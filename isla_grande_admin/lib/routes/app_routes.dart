import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/product_edit_screen.dart';
import '../screens/product_create_screen.dart';
import '../screens/order_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/product_detail_screen.dart';

class AppRoutes {
  static const String initialRoute = 'main';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      'main': (context) => const MainScreen(),
      'product_edit': (context) => const ProductEditScreen(),
      'product_create': (context) => const ProductCreateScreen(),
      'order_detail': (context) => const OrderDetailScreen(),
      'profile': (context) => const ProfileScreen(),
      'product_detail': (context) => const ProductDetailScreen(),
    };
  }
}
