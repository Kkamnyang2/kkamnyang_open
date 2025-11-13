import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/aac_card.dart';
import '../services/hybrid_storage_service.dart';

/// 카드 추가/수정 화면
class CardEditScreen extends StatefulWidget {
  final AACCard? card; // null이면 추가, 값이 있으면 수정

  const CardEditScreen({super.key, this.card});

  @override
  State<CardEditScreen> createState() => _CardEditScreenState();
}

class _CardEditScreenState extends State<CardEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final HybridStorageService _storageService = HybridStorageService();
  
  late TextEditingController _textController;
  late TextEditingController _imageUrlController;
  late TextEditingController _categoryController;
  
  String? _selectedColor;
  bool _isLoading = false;

  // 기본 색상 팔레트
  final List<String> _colorPalette = [
    '#FFE082', // 노란색
    '#90CAF9', // 파란색
    '#EF9A9A', // 빨간색
    '#81D4FA', // 하늘색
    '#FFE0B2', // 주황색
    '#E1BEE7', // 보라색
    '#A5D6A7', // 초록색
    '#F48FB1', // 분홍색
    '#FFF59D', // 연노랑
    '#B0BEC5', // 회색
    '#FFCC80', // 살구색
    '#80CBC4', // 청록색
  ];

  @override
  void initState() {
    super.initState();
    
    // 수정 모드면 기존 데이터로 초기화
    final card = widget.card;
    _textController = TextEditingController(text: card?.text ?? '');
    _imageUrlController = TextEditingController(text: card?.imageUrl ?? '');
    _categoryController = TextEditingController(text: card?.category ?? '');
    _selectedColor = card?.backgroundColor ?? _colorPalette[0];
  }

  @override
  void dispose() {
    _textController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  /// 카드 저장
  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      final card = widget.card?.copyWith(
        text: _textController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        category: _categoryController.text.trim().isEmpty 
            ? null 
            : _categoryController.text.trim(),
        backgroundColor: _selectedColor,
        updatedAt: now,
      ) ?? AACCard(
        id: 'card_${now.millisecondsSinceEpoch}',
        text: _textController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        category: _categoryController.text.trim().isEmpty 
            ? null 
            : _categoryController.text.trim(),
        backgroundColor: _selectedColor,
        createdAt: now,
        updatedAt: now,
        sortOrder: _storageService.getAllCards().length,
      );

      if (widget.card == null) {
        await _storageService.addCard(card);
      } else {
        await _storageService.updateCard(card);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.card == null 
                ? '카드가 추가되었습니다 (로컬 + 클라우드)' 
                : '카드가 수정되었습니다 (로컬 + 클라우드)'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류 발생: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.card != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? '카드 수정' : '카드 추가'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: '저장',
              onPressed: _saveCard,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이미지 미리보기
                _buildImagePreview(),
                const SizedBox(height: 24),
                
                // 텍스트 입력
                TextFormField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: '카드 텍스트 *',
                    hintText: '예: 안녕하세요',
                    prefixIcon: Icon(Icons.text_fields),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '텍스트를 입력해주세요';
                    }
                    return null;
                  },
                  maxLength: 30,
                ),
                const SizedBox(height: 16),
                
                // 이미지 URL 입력
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: '이미지 URL *',
                    hintText: 'https://example.com/image.png',
                    prefixIcon: Icon(Icons.image),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '이미지 URL을 입력해주세요';
                    }
                    if (!value.startsWith('http')) {
                      return '올바른 URL 형식이 아닙니다';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // 실시간 미리보기 업데이트
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                
                // 카테고리 입력
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: '카테고리 (선택)',
                    hintText: '예: 감정, 욕구, 인사, 활동',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 20,
                ),
                const SizedBox(height: 24),
                
                // 배경색 선택
                const Text(
                  '배경색',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildColorPicker(),
                
                const SizedBox(height: 32),
                
                // 저장 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _saveCard,
                    icon: const Icon(Icons.save),
                    label: Text(isEditMode ? '수정 완료' : '카드 추가'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 이미지 미리보기
  Widget _buildImagePreview() {
    final imageUrl = _imageUrlController.text.trim();
    
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: _parseColor(_selectedColor ?? _colorPalette[0]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: imageUrl.isEmpty || !imageUrl.startsWith('http')
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '이미지 미리보기',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '이미지를 불러올 수 없습니다',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  /// 색상 선택 팔레트
  Widget _buildColorPicker() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _colorPalette.map((color) {
        final isSelected = _selectedColor == color;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = color;
            });
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _parseColor(color),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue.shade900 : Colors.grey.shade300,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 28,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  /// 16진수 색상 코드를 Color로 변환
  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.blue.shade100;
    }
  }
}
