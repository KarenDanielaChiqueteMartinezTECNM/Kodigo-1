import 'package:flutter/material.dart';
import '../../models/lesson.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/lesson_service.dart';
import '../../widgets/lesson_card.dart';
import '../../widgets/custom_button.dart';
import 'lesson_detail_screen.dart';

/// Pantalla principal de lecciones
/// Muestra las lecciones disponibles organizadas por categorías
class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  User? _currentUser;
  List<Lesson> _lessons = [];
  List<Lesson> _filteredLessons = [];
  String _selectedCategory = 'Todas';
  bool _isLoading = true;

  final List<String> _categories = [
    'Todas',
    'Variables',
    'Condicionales',
    'Bucles',
    'Funciones',
    'Arrays',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Carga los datos del usuario y las lecciones
  Future<void> _loadData() async {
    try {
      final authService = AuthService();
      final lessonService = LessonService();

      _currentUser = await authService.getCurrentUser();
      _lessons = await lessonService.getLessons();
      _filteredLessons = _lessons;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando datos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Filtra las lecciones por categoría
  void _filterLessons(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'Todas') {
        _filteredLessons = _lessons;
      } else {
        _filteredLessons = _lessons.where((lesson) => lesson.category == category).toList();
      }
    });
  }

  /// Navega a los detalles de una lección
  void _openLesson(Lesson lesson) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LessonDetailScreen(lesson: lesson),
      ),
    ).then((_) {
      // Recargar datos cuando regrese de la lección
      _loadData();
    });
  }

  /// Cierra sesión y regresa al login
  Future<void> _logout() async {
    final authService = AuthService();
    await authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecciones'),
        actions: [
          // Botón de progreso
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.of(context).pushNamed('/progress');
            },
            tooltip: 'Ver progreso',
          ),
          // Menú de usuario
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  _currentUser?.name.isNotEmpty == true 
                      ? _currentUser!.name[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Información del usuario
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola, ${_currentUser?.name ?? 'Usuario'}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStatCard('Nivel', '${_currentUser?.currentLevel ?? 1}'),
                          const SizedBox(width: 16),
                          _buildStatCard('Lecciones', '${_currentUser?.lessonsCompleted ?? 0}'),
                          const SizedBox(width: 16),
                          _buildStatCard('Puntos', '${_currentUser?.totalScore ?? 0}'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Filtros de categoría
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      String category = _categories[index];
                      bool isSelected = category == _selectedCategory;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) => _filterLessons(category),
                          backgroundColor: Colors.grey[200],
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                  ),
                ),

                // Lista de lecciones
                Expanded(
                  child: _filteredLessons.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay lecciones disponibles',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Selecciona otra categoría',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredLessons.length,
                          itemBuilder: (context, index) {
                            Lesson lesson = _filteredLessons[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: LessonCard(
                                lesson: lesson,
                                onTap: () => _openLesson(lesson),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  /// Construye una tarjeta de estadística
  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
