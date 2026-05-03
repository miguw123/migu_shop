import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/user_provider.dart';
import '../providers/video_provider.dart';
import '../providers/product_provider.dart';
import '../providers/order_provider.dart';
import '../providers/warehouse_provider.dart';
import '../providers/message_provider.dart';
import '../pages/video/video_home_page.dart';
import '../pages/purchase/purchase_list_page.dart';
import '../pages/message/message_list_page.dart';
import '../pages/public/public_square_page.dart';
import '../pages/profile/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const VideoHomePage(),
    const PurchaseListPage(),
    const MessageListPage(),
    const PublicSquarePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            activeIcon: Icon(Icons.play_circle_filled),
            label: '视频',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: '求购',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public_outlined),
            activeIcon: Icon(Icons.public),
            label: '公域',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
