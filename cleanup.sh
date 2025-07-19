#!/bin/bash

set -euo pipefail

# Config
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="ap-southeast-2"

BUCKET_ATHENA="athena-query-results-${ACCOUNT_ID}-${REGION}"
BUCKET_MOVIE="movie-data-bucket-${ACCOUNT_ID}-${REGION}"

STACKS=(
  "step3-databrew"
  "step2-athena-glue"
  "step1-s3"
)

# Empty buckets
echo "🧹 Emptying S3 buckets..."

aws s3 rm "s3://$BUCKET_ATHENA" --recursive || echo "⚠️ Failed to empty $BUCKET_ATHENA"
aws s3 rm "s3://$BUCKET_MOVIE" --recursive || echo "⚠️ Failed to empty $BUCKET_MOVIE"

# Delete CloudFormation stacks
echo "🧨 Deleting CloudFormation stacks..."

for STACK in "${STACKS[@]}"; do
  echo "🔍 Checking stack: $STACK"

  if aws cloudformation describe-stacks --stack-name "$STACK" &>/dev/null; then
    echo "🚨 Deleting stack: $STACK"
    aws cloudformation delete-stack --stack-name "$STACK"
  else
    echo "✅ Stack $STACK does not exist or already deleted. Skipping..."
  fi
done

# Wait for stack deletions to complete
echo "⏳ Waiting for stack deletions to complete..."

for STACK in "${STACKS[@]}"; do
  echo "⏳ Waiting on stack: $STACK"

  if aws cloudformation describe-stacks --stack-name "$STACK" &>/dev/null; then
    aws cloudformation wait stack-delete-complete --stack-name "$STACK" \
      && echo "✅ $STACK deleted." \
      || echo "❌ Failed to delete $STACK (check CloudFormation console)"
  else
    echo "✅ Stack $STACK already deleted."
  fi
done

echo "🏁 Cleanup complete!"
