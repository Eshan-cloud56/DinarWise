# Google Play SMS & Call Log Permissions Declaration Guide

This document outlines the exact responses and justifications for submitting **DinarWise** to the **Google Play Console** under the **SMS and Call Log Permissions Policy**.

---

## 1. Permitted Use Case Selection

In the Google Play Console **Permissions Declaration Form**:

- **Core Functionality Category**:  
  Select: **"Financial-based transaction tracking and management"** (or **"SMS-based financial transactions tracking"**).

---

## 2. Core Functional Need & Detailed Description

### Primary App Purpose
**DinarWise** is a personal finance, expense tracking, and budgeting application tailored for users in Saudi Arabia and the GCC.

### How `RECEIVE_SMS` Is Used in DinarWise
1. **Real-Time Transaction Detection**: In Saudi Arabia and the GCC, banks (such as Al Rajhi, SNB, Alinma, Riyad Bank, Bank AlJazira, STC Pay, and urpay) do not provide open webhook APIs for consumer debit/mada/credit card purchases. Instead, they instantly send an SMS alert to the account holder upon every POS swipe, online purchase, or ATM deposit.
2. **Local Extraction**: DinarWise registers an Android `BroadcastReceiver` listening exclusively for incoming SMS alerts (`android.provider.Telephony.SMS_RECEIVED`). When an SMS arrives from a supported financial institution:
   - DinarWise parses the message body **locally on-device** using a deterministic regex/heuristic engine.
   - It extracts the transaction amount, currency (SAR, AED, etc.), merchant/recipient, and transaction type (outgoing expense vs incoming deposit).
   - Card numbers (e.g. `*4321`) are masked and filtered out so they are never confused with amounts.
   - OTPs, 2FA security codes, and marketing messages are strictly rejected and discarded.
3. **Interactive User Notification**: DinarWise displays a high-priority local system notification:
   - *Outgoing*: "A payment of SAR 120 was detected. Add to DinarWise?"
   - *Incoming*: "SAR 2,500 was credited to your ABC Bank account. Add it to DinarWise Income?"
4. **Interactive Actions**:
   - **Add / Review**: Opens the DinarWise Add Expense / Add Income screen with the detected fields pre-filled.
   - **Dismiss**: Silently dismisses the notification.
5. **Zero Auto-Saving**: DinarWise **never** writes or commits transactions to the database automatically. The user maintains complete control and must explicitly review and tap "Add expense" or "Save" to record the transaction.

---

## 3. Data Minimization & Privacy Guarantees

| Principle | Implementation in DinarWise |
| :--- | :--- |
| **Minimum Permission Requested** | Only `android.permission.RECEIVE_SMS` is requested. The app **DOES NOT** request `READ_SMS`, `SEND_SMS`, `WRITE_SMS`, or MMS permissions. |
| **No Access to SMS History** | Because `READ_SMS` is not requested or declared, DinarWise has zero access to past SMS history, personal text threads, or inbox messages. |
| **100% On-Device Processing** | All parsing and classification occurs in local memory inside the Flutter Dart VM on the device. |
| **Zero Remote Egress** | Raw SMS message bodies, sender phone numbers, and transaction contents are **never** transmitted across the network, never sent to Cloudflare, never sent to Firebase, and never stored on any remote server. |
| **Local SHA-256 Deduplication** | To prevent repeated alerts, only a one-way SHA-256 hash of the transaction event is cached locally in encrypted SharedPreferences. |
| **Strict OTP/2FA Rejection** | Any SMS containing verification keywords (`رمز التحقق`, `كود`, `OTP`, `verification code`, `one-time password`, `do not share`) is rejected immediately. |

---

## 4. Prominent In-App Disclosure & Opt-In Consent Flow

In strict compliance with Google Play's Prominent Disclosure and User Consent Policy:

