# 🎉 AAC TalkSeed v1.0.0 Release Notes

**Release Date**: November 13, 2024  
**Version**: 1.0.0 (Build 1)  
**Package**: com.talkseed

---

## 📱 Download

### APK (Direct Install)
- **File**: `app-release.apk`
- **Size**: 50.6 MB
- **Use**: Direct installation on Android devices
- **Minimum Android**: 5.0 (API 21)
- **Target Android**: 14 (API 36)

### AAB (Google Play Store)
- **File**: `app-release.aab`
- **Size**: 43.7 MB
- **Use**: Upload to Google Play Console
- **Optimized**: Dynamic delivery enabled

---

## ✨ Features

### Core Functionality
- 🎴 **AAC Card Management**
  - 12 pre-loaded sample cards
  - Add, edit, and delete custom cards
  - Support for external image URLs
  - Customizable background colors

- 📁 **Smart Category System**
  - 5 default categories (감정, 욕구, 인사, 활동, 전체)
  - Sidebar navigation with expand/collapse
  - Drag-and-drop reordering
  - Icon and color customization

- 🔊 **Korean TTS Integration**
  - Tap card to speak
  - Adjustable speed, volume, and pitch
  - Visual feedback with SnackBar
  - Offline TTS support

- 💾 **Hybrid Storage System**
  - Local: Hive (fast offline access)
  - Cloud: Firebase Firestore (auto backup)
  - Bidirectional synchronization
  - Works offline completely

- 🌐 **Multi-Platform Support**
  - ✅ Android (this release)
  - ✅ Web (browser access)
  - 🔜 iOS (planned)

### UI/UX
- Material Design 3
- Accessibility optimized
- Large touch targets
- High contrast colors
- Intuitive navigation
- SafeArea implementation

---

## 🔥 Firebase Integration

### Cloud Features
- Automatic data backup to Firestore
- Cross-device synchronization
- Real-time data updates
- Offline-first architecture

### Collections
- `categories` - User categories
- `aac_cards` - Communication cards

**Note**: Firebase is optional - app works fully offline with Hive local storage.

---

## 🛠️ Technical Details

### Framework
- Flutter 3.35.4
- Dart 3.9.2
- Material Design 3

### Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| firebase_core | 3.6.0 | Firebase initialization |
| cloud_firestore | 5.4.3 | Cloud database |
| hive | 2.2.3 | Local NoSQL database |
| hive_flutter | 1.1.0 | Flutter Hive integration |
| flutter_tts | 4.2.0 | Text-to-speech |
| cached_network_image | 3.4.1 | Image caching |
| provider | 6.1.5+1 | State management |

### Build Configuration
- **Min SDK**: 21 (Android 5.0 Lollipop)
- **Target SDK**: 36 (Android 14)
- **Compile SDK**: 36
- **Java Version**: 11
- **Kotlin Version**: 1.9+

---

## 📦 Installation

### APK Installation
1. Download `app-release.apk`
2. Enable "Install from Unknown Sources" on your device
3. Open the APK file to install
4. Grant required permissions

### Google Play Store (Coming Soon)
- AAB uploaded and ready for review
- Awaiting Play Store approval

---

## 🔐 Permissions

### Required
- **Internet**: For Firebase cloud sync (optional)
- **Storage**: For local data storage

### Optional
- All features work without internet
- Firebase sync requires network connection

---

## 🐛 Known Issues

None reported in this release.

---

## 🚀 What's Next (Roadmap)

### v1.1.0 (Planned)
- [ ] iOS platform support
- [ ] User authentication (Firebase Auth)
- [ ] Multi-user account support
- [ ] Cloud image storage (Firebase Storage)
- [ ] Offline image upload
- [ ] Voice recording for custom sounds

### v1.2.0 (Planned)
- [ ] Multiple languages support
- [ ] Customizable TTS voices
- [ ] Folder organization for cards
- [ ] Export/Import data
- [ ] Themes and color schemes
- [ ] Widget support

---

## 📝 Changelog

### [1.0.0] - 2024-11-13

#### Added
- Initial release of AAC TalkSeed
- 12 sample AAC cards across 4 categories
- Category management with sidebar
- Korean TTS voice output
- Hive local storage
- Firebase Firestore cloud sync
- Material Design 3 UI
- Web platform support
- Android APK/AAB builds

#### Technical
- Flutter 3.35.4 implementation
- Firebase integration
- Hybrid storage architecture
- Release signing configuration

---

## 🙏 Acknowledgments

This app is created to help people with communication difficulties. We believe AAC technology should be free and accessible to everyone.

**Special Thanks To**:
- The Flutter team for the amazing framework
- Firebase team for cloud infrastructure
- Open source community for packages
- All users and testers

---

## 📞 Support & Feedback

- **GitHub Issues**: [Report bugs or request features](https://github.com/Kkamnyang2/kkamnyang_open/issues)
- **Email**: [Contact for support]
- **Discussions**: [Community discussions](https://github.com/Kkamnyang2/kkamnyang_open/discussions)

---

## 📄 License

MIT License - Free to use, modify, and distribute.

---

**Made with ❤️ for everyone who needs a voice**

🗣️ AAC TalkSeed - Free Communication for All
