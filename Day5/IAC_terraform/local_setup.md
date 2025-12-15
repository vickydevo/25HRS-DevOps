# 💻 Installing Terraform on Windows (Using Chocolatey)

This guide provides the most straightforward method for installing HashiCorp Terraform on Windows by using the popular package manager, **Chocolatey**.

## Prerequisites

* A Windows operating system (Windows 7+ / Windows Server 2003+).
* Access to an account with **Administrator** privileges.
* PowerShell (PowerShell 7 is preferred, but the default Windows PowerShell works).

---

## Step 1: Install Chocolatey (The Package Manager)

Chocolatey (choco) simplifies the process of installing software by handling file paths and environment variables automatically.

### A. Run PowerShell as Administrator

1.  Click the Start button (or press the Windows key).
2.  Type `PowerShell`.
3.  Right-click the "Windows PowerShell" result and select **"Run as administrator."**

### B. Execute the Installation Command

Paste the following command into the elevated PowerShell window and press Enter. This command downloads and runs the official Chocolatey installation script.

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('[https://community.chocolatey.org/install.ps1](https://community.chocolatey.org/install.ps1)'))
```
### B.Verify choco
```powershell
    choco -v
```

## Step 2: Install Terraform

Once Chocolatey is installed, you can easily install Terraform with a single command.

### A. Install Using Chocolatey

In the same elevated PowerShell window, run:

```powershell
choco install terraform -y
```

### B. Verify Installation

To confirm Terraform was installed correctly:

1. Close and reopen PowerShell
2. Run the command:

```powershell
terraform --version
```

You should see the current version of Terraform displayed.