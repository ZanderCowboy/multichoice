# Notification System Setup

## New Features Added

### 1. Enhanced Concurrency Management

- Specific concurrency groups for each workflow
- Version management isolation
- PR-specific concurrency handling

### 2. Version Conflict Resolution

- Automatic retry mechanism (3 attempts)
- Smart conflict detection and resolution
- Improved version comparison logic

### 3. Rollback Mechanism

- Automatic version rollback on failures
- Manual rollback action available
- Audit trail for rollback operations

### 4. Comprehensive Notification System

- Multi-channel notifications (Slack, Discord, Email, GitHub Issues)
- Rich deployment information with formatting
- Automatic issue creation for failed deployments

## Required Secrets

Add these to your GitHub repository secrets:

```bash
DEPLOYMENT_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
DEPLOYMENT_EMAIL_RECIPIENTS=dev-team@company.com,ops@company.com
```

## Webhook Setup

### Slack

1. Create Slack app → Incoming Webhooks
2. Copy webhook URL to `DEPLOYMENT_WEBHOOK_URL`

### Discord

1. Server Settings → Integrations → Webhooks
2. Copy webhook URL to `DEPLOYMENT_WEBHOOK_URL`

## Usage

The notification system automatically:
- Sends success/failure notifications for all environments
- Creates GitHub issues for failed deployments
- Provides rich deployment information
- Handles version conflicts automatically

## Troubleshooting Notification

- Check webhook URL format and permissions
- Verify secrets are properly configured
- Review workflow logs for detailed error messages

## Notification Message Format

The notification system generates rich, formatted messages:

```sh
✅ **Deployment success**
🎯 **Environment:** production
📦 **Version:** 1.2.3
🌿 **Branch:** main
👤 **Author:** john-doe
🔗 **PR:** #123 - Add new feature
📝 **Commit:** a1b2c3d4
💬 **Message:** feat: add new feature
⏰ **Time:** 2024-01-15 10:30:00 UTC
🔗 **Repository:** https://github.com/owner/repo
🔗 **PR Link:** https://github.com/owner/repo/pull/123
```

## Environment-Specific Features

### Develop Environment

- Notifications for successful builds and Firebase distribution
- Automatic tag creation
- Version bumping with build number increment

### Staging Environment

- Notifications for Google Play internal track releases
- RC version handling
- Pre-production validation

### Production Environment

- Notifications for Google Play production releases
- GitHub release creation
- APK artifact upload
- Critical deployment tracking

## Troubleshooting

### Common Issues

1. **Webhook Not Sending**
   - Check webhook URL format
   - Verify webhook permissions
   - Check network connectivity

2. **Version Conflicts**
   - The system will automatically retry up to 3 times
   - Check logs for conflict resolution attempts
   - Manual intervention may be required for complex conflicts

3. **Email Notifications Not Working**
   - Verify email service configuration
   - Check API keys and permissions
   - Review email service logs

### Debug Mode

Enable debug logging by adding this to your workflow:

```yaml
env:
  ACTIONS_STEP_DEBUG: true
  ACTIONS_RUNNER_DEBUG: true
```

## Best Practices

1. **Webhook Security**
   - Use HTTPS URLs only
   - Rotate webhook URLs regularly
   - Monitor webhook usage

2. **Notification Management**
   - Don't send too many notifications
   - Use appropriate channels for different environments
   - Include relevant stakeholders

3. **Version Management**
   - Review version bumps before merging
   - Use appropriate labels for version types
   - Monitor version conflicts

4. **Rollback Strategy**
   - Have a clear rollback procedure
   - Test rollback mechanisms regularly
   - Document rollback decisions

## Monitoring and Analytics

The notification system provides:
- Deployment success/failure rates
- Environment-specific metrics
- Response times for notifications
- Version conflict frequency

## Future Enhancements

1. **Advanced Analytics Dashboard**
2. **SMS Notifications**
3. **Custom Notification Templates**
4. **Integration with Monitoring Tools**
5. **Automated Rollback Triggers**

## Support

For issues or questions:
1. Check the workflow logs
2. Review this documentation
3. Create an issue in the repository
4. Contact the DevOps team
