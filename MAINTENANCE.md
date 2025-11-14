# 🔧 TalkSeed AAC 유지보수 가이드

이 문서는 TalkSeed AAC 웹 애플리케이션의 유지보수, 업데이트, 배포 방법을 안내합니다.

---

## 📋 목차

1. [로컬 개발 환경 설정](#로컬-개발-환경-설정)
2. [코드 수정 워크플로우](#코드-수정-워크플로우)
3. [테스트 방법](#테스트-방법)
4. [GitHub 업데이트 및 배포](#github-업데이트-및-배포)
5. [버전 관리](#버전-관리)
6. [문제 해결](#문제-해결)
7. [자주 묻는 질문](#자주-묻는-질문)

---

## 🖥️ 로컬 개발 환경 설정

### 1. 저장소 클론

```bash
# 저장소를 로컬로 다운로드
git clone https://github.com/Kkamnyang2/talkseed_aac.git

# 프로젝트 디렉토리로 이동
cd talkseed_aac
```

### 2. 로컬 서버 실행

#### 방법 1: Python HTTP 서버 (권장)
```bash
# Python 3가 설치되어 있어야 합니다
python3 -m http.server 8000

# 브라우저에서 접속
# http://localhost:8000
```

#### 방법 2: Node.js http-server
```bash
# http-server 설치 (한 번만 실행)
npm install -g http-server

# 서버 실행
http-server -p 8000

# 브라우저에서 접속
# http://localhost:8000
```

#### 방법 3: VS Code Live Server
1. VS Code 설치
2. "Live Server" 확장 프로그램 설치
3. `index.html` 우클릭 → "Open with Live Server"

### 3. 개발 도구 추천

- **코드 에디터**: VS Code, Sublime Text, Atom
- **브라우저**: Chrome (DevTools가 강력함)
- **Git 클라이언트**: GitHub Desktop, SourceTree, Git CLI

---

## ✏️ 코드 수정 워크플로우

### 기본 워크플로우

```
1. 로컬 저장소 업데이트
   ↓
2. 새 브랜치 생성 (선택사항)
   ↓
3. 코드 수정
   ↓
4. 로컬에서 테스트
   ↓
5. Git에 커밋
   ↓
6. GitHub에 푸시
   ↓
7. GitHub Pages 자동 배포 (1-3분 소요)
```

### 상세 단계

#### STEP 1: 최신 코드 가져오기
```bash
# 로컬 저장소를 최신 상태로 업데이트
git pull origin main
```

#### STEP 2: 브랜치 생성 (선택사항)
```bash
# 새로운 기능을 추가할 때 브랜치를 만드는 것이 좋습니다
git checkout -b feature/new-feature-name

# 예시:
git checkout -b feature/add-new-card
git checkout -b fix/tts-bug
git checkout -b update/ui-improvement
```

#### STEP 3: 코드 수정
프로젝트 파일 구조:
```
talkseed_aac/
├── index.html          # 메인 HTML 파일
├── css/
│   └── style.css      # 스타일시트
├── js/
│   ├── app.js         # 메인 로직
│   ├── storage.js     # 데이터 관리
│   └── tts.js         # 음성 출력
└── assets/            # 이미지 등
```

**주요 수정 파일:**
- **UI 변경**: `index.html`, `css/style.css`
- **기능 추가/수정**: `js/app.js`
- **데이터 구조 변경**: `js/storage.js`
- **TTS 설정**: `js/tts.js`

#### STEP 4: 로컬 테스트
```bash
# 서버 실행
python3 -m http.server 8000

# 브라우저에서 테스트
# http://localhost:8000
```

**테스트 체크리스트:**
- ✅ 페이지가 정상적으로 로드되는가?
- ✅ 수정한 기능이 작동하는가?
- ✅ 기존 기능이 정상 작동하는가?
- ✅ 모바일/태블릿 화면에서도 잘 보이는가? (브라우저 DevTools 사용)
- ✅ 콘솔에 에러가 없는가? (F12 → Console 탭)

#### STEP 5: Git 커밋
```bash
# 변경된 파일 확인
git status

# 수정한 파일 추가
git add index.html          # 특정 파일만
git add css/style.css js/app.js  # 여러 파일
git add .                   # 모든 변경 파일 (주의!)

# 커밋 메시지 작성
git commit -m "설명: 무엇을 수정했는지 명확하게 작성"

# 좋은 커밋 메시지 예시:
git commit -m "Add: 새로운 동물 카테고리 추가"
git commit -m "Fix: TTS 음성 속도 버그 수정"
git commit -m "Update: 모바일 UI 반응형 개선"
git commit -m "Remove: 사용하지 않는 테스트 파일 삭제"
```

#### STEP 6: GitHub에 푸시
```bash
# main 브랜치에 직접 푸시
git push origin main

# 또는 새 브랜치를 푸시한 경우
git push origin feature/new-feature-name
```

#### STEP 7: 자동 배포 확인
1. GitHub Actions 확인: https://github.com/Kkamnyang2/talkseed_aac/actions
2. 배포 완료 대기 (1-3분)
3. 라이브 사이트 확인: https://kkamnyang2.github.io/talkseed_aac/
4. **브라우저 캐시 무시**: `Ctrl + Shift + R` (Windows) 또는 `Cmd + Shift + R` (Mac)

---

## 🧪 테스트 방법

### 로컬 테스트

#### 1. 기능 테스트
```
✅ 카드 추가/수정/삭제
✅ 카테고리 추가/편집/삭제
✅ 문장 만들기 (카드 선택 + 직접 입력)
✅ TTS 음성 출력
✅ 즐겨찾기 추가/제거
✅ 보조 단어 버튼
✅ 설정 저장/불러오기
```

#### 2. 브라우저 호환성 테스트
```
✅ Chrome/Edge
✅ Firefox
✅ Safari (Mac/iOS)
```

#### 3. 반응형 디자인 테스트
브라우저 DevTools (F12):
```
✅ 모바일 (375px ~ 480px)
✅ 태블릿 세로 (768px ~ 1024px)
✅ 태블릿 가로 (1024px ~ 1366px)
✅ 데스크톱 (1920px+)
```

#### 4. 콘솔 에러 확인
```
F12 → Console 탭
에러나 경고가 없는지 확인
```

### 디버깅 도구

#### Chrome DevTools 활용
```javascript
// 1. 콘솔에서 데이터 확인
console.log(AACStorage.getCards());
console.log(AACStorage.getCategories());

// 2. localStorage 확인
// F12 → Application 탭 → Local Storage
// 키: aac_cards, aac_categories 등

// 3. 네트워크 요청 확인
// F12 → Network 탭
// 외부 이미지 URL, ResponsiveVoice API 등
```

---

## 🚀 GitHub 업데이트 및 배포

### 빠른 업데이트 명령어

#### 한 번에 업데이트하기
```bash
# 1단계: 변경 사항 확인
git status

# 2단계: 모든 변경 파일 추가 및 커밋
git add .
git commit -m "Update: 설명 작성"

# 3단계: GitHub에 푸시
git push origin main

# 완료! GitHub Pages가 자동으로 배포합니다 (1-3분 소요)
```

### 버전 업데이트 시 (v18, v19 등)

#### 1. 버전 번호 변경
```javascript
// index.html에서 버전 번호 업데이트
<link rel="stylesheet" href="css/style.css?v=18">
<script src="js/storage.js?v=18"></script>
<script src="js/tts.js?v=18"></script>
<script src="js/app.js?v=18"></script>
```

#### 2. Git 태그 생성
```bash
# 태그 생성
git tag -a v18 -m "TalkSeed AAC v18: 새로운 기능 설명"

# 태그 푸시
git push origin v18

# 또는 모든 태그 푸시
git push --tags
```

#### 3. GitHub Release 생성
1. https://github.com/Kkamnyang2/talkseed_aac/releases/new
2. Tag 선택: `v18`
3. Release 제목 및 설명 작성
4. "Publish release" 클릭

### 자동화 스크립트

로컬에 저장해서 사용하세요:

#### `update.sh` (Mac/Linux)
```bash
#!/bin/bash
# TalkSeed AAC 빠른 업데이트 스크립트

echo "🔍 변경 사항 확인..."
git status

echo ""
echo "📝 커밋 메시지를 입력하세요:"
read commit_message

echo ""
echo "💾 변경 사항 저장 중..."
git add .
git commit -m "$commit_message"

echo ""
echo "🚀 GitHub에 업로드 중..."
git push origin main

echo ""
echo "✅ 완료! GitHub Pages 배포 중 (1-3분 소요)"
echo "📍 배포 상태: https://github.com/Kkamnyang2/talkseed_aac/actions"
echo "🌐 라이브 사이트: https://kkamnyang2.github.io/talkseed_aac/"
```

사용 방법:
```bash
# 실행 권한 부여 (한 번만)
chmod +x update.sh

# 스크립트 실행
./update.sh
```

#### `update.bat` (Windows)
```batch
@echo off
REM TalkSeed AAC 빠른 업데이트 스크립트

echo 🔍 변경 사항 확인...
git status

echo.
set /p commit_message="📝 커밋 메시지를 입력하세요: "

echo.
echo 💾 변경 사항 저장 중...
git add .
git commit -m "%commit_message%"

echo.
echo 🚀 GitHub에 업로드 중...
git push origin main

echo.
echo ✅ 완료! GitHub Pages 배포 중 (1-3분 소요)
echo 📍 배포 상태: https://github.com/Kkamnyang2/talkseed_aac/actions
echo 🌐 라이브 사이트: https://kkamnyang2.github.io/talkseed_aac/
pause
```

사용 방법:
```batch
REM 더블클릭하거나 명령 프롬프트에서 실행
update.bat
```

---

## 🏷️ 버전 관리

### 버전 번호 규칙

```
v[Major].[Minor].[Patch]

예시:
v17 → v18 (큰 기능 추가)
v18 → v18.1 (작은 기능 추가)
v18.1 → v18.1.1 (버그 수정)
```

### 변경 사항 기록

`CHANGELOG.md` 파일을 만들어 버전별 변경 사항 기록:

```markdown
# Changelog

## v18 (2024-11-15)
### Added
- 새로운 동물 카테고리 추가
- 카드 크기 조절 기능

### Fixed
- TTS 음성 속도 버그 수정

### Changed
- UI 색상 개선

## v17 (2024-11-14)
### Added
- 카테고리 편집 기능
- 직접 텍스트 입력 기능
- "사랑해요" 카드 추가
```

---

## 🔧 문제 해결

### 자주 발생하는 문제

#### 1. GitHub Pages가 업데이트되지 않음
**증상**: 코드를 푸시했는데 사이트가 변경되지 않음

**해결 방법:**
```bash
# 1. 배포 상태 확인
# https://github.com/Kkamnyang2/talkseed_aac/actions
# 초록색 체크 표시가 있는지 확인

# 2. 브라우저 캐시 무시
# Ctrl + Shift + R (Windows)
# Cmd + Shift + R (Mac)

# 3. 시크릿 모드에서 확인
# Chrome: Ctrl + Shift + N
```

#### 2. Git Push가 거부됨
**증상**: `error: failed to push some refs`

**해결 방법:**
```bash
# 원격 저장소의 변경 사항을 먼저 가져오기
git pull origin main

# 충돌이 발생하면 수동으로 해결 후
git add .
git commit -m "Merge remote changes"
git push origin main
```

#### 3. 로컬에서는 작동하는데 GitHub Pages에서 안됨
**원인**: 파일 경로 문제 (대소문자 구분)

**해결 방법:**
```html
<!-- ❌ 잘못된 경로 -->
<script src="JS/app.js"></script>

<!-- ✅ 올바른 경로 -->
<script src="js/app.js"></script>
```

#### 4. localStorage 데이터 초기화됨
**증상**: 테스트 중 데이터가 사라짐

**해결 방법:**
```javascript
// 브라우저 콘솔에서 데이터 백업
const backup = {
  cards: AACStorage.getCards(),
  categories: AACStorage.getCategories()
};
console.log(JSON.stringify(backup));

// 복원
// 콘솔에 백업 데이터 붙여넣고
localStorage.setItem('aac_cards', JSON.stringify(backup.cards));
localStorage.setItem('aac_categories', JSON.stringify(backup.categories));
location.reload();
```

### 디버깅 유틸리티 파일

프로젝트에 이미 포함된 유틸리티 파일들:

```
debug.html        # localStorage 데이터 확인
check.html        # 데이터 유효성 검사
test-load.html    # 로딩 테스트
reset.html        # 데이터 초기화
clear_favorites.html  # 즐겨찾기 초기화
```

사용 방법:
```
http://localhost:8000/debug.html
```

---

## ❓ 자주 묻는 질문

### Q1: 새로운 카드를 기본으로 추가하려면?
**A**: `js/storage.js` 파일 수정

```javascript
// defaultCards 배열에 새 카드 추가
{
    id: '14',
    text: '안녕하세요',
    imageUrl: 'https://example.com/image.jpg',
    category: '인사',
    backgroundColor: '#4CAF50',
    createdAt: new Date().toISOString()
}
```

### Q2: 새로운 카테고리를 기본으로 추가하려면?
**A**: `js/storage.js` 파일 수정

```javascript
// defaultCategories 배열에 새 카테고리 추가
{
    id: 'cat_new',
    name: '동물',
    icon: 'pets',
    backgroundColor: '#795548',
    order: 7
}
```

### Q3: UI 색상을 변경하려면?
**A**: `css/style.css` 파일의 `:root` 섹션 수정

```css
:root {
    --primary-color: #4CAF50;  /* 메인 색상 */
    --secondary-color: #2196F3; /* 보조 색상 */
    /* ... */
}
```

### Q4: TTS 음성을 변경하려면?
**A**: `js/tts.js` 파일 수정

```javascript
// ResponsiveVoice 설정 변경
responsiveVoice.speak(text, "Korean Female", {
    pitch: 1.0,
    rate: 1.0,
    volume: 1.0
});
```

### Q5: 여러 명이 함께 개발하려면?
**A**: GitHub의 브랜치 기능 사용

```bash
# 각자 브랜치 생성
git checkout -b feature/person1-work
git checkout -b feature/person2-work

# 작업 후 푸시
git push origin feature/person1-work

# GitHub에서 Pull Request 생성
# 리뷰 후 main 브랜치에 병합
```

---

## 📚 추가 자료

### 학습 자료
- **Git 기초**: https://git-scm.com/book/ko/v2
- **HTML/CSS/JS**: https://developer.mozilla.org/ko/
- **GitHub Pages**: https://docs.github.com/pages

### 도움말
- **GitHub Issues**: https://github.com/Kkamnyang2/talkseed_aac/issues
- **Git 명령어 치트시트**: https://education.github.com/git-cheat-sheet-education.pdf

---

## 🎯 빠른 참조

### 일상적인 업데이트 (3단계)
```bash
# 1. 코드 수정 후
git add .

# 2. 커밋
git commit -m "Update: 변경 내용"

# 3. 푸시
git push origin main
```

### 긴급 롤백 (이전 버전으로 되돌리기)
```bash
# 최근 커밋 취소
git reset --hard HEAD~1
git push -f origin main

# 특정 커밋으로 되돌리기
git log  # 커밋 ID 확인
git reset --hard [커밋ID]
git push -f origin main
```

### 배포 상태 확인 URL
```
배포 진행: https://github.com/Kkamnyang2/talkseed_aac/actions
라이브 사이트: https://kkamnyang2.github.io/talkseed_aac/
```

---

**💡 이 가이드를 프로젝트 루트에 저장하고 참고하세요!**

더 궁금한 점이 있으면 GitHub Issues에 문의해주세요. 🚀
