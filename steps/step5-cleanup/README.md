# Final Cleanup

If you're done with the workshop and want to remove all resources, follow the steps below.

## 1. Delete the QuickSight Account (Manual Step)

Unfortunately, **QuickSight accounts can't be deleted via CLI or CloudFormation.**

To close your QuickSight account:

1. Go to the QuickSight Console: [https://quicksight.aws.amazon.com](https://quicksight.aws.amazon.com)
2. In the top-right corner, click your profile
3. Choose **Manage QuickSight**
4. Find **Account settings**
5. Click Manage
6. Delete the account

💡 _Note: This deletes **only the QuickSight account**, not your AWS account or any S3 buckets._

## 2. Run the Cleanup Script

This will delete all deployed CloudFormation stacks and empty the S3 buckets.

From your project root:

```bash
./cleanup.sh
```

This will:
- Empty the `movie-data-bucket` and `athena-query-results` S3 buckets
- Delete the following stacks:
  - step3-databrew
  - step2-glue
  - step1-s3

3. Troubleshooting Cleanup Failures

If any of the stacks failed to delete - go to Cloud Formation Console and investigate the error.
