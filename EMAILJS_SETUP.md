# EmailJS Integration Setup Guide

Your contact form is now integrated with EmailJS! Follow these steps to complete the setup.

## Configuration Required

You have the following constants in your code that need to be updated:

### 1. **Service ID** ✓ (Already provided)
- **Location**: `lib/main.dart` (line ~7)
- **Current Value**: `service_xu8fwps`
- **Status**: ✅ Configured

### 2. **Template ID** 🔴 (REQUIRED)
- **Location**: 
  - `lib/main.dart` (line ~8) - Change `emailjsTemplateId`
  - `web/index.html` - Not directly needed (handled via Dart)
- **How to get it**:
  1. Log in to your [EmailJS Dashboard](https://dashboard.emailjs.com/)
  2. Go to **Email Templates**
  3. Create a new template or use an existing one
  4. Copy the **Template ID**
  5. Replace `YOUR_TEMPLATE_ID` in `lib/main.dart`

### 3. **Public Key** 🔴 (REQUIRED)
- **Locations**:
  - `web/index.html` (line ~28) - In the `emailjs.init()` call
  - `lib/main.dart` (line ~9) - In `emailjsPublicKey` constant
- **How to get it**:
  1. Log in to your [EmailJS Dashboard](https://dashboard.emailjs.com/)
  2. Go to **Account** → **API Keys**
  3. Copy your **Public Key**
  4. Replace both `YOUR_PUBLIC_KEY` values:
     - In `web/index.html`: `emailjs.init("YOUR_PUBLIC_KEY")`
     - In `lib/main.dart`: `const String emailjsPublicKey = 'YOUR_PUBLIC_KEY';`

### 4. **Recipient Email** 🔴 (REQUIRED)
- **Location**: `lib/main.dart` (line ~10) - Change `emailjsRecipientEmail`
- **Value**: The email address where contact form submissions should be sent
- **Example**: `support@bhartiysadbhavnamanch.org`

## Template Variables

When creating your EmailJS template, use these variables for form data:

```
{{from_name}}      - Visitor's name
{{from_email}}     - Visitor's email
{{phone}}          - Visitor's phone number
{{message}}        - Visitor's message
{{to_email}}       - Recipient email
```

### Example Template Content:
```
Subject: New Contact Form Submission from {{from_name}}

Name: {{from_name}}
Email: {{from_email}}
Phone: {{phone}}

Message:
{{message}}
```

## Complete Setup Checklist

- [ ] Get Service ID: `service_xu8fwps` ✓
- [ ] Create EmailJS Template (or use existing one)
- [ ] Get Template ID from EmailJS Dashboard
- [ ] Get Public Key from EmailJS Account Settings
- [ ] Update `emailjsTemplateId` in `lib/main.dart`
- [ ] Update `emailjsPublicKey` in `web/index.html`
- [ ] Update `emailjsPublicKey` in `lib/main.dart`
- [ ] Update `emailjsRecipientEmail` in `lib/main.dart`
- [ ] Test the contact form

## Quick Reference

### File: `lib/main.dart` (Lines 7-10)
```dart
const String emailjsServiceId = 'service_xu8fwps';
const String emailjsTemplateId = 'YOUR_TEMPLATE_ID'; // ← Update this
const String emailjsPublicKey = 'YOUR_PUBLIC_KEY'; // ← Update this
const String emailjsRecipientEmail = 'YOUR_RECIPIENT_EMAIL'; // ← Update this
```

### File: `web/index.html` (Line 28)
```javascript
emailjs.init("YOUR_PUBLIC_KEY"); // ← Update this
```

## Testing

After configuration:
1. Run the Flutter web app: `flutter run -d chrome`
2. Fill out the contact form
3. Click "Send Message"
4. Check the recipient email for the submission

## Troubleshooting

### No email received?
- Check your EmailJS Dashboard for error logs
- Verify all credentials are correct
- Ensure template variables match your configuration
- Check spam/junk folders

### "Error sending message" in UI?
- Check browser console for detailed error messages
- Verify public key is correct
- Ensure template ID exists and is correct
- Verify service ID is active in your EmailJS account

### Service ID not recognized?
- Log in to EmailJS and verify `service_xu8fwps` is your actual service ID
- If different, update it in `lib/main.dart` (line 7)

## Support

- EmailJS Docs: https://www.emailjs.com/docs/
- EmailJS Dashboard: https://dashboard.emailjs.com/
- For issues, check the browser console (F12 → Console tab)
