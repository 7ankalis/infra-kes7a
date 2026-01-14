# Evilginx Infrastructure Module

This directory contains the automation code for deploying an Evilginx instance on AWS. It uses a combination of Terraform for the hardware and Ansible for the software setup.

>Although this is crafted for a single evilginx EC2 instance, the logic still applies even if we change the cloud provider, the number of VMs or security groups or whatever. Fine tune the updating script as necessary.
## File Overview

### terraform/
These files manage the AWS resources. Instead of hardcoding details, they look up the latest Ubuntu images dynamically.
- **main.tf**: Defines the server and the networking.
- **outputs.tf**: Displays the IP and connection commands after the build is finished. With both occasions to login with full DNS or with IP (Not the same).
- **Security Group**: The setup creates a firewall named `evilginx-firewall`. It opens ports 80 and 443 for web traffic, port 22 for SSH, and port 53 (UDP) for DNS management (these are crucial).

### ansible/
Once the server is running, these files handle the configuration.
- **setup_evilginx.yml**: A playbook that installs the required packages and the Evilginx environment.
- **update_inventory.sh**: A script designed to be run locally. It pulls the current DNS names from your AWS state and updates the Ansible inventory file so you don't have to copy-paste IPs manually.

**IMPORTANT:** If you logged in for the first time using the full DNS of the EC2 you should do the same when using the Ansible playook. Otherwise, it'll error out due to invalid fingerprinting.  

### phishlets/
This is a storage folder for your configuration files (like `kedux.yaml`). The Ansible playbook is configured to look here when deploying files to the remote server.

## Deployment Workflow

1. Navigate to the terraform directory and run the `terraform fmt`, `terraform init`, `terraform validate`, `terraform plan`, `terraform apply`.
2. Move to the ansible directory and run `./update_inventory.sh`. This should show your deployed instances and asks for which one you're planning to install the playbook on.
3. Select your instance (in my case a single EC2) and run the `ansible-playbook` command the script generates.

In your AWS dashboard, you will see a single EC2 instance and a security group configured with the ports necessary for DNS and web traffic.  

