#317 - Allow user to add Images to Feedback

- Add support for picking and attaching multiple images to feedback submissions.
- Store uploaded feedback images in Firebase Storage and save their URLs.
- Update FeedbackDTO to include image URLs.

#315 - Update Feedback Functionality

- Require at least one star: default rating is one and submissions with rating below one are rejected.
- Cap anonymous feedback spam with five successful submissions per local calendar day, persisted on device; debug clear-all resets the counter keys.
