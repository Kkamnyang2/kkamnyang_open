# 🗣️ TalkSeed AAC - 무료 의사소통 앱

**TalkSeed AAC**는 언어 장애가 있는 분들을 위한 무료 AAC (Augmentative and Alternative Communication) 웹 애플리케이션입니다.

## ✨ 주요 기능

### 📱 핵심 기능
- **카드 기반 의사소통**: 카테고리별로 정리된 카드를 클릭하여 문장 구성
- **직접 입력**: 키보드로 직접 텍스트 입력 가능
- **한국어 TTS**: ResponsiveVoice API를 사용한 자연스러운 한국어 음성 출력
- **인포그래픽 그리드**: 7x10 그리드 (70개 셀)로 빠른 단어 선택

### 🎨 카드 관리
- **카드 추가/수정/삭제**: 사용자가 원하는 카드를 자유롭게 관리
- **이미지 업로드**: 
  - 📷 앨범에서 선택
  - 📷 카메라로 촬영
  - 🌐 외부 URL 사용
- **카테고리 시스템**: 음식, 감정, 인사, 요청, 일상 등 분류
- **즐겨찾기**: ⭐ 자주 사용하는 카드 즐겨찾기 등록

### 💬 문장 구성
- **유연한 입력**: 카드 선택 + 키보드 직접 입력 혼합
- **보조 단어**: 조사, 동사, 형용사 빠른 추가
- **자주 쓰는 문장**: 자주 사용하는 문장 저장 및 재사용
- **문장 편집**: 입력한 문장 수정 및 삭제

### 🎯 사용자 편의
- **오프라인 작동**: 인터넷 연결 없이도 사용 가능 (localStorage 사용)
- **반응형 디자인**: 모바일, 태블릿, 데스크톱 모두 지원
- **태블릿 최적화**: 가로 모드에서 한 화면에 모든 요소 표시

## 🚀 사용 방법

### 온라인 사용
GitHub Pages에서 바로 사용하세요:
👉 **[TalkSeed AAC 열기](https://kkamnyang2.github.io/kkamnyang_open/)**

### 오프라인 사용
1. 저장소 다운로드 또는 클론
```bash
git clone https://github.com/Kkamnyang2/kkamnyang_open.git
```

2. `index.html` 파일을 브라우저로 열기

또는 로컬 서버 실행:
```bash
cd kkamnyang_open
python3 -m http.server 8000
# 브라우저에서 http://localhost:8000 접속
```

## 📖 기능 상세 가이드

### 1. 카드 추가하기
1. 우측 상단 **➕** 버튼 클릭
2. 텍스트 입력 (예: "물")
3. 이미지 선택 (3가지 방법):
   - 📷 앨범에서 선택
   - 📷 사진 촬영
   - 🌐 URL 입력
4. 카테고리 및 배경색 선택
5. **저장** 버튼 클릭

### 2. 문장 만들기
1. **카드 클릭**: 카드를 클릭하여 단어 추가
2. **직접 입력**: 입력 필드에 키보드로 입력
3. **인포그래픽 그리드**: 📊 버튼 클릭 → 그리드에서 선택
4. **보조 단어**: 하단 바에서 조사/동사/형용사 추가
5. **음성 출력**: 🔊 버튼 클릭

### 3. 카테고리 관리
1. 좌측 사이드바 하단 **카테고리 관리** 클릭
2. 새 카테고리 추가:
   - 이름 입력
   - 아이콘 선택 (Material Icons)
   - 배경색 선택
3. 기존 카테고리 삭제 가능

### 4. 인포그래픽 그리드
- 하단 문장 입력 바의 **📊 그리드 버튼** 클릭
- 7행 x 10열 (70개 셀) 그리드 표시
- 셀 클릭 시 입력 필드에 단어 추가
- 색상별 분류:
  - 🟡 대명사 (나, 너, 우리, 그거, 이거, 저거)
  - 🟣 의문사 (무엇?, 누구?, 어디?, 언제?, 왜?, 어떻게?)
  - 🟤 부사 (더, 다시, 그만, 같이, 많이, 조금)
  - 🔵 상태/크기
  - 🟡 위치/방향
  - 🟢 동사

## 🛠️ 기술 스택

- **HTML5/CSS3**: 순수 웹 기술
- **Vanilla JavaScript**: 프레임워크 없이 가볍게 구현
- **Material Icons**: Google Material Design 아이콘
- **ResponsiveVoice API**: 고품질 한국어 TTS
- **Web Speech API**: TTS 폴백
- **localStorage**: 오프라인 데이터 저장

## 📱 지원 환경

- **브라우저**: Chrome, Firefox, Safari, Edge (최신 버전)
- **디바이스**: 
  - 📱 모바일 (Android, iOS)
  - 💻 태블릿 (가로/세로 모드)
  - 🖥️ 데스크톱

## 📂 프로젝트 구조

```
aac_html_app_v2/
├── index.html          # 메인 HTML 파일
├── css/
│   └── style.css      # 전체 스타일시트
├── js/
│   ├── app.js         # 메인 애플리케이션 로직
│   ├── storage.js     # localStorage 데이터 관리
│   └── tts.js         # TTS 엔진 관리
└── README.md          # 프로젝트 문서
```

## 💾 데이터 저장

모든 데이터는 브라우저의 **localStorage**에 저장됩니다:
- `aac_cards`: 카드 데이터
- `aac_categories`: 카테고리 데이터
- `aac_favorite_cards`: 즐겨찾기 카드
- `aac_favorite_sentences`: 자주 쓰는 문장
- `aac_auxiliary_words`: 보조 단어
- `aac_settings`: 앱 설정

**주의**: 브라우저 캐시를 지우면 데이터가 삭제됩니다. 설정에서 CSV로 백업하세요.

## 🔄 데이터 백업

### 내보내기
1. 우측 상단 **⚙️ 설정** 클릭
2. **카드 내보내기 (CSV)** 버튼 클릭
3. CSV 파일 다운로드

### 가져오기
1. 우측 상단 **⚙️ 설정** 클릭
2. **카드 가져오기 (CSV)** 버튼 클릭
3. CSV 파일 선택

## 🎨 커스터마이징

### TTS 설정
- 음성 속도 조절 (0.5x ~ 2.0x)
- 음높이 조절 (0.5x ~ 2.0x)
- 테스트 음성 재생

### 카드 디자인
- 자유로운 배경색 선택
- 이미지 업로드 (5MB 이하)
- 텍스트 크기 자동 조절

## 🤝 기여

이 프로젝트는 오픈소스입니다. 기여를 환영합니다!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 무료로 사용 가능합니다.

## 🙏 감사의 말

- **ResponsiveVoice**: 고품질 한국어 TTS 제공
- **Material Icons**: 아름다운 아이콘 시스템
- **모든 사용자**: 소중한 피드백과 제안

## 📞 문의

- GitHub Issues: [이슈 등록](https://github.com/Kkamnyang2/kkamnyang_open/issues)

---

**TalkSeed AAC**를 사용해주셔서 감사합니다! 💙

더 나은 의사소통을 위한 여정을 함께합니다. 🌱
