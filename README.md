# Automate Ansible Playbook Using Terraform (POC)

This repository contains a Proof of Concept (POC) demonstrating how to integrate **Terraform** and **Ansible** to provision infrastructure and manage its state automatically. 

Specifically, this project uses Terraform to provision an AWS EC2 instance and utilizes a `local-exec` provisioner to trigger an Ansible playbook that manages the power state (started or stopped) of that EC2 instance.

## Architecture & Workflow

1. **Infrastructure Provisioning**: Terraform creates an AWS EC2 instance (`t2.micro` by default) defined in `ec2.tf`.
2. **State Management**: A `null_resource` in `main.tf` acts as a trigger. Whenever the EC2 instance is created/modified or the desired `ec2_state` variable is changed, it runs a local shell command.
3. **Configuration Management**: The shell command executes the Ansible playbook (`ansible/manage_state.yaml`), passing the instance ID, region, and target state as extra variables to start or stop the instance using the `amazon.aws.ec2_instance` Ansible module.

## Prerequisites

Before running this project, ensure you have the following installed and configured:

- **Terraform** (v1.0.0 or higher)
- **Ansible**
- **Amazon.aws Ansible Collection**: Install it via `ansible-galaxy collection install amazon.aws`
- **AWS CLI**: Configured with a profile named `mit_test` that has sufficient permissions to manage EC2 instances. *(Alternatively, you can modify the `profile` parameter in `provider.tf` and `ansible/manage_state.yaml` to match your existing AWS CLI profile).*

## Project Structure

```bash
.
├── ansible/
│   └── manage_state.yaml   # Ansible playbook to start/stop the EC2 instance
├── ec2.tf                  # Defines the AWS EC2 instance resource
├── main.tf                 # Contains the null_resource that links Terraform with Ansible
├── provider.tf             # AWS provider configuration
├── terraform.tfvars        # Default variable values
└── variable.tf             # Variable definitions
```

## Usage

### 1. Initialize Terraform
Initialize the working directory containing Terraform configuration files.
```bash
terraform init
```

### 2. Review the Plan
Check the execution plan before making any changes.
```bash
terraform plan
```

### 3. Apply the Configuration
Provision the resources. This will create the EC2 instance and immediately trigger the Ansible playbook to set its state to `stopped` (the default state defined in `terraform.tfvars`).
```bash
terraform apply
```

### 4. Changing the EC2 State
To start the EC2 instance, you simply update the `ec2_state` variable. You can do this by modifying `terraform.tfvars` or passing it directly via the CLI:
```bash
terraform apply -var="ec2_state=started"
```
Because the `null_resource` triggers on changes to `var.ec2_state`, Terraform will re-run the Ansible playbook and power on the instance.

### 5. Clean Up
To destroy the provisioned infrastructure when you are done:
```bash
terraform destroy
```

## Variables

The following variables are defined in `variable.tf` and can be overridden:

| Variable | Description | Default Value |
| --- | --- | --- |
| `aws_region` | The AWS region to deploy resources in | `us-east-1` |
| `ami_id` | The AMI ID for the EC2 instance | `ami-0c02fb55956c7d316` |
| `instance_type`| The EC2 instance type | `t2.micro` |
| `ec2_state` | The desired power state of the instance (`started` or `stopped`) | `stopped` |
