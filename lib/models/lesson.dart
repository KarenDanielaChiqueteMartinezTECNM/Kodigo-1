/// Modelo que representa una lección de programación
/// Contiene el contenido educativo y metadatos
class Lesson {
  final String id;
  final String title;
  final String description;
  final int level;
  final String category; // variables, loops, functions, etc.
  final List<String> concepts; // conceptos que enseña
  final String content; // contenido de la lección
  final List<Question> questions; // preguntas/ejercicios
  final int estimatedMinutes;
  final bool isCompleted;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.category,
    required this.concepts,
    required this.content,
    required this.questions,
    required this.estimatedMinutes,
    this.isCompleted = false,
  });

  /// Convierte la lección a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'level': level,
      'category': category,
      'concepts': concepts,
      'content': content,
      'questions': questions.map((q) => q.toMap()).toList(),
      'estimatedMinutes': estimatedMinutes,
      'isCompleted': isCompleted,
    };
  }

  /// Crea una lección desde un mapa
  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      level: map['level'] ?? 1,
      category: map['category'] ?? '',
      concepts: List<String>.from(map['concepts'] ?? []),
      content: map['content'] ?? '',
      questions: (map['questions'] as List<dynamic>?)
          ?.map((q) => Question.fromMap(q as Map<String, dynamic>))
          .toList() ?? [],
      estimatedMinutes: map['estimatedMinutes'] ?? 5,
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  /// Crea una copia de la lección con algunos campos modificados
  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    int? level,
    String? category,
    List<String>? concepts,
    String? content,
    List<Question>? questions,
    int? estimatedMinutes,
    bool? isCompleted,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      level: level ?? this.level,
      category: category ?? this.category,
      concepts: concepts ?? this.concepts,
      content: content ?? this.content,
      questions: questions ?? this.questions,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Modelo que representa una pregunta o ejercicio dentro de una lección
class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  /// Convierte la pregunta a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
    };
  }

  /// Crea una pregunta desde un mapa
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
      explanation: map['explanation'] ?? '',
    );
  }
}
