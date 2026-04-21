Here is a structured, comprehensive prompt designed to onboard multiple AI agents into your Red Team infrastructure project, covering the scope, goals, technologies, and operational aspects:

AI Agent Onboarding Prompt: Advanced Red Team C2 Infrastructure
Project Title: Multi-Layered, OPSEC-Hardened Red Team C2 Infrastructure

Goal: Build a resilient, disposable, and stealthy command-and-control (C2) architecture to safely simulate advanced persistent threats (APTs) while preserving operational security (OPSEC). The primary measure of success is maintaining C2 connectivity for the full duration of the engagement without the core components being identified or blocked.

1. Scope and Architecture
Describe the entire infrastructure using the layers below:

Layer	Components	Role
A. Operations	Terraform, Ansible, Centralized Logging (ELK/Splunk), Custom Domain Health Checker	Automate the deployment, rotation, and logging of all disposable assets. Manage operator access.
B. Delivery/Initial Access (High Risk)	Mail Server, Payload Server, Phishing Redirectors	These servers are designed to be disposable (burnable). They handle the highest-risk actions (phishing and implant delivery) and are isolated from the C2 core.
C. C2 Fronting/Evasion	C2 Redirectors (Nginx, CDN), Evasion Logic (Layer 7 filtering)	Filter traffic. Only whitelisted/expected traffic passes; all others are diverted to a Decoy/Canary.
D. C2 Core (Hidden)	Primary C2 Server (e.g., Cobalt Strike, Mythic)	The core asset. Its IP address must never be directly exposed. It only communicates with authorized redirectors.

Exporter vers Sheets
2. Key Technology Stack
Identify the tools and technologies required for implementation:

Infrastructure as Code (IaC): Terraform (for deployment/destruction automation), Ansible (for post-deployment configuration, hardening, and listener setup).

Networking/Fronting: Nginx/Apache (for reverse proxy/redirectors), optional CDN/CloudFront for domain fronting/reputation.

Evasion/Filtering: iptables/firewalld (for IP whitelisting on C2 core), Nginx map or if blocks (for Layer 7 User-Agent/Header filtering).

Specialized Servers: Dedicated low-reputation VPS for Mail and Payload hosting.

Monitoring/Log Aggregation: rsyslog/Logstash and a secure centralized log collector.

3. Core OPSEC Principles (Must be Followed)
The following principles govern all infrastructure design:

Segregation of Duty: The Mail Server and Payload Server must have dedicated IP addresses and domains, completely separate from the C2 redirectors. If they are detected, only the low-value components are lost.

Defense-in-Depth: All traffic must pass through at least one filtering redirector before reaching the C2 core.

Canary Traps: Any connection that does not match the expected C2 traffic profile (e.g., correct User-Agent, specific headers) must be immediately forwarded to a Decoy/Canary Listener.

Automation & Disposable: The infrastructure must be designed for rapid deployment and automated tear-down using Terraform to ensure all assets are easily replaced when indicators of compromise (IOCs) are detected.

4. Agent Tasking and Focus Areas
Based on this overview, your tasks are:

Analyze: Identify critical failure points in the Layer B (Delivery) and Layer C (Evasion) structure.

Propose: Suggest specific hardening techniques for the Payload Server (G) to block automated scanners (e.g., specific HTTP redirect codes, time-based filtering).

Define: Detail the necessary Nginx/Apache configuration syntax for the C2 Redirectors (E) to enforce the Evasion Logic (Header/User-Agent check) and the Decoy/Canary redirection.

Validate: Outline a logging architecture that ensures operator actions on the C2 core are logged separately from network traffic logs, maximizing forensic security.

Goal Confirmation: All subsequent responses must reference these four layers (A, B, C, D) and the three Core OPSEC Principles.
