# 📚 Terminology and Concepts

## Red Team & Adversary Terms

| Term | Category | Definition |
| :--- | :--- | :--- |
| **APT** | Adversary | Advanced Persistent Threat. A sophisticated, long-term threat actor. |
| **TTPs** | Methodology | Tactics, Techniques, and Procedures. The specific *how* an APT conducts an attack. |
| **OPSEC** | Operational | Operational Security. The practice of protecting one's operations from detection. |
| **C2** | Infrastructure | Command and Control. The communication channel for managing compromised hosts. |
| **Beacon** | Infrastructure | The regular callback communication from the implant to the C2 server. |
| **Malleable C2** | Infrastructure | A profile that customizes C2 traffic to mimic benign applications or protocols. |
| **Implant/Agent**| Payload | The executable code deployed on the target machine that connects to the C2. |
| **Decoy/Canary** | OPSEC | A resource designed to trap scanners and log suspicious, non-C2 activity. |
| **Red Team** | Role | The offensive team simulating an adversary to test an organization's defenses. |
| **Blue Team** | Role | The defensive team responsible for detection, analysis, and response. |

---

## Infrastructure as Code (IaC) & Tooling

| Term | Technology | Definition |
| :--- | :--- | :--- |
| **IaC** | Concept | Infrastructure as Code. Managing and provisioning infrastructure through code. |
| **Terraform** | IaC Tool | Used for **Provisioning** (creating, updating, and destroying) the cloud resources. |
| **Ansible** | IaC Tool | Used for **Configuration Management** (installing Nginx, hardening the firewall, setting up users). |
| **HCL** | Language | HashiCorp Configuration Language. The language used by Terraform. |
| **Reverse Proxy**| Networking | A server that sits in front of another server and forwards client requests to it, masking the true origin. (Used by our Nginx Redirectors). |
| **iptables/UFW** | OS Hardening | Linux firewall utilities used by Ansible to enforce the Zero Trust firewall rules on the C2 Core. |
