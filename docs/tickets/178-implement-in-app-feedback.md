# [Implementing In-App Feedback with Firebase Cloud Functions](https://github.com/ZanderCowboy/multichoice/issues/178)

This guide will walk you through setting up in-app feedback for your application using Firebase Cloud Functions, Firestore, and email notifications. It is designed for users with no prior context or experience with Firebase Cloud Functions.

---

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Setting Up Firebase CLI](#setting-up-firebase-cli)
4. [Initializing Firebase in Your Project](#initializing-firebase-in-your-project)
5. [Setting Up Email Notifications](#setting-up-email-notifications)
6. [Configuring Environment Variables](#configuring-environment-variables)
7. [Deploying Cloud Functions](#deploying-cloud-functions)
8. [Troubleshooting & Common Issues](#troubleshooting--common-issues)
9. [Additional Resources](#additional-resources)

---

## Overview

This document explains how to:
- Set up Firebase in your project
- Configure and deploy Cloud Functions for in-app feedback
- Set up email notifications for feedback
- Manage environment variables securely

---

## Prerequisites

- A Google account
- Node.js installed ([Download Node.js](https://nodejs.org/))
- Access to the Firebase Console ([console.firebase.google.com](https://console.firebase.google.com/))

---

## Setting Up Firebase CLI

1. **Install the Firebase CLI globally:**
   ```sh
   npm install -g firebase-tools
   ```
2. **Restart your terminal** to ensure the CLI is available.
3. **Verify the installation:**
   ```sh
   firebase --version
   ```
4. **Login to Firebase:**
   ```sh
   firebase login
   ```

---

## Initializing Firebase in Your Project

1. **Navigate to your project directory:**
   ```sh
   cd path/to/your/project
   ```
2. **Initialize Firebase:**
   ```sh
   firebase init
   ```
   - Select the following features when prompted:
     - Firestore: Configure security rules and indexes files for Firestore
     - Functions: Configure a Cloud Functions directory and its files
   - Use an existing Firebase project or create a new one as needed.
   - Choose TypeScript for Cloud Functions language.
   - Enable ESLint for code quality.
   - Allow overwriting of existing config files if you want to reset them.
   - Install dependencies when prompted.

---

## Setting Up Email Notifications

To receive feedback via email, you need a dedicated email account (e.g., a Gmail address) and an app password for secure access.

1. **Create a dedicated email address** (e.g., `yourapp.feedback@gmail.com`).
2. **Enable App Passwords** (for Gmail):
   - Go to your Google Account > Security > App passwords
   - Generate an app password for "Mail"
   - Save this password securely (you will use it in the next step)

---

## Configuring Environment Variables

Firebase Cloud Functions use environment variables for sensitive data like email credentials. Set these using the Firebase CLI:

1. **Get your Firebase project ID:**
   ```sh
   firebase projects:list
   ```
2. **Set environment variables for your function:**
   ```sh
   firebase functions:config:set email.user="<your-email>" email.pass="<your-app-password>" --project <your-project-id>
   ```
   - Replace `<your-email>` and `<your-app-password>` with your actual credentials.
   - Replace `<your-project-id>` with your Firebase project ID.

---

## Deploying Cloud Functions

1. **Navigate to your project root directory.**
2. **Deploy your functions:**
   ```sh
   firebase deploy --only functions
   ```
   - This will upload your Cloud Functions to Firebase and make them available for use.

---

## Troubleshooting & Common Issues

- **PowerShell Script Execution Policy Error:**
  - If you see `firebase.ps1 cannot be loaded`, run:
    ```sh
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    ```
- **Dependency Warnings:**
  - Some npm packages may show deprecation warnings. These can usually be ignored unless they cause errors.
- **Cloud Function Cleanup Policy:**
  - When deploying, you may be prompted to set a cleanup policy for container images. Choose how many days to keep images (e.g., 1 day) to avoid unnecessary billing.

---

## Additional Resources

- [Firebase Functions Environment Config](https://firebase.google.com/docs/functions/config-env?gen=2nd#env-variables)
- [Google Cloud SDK](https://cloud.google.com/sdk)
- [Firebase Documentation](https://firebase.google.com/docs/)

---

## Example: Enabling Google Cloud Eventarc (Optional)

If you need to enable Google Cloud Eventarc for advanced event handling:
```sh
# Set PowerShell policy (if needed)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Enable Eventarc API
gcloud services enable eventarc.googleapis.com --project=<your-project-id>
```

---

## Notes

- The Cloud Function code can be found in the `functions/` directory of your project.
- Make sure to keep your app passwords and credentials secure and never commit them to version control.