1. **Opt-In by Default**: The Automatic Transaction Detection feature is **disabled by default** (`sms_detection_enabled = false`).
2. **Pre-Permission Disclosure**: The Android system runtime permission (`RECEIVE_SMS`) is **never** requested automatically upon app launch or onboarding.
3. **User Action Required**: The permission is requested **only** when the user navigates to **Settings** and explicitly turns on the **Automatic Transaction Detection** toggle.
4. **Prominent Disclosure Modal**:
   - Before the OS permission dialog is triggered, DinarWise presents an explicit in-app dialog entitled:  
     **"SMS Transaction Detection"** / **"الكشف عن المعاملات عبر الرسائل النصية"**.
   - The dialog clearly specifies:
     - What data is accessed: Incoming transaction SMS messages from financial institutions.
     - Why: To detect expenses and income and generate prefilled suggestions.
     - Privacy guarantee: 100% on-device processing; no SMS text is ever uploaded or shared.
     - User control: Transactions are never auto-saved without confirmation.
   - If the user taps **"Not Now"** / **"Dismiss"**:
     - The system permission prompt is **NOT** displayed.
     - The toggle remains **OFF**.
   - If the user taps **"Agree & Enable"**:
     - The Android system permission dialog for `RECEIVE_SMS` is presented.
     - If the user grants permission: The toggle switches to **ON**.
     - If the user denies permission: The toggle remains **OFF** and an informational snackbar explains that SMS permission is required for automatic detection.

---

## 5. Justification: Why Alternative APIs Cannot Be Used

1. **SMS Retriever API**:
   - The SMS Retriever API is strictly designed for automated phone number verification (OTP / 2FA) where the sending SMS contains an 11-character hash code generated specifically for the app.
   - Bank transaction notifications come from banks with standard formats and **cannot** contain app-specific hash strings.
2. **Notification Listener Service (`BIND_NOTIFICATION_LISTENER_SERVICE`)**:
   - Requires full access to **all** notifications from **all** applications installed on the user's phone (including private messaging apps, emails, and sensitive alerts).
   - This represents a severe privacy overreach compared to `RECEIVE_SMS`, which only listens for incoming SMS broadcasts.
3. **Accessibility Service**:
   - Google Play policy strictly prohibits using Accessibility APIs for non-accessibility purposes.
4. **Open Banking / Financial APIs**:
   - Open Banking APIs in Saudi Arabia and the GCC are restricted to institutional entities and currently do not support real-time consumer push triggers for POS debit/mada card payments.

---

## 6. Reviewer Demonstration & Verification Steps

For the Google Play reviewer video demonstration:

1. **Open DinarWise** on an Android device or emulator.
2. Navigate to **Settings** (gear icon in the navigation bar).
3. Scroll down to **Automatic Transaction Detection**. Note that it is **OFF** by default.
4. Tap the **Privacy details** link or tap the switch to **ON**.
5. Observe the **Prominent Disclosure Modal** detailing:
   - Specific data accessed: Incoming bank transaction alerts.
   - Purpose: Suggesting prefilled expenses and income.
   - Privacy guarantee: 100% on-device processing, zero remote upload.
   - User control: Zero auto-saving.
6. Tap **"Not Now"** -> Verify that the toggle remains OFF and no system dialog was invoked.
7. Tap the switch again -> In the modal, tap **"Agree & Enable"**.
8. Observe the standard Android system dialog requesting SMS permission. Tap **Allow**.
9. The toggle is now **ON** and a confirmation message appears.
10. Send a test transaction SMS (via emulator SMS tool or ADB):
    - *Sender*: `AlRajhiBank`
    - *Body*: `شراء: 120.50 ر.س لدى بنده بطاقة: *4321`
11. Observe the notification: *"A payment of SAR 120.50 was detected. Add to DinarWise?"*
12. Tap **"Add / Review"** -> Verify that the Add Expense screen opens with amount `120.50` and merchant `بنده` pre-filled, awaiting user confirmation before saving.
