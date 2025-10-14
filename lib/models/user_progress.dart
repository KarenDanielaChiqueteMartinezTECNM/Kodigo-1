/// Modelo que representa el progreso de un usuario en una lección específica
/// Se usa para el algoritmo KNN y seguimiento de rendimiento
class UserProgress {
  final String userId;
  final String lessonId;
  final int score; // puntuación obtenida (0-100)
  final double timeSpent; // tiempo en minutos
  final int attempts; // número de intentos
  final DateTime completedAt;
  final int level; // nivel del usuario al completar
  final String category; // categoría de la lección

  const UserProgress({
    required this.userId,
    required this.lessonId,
    required this.score,
    required this.timeSpent,
    required this.attempts,
    required this.completedAt,
    required this.level,
    required this.category,
  });

  /// Convierte el progreso a un mapa
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'lessonId': lessonId,
      'score': score,
      'timeSpent': timeSpent,
      'attempts': attempts,
      'completedAt': completedAt.toIso8601String(),
      'level': level,
      'category': category,
    };
  }

  /// Crea un progreso desde un mapa
  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      userId: map['userId'] ?? '',
      lessonId: map['lessonId'] ?? '',
      score: map['score'] ?? 0,
      timeSpent: map['timeSpent']?.toDouble() ?? 0.0,
      attempts: map['attempts'] ?? 1,
      completedAt: DateTime.parse(map['completedAt'] ?? DateTime.now().toIso8601String()),
      level: map['level'] ?? 1,
      category: map['category'] ?? '',
    );
  }

  /// Convierte el progreso a un vector numérico para el algoritmo KNN
  /// [score, timeSpent, attempts, level]
  List<double> toVector() {
    return [
      score.toDouble(),
      timeSpent,
      attempts.toDouble(),
      level.toDouble(),
    ];
  }

  /// Calcula un puntaje de rendimiento normalizado (0.0 - 1.0)
  /// Considera score, tiempo y intentos
  double get performanceScore {
    // Normalizar score (0-100 -> 0-1)
    double normalizedScore = score / 100.0;
    
    // Penalizar por tiempo excesivo (más de 15 minutos es malo)
    double timeScore = (15.0 - timeSpent.clamp(0, 15)) / 15.0;
    
    // Penalizar por muchos intentos (más de 3 es malo)
    double attemptsScore = (4.0 - attempts.clamp(1, 4)) / 3.0;
    
    // Promedio ponderado: score es más importante
    return (normalizedScore * 0.6) + (timeScore * 0.25) + (attemptsScore * 0.15);
  }
}

/// Modelo para recomendaciones generadas por el algoritmo KNN
class Recommendation {
  final String lessonId;
  final String title;
  final String category;
  final int level;
  final double confidence; // qué tan segura es la recomendación (0.0 - 1.0)
  final String reason; // explicación de por qué se recomienda

  const Recommendation({
    required this.lessonId,
    required this.title,
    required this.category,
    required this.level,
    required this.confidence,
    required this.reason,
  });

  /// Convierte la recomendación a un mapa
  Map<String, dynamic> toMap() {
    return {
      'lessonId': lessonId,
      'title': title,
      'category': category,
      'level': level,
      'confidence': confidence,
      'reason': reason,
    };
  }

  /// Crea una recomendación desde un mapa
  factory Recommendation.fromMap(Map<String, dynamic> map) {
    return Recommendation(
      lessonId: map['lessonId'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      level: map['level'] ?? 1,
      confidence: map['confidence']?.toDouble() ?? 0.0,
      reason: map['reason'] ?? '',
    );
  }
}
