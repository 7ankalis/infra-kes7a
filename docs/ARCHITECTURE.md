# 🛡️ Architecture and Layered Defense

## 1. Core Principles (OPSEC)

The infrastructure follows a **Defense-in-Depth** model designed for maximum Operational Security (OPSEC) and resilience. The central strategy is to use **disposable, heavily filtered front-end servers** to shield the high-value **Primary C2 Core**.

* **Zero Trust Core:** The C2 Core **denies all** inbound traffic by default, only whitelisting the Redirectors and the operator's IP.
* **Decoupled Functions:** High-risk functions (Payload Delivery, Phishing) are segregated from the low-risk, stealthy C2 channels.
* **Automated Disposal:** The entire front-end is managed by IaC (Terraform) for rapid **"Burn and Rebuild"** capability upon detection.

---

## 2. Infrastructure Layers

| Layer | Component Role | Technical Tooling | Public Access | Primary Function |
| :---: | :--- | :--- | :---: | :--- |
| **A** | **Automation/IaC** | `Terraform`, `Ansible` | Private | Full stack provisioning and configuration management. |
| **B** | **Delivery Front** | `Nginx`, `Postfix`/`Mail Server` | Public IP | Hosts stagers, payloads, or manages SMTP for initial access. |
| **C** | **C2 Redirectors** | `Nginx Reverse Proxy` | Public IP | Layer 7 Header Validation and Traffic Routing. The primary decoy. |
| **E** | **Decoy Listener** | `Nginx/Custom Web Server` | Private/Local | Catches invalid C2 traffic, logs connection, and sends OPSEC alert. |
| **D** | **Primary C2 Core** | C2 Framework (e.g., `Cobalt Strike`) | Private | Command and Control of implanted targets. |

---

## 3. Naming Conventions (OPSEC Focused)

We use generic, obfuscated internal names to avoid revealing purpose in configuration files or logging (where external eyes might see them).

| Asset Type | Convention | Example | Notes |
| :--- | :--- | :--- | :--- |
| **Core C2 Server** | `TEAM-C2-[REGION]` | `TEAM-C2-R1` | The "Crown Jewel." IP is never public. |
| **C2 Redirector** | `EDGE-[PROVIDER]-[NUMBER]` | `EDGE-LIN-01` | Front-facing, disposable servers. |
| **Decoy Server** | `DECOY-TRAP-[REGION]` | `DECOY-TRAP-A` | Used for logging attempted bypasses. |
| **Delivery Server** | `DELIVERY-[FUNC]` | `DELIVERY-PHISH-SMTP` | High burn rate, used for initial access only. |

---

## 4. The Evasion Logic Flow (Traffic Routing)

The resilience of the infrastructure depends on the Nginx Redirector's filtering logic:

1.  **Request Arrives at Redirector (C).**
2.  **Header Check:** The Redirector inspects the HTTP request for a **secret custom header** (e.g., `X-Secret-Tag: TTP_A1`).
3.  **VALID Connection (TTP Match):** The request contains the correct secret tag (set by the Malleable C2 Profile). The Redirector forwards the request to the **C2 Core (D)**.
4.  **INVALID Connection (Scanner/Blue Team):** The request lacks the secret tag. The Redirector silently forwards the request to the **Decoy Listener (E)** and sends a decoy page response.
5.  **ALERT:** The Decoy Listener (E) logs the invalid connection and can trigger a Slack/Email OPSEC alert.
