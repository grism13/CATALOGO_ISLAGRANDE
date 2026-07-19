import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2FA3BE);
  static const Color midBlue = Color(0xFF1381A5);
  static const Color darkBlue = Color(0xFF1E4D6D);
  static const Color lightYellow = Color(0xFFF6E7AA);
  static const Color backgroundColor = Color(0xFFEBF5FF);
  
  static const Color backgroundColorLight = Color(0xFFF2F5F8);
  static const Color lightTeal = Color(0xFFC7E2E9);
  static const Color paleYellow = Color(0xFFF3E7B2);
  static const Color veryLightTeal = Color(0xFFE4F0F4);
  static const Color darkTeal = Color(0xFFABC9D6);
  
  static const Color rechazado = Color.fromARGB(255, 124, 23, 23);
  static const Color concretado = Color.fromARGB(255, 22, 98, 93);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    
    // Aplicar tipografía a toda la aplicación
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'YanoneKaffeesatz',
      bodyColor: darkBlue,
      displayColor: darkBlue,
    ).copyWith(
      displayLarge: const TextStyle(
        fontFamily: 'YanoneKaffeesatz',
        color: darkBlue,
        fontSize: 32, 
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'YanoneKaffeesatz',
        color: darkBlue,
        fontSize: 18, 
      ),
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBlue,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: lightYellow),
      titleTextStyle: TextStyle(
        fontFamily: 'YanoneKaffeesatz',
        color: backgroundColor,
        fontSize: 24, 
      ),
    ),
  );
}
