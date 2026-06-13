/* eslint-disable max-len, indent, object-curly-spacing, quotes */
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { defineString } from "firebase-functions/params";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";

const emailUser = defineString("EMAIL_USER");
const emailPass = defineString("EMAIL_PASS");

const DEV_PROJECT_ID = "multichoice-app-develop";
const PROD_PROJECT_ID = "multichoice-412309";

admin.initializeApp();

/**
 * Returns a short environment label for the deployed Firebase project.
 * @return {string} DEV, PROD, or the raw project ID when unknown.
 */
function getEnvironmentLabel(): string {
  const projectId = process.env.GCLOUD_PROJECT;
  if (projectId === DEV_PROJECT_ID) {
    return "DEV";
  }
  if (projectId === PROD_PROJECT_ID) {
    return "PROD";
  }
  return projectId ?? "UNKNOWN";
}

/**
 * Creates a Nodemailer transporter for sending emails using Gmail.
 * @return {nodemailer.Transporter} A configured Nodemailer transporter
 */
function createTransporter() {
  return nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: emailUser.value(),
      pass: emailPass.value(),
    },
  });
}

export const onNewFeedback = onDocumentCreated({
  document: "feedback/{feedbackId}",
  region: "europe-west1",
}, async (event) => {
  const feedback = event.data?.data();
  if (!feedback) {
    console.error("No feedback data found");
    return;
  }

  const environment = getEnvironmentLabel();

  const mailOptions = {
    from: emailUser.value(),
    to: emailUser.value(),
    subject: `[${environment}] New Feedback: ${feedback.category || "General"}`,
    html: `
      <h2>New Feedback Received</h2>
      <p><strong>Environment:</strong> ${environment}</p>
      <p><strong>Category:</strong> ${feedback.category || "General"}</p>
      <p><strong>Rating:</strong> ${feedback.rating || "N/A"}/5</p>
      <p><strong>Message:</strong> ${feedback.message || "No message"}</p>
      <p><strong>Device Info:</strong> ${feedback.deviceInfo || "N/A"}</p>
      <p><strong>App Version:</strong> ${feedback.appVersion || "N/A"}</p>
      ${feedback.userEmail ? `<p><strong>User Email:</strong> 
        ${feedback.userEmail}</p>` : ""}
      <p><strong>Timestamp:</strong> 
      ${feedback.timestamp ?
        feedback.timestamp.toDate().toLocaleString() : "N/A"}</p>
      ${feedback.imageUrls && feedback.imageUrls.length > 0 ? `
      <h3>Attached Images:</h3>
      <div style="display: flex; gap: 10px; flex-wrap: wrap;">
        ${feedback.imageUrls.map((url: string) =>
          `<img src="${url}" style="max-width: 300px; max-height: 300px; border: 1px solid #ccc; padding: 4px;" />`
        ).join("")}
      </div>` : ""}
    `,
  };

  try {
    await createTransporter().sendMail(mailOptions);
    console.log("Feedback notification email sent successfully");
  } catch (error) {
    console.error("Error sending feedback notification email:", error);
  }
});
