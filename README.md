# 🛠️ Windows PowerShell Scripts

This repository contains PowerShell scripts designed to automate the installation of essential applications and thoroughly remove the Xbox ecosystem from Windows, optimizing your system.

## 📄 Available Scripts

### 1. `install_apps.ps1`
This script uses **Winget** (Windows Package Manager) to automatically check, install, and update the following applications:
* Oracle VirtualBox
* Mozilla Firefox
* Microsoft Visual Studio Code
* Microsoft Visual Studio Community
* Discord
* Steam

**What it does:** It checks if each application is already installed. If it is, it searches for and applies updates. If it is not found, it downloads and silently installs the latest version from the internet.

### 2. `remove_xbox.ps1`
⚠️ **Recommended: Run as Administrator**
A deep cleaning script designed to remove bloatware and the entire Gaming/Xbox ecosystem from Windows.

**What it does:**
* **Step 1:** Uninstalls all Xbox apps and frameworks (Xbox App, Game Bar, Identity Provider, etc.).
* **Step 2:** Stops and permanently disables all Xbox and Gaming-related services in Windows.
* **Step 3:** Disables Game DVR and Game Mode features in the Windows Registry.
* **Step 4:** Disables Xbox scheduled tasks.

---

## 🚀 How to Run

Windows blocks the execution of `.ps1` scripts by default for security reasons. To run these files successfully, open your Command Prompt (CMD) or PowerShell in the folder where the files are located and use the commands below, which temporarily bypass this block.

**To run the app installation script:**
```powershell
powershell -ExecutionPolicy Bypass -File .\install_apps.ps1
```

**To run the Xbox removal script (Requires opening PowerShell as Administrator):**
```powershell
powershell -ExecutionPolicy Bypass -File .
emove_xbox.ps1
```
