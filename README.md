# 🛡️ NMaper Stealth Reporter (v1.0)

A modular Bash-based network scanner designed for automated reconnaissance with encrypted exfiltration and anti-forensics capabilities.

---

## 📖 Overview
**NMaper** is a security auditing tool that automates the workflow from scanning to reporting. It performs Nmap scans, archives results into a protected ZIP, exfiltrates the data to an anonymous remote server, and notifies the operator with an **AES-256 encrypted link**.

### Key Features
* **Modular Architecture:** Logic is separated into `lib/utils.sh` (UI/Crypto) and `lib/comms.sh` (Networking).
* **Secure Exfiltration:** Report links are encrypted using **AES-256-CBC (PBKDF2)** before transmission.
* **Anonymous Reporting:** Utilizes `bashupload.com` and `ntfy.sh` — no accounts, registration, or logs required.
* **Anti-Forensics:** Automatically purges local XML scan results and temporary archives after a successful upload.
* **Color-Coded UI:** Professional terminal interface for real-time status updates.

---

## 🛠️ Project Structure
```text
.
├── nmaper.sh          # Main execution engine
├── targets.txt        # List of target IPs/Subnets
├── lib/
│   ├── utils.sh       # UI components and Cryptography
│   └── comms.sh       # HTTP handling and Data Exfiltration
└── result/            # Temporary directory for XML reports

```
## 🚀 Getting Started

### 1. Prerequisites
Ensure your system has the following tools installed:
`nmap`, `curl`, `zip`, `openssl`.

### 2. Installation
Clone the repository and grant execution permissions:
```bash
chmod +x nmaper.sh

### 3. Configuration
Define your environment variables in `nmaper.sh` or export them in your shell:
* `STATIONARY_ROOM`: Your unique topic name on `ntfy.sh` (e.g., `ghost_scanner_99`).
* `ENCRYPT_PASS`: The master password used for AES encryption.

### 4. Usage
To run a scan with automatic upload and notification:
```bash
./nmaper.sh -u

## 🔓 Decrypting Results
When you receive a notification on your `ntfy.sh` channel, use the following command to retrieve the plain-text link:

```bash
echo "YOUR_ENCRYPTED_STRING" | openssl enc -aes-256-cbc -a -d -salt -pbkdf2 -pass "pass:YOUR_PASSWORD"

## 🛡️ Operational Security (OPSEC)
* **Secret Channels:** Use long, randomized strings for your `STATIONARY_ROOM` to prevent others from guessing your notification channel.
* **Forensic Protection:** The script automatically deletes XML reports after upload. For maximum security, run the project from a **RAM disk** (tmpfs) so no data ever touches the physical drive.

---

## ⚠️ Legal Disclaimer
This tool is for educational purposes and authorized security auditing only. Using this script against targets without prior written consent is illegal and unethical. The author is not responsible for any misuse.