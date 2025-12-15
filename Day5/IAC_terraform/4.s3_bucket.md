# Simple AWS S3 Terraform (single-file)

Minimal single-file Terraform script (provider + resource). Edit the bucket name to a globally unique value before applying.

## Overview of Terraform Blocks

## Terraform Block
The `terraform` block declares which provider plugins are needed. Think of it as the power tool (like a drill) that provides the core functionality:
### terraform.tf
```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.18.0"
    }
  }
}
```



These blocks work together to define how Terraform will interact with AWS to create and manage resources.



## Provider Block
The `provider` block configures how to authenticate and operate the provider plugin. Think of it as the drill bit that determines how we'll interact with AWS:
### provider.tf
```hcl
provider "aws" {
    region = "us-east-1"  # Specifies where to create resources
}
```
## s3.tf
```hcl

resource "aws_s3_bucket" "bucket" {
    bucket = "terraform-vignan-bucket-30-nov" # replace with your unique name

}

```

## Install AWS CLI
- **Linux:**
    - Download/unzip installer:
    ```bash
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        sudo apt  install unzip -y
        unzip awscliv2.zip
        sudo ./aws/install
    ```
- **Windows (PowerShell):**
      run the AWS CLI MSI installer from AWS (msi URL available in AWS docs)

## Configure AWS CLI (use IAM credentials)
1. Create an IAM user in the AWS Console:
     - Go to IAM → Users → Add user.

<img width="1532" height="736" alt="Image" src="https://github.com/user-attachments/assets/ab17b21d-3f2d-4d4c-a0f3-87df62f2fec0" />

---
 <img width="1890" height="702" alt="Image" src="https://github.com/user-attachments/assets/4cf9ab76-ba03-41ff-8014-01a4f9ae420b" />
---

     - Enable "Programmatic access".

     - Attach existing policies → search and attach `AmazonS3FullAccess`.
     - Create user and download the Access key ID and Secret access key (CSV).
---
<img width="1869" height="741" alt="Image" src="https://github.com/user-attachments/assets/e4ff1969-348d-45bf-8da5-1da8b787ad6b" />

<img width="1861" height="674" alt="Image" src="https://github.com/user-attachments/assets/b2fddbab-63fb-4a20-9520-a041cb1d6344" />
---
<img width="1462" height="773" alt="Image" src="https://github.com/user-attachments/assets/6e271ac8-5f11-4b17-8818-202c5b50ea23" />

<img width="1353" height="450" alt="Image" src="https://github.com/user-attachments/assets/8a20df1e-e9e9-4984-a407-72daee0552e3" />


---

2. Locally run:
    ```bash
     aws configure
     aws configure --profile my-dev-user
    ```
     - Enter Access Key ID, Secret Access Key, default region (e.g., us-east-1), and default output (json).

<img width="1502" height="231" alt="Image" src="https://github.com/user-attachments/assets/558794f2-2546-44c4-a0b8-b07b5a5874de" />
---

## Apply Terraform
1. In the directory with `main.tf`:
     - `terraform init`
     - `terraform plan`
     - `terraform apply` (confirm)
2. Delete or change `force_destroy` manually if you need to remove non-empty buckets (not enabled here).

Notes:
- Bucket names must be globally unique.
- For production, prefer KMS-managed encryption and least-privilege IAM policies instead of AmazonS3FullAccess.
- Keep credentials secure and rotate regularly.
