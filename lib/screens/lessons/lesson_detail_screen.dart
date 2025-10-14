import 'package:flutter/material.dart';
import '../../models/lesson.dart';
import '../../models/user_progress.dart';
import '../../services/progress_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';

/// Pantalla de detalles de una lección
/// Muestra el contenido y permite realizar ejercicios interactivos
class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _showExplanation = false;
  bool _isCompleted = false;
  int _score = 0;
  int _attempts = 0;
  DateTime? _startTime;
  List<bool> _questionResults = [];

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _questionResults = List.filled(widget.lesson.questions.length, false);
  }

  /// Selecciona una respuesta para la pregunta actual
  void _selectAnswer(int index) {
    if (_showExplanation) return;
    
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  /// Confirma la respuesta seleccionada
  void _confirmAnswer() {
    if (_selectedAnswerIndex == null || _showExplanation) return;

    Question currentQuestion = widget.lesson.questions[_currentQuestionIndex];
    bool isCorrect = _selectedAnswerIndex == currentQuestion.correctAnswerIndex;

    setState(() {
      _showExplanation = true;
      _attempts++;
      _questionResults[_currentQuestionIndex] = isCorrect;
      
      if (isCorrect) {
        _score += (100 / widget.lesson.questions.length).round();
      }
    });
  }

  /// Avanza a la siguiente pregunta o completa la lección
  void _nextQuestion() {
    if (_currentQuestionIndex < widget.lesson.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _showExplanation = false;
      });
    } else {
      _completeLesson();
    }
  }

  /// Marca la lección como completada y guarda el progreso
  Future<void> _completeLesson() async {
    if (_isCompleted) return;

    setState(() {
      _isCompleted = true;
    });

    try {
      final authService = AuthService();
      final progressService = ProgressService();
      final currentUser = await authService.getCurrentUser();

      if (currentUser != null && _startTime != null) {
        // Calcular tiempo transcurrido
        double timeSpent = DateTime.now().difference(_startTime!).inMinutes.toDouble();
        if (timeSpent < 1) timeSpent = 1; // Mínimo 1 minuto

        // Crear registro de progreso
        UserProgress progress = UserProgress(
          userId: currentUser.id,
          lessonId: widget.lesson.id,
          score: _score,
          timeSpent: timeSpent,
          attempts: _attempts,
          completedAt: DateTime.now(),
          level: currentUser.currentLevel,
          category: widget.lesson.category,
        );

        // Guardar progreso
        await progressService.saveProgress(progress);

        // Actualizar estadísticas del usuario
        int newTotalScore = currentUser.totalScore + _score;
        int newLessonsCompleted = currentUser.lessonsCompleted + 1;
        
        // Calcular nuevo promedio de tiempo
        double newAverageTime = currentUser.lessonsCompleted > 0
            ? ((currentUser.averageTimePerLesson * currentUser.lessonsCompleted) + timeSpent) / newLessonsCompleted
            : timeSpent;

        // Calcular nuevo nivel (cada 500 puntos = 1 nivel)
        int newLevel = (newTotalScore / 500).floor() + 1;

        // Actualizar usuario
        var updatedUser = currentUser.copyWith(
          totalScore: newTotalScore,
          lessonsCompleted: newLessonsCompleted,
          averageTimePerLesson: newAverageTime,
          currentLevel: newLevel,
          lastActivity: DateTime.now(),
        );

        await authService.updateCurrentUser(updatedUser);
      }

      // Mostrar diálogo de felicitaciones
      _showCompletionDialog();
    } catch (e) {
      print('Error guardando progreso: $e');
      _showCompletionDialog();
    }
  }

  /// Muestra el diálogo de felicitaciones al completar la lección
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.celebration,
              color: Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text('¡Felicidades!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Has completado la lección "${widget.lesson.title}"'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Puntuación:'),
                      Text(
                        '$_score/100',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Respuestas correctas:'),
                      Text(
                        '${_questionResults.where((r) => r).length}/${_questionResults.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          CustomButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).pop(); // Volver a lecciones
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.lesson.title),
        ),
        body: const Center(
          child: Text('Esta lección no tiene ejercicios disponibles'),
        ),
      );
    }

    Question currentQuestion = widget.lesson.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          // Progreso
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${_currentQuestionIndex + 1}/${widget.lesson.questions.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de progreso
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.lesson.questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),

          // Contenido de la lección
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información de la lección
                  if (_currentQuestionIndex == 0) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contenido de la lección',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(widget.lesson.content),
                            const SizedBox(height: 12),
                            Text(
                              'Conceptos clave:',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: widget.lesson.concepts.map((concept) {
                                return Chip(
                                  label: Text(concept),
                                  backgroundColor: Colors.blue[50],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Pregunta actual
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pregunta ${_currentQuestionIndex + 1}',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentQuestion.question,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Opciones de respuesta
                          ...currentQuestion.options.asMap().entries.map((entry) {
                            int index = entry.key;
                            String option = entry.value;
                            bool isSelected = _selectedAnswerIndex == index;
                            bool isCorrect = index == currentQuestion.correctAnswerIndex;
                            bool showResult = _showExplanation;

                            Color? backgroundColor;
                            Color? borderColor;
                            IconData? icon;

                            if (showResult) {
                              if (isCorrect) {
                                backgroundColor = Colors.green[50];
                                borderColor = Colors.green;
                                icon = Icons.check_circle;
                              } else if (isSelected && !isCorrect) {
                                backgroundColor = Colors.red[50];
                                borderColor = Colors.red;
                                icon = Icons.cancel;
                              }
                            } else if (isSelected) {
                              backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
                              borderColor = Theme.of(context).primaryColor;
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                onTap: () => _selectAnswer(index),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(
                                      color: borderColor ?? Colors.grey[300]!,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      if (icon != null)
                                        Icon(
                                          icon,
                                          color: isCorrect ? Colors.green : Colors.red,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),

                          // Explicación
                          if (_showExplanation) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lightbulb_outline,
                                        color: Colors.blue[700],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Explicación',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(currentQuestion.explanation),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botones de acción
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_showExplanation)
                  Expanded(
                    child: CustomButton(
                      onPressed: _nextQuestion,
                      child: Text(
                        _currentQuestionIndex < widget.lesson.questions.length - 1
                            ? 'Siguiente pregunta'
                            : 'Completar lección',
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: CustomButton(
                      onPressed: _selectedAnswerIndex != null ? _confirmAnswer : null,
                      child: const Text('Confirmar respuesta'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
