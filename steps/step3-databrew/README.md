# Step 3: Clean and Transform with AWS Glue DataBrew

> **AWS Glue DataBrew** is a visual data preparation tool that lets you clean and normalise data without writing code.
>
> 💡 Think of it as: _"Excel for big data" — with smart suggestions and export options._

In this step, you'll:

- Create a DataBrew dataset connected to your S3 bucket
- Launch a DataBrew project to visually explore and clean the data

## 1. Deploy DataBrew Resources

From the **project root**, run:

```bash
./deploy.sh step3-databrew
```

See the CF Template for this step [here](./template.yml).

This will:

-  Create a DataBrew dataset linked to your movie data in S3
-  Create a DataBrew project so you can clean the data visually
-  Assign permissions to allow DataBrew to read from and write to S3

## 2. Open the DataBrew Project

1. Go to [AWS Glue DataBrew Projects](https://console.aws.amazon.com/databrew/home?region=ap-southeast-2#projects)
2. Find the project named `movies-databrew-project`
3. Click on it
4. Wait for the data preview to load

Once open, you'll be able to:

- Explore column stats
- Clean malformed or missing fields
- Standardise or split columns

> While we are using Glue as a source, the dataset ultimately references the file at:
> s3://movie-data-bucket-<account-id>-<region>/raw/movies/movies_metadata.csv
> 💡 Note: Glue acts as a schema layer — the original file in S3 is still required because Glue doesn’t store the data itself, just metadata.

If you notice, we already have a recipe attached to the data with some transformations.
Let's try to update the recipe via the UI to see how the data changes. Your tasks:

1. Change format for `release_date` to date
2. Convert `popularity` field to appropriate numeric data type and reduce number of decimal after `.` to 2.

Make sure to publish your updates in Recipe.

## 3. Run the DataBrew job to apply transformations

Once you’re happy with your data preparation, you can run the **DataBrew Job** that is deployed with your step CF template.

```bash
aws databrew start-job-run \
  --name movies-clean-job
```

You can check the status in a few ways:

1. Check in the AWS Console
2. Manual polling

```bash
aws databrew list-job-runs \
  --name movies-clean-job
```

Once the state returns "SUCCEEDED", the crawler has finished, and the table is available to use.

3. Monitor the job state until it's complete

Using watch (not installed on MacOS, need to run `brew install watch` before running the command)

```bash
watch -n 10 "aws databrew list-job-runs --name movies-clean-job --query 'JobRuns[0].State'"
```

Confirm the cleaned data is now in `s3://movie-data-bucket-<account-id>-<region>/clean/movies/*` via S3 Console. Or by running:

```bash
aws s3 ls s3://<your-bucket-name>/clean/movies/
```

[Continue to Step 4 - Create a QuickSight Dashboard](../step4-quicksight/README.md)
