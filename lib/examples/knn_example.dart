import '../models/user_progress.dart';
import '../models/lesson.dart';
import '../services/knn_service.dart';

/// Ejemplo práctico del algoritmo KNN para recomendaciones educativas
/// Este archivo demuestra cómo funciona el sistema de recomendaciones
/// con datos de ejemplo y explicaciones paso a paso
class KNNExample {
  
  /// Ejecuta un ejemplo completo del algoritmo KNN
  /// Muestra el proceso paso a paso con datos reales
  static void runExample() {
    print('=== EJEMPLO DEL ALGORITMO KNN ===\n');
    
    // 1. Crear datos de ejemplo
    print('1. DATOS DE USUARIOS SIMULADOS:');
    List<UserProgress> allProgress = _createSampleData();
    _printUserData(allProgress);
    
    // 2. Crear usuario nuevo
    print('\n2. NUEVO USUARIO (sin historial):');
    List<UserProgress> newUserProgress = [];
    print('   - Usuario ID: new_user_001');
    print('   - Progreso: Ninguno (usuario nuevo)');
    
    // 3. Crear lecciones disponibles
    print('\n3. LECCIONES DISPONIBLES:');
    List<Lesson> availableLessons = _createSampleLessons();
    _printLessons(availableLessons);
    
    // 4. Generar recomendaciones para usuario nuevo
    print('\n4. RECOMENDACIONES PARA USUARIO NUEVO:');
    List<Recommendation> newUserRecommendations = KNNService.generateRecommendations(
      userProgress: newUserProgress,
      allProgress: allProgress,
      availableLessons: availableLessons,
      k: 3,
    );
    _printRecommendations(newUserRecommendations, 'Usuario nuevo');
    
    // 5. Simular progreso del usuario
    print('\n5. SIMULANDO PROGRESO DEL USUARIO:');
    List<UserProgress> userWithProgress = [
      UserProgress(
        userId: 'new_user_001',
        lessonId: 'var_001',
        score: 75,
        timeSpent: 12.0,
        attempts: 2,
        completedAt: DateTime.now(),
        level: 1,
        category: 'Variables',
      ),
    ];
    print('   - Completó: Introducción a Variables');
    print('   - Score: 75/100');
    print('   - Tiempo: 12 minutos');
    print('   - Intentos: 2');
    
    // 6. Generar nuevas recomendaciones basadas en progreso
    print('\n6. NUEVAS RECOMENDACIONES BASADAS EN PROGRESO:');
    List<Recommendation> progressBasedRecommendations = KNNService.generateRecommendations(
      userProgress: userWithProgress,
      allProgress: allProgress,
      availableLessons: availableLessons,
      k: 3,
    );
    _printRecommendations(progressBasedRecommendations, 'Usuario con progreso');
    
    // 7. Explicar el algoritmo
    print('\n7. EXPLICACIÓN DEL ALGORITMO:');
    _explainAlgorithm();
    
    print('\n=== FIN DEL EJEMPLO ===');
  }
  
  /// Crea datos de ejemplo de diferentes tipos de usuarios
  static List<UserProgress> _createSampleData() {
    return [
      // Usuario principiante exitoso
      UserProgress(
        userId: 'user_beginner_good',
        lessonId: 'var_001',
        score: 85,
        timeSpent: 10.0,
        attempts: 1,
        completedAt: DateTime.now().subtract(Duration(days: 5)),
        level: 1,
        category: 'Variables',
      ),
      UserProgress(
        userId: 'user_beginner_good',
        lessonId: 'var_002',
        score: 90,
        timeSpent: 8.0,
        attempts: 1,
        completedAt: DateTime.now().subtract(Duration(days: 4)),
        level: 1,
        category: 'Variables',
      ),
      
      // Usuario principiante con dificultades
      UserProgress(
        userId: 'user_beginner_struggling',
        lessonId: 'var_001',
        score: 60,
        timeSpent: 20.0,
        attempts: 3,
        completedAt: DateTime.now().subtract(Duration(days: 7)),
        level: 1,
        category: 'Variables',
      ),
      
      // Usuario intermedio
      UserProgress(
        userId: 'user_intermediate',
        lessonId: 'var_001',
        score: 95,
        timeSpent: 6.0,
        attempts: 1,
        completedAt: DateTime.now().subtract(Duration(days: 10)),
        level: 2,
        category: 'Variables',
      ),
      UserProgress(
        userId: 'user_intermediate',
        lessonId: 'cond_001',
        score: 88,
        timeSpent: 12.0,
        attempts: 1,
        completedAt: DateTime.now().subtract(Duration(days: 8)),
        level: 2,
        category: 'Condicionales',
      ),
      
      // Usuario avanzado
      UserProgress(
        userId: 'user_advanced',
        lessonId: 'func_001',
        score: 98,
        timeSpent: 15.0,
        attempts: 1,
        completedAt: DateTime.now().subtract(Duration(days: 2)),
        level: 3,
        category: 'Funciones',
      ),
    ];
  }
  
