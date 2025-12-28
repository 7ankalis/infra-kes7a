# 🎭 Project Hydra: Infra Kes7a (Ghost Protocol)

[![State: Under Development](https://img.shields.io/badge/Status-Cooking..-orange?style=for-the-badge&logo=fastapi)](https://github.com/)
[![Vibe: Main Character Energy](https://img.shields.io/badge/Vibe-No%20Cap-blueviolet?style=for-the-badge)](https://github.com/)
[![Tech: Terraform/Ansible](https://img.shields.io/badge/Stack-IaC%20%2F%20C2-blue?style=for-the-badge&logo=terraform)](https://www.terraform.io/)

> **"Stop getting burned by Blue Teams. If they cut off one head, two more take its place."**

## 💡 The Tea (Why I built this)

Let’s be real: Most CTF labs are "delulu." They teach you to attack from a single VM, which is basically asking to get clapped in a real-world engagement. After digging into how actual APTs move, I realized their infra isn't a server—it's an **ecosystem**.

I built **Infra Kes7a** because I wanted to move away from "script kiddie" networking and level up to **Main Character** tradecraft. This project is for when you want your C2 to be as resilient as your intrusive thoughts. 

Also, I wanted to build DFIR challenges that actually make people sweat. 😬

---

## 💅 Why This Infra Slays (Comparison)

Standard C2 is mid. This is elite.

| Feature | The "Mid" Setup | The Hydra Setup (This Repo) |
| :--- | :--- | :--- |
| **Visibility** | Core IP is exposed. RIP. | Core is **Ghosted** behind a Zero-Trust firewall. |
| **Vibe Check** | Blue Team hits a 404. Suspicious. | Blue Team hits a **Decoy**. You get a ping. They get nothing. |
| **Sustainability** | Manual rebuilds (Cringe). | **Automated** "Burn & Rebuild" via Terraform. |
| **Reputation** | One IP for everything. Easy block. | **Layered Segregation.** Clean IPs for C2; dirty IPs for the Phish. |

---

## 🛠️ The Tech Stack

* **Automation:** Terraform & Ansible (The "Do It For Me" duo)
* **Initial Access:** Evilginx (MFA Bypass) & Gophish
* **C2:** Mythic C2 (High-fidelity stealth)
* **Logic:** Nginx (Custom Header Evasion)
* **Recon:** DNSTwist (Homograph domain magic)

---

## 🧠 The "Layers" (How it works)

### 1. **Zero Trust Core (Layer D)**
The Brain. Managed by Ansible. It doesn't talk to strangers. It only accepts connections from the Redirectors. It's strictly "invite-only."

### 2. **The Secret Handshake (Layer C)**
Nginx Redirectors doing the absolute most. They check for a **Secret Header** in the traffic. 
* **Have the key?** You're in.
* **No key?** Get redirected to a boring decoy site.

### 3. **The Canary Trap (Layer E)**
This is the "Find Out" part of "Fuck Around." If someone probes the redirector without the key, a high-priority alert is triggered. You'll know the Blue Team is looking at you before they even finish their coffee.

### 4. **Disposable Everything (Layer A)**
"Burn and Rebuild." Suspect a compromise? One command destroys the evidence and spins up a fresh head with a new IP. Persistence, but make it ✨automated✨.

---

## 📂 Project Structure (Current Progress)

```text
.
├── docs                # The receipts (Architecture, Methodology, etc.)
├── evilginx            # MFA Bypass setup (The Phishlets live here)
│   ├── ansible         # Config for the proxy
│   └── terraform       # Infra for the attack node
├── overview            # The "Big Brain" PDFs (EN/FR)
└── README.md           # You are here (The vibe check)
