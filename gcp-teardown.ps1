Write-Host "Tearing down GCP services for Storybook..."

$PROJECT_ID = gcloud config get-value project
$REGION = "us-central1"
$DB_INSTANCE = "storybook-db"

Write-Host "Deleting Cloud Run frontend service..."
gcloud run services delete storybook-frontend --region $REGION --quiet

Write-Host "Deleting Cloud Run backend service..."
gcloud run services delete storybook-backend --region $REGION --quiet

Write-Host "Deleting Cloud SQL instance..."
gcloud sql instances delete $DB_INSTANCE --quiet

Write-Host "Teardown complete."
