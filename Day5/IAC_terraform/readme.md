# 🚀 Infrastructure as Code with Terraform: Getting Started

Welcome to the **4-hour intensive session** on Infrastructure as Code (IaC) using **HashiCorp Terraform**!

This course is designed to take you from understanding the fundamentals of IaC to writing, executing, and managing real-world cloud resources with Terraform.

---

## ⏰ Session Schedule & Breakdown

| Time Slot | Duration | Module | Focus Area |
| :--- | :--- | :--- | :--- |
| **Hour 1** | 60 min | **Foundations & Core Concepts** | **Theory: The What and Why** |
| **Hour 2** | 60 min | **Execution Workflow & State Management** | **Theory & Demo: The How** |
| **Hour 3** | 60 min | **Configuration & Provisioning (Lab)** | **Hands-On: First Script** |
| **Hour 4** | 60 min | **Advanced Practice & Next Steps** | **Hands-On: Full Stack & Future** |

---

## 🧠 What We'll Cover

We will be covering the following topics in depth, combining essential theory with practical, hands-on labs.

### 1. Introduction to IaC & Terraform Basics (Hour 1)

* **Introduction to IaC:** The problem IaC solves (Configuration Drift, Speed, Auditability).
* **Basics of Terraform:**
    * **Definition:** What Terraform is and why it's the industry standard for multi-cloud IaC.
    * **History:** The origin and growth of the HashiCorp ecosystem.
    * **Terraform Lifecycle:** The fundamental cycle of configuration $\to$ Plan $\to$ Apply $\to$ Destroy.
* **Providers & Resources:**
    * **Providers:** The plug-ins (e.g., AWS, Azure, Google Cloud) that translate your code.
    * **The Workflow Diagram:** Understanding the loop: **Terraform $\leftrightarrow$ Terraform Provider $\to$ Target API**.

### 2. The Execution Workflow and State (Hour 2)

* **The Four Core Commands:** A deep dive into the commands that drive the Terraform lifecycle:
    * `terraform **init**`: Setting up the working directory.
    * `terraform **plan**`: The crucial "dry run" step.
    * `terraform **apply**`: Creating and updating infrastructure.
    * `terraform **destroy**`: Cleaning up resources.
* **The State File (`.tfstate`):**
    * What the `tfstate` file is and why it's the **single source of truth**.
    * Security implications and why the state should **never** be stored locally in a team environment.
    * **Remote Backend:** Configuring and understanding **remote state management** (e.g., using S3 for collaboration and security).

### 3. Practical: Writing Simple Terraform Scripts (Hours 3 & 4)

We will focus on writing reusable and maintainable configuration using **HashiCorp Configuration Language (HCL)**.

* **Configuration Structure:** Organizing your code into standard files (`main.tf`, `variables.tf`, `outputs.tf`).
* **Variables:** Defining input variables, setting types, and supplying values via `.tfvars`.
* **Outputs:** Using **`output` blocks** to extract and display useful information (like public IPs or DNS names) after deployment.
* **Practical Lab Scenario: Deploying a Web Server**
    * Writing scripts to provision an **EC2 instance** (or equivalent VM).
    * Provisioning and linking a **Security Group** (Network Firewall).
    * Using **Data Sources** to dynamically fetch resource information (e.g., the latest AMI ID).

### 4. Next Steps & Best Practices (Hour 4 Wrap-Up)

* **Code Validation:** Quick tips using `terraform fmt` and `terraform validate`.
* **Introduction to Modules:** The key to true reusability and scaling your IaC efforts.
* **The Future:** Brief discussion on CI/CD integration and **Terraform Cloud/Enterprise**.