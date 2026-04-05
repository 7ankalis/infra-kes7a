# Infra Kes7a

[![Status: Development](https://img.shields.io/badge/Status-In--Development-orange?style=flat-square&logo=terraform)](https://github.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](https://github.com/)
[![Stack: Hybrid Cloud C2](https://img.shields.io/badge/Stack-IaC%20%2F%20Red%20Team-lightgrey?style=flat-square&logo=linux)](https://www.terraform.io/)

> **"Advanced persistent threats aren't built on single servers; they are built on resilient ecosystems."**


<p align="center">
  <img src="assets/final-c2.png" alt="Operational Overview of the C2 infrastructure."><br>
  <em>Operational Overview of the C2 infrastructure.</em>
</p>



## Why I built this 

Let’s be real: Most CTF labs train us to get clapped in a real-world engagement. Attacking from a single VM, extensive unlimited probing, and much more; as delulu as can be. After digging into how actual APTs move, I realized their infra is a whole ecosystem not just a centralized server or whatsoever with closed ports or whatsoever.
So I built **Infra Kes7a** in an attempt to move away from script kiddie networking and feed my **Main Character Syndrome**.

![](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExZW12ZzZmaWY4OHJyMnN5ZzE2cnlwZmhicDNhY3gzbXZnNXkxZXJwaSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/G1vplGMypxBcp7kx32/giphy.gif)

##  Bring Your Own APT Lab: What this infrastructure can be used for

Of course, Red Team engagements. But not only that.

### **APT Simulation & Emulation**

Simply put, Infra Kes7a provides a realistic, multi-tier environment around APT simulation so that Blue Teams can test detection engineering against techniques like CDN masking and cross-cloud redirection. So, BYOAL

![](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNzcxbGQ0eWV4aWRlamZ6YmFxY2J4bmxxcWE5cmU4MWFxN3MycjNpbiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/htAMDLwwR1VSl4DG5Q/giphy.gif)

### **Adversary Emulation (Purple Teaming)**
The framework could be seen as a consistent, repeatable lab for Purple Team exercises. It enables security teams to validate the effectiveness of their solutions against multi-stage threat.

### **More fun and reallistic DFIR challenges**

I know how tiring DFIR challenges can be and how it takes too much time when we're authoring a task replicating a multi-layer attack. So here's an automated way to build high fidelity challenges.

## Key Takeways  

This project is for when you want to learn more about:
- How APTs maintain persistence at the infrastructure level (not the local persistence via implants and all).

- How spear phishing is crafted and how hard it can get to spot. 

- Building and connecting cloud resources from different providers.

- How L3 firewalls operate and see them in action.

- What IaS is through automating the process of building, configuring, running and tearing down the infrastructure.


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

* **Orchestration:** Terraform (Provisioning), Ansible (Configuration).
* **Initial Access:** Evilginx (MFA Bypass) & GoPhish (Isolated Stage 0).
* **C2 Frameworks:** Mythic, Havoc, Sliver or whatever.
* **Network Layer:** WireGuard (Encrypted Tunneling), Nginx (Reverse Proxy & Filtering).
* **Cloud Providers:** Redundant deployment across AWS, Azure, and DigitalOcean.

---

## 🧠 The "Layers"



### 1. **The Brain : The C2 server**  



- Doesn't talk to strangers

- It only accepts connections from the Redirectors/LBs and operators IPs.

- It's strictly "invite-only" via sessions for each operator.

- Behind Layers of security and deception. 



### 2. **The Secret Handshake**

Nginx Redirectors doing the absolute most. They check for a **Secret Header** in the traffic. 

* **Got the key?** Let the data in.

* **No key?** Cute, nice try. Redirect to the honeypot (still deciding).



### 3. **The Buffoon (The Deception)**

This is the "Find Out" part of "Fuck Around." If someone does what you want them to do, analyze and probe your decoy for example, a high-priority alert is triggered, logged and monitored. Which results in us receiving much more intel on how the Blue Team operates and how their tools work without efforts.



### 4. **The Resurrection**

"Burn and Rebuild." Suspect a compromise? One command destroys the evidence and spins up a fresh head with a new IP. Persistence, but make it ✨automated✨. Yayyy!



---



## 📂 Project Structure (Current Progress)



```text

.

├── docs                # The receipts (Resources, Methodology, Terminology etc.)

├── evilginx            # 

│   ├── ansible         # Inventory files for corresponding service (evilginx in this case)

│   └── terraform       # Terraform files for the corresponponding service (evilginx in this case)

├── overview            # The AI-Generated v0 PDFs (EN/FR).

└── README.md           # You are here (vibe check)
