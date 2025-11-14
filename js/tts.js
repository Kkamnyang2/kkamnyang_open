/**
 * TTS (Text-to-Speech) 음성 출력 관리
 * ResponsiveVoice API 및 Web Speech API 하이브리드 사용
 */

console.log('🔄 tts.js 파일 로드 시작...');

const TTS = {
    synthesis: window.speechSynthesis,
    currentUtterance: null,
    settings: { speechRate: 1.0, speechPitch: 1.0 }, // 초기값, 나중에 loadSettings에서 업데이트
    useResponsiveVoice: true, // ResponsiveVoice 우선 사용

    /**
     * TTS 초기화
     */
    init() {
        // AACStorage에서 설정 로드 (이제 안전하게 접근 가능)
        if (typeof window.AACStorage !== 'undefined') {
            this.settings = window.AACStorage.getSettings();
            console.log('✅ TTS settings loaded from AACStorage');
        }
        
        // ResponsiveVoice 사용 가능 여부 확인
        if (typeof responsiveVoice !== 'undefined') {
            console.log('✅ ResponsiveVoice TTS loaded (optimized for Korean)');
            this.useResponsiveVoice = true;
            
            // ResponsiveVoice 초기화 대기
            responsiveVoice.init();
        } else {
            console.log('⚠️ ResponsiveVoice not loaded, using Web Speech API');
            this.useResponsiveVoice = false;
            
            // Web Speech API 초기화
            if (this.synthesis) {
                setTimeout(() => {
                    this.voices = this.synthesis.getVoices();
                    console.log('✅ Web Speech API initialized with', this.voices.length, 'voices');
                }, 100);
            }
        }
    },

    /**
     * 텍스트를 음성으로 출력 (ResponsiveVoice 우선)
     */
    speak(text) {
        if (!text || text.trim() === '') return;

        // 기존 음성 중지
        this.stop();

        if (this.useResponsiveVoice && typeof responsiveVoice !== 'undefined') {
            // ResponsiveVoice 사용 (한국어 최적화)
            this.speakWithResponsiveVoice(text);
        } else {
            // Web Speech API 사용 (폴백)
            this.speakWithWebSpeech(text);
        }

        console.log(`🔊 Speaking: "${text}"`);
    },

    /**
     * ResponsiveVoice로 음성 출력 (한국어 최적화)
     */
    speakWithResponsiveVoice(text) {
        // ResponsiveVoice 한국어 음성 사용
        const voice = 'Korean Female'; // 가장 자연스러운 한국어 여성 음성
        const rate = this.settings.speechRate || 1.0;
        const pitch = this.settings.speechPitch || 1.0;

        responsiveVoice.speak(text, voice, {
            rate: rate,
            pitch: pitch,
            volume: 1.0,
            onstart: () => {
                console.log('🎤 ResponsiveVoice started speaking');
            },
            onend: () => {
                console.log('✅ ResponsiveVoice finished speaking');
            },
            onerror: (error) => {
                console.error('❌ ResponsiveVoice error:', error);
                // 에러 시 Web Speech API로 폴백
                this.useResponsiveVoice = false;
                this.speakWithWebSpeech(text);
            }
        });
    },

    /**
     * Web Speech API로 음성 출력 (폴백)
     */
    speakWithWebSpeech(text) {
        if (!this.synthesis) {
            console.warn('⚠️ Web Speech API not available');
            return;
        }

        // 새 음성 생성
        this.currentUtterance = new SpeechSynthesisUtterance(text);
        
        // 한국어 음성 찾기
        const voices = this.synthesis.getVoices();
        
        // 한국어 음성 우선순위 설정
        const koreanVoicePriority = [
            'Google 한국의', // Chrome
            'Microsoft Heami - Korean (South Korea)', // Edge
            'Yuna', // Safari (iOS)
            'ko-KR', // 일반 한국어
        ];

        let selectedVoice = null;
        for (const priority of koreanVoicePriority) {
            selectedVoice = voices.find(voice => 
                voice.name.includes(priority) || 
                voice.lang.startsWith('ko')
            );
            if (selectedVoice) break;
        }

        if (selectedVoice) {
            this.currentUtterance.voice = selectedVoice;
            console.log(`🎤 Using voice: ${selectedVoice.name}`);
        } else {
            console.warn('⚠️ No Korean voice found, using default');
        }

        // 설정 적용
        this.currentUtterance.rate = this.settings.speechRate || 1.0;
        this.currentUtterance.pitch = this.settings.speechPitch || 1.0;
        this.currentUtterance.volume = 1.0;
        this.currentUtterance.lang = 'ko-KR';

        // 음성 출력
        this.synthesis.speak(this.currentUtterance);
    },

    /**
     * 음성 중지
     */
    stop() {
        // ResponsiveVoice 중지
        if (typeof responsiveVoice !== 'undefined') {
            responsiveVoice.cancel();
        }
        
        // Web Speech API 중지
        if (this.synthesis) {
            this.synthesis.cancel();
        }
    },

    /**
     * 사용 가능한 한국어 음성 목록 가져오기
     */
    getKoreanVoices() {
        if (this.useResponsiveVoice && typeof responsiveVoice !== 'undefined') {
            // ResponsiveVoice 한국어 음성
            return [
                { name: 'Korean Female', label: '한국어 여성 (권장)' },
                { name: 'Korean Male', label: '한국어 남성' }
            ];
        } else if (this.synthesis) {
            // Web Speech API 한국어 음성
            const voices = this.synthesis.getVoices();
            return voices
                .filter(voice => voice.lang.startsWith('ko'))
                .map(voice => ({
                    name: voice.name,
                    label: voice.name
                }));
        }
        return [];
    },

    /**
     * 설정 업데이트
     */
    updateSettings(newSettings) {
        this.settings = { ...this.settings, ...newSettings };
        if (Storage) {
            Storage.saveSettings(this.settings);
        }
    },

    /**
     * 음성 속도 설정
     */
    setRate(rate) {
        this.settings.speechRate = rate;
        if (Storage) {
            Storage.saveSettings(this.settings);
        }
    },

    /**
     * 음높이 설정
     */
    setPitch(pitch) {
        this.settings.speechPitch = pitch;
        if (Storage) {
            Storage.saveSettings(this.settings);
        }
    },

    /**
     * TTS 엔진 정보 표시
     */
    getEngineInfo() {
        if (this.useResponsiveVoice && typeof responsiveVoice !== 'undefined') {
            return 'ResponsiveVoice (한국어 최적화)';
        } else if (this.synthesis) {
            return 'Web Speech API';
        }
        return 'TTS 사용 불가';
    },

    /**
     * 테스트 음성 출력
     */
    test() {
        const testMessages = [
            '안녕하세요. 음성 테스트입니다.',
            '물을 마시고 싶어요.',
            '화장실에 가고 싶어요.',
            '도와주세요.'
        ];
        const randomMessage = testMessages[Math.floor(Math.random() * testMessages.length)];
        this.speak(randomMessage);
    }
};

// TTS 초기화
document.addEventListener('DOMContentLoaded', () => {
    // ResponsiveVoice 로드 대기
    const initTTS = () => {
        if (typeof responsiveVoice !== 'undefined') {
            TTS.init();
        } else {
            // ResponsiveVoice 로드 실패 시 Web Speech API 사용
            setTimeout(() => {
                TTS.init();
            }, 500);
        }
    };

    // 초기화 실행
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initTTS);
    } else {
        initTTS();
    }
    
    // Web Speech API 음성 목록 변경 시 다시 로드
    if (window.speechSynthesis) {
        window.speechSynthesis.onvoiceschanged = () => {
            if (!TTS.useResponsiveVoice) {
                TTS.voices = window.speechSynthesis.getVoices();
            }
        };
    }
});

// 전역으로 export
window.TTS = TTS;
