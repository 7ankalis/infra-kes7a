#!/bin/bash

# --- Configuration ---
# Script is in 'ansible/', terraform is one level up
TF_DIR="../terraform"
INVENTORY_FILE="./inventory_evilginx.ini"
# Ensure we have the absolute path to the key for Ansible
KEY_PATH="$(readlink -f ../terraform/evilginx_key.pem)"

# --- Dependency Check ---
if ! command -v terraform &> /dev/null; then
    echo "Error: 'terraform' is not installed or not in PATH."
    exit 1
fi

echo "--- 🔎 Querying AWS Instances via Terraform ---"

# Get list of instance resource names from the state file
mapfile -t INSTANCE_RESOURCES < <(terraform -chdir="$TF_DIR" state list | grep 'aws_instance')

if [ ${#INSTANCE_RESOURCES[@]} -eq 0 ]; then
    echo "❌ No instances found. Please run 'terraform apply' first."
    exit 1
fi

declare -A DNS_MAP
declare -A NAME_MAP

echo ""
echo "Available Instances:"
echo "--------------------"

i=1
for inst in "${INSTANCE_RESOURCES[@]}"; do
    # Fetch Public DNS and Name Tag
    DNS=$(terraform -chdir="$TF_DIR" state show "$inst" | grep "public_dns" | head -n 1 | awk -F'=' '{print $2}' | tr -d ' "')
    NAME=$(terraform -chdir="$TF_DIR" state show "$inst" | grep -A 5 "tags" | grep "Name" | awk -F'=' '{print $2}' | tr -d ' "')

    # Fallback to IP if DNS is not yet propagated
    if [ -z "$DNS" ] || [ "$DNS" == "null" ]; then
        DNS=$(terraform -chdir="$TF_DIR" state show "$inst" | grep "public_ip" | head -n 1 | awk -F'=' '{print $2}' | tr -d ' "')
    fi

    # Fallback for Name tag
    [ -z "$NAME" ] && NAME="Unknown-Instance"

    echo "  [$i] $NAME -> $DNS"
    DNS_MAP[$i]=$DNS
    NAME_MAP[$i]=$NAME
    i=$((i+1))
done
echo "--------------------"

# --- User Input ---
read -rp "Enter the number of the target machine: " SELECTION

TARGET_DNS=${DNS_MAP[$SELECTION]}

if [ -z "$TARGET_DNS" ]; then
    echo "❌ Invalid selection. Exiting."
    exit 1
fi

# --- Get Security Group ID from Terraform ---
SG_ID=$(terraform -chdir="$TF_DIR" output -raw security_group_id 2>/dev/null || echo "sg-0f5029e47217fa1a8")

# --- Update the INI File ---
echo "--- 📝 Updating $INVENTORY_FILE ---"

cat <<EOF > "$INVENTORY_FILE"
[ec2_setup]
ec2_target ansible_host=$TARGET_DNS ansible_user=ubuntu ansible_private_key_file=$KEY_PATH

[all:vars]
security_group_id=$SG_ID
EOF

# Ensure key permissions are correct for SSH
chmod 400 "$KEY_PATH"

echo "✅ Success! Inventory updated for: ${NAME_MAP[$SELECTION]}"
echo "Host Address: ubuntu@$TARGET_DNS"
echo ""

# --- The Final Command ---
echo "--- 🚀 Run your playbook with this command ---"
echo "ansible-playbook setup_evilginx.yml -i inventory_evilginx.ini"
echo ""