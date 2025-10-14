import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/lessons/lessons_screen.dart';
import 'screens/progress/progress_screen.dart';

/// Punto de entrada principal de la aplicación
/// Configura el tema y la navegación inicial
void main() {
  runApp(const ProgrammingTutorApp());
}

class ProgrammingTutorApp extends StatelessWidget {
  const ProgrammingTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programming Tutor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Colores suaves y amigables para una app educativa
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF4A90E2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      // Pantalla inicial: Login
      home: const LoginScreen(),
      // Rutas nombradas para navegación
      routes: {
        '/login': (context) => const LoginScreen(),
        '/lessons': (context) => const LessonsScreen(),
        '/progress': (context) => const ProgressScreen(),
      },
    );
  }
}
