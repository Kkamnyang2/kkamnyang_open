#!/bin/bash
# TalkSeed AAC 빠른 업데이트 스크립트 (Mac/Linux)
# 사용 방법: ./update.sh

clear
echo "🚀 TalkSeed AAC 업데이트 도구"
echo "================================"
echo ""

# 현재 브랜치 확인
current_branch=$(git branch --show-current)
echo "📍 현재 브랜치: $current_branch"
echo ""

# 변경 사항 확인
echo "🔍 변경 사항 확인 중..."
git status
echo ""

# 변경된 파일이 있는지 확인
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ 변경된 파일이 없습니다."
    echo ""
    read -p "원격 저장소에서 최신 코드를 가져올까요? (y/n): " pull_choice
    if [ "$pull_choice" = "y" ] || [ "$pull_choice" = "Y" ]; then
        echo ""
        echo "📥 최신 코드 가져오는 중..."
        git pull origin main
        echo ""
        echo "✅ 완료!"
    fi
    exit 0
fi

# 커밋 메시지 입력
echo "📝 커밋 메시지를 입력하세요:"
echo "   예시: Update: 새로운 카드 추가"
echo "   예시: Fix: TTS 버그 수정"
echo "   예시: Add: 동물 카테고리 추가"
echo ""
read -p "커밋 메시지: " commit_message

if [ -z "$commit_message" ]; then
    echo "❌ 커밋 메시지가 비어있습니다. 종료합니다."
    exit 1
fi

echo ""
echo "💾 변경 사항 저장 중..."
git add .
git commit -m "$commit_message"

if [ $? -ne 0 ]; then
    echo "❌ 커밋 실패. 에러를 확인하세요."
    exit 1
fi

echo ""
echo "🚀 GitHub에 업로드 중..."
git push origin $current_branch

if [ $? -ne 0 ]; then
    echo "❌ 푸시 실패. 에러를 확인하세요."
    echo ""
    echo "💡 원격 저장소의 변경 사항을 먼저 가져와야 할 수 있습니다:"
    echo "   git pull origin $current_branch"
    exit 1
fi

echo ""
echo "✅ 완료!"
echo ""
echo "📍 배포 상태 확인: https://github.com/Kkamnyang2/talkseed_aac/actions"
echo "🌐 라이브 사이트: https://kkamnyang2.github.io/talkseed_aac/"
echo ""
echo "⏳ GitHub Pages 배포 중... (1-3분 소요)"
echo "💡 브라우저에서 Ctrl+Shift+R (Mac: Cmd+Shift+R)로 캐시 무시하고 새로고침하세요."
