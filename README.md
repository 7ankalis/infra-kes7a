# 🎭  Infra Kes7a

[![Status: Development](https://img.shields.io/badge/Status-In--Development-orange?style=flat-square&logo=terraform)](https://github.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](https://github.com/)
[![Stack: Hybrid Cloud C2](https://img.shields.io/badge/Stack-IaC%20%2F%20Red%20Team-lightgrey?style=flat-square&logo=linux)](https://www.terraform.io/)

> **"Advanced persistent threats aren't built on single servers; they are built on resilient ecosystems."**

## 🔑 Operational Rationale

Standard security training often emphasizes attacking from a single, static VM. In a modern enterprise environment, this is a recipe for immediate detection and attribution. **Infra Kes7a** was engineered to simulate true Tier-1 adversary tradecraft by moving away from centralized infrastructure.

This project implements a multi-layered, hybrid-cloud architecture that separates internal command logic from public-facing collection points, ensuring that the discovery of a single component does not compromise the entire operation.

## 💎 Technical Objectives

- **Infrastructure Survivability:** Implementing a "Burn & Rebuild" cycle where redirectors can be rotated in minutes without losing C2 sessions.
- **Traffic Obfuscation:** Utilizing Layer 7 Nginx filtering and CDN masking to blend C2 heartbeats with legitimate enterprise web traffic.
- **Backend Isolation:** Establishing a secure WireGuard-based "Operations Network" where the Team Server remains entirely hidden from the public internet.
- **Automated Provisioning:** Using Terraform and Ansible to eliminate manual configuration errors and "infrastructure fingerprinting."

---

## 🏗️ Architectural Comparison

| Feature | Standard "Lab" Setup | Infra Kes7a |
| :--- | :--- | :--- |
| **Exposure** | Core IP is public and easily scanned. | Core is isolated behind a private VPN tunnel. |
| **Response** | Blue Team blocks the IP; session dies. | Traffic is redirected to a benign decoy. |
| **Deployment** | Manual setup (Slow/Error-prone). | Fully automated via IaC (Terraform). |
| **Segmentation** | Single domain for all stages. | Tiered domains (Phishing vs. Persistence vs. Exfil). |

---

## 🛠️ The Tech Stack

* **Orchestration:** Terraform (Provisioning), Ansible (Configuration), Cloud-init.
* **Initial Access:** Evilginx (MFA Bypass) & GoPhish (Isolated Stage 0).
* **C2 Frameworks:** Support for Mythic, Havoc, or Sliver via internal Nginx Collectors.
* **Network Layer:** WireGuard (Encrypted Tunneling), Nginx (Reverse Proxy & Filtering).
* **Cloud Providers:** Redundant deployment across AWS, Azure, and DigitalOcean.

---

## 🧠 Infrastructure Layers

### 1. The Internal Operations Network (The Brain)
The Team Server sits in a private environment with no direct internet access. It communicates only with an **Internal Nginx Collector** which acts as a traffic switchboard, routing data between different engagement stages.

### 2. Front-End Bastions (The Redirectors)
Public-facing VPS instances acting as Layer 4/7 redirectors. These servers perform header validation; if a request does not contain the "Secret Key" defined in the Malleable C2 profile, the traffic is dropped or sent to a decoy site to mislead defenders.

### 3. Active Deception (The Decoy)
Each redirector is paired with a high-reputation "Front" site. This ensures that passive scanners or Blue Team investigators see a legitimate business entity (e.g., a Healthcare blog or Finance portal) rather than an empty server or a default Nginx page.

### 4. Automated Persistence
By utilizing Infrastructure as Code (IaC), the operator can "Burn" a compromised domain or IP address and "Resurrect" the infrastructure in a different cloud region with a single command, maintaining operational momentum.

---

## 📂 Project Structure

```text
.
├── core_ops            # Backend: Team Server & Internal Collector logic
├── redirectors         # Front-End: Nginx, WireGuard, and L7 filtering automation
├── phishing            # Stage 0: Infrastructure for delivery and credential harvesting
├── terraform           # IaC modules for multi-cloud provisioning
└── docs                # Operational methodology and OPSEC guidelines
```

---

### Next Step for you:
Would you like me to provide the **Terraform main.tf** file to automatically spin up your first Cloud Redirector and link it to your local machine?
