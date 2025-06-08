# Setting up Firebase Functions

This document details the setup and implementation of Firebase Functions for the feedback notification system.

## Prerequisites

1. Install Node.js
2. Install Firebase CLI:
```bash
npm install -g firebase-tools
```
3. Install Google Cloud SDK (for environment variables)

## Project Structure

The Firebase Functions are located in the `functions/` directory with the following structure:
```
functions/
├── src/
│   └── index.ts         # Main functions file
├── lib/                 # Compiled JavaScript files
├── package.json         # Dependencies and scripts
├── tsconfig.json        # TypeScript configuration
└── .eslintrc.js        # ESLint configuration
```

## Understanding TypeScript and index.ts

### What is TypeScript?
TypeScript is a superset of JavaScript that adds static typing. This means you can specify the type of variables, function parameters, and return values, which helps catch errors during development.

### Key TypeScript Concepts in Our Code

#### 1. Imports
```typescript
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { defineString } from "firebase-functions/params";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";
```
- `import` statements bring in functionality from other files/packages
- `{ onDocumentCreated }` is a named import - we're specifically importing this function
- `* as admin` imports everything from the package and namespaces it under 'admin'

#### 2. Environment Variables with TypeScript
```typescript
const emailUser = defineString("EMAIL_USER");
const emailPass = defineString("EMAIL_PASS");
```
- `defineString` is a type-safe way to handle environment variables
- It ensures the variables are strings and exist
- `.value()` is used to get the actual value when needed

#### 3. Firebase Admin Initialization
```typescript
admin.initializeApp();
```
- Initializes Firebase Admin SDK
- Required to interact with Firebase services

#### 4. Email Transport Configuration
```typescript
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: emailUser.value(),
    pass: emailPass.value(),
  },
});
```
- Creates an email transport configuration
- Uses the environment variables we defined earlier
- `.value()` retrieves the actual values from our environment variables

#### 5. Function Definition
```typescript
export const onNewFeedback = onDocumentCreated({
  document: "feedback/{feedbackId}",
  region: "europe-west1"
}, async (event) => {
  // Function body
});
```
Breaking this down:
- `export` makes the function available to other files
- `const` declares a constant variable
- `onDocumentCreated` is a Firebase function that triggers when a document is created
- The first parameter is an object with configuration:
  - `document`: Specifies which document to watch ("feedback/{feedbackId}")
  - `region`: Specifies where the function runs
- The second parameter is an async function that handles the event

#### 6. Event Handling
```typescript
const feedback = event.data?.data();
if (!feedback) {
  console.error("No feedback data found");
  return;
}
```
- `event.data?.data()` uses optional chaining (`?.`) to safely access nested properties
- If `event.data` is null/undefined, it won't try to call `.data()`
- TypeScript helps ensure we handle potential null values

#### 7. Email Options
```typescript
const mailOptions = {
  from: emailUser.value(),
  to: emailUser.value(),
  subject: `New Feedback: ${feedback.category || "General"}`,
  html: `...`
};
```
- Creates an object with email configuration
- Uses template literals (`` ` ``) for string interpolation
- `||` operator provides fallback values if properties are undefined

#### 8. Error Handling
```typescript
try {
  await transporter.sendMail(mailOptions);
  console.log("Feedback notification email sent successfully");
} catch (error) {
  console.error("Error sending feedback notification email:", error);
}
```
- `try/catch` blocks handle potential errors
- `await` is used with async operations
- TypeScript ensures proper error handling

### TypeScript Configuration (tsconfig.json)
```json
{
  "compilerOptions": {
    "module": "NodeNext",
    "esModuleInterop": true,
    "moduleResolution": "nodenext",
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "outDir": "lib",
    "sourceMap": true,
    "strict": true,
    "target": "es2017"
  }
}
```
Key settings:
- `strict`: Enables all strict type checking options
- `noImplicitReturns`: Ensures all code paths return a value
- `sourceMap`: Generates source maps for debugging
- `target`: Specifies ECMAScript target version

## Function Implementation

The feedback notification function is implemented in `functions/src/index.ts`:

```typescript
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { defineString } from "firebase-functions/params";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";

const emailUser = defineString("EMAIL_USER");
const emailPass = defineString("EMAIL_PASS");

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: emailUser.value(),
    pass: emailPass.value(),
  },
});

export const onNewFeedback = onDocumentCreated({
  document: "feedback/{feedbackId}",
  region: "europe-west1"
}, async (event) => {
  const feedback = event.data?.data();
  if (!feedback) {
    console.error("No feedback data found");
    return;
  }

  const mailOptions = {
    from: emailUser.value(),
    to: emailUser.value(),
    subject: `New Feedback: ${feedback.category || "General"}`,
    html: `
      <h2>New Feedback Received</h2>
      <p><strong>Category:</strong> ${feedback.category || "General"}</p>
      <p><strong>Rating:</strong> ${feedback.rating || "N/A"}/5</p>
      <p><strong>Message:</strong> ${feedback.message || "No message"}</p>
      <p><strong>Device Info:</strong> ${feedback.deviceInfo || "N/A"}</p>
      <p><strong>App Version:</strong> ${feedback.appVersion || "N/A"}</p>
      ${feedback.userEmail ? `<p><strong>User Email:</strong> ${feedback.userEmail}</p>` : ""}
      <p><strong>Timestamp:</strong> ${feedback.timestamp ? feedback.timestamp.toDate().toLocaleString() : "N/A"}</p>
    `,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log("Feedback notification email sent successfully");
  } catch (error) {
    console.error("Error sending feedback notification email:", error);
  }
});
```

## Environment Variables

The function uses environment variables for email configuration. These are set using the Firebase Console or gcloud CLI:

1. Go to Firebase Console → Functions → Configuration
2. Add these environment variables:
   - `EMAIL_USER`: Your Gmail address
   - `EMAIL_PASS`: Your Gmail app password

Or using gcloud CLI:
```bash
gcloud functions deploy onNewFeedback --set-env-vars EMAIL_USER="your-gmail@gmail.com",EMAIL_PASS="your-app-password"
```

## Gmail Setup

1. Enable 2-factor authentication in your Google Account
2. Generate an App Password:
   - Go to Google Account → Security → App Passwords
   - Select "Mail" and your device
   - Use the generated password (including spaces) in the environment variables

## Deployment

Deploy the functions using:
```bash
firebase deploy --only functions
```

## Troubleshooting

### Functions Not Showing in Console
- Ensure the function is properly exported in `index.ts`
- Check that the deployment was successful
- Verify the region matches your Firebase project settings

### Email Not Sending
- Verify Gmail app password is correct (including spaces)
- Check environment variables are set correctly
- Ensure the Gmail account has 2-factor authentication enabled
- Check function logs in Firebase Console for specific errors

### PowerShell Issues
If you encounter PowerShell execution policy issues:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

## Dependencies

Key dependencies in `package.json`:
```json
{
  "dependencies": {
    "firebase-admin": "^12.6.0",
    "firebase-functions": "^6.0.1",
    "nodemailer": "^7.0.3"
  }
}
```

## Testing

1. Submit feedback through the app
2. Check Firebase Console → Functions → Logs for execution
3. Verify email receipt
4. Check Firestore for feedback document creation 