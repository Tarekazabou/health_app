# 🔥 Firebase Setup Guide for HealthTrack App

## ⚠️ CRITICAL: Firebase Services Must Be Enabled

Your backend Firebase connection is working, but the following services need to be enabled in Google Cloud Console:

---

## 📋 Step-by-Step Firebase Setup

### 1. Enable Firestore Database

**Status:** ❌ **REQUIRED - Currently Disabled**

#### How to Enable:
1. Go to: https://console.firebase.google.com/project/health-track-app-9e7cf/firestore
2. Click **"Create Database"**
3. Choose **"Start in production mode"** (or test mode for development)
4. Select location: **us-central** (or closest to you)
5. Click **"Enable"**

**OR** Use direct link:
https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=health-track-app-9e7cf

⏱️ **Wait 1-2 minutes** after enabling for the API to propagate.

---

### 2. Enable Firebase Authentication

**Status:** ❌ **REQUIRED - Email/Password Sign-in Disabled**

#### Error you're seeing:
```
POST https://identitytoolkit.googleapis.com/v1/accounts:signUp 400 (Bad Request)
```

#### How to Enable:
1. Go to: https://console.firebase.google.com/project/health-track-app-9e7cf/authentication/providers
2. Click on **"Email/Password"** provider
3. Click **"Enable"** toggle
4. Check **"Email/Password"** (first option)
5. Optionally enable **"Email link (passwordless sign-in)"** if needed
6. Click **"Save"**

---

### 3. Configure Firestore Security Rules

**Status:** ⚠️ **Recommended**

After enabling Firestore, set up security rules:

1. Go to: https://console.firebase.google.com/project/health-track-app-9e7cf/firestore/rules
2. Replace with these rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection - only authenticated users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User subcollections (profile, vitals, activities, etc.)
      match /{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

3. Click **"Publish"**

---

### 4. Verify Backend Connection

After enabling services, test the connection:

```powershell
cd back_end
python test_firestore.py
```

**Expected Output:**
```
✅ Firebase initialized successfully with Firestore access
✅ Firebase connected successfully!
📝 TEST 1: Creating a test user...
✅ User created with ID: xxxxx
```

---

### 5. Configure Flutter Web App

**Update API Key Settings (if needed):**

If you see issues with the web app, you may need to add your domain to Firebase:

1. Go to: https://console.firebase.google.com/project/health-track-app-9e7cf/settings/general
2. Scroll to **"Your apps"**
3. Find your web app
4. Add authorized domains:
   - `localhost`
   - `127.0.0.1`
   - Your production domain

---

## ✅ Verification Checklist

After completing setup, verify:

- [ ] Firestore Database is created and active
- [ ] Email/Password authentication is enabled
- [ ] Security rules are configured
- [ ] Backend test passes successfully
- [ ] Flutter web app can register/login users

---

## 🧪 Testing the Setup

### Test Backend API:
```powershell
# Start backend
cd back_end
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# In browser, go to:
http://localhost:8000/docs
```

### Test Flutter Web App:
```powershell
# Run web app
cd front_end
flutter run -d edge  # or chrome
```

### Test Registration Flow:
1. Open the app
2. Click "Sign Up"
3. Enter email, username, password
4. Submit
5. Should successfully create account

---

## 🔐 Security Best Practices

### ⚠️ IMPORTANT: Revoke Compromised Service Account Key

You shared your private key publicly. **You MUST revoke it:**

1. Go to: https://console.cloud.google.com/iam-admin/serviceaccounts?project=health-track-app-9e7cf
2. Find: `firebase-adminsdk-fbsvc@health-track-app-9e7cf.iam.gserviceaccount.com`
3. Click on it → **KEYS** tab
4. Find key with ID: `a9a1459437e8d4dace8881d0b3fddda77f1561a2`
5. Delete it
6. Create a new key
7. Download and replace `serviceAccountKey.json`

### Production Security:
- [ ] Use environment variables for sensitive data
- [ ] Enable Firebase App Check
- [ ] Set up proper CORS policies
- [ ] Use HTTPS only
- [ ] Implement rate limiting
- [ ] Enable audit logging

---

## 📊 Current Status Summary

| Service | Status | Action Required |
|---------|--------|-----------------|
| Firebase Admin SDK | ✅ Working | None |
| Service Account Auth | ✅ Working | Revoke old key |
| Firestore Database | ❌ Disabled | **Enable Now** |
| Firebase Authentication | ❌ Email/Password Off | **Enable Now** |
| Backend API | ✅ Running | None |
| Flutter Web App | ⚠️ Errors | Fix after enabling Firebase |

---

## 🆘 Troubleshooting

### Error: "Cloud Firestore API has not been used"
**Solution:** Enable Firestore using link in Step 1

### Error: "400 Bad Request" on signup
**Solution:** Enable Email/Password authentication in Step 2

### Error: "PERMISSION_DENIED"
**Solution:** Check Firestore security rules in Step 3

### Backend shows "DEMO MODE"
**Solution:** Restart backend after enabling Firestore

---

## 📞 Support

If you encounter issues:
1. Check Firebase Console for service status
2. Review security rules
3. Check browser console for detailed errors
4. Verify API keys are correct
5. Ensure services are enabled (wait 1-2 minutes after enabling)

---

**Created:** November 17, 2025  
**Last Updated:** November 17, 2025
