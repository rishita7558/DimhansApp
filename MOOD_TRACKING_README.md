# Mood Tracking System for DIMHANS App

## Overview
The DIMHANS app now includes a comprehensive mood tracking system that allows users to log their daily moods, track patterns, and view detailed analytics. Each user's mood data is securely stored in Firebase Firestore and associated with their authenticated account.

## Features

### 🚀 Quick Mood Check
- **Simplified Interface**: Quick 5-point mood scale (Very Low to Excellent)
- **Optional Notes**: Add brief descriptions or thoughts
- **Real-time Storage**: Mood entries are immediately saved to Firestore
- **User-specific Data**: Each user sees only their own mood entries

### 📊 Mood History & Analytics
- **Time Period Selection**: View data for week, month, or year
- **Statistical Overview**: Total entries, average mood, mood distribution
- **Visual Analytics**: Progress bars showing mood frequency distribution
- **Detailed Entries**: Complete list of mood entries with timestamps

### 🔐 User Authentication Integration
- **Secure Storage**: Mood data is tied to authenticated user accounts
- **Private Data**: Users can only access their own mood information
- **Real-time Updates**: Data syncs across devices when logged in

## Technical Implementation

### Data Structure
Each mood entry is stored in Firestore with the following structure:

```dart
{
  'mood_level': 1-5,           // 1=Very Low, 5=Excellent
  'mood_description': String,   // Optional user notes
  'timestamp': Timestamp,      // Server timestamp
  'user_id': String,           // Firebase Auth UID
  'user_email': String         // User's email address
}
```

### Database Collections
```
users/
  {user_uid}/
    quick_mood_entries/
      {entry_id}/
        - mood_level
        - mood_description
        - timestamp
        - user_id
        - user_email
```

### Key Components

#### 1. QuickMoodCheckScreen
- **Purpose**: Primary interface for logging daily moods
- **Features**: 
  - 5-point mood scale with emojis and colors
  - Optional text input for notes
  - Recent mood history display
  - Real-time data saving

#### 2. MoodHistoryScreen
- **Purpose**: Detailed analytics and mood history
- **Features**:
  - Time period selection (week/month/year)
  - Statistical summaries
  - Mood distribution charts
  - Complete entry history

#### 3. HomeScreen Integration
- **Quick Mood Check Button**: Orange button for immediate mood logging
- **View Mood History Button**: Outlined button for detailed analytics

## User Experience Flow

### Daily Mood Check
1. User taps "Quick Mood Check" on home screen
2. Selects mood level (1-5) with visual feedback
3. Optionally adds notes or thoughts
4. Taps "Save Mood" to store entry
5. Entry is saved to Firestore and displayed in recent moods

### Viewing Mood History
1. User taps "View Mood History" on home screen
2. Selects time period (week/month/year)
3. Views statistical overview and mood distribution
4. Scrolls through detailed entry list
5. Can switch between time periods for different insights

## Security Features

### Data Privacy
- **User Isolation**: Each user only sees their own mood data
- **Authentication Required**: Must be logged in to access mood features
- **Secure Storage**: Data stored in Firebase with proper user authentication

### Data Validation
- **Mood Level Range**: Ensures mood levels are between 1-5
- **Timestamp Validation**: Uses server timestamps for accuracy
- **User Verification**: Confirms user ID matches authenticated user

## Language Support

### Bilingual Interface
- **English**: Primary language with full feature support
- **Kannada**: Localized interface for regional users
- **Language Toggle**: Easy switching between languages
- **Localized Text**: All UI elements support both languages

## Performance Optimizations

### Efficient Data Loading
- **Pagination**: Limits recent moods to 7 entries for quick display
- **Lazy Loading**: Mood history loads only when requested
- **Caching**: Recent moods cached for immediate display
- **Optimized Queries**: Firestore queries use proper indexing

### User Experience
- **Loading States**: Visual feedback during data operations
- **Error Handling**: Graceful fallbacks for network issues
- **Offline Support**: Local storage fallback when needed
- **Responsive Design**: Works on all screen sizes

## Firebase Configuration Requirements

### Firestore Rules
Ensure your Firestore security rules allow authenticated users to access their own data:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/quick_mood_entries/{entryId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Authentication
- **Email/Password**: Required for user identification
- **Email Verification**: Ensures valid user accounts
- **Session Management**: Secure login/logout handling

## Usage Examples

### Basic Mood Logging
```dart
// User selects mood level 4 (Good)
// Adds note: "Had a productive day at work"
// Saves entry to Firestore
```

### Viewing Analytics
```dart
// User selects "Last Month" period
// Views: 28 total entries, 3.8 average mood
// Sees mood distribution: 20% Excellent, 40% Good, etc.
```

### Data Export
```dart
// All mood data is stored in Firestore
// Can be exported or analyzed using Firebase tools
// Supports integration with external analytics platforms
```

## Future Enhancements

### Planned Features
- **Mood Trends**: Line charts showing mood over time
- **Trigger Analysis**: Identify common mood triggers
- **Coping Strategy Tracking**: Link moods to coping mechanisms
- **Mood Reminders**: Scheduled mood check notifications
- **Social Features**: Anonymous mood sharing (optional)
- **Professional Insights**: Export data for healthcare providers

### Integration Possibilities
- **Health Apps**: Connect with Apple Health, Google Fit
- **Calendar Integration**: Link moods to daily events
- **Weather Data**: Correlate moods with weather conditions
- **Sleep Tracking**: Analyze mood-sleep relationships

## Troubleshooting

### Common Issues
1. **Mood Not Saving**: Check Firebase connection and authentication
2. **History Not Loading**: Verify Firestore permissions and rules
3. **Language Not Switching**: Ensure proper state management
4. **Performance Issues**: Check Firestore query optimization

### Debug Information
- **Console Logs**: Check Flutter console for error messages
- **Firebase Console**: Monitor Firestore usage and errors
- **Network Tab**: Verify API calls are successful
- **Authentication State**: Confirm user is properly logged in

## Support and Maintenance

### Regular Tasks
- **Data Backup**: Ensure Firestore data is regularly backed up
- **Performance Monitoring**: Track query performance and optimize
- **User Feedback**: Collect and implement user suggestions
- **Security Updates**: Keep Firebase SDKs updated

### Monitoring
- **Usage Analytics**: Track feature usage and user engagement
- **Error Rates**: Monitor and fix any recurring issues
- **Performance Metrics**: Ensure fast loading times
- **User Satisfaction**: Regular feedback collection

---

This mood tracking system provides a comprehensive solution for users to monitor their emotional well-being while maintaining privacy and security. The system is designed to be both simple for daily use and powerful for long-term analysis.