  /// Crea lecciones de ejemplo
  static List<Lesson> _createSampleLessons() {
    return [
      Lesson(
        id: 'var_001',
        title: 'Introducción a Variables',
        description: 'Conceptos básicos de variables',
        level: 1,
        category: 'Variables',
        concepts: ['Declaración', 'Asignación'],
        content: 'Contenido sobre variables...',
        questions: [],
        estimatedMinutes: 10,
      ),
      Lesson(
        id: 'var_002',
        title: 'Tipos de Datos',
        description: 'Diferentes tipos de datos',
        level: 1,
        category: 'Variables',
        concepts: ['int', 'String', 'bool'],
        content: 'Contenido sobre tipos...',
        questions: [],
        estimatedMinutes: 12,
      ),
      Lesson(
        id: 'cond_001',
        title: 'Condicionales IF',
        description: 'Estructuras condicionales',
        level: 2,
        category: 'Condicionales',
        concepts: ['if', 'else', 'condiciones'],
        content: 'Contenido sobre condicionales...',
        questions: [],
        estimatedMinutes: 15,
      ),
      Lesson(
        id: 'func_001',
        title: 'Introducción a Funciones',
        description: 'Crear y usar funciones',
        level: 3,
        category: 'Funciones',
        concepts: ['función', 'parámetros', 'return'],
        content: 'Contenido sobre funciones...',
        questions: [],
        estimatedMinutes: 20,
      ),
    ];
  }
  
  /// Imprime información de los usuarios
  static void _printUserData(List<UserProgress> allProgress) {
    Map<String, List<UserProgress>> progressByUser = {};
    for (var progress in allProgress) {
      if (!progressByUser.containsKey(progress.userId)) {
        progressByUser[progress.userId] = [];
      }
      progressByUser[progress.userId]!.add(progress);
    }
    
    for (var entry in progressByUser.entries) {
      String userId = entry.key;
      List<UserProgress> userProgress = entry.value;
      
      double avgScore = userProgress.map((p) => p.score).reduce((a, b) => a + b) / userProgress.length;
      double avgTime = userProgress.map((p) => p.timeSpent).reduce((a, b) => a + b) / userProgress.length;
      
      print('   - $userId:');
      print('     * Lecciones: ${userProgress.length}');
      print('     * Score promedio: ${avgScore.toInt()}%');
      print('     * Tiempo promedio: ${avgTime.toInt()}min');
    }
  }
  
  /// Imprime información de las lecciones
  static void _printLessons(List<Lesson> lessons) {
    for (var lesson in lessons) {
      print('   - ${lesson.title} (${lesson.category}, Nivel ${lesson.level})');
    }
  }
  
  /// Imprime las recomendaciones generadas
  static void _printRecommendations(List<Recommendation> recommendations, String userType) {
    print('   Recomendaciones para: $userType');
    
    if (recommendations.isEmpty) {
      print('   - No hay recomendaciones disponibles');
      return;
    }
    
    for (int i = 0; i < recommendations.length; i++) {
      var rec = recommendations[i];
      print('   ${i + 1}. ${rec.title}');
      print('      * Categoría: ${rec.category}');
      print('      * Confianza: ${(rec.confidence * 100).toInt()}%');
      print('      * Razón: ${rec.reason}');
    }
  }
  
  /// Explica cómo funciona el algoritmo KNN
  static void _explainAlgorithm() {
    print('''
   El algoritmo K-Nearest Neighbors (KNN) funciona de la siguiente manera:
   
   1. RECOLECCIÓN DE DATOS:
      - Toma el historial de progreso del usuario actual
      - Recopila datos de todos los demás usuarios
   
   2. CÁLCULO DE SIMILITUD:
      - Convierte el progreso en vectores numéricos [score, tiempo, intentos, nivel]
      - Calcula la distancia euclidiana entre usuarios
      - Normaliza los valores para que tengan el mismo peso
   
   3. SELECCIÓN DE VECINOS:
      - Encuentra los K usuarios más similares (menor distancia)
      - Por defecto K=5, pero se puede ajustar
   
   4. GENERACIÓN DE RECOMENDACIONES:
      - Analiza qué lecciones completaron exitosamente los usuarios similares
      - Filtra lecciones ya completadas por el usuario actual
      - Calcula confianza basada en el rendimiento de usuarios similares
   
   5. EXPLICACIÓN:
      - Proporciona razones claras para cada recomendación
      - Indica el nivel de confianza de la sugerencia
   
   VENTAJAS:
   ✓ Simple de implementar y entender
   ✓ No requiere entrenamiento previo
   ✓ Se adapta automáticamente a nuevos datos
   ✓ Proporciona explicaciones interpretables
   
   FÓRMULA DE DISTANCIA:
   distance = √[(score₁-score₂)²/100² + (time₁-time₂)²/20² + (attempts₁-attempts₂)²/5² + (level₁-level₂)²/10²]
   
   La normalización asegura que todas las métricas contribuyan equitativamente.
   ''');
  }
}

/// Función para ejecutar el ejemplo desde cualquier parte de la app
void runKNNExample() {
  KNNExample.runExample();
}
