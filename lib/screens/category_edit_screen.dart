import 'package:flutter/material.dart';
import '../models/category_index.dart';
import '../services/hybrid_storage_service.dart';

/// 카테고리 추가/수정 화면
class CategoryEditScreen extends StatefulWidget {
  final CategoryIndex? category;

  const CategoryEditScreen({super.key, this.category});

  @override
  State<CategoryEditScreen> createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final HybridStorageService _storageService = HybridStorageService();
  
  late TextEditingController _nameController;
  
  IconData? _selectedIcon;
  String? _selectedColor;
  bool _isLoading = false;

  // 아이콘 목록
  final List<IconData> _iconList = [
    Icons.sentiment_satisfied,
    Icons.restaurant,
    Icons.waving_hand,
    Icons.sports_soccer,
    Icons.apps,
    Icons.favorite,
    Icons.home,
    Icons.school,
    Icons.local_hospital,
    Icons.directions_car,
    Icons.flight,
    Icons.beach_access,
    Icons.music_note,
    Icons.pets,
    Icons.shopping_cart,
    Icons.work,
    Icons.child_care,
    Icons.fastfood,
  ];

  // 색상 팔레트
  final List<String> _colorPalette = [
    '#FFE082',
    '#90CAF9',
    '#EF9A9A',
    '#81D4FA',
    '#FFE0B2',
    '#E1BEE7',
    '#A5D6A7',
    '#F48FB1',
    '#FFF59D',
    '#B0BEC5',
    '#FFCC80',
    '#80CBC4',
  ];

  @override
  void initState() {
    super.initState();
    
    final category = widget.category;
    _nameController = TextEditingController(text: category?.name ?? '');
    _selectedIcon = category?.icon ?? _iconList[0];
    _selectedColor = category?.backgroundColor ?? _colorPalette[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// 카테고리 저장
  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이콘을 선택해주세요')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      final category = widget.category?.copyWith(
        name: _nameController.text.trim(),
        iconCode: _selectedIcon!.codePoint,
        backgroundColor: _selectedColor!,
        updatedAt: now,
      ) ?? CategoryIndex(
        id: 'category_${now.millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        iconCode: _selectedIcon!.codePoint,
        backgroundColor: _selectedColor!,
        createdAt: now,
        updatedAt: now,
        sortOrder: _storageService.getAllCategories().length,
      );

      if (widget.category == null) {
        await _storageService.addCategory(category);
      } else {
        await _storageService.updateCategory(category);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.category == null 
                ? '카테고리가 추가되었습니다 (로컬 + 클라우드)' 
                : '카테고리가 수정되었습니다 (로컬 + 클라우드)'),
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
    final isEditMode = widget.category != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? '카테고리 수정' : '카테고리 추가'),
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
              onPressed: _saveCategory,
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
                // 미리보기
                _buildPreview(),
                const SizedBox(height: 24),
                
                // 카테고리 이름
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '카테고리 이름 *',
                    hintText: '예: 감정, 욕구, 인사',
                    prefixIcon: Icon(Icons.text_fields),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '카테고리 이름을 입력해주세요';
                    }
                    return null;
                  },
                  maxLength: 20,
                  onChanged: (value) {
                    setState(() {}); // 미리보기 업데이트
                  },
                ),
                const SizedBox(height: 24),
                
                // 아이콘 선택
                const Text(
                  '아이콘 선택 *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildIconPicker(),
                const SizedBox(height: 24),
                
                // 배경색 선택
                const Text(
                  '배경색 선택 *',
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
                    onPressed: _isLoading ? null : _saveCategory,
                    icon: const Icon(Icons.save),
                    label: Text(isEditMode ? '수정 완료' : '카테고리 추가'),
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

  /// 미리보기
  Widget _buildPreview() {
    final bgColor = _parseColor(_selectedColor ?? _colorPalette[0]);
    final name = _nameController.text.trim().isEmpty 
        ? '카테고리 이름' 
        : _nameController.text.trim();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            '미리보기',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _selectedIcon ?? Icons.help_outline,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 아이콘 선택기
  Widget _buildIconPicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _iconList.map((icon) {
          final isSelected = _selectedIcon?.codePoint == icon.codePoint;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIcon = icon;
              });
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.blue.shade700 
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue.shade900 : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade700,
                size: 32,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 색상 선택기
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

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.blue.shade100;
    }
  }
}
