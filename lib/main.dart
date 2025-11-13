import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/aac_card.dart';
import 'models/category_index.dart';
import 'screens/home_screen_with_sidebar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화 (Multi-platform support)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Hive 초기화 (로컬 저장소)
  await Hive.initFlutter();
  
  // 타입 어댑터 등록
  Hive.registerAdapter(AACCardAdapter());
  Hive.registerAdapter(CategoryIndexAdapter());
  
  // Hive Box 열기
  await Hive.openBox<AACCard>('aac_cards');
  await Hive.openBox<CategoryIndex>('category_indexes');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAC 의사소통',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        
        // 접근성 최적화 - 큰 터치 영역
        visualDensity: VisualDensity.comfortable,
        
        // 앱바 테마
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        
        // 플로팅 액션 버튼 테마
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        
        // 카드 테마
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        
        // 입력 필드 테마
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      home: const HomeScreenWithSidebar(),
    );
  }
}
