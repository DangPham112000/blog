# GitHub Actions Setup Guide

To allow GitHub Actions to automatically deploy your Hugo site to `DangPham112000/dangpham112000.github.io`, you need to set up authentication by providing a Personal Access Token (PAT).

Follow these steps to set it up:

### Step 1: Generate a Personal Access Token (PAT)
1. Go to your GitHub account settings: [Settings > Developer settings > Personal access tokens > Tokens (classic)](https://github.com/settings/tokens).
2. Click **Generate new token** and choose **Generate new token (classic)**.
3. Give it a descriptive note (e.g., "Hugo Action Deploy Token").
4. Under **Select scopes**, check the **repo** box (this gives full control of private repositories and is necessary to push to the other repo).
5. Scroll down and click **Generate token**.
6. **Copy the generated token immediately!** (You won't be able to see it again).

### Step 2: Add the PAT as a Repository Secret
1. Go to the repository where you manage your source code (this current repo).
2. Click on **Settings** in the top navigation bar.
3. In the left sidebar, go to **Secrets and variables > Actions**.
4. Click the **New repository secret** button.
5. In the **Name** field, enter: `DEPLOY_TOKEN`.
6. In the **Secret** field, paste the Personal Access Token you copied in Step 1.
7. Click **Add secret**.

### Step 3: Trigger the deployment
- The GitHub Action is configured to run automatically whenever you push code to the `main` branch.
- You can also trigger it manually from the **Actions** tab in this repository.

That's it! Your GitHub Action workflow (`deploy.yml`) is now fully configured to use this token to deploy your site.
