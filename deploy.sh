#!/bin/bash

set -e

STEP=$1

if [[ -z "$STEP" ]]; then
  echo "Usage: ./deploy.sh <step1-s3|step2-athena|step3-databrew|step4-quicksight>"
  exit 1
fi

TEMPLATE_FILE="steps/${STEP}/template.yml"

echo $TEMPLATE_FILE

if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo "❌ Template not found for: $STEP"
  exit 1
fi

STACK_NAME="$STEP"

echo "🚀 Deploying stack: $STACK_NAME from $TEMPLATE_FILE"

aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM

echo "✅ Stack '$STACK_NAME' deployed successfully."
