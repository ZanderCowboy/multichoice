/// Client-side limits for feedback image attachments.
abstract final class FeedbackImageLimits {
  static const int maxCount = 3;
  static const int maxBytesPerImage = 5 * 1024 * 1024;
}

const feedbackMaxImagesReachedMessage =
    'You can attach up to 3 images per feedback report.';

const feedbackImageTooLargeMessage =
    'Each image must be 5 MB or smaller.';

const feedbackImageEmptyMessage =
    'The selected image is empty or could not be read.';
