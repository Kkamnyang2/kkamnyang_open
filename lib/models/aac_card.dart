import 'package:hive/hive.dart';

part 'aac_card.g.dart';

/// AAC 카드 데이터 모델
/// - Hive 로컬 저장소에 저장되는 의사소통 카드
/// - 이미지 URL과 텍스트를 포함하여 TTS 음성 출력 지원
@HiveType(typeId: 0)
class AACCard extends HiveObject {
  /// 카드 고유 ID
  @HiveField(0)
  String id;

  /// 표시할 텍스트 (TTS로 읽힐 내용)
  @HiveField(1)
  String text;

  /// 이미지 URL (외부 이미지 링크 또는 로컬 경로)
  @HiveField(2)
  String imageUrl;

  /// 카드 배경색 (16진수 색상 코드)
  @HiveField(3)
  String? backgroundColor;

  /// 카드 생성 시간
  @HiveField(4)
  DateTime createdAt;

  /// 카드 마지막 수정 시간
  @HiveField(5)
  DateTime updatedAt;

  /// 카드 정렬 순서 (낮은 숫자가 앞에 표시)
  @HiveField(6)
  int sortOrder;

  /// 카테고리 (예: "감정", "음식", "활동" 등)
  @HiveField(7)
  String? category;

  AACCard({
    required this.id,
    required this.text,
    required this.imageUrl,
    this.backgroundColor,
    required this.createdAt,
    required this.updatedAt,
    this.sortOrder = 0,
    this.category,
  });

  /// JSON으로부터 AACCard 생성
  factory AACCard.fromJson(Map<String, dynamic> json) {
    return AACCard(
      id: json['id'] as String,
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String,
      backgroundColor: json['backgroundColor'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sortOrder: json['sortOrder'] as int? ?? 0,
      category: json['category'] as String?,
    );
  }

  /// AACCard를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'backgroundColor': backgroundColor,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sortOrder': sortOrder,
      'category': category,
    };
  }

  /// 카드 복사본 생성 (일부 필드 업데이트 가능)
  AACCard copyWith({
    String? id,
    String? text,
    String? imageUrl,
    String? backgroundColor,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sortOrder,
    String? category,
  }) {
    return AACCard(
      id: id ?? this.id,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'AACCard(id: $id, text: $text, imageUrl: $imageUrl, category: $category)';
  }
}
