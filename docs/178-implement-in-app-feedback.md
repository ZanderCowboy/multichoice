# [Implement In-App Feedback](https://github.com/ZanderCowboy/multichoice/issues/178)

## Setting up Email Notifications

### Create dedicated email address

### Enable "App Passwords" for Gmail

App Passwords
Email: <email@gmail.com>
Pass: <Found in .env>

### Set Up Environment Config in Firebase

Get project id by running `firebase projects:list`

`firebase functions:config:set email.user="zkotze.dev@gmail.com" email.pass="tims omtf cxhz xldm" --project <project id>`

### Use the Cloud Function

Found in `functions/`

### Deploy the Function

> Requires `firebase init` in root directory 

```sh
firebase deploy --only functions
```

## Setting up Firebase CLI

1. Install Node.js

2. Install the Firebase CLI globally

`npm install -g firebase-tools`

3. Restart terminal

4. Verify installation

`firebase --version`

5. Run firebase ocmmands 

`firebase login` etc

## Running `firebase init`

```sh
PS G:\Programming\Projects\multichoice> firebase init

     ######## #### ########  ######## ########     ###     ######  ########
     ##        ##  ##     ## ##       ##     ##  ##   ##  ##       ##
     ######    ##  ########  ######   ########  #########  ######  ######
     ##        ##  ##    ##  ##       ##     ## ##     ##       ## ##
     ##       #### ##     ## ######## ########  ##     ##  ######  ########

You're about to initialize a Firebase project in this directory:

  G:\Programming\Projects\multichoice

✔ Are you ready to proceed? Yes
✔ Which Firebase features do you want to set up for this directory? Press Space to select features, then Enter to confirm your choices. Firestore: Configure
 security rules and indexes files for Firestore, Functions: Configure a Cloud Functions directory and its files

=== Project Setup

First, let's associate this project directory with a Firebase project.
You can create multiple project aliases by running firebase use --add,
but for now we'll just set up a default project.

✔ Please select an option: Use an existing project
✔ Select a default Firebase project for this directory: multichoice-412309 (Multichoice)
i  Using project multichoice-412309 (Multichoice)

=== Firestore Setup
i  firestore: ensuring required API firestore.googleapis.com is enabled...
+  firestore: required API firestore.googleapis.com is enabled

Firestore Security Rules allow you to define how and when to allow
requests. You can keep these rules in your project directory
and publish them with firebase deploy.

✔ What file should be used for Firestore Rules? firestore.rules
i  Downloaded the existing Firestore Security Rules from the Firebase console
✔ File firestore.rules already exists. Overwrite? No
i  Skipping write of firestore.rules

Firestore indexes allow you to perform complex queries while
maintaining performance that scales with the size of the result
set. You can keep index definitions in your project directory
and publish them with firebase deploy.

✔ What file should be used for Firestore indexes? firestore.indexes.json
i  Downloaded the existing Firestore indexes from the Firebase console
+  Wrote firestore.rules
+  Wrote firestore.indexes.json

=== Functions Setup
Let's create a new codebase for your functions.
A directory corresponding to the codebase will be created in your project
with sample code pre-configured.

See https://firebase.google.com/docs/functions/organize-functions for
more information on organizing your functions using codebases.

Functions can be deployed with firebase deploy.

✔ What language would you like to use to write Cloud Functions? TypeScript
✔ Do you want to use ESLint to catch probable bugs and enforce style? Yes
✔ File functions/package.json already exists. Overwrite? Yes
+  Wrote functions/package.json
+  Wrote functions/.eslintrc.js
+  Wrote functions/tsconfig.dev.json
+  Wrote functions/tsconfig.json
+  Wrote functions/src/index.ts
✔ File functions/.gitignore already exists. Overwrite? Yes
+  Wrote functions/.gitignore
✔ Do you want to install dependencies with npm now? Yes
npm warn deprecated inflight@1.0.6: This module is not supported, and leaks memory. Do not use it. Check out lru-cache if you want a good and tested way to coalesce async requests by a key value, which is much more comprehensive and powerful.
npm warn deprecated rimraf@3.0.2: Rimraf versions prior to v4 are no longer supported
npm warn deprecated glob@7.2.3: Glob versions prior to v9 are no longer supported
npm warn deprecated @humanwhocodes/config-array@0.13.0: Use @eslint/config-array instead
npm warn deprecated @humanwhocodes/object-schema@2.0.3: Use @eslint/object-schema instead
npm warn deprecated eslint@8.57.1: This version is no longer supported. Please see https://eslint.org/version-support for other options.

added 449 packages, removed 1 package, changed 11 packages, and audited 688 packages in 54s

146 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities

+  Wrote configuration info to firebase.json
+  Wrote project information to .firebaserc

+  Firebase initialization complete!
```

## Issues and Problems

- `firebase.ps1 cannot be loaded` -> `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`

## Setting up Blaze Firebase plan

## Setting up Cloud Functions

## Deploying Cloud Functions

## Setting up ENV in `functions/`

<https://firebase.google.com/docs/functions/config-env?gen=2nd#env-variables>

## Adding Google Cloud SDK

<https://cloud.google.com/sdk>

```
PS C:\Users\Zander Kotze> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
PS C:\Users\Zander Kotze> gcloud services enable eventarc.googleapis.com --project=multichoice-412309
Operation "operations/acat.p2-82796040762-729a13b0-684a-4d99-a478-50810080b7e3" finished successfully.
```

## Look into 

```
+  functions[onNewFeedback(europe-west1)] Successful create operation.
!  functions: No cleanup policy detected for repositories in europe-west1. This may result in a small monthly bill as container images accumulate over time.
✔ How many days do you want to keep container images before they're deleted? 1
i  functions: Configuring cleanup policy for repository in europe-west1. Images older than 1 days will be automatically deleted.
i  functions: Configured cleanup policy for repository in europe-west1.
```
