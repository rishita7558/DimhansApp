# Mood Tracker Feature Documentation

This document explains the mood tracker feature integrated into the DIMHANS Flutter app for alcohol users.

## Overview

The mood tracker is a comprehensive tool designed to help alcohol users monitor their emotional well-being, identify triggers, and track effective coping strategies. It's automatically presented after the self-assessment for users who consume alcohol.

## Features

### 🎯 **Core Functionality**
- **Mood Rating**: 5-point scale (Very Low to Excellent) with emoji indicators
- **Trigger Identification**: Select from common triggers that affect mood
- **Coping Strategy Tracking**: Record what helps manage difficult emotions
- **Notes & Descriptions**: Add personal context to mood entries
- **Bilingual Support**: English and Kannada language support

### 📊 **Analytics & Insights**
- **Mood Trends**: Visual chart showing mood patterns over time
- **Trigger Analysis**: Identify most common mood triggers
- **Coping Strategy Effectiveness**: Track which strategies work best
- **Period Filtering**: View data for 7 days, 30 days, 90 days, or all time
- **Summary Statistics**: Quick overview of entries and average mood

### 🔄 **Integration Points**
- **Assessment Flow**: Automatically appears after alcohol assessment
- **Home Screen**: Quick access button for immediate mood checks
- **Navigation**: Dedicated tab in main navigation
- **Data Persistence**: Cloud storage with offline fallback

## File Structure

```
lib/
├── mood_tracker_screen.dart      # Main mood entry screen
├── mood_history_screen.dart      # Analytics and history view
└── assessment_screen.dart        # Modified to include mood tracker
```

## User Experience Flow

### 1. **Assessment Completion**
- User completes alcohol self-assessment
- If user consumes alcohol (`q1 == 'Yes'`), mood tracker button appears
- Button labeled "Track Your Mood" with mood icon

### 2. **Mood Entry Process**
- **Mood Selection**: Choose from 5 mood levels with visual feedback
- **Description**: Optional notes about current emotional state
- **Triggers**: Select what caused this mood (multiple choice)
- **Coping Strategies**: Choose what helps manage the mood
- **Save/Skip**: Save entry or skip for later

### 3. **Quick Access**
- **Home Screen Button**: "Quick Mood Check" for immediate entries
- **Navigation Tab**: "Mood History" tab for comprehensive view
- **Offline Support**: Works without internet connection

## Technical Implementation

### **Data Storage**
- **Primary**: Firebase Firestore (cloud)
- **Fallback**: SharedPreferences (local)
- **Sync**: Automatic cloud sync when online

### **Data Structure**
```dart
{
  'mood_level': int,           // 1-5 scale
  'mood_description': String,   // User notes
  'triggers': List<String>,     // Selected triggers
  'coping_strategies': List<String>, // Selected strategies
  'timestamp': DateTime,        // Entry time
  'assessment_data': Map        // Linked assessment answers
}
```

### **Triggers Available**
- Stress at work
- Family issues
- Financial problems
- Relationship conflicts
- Health concerns
- Social pressure
- Loneliness
- Past trauma
- Sleep problems
- Physical pain
- Boredom
- Celebration
- Other

### **Coping Strategies Available**
- Deep breathing
- Exercise
- Talking to someone
- Meditation
- Journaling
- Hobbies
- Music
- Nature walk
- Professional help
- Support groups
- Other

## Analytics Features

### **Mood Trend Chart**
- Custom painted line chart
- Shows mood progression over time
- Filled area for visual appeal
- Data points for each entry

### **Trigger Analysis**
- Frequency-based ranking
- Percentage calculations
- Progress bar visualization
- Top 5 triggers display

### **Coping Strategy Analysis**
- Effectiveness tracking
- Usage frequency
- Visual progress indicators
- Strategy recommendations

## Language Support

### **English**
- All UI elements
- Error messages
- Validation text
- Help text

### **Kannada (ಕನ್ನಡ)**
- Form labels
- Button text
- Section headers
- Error messages
- Placeholder text

## Integration with Existing Features

### **Assessment System**
- Seamlessly integrated after completion
- Context-aware (only for alcohol users)
- Preserves assessment data

### **Navigation**
- New tab in bottom navigation
- Consistent with app design
- Easy access from anywhere

### **Authentication**
- User-specific data
- Secure cloud storage
- Privacy protection

## Usage Scenarios

### **Daily Mood Tracking**
1. User completes daily mood check
2. Records current emotional state
3. Identifies triggers and coping strategies
4. Builds pattern recognition over time

### **Crisis Management**
1. User experiences difficult emotions
2. Uses mood tracker to document situation
3. Identifies effective coping strategies
4. Builds resilience through tracking

### **Recovery Progress**
1. Monitor mood improvements over time
2. Track trigger reduction
3. Identify most effective coping methods
4. Celebrate progress and milestones

## Benefits for Alcohol Users

### **Self-Awareness**
- Recognize emotional patterns
- Identify alcohol-related triggers
- Understand mood-alcohol relationships

### **Coping Skill Development**
- Track effective strategies
- Build healthy habits
- Reduce reliance on alcohol

### **Recovery Support**
- Monitor emotional well-being
- Identify relapse risk factors
- Celebrate positive progress

### **Professional Collaboration**
- Share data with counselors
- Track therapy effectiveness
- Support treatment planning

## Future Enhancements

### **Advanced Analytics**
- Machine learning insights
- Predictive mood patterns
- Personalized recommendations

### **Social Features**
- Anonymous community support
- Group mood challenges
- Peer encouragement

### **Integration**
- Calendar integration
- Reminder notifications
- Export capabilities

### **Wellness Tools**
- Breathing exercises
- Guided meditation
- Stress reduction techniques

## Testing

### **User Testing Scenarios**
1. Complete assessment as alcohol user
2. Navigate to mood tracker
3. Enter mood data
4. View analytics
5. Test offline functionality

### **Data Validation**
- Mood level range (1-5)
- Required field validation
- Data persistence verification
- Cloud sync testing

## Troubleshooting

### **Common Issues**
1. **Data not saving**: Check internet connection and Firebase setup
2. **Chart not displaying**: Ensure minimum 2 entries for trend analysis
3. **Language not switching**: Verify language toggle functionality
4. **Navigation errors**: Check import statements and route definitions

### **Debug Information**
- Console logging for data operations
- Error handling with user-friendly messages
- Fallback mechanisms for offline use

## Conclusion

The mood tracker feature provides alcohol users with a powerful tool for emotional self-awareness and recovery support. By integrating seamlessly with the existing assessment system and providing comprehensive analytics, it helps users build healthier coping mechanisms and track their progress toward recovery.

The bilingual support ensures accessibility for Kannada-speaking users, while the offline-first approach guarantees functionality regardless of internet connectivity. This feature represents a significant step toward comprehensive alcohol addiction support and recovery management. 