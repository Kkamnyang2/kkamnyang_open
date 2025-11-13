import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/aac_card.dart';
import '../models/category_index.dart';

/// Firestore 서비스
/// - 클라우드 데이터베이스 CRUD 작업
/// - Hive와 함께 사용하여 하이브리드 저장소 구현
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== 카테고리 관련 ====================

  /// Firestore에서 모든 카테고리 조회
  Future<List<CategoryIndex>> getAllCategoriesFromFirestore() async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .orderBy('sortOrder')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryIndex(
          id: doc.id,
          name: data['name'] as String,
          iconCode: data['iconCode'] as int,
          backgroundColor: data['backgroundColor'] as String,
          sortOrder: data['sortOrder'] as int? ?? 0,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firestore getAllCategories error: $e');
      }
      return [];
    }
  }

  /// Firestore에 카테고리 추가
  Future<void> addCategoryToFirestore(CategoryIndex category) async {
    try {
      await _firestore.collection('categories').doc(category.id).set({
        'name': category.name,
        'iconCode': category.iconCode,
        'backgroundColor': category.backgroundColor,
        'sortOrder': category.sortOrder,
        'createdAt': Timestamp.fromDate(category.createdAt),
        'updatedAt': Timestamp.fromDate(category.updatedAt),
      });
      
      if (kDebugMode) {
        debugPrint('✅ Category added to Firestore: ${category.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firestore addCategory error: $e');
      }
      rethrow;
    }
  }

  /// Firestore에서 카테고리 수정
  Future<void> updateCategoryInFirestore(CategoryIndex category) async {
    try {
      await _firestore.collection('categories').doc(category.id).update({
        'name': category.name,
        'iconCode': category.iconCode,
        'backgroundColor': category.backgroundColor,
        'sortOrder': category.sortOrder,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
      
      if (kDebugMode) {
        debugPrint('✅ Category updated in Firestore: ${category.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firestore updateCategory error: $e');
      }
      rethrow;
    }
  }

  /// Firestore에서 카테고리 삭제
  Future<void> deleteCategoryFromFirestore(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
      
      if (kDebugMode) {
        debugPrint('✅ Category deleted from Firestore: $categoryId');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firestore deleteCategory error: $e');
      }
      rethrow;
    }
  }

  // ==================== 카드 관련 ====================

  /// Firestore에서 모든 카드 조회
  Future<List<AACCard>> getAllCardsFromFirestore() async {
    try {
      final snapshot = await _firestore
          .collection('aac_cards')
          .orderBy('sortOrder')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AACCard(
          id: doc.id,
          text: data['text'] as String,
          imageUrl: data['imageUrl'] as String,
          backgroundColor: data['backgroundColor'] as String?,
          category: data['category'] as String?,
          sortOrder: data['sortOrder'] as int? ?? 0,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firestore getAllCards error: $e');
      }
      return [];
    }
  }

  /// 카테고리별 카드 조회
  Future<List<AACCard>> getCardsByCategoryFromFirestore(String category) async {
    try {
      final snapshot = await _firestore
          .collection('aac_cards')
          .where('category', isEqualTo: category)
          .orderBy('sortOrder')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AACCard(
          id: doc.id,
          text: data['text'] as String,
          imageUrl: data['imageUrl'] as String,
          backgroundColor: data['backgroundColor'] as String?,
          category: data['category'] as String?,
          sortOrder: data['sortOrder'] as int? ?? 0,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firestore getCardsByCategory error: $e');
      }
      return [];
    }
  }

  /// Firestore에 카드 추가
  Future<void> addCardToFirestore(AACCard card) async {
    try {
      await _firestore.collection('aac_cards').doc(card.id).set({
        'text': card.text,
        'imageUrl': card.imageUrl,
        'backgroundColor': card.backgroundColor,
        'category': card.category,
        'sortOrder': card.sortOrder,
        'createdAt': Timestamp.fromDate(card.createdAt),
        'updatedAt': Timestamp.fromDate(card.updatedAt),
      });
      
      if (kDebugMode) {
        debugPrint('✅ Card added to Firestore: ${card.text}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firestore addCard error: $e');
      }
      rethrow;
    }
  }

  /// Firestore에서 카드 수정
  Future<void> updateCardInFirestore(AACCard card) async {
    try {
      await _firestore.collection('aac_cards').doc(card.id).update({
        'text': card.text,
        'imageUrl': card.imageUrl,
        'backgroundColor': card.backgroundColor,
        'category': card.category,
        'sortOrder': card.sortOrder,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
      
      if (kDebugMode) {
        debugPrint('✅ Card updated in Firestore: ${card.text}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firestore updateCard error: $e');
      }
      rethrow;
    }
  }

  /// Firestore에서 카드 삭제
  Future<void> deleteCardFromFirestore(String cardId) async {
    try {
      await _firestore.collection('aac_cards').doc(cardId).delete();
      
      if (kDebugMode) {
        debugPrint('✅ Card deleted from Firestore: $cardId');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firestore deleteCard error: $e');
      }
      rethrow;
    }
  }

  // ==================== 동기화 관련 ====================

  /// Firestore → Hive 동기화 (클라우드에서 로컬로)
  Future<void> syncFromFirestoreToHive({
    required Function(List<CategoryIndex>) onCategoriesSynced,
    required Function(List<AACCard>) onCardsSynced,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 Syncing from Firestore to Hive...');
      }

      // 카테고리 동기화
      final categories = await getAllCategoriesFromFirestore();
      onCategoriesSynced(categories);

      // 카드 동기화
      final cards = await getAllCardsFromFirestore();
      onCardsSynced(cards);

      if (kDebugMode) {
        debugPrint('✅ Sync completed: ${categories.length} categories, ${cards.length} cards');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Sync error: $e');
      }
      rethrow;
    }
  }

  /// 실시간 카테고리 스트림
  Stream<List<CategoryIndex>> getCategoriesStream() {
    return _firestore
        .collection('categories')
        .orderBy('sortOrder')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryIndex(
          id: doc.id,
          name: data['name'] as String,
          iconCode: data['iconCode'] as int,
          backgroundColor: data['backgroundColor'] as String,
          sortOrder: data['sortOrder'] as int? ?? 0,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  /// 실시간 카드 스트림
  Stream<List<AACCard>> getCardsStream() {
    return _firestore
        .collection('aac_cards')
        .orderBy('sortOrder')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AACCard(
          id: doc.id,
          text: data['text'] as String,
          imageUrl: data['imageUrl'] as String,
          backgroundColor: data['backgroundColor'] as String?,
          category: data['category'] as String?,
          sortOrder: data['sortOrder'] as int? ?? 0,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}
