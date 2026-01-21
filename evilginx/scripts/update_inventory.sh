#!/bin/bash

# --- Dynamic Path Resolution ---
# This finds the 'evilginx' root folder regardless of where you run the script from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# --- Configuration ---
# Terraform is in the terraform/ folder relative to root
TF_DIR="$PROJECT_ROOT/terraform"
# Inventory is in the ansible/ folder relative to root
INVENTORY_FILE="$PROJECT_ROOT/ansible/inventory_evilginx.ini"
# Absolute path to the PEM key
KEY_PATH="$(readlink -f "$PROJECT_ROOT/terraform/evilginx_key.pem")"

# --- Dependency Check ---
if ! command -v terraform &> /dev/null; then
    echo "Error: 'terraform' is not installed or not in PATH."
    exit 1
fi

echo "--- 🔎 Querying AWS Instances via Terraform ---"

# Use -chdir to point to the terraform directory
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
    DNS=$(terraform -chdir="$TF_DIR" state show "$inst" | grep "public_dns" | head -n 1 | awk -F'=' '{print $2}' | tr -d ' "')
    NAME=$(terraform -chdir="$TF_DIR" state show "$inst" | grep -A 5 "tags" | grep "Name" | awk -F'=' '{print $2}' | tr -d ' "')

    if [ -z "$DNS" ] || [ "$DNS" == "null" ]; then
        DNS=$(terraform -chdir="$TF_DIR" state show "$inst" | grep "public_ip" | head -n 1 | awk -F'=' '{print $2}' | tr -d ' "')
    fi

    [ -z "$NAME" ] && NAME="Unknown-Instance"

    echo "  [$i] $NAME -> $DNS"
    DNS_MAP[$i]=$DNS
    NAME_MAP[$i]=$NAME
    i=$((i+1))
done
echo "--------------------"

read -rp "Enter the number of the target machine: " SELECTION
TARGET_DNS=${DNS_MAP[$SELECTION]}

if [ -z "$TARGET_DNS" ]; then
    echo "❌ Invalid selection. Exiting."
    exit 1
fi

SG_ID=$(terraform -chdir="$TF_DIR" output -raw security_group_id 2>/dev/null || echo "sg-0f5029e47217fa1a8")

# --- Update the INI File ---
echo "--- 📝 Updating $INVENTORY_FILE ---"

cat <<EOF > "$INVENTORY_FILE"
[ec2_setup]
ec2_target ansible_host=$TARGET_DNS ansible_user=ubuntu ansible_private_key_file=$KEY_PATH

[all:vars]
security_group_id=$SG_ID
EOF

chmod 400 "$KEY_PATH"

echo "✅ Success! Inventory updated for: ${NAME_MAP[$SELECTION]}"
echo "Host Address: ubuntu@$TARGET_DNS"
echo ""

# --- The Final Command (Updated Path) ---
echo "--- 🚀 Run your playbook with this command ---"
echo "cd $PROJECT_ROOT/ansible && ansible-playbook setup_evilginx.yml -i inventory_evilginx.ini"
echo ""
