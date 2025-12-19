

### 1. Create your README.md

Copy and paste this into a new file named `README.md` in your project folder:

```markdown
# AWS Jenkins Infrastructure (Spot Instance)

This Terraform project automates the deployment of a Jenkins server on an AWS EC2 **Spot Instance** to optimize costs. It uses a `t3.xlarge` instance with a persistent request to ensure the server stays up or restarts automatically.

## Architecture
* **Instance Type:** t3.xlarge (Spot)
* **Storage:** 20GB gp3 EBS Volume
* **OS:** Ubuntu 24.04 LTS
* **Network:** Default VPC
* **Security:** Open ingress for all protocols (for development purposes)

## Prerequisites
1. [Terraform](https://www.terraform.io/downloads.html) installed.
2. AWS CLI configured with appropriate credentials.
3. An SSH key pair named `local_key` and `local_key.pub` in the root directory.

## Getting Started

1. **Initialize Terraform:**
   ```bash
   terraform init
```

2. **Plan the infrastructure:**
```bash
terraform plan

```


3. **Deploy:**
```bash
terraform apply

```



## Important Security Note

The current security group allows **all inbound traffic** (`0.0.0.0/0`). This is intended for initial setup but should be restricted to your specific IP address for production use.

```

---

### 2. Final Check of your Folder Structure
Your folder should now look like this before you push to GitHub:

* `Ec2.tf`
* `providers.tf`
* `output.tf`
* `.gitignore` <--- **Crucial!**
* `README.md`
* `local_key.pub` (Optional)
* *(The following will be hidden by your .gitignore: `local_key`, `.terraform/`, `terraform.tfstate`)*



---

### 3. Commands to Push to GitHub
If you haven't pushed yet, run these commands in your terminal:

```bash
# 1. Initialize git
git init

# 2. Add all files (Git will automatically ignore what's in .gitignore)
git add .

# 3. Commit your changes
git commit -m "Initial commit: Jenkins Spot instance infrastructure"

# 4. Create a main branch
git branch -M main

# 5. Link to your GitHub repo (Replace with your actual URL)
git remote add origin https://github.com/YOUR_USERNAME/terraform-aws-jenkins-spot.git

# 6. Push!
git push -u origin main

```

