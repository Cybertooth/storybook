# Get latest Storybook Production URLs from Google Cloud
$ErrorActionPreference = "Stop"

$REGION = "us-central1"

Write-Host "Fetching production URLs for Storybook..." -ForegroundColor Cyan

try {
    $BACKEND_URL = gcloud run services describe storybook-backend --platform managed --region $REGION --format 'value(status.url)'
    $FRONTEND_URL = gcloud run services describe storybook-frontend --platform managed --region $REGION --format 'value(status.url)'

    Write-Host ""
    Write-Host "Backend API URL:  $BACKEND_URL/api/v1" -ForegroundColor Green
    Write-Host "Frontend Web URL: $FRONTEND_URL" -ForegroundColor Green
    Write-Host ""
}
catch {
    Write-Host "Error: Could not retrieve URLs. Ensure you are logged into gcloud and the services exist." -ForegroundColor Red
}
