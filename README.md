#  Infra Kes7a
## Project Overview

This repository contains the Infrastructure-as-Code (IaC) and configuration files for deploying a **multi-layered, OPSEC-hardened Command and Control (C2) infrastructure**. The primary goal is to provide a highly resilient and disposable platform capable of safely conducting advanced adversary emulation (APT simulation) against mature defensive teams.

---

## 💡 Reason Behind Building This Infrastructure  

It came to my mind once: Why are there this amount of C2 IPs ina single report on a signle compaign on a single target?  

Turns out that after some research, APTs have a much bigger infrastructure than I thought: It's not a regular VM from which they attack as it is the case in CTFs. (Something I should've known earlier lol).

This project was built to address the following problems:

1.  **High OPSEC Risk:** Minimize the risk of exposing the high-value **Primary C2 Server** to Blue Team detection, forensic analysis, or automated scanner activity.
2.  **Lack of Resilience:** Create a network that can sustain losses (e.g., a Redirector or Phishing server getting blocked) without compromising the entire operation, allowing for **rapid, automated replacement** of compromised components.
3.  This will serve me enormously since now I can author full scope DFIR CTF challenges with much better interactivity and all. 😬
4.  Most importantly, my agony? Because I deserve it? Let's hope this keeps me busy 🫩.

---

## ✅ Reasons to Choose This Infrastructure

This architecture moves beyond simple port forwarding and utilizes **advanced network filtering** and **automation** to achieve superior stealth and resilience.

| Feature | Traditional C2 Architecture | Resilient APT Infrastructure |
| :--- | :--- | :--- |
| **Exposure** | C2 Core IP is one hop away. | C2 Core is **firewalled**; only communicates with trusted Redirectors. |
| **OPSEC Failure**| Blue Team hitting the redirector reveals C2 behavior (404/no content).| Blue Team is routed to a **Decoy/Canary Trap**, logging an alert and masking the C2 presence. |
| **Sustainability**| Manual spin-up and tear-down; slow to respond to compromise. | **Fully automated** deployment/destruction via **Terraform**; allows for immediate rotation. |
| **Reputation**| Phishing/delivery and C2 use the same IP space/reputation. | **Layered Segregation:** High-risk delivery components are isolated from the stealthy C2 fronting layer. |

---

## 🚀 What You'll Gain After Learning This Infrastructure

Mastering this architecture and the associated tooling will elevate your operational tradecraft significantly. You will gain expertise in:

* **Adversary Tradecraft:** Implementing real-world defensive evasion TTPs used by sophisticated APT groups.
* **Infrastructure as Code (IaC):** Proficiency in using **Terraform** and **Ansible** to manage complex, disposable multi-host environments.
* **Network Filtering Mastery:** Deep understanding of **Nginx reverse proxying, header inspection, and conditional traffic routing** for stealth operations.
* **Proactive OPSEC:** Implementing **Canary Traps** and automated logging to establish a continuous feedback loop that alerts you *before* the Blue Team can burn your entire environment.
* **Full-Spectrum Testing:** The capability to deploy and validate infrastructure tailored for full-scale **Adversary Emulation** engagements.

---

## 🔑 The Main and Key Features of This Infrastructure

This infrastructure is defined by its four distinct, segregated layers:

### 1. **Zero Trust C2 Core Hardening (Layer D)**
* The primary C2 server is protected by an **Ansible-managed iptables/UFW firewall**.
* It operates on a **Deny-All** principle, accepting connections **only** from the whitelisted IP addresses of the C2 Redirectors and the Operator's specific management IP.

### 2. **Header-Based Evasion Logic (Layer C)**
* **Nginx Redirectors** perform Layer 7 filtering based on the HTTP User-Agent and/or a custom header secret defined in the Malleable C2 Profile.
* The Redirectors use a custom Nginx configuration to make the routing decision dynamically.

### 3. **The Decoy/Canary Trap (Layer E)**
* Any incoming request to the Redirector that **fails** the Evasion Logic check is immediately diverted to a benign Decoy webpage.
* This connection triggers a **high-priority log alert** to the operator, confirming that defensive scanning or manual Blue Team inspection is occurring.

### 4. **Automated, Disposable Architecture (Layer A)**
* The entire front-end infrastructure (Redirectors, Payload, Mail) can be provisioned and destroyed with a single command (`terraform apply/destroy`).
* This enables the Red Team to **"Burn and Rebuild"** an entire C2 chain in minutes when compromise is suspected.

---

## 🛠️ Usages for This Infrastructure

* **Advanced Red Team Assessments:** Conducting long-term, high-fidelity operations against mature security programs (SOC/MDR).
* **Adversary Emulation Exercises:** Simulating the specific TTPs and C2 protocols of known threat actors (e.g., APT29, FIN7) with minimal risk of exposing the core team server.
* **Purple Team Testing:** Providing a highly realistic infrastructure target against which the Blue Team can test and fine-tune their **Network Detection and Response (NDR)** rules and C2 hunting procedures.
* **Security Research:** Safely testing new C2 profiles, stealth techniques, and payload delivery methods in an environment designed for rapid iteration and logging.
