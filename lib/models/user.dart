/// Modelo que representa un usuario de la aplicación
/// Contiene información básica y estadísticas de progreso
class User {
  final String id;
  final String name;
  final String email;
  final int currentLevel;
  final int totalScore;
  final int lessonsCompleted;
  final double averageTimePerLesson; // en minutos
  final DateTime lastActivity;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.currentLevel,
    required this.totalScore,
    required this.lessonsCompleted,
    required this.averageTimePerLesson,
    required this.lastActivity,
  });

  /// Convierte el usuario a un mapa para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'currentLevel': currentLevel,
      'totalScore': totalScore,
      'lessonsCompleted': lessonsCompleted,
      'averageTimePerLesson': averageTimePerLesson,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }

  /// Crea un usuario desde un mapa
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      currentLevel: map['currentLevel'] ?? 1,
      totalScore: map['totalScore'] ?? 0,
      lessonsCompleted: map['lessonsCompleted'] ?? 0,
      averageTimePerLesson: map['averageTimePerLesson']?.toDouble() ?? 0.0,
      lastActivity: DateTime.parse(map['lastActivity'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Crea una copia del usuario con algunos campos modificados
  User copyWith({
    String? id,
    String? name,
    String? email,
    int? currentLevel,
    int? totalScore,
    int? lessonsCompleted,
    double? averageTimePerLesson,
    DateTime? lastActivity,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      currentLevel: currentLevel ?? this.currentLevel,
      totalScore: totalScore ?? this.totalScore,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      averageTimePerLesson: averageTimePerLesson ?? this.averageTimePerLesson,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}
