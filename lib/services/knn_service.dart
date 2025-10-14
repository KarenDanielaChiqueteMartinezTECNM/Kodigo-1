import 'dart:math';
import '../models/user_progress.dart';
import '../models/lesson.dart';

/// Servicio que implementa el algoritmo K-Nearest Neighbors (KNN)
/// para generar recomendaciones educativas personalizadas
/// 
/// El algoritmo funciona de la siguiente manera:
/// 1. Toma el historial de progreso del usuario actual
/// 2. Compara con el progreso de otros usuarios similares
/// 3. Encuentra los K usuarios más parecidos usando distancia euclidiana
/// 4. Recomienda lecciones que esos usuarios completaron exitosamente
class KNNService {
  /// Número de vecinos más cercanos a considerar (K)
  static const int defaultK = 5;

  /// Genera recomendaciones para un usuario basándose en usuarios similares
  /// 
  /// [userProgress] - Lista del progreso del usuario actual
  /// [allProgress] - Lista de todo el progreso de todos los usuarios
  /// [availableLessons] - Lista de lecciones disponibles
  /// [k] - Número de vecinos más cercanos a considerar
  /// 
  /// Retorna una lista de recomendaciones ordenadas por confianza
  static List<Recommendation> generateRecommendations({
    required List<UserProgress> userProgress,
    required List<UserProgress> allProgress,
    required List<Lesson> availableLessons,
    int k = defaultK,
  }) {
    // Si el usuario no tiene progreso, recomendar lecciones básicas
    if (userProgress.isEmpty) {
      return _getBeginnerRecommendations(availableLessons);
    }

    // Calcular el perfil promedio del usuario actual
    List<double> userProfile = _calculateUserProfile(userProgress);
    
    // Encontrar usuarios similares
    List<SimilarUser> similarUsers = _findSimilarUsers(
      userProfile: userProfile,
      userProgress: userProgress,
      allProgress: allProgress,
      k: k,
    );

    // Generar recomendaciones basadas en usuarios similares
    List<Recommendation> recommendations = _generateRecommendationsFromSimilarUsers(
      similarUsers: similarUsers,
      userProgress: userProgress,
      availableLessons: availableLessons,
    );

    // Ordenar por confianza y retornar las mejores
    recommendations.sort((a, b) => b.confidence.compareTo(a.confidence));
    return recommendations.take(10).toList();
  }

  /// Calcula el perfil promedio de un usuario basado en su progreso
  /// Retorna un vector con [score_promedio, tiempo_promedio, intentos_promedio, nivel_actual]
  static List<double> _calculateUserProfile(List<UserProgress> userProgress) {
    if (userProgress.isEmpty) return [0, 0, 0, 1];

    double avgScore = userProgress.map((p) => p.score).reduce((a, b) => a + b) / userProgress.length;
    double avgTime = userProgress.map((p) => p.timeSpent).reduce((a, b) => a + b) / userProgress.length;
    double avgAttempts = userProgress.map((p) => p.attempts).reduce((a, b) => a + b) / userProgress.length;
    double currentLevel = userProgress.map((p) => p.level).reduce(max).toDouble();

    return [avgScore, avgTime, avgAttempts, currentLevel];
  }

  /// Encuentra los K usuarios más similares usando distancia euclidiana
  static List<SimilarUser> _findSimilarUsers({
    required List<double> userProfile,
    required List<UserProgress> userProgress,
    required List<UserProgress> allProgress,
    required int k,
  }) {
    // Agrupar progreso por usuario
    Map<String, List<UserProgress>> progressByUser = {};
    for (var progress in allProgress) {
      if (!progressByUser.containsKey(progress.userId)) {
        progressByUser[progress.userId] = [];
      }
      progressByUser[progress.userId]!.add(progress);
    }

    // Calcular similitud con cada usuario
    List<SimilarUser> similarities = [];
    String currentUserId = userProgress.isNotEmpty ? userProgress.first.userId : '';

    for (var entry in progressByUser.entries) {
      String otherUserId = entry.key;
      List<UserProgress> otherProgress = entry.value;

      // No comparar consigo mismo
      if (otherUserId == currentUserId) continue;

      // Calcular perfil del otro usuario
      List<double> otherProfile = _calculateUserProfile(otherProgress);

      // Calcular distancia euclidiana
      double distance = _calculateEuclideanDistance(userProfile, otherProfile);

      // Convertir distancia a similitud (menor distancia = mayor similitud)
      double similarity = 1.0 / (1.0 + distance);

      similarities.add(SimilarUser(
        userId: otherUserId,
        similarity: similarity,
        progress: otherProgress,
      ));
    }

    // Ordenar por similitud y tomar los K más similares
    similarities.sort((a, b) => b.similarity.compareTo(a.similarity));
    return similarities.take(k).toList();
  }

