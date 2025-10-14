import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/user_progress.dart';
import '../../models/lesson.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../services/lesson_service.dart';
import '../../services/knn_service.dart';
import '../../widgets/progress_chart.dart';
import '../../widgets/recommendation_card.dart';
import '../../widgets/stats_card.dart';

/// Pantalla de progreso y recomendaciones personalizadas
/// Muestra estadísticas del usuario y recomendaciones generadas por KNN
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  User? _currentUser;
  List<UserProgress> _userProgress = [];
  List<Recommendation> _recommendations = [];
  ProgressStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Carga todos los datos necesarios para la pantalla
  Future<void> _loadData() async {
    try {
      final authService = AuthService();
      final progressService = ProgressService();
      final lessonService = LessonService();

      // Generar datos de ejemplo si es la primera vez
      await progressService.generateSampleProgress();

      // Cargar datos del usuario
      _currentUser = await authService.getCurrentUser();
      
      if (_currentUser != null) {
        // Cargar progreso del usuario
        _userProgress = await progressService.getUserProgress(_currentUser!.id);
        
        // Cargar estadísticas
        _stats = await progressService.getUserStats(_currentUser!.id);
        
        // Generar recomendaciones usando KNN
        await _generateRecommendations();
      }

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

  /// Genera recomendaciones usando el algoritmo KNN
  Future<void> _generateRecommendations() async {
    try {
      final progressService = ProgressService();
      final lessonService = LessonService();

      // Obtener todo el progreso (de todos los usuarios)
      List<UserProgress> allProgress = await progressService.getAllProgress();
      
      // Obtener todas las lecciones disponibles
      List<Lesson> availableLessons = await lessonService.getLessons();

      // Generar recomendaciones usando KNN
      _recommendations = KNNService.generateRecommendations(
        userProgress: _userProgress,
        allProgress: allProgress,
        availableLessons: availableLessons,
        k: 3, // Usar 3 usuarios similares
      );
    } catch (e) {
      print('Error generando recomendaciones: $e');
      _recommendations = [];
    }
  }

  /// Navega a una lección recomendada
  void _openRecommendedLesson(String lessonId) async {
    final lessonService = LessonService();
    Lesson? lesson = await lessonService.getLessonById(lessonId);
    
    if (lesson != null && mounted) {
      Navigator.of(context).pushNamed('/lessons');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Progreso'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Saludo personalizado
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),

                  // Estadísticas generales
                  _buildStatsSection(),
                  const SizedBox(height: 24),

                  // Gráfico de progreso
                  _buildProgressChart(),
                  const SizedBox(height: 24),

                  // Progreso reciente
                  _buildRecentProgress(),
                  const SizedBox(height: 24),

                  // Recomendaciones KNN
                  _buildRecommendations(),
                ],
              ),
            ),
    );
  }

  /// Construye la sección de bienvenida
  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Text(
                  _currentUser?.name.isNotEmpty == true 
                      ? _currentUser!.name[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
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
                    const SizedBox(height: 4),
                    Text(
                      'Aquí está tu progreso de aprendizaje',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye la sección de estadísticas
  Widget _buildStatsSection() {
    if (_stats == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas Generales',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Lecciones',
                value: '${_stats!.totalLessons}',
                subtitle: 'Completadas',
                icon: Icons.school,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'Promedio',
                value: '${_stats!.averageScore.toInt()}%',
                subtitle: 'Puntuación',
                icon: Icons.grade,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Tiempo',
                value: '${_stats!.averageTime.toInt()}m',
                subtitle: 'Por lección',
                icon: Icons.timer,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'Progreso',
                value: '${(_stats!.completionRate * 100).toInt()}%',
                subtitle: 'Completado',
                icon: Icons.trending_up,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye el gráfico de progreso
  Widget _buildProgressChart() {
    if (_userProgress.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progreso por Categoría',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ProgressChart(userProgress: _userProgress),
      ],
    );
  }

  /// Construye la sección de progreso reciente
  Widget _buildRecentProgress() {
    if (_userProgress.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.school_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'Aún no has completado lecciones',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '¡Comienza tu primera lección!',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Tomar las últimas 3 lecciones
    List<UserProgress> recentProgress = _userProgress
        .toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    recentProgress = recentProgress.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progreso Reciente',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...recentProgress.map((progress) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getCategoryColor(progress.category),
                child: Text(
                  progress.category[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(progress.category),
              subtitle: Text(
                'Completado el ${_formatDate(progress.completedAt)}',
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${progress.score}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${progress.timeSpent.toInt()}m',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )).toList(),
      ],
    );
  }

  /// Construye la sección de recomendaciones KNN
  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.psychology,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Recomendaciones Personalizadas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Basadas en usuarios con progreso similar al tuyo',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        
        if (_recommendations.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Completa más lecciones para obtener recomendaciones',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...(_recommendations.take(3).map((recommendation) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RecommendationCard(
              recommendation: recommendation,
              onTap: () => _openRecommendedLesson(recommendation.lessonId),
            ),
          )).toList()),
      ],
    );
  }

  /// Obtiene un color para cada categoría
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'variables':
        return Colors.blue;
      case 'condicionales':
        return Colors.orange;
      case 'bucles':
        return Colors.purple;
      case 'funciones':
        return Colors.green;
      case 'arrays':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Formatea una fecha para mostrar
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
