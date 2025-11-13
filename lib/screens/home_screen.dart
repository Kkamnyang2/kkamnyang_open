import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/aac_card.dart';
import '../services/aac_service.dart';
import '../services/tts_service.dart';
import 'card_edit_screen.dart';

/// AAC 메인 화면 - 플립북 형태의 카드 그리드
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AACService _aacService = AACService();
  final TTSService _ttsService = TTSService();
  List<AACCard> _cards = [];
  String? _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  /// 서비스 초기화 및 데이터 로드
  Future<void> _initializeServices() async {
    await _ttsService.initialize();
    await _aacService.initializeSampleCards();
    _loadCards();
  }

  /// 카드 목록 로드
  void _loadCards() {
    setState(() {
      if (_selectedCategory == null || _selectedCategory == '전체') {
        _cards = _aacService.getAllCards();
      } else {
        _cards = _aacService.getCardsByCategory(_selectedCategory!);
      }
    });
  }

  /// 카테고리 목록 가져오기
  List<String> _getCategories() {
    final allCards = _aacService.getAllCards();
    final categories = allCards
        .map((card) => card.category ?? '기타')
        .toSet()
        .toList();
    categories.insert(0, '전체');
    return categories;
  }

  /// 카드 탭 - TTS 음성 출력
  Future<void> _onCardTap(AACCard card) async {
    await _ttsService.speak(card.text);
    
    // 시각적 피드백 (mounted 체크 추가)
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

  /// 카드 추가 화면으로 이동
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

  /// 카드 수정 화면으로 이동
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

  /// 카드 삭제 확인 다이얼로그
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
      await _aacService.deleteCard(card.id);
      _loadCards();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카드가 삭제되었습니다')),
        );
      }
    }
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getCategories();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AAC 의사소통', 
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // 카테고리 필터
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: '카테고리 필터',
            onSelected: (category) {
              setState(() {
                _selectedCategory = category == '전체' ? null : category;
                _loadCards();
              });
            },
            itemBuilder: (context) => categories.map((category) {
              return PopupMenuItem<String>(
                value: category,
                child: Row(
                  children: [
                    Icon(
                      category == (_selectedCategory ?? '전체')
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(category),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: SafeArea(
        child: _cards.isEmpty
            ? _buildEmptyState()
            : _buildCardGrid(),
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

  /// 빈 상태 UI
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
            '아직 카드가 없습니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '아래 버튼을 눌러 첫 카드를 추가해보세요',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// 카드 그리드 UI (플립북 형태)
  Widget _buildCardGrid() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 한 줄에 3개씩
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85, // 카드 비율
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
            // 카드 이미지
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
            // 카드 텍스트
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

  /// 카드 옵션 메뉴 (수정/삭제)
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
