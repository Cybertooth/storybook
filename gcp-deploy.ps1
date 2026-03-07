$ErrorActionPreference = "Stop"

Write-Host "Starting Storybook GCP Deployment Script..."

$PROJECT_ID = gcloud config get-value project
$REGION = "us-central1"
$DB_INSTANCE = "storybook-db"
$DB_NAME = "storybook"
$DB_USER = "storybook"
$DB_PASS = "storybookpass" # Note: In a real production scenario, this should be a secure secret managed by Secret Manager

Write-Host "Project ID: $PROJECT_ID"

Write-Host "1. Provisioning Cloud SQL Instance (This may take ~5-10 minutes)..."
gcloud sql instances create $DB_INSTANCE --database-version=POSTGRES_15 --tier=db-f1-micro --region=$REGION

Write-Host "2. Creating Database..."
gcloud sql databases create $DB_NAME --instance=$DB_INSTANCE

Write-Host "3. Creating Database User..."
gcloud sql users create $DB_USER --instance=$DB_INSTANCE --password=$DB_PASS

Write-Host "4. Building Backend Docker Image..."
gcloud builds submit --config cloudbuild-backend.yaml .

Write-Host "5. Deploying Backend to Cloud Run..."
gcloud run deploy storybook-backend `
    --image "gcr.io/$PROJECT_ID/storybook-backend" `
    --region $REGION `
    --add-cloudsql-instances "$PROJECT_ID:$REGION:$DB_INSTANCE" `
    --set-env-vars DATABASE_URL="postgresql://$DB_USER:$DB_PASS@localhost/$DB_NAME?host=/cloudsql/$PROJECT_ID:$REGION:$DB_INSTANCE" `
    --allow-unauthenticated

Write-Host "6. Retrieving Backend URL..."
$BACKEND_URL = gcloud run services describe storybook-backend --platform managed --region $REGION --format 'value(status.url)'
$VITE_API_URL = "$BACKEND_URL/api/v1"
Write-Host "Backend URL is $BACKEND_URL"

Write-Host "7. Building Frontend Docker Image..."
gcloud builds submit --config cloudbuild-frontend.yaml --substitutions=_VITE_API_URL=$VITE_API_URL .

Write-Host "8. Deploying Frontend to Cloud Run..."
gcloud run deploy storybook-frontend `
    --image "gcr.io/$PROJECT_ID/storybook-frontend" `
    --region $REGION `
    --port 80 `
    --allow-unauthenticated

Write-Host "Deployment completed successfully!"
$FRONTEND_URL = gcloud run services describe storybook-frontend --platform managed --region $REGION --format 'value(status.url)'
Write-Host "Access your live app at: $FRONTEND_URL"
