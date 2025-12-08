#!/bin/bash

# --- Configuration ---
TF_DIR="./terraform"
INVENTORY_FILE="./ansible/inventory_evilginx.ini"

# The key file (evilginx_key.pem) is generated in the root directory (where the script runs).
# The inventory file is in ./ansible/.
# Therefore, the path from the inventory to the key is '../evilginx_key.pem'.
KEY_FILE_PATH_FOR_ANSIBLE="./terraform/evilginx_key.pem"

# --- Function to check dependencies ---
check_deps() {
    if ! command -v terraform &> /dev/null; then
        echo "Error: 'terraform' command not found. Please ensure Terraform is installed and in your PATH."
        exit 1
    fi
}

# --- Function to get and display EC2 instances ---
# This function will now populate the global INSTANCE_MAP array.
get_ec2_instances() {
    echo "--- 🔎 Checking for deployed EC2 instances in Terraform State ---"

    # Initialize Terraform to ensure the state is accessible
    terraform -chdir="$TF_DIR" init -no-color > /dev/null 2>&1

    # Use terraform state list to find all aws_instance resources
    INSTANCES=$(terraform -chdir="$TF_DIR" state list -no-color | grep 'aws_instance')

    if [ -z "$INSTANCES" ]; then
        echo "No 'aws_instance' resources found in the current Terraform state."
        exit 0
    fi

    i=1
    echo ""
    echo "Available Instances:"
    echo "--------------------"

    for instance in $INSTANCES; do
        STATE_OUTPUT=$(terraform -chdir="$TF_DIR" state show -no-color "$instance")

        NAME=$(echo "$STATE_OUTPUT" | awk '/^ *Name *=/ {print $3}' | sed 's/"//g')
        DNS=$(echo "$STATE_OUTPUT" | awk '/^ *public_dns *=/ {print $3}' | sed 's/"//g')

        # If DNS empty, fallback to public IP
        if [ -z "$DNS" ] || [[ "$DNS" == "(known" ]] || [[ "$DNS" == "null" ]]; then
            IP=$(echo "$STATE_OUTPUT" | awk '/^ *public_ip *=/ {print $3}' | sed 's/"//g')
            DNS=$IP
        fi

        echo "  [$i] Name: $NAME, Address: $DNS"
        INSTANCE_MAP[$i]="$DNS"
        i=$((i+1))
    done

    echo ""
    echo "--------------------"
    return 0
}

# --- Main script logic ---

check_deps

# Global associative array for instance mapping
declare -A INSTANCE_MAP

# 1. List EC2 instances
get_ec2_instances

# 2. Ask user for selection
read -rp "Enter the number of the target machine to update inventory for: " SELECTION
SELECTION=$(echo "$SELECTION" | tr -d '\r')

# 3. Validate input
if ! [[ "$SELECTION" =~ ^[0-9]+$ ]] || [ "$SELECTION" -lt 1 ] || [ -z "${INSTANCE_MAP[$SELECTION]}" ]; then
    echo "Error: Invalid selection number. Please enter a valid number from the list."
    exit 1
fi

# 4. Selected address
TARGET_ADDRESS="${INSTANCE_MAP[$SELECTION]}"

# 5. Get security group ID
SG_ID=$(terraform -chdir="$TF_DIR" output -raw security_group_id 2>/dev/null || echo "sg-0f5029e47217fa1a8")

# 6. Update the Ansible Inventory
echo "--- 📝 Updating $INVENTORY_FILE ---"
NEW_INVENTORY="[ec2_setup]\nec2_target ansible_host=$TARGET_ADDRESS ansible_user=ubuntu ansible_private_key_file=$KEY_FILE_PATH_FOR_ANSIBLE\n\n[all:vars]\nsecurity_group_id=$SG_ID"

echo -e "$NEW_INVENTORY" > "$INVENTORY_FILE"

echo "✅ Inventory updated successfully for ec2_target!"
echo "   New Target Address: $TARGET_ADDRESS"
echo "   Ansible will use key: $KEY_FILE_PATH_FOR_ANSIBLE"
echo ""

echo "--- Next Step ---"
echo "You can now run your Ansible playbook:"
echo "ansible-playbook ansible/setup_evilginx.yml -i $INVENTORY_FILE"

# --- NEW: Print SSH connection command ---
echo ""
echo "--- SSH Connection ---"
echo "Connect using:"
echo "ssh -i ./terraform/evilginx_key.pem ubuntu@$TARGET_ADDRESS"

