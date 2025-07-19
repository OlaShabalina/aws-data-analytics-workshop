# Step 2: Set Up Glue Crawler and Query with Athena

> 💡 An **AWS Glue Crawler** is a service that:
> - Scans files in your S3 bucket (like CSVs, JSON, or Parquet)
> - Infers the data structure (columns, types, formats)
> - Creates or updates a table in the Glue Data Catalog
>
> Once the crawler runs, your S3 data becomes queryable in **Athena** using standard SQL.
>
> Think of it as: _"A smart scanner that turns files in S3 into database tables you can query with SQL."_

In this step, you'll:
- Deploy a Glue Database and Crawler
- Crawl the movie dataset stored in your S3 bucket
- Query the dataset using Athena

## 1. Deploy Glue Resources

From the **project root**, run:

```bash
./deploy.sh step2-athena-glue
```

See the CF Template for this step [here](./template.yml).

This will:
- Create a Glue Database called movies-workshop-db
- Create a crawler named movies-csv-crawler
- Assign a role to allow Glue to read your S3 bucket

## 2. Run the Crawler

Once your crawler is created, you need to run it to scan your movie data and register the table.

### Option A: AWS CLI

Run the crawler from your terminal:

```bash
aws glue start-crawler --name movies-csv-crawler
```

### Option B: Glue Console

1. Go to [AWS Glue Console → Crawlers](https://console.aws.amazon.com/glue/home?region=ap-southeast-2#/v2/data-catalog/crawlers)
2. In the left menu, click **Crawlers**
3. Find `movies-csv-crawler` in the list
4. Click **Run crawler**
5. Wait ~1 minute for it to complete

This will scan the files in your S3 bucket at `raw/movies/` and create a table in the Glue Data Catalog.

The crawler takes some time to complete. You can check the status in a few ways:
1. Check in the AWS Console
2. Manual polling

```bash
aws glue get-crawler --name movies-csv-crawler --query 'Crawler.State'
```

Once the crawler state returns "READY", the crawler has finished, and the table is available to use.

3. Monitor the crawler state until it's complete

Using watch (not installed on MacOS, need to run `brew install watch` before running the command)

```bash
watch -n 5 "aws glue get-crawler --name movies-csv-crawler --query 'Crawler.State'"
```

## 🔎 3. Explore the Data with Athena

> **Amazon Athena** is a serverless SQL query engine that lets you analyse data directly in Amazon S3 using standard SQL — no need to move the data or manage servers.
>
> You can:
> - Run ad-hoc queries on large datasets
> - Perform data exploration and validation
> - Use it as a source for dashboards (e.g., QuickSight)
> - Integrate with Glue to query structured S3 data like a database
>
> 💡 Think of it as: _“SQL for your S3 buckets.”_

Once the crawler finishes, your movie data is ready to query in Athena using SQL.

### Option A: Athena Console (recommended)

1. Go to [AWS Glue Console → Databases → Tables](https://console.aws.amazon.com/glue/home?region=ap-southeast-2#/v2/data-catalog/tables)
2. Click on the table movies
3. In the Actions dropdown, choose View data. You’ll be redirected to Athena with a pre-filled SQL query to see all the data
4. Athena needs to store query results in a bucket, click the error message at the top or go to Settings → Manage → Query result location and encryption. Paste the name of your custom bucket deployed in this step with a prefix of your choice: `athena-query-results-${AWS::AccountId}-${AWS::Region}` + `/query-results/`.
4. Click Run to preview the results!

You can now write custom SQL queries, like:

- Check the total count of rows:

```sql
SELECT COUNT(*) AS total_movies
FROM "movies-workshop-db"."movies";
```

- Check top 10 highly rated movies:
```sql
SELECT title, release_date, vote_average
FROM "movies-workshop-db"."movies"
WHERE vote_average >= 8
ORDER BY vote_average DESC
LIMIT 10;
```

- Number of movies by release year (the date field is not consistent so we added a filter to show only valid years)

```sql
SELECT
  REGEXP_EXTRACT(release_date, '([0-9]{4})$') AS release_year,
  COUNT(*) AS movie_count
FROM "movies-workshop-db"."movies"
WHERE release_date IS NOT NULL
  AND release_date != ''
  AND REGEXP_LIKE(release_date, '[0-9]{4}$')
  AND CAST(REGEXP_EXTRACT(release_date, '([0-9]{4})$') AS INTEGER) <= 2025
GROUP BY REGEXP_EXTRACT(release_date, '([0-9]{4})$')
ORDER BY release_year DESC;
```

### Option B: Athena CLI
You can also run queries programmatically using the AWS CLI or Boto3.

**Output Location:** Just like in the console, you can use your custom bucket that was deployed in this step with a prefix: `s3://athena-query-results-<your-account-id>-<region>/query-results/`

1. Run a Query

```bash
aws athena start-query-execution \
  --query-string "SELECT title, release_date FROM \"movies-workshop-db\".\"movies\" LIMIT 5;" \
  --query-execution-context Database=movies-workshop-db \
  --result-configuration OutputLocation=s3://athena-query-results-<your-account-id>-ap-southeast-2/query-results/
```

It should return something like this:

```json

{
    "QueryExecutionId": "9e61b0a6-e5c3-4e80-a8d7-c79178bf30f3"
}
```

2. Get the Query Results using `QueryExecutionId` from the returned result in the previous step.

```bash
aws athena get-query-results \
  --query-execution-id <your-query-execution-id>
```

[Continue to Step 3 - Clean and Transform with AWS Glue DataBrew](../step3-databrew/README.md)
