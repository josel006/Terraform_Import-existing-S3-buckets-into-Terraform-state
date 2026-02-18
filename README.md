# Terraform_Import-existing-S3-buckets-into-Terraform-state
## How to import an existing AWS S3 bucket into a Terraform tfstate file

Terraform does not automatically detect resources that already exist in the AWS Console.
To allow Terraform to manage existing infrastructure, you must import those resources into Terraform state.

This article demonstrates how to import an existing S3 bucket created in the AWS Console into Terraform using VS Code.

## Prerequisites

- AWS CLI configured (aws configure)

- Terraform installed

- VS Code with Terraform extension

- Existing S3 bucket in AWS

## Step 1: Create the Terraform configuration

In VS Code, create a working directory and add a main.tf file.
```bash
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "default" # Change if you use another AWS CLI profile
}

resource "aws_s3_bucket" "resume" {
  bucket = "jose-rios-resume"
}
```

⚠️ Important:
The resource block must exactly match the existing AWS resource name. Terraform will not create this bucket — it will only attach it to state.

## Step 2: Identify the existing S3 bucket

The following S3 bucket already exists in the AWS Console and will be imported into Terraform state:

<img width="1003" height="272" alt="image" src="https://github.com/user-attachments/assets/21d8e674-dc77-495b-8612-6817784da11f" />

- Bucket name: jose-rios-resume

- Region: us-east-2

## Step 3: Initialize Terraform

From the VS Code terminal, inside the project directory, run:
```bash
terraform init
```

This command:

Downloads the AWS provider

Prepares Terraform to manage state

## Step 4: Import the existing S3 bucket into Terraform state

Run the following command:
```bash
terraform import aws_s3_bucket.resume jose-rios-resume
```

What this does:

Maps the existing AWS S3 bucket to the Terraform resource aws_s3_bucket.resume

Writes the mapping into terraform.tfstate

✅ No resources are created or modified during import

## Step 5: Verify the import with Terraform plan

Run:
```bash
terraform plan
```

Terraform will now:

Compare your .tf configuration with the real AWS resource

Show any configuration drift (if present)

If Terraform proposes changes, it usually means the bucket has additional settings such as:

- Versioning

- Encryption

- Public access block

- Bucket policy

- Website hosting

These features are managed using separate Terraform resources and can be added later if you want Terraform to fully control them.

## Result

Terraform is now aware of the existing S3 bucket and can manage it going forward.
The bucket is safely tracked inside terraform.tfstate without recreating or deleting anything.

## Key Takeaways

Terraform does not automatically discover existing AWS resources

terraform import attaches real infrastructure to Terraform state

Always run terraform plan after import to detect configuration drift

Never run terraform apply before importing existing resources
