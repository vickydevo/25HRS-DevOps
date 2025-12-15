# README.md

## Overview
This README shows the full, minimal workflow to automate creating a local file with Terraform using the `local_file` resource and exercises the Terraform lifecycle (write → init → validate → plan → apply → destroy). Follow the commands below in the project directory containing `main.tf`.

## Prerequisites
- Terraform installed (v1.x recommended)
- Local shell access
- Working directory for Terraform (example: `/d:/PROJECTS/25Hrs-Devops/Day5/`)

## Files
Create `main.tf` with the following content:

```hcl

resource "local_file" "my_file" {
    content             = "this is automated file"
    filename            = "automate.txt"
    file_permission     = "0777"
    directory_permission = "0777"
}
```

Save `main.tf` in your working directory.

## Terraform lifecycle steps (commands)

1. Initialize the working directory (downloads provider plugins):
```bash
terraform init
```

2. Validate the configuration syntax and provider blocks:
```bash
terraform validate
```

3. Generate and inspect an execution plan:
```bash
terraform plan
```
Optional: save the plan to a file to guarantee exact apply actions:
```bash
terraform plan -out=tfplan
```

4. Apply the plan (create the local file):
- Interactive:
```bash
terraform apply
# then type: yes
```
- Non-interactive:
```bash
terraform apply -auto-approve
```
Or apply the saved plan:
```bash
terraform apply tfplan
```

5. Verify the file was created:
```bash
ls -l automate.txt
cat automate.txt
```

6. Clean up (destroy the resource and remove from state):
- Interactive:
```bash
terraform destroy
# then type: yes
```
- Non-interactive:
```bash
terraform destroy -auto-approve
```

## Notes / Explanations
- Terraform lifecycle phases:
    - Write: author HCL (`main.tf`).
    - Init: download providers and initialize backend.
    - Validate: check configuration syntax.
    - Plan: preview changes Terraform will make.
    - Apply: enact changes and create resources.
    - Destroy: remove resources created by Terraform.
- State: Terraform stores resource metadata in `terraform.tfstate` (by default in the working dir). Keep it safe or configure a remote backend for collaboration.
- `local_file` writes files on the machine where Terraform is run. Use with care — it does not provision remote machines.


<img width="1242" height="478" alt="Image" src="https://github.com/user-attachments/assets/761b0c43-bf6b-4c26-a813-bbd2b12beab6" />