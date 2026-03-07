# Google Cloud Deployment

This project uses Google Cloud Platform (GCP) for hosting. The core services utilized are:
- **Cloud Run**: Serverless compute used for both the backend (NestJS) and frontend (React) services.
- **Cloud SQL**: Managed PostgreSQL 15 database instance (`db-f1-micro` tier) used to store application data persistently.
- **Cloud Build**: Used to containerize the Dockerfiles and build deployment images.
- **Container Registry**: Used to store the built Docker container images.

## Deployment Scripts

We have provided Windows PowerShell scripts to automatically manage the full lifecycle of the infrastructure. You can find these scripts in the root directory.

### Bringing Services Up
To provision all GCP resources (Cloud SQL Database, Backend Cloud Run, and Frontend Cloud Run) automatically from scratch, you can run the deployment script. 

> [!WARNING]  
> The database creation step can take anywhere from 5 to 10 minutes to finish provisioning.

```powershell
.\gcp-deploy.ps1
```

**What the script does:**
1. Retrieves your current GCP project configurations.
2. Provisions a `db-f1-micro` PostgreSQL 15 Cloud SQL instance and sets up the user/database.
3. Builds the `storybook-backend` Docker image via Cloud Build.
4. Deploys the backend to Cloud Run, injecting the Cloud SQL connection string.
5. Dynamically fetches the newly deployed Backend URL.
6. Builds the `storybook-frontend` Docker image via Cloud Build, injecting the dynamic Backend API URL at build speed.
7. Deploys the frontend to Cloud Run and outputs the live public frontend URL.

### Tearing Services Down
If you want to stop incurring costs or simply start fresh, you can use the teardown script to delete the active deployment.

> [!CAUTION]  
> Running the teardown script will completely delete the Cloud SQL database and all of its data. This cannot be easily reversed unless you took a manual snapshot.

```powershell
.\gcp-teardown.ps1
```

**What the script does:**
1. Deletes the `storybook-frontend` Cloud Run service.
2. Deletes the `storybook-backend` Cloud Run service.
3. Deletes the `storybook-db` Cloud SQL instance (which drops all persistent data).

Note: The script does *not* delete the compiled Docker images from your Container Registry, though they only cost a negligible storage fee if left.
