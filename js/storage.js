/**
 * 로컬 저장소 관리 (localStorage 사용)
 */

console.log('🔄 storage.js 파일 로드 시작...');

const Storage = {
    // 카드 관리
    getCards() {
        const cards = localStorage.getItem('aac_cards');
        return cards ? JSON.parse(cards) : this.getDefaultCards();
    },

    saveCards(cards) {
        localStorage.setItem('aac_cards', JSON.stringify(cards));
    },

    addCard(card) {
        const cards = this.getCards();
        card.id = Date.now().toString();
        card.createdAt = new Date().toISOString();
        cards.push(card);
        this.saveCards(cards);
        return card;
    },

    updateCard(cardId, updates) {
        const cards = this.getCards();
        const index = cards.findIndex(c => c.id === cardId);
        if (index !== -1) {
            cards[index] = { ...cards[index], ...updates, updatedAt: new Date().toISOString() };
            this.saveCards(cards);
            return cards[index];
        }
        return null;
    },

    deleteCard(cardId) {
        const cards = this.getCards();
        const filtered = cards.filter(c => c.id !== cardId);
        this.saveCards(filtered);
        return filtered;
    },

    // 카테고리 관리
    getCategories() {
        const categories = localStorage.getItem('aac_categories');
        return categories ? JSON.parse(categories) : this.getDefaultCategories();
    },

    saveCategories(categories) {
        localStorage.setItem('aac_categories', JSON.stringify(categories));
    },

    addCategory(category) {
        const categories = this.getCategories();
        category.id = Date.now().toString();
        categories.push(category);
        this.saveCategories(categories);
        return category;
    },

    deleteCategory(categoryId) {
        const categories = this.getCategories();
        const filtered = categories.filter(c => c.id !== categoryId);
        this.saveCategories(filtered);
        return filtered;
    },

    // 즐겨찾기 카드 관리
    getFavoriteCards() {
        const favorites = localStorage.getItem('aac_favorite_cards');
        return favorites ? JSON.parse(favorites) : [];
    },

    saveFavoriteCards(favoriteCardIds) {
        localStorage.setItem('aac_favorite_cards', JSON.stringify(favoriteCardIds));
    },

    toggleFavoriteCard(cardId) {
        const favorites = this.getFavoriteCards();
        const index = favorites.indexOf(cardId);
        
        if (index > -1) {
            // 이미 즐겨찾기에 있으면 제거
            favorites.splice(index, 1);
        } else {
            // 없으면 추가
            favorites.push(cardId);
        }
        
        this.saveFavoriteCards(favorites);
        return favorites;
    },

    isFavoriteCard(cardId) {
        const favorites = this.getFavoriteCards();
        return favorites.includes(cardId);
    },

    // 자주 쓰는 문장 관리
    getFavoriteSentences() {
        const favorites = localStorage.getItem('aac_favorite_sentences');
        return favorites ? JSON.parse(favorites) : [];
    },

    saveFavoriteSentences(favorites) {
        localStorage.setItem('aac_favorite_sentences', JSON.stringify(favorites));
    },

    addFavoriteSentence(sentence) {
        const favorites = this.getFavoriteSentences();
        const newFavorite = {
            id: Date.now().toString(),
            text: sentence,
            createdAt: new Date().toISOString(),
            useCount: 0
        };
        favorites.unshift(newFavorite);
        this.saveFavoriteSentences(favorites);
        return newFavorite;
    },

    deleteFavoriteSentence(id) {
        const favorites = this.getFavoriteSentences();
        const filtered = favorites.filter(f => f.id !== id);
        this.saveFavoriteSentences(filtered);
        return filtered;
    },

    incrementFavoriteUseCount(id) {
        const favorites = this.getFavoriteSentences();
        const favorite = favorites.find(f => f.id === id);
        if (favorite) {
            favorite.useCount = (favorite.useCount || 0) + 1;
            favorite.lastUsed = new Date().toISOString();
            this.saveFavoriteSentences(favorites);
        }
    },

    // 설정 관리
    getSettings() {
        const settings = localStorage.getItem('aac_settings');
        return settings ? JSON.parse(settings) : {
            speechRate: 1.0,
            speechPitch: 1.0,
        };
    },

    saveSettings(settings) {
        localStorage.setItem('aac_settings', JSON.stringify(settings));
    },

    // 모든 데이터 삭제
    clearAll() {
        localStorage.removeItem('aac_cards');
        localStorage.removeItem('aac_categories');
        localStorage.removeItem('aac_settings');
        localStorage.removeItem('aac_favorite_sentences');
    },

    // 기본 카드 데이터
    getDefaultCards() {
        return [
            {
                id: '1',
                text: '물',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/2851/2851133.png',
                category: '음식',
                backgroundColor: '#BBDEFB',
                createdAt: new Date().toISOString()
            },
            {
                id: '2',
                text: '밥',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/3480/3480822.png',
                category: '음식',
                backgroundColor: '#FFE0B2',
                createdAt: new Date().toISOString()
            },
            {
                id: '3',
                text: '화장실',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/2917/2917995.png',
                category: '일상',
                backgroundColor: '#C8E6C9',
                createdAt: new Date().toISOString()
            },
            {
                id: '4',
                text: '안녕하세요',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
                category: '인사',
                backgroundColor: '#FFF9C4',
                createdAt: new Date().toISOString()
            },
            {
                id: '5',
                text: '감사합니다',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/2589/2589175.png',
                category: '인사',
                backgroundColor: '#F8BBD0',
                createdAt: new Date().toISOString()
            },
            {
                id: '6',
                text: '도와주세요',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/4436/4436481.png',
                category: '요청',
                backgroundColor: '#FFCCBC',
                createdAt: new Date().toISOString()
            },
            {
                id: '7',
                text: '좋아요',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/1077/1077035.png',
                category: '감정',
                backgroundColor: '#C5E1A5',
                createdAt: new Date().toISOString()
            },
            {
                id: '8',
                text: '싫어요',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/1077/1077086.png',
                category: '감정',
                backgroundColor: '#EF9A9A',
                createdAt: new Date().toISOString()
            },
            {
                id: '9',
                text: '아파요',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/2785/2785482.png',
                category: '건강',
                backgroundColor: '#FFAB91',
                createdAt: new Date().toISOString()
            },
            {
                id: '10',
                text: '피곤해요',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/3588/3588314.png',
                category: '감정',
                backgroundColor: '#B39DDB',
                createdAt: new Date().toISOString()
            },
            {
                id: '11',
                text: '배고파요',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/857/857681.png',
                category: '음식',
                backgroundColor: '#FFE082',
                createdAt: new Date().toISOString()
            },
            {
                id: '12',
                text: '집에 가고 싶어요',
                imageUrl: 'https://cdn-icons-png.flaticon.com/512/1946/1946436.png',
                category: '요청',
                backgroundColor: '#A5D6A7',
                createdAt: new Date().toISOString()
            }
        ];
    },

    // 기본 카테고리 데이터
    getDefaultCategories() {
        return [
            {
                id: 'cat_1',
                name: '음식',
                icon: 'restaurant',
                backgroundColor: '#FF9800'
            },
            {
                id: 'cat_2',
                name: '감정',
                icon: 'emoji_emotions',
                backgroundColor: '#E91E63'
            },
            {
                id: 'cat_3',
                name: '인사',
                icon: 'waving_hand',
                backgroundColor: '#4CAF50'
            },
            {
                id: 'cat_4',
                name: '요청',
                icon: 'help',
                backgroundColor: '#2196F3'
            },
            {
                id: 'cat_5',
                name: '일상',
                icon: 'home',
                backgroundColor: '#9C27B0'
            }
        ];
    },

    // 보조 단어 관리
    getAuxiliaryWords() {
        const words = localStorage.getItem('aac_auxiliary_words');
        return words ? JSON.parse(words) : this.getDefaultAuxiliaryWords();
    },

    saveAuxiliaryWords(words) {
        localStorage.setItem('aac_auxiliary_words', JSON.stringify(words));
    },

    addAuxiliaryWord(word) {
        const words = this.getAuxiliaryWords();
        if (words.length >= 16) {
            throw new Error('보조 단어는 최대 16개까지 추가할 수 있습니다.');
        }
        if (words.some(w => w.text === word.trim())) {
            throw new Error('이미 존재하는 단어입니다.');
        }
        words.push({
            id: Date.now().toString(),
            text: word.trim(),
            icon: word.icon || 'https://cdn-icons-png.flaticon.com/512/2942/2942937.png'
        });
        this.saveAuxiliaryWords(words);
        return words;
    },

    deleteAuxiliaryWord(wordId) {
        const words = this.getAuxiliaryWords();
        const filtered = words.filter(w => w.id !== wordId);
        this.saveAuxiliaryWords(filtered);
        return filtered;
    },

    getDefaultAuxiliaryWords() {
        return [
            { id: 'aux_1', text: '나', icon: 'https://cdn-icons-png.flaticon.com/512/1077/1077114.png' },
            { id: 'aux_2', text: '너', icon: 'https://cdn-icons-png.flaticon.com/512/3006/3006876.png' },
            { id: 'aux_3', text: '우리', icon: 'https://cdn-icons-png.flaticon.com/512/1256/1256650.png' },
            { id: 'aux_4', text: '그거', icon: 'https://cdn-icons-png.flaticon.com/512/3524/3524335.png' },
            { id: 'aux_5', text: '이거', icon: 'https://cdn-icons-png.flaticon.com/512/3524/3524388.png' },
            { id: 'aux_6', text: '무엇', icon: 'https://cdn-icons-png.flaticon.com/512/2354/2354573.png' },
            { id: 'aux_7', text: '누구?', icon: 'https://cdn-icons-png.flaticon.com/512/3815/3815468.png' },
            { id: 'aux_8', text: '어디?', icon: 'https://cdn-icons-png.flaticon.com/512/854/854878.png' },
            { id: 'aux_9', text: '언제?', icon: 'https://cdn-icons-png.flaticon.com/512/3652/3652191.png' },
            { id: 'aux_10', text: '왜?', icon: 'https://cdn-icons-png.flaticon.com/512/189/189665.png' },
            { id: 'aux_11', text: '어떻게?', icon: 'https://cdn-icons-png.flaticon.com/512/2354/2354573.png' },
            { id: 'aux_12', text: '네', icon: 'https://cdn-icons-png.flaticon.com/512/5290/5290058.png' },
            { id: 'aux_13', text: '아니요', icon: 'https://cdn-icons-png.flaticon.com/512/1828/1828843.png' },
            { id: 'aux_14', text: '더', icon: 'https://cdn-icons-png.flaticon.com/512/3524/3524388.png' },
            { id: 'aux_15', text: '다시', icon: 'https://cdn-icons-png.flaticon.com/512/2618/2618245.png' },
            { id: 'aux_16', text: '그만', icon: 'https://cdn-icons-png.flaticon.com/512/1828/1828774.png' }
        ];
    }
};

// 전역으로 export (브라우저 내장 Storage와 충돌 방지를 위해 AACStorage로 변경)
window.AACStorage = Storage;

console.log('✅ Storage module loaded as AACStorage');
