# 🚀 TalkSeed AAC 빠른 시작 가이드

## 📌 처음 사용하시나요?

### 1️⃣ 저장소 다운로드

```bash
git clone https://github.com/Kkamnyang2/talkseed_aac.git
cd talkseed_aac
```

### 2️⃣ 로컬 서버 실행

**Python 사용 (가장 간단):**
```bash
python3 -m http.server 8000
```

브라우저에서 접속: `http://localhost:8000`

---

## ✏️ 코드를 수정하고 싶으신가요?

### 간단한 3단계 업데이트

#### **STEP 1: 파일 수정**
- `index.html` - 페이지 구조
- `css/style.css` - 디자인
- `js/app.js` - 기능
- `js/storage.js` - 데이터

#### **STEP 2: 로컬에서 테스트**
```bash
python3 -m http.server 8000
# http://localhost:8000 에서 확인
```

#### **STEP 3: GitHub에 업로드**

**자동 스크립트 사용 (권장):**
```bash
# Mac/Linux
./update.sh

# Windows
update.bat (더블클릭)
```

**또는 수동으로:**
```bash
git add .
git commit -m "Update: 변경 내용 설명"
git push origin main
```

**결과:** 1-3분 후 https://kkamnyang2.github.io/talkseed_aac/ 에 자동 반영!

---

## 🎯 자주 하는 작업들

### 새로운 카드 추가하기
1. `js/storage.js` 열기
2. `defaultCards` 배열에 추가:
```javascript
{
    id: '새ID',
    text: '카드텍스트',
    imageUrl: '이미지URL',
    category: '카테고리',
    backgroundColor: '#색상코드',
    createdAt: new Date().toISOString()
}
```
3. 저장 후 업데이트 (위의 STEP 3)

### UI 색상 변경하기
1. `css/style.css` 열기
2. `:root` 섹션에서 색상 변경:
```css
:root {
    --primary-color: #원하는색상;
}
```
3. 저장 후 업데이트

### 새 카테고리 추가하기
1. `js/storage.js` 열기
2. `defaultCategories` 배열에 추가:
```javascript
{
    id: 'cat_새ID',
    name: '카테고리명',
    icon: 'material_icon_이름',
    backgroundColor: '#색상코드',
    order: 순서번호
}
```
3. 저장 후 업데이트

---

## 🏷️ 새 버전 릴리스하기

```bash
# Mac/Linux
./release.sh v18

# 또는 수동으로
git tag -a v18 -m "버전 v18"
git push origin v18
```

그 후:
1. https://github.com/Kkamnyang2/talkseed_aac/releases/new
2. 태그 선택 및 설명 작성
3. "Publish release" 클릭

---

## 🆘 문제가 생겼나요?

### GitHub Pages가 업데이트 안 됨
```bash
# 브라우저에서 강제 새로고침
Ctrl + Shift + R (Windows)
Cmd + Shift + R (Mac)

# 또는 시크릿 모드에서 확인
```

### Git Push가 안 됨
```bash
# 최신 코드 먼저 가져오기
git pull origin main

# 다시 푸시
git push origin main
```

### 로컬에서는 되는데 GitHub Pages에서 안 됨
- 파일 경로 대소문자 확인 (js/ vs JS/)
- 외부 리소스 URL 확인 (https:// 사용)

---

## 📚 더 자세한 내용은?

**전체 가이드:** [MAINTENANCE.md](MAINTENANCE.md)
- 상세한 개발 워크플로우
- 디버깅 방법
- 버전 관리 전략
- FAQ

---

## 🔗 유용한 링크

- **라이브 사이트**: https://kkamnyang2.github.io/talkseed_aac/
- **저장소**: https://github.com/Kkamnyang2/talkseed_aac
- **배포 상태**: https://github.com/Kkamnyang2/talkseed_aac/actions
- **이슈 등록**: https://github.com/Kkamnyang2/talkseed_aac/issues

---

**💡 팁:** 이 가이드를 북마크해두고 필요할 때마다 참고하세요!
