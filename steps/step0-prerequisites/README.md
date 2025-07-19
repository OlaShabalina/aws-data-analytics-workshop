# Step 0: Set Up Your Environment (AWS CLI)

This step will set up your local environment with:

- AWS CLI
- Credentials configured to deploy CloudFormation stacks

No Python or virtual environment is required.

## Prerequisites

- AWS account and access keys
- AWS CLI installed. If AWS CLI is not installed, follow [these instructions](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) for your platform.

To check:

```bash
aws --version
```

## Step-by-Step Setup

### 1. Clone the repo

```bash
git clone https://github.com/OlaShabalina/aws-data-analytics-workshop.git
cd aws-data-analytics-workshop
```

### 2. Make the deploy script executable

```bash
chmod +x deploy.sh
```

We will use the script for deploying our CloudFormation templates.

### 3. Configure your AWS CLI

Create an access key via the AWS Console:
1. Go to IAM
2. Under Access Management, click Users
3. Select your user
4. Open the Security credentials tab
5. Click Create access key
6. Choose Use case: CLI
7. Your Access key ID and Secret access key will be generated.

Use the values from the steps above when running aws configure:

```bash
aws configure
```

You'll be prompted to enter:

* `AWS Access Key ID`
* `AWS Secret Access Key`
* `Default region name` → e.g. `ap-southeast-2`
* `Default output format` → `json`

To verify you're connected:

```bash
aws sts get-caller-identity
```

You should see your AWS account ID and user.

[Continue to Step 1 - Create Your S3 Bucket and Upload Movie Data](../step1-s3/README.md)
