import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import * as nodemailer from 'nodemailer';

admin.initializeApp();

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: functions.config().email.user,
        pass: functions.config().email.pass,
    },
});

export const onNewFeedback = functions.firestore
    .document('feedback/{feedbackId}')
    .onCreate(async (snap, context) => {
        const feedback = snap.data();

        const mailOptions = {
            from: 'your-app@example.com',
            to: 'your-support@example.com',
            subject: `New Feedback: ${feedback.category || 'General'}`,
            html: `
        <h2>New Feedback Received</h2>
        <p><strong>Category:</strong> ${feedback.category || 'General'}</p>
        <p><strong>Rating:</strong> ${feedback.rating}/5</p>
        <p><strong>Message:</strong> ${feedback.message}</p>
        <p><strong>Device Info:</strong> ${feedback.deviceInfo}</p>
        <p><strong>App Version:</strong> ${feedback.appVersion}</p>
        ${feedback.userEmail ? `<p><strong>User Email:</strong> ${feedback.userEmail}</p>` : ''}
        <p><strong>Timestamp:</strong> ${feedback.timestamp.toDate().toLocaleString()}</p>
      `,
        };

        try {
            await transporter.sendMail(mailOptions);
            console.log('Feedback notification email sent successfully');
        } catch (error) {
            console.error('Error sending feedback notification email:', error);
        }
    }); 