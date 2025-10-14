import 'package:flutter/material.dart';
import '../models/user_progress.dart';

/// Widget que muestra una recomendación generada por el algoritmo KNN
/// Presenta la lección recomendada con información sobre por qué se sugiere
class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;
  final VoidCallback onTap;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con título y confianza
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(recommendation.category)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getCategoryColor(recommendation.category)
                                      .withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                recommendation.category,
                                style: TextStyle(
                                  color: _getCategoryColor(recommendation.category),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.signal_cellular_alt,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Nivel ${recommendation.level}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Indicador de confianza
                  _buildConfidenceIndicator(),
                ],
              ),
              const SizedBox(height: 12),

              // Razón de la recomendación
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation.reason,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Botón de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Comenzar lección'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el indicador de confianza de la recomendación
  Widget _buildConfidenceIndicator() {
    Color confidenceColor;
    String confidenceText;
    IconData confidenceIcon;

    if (recommendation.confidence >= 0.8) {
      confidenceColor = Colors.green;
      confidenceText = 'Alta';
      confidenceIcon = Icons.trending_up;
    } else if (recommendation.confidence >= 0.6) {
      confidenceColor = Colors.orange;
      confidenceText = 'Media';
      confidenceIcon = Icons.trending_flat;
    } else {
      confidenceColor = Colors.grey;
      confidenceText = 'Baja';
      confidenceIcon = Icons.trending_down;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: confidenceColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: confidenceColor.withOpacity(0.3),
            ),
          ),
          child: Icon(
            confidenceIcon,
            color: confidenceColor,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          confidenceText,
          style: TextStyle(
            color: confidenceColor,
            fontSize: 10,
            fontWeight: FontWeight.w500,
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
