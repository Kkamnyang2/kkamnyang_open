import 'package:flutter/foundation.dart';
import '../models/aac_card.dart';
import '../models/category_index.dart';
import 'aac_service.dart';
import 'category_service.dart';
import 'firestore_service.dart';

/// 하이브리드 저장소 서비스
/// - Hive (로컬) + Firestore (클라우드) 통합 관리
/// - 오프라인 우선: Hive를 메인으로 사용하고 Firestore에 백업
/// - 자동 동기화: 변경사항을 양쪽에 저장
class HybridStorageService {
  final AACService _aacService = AACService();
  final CategoryService _categoryService = CategoryService();
  final FirestoreService _firestoreService = FirestoreService();

  // ==================== 초기화 ====================

  /// Firestore에서 초기 데이터 로드
  Future<void> initializeFromFirestore() async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 Loading initial data from Firestore...');
      }

      // Firestore에서 카테고리 가져오기
      final categories = await _firestoreService.getAllCategoriesFromFirestore();
      if (categories.isNotEmpty) {
        // Hive에 저장 (로컬 캐시)
        for (var category in categories) {
          await _categoryService.addCategory(category);
        }
        if (kDebugMode) {
          debugPrint('✅ Loaded ${categories.length} categories from Firestore');
        }
      }

      // Firestore에서 카드 가져오기
      final cards = await _firestoreService.getAllCardsFromFirestore();
      if (cards.isNotEmpty) {
        // Hive에 저장 (로컬 캐시)
        for (var card in cards) {
          await _aacService.addCard(card);
        }
        if (kDebugMode) {
          debugPrint('✅ Loaded ${cards.length} cards from Firestore');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Firestore load failed (using local data): $e');
      }
      // Firestore 접근 실패해도 로컬 Hive 데이터 사용
    }
  }

  // ==================== 카테고리 관리 ====================

  /// 카테고리 추가 (로컬 + 클라우드)
  Future<void> addCategory(CategoryIndex category) async {
    // 1. 로컬에 저장 (빠른 응답)
    await _categoryService.addCategory(category);

    // 2. 클라우드에 백업 (비동기)
    try {
      await _firestoreService.addCategoryToFirestore(category);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Firestore backup failed for category: $e');
      }
      // 로컬 저장은 성공했으므로 계속 진행
    }
  }

  /// 카테고리 수정 (로컬 + 클라우드)
  Future<void> updateCategory(CategoryIndex category) async {
    // 1. 로컬 업데이트
    await _categoryService.updateCategory(category);

    // 2. 클라우드 업데이트
    try {
      await _firestoreService.updateCategoryInFirestore(category);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Firestore update failed for category: $e');
      }
    }
  }

  /// 카테고리 삭제 (로컬 + 클라우드)
  Future<void> deleteCategory(String categoryId) async {
    // 1. 로컬에서 삭제
    await _categoryService.deleteCategory(categoryId);

    // 2. 클라우드에서 삭제
    try {
      await _firestoreService.deleteCategoryFromFirestore(categoryId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Firestore delete failed for category: $e');
      }
    }
  }

  /// 카테고리 목록 조회 (로컬 우선)
  List<CategoryIndex> getAllCategories() {
    return _categoryService.getAllCategories();
  }

  /// 카테고리 순서 재정렬 (로컬 + 클라우드)
  Future<void> reorderCategories(List<CategoryIndex> reorderedCategories) async {
    // 1. 로컬 재정렬
    await _categoryService.reorderCategories(reorderedCategories);

    // 2. 클라우드 재정렬
    try {
      for (var category in reorderedCategories) {
        await _firestoreService.updateCategoryInFirestore(category);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Firestore reorder failed for categories: $e');
      }
    }
  }

  // ==================== 카드 관리 ====================

  /// 카드 추가 (로컬 + 클라우드)
  Future<void> addCard(AACCard card) async {
    // 1. 로컬에 저장 (빠른 응답)
    await _aacService.addCard(card);

    // 2. 클라우드에 백업 (비동기)
    try {
      await _firestoreService.addCardToFirestore(card);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Firestore backup failed for card: $e');
      }
    }
  }

  /// 카드 수정 (로컬 + 클라우드)
  Future<void> updateCard(AACCard card) async {
    // 1. 로컬 업데이트
    await _aacService.updateCard(card);

    // 2. 클라우드 업데이트
    try {
      await _firestoreService.updateCardInFirestore(card);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Firestore update failed for card: $e');
      }
    }
  }

  /// 카드 삭제 (로컬 + 클라우드)
  Future<void> deleteCard(String cardId) async {
    // 1. 로컬에서 삭제
    await _aacService.deleteCard(cardId);

    // 2. 클라우드에서 삭제
    try {
      await _firestoreService.deleteCardFromFirestore(cardId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Firestore delete failed for card: $e');
      }
    }
  }

  /// 카드 목록 조회 (로컬 우선)
  List<AACCard> getAllCards() {
    return _aacService.getAllCards();
  }

  /// 카테고리별 카드 조회 (로컬 우선)
  List<AACCard> getCardsByCategory(String category) {
    return _aacService.getCardsByCategory(category);
  }

  /// 카드 순서 재정렬 (로컬 + 클라우드)
  Future<void> reorderCards(List<AACCard> reorderedCards) async {
    // 1. 로컬 재정렬
    await _aacService.reorderCards(reorderedCards);

    // 2. 클라우드 재정렬
    try {
      for (var card in reorderedCards) {
        await _firestoreService.updateCardInFirestore(card);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Firestore reorder failed for cards: $e');
      }
    }
  }

  // ==================== 동기화 ====================

  /// 클라우드에서 최신 데이터 가져오기
  Future<void> syncFromCloud() async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 Syncing from cloud...');
      }

      // Firestore에서 데이터 가져오기
      final categories = await _firestoreService.getAllCategoriesFromFirestore();
      final cards = await _firestoreService.getAllCardsFromFirestore();

      // 로컬 데이터 초기화
      await _categoryService.clearAllCategories();
      await _aacService.clearAllCards();

      // 클라우드 데이터로 업데이트
      for (var category in categories) {
        await _categoryService.addCategory(category);
      }

      for (var card in cards) {
        await _aacService.addCard(card);
      }

      if (kDebugMode) {
        debugPrint('✅ Sync completed: ${categories.length} categories, ${cards.length} cards');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Sync from cloud failed: $e');
      }
      rethrow;
    }
  }

  /// 로컬 데이터를 클라우드에 백업
  Future<void> backupToCloud() async {
    try {
      if (kDebugMode) {
        debugPrint('☁️ Backing up to cloud...');
      }

      // 로컬 데이터 가져오기
      final categories = _categoryService.getAllCategories();
      final cards = _aacService.getAllCards();

      // 클라우드에 업로드
      for (var category in categories) {
        await _firestoreService.addCategoryToFirestore(category);
      }

      for (var card in cards) {
        await _firestoreService.addCardToFirestore(card);
      }

      if (kDebugMode) {
        debugPrint('✅ Backup completed: ${categories.length} categories, ${cards.length} cards');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Backup to cloud failed: $e');
      }
      rethrow;
    }
  }
}
