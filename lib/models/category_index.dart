import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'category_index.g.dart';

/// 카테고리 인덱스 모델
/// - 왼쪽 사이드바에 표시되는 카테고리 네비게이션
/// - 아이콘, 이름, 순서 정보 포함
@HiveType(typeId: 1)
class CategoryIndex extends HiveObject {
  /// 카테고리 고유 ID
  @HiveField(0)
  String id;

  /// 카테고리 이름
  @HiveField(1)
  String name;

  /// 아이콘 코드 (Material Icons codePoint)
  @HiveField(2)
  int iconCode;

  /// 배경색 (16진수 색상 코드)
  @HiveField(3)
  String backgroundColor;

  /// 정렬 순서 (낮은 숫자가 위에 표시)
  @HiveField(4)
  int sortOrder;

  /// 카테고리 생성 시간
  @HiveField(5)
  DateTime createdAt;

  /// 카테고리 마지막 수정 시간
  @HiveField(6)
  DateTime updatedAt;

  CategoryIndex({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.backgroundColor,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// IconData 가져오기
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  /// JSON으로부터 CategoryIndex 생성
  factory CategoryIndex.fromJson(Map<String, dynamic> json) {
    return CategoryIndex(
      id: json['id'] as String,
      name: json['name'] as String,
      iconCode: json['iconCode'] as int,
      backgroundColor: json['backgroundColor'] as String,
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// CategoryIndex를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': iconCode,
      'backgroundColor': backgroundColor,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 카테고리 복사본 생성
  CategoryIndex copyWith({
    String? id,
    String? name,
    int? iconCode,
    String? backgroundColor,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryIndex(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CategoryIndex(id: $id, name: $name, sortOrder: $sortOrder)';
  }
}
