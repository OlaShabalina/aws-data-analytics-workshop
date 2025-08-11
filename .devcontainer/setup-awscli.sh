#!/usr/bin/env bash
set -euo pipefail

curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

echo "AWS CLI installed: $(aws --version)"
