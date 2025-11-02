# 🗺️ Project Walkthrough: From Intel to Emulation

This document outlines the four main phases of the operation, ensuring that the infrastructure is built only after the required intelligence is gathered.

---

## Phase 1: Planning and Threat Intelligence

The focus here is defining the "WHY" and the "WHAT" before touching the "HOW."

| Step | Goal & Output | Tools/Concepts |
| :--- | :--- | :--- |
| **1.1. Adversary Selection** | Choose the specific **APT Group** (e.g., APT41, FIN7) and map their TTPs (Tactics, Techniques, Procedures) to **MITRE ATT&CK**. | Threat Intelligence Reports, MITRE ATT&CK Framework. |
| **1.2. Malleable Profile Design** | Create a C2 profile that visually and statistically emulates the chosen APT's network traffic. Define the secret header that will be used for filtering. | `Cobalt Strike .profile`, `Mythic Config`, Traffic Analyzers. |
| **1.3. Pretext Development** | Establish the cover story for the domains and network traffic (e.g., "Legitimate Cloud Storage API," "Internal Update Server"). | Domain Categorization Checkers, Clean Domains. |

---

## Phase 2: Infrastructure as Code (IaC) Development

This phase focuses on automated deployment and configuration for high resilience.

| Step | Detail & Output | Technology Used |
| :--- | :--- | :--- |
| **2.1. Provisioning (Terraform)** | Write HCL files to spin up all virtual machines (Core, Redirectors, Delivery, Decoy) across one or more cloud providers. | `Terraform` (HCL). |
| **2.2. Zero Trust Core Hardening (Ansible)** | Deploy the Ansible Playbook to the **C2 Core (D)**. This configures the firewall to **only allow SSH access from the operator's public IP** and **only allow C2 traffic from Redirector IPs (C)**. | `Ansible` (UFW/iptables modules). |
| **2.3. Redirector Deployment (Ansible)** | Deploy the Ansible Playbook to the **Redirectors (C)**. This installs `Nginx`, configures SSL/TLS, and injects the **Header-Based Evasion Logic**. | `Ansible` (Nginx modules, TLS certs). |

---

## Phase 3: Verification and OPSEC Test (Go/No-Go)

This phase ensures the C2 infrastructure is perfectly stealthy before the operation begins.

* **Test 1 (Scanner Emulation):** Attempt to connect to the Redirector's IP/Domain from an external, non-whitelisted machine **without** the secret C2 header.
    * **Expected Result:** Connection is accepted, serves the benign **Decoy Page (E)**, and triggers an alert in the Decoy logs. The **C2 Core (D)** sees zero traffic.
* **Test 2 (Implant Emulation):** Run a test connection using the full, correctly formatted C2 beacon (with the secret header and Malleable Profile).
    * **Expected Result:** The connection is successfully routed through the Redirector (C) and accepted by the **C2 Core (D)**.

---

## Phase 4: Adversary Emulation Execution

The operation is now live, focused on TTP execution.

| Step | Detail & Focus | OPSEC Considerations |
| :--- | :--- | :--- |
| **4.1. Initial Compromise** | Execute the TTPs for gaining initial access (e.g., Phishing, Web App Exploit) using the **Delivery Front (B)**. | **Monitor logs on B** closely. If it's burned, destroy and redeploy only Layer B. |
| **4.2. Post-Exploitation TTPs** | Use the C2 implant to perform lateral movement, privilege escalation, and data collection, strictly following the selected **APT TTPs**. | Maintain a low and slow beacon rate; use process injection and evasion TTPs defined by the APT. |
| **4.3. Incident Handling Test** | Monitor the Blue Team's response. If a Redirector is blocked or logged, immediately trigger the **Terraform destroy/apply** for that component to rotate the IP/Domain. | **Prioritize OPSEC over speed.** When compromised, destroy. |
