import 'package:flutter/material.dart';

class AppColors {
  //لون مخصص لشاشة تسجيل الدخول
  static const Color loginBackground = Color(0xFF1E1E1E);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
// --- الألوان الأساسية ---
    primary: Color(0xFF3B1E54), 
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color.fromARGB(255, 240, 229, 251), 
    onPrimaryContainer: Color(0xFF3B1E54),
    
    // --- الألوان الثانوية (الأخضر الربيعي) ---
    secondary: Color(0xFF4ADE80), 
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD1FADF),
    onSecondaryContainer: Color(0xFF166534),

    // --- ألوان الأخطاء  ---
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF991B1B),

    // --- ألوان الخلفيات والأسطح ---
    surface: Color(0xFFFAF9FF),
    onSurface: Color(0xFF181C1F),
    surfaceContainerHighest: Color(0xFFF3E8FF),
    onSurfaceVariant: Color(0xFF40484F),
    
    // لون الحدود والخطوط الفاصلة
    outline: Color(0xFF9CA3AF),
    outlineVariant: Color(0xFFE5E7EB),


  );
  
}
extension ThemeExtension on BuildContext {
  ColorScheme get color => Theme.of(this).colorScheme;
}
