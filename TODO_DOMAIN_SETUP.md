# Custom Domain Setup for Android Integration

To ensure the Android app uses a stable API URL that never changes (even if backend infrastructure is recreated), follow these steps to map a custom subdomain (e.g., `api.riju.dev`) to your Cloud Run backend.

## Prerequisites
- You must own the domain `riju.dev`.
- You must have access to the Squarespace Domain Dashboard for `riju.dev`.
- Your `storybook-backend` service must be deployed on Google Cloud Run.

---

## Step 1: Verify Ownership & Initiate Mapping in GCP
1. Go to the **Google Cloud Console** and navigate to your **Cloud Run** services.
2. Click on the **Manage Custom Domains** button (usually located near the top of the Cloud Run dashboard).
3. Click **Add Mapping**.
4. **Select Service:** Choose your `storybook-backend` service.
5. **Select Domain:**
   - If `riju.dev` is not in the dropdown list, click "Verify a new domain". This will redirect you to Google Webmaster Central.
   - Follow the instructions to copy a `TXT` record. Log into Squarespace, go to your domain's DNS Settings, add the `TXT` record, and click verify in Google.
6. Once the domain is verified in the dropdown, specify your chosen subdomain in the base path field (e.g., type `api` to create `api.riju.dev`).
7. Click **Continue**.

## Step 2: Update DNS Records in Squarespace
After you click Continue, Google Cloud will provide you with a specific DNS record to point traffic to their servers. 

1. Log in to your **Squarespace** account and navigate to the **Domain Dashboard**.
2. Click on **riju.dev** and go to **DNS Settings**.
3. Scroll down to the **Custom Records** section and click **Add Record**.
4. Fill out the record exactly as GCP instructed. It will normally look like this:
   - **Type:** `CNAME`
   - **Host/Alias:** `api` (or whatever subdomain you chose)
   - **Data/Target/Value:** `ghs.googlehosted.com.` *(Note: copy it exactly as GCP gives it to you, sometimes the trailing dot is required).*
5. Save the DNS record in Squarespace.

## Step 3: Wait for SSL Validation
1. Go back to the **Cloud Run Custom Domains** page in Google Cloud.
2. You will see your new mapping with a green spinning icon. This indicates Google is waiting for the DNS changes to propagate globally and is generating a free automatic SSL/TLS certificate.
3. This process usually takes **15 to 30 minutes**, but can occasionally take up to an hour depending on DNS propagation.
4. **Do not** attempt to use the URL in your browser or Android app until the certificate has finished generating (the spinner will turn into a green checkmark).

Once the green checkmark appears, your custom domain is live! Your Android app can safely hardcode `https://api.riju.dev/api/v1` as its permanent backend URL.
