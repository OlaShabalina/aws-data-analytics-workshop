# Step 0: Set Up Your Environment (AWS CLI)

This step will set up your local environment with:

- AWS CLI
- Credentials configured to deploy CloudFormation stacks

No Python or virtual environment is required.

## Prerequisites

- AWS account and access keys
- [AWS CLI installed](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

To check:

```bash
aws --version
```

If it's not installed, follow [these instructions](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) for your platform.

## Step-by-Step Setup

### 1. Clone the workshop repo

```bash
git clone https://https://github.com/OlaShabalina/aws-data-analytics-workshop
cd aws-data-analytics-workshop
```

### 2. Configure your AWS CLI

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
