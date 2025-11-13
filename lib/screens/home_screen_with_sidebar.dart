import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/aac_card.dart';
import '../models/category_index.dart';
import '../services/hybrid_storage_service.dart';
import '../services/tts_service.dart';
import 'card_edit_screen.dart';
import 'category_management_screen.dart';

/// AAC 메인 화면 - 사이드바 + 카드 그리드
class HomeScreenWithSidebar extends StatefulWidget {
  const HomeScreenWithSidebar({super.key});

  @override
  State<HomeScreenWithSidebar> createState() => _HomeScreenWithSidebarState();
}

class _HomeScreenWithSidebarState extends State<HomeScreenWithSidebar> {
  final HybridStorageService _storageService = HybridStorageService();
  final TTSService _ttsService = TTSService();
  
  List<AACCard> _cards = [];
  List<CategoryIndex> _categories = [];
  String? _selectedCategoryId;
  
  // 사이드바 확장 상태 (true: 확장, false: 축소)
  bool _isSidebarExpanded = true;
  
  // 로딩 상태
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  /// 서비스 초기화 및 데이터 로드
  Future<void> _initializeServices() async {
    setState(() => _isLoading = true);
    
    await _ttsService.initialize();
    
    // Firestore에서 데이터 로드 (첫 실행 시)
    await _storageService.initializeFromFirestore();
    
    _loadCategories();
    _loadCards();
    
    setState(() => _isLoading = false);
  }

  /// 카테고리 목록 로드
  void _loadCategories() {
    setState(() {
      _categories = _storageService.getAllCategories();
    });
  }

  /// 카드 목록 로드
  void _loadCards() {
    setState(() {
      if (_selectedCategoryId == null || _selectedCategoryId == 'category_all') {
        _cards = _storageService.getAllCards();
      } else {
        // 선택된 카테고리의 이름 찾기
        final category = _categories.firstWhere(
          (cat) => cat.id == _selectedCategoryId,
          orElse: () => _categories.first,
        );
        _cards = _storageService.getCardsByCategory(category.name);
      }
    });
  }

  /// 카테고리 선택
  void _selectCategory(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _loadCards();
    });
  }

  /// 사이드바 토글
  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }

  /// 카드 탭 - TTS 음성 출력
  Future<void> _onCardTap(AACCard card) async {
    await _ttsService.speak(card.text);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🔊 ${card.text}',
            style: const TextStyle(fontSize: 18),
          ),
          duration: const Duration(milliseconds: 800),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.shade700,
        ),
      );
    }
  }

  /// 카드 추가
  void _addNewCard() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CardEditScreen(),
      ),
    );
    
    if (result == true) {
      _loadCards();
    }
  }

  /// 카드 수정
  void _editCard(AACCard card) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardEditScreen(card: card),
      ),
    );
    
    if (result == true) {
      _loadCards();
    }
  }

  /// 카드 삭제
  void _deleteCard(AACCard card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('카드 삭제'),
        content: Text('정말로 "${card.text}" 카드를 삭제하시겠습니까?'),
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
      await _storageService.deleteCard(card.id);
      _loadCards();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카드가 삭제되었습니다 (로컬 + 클라우드)')),
        );
      }
    }
  }

  /// 카테고리 관리 화면으로 이동
  void _manageCaategories() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryManagementScreen(),
      ),
    );
    
    if (result == true) {
      _loadCategories();
      _loadCards();
    }
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // 왼쪽 사이드바
            _buildSidebar(),
            
            // 오른쪽 메인 콘텐츠
            Expanded(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Firebase에서 데이터 로딩 중...'),
                              ],
                            ),
                          )
                        : _cards.isEmpty
                            ? _buildEmptyState()
                            : _buildCardGrid(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewCard,
        icon: const Icon(Icons.add),
        label: const Text('카드 추가'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// 왼쪽 사이드바
  Widget _buildSidebar() {
    final sidebarWidth = _isSidebarExpanded ? 200.0 : 80.0;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Column(
        children: [
          // 사이드바 헤더
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_isSidebarExpanded)
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      '카테고리',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    _isSidebarExpanded 
                        ? Icons.chevron_left 
                        : Icons.chevron_right,
                    color: Colors.white,
                  ),
                  onPressed: _toggleSidebar,
                  tooltip: _isSidebarExpanded ? '사이드바 축소' : '사이드바 확장',
                ),
              ],
            ),
          ),
          
          // 카테고리 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategoryId == category.id;
                
                return _buildCategoryItem(category, isSelected);
              },
            ),
          ),
          
          // 카테고리 관리 버튼
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: _isSidebarExpanded
                ? ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('카테고리 관리'),
                    onTap: _manageCaategories,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: _manageCaategories,
                    tooltip: '카테고리 관리',
                  ),
          ),
        ],
      ),
    );
  }

  /// 카테고리 아이템
  Widget _buildCategoryItem(CategoryIndex category, bool isSelected) {
    final bgColor = _parseColor(category.backgroundColor);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: isSelected ? bgColor.withValues(alpha: 0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _selectCategory(category.id),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: _isSidebarExpanded
                ? Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          category.icon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        category.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  /// 앱바
  Widget _buildAppBar() {
    final selectedCategory = _selectedCategoryId != null
        ? _categories.firstWhere(
            (cat) => cat.id == _selectedCategoryId,
            orElse: () => _categories.first,
          )
        : null;
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              selectedCategory != null 
                  ? selectedCategory.name 
                  : 'AAC 의사소통',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            '${_cards.length}개',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  /// 빈 상태
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.grid_view,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '카드가 없습니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '아래 버튼을 눌러 카드를 추가해보세요',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// 카드 그리드
  Widget _buildCardGrid() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return _buildCardItem(card);
        },
      ),
    );
  }

  /// 개별 카드 아이템
  Widget _buildCardItem(AACCard card) {
    final bgColor = card.backgroundColor != null
        ? _parseColor(card.backgroundColor!)
        : Colors.blue.shade100;

    return GestureDetector(
      onTap: () => _onCardTap(card),
      onLongPress: () => _showCardOptions(card),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CachedNetworkImage(
                  imageUrl: card.imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  card.text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 카드 옵션 메뉴
  void _showCardOptions(AACCard card) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('카드 수정'),
                onTap: () {
                  Navigator.pop(context);
                  _editCard(card);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('카드 삭제'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteCard(card);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// 16진수 색상 파싱
  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.blue.shade100;
    }
  }
}
