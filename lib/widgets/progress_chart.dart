import 'package:flutter/material.dart';
import '../models/user_progress.dart';

/// Widget que muestra un gráfico de barras del progreso por categoría
/// Visualiza el rendimiento del usuario en diferentes áreas de programación
class ProgressChart extends StatelessWidget {
  final List<UserProgress> userProgress;

  const ProgressChart({
    super.key,
    required this.userProgress,
  });

  @override
  Widget build(BuildContext context) {
    if (userProgress.isEmpty) {
      return const SizedBox.shrink();
    }

    // Agrupar progreso por categoría y calcular promedios
    Map<String, List<UserProgress>> progressByCategory = {};
    for (var progress in userProgress) {
      if (!progressByCategory.containsKey(progress.category)) {
        progressByCategory[progress.category] = [];
      }
      progressByCategory[progress.category]!.add(progress);
    }

    // Calcular estadísticas por categoría
    List<CategoryStats> categoryStats = progressByCategory.entries.map((entry) {
      String category = entry.key;
      List<UserProgress> categoryProgress = entry.value;
      
      double averageScore = categoryProgress
          .map((p) => p.score)
          .reduce((a, b) => a + b) / categoryProgress.length;
      
      int lessonsCount = categoryProgress.length;
      
      return CategoryStats(
        category: category,
        averageScore: averageScore,
        lessonsCount: lessonsCount,
        color: _getCategoryColor(category),
      );
    }).toList();

    // Ordenar por puntuación promedio
    categoryStats.sort((a, b) => b.averageScore.compareTo(a.averageScore));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bar_chart,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Rendimiento por Categoría',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Gráfico de barras
            ...categoryStats.map((stats) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildProgressBar(stats),
            )).toList(),
            
            const SizedBox(height: 8),
            
            // Leyenda
            Text(
              'Basado en ${userProgress.length} lecciones completadas',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye una barra de progreso para una categoría
  Widget _buildProgressBar(CategoryStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stats.category,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${stats.averageScore.toInt()}% (${stats.lessonsCount} lecciones)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: stats.averageScore / 100,
            child: Container(
              decoration: BoxDecoration(
                color: stats.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Obtiene un color representativo para cada categoría
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
}

/// Clase auxiliar para estadísticas de categoría
class CategoryStats {
  final String category;
  final double averageScore;
  final int lessonsCount;
  final Color color;

  CategoryStats({
    required this.category,
    required this.averageScore,
    required this.lessonsCount,
    required this.color,
  });
}