  /// Calcula la distancia euclidiana entre dos vectores
  static double _calculateEuclideanDistance(List<double> vector1, List<double> vector2) {
    if (vector1.length != vector2.length) {
      throw ArgumentError('Los vectores deben tener la misma longitud');
    }

    double sum = 0;
    for (int i = 0; i < vector1.length; i++) {
      // Normalizar valores para que tengan el mismo peso
      double diff;
      switch (i) {
        case 0: // Score (0-100)
          diff = (vector1[i] - vector2[i]) / 100.0;
          break;
        case 1: // Time (normalizar a 0-20 minutos)
          diff = (vector1[i] - vector2[i]) / 20.0;
          break;
        case 2: // Attempts (normalizar a 0-5 intentos)
          diff = (vector1[i] - vector2[i]) / 5.0;
          break;
        case 3: // Level (normalizar a 0-10 niveles)
          diff = (vector1[i] - vector2[i]) / 10.0;
          break;
        default:
          diff = vector1[i] - vector2[i];
      }
      sum += diff * diff;
    }
    return sqrt(sum);
  }

  /// Genera recomendaciones basándose en usuarios similares
  static List<Recommendation> _generateRecommendationsFromSimilarUsers({
    required List<SimilarUser> similarUsers,
    required List<UserProgress> userProgress,
    required List<Lesson> availableLessons,
  }) {
    // Obtener lecciones ya completadas por el usuario
    Set<String> completedLessons = userProgress.map((p) => p.lessonId).toSet();

    // Contar recomendaciones de usuarios similares
    Map<String, RecommendationScore> lessonScores = {};

    for (var similarUser in similarUsers) {
      for (var progress in similarUser.progress) {
        // Solo considerar lecciones exitosas (score >= 70)
        if (progress.score >= 70 && !completedLessons.contains(progress.lessonId)) {
          if (!lessonScores.containsKey(progress.lessonId)) {
            lessonScores[progress.lessonId] = RecommendationScore(
              lessonId: progress.lessonId,
              totalWeight: 0,
              count: 0,
              avgPerformance: 0,
            );
          }

          var score = lessonScores[progress.lessonId]!;
          score.totalWeight += similarUser.similarity;
          score.count++;
          score.avgPerformance += progress.performanceScore;
        }
      }
    }

    // Convertir a recomendaciones
    List<Recommendation> recommendations = [];
    for (var entry in lessonScores.entries) {
      String lessonId = entry.key;
      RecommendationScore score = entry.value;

      // Buscar la lección correspondiente
      Lesson? lesson = availableLessons.where((l) => l.id == lessonId).firstOrNull;
      if (lesson == null) continue;

      // Calcular confianza basada en peso total y rendimiento promedio
      double avgPerformance = score.avgPerformance / score.count;
      double confidence = (score.totalWeight / similarUsers.length) * avgPerformance;

      // Generar razón de la recomendación
      String reason = _generateRecommendationReason(lesson, score.count, confidence);

      recommendations.add(Recommendation(
        lessonId: lessonId,
        title: lesson.title,
        category: lesson.category,
        level: lesson.level,
        confidence: confidence.clamp(0.0, 1.0),
        reason: reason,
      ));
    }

    return recommendations;
  }

  /// Genera recomendaciones para usuarios principiantes
  static List<Recommendation> _getBeginnerRecommendations(List<Lesson> availableLessons) {
    return availableLessons
        .where((lesson) => lesson.level == 1)
        .take(5)
        .map((lesson) => Recommendation(
              lessonId: lesson.id,
              title: lesson.title,
              category: lesson.category,
              level: lesson.level,
              confidence: 0.8,
              reason: 'Recomendado para principiantes en ${lesson.category}',
            ))
        .toList();
  }

  /// Genera una explicación de por qué se recomienda una lección
  static String _generateRecommendationReason(Lesson lesson, int userCount, double confidence) {
    if (confidence > 0.8) {
      return 'Altamente recomendado: $userCount usuarios similares tuvieron excelente rendimiento';
    } else if (confidence > 0.6) {
      return 'Recomendado: Usuarios con perfil similar completaron esta lección exitosamente';
    } else {
      return 'Sugerido: Podría ser útil basado en tu progreso actual';
    }
  }
}

/// Clase auxiliar para representar un usuario similar
class SimilarUser {
  final String userId;
  final double similarity;
  final List<UserProgress> progress;

  SimilarUser({
    required this.userId,
    required this.similarity,
    required this.progress,
  });
}

/// Clase auxiliar para calcular puntajes de recomendación
class RecommendationScore {
  final String lessonId;
  double totalWeight;
  int count;
  double avgPerformance;

  RecommendationScore({
    required this.lessonId,
    required this.totalWeight,
    required this.count,
    required this.avgPerformance,
  });
}
