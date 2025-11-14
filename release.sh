#!/bin/bash
# TalkSeed AAC 버전 릴리스 스크립트 (Mac/Linux)
# 사용 방법: ./release.sh v18

clear
echo "🎉 TalkSeed AAC 릴리스 도구"
echo "================================"
echo ""

# 버전 번호 입력
if [ -z "$1" ]; then
    echo "📝 릴리스 버전을 입력하세요 (예: v18, v18.1):"
    read -p "버전: " version
else
    version=$1
fi

# 버전 형식 확인
if [[ ! $version =~ ^v[0-9]+(\.[0-9]+)*$ ]]; then
    echo "❌ 잘못된 버전 형식입니다. 예: v18, v18.1, v18.1.1"
    exit 1
fi

echo ""
echo "🏷️  릴리스 버전: $version"
echo ""

# 릴리스 제목 입력
echo "📝 릴리스 제목을 입력하세요:"
echo "   예시: TalkSeed AAC $version - 새로운 기능 추가"
read -p "제목: " release_title

if [ -z "$release_title" ]; then
    release_title="TalkSeed AAC $version"
fi

echo ""
echo "📝 릴리스 설명을 입력하세요 (여러 줄 가능, 빈 줄 입력 시 종료):"
echo "   예시: - 새로운 동물 카테고리 추가"
echo "   예시: - TTS 음성 속도 개선"
echo ""

release_description=""
while IFS= read -r line; do
    [ -z "$line" ] && break
    release_description="${release_description}- ${line}\n"
done

if [ -z "$release_description" ]; then
    release_description="버전 $version 릴리스"
fi

echo ""
echo "📋 릴리스 정보:"
echo "   버전: $version"
echo "   제목: $release_title"
echo "   설명: "
echo -e "$release_description"
echo ""

read -p "이대로 릴리스를 진행할까요? (y/n): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "❌ 릴리스가 취소되었습니다."
    exit 0
fi

echo ""
echo "💾 변경 사항 커밋 중..."
git add .
git commit -m "Release $version" || echo "커밋할 변경 사항이 없습니다."

echo ""
echo "🏷️  Git 태그 생성 중..."
git tag -a $version -m "$release_title"

if [ $? -ne 0 ]; then
    echo "❌ 태그 생성 실패. 이미 존재하는 태그일 수 있습니다."
    exit 1
fi

echo ""
echo "🚀 GitHub에 푸시 중..."
git push origin main
git push origin $version

if [ $? -ne 0 ]; then
    echo "❌ 푸시 실패. 에러를 확인하세요."
    exit 1
fi

echo ""
echo "✅ 완료!"
echo ""
echo "📋 다음 단계:"
echo ""
echo "1️⃣  GitHub Release 페이지로 이동:"
echo "   https://github.com/Kkamnyang2/talkseed_aac/releases/new"
echo ""
echo "2️⃣  태그 선택: $version"
echo ""
echo "3️⃣  릴리스 제목 입력:"
echo "   $release_title"
echo ""
echo "4️⃣  릴리스 설명 입력:"
echo -e "$release_description"
echo ""
echo "5️⃣  'Publish release' 버튼 클릭"
echo ""
echo "🌐 라이브 사이트: https://kkamnyang2.github.io/talkseed_aac/"
