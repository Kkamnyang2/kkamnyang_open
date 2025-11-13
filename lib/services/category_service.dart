import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category_index.dart';

/// 카테고리 인덱스 관리 서비스
class CategoryService {
  static const String _boxName = 'category_indexes';
  
  /// Hive Box 가져오기
  Box<CategoryIndex> get _box => Hive.box<CategoryIndex>(_boxName);

  /// 모든 카테고리 조회 (sortOrder 기준 정렬)
  List<CategoryIndex> getAllCategories() {
    final categories = _box.values.toList();
    categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return categories;
  }

  /// 카테고리 추가
  Future<void> addCategory(CategoryIndex category) async {
    await _box.put(category.id, category);
  }

  /// 카테고리 수정
  Future<void> updateCategory(CategoryIndex category) async {
    category.updatedAt = DateTime.now();
    await _box.put(category.id, category);
  }

  /// 카테고리 삭제
  Future<void> deleteCategory(String categoryId) async {
    await _box.delete(categoryId);
  }

  /// 특정 카테고리 조회
  CategoryIndex? getCategory(String categoryId) {
    return _box.get(categoryId);
  }

  /// 모든 카테고리 삭제
  Future<void> clearAllCategories() async {
    await _box.clear();
  }

  /// 카테고리 순서 재정렬
  Future<void> reorderCategories(List<CategoryIndex> reorderedCategories) async {
    for (int i = 0; i < reorderedCategories.length; i++) {
      reorderedCategories[i].sortOrder = i;
      await updateCategory(reorderedCategories[i]);
    }
  }

  /// 기본 샘플 카테고리 생성 (앱 첫 실행 시)
  Future<void> initializeSampleCategories() async {
    if (_box.isEmpty) {
      final sampleCategories = _getSampleCategories();
      for (var category in sampleCategories) {
        await addCategory(category);
      }
    }
  }

  /// 샘플 카테고리 데이터
  List<CategoryIndex> _getSampleCategories() {
    final now = DateTime.now();
    
    return [
      CategoryIndex(
        id: 'category_emotion',
        name: '감정',
        iconCode: Icons.sentiment_satisfied.codePoint,
        backgroundColor: '#FFE082',
        sortOrder: 0,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryIndex(
        id: 'category_need',
        name: '욕구',
        iconCode: Icons.restaurant.codePoint,
        backgroundColor: '#90CAF9',
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryIndex(
        id: 'category_greeting',
        name: '인사',
        iconCode: Icons.waving_hand.codePoint,
        backgroundColor: '#A5D6A7',
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryIndex(
        id: 'category_activity',
        name: '활동',
        iconCode: Icons.sports_soccer.codePoint,
        backgroundColor: '#F48FB1',
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
      ),
      CategoryIndex(
        id: 'category_all',
        name: '전체',
        iconCode: Icons.apps.codePoint,
        backgroundColor: '#B0BEC5',
        sortOrder: 4,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
