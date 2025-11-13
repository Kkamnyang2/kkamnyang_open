import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

/// TTS (Text-to-Speech) 서비스
/// - 한국어 음성 출력 기능 제공
/// - AAC 카드 텍스트를 음성으로 읽어주는 핵심 기능
class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  /// TTS 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 한국어 설정
      await _flutterTts.setLanguage("ko-KR");
      
      // 음성 속도 설정 (0.0 ~ 1.0, 기본 0.5)
      await _flutterTts.setSpeechRate(0.5);
      
      // 음량 설정 (0.0 ~ 1.0, 기본 1.0)
      await _flutterTts.setVolume(1.0);
      
      // 음높이 설정 (0.5 ~ 2.0, 기본 1.0)
      await _flutterTts.setPitch(1.0);

      // 웹 플랫폼 추가 설정
      if (kIsWeb) {
        await _flutterTts.setVoice({"name": "Google 한국어", "locale": "ko-KR"});
      }

      _isInitialized = true;
      
      if (kDebugMode) {
        debugPrint('✅ TTS Service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ TTS initialization error: $e');
      }
    }
  }

  /// 텍스트 음성 출력
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // 이미 재생 중이면 중지
      await stop();
      
      // 텍스트 음성 출력
      await _flutterTts.speak(text);
      
      if (kDebugMode) {
        debugPrint('🔊 Speaking: $text');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ TTS speak error: $e');
      }
    }
  }

  /// 음성 출력 중지
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ TTS stop error: $e');
      }
    }
  }

  /// 음성 출력 일시정지
  Future<void> pause() async {
    try {
      await _flutterTts.pause();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ TTS pause error: $e');
      }
    }
  }

  /// 사용 가능한 언어 목록 가져오기
  Future<List<dynamic>> getAvailableLanguages() async {
    try {
      return await _flutterTts.getLanguages;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ TTS get languages error: $e');
      }
      return [];
    }
  }

  /// 음성 속도 변경 (0.0 ~ 1.0)
  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ TTS set speech rate error: $e');
      }
    }
  }

  /// 음량 변경 (0.0 ~ 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _flutterTts.setVolume(volume);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ TTS set volume error: $e');
      }
    }
  }

  /// 음높이 변경 (0.5 ~ 2.0)
  Future<void> setPitch(double pitch) async {
    try {
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ TTS set pitch error: $e');
      }
    }
  }

  /// TTS 리소스 정리
  Future<void> dispose() async {
    try {
      await stop();
      _isInitialized = false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ TTS dispose error: $e');
      }
    }
  }
}
