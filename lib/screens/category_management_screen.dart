import 'package:flutter/material.dart';
import '../models/category_index.dart';
import '../services/hybrid_storage_service.dart';
import 'category_edit_screen.dart';

/// 카테고리 관리 화면
class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final HybridStorageService _storageService = HybridStorageService();
  List<CategoryIndex> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categories = _storageService.getAllCategories();
    });
  }

  /// 카테고리 추가
  void _addCategory() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryEditScreen(),
      ),
    );
    
    if (result == true) {
      _loadCategories();
    }
  }

  /// 카테고리 수정
  void _editCategory(CategoryIndex category) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryEditScreen(category: category),
      ),
    );
    
    if (result == true) {
      _loadCategories();
    }
  }

  /// 카테고리 삭제
  void _deleteCategory(CategoryIndex category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('카테고리 삭제'),
        content: Text('정말로 "${category.name}" 카테고리를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await _storageService.deleteCategory(category.id);
      _loadCategories();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카테고리가 삭제되었습니다 (로컬 + 클라우드)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카테고리 관리'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: '완료',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
      body: SafeArea(
        child: _categories.isEmpty
            ? _buildEmptyState()
            : ReorderableListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _categories.length,
                onReorder: _onReorder,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return _buildCategoryItem(category, index);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCategory,
        icon: const Icon(Icons.add),
        label: const Text('카테고리 추가'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// 카테고리 순서 변경
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _categories.removeAt(oldIndex);
      _categories.insert(newIndex, item);
    });
    
    // 변경된 순서 저장 (로컬 + 클라우드)
    _storageService.reorderCategories(_categories);
  }

  /// 빈 상태
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '카테고리가 없습니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '아래 버튼을 눌러 카테고리를 추가해보세요',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// 카테고리 아이템
  Widget _buildCategoryItem(CategoryIndex category, int index) {
    final bgColor = _parseColor(category.backgroundColor);
    
    return Card(
      key: ValueKey(category.id),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            category.icon,
            color: Colors.white,
            size: 32,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('순서: ${index + 1}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editCategory(category),
              tooltip: '수정',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteCategory(category),
              tooltip: '삭제',
            ),
            const Icon(Icons.drag_handle, color: Colors.grey),
          ],
        ),
      ),
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
