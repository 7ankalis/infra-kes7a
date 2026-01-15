# Automated C2 Server Infrastructure Deployment

This directory contains the automation code for deploying a base Command and Control (C2) server on AWS. It uses a combination of Terraform for the infrastructure and Ansible for the initial software setup and configuration.

> Although this is crafted for a single C2 EC2 instance, the logic is highly adaptable. It can be easily modified for different cloud providers, a larger number of VMs, or more complex networking rules. The update script can be fine-tuned as necessary.

## File Overview

### terraform/

These files manage the AWS resources. Instead of hardcoding details like AMI IDs, they are designed to be dynamic, for instance by looking up the latest official Ubuntu images.

*   **main.tf**: Defines the core resources: the EC2 server instance, a new SSH keypair, and the security group.
*   **outputs.tf**: Displays the server's public IP/DNS and provides a ready-to-use SSH connection command after the deployment is finished.
*   **variables.tf**: Contains configurable parameters like the instance type and disk size.
*   **versions.tf**: Locks the required versions for the Terraform providers (AWS, TLS, etc.) to ensure consistent builds.
*   **Security Group**: The setup creates a minimalist firewall named `c2-firewall`. By design, it **only opens port 22 for SSH access**, ensuring a minimal initial attack surface.

### ansible/

Once the server is running, these files handle the software configuration.

*   **setup_c2.yml**: A playbook that runs after the server is built. It updates the system and installs a set of essential productivity tools like `btop`, `net-tools`, `build-essential`, `bat`, and `git`.
*   **update_inventory.sh**: A helper script designed to be run locally. It reads the current public DNS from your AWS state file and automatically updates the Ansible inventory, saving you from manually copying and pasting IP addresses.
*   **inventory_c2.ini**: The Ansible inventory file that is automatically populated by the `update_inventory.sh` script.

**IMPORTANT:** When you connect to the server for the first time via SSH, your local machine will save its host key fingerprint. Ansible uses the same SSH mechanism, so if you ever rebuild the server (getting a new IP/DNS but the same name in your inventory), you might see a "REMOTE HOST IDENTIFICATION HAS CHANGED" error. You would need to remove the old key from your `~/.ssh/known_hosts` file to resolve this.

## Deployment Workflow

1.  Navigate to the `terraform/` directory. Initialize the project, check the plan, and apply it.
    ```bash
    cd terraform
    terraform init
    terraform plan
    terraform apply
    ```

2.  Move to the `ansible/` directory and run the inventory update script. It will find your new server and ask you to confirm which one you want to configure.
    ```bash
    cd ../ansible
    bash ./update_inventory.sh
    ```
3.  Select your instance from the list (there will likely be only one). The script will then generate the final command you need to run to configure the server.
    
    ```bash
    ansible-playbook setup_c2.yml -i inventory_c2.ini
    ```

After these steps, you will see a single EC2 instance named `c2_server` and a security group named `c2-firewall` in your AWS dashboard. The server will be ready for you to log in and install your specific C2 framework.
