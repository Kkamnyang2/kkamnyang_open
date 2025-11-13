# 🗣️ AAC TalkSeed

무료 AAC(보완대체의사소통) 앱 - 의사소통에 어려움을 겪는 분들을 위한 무료 소통 도구

[![Flutter](https://img.shields.io/badge/Flutter-3.35.4-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 프로젝트 소개

AAC TalkSeed는 의사소통에 어려움을 겪는 분들(자폐 스펙트럼, 실어증, 발달장애 등)을 위한 **무료 의사소통 도구**입니다. 유료 AAC 앱의 한계를 극복하고 누구나 쉽게 사용할 수 있는 앱을 목표로 개발되었습니다.

### ✨ 주요 기능

- 🎴 **AAC 카드 관리**
  - 이미지 + 텍스트 카드
  - 카드 추가/수정/삭제
  - 12개 기본 샘플 카드 제공
  
- 📁 **카테고리 시스템**
  - 왼쪽 사이드바 네비게이션
  - 아이콘과 색상으로 구분
  - 드래그앤드롭 순서 변경
  - 확장/축소 가능한 UI

- 🔊 **한국어 TTS (음성 출력)**
  - 카드 탭하면 자동 음성 출력
  - 속도/음량/음높이 조절 가능
  - 시각적 피드백 제공

- 💾 **하이브리드 저장소**
  - 로컬: Hive (빠른 오프라인 접근)
  - 클라우드: Firebase Firestore (자동 백업)
  - 양방향 자동 동기화

- 🌐 **멀티플랫폼 지원**
  - ✅ Android (APK 빌드 가능)
  - ✅ Web (브라우저에서 즉시 사용)
  - 🔜 iOS (향후 지원 예정)

## 🚀 시작하기

### 필요 사항

- Flutter 3.35.4+
- Dart 3.9.2+
- Firebase 프로젝트 (선택사항 - 로컬만 사용 가능)

### 설치 방법

```bash
# 저장소 클론
git clone https://github.com/Kkamnyang2/kkamnyang_open.git
cd kkamnyang_open

# 의존성 설치
flutter pub get

# Hive 타입 어댑터 생성
flutter pub run build_runner build --delete-conflicting-outputs

# 앱 실행
flutter run
```

### Firebase 설정 (선택사항)

Firebase 클라우드 동기화를 사용하려면:

1. Firebase 콘솔에서 프로젝트 생성
2. Firestore Database 생성 (asia-northeast3 권장)
3. `google-services.json` 다운로드 → `android/app/` 에 배치
4. `lib/firebase_options.dart` 업데이트

**참고**: Firebase 없이도 로컬 Hive 저장소로 모든 기능 사용 가능합니다!

## 📦 기술 스택

### Flutter & Dart
- **Flutter**: 3.35.4 (고정 버전)
- **Dart**: 3.9.2
- **Material Design**: 3

### 저장소
- **Hive**: 2.2.3 (로컬 NoSQL)
- **hive_flutter**: 1.1.0
- **Firebase Core**: 3.6.0
- **Cloud Firestore**: 5.4.3

### 기능
- **flutter_tts**: 4.2.0 (한국어 TTS)
- **cached_network_image**: 3.4.1 (이미지 캐싱)
- **provider**: 6.1.5+1 (상태 관리)

## 🏗️ 프로젝트 구조

```
lib/
├── main.dart                          # 앱 진입점
├── firebase_options.dart              # Firebase 구성
├── models/                            # 데이터 모델
│   ├── aac_card.dart                  # AAC 카드 모델
│   └── category_index.dart            # 카테고리 모델
├── services/                          # 비즈니스 로직
│   ├── hybrid_storage_service.dart    # 하이브리드 저장소
│   ├── firestore_service.dart         # Firestore 서비스
│   ├── aac_service.dart               # Hive 카드 서비스
│   ├── category_service.dart          # Hive 카테고리 서비스
│   └── tts_service.dart               # TTS 서비스
└── screens/                           # UI 화면
    ├── home_screen_with_sidebar.dart  # 메인 화면
    ├── card_edit_screen.dart          # 카드 편집
    ├── category_management_screen.dart # 카테고리 관리
    └── category_edit_screen.dart      # 카테고리 편집
```

## 💡 사용 방법

### 기본 사용

1. **카드 선택**: 카드를 탭하면 음성으로 읽어줍니다
2. **카테고리 전환**: 왼쪽 사이드바에서 카테고리 선택
3. **카드 관리**: 카드 롱프레스 → 수정/삭제 메뉴

### 카드 추가

1. 우측 하단 "카드 추가" 버튼 클릭
2. 텍스트, 이미지 URL, 카테고리, 배경색 입력
3. 저장 → 자동으로 로컬 + 클라우드에 저장

### 카테고리 관리

1. 왼쪽 사이드바 하단 "카테고리 관리" 클릭
2. 추가/수정/삭제/순서변경 가능
3. 드래그앤드롭으로 순서 조정

## 🎨 디자인 철학

- **접근성 우선**: 큰 터치 영역, 명확한 아이콘, 고대비 색상
- **직관적 UI**: 복잡한 설정 없이 즉시 사용 가능
- **빠른 응답**: 로컬 우선 저장으로 즉각적인 피드백
- **오프라인 지원**: 인터넷 없어도 모든 기능 사용 가능

## 🔐 보안 & 개인정보

- **로컬 저장소 우선**: 모든 데이터는 기본적으로 사용자 기기에 저장
- **Firebase는 선택사항**: 클라우드 백업은 사용자가 원할 때만 활성화
- **데이터 독립성**: Firebase 없이도 완전히 작동
- **개인정보 수집 없음**: 계정 없이 사용 가능

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자유롭게 사용, 수정, 배포할 수 있습니다.

## 🤝 기여하기

버그 리포트, 기능 제안, Pull Request를 환영합니다!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 문의

- **GitHub Issues**: [이슈 생성](https://github.com/Kkamnyang2/kkamnyang_open/issues)
- **Email**: [프로젝트 관련 문의]

## 🙏 감사의 말

이 프로젝트는 의사소통에 어려움을 겪는 분들과 그 가족들을 위해 만들어졌습니다. 
AAC 기술이 더 많은 사람들에게 무료로 제공되길 바라는 마음으로 개발했습니다.

---

**Made with ❤️ for everyone who needs a voice**
