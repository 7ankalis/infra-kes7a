# 🎭 Infra Kes7a

[![State: Under Development](https://img.shields.io/badge/Status-Cooking..-orange?style=for-the-badge&logo=fastapi)](https://github.com/)
[![Vibe: Main Character Energy](https://img.shields.io/badge/Vibe-No%20Cap-blueviolet?style=for-the-badge)](https://github.com/)
[![Tech: Terraform/Ansible](https://img.shields.io/badge/Stack-IaC%20%2F%20C2-blue?style=for-the-badge&logo=terraform)](https://www.terraform.io/)

> **"Imagine a Quote on evading the Blue Team with a decent methodology."**

## 🔑 Why I built this 

Let’s be real: Most CTF labs train us to get clapped in a real-world engagement. Attacking from a single VM, extensive unlimited probing, and much more; as delulu as can be. After digging into how actual APTs move, I realized their infra is a whole ecosystem not just a centralized server or whatsoever with closed ports or whatsoever.

So I built **Infra Kes7a** in an attempt to move away from script kiddie networking and feed my **Main Character Syndrome**.

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

> With further releases, **Infra Kes7a** will include other structures depending on other compaign goals. For now let's focus on spear phishing.
---

## 🛠️ The Tech Stack

* **Automation:** Terraform, Ansible and cloud-init.
* **Initial Access:** Evilginx (MFA Bypass) & Gophish. (This is as a first release, much more will come on later.
* **C2:** Mythic C2 or whatever, depending on the target hosts and engagement objectives.
* **Logic:** AWS, GCP, Azure and DigitalOcean: Redirectors, Firewalls, Honeypot to attract blue teamers.
* **Domain:** DNSTwist or equivalent.

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
