# 🎭 Project Hydra: Infra Kes7a (Ghost Protocol)

[![State: Under Development](https://img.shields.io/badge/Status-Cooking..-orange?style=for-the-badge&logo=fastapi)](https://github.com/)
[![Vibe: Main Character Energy](https://img.shields.io/badge/Vibe-No%20Cap-blueviolet?style=for-the-badge)](https://github.com/)
[![Tech: Terraform/Ansible](https://img.shields.io/badge/Stack-IaC%20%2F%20C2-blue?style=for-the-badge&logo=terraform)](https://www.terraform.io/)

> **"Imagine a Quote on evading the Blue Team."**

## 🔑 Why I built this 

Let’s be real: Most CTF labs train us to get clapped in a real-world engagement. Attacking from a single VM, extensive unlimited probing, and much more; as delulu as can be. After digging into how actual APTs move, I realized their infra is a whole ecosystem not just a centralized server or whatsoever with closed ports or whatsoever.

So I built **Infra Kes7a** in an attempt to move away from script kiddie networking and feed my **MCS**.

![](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExZW12ZzZmaWY4OHJyMnN5ZzE2cnlwZmhicDNhY3gzbXZnNXkxZXJwaSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/G1vplGMypxBcp7kx32/giphy.gif)

## 💎 Key Takeways  

This project is for when you want to learn more about:

- How APTs maintain persistence at the infrastructure level (not the local persistence via implants and all).
- How spear phishing is crafted and how hard it can get to spot. 
- Building and connecting cloud resources from different providers.
- How L3 firewalls operate and see them in action.
- What IaS is through automating the process of building, configuring, running and tearing down the infrastructure.
  
  And Much more. 😉

---

## 💅 Why This Infra Slays (Comparison)

Standard C2 is mid. This is elite.

| Feature | The "Mid" Setup | Infra Kes7a |
| :--- | :--- | :--- |
| **Visibility** | Core IP is exposed. RIP. | Core is **Ghosted** behind multiple lines of defense. |
| **Vibe Check** | Blue Team hits a 404. Suspicious. | Blue Team hits a **Decoy**. You get a ping. They get nothing. |
| **Sustainability** | Manual rebuilds (Tiring and inefficient). | **Automated** Burn & Rebuild via Terraform. |
| **Reputation** | One IP for everything. Easy block. | **Layered Segregation.** Clean IPs, domain names and traffic. |

---

## 🛠️ The Tech Stack

* **Automation:** Terraform & Ansible.
* **Initial Access:** Evilginx (MFA Bypass) & Gophish. (This is as a first release, much more will come on later.
* **C2:** Mythic C2 or whatever, depending on the target hosts and engagement objectives.
* **Logic:** Redirectors, Firewalls, Honey pot to attract blue teamers.
* **Recon:** DNSTwist (Homograph domain magic)

---

## 🧠 The "Layers"

### 1. **The Brain**
The C2 server: 
- Doesn't talk to strangers
- It only accepts connections from the Redirectors/LBs and operators IPs.
- It's strictly "invite-only" via sessions for each operator.
- Behind Layers of security and deception. 

### 2. **The Secret Handshake (Layer C)**
Nginx Redirectors doing the absolute most. They check for a **Secret Header** in the traffic. 
* **Got the key?** Data in.
* **No key?** Cute, nice try. Redirect to the Honey Pot.

### 3. **The Deception**
This is the "Find Out" part of "Fuck Around." If someone does what you want them to do: analyze and probe your decoy, a high-priority alert is triggered, logged and monitored. Which results in us, receiving intel on how the Blue Team operates without efforts.

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
