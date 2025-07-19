## Step 1: Create Your S3 Bucket and Upload Movie Data

### What this step does:
- Creates a personal S3 bucket for you
- You'll upload a small movie metadata file to this bucket

### Deploy the S3 stack:
From the project root folder, run:

```bash
./deploy.sh step1-s3
```

This will create a bucket named like: `movie-data-bucket-123456789012-ap-southeast-2`

To test it you can either locate the bucket via AWS Console or by running this script:

```bash
aws cloudformation describe-stacks \
  --stack-name step1-s3 \
  --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" \
  --output text
```

Press on `q` to exit the view.

### Upload the dataset to the bucket

In real life scenario the file is being dropped to the bucket by another system. But for the demo purpose we drop it ourselves.

#### Option A: Upload via AWS Console

```bash
aws s3 cp data/movies_metadata.csv \
  s3://<your-bucket-name>/raw/movies/
```

#### Option B: Upload via AWS Console

1. Go to your Amazon S3 and locate the bucekt.
2. Click Upload
3. Create or choose a folder path: raw/movies/
4. Upload [the file](../../data/movies_metadata.csv) from this repository.
