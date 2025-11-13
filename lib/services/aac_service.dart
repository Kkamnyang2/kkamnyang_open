import 'package:hive_flutter/hive_flutter.dart';
import '../models/aac_card.dart';

/// AAC 카드 관리 서비스
/// - Hive 로컬 DB CRUD 작업 처리
/// - 카드 추가, 수정, 삭제, 조회 기능 제공
class AACService {
  static const String _boxName = 'aac_cards';
  
  /// Hive Box 가져오기
  Box<AACCard> get _box => Hive.box<AACCard>(_boxName);

  /// 모든 카드 조회 (sortOrder 기준 정렬)
  List<AACCard> getAllCards() {
    final cards = _box.values.toList();
    cards.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return cards;
  }

  /// 카테고리별 카드 조회
  List<AACCard> getCardsByCategory(String category) {
    return _box.values
        .where((card) => card.category == category)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// 카드 추가
  Future<void> addCard(AACCard card) async {
    await _box.put(card.id, card);
  }

  /// 카드 수정
  Future<void> updateCard(AACCard card) async {
    card.updatedAt = DateTime.now();
    await _box.put(card.id, card);
  }

  /// 카드 삭제
  Future<void> deleteCard(String cardId) async {
    await _box.delete(cardId);
  }

  /// 특정 카드 조회
  AACCard? getCard(String cardId) {
    return _box.get(cardId);
  }

  /// 모든 카드 삭제 (초기화)
  Future<void> clearAllCards() async {
    await _box.clear();
  }

  /// 기본 샘플 카드 생성 (앱 첫 실행 시)
  Future<void> initializeSampleCards() async {
    if (_box.isEmpty) {
      final sampleCards = _getSampleCards();
      for (var card in sampleCards) {
        await addCard(card);
      }
    }
  }

  /// 샘플 카드 데이터 (일상생활 기본 표현)
  List<AACCard> _getSampleCards() {
    final now = DateTime.now();
    
    return [
      // 감정 표현
      AACCard(
        id: 'emotion_happy',
        text: '행복해요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/742/742751.png',
        backgroundColor: '#FFE082',
        category: '감정',
        sortOrder: 0,
        createdAt: now,
        updatedAt: now,
      ),
      AACCard(
        id: 'emotion_sad',
        text: '슬퍼요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/742/742756.png',
        backgroundColor: '#90CAF9',
        category: '감정',
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
      ),
      AACCard(
        id: 'emotion_angry',
        text: '화났어요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/742/742752.png',
        backgroundColor: '#EF9A9A',
        category: '감정',
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
      ),
      
      // 기본 욕구
      AACCard(
        id: 'need_water',
        text: '물 마시고 싶어요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/924/924514.png',
        backgroundColor: '#81D4FA',
        category: '욕구',
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
      ),
      AACCard(
        id: 'need_food',
        text: '밥 먹고 싶어요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
        backgroundColor: '#FFE0B2',
        category: '욕구',
        sortOrder: 4,
        createdAt: now,
        updatedAt: now,
      ),
      AACCard(
        id: 'need_toilet',
        text: '화장실 가고 싶어요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2329/2329051.png',
        backgroundColor: '#E1BEE7',
        category: '욕구',
        sortOrder: 5,
        createdAt: now,
        updatedAt: now,
      ),
      
      // 인사말
      AACCard(
        id: 'greeting_hello',
        text: '안녕하세요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2040/2040946.png',
        backgroundColor: '#A5D6A7',
        category: '인사',
        sortOrder: 6,
        createdAt: now,
        updatedAt: now,
      ),
      AACCard(
        id: 'greeting_bye',
        text: '안녕히 가세요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2040/2040891.png',
        backgroundColor: '#B39DDB',
        category: '인사',
        sortOrder: 7,
        createdAt: now,
        updatedAt: now,
      ),
      AACCard(
        id: 'greeting_thanks',
        text: '고맙습니다',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2107/2107845.png',
        backgroundColor: '#F48FB1',
        category: '인사',
        sortOrder: 8,
        createdAt: now,
        updatedAt: now,
      ),
      
      // 활동
      AACCard(
        id: 'activity_play',
        text: '놀고 싶어요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3176/3176406.png',
        backgroundColor: '#FFF59D',
        category: '활동',
        sortOrder: 9,
        createdAt: now,
        updatedAt: now,
      ),
      AACCard(
        id: 'activity_sleep',
        text: '자고 싶어요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3460/3460335.png',
        backgroundColor: '#B0BEC5',
        category: '활동',
        sortOrder: 10,
        createdAt: now,
        updatedAt: now,
      ),
      AACCard(
        id: 'activity_help',
        text: '도와주세요',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/3588/3588435.png',
        backgroundColor: '#FFCC80',
        category: '활동',
        sortOrder: 11,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// 카드 순서 재정렬
  Future<void> reorderCards(List<AACCard> reorderedCards) async {
    for (int i = 0; i < reorderedCards.length; i++) {
      reorderedCards[i].sortOrder = i;
      await updateCard(reorderedCards[i]);
    }
  }
}
