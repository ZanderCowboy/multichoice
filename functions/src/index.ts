import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {defineString} from "firebase-functions/params";
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
  region: "europe-west1",
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
      ${feedback.userEmail ? `<p><strong>User Email:</strong> 
        ${feedback.userEmail}</p>` : ""}
      <p><strong>Timestamp:</strong> 
      ${feedback.timestamp ?
    feedback.timestamp.toDate().toLocaleString() : "N/A"}</p>
    `,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log("Feedback notification email sent successfully");
  } catch (error) {
    console.error("Error sending feedback notification email:", error);
  }
});
