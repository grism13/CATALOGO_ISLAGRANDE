import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'home_screen.dart';
import 'inventory_screen.dart';
import 'orders_screen.dart';
import '../theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const InventoryScreen(),
    const OrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: AppTheme.backgroundColor,
        color: AppTheme.darkBlue,
        buttonBackgroundColor: AppTheme.lightYellow,
        index: _currentIndex,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined, color: _currentIndex == 0 ? AppTheme.darkBlue : AppTheme.lightYellow),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.grid_view_outlined, color: _currentIndex == 1 ? AppTheme.darkBlue : AppTheme.lightYellow),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.shopping_bag_outlined, color: _currentIndex == 2 ? AppTheme.darkBlue : AppTheme.lightYellow),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
