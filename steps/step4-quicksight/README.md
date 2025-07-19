# Step 4: Create a QuickSight Account

> **Amazon QuickSight** is a cloud-native business intelligence tool that lets you build interactive dashboards directly from AWS data sources like S3, Athena, or Redshift.
>
> 💡 Think of it as: _“Excel meets Tableau — but native to AWS and serverless.”_

## 🧭 1. Set Up Your QuickSight Account

1. Go to the [QuickSight Console](https://quicksight.aws.amazon.com)
2. Click **“Sign up for QuickSight”**
3. Choose the **Standard or Enterprise edition** (you can start with a free trial)
4. Enter your preferred **notification email**
5. Under **QuickSight account name**, enter: `movie-insights`
6. Select your region (e.g., **Asia Pacific (Sydney)** / `ap-southeast-2`)
7. Choose the **QuickSight-managed role** (default)
8. Grant access to your **S3 bucket**: `movie-data-bucket-<account-id>-<region>`
9. Deselect any optional add-ons

⏳ **Wait 2–5 minutes** for your account to be provisioned.

## 📂 2. Connect to the Cleaned S3 Data in QuickSight!

Your cleaned CSV output from the DataBrew job lives at a path like:

```bash
s3://movie-data-bucket-<account-id>-ap-southeast-2/clean/movies/*
```

> ⚠️ CloudFormation is limited
> You can deploy some QuickSight resources via CloudFormation, but support is limited. For now, we'll configure the dataset manually.

Before we follow the steps, we need to prepare the Manifest File. QuickSight uses a manifest file to understand where to find your data and how to interpret it.
In the `step4-quicksight` folder you see a file `quicksight-movie-manifest.json`. Replace <account-id> with your actual AWS account ID. Now the manifest file is ready to be used.

1. In the QuickSight console, go to Datasets
👉 [QuickSight Datasets Console](https://ap-southeast-2.quicksight.aws.amazon.com/sn/start/data-sets)
2. Click New dataset
3. Choose S3 as the source
4. Enter a name: CleanedMoviesData (or any other name you like for your source)
5. Under Manifest file path, select from URL to Upload option
6. Select the manifest file we just updated.
7. Click on Visualize to start building.

<img width="607" height="308" alt="Screenshot 2025-07-19 at 2 01 17 pm" src="https://github.com/user-attachments/assets/d21941b4-69e0-46ec-962a-f109926fed94" />

## 3. Build Your Dashboard in QuickSight

Once your dataset is imported and loaded, it's time to explore and visualise your data!

> 💡 Think of this like creating your own mini IMDb analytics dashboard.

### Suggested Visuals to Try

Here are a few ideas for charts and insights you can build:

#### Popular Genres by Count

- **Visual type**: Pie or bar chart
- **X-axis**: `genre`
- **Value**: `none` (picks count of records)

> 💡 This helps you see which genres appear most frequently in your dataset.

#### Top Spoken Languages

- **Visual type**: Pie or bar chart
- **Dimension**: `spoken_languages`
- **Value**: `none` (picks count of records)
- **Filter**: Pick the most common languages

> 💡 Identify which languages dominate the movie dataset.

#### Average Popularity by Genre

- **Visual type**: Horizontal bar or heatmap
- **Group by**: `genre`
- **Metric**: `avg(popularity)` (be careful, defaults to Sum)

> 💡 Helps surface which genres trend as the most "popular" overall.

### Save Your Dashboard

Once your visuals are created:

1. Click "Publish"
2. Name it: Movie Insights Dashboard

> 💡 After publishing, you can even **share dashboards** with teammates or export them as PDFs.
