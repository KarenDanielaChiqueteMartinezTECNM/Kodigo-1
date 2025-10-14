import '../models/lesson.dart';

/// Servicio que maneja las lecciones de programación
/// Proporciona datos de ejemplo para demostrar la funcionalidad
class LessonService {
  /// Obtiene todas las lecciones disponibles
  /// En una app real, esto vendría de una base de datos o API
  Future<List<Lesson>> getLessons() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _sampleLessons;
  }

  /// Obtiene una lección específica por ID
  Future<Lesson?> getLessonById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _sampleLessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene lecciones por categoría
  Future<List<Lesson>> getLessonsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _sampleLessons.where((lesson) => lesson.category == category).toList();
  }

  /// Obtiene lecciones por nivel
  Future<List<Lesson>> getLessonsByLevel(int level) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _sampleLessons.where((lesson) => lesson.level == level).toList();
  }

  /// Datos de ejemplo de lecciones
  static final List<Lesson> _sampleLessons = [
    // Lecciones de Variables
    Lesson(
      id: 'var_001',
      title: 'Introducción a Variables',
      description: 'Aprende qué son las variables y cómo usarlas en programación',
      level: 1,
      category: 'Variables',
      concepts: ['Declaración', 'Asignación', 'Tipos de datos'],
      content: '''
Las variables son contenedores que almacenan datos en la memoria de la computadora. 
Piensa en ellas como cajas etiquetadas donde puedes guardar información.

En programación, las variables tienen:
• Un nombre (identificador)
• Un tipo de dato (número, texto, etc.)
• Un valor

Ejemplo:
int edad = 25;
String nombre = "Juan";
bool esEstudiante = true;
      ''',
      questions: [
        Question(
          id: 'var_001_q1',
          question: '¿Qué es una variable en programación?',
          options: [
            'Un número que nunca cambia',
            'Un contenedor que almacena datos',
            'Una función matemática',
            'Un tipo de bucle'
          ],
          correctAnswerIndex: 1,
          explanation: 'Una variable es un contenedor que almacena datos en la memoria, permitiendo guardar y modificar información durante la ejecución del programa.',
        ),
        Question(
          id: 'var_001_q2',
          question: '¿Cuál es la sintaxis correcta para declarar una variable entera en muchos lenguajes?',
          options: [
            'variable edad = 25',
            'int edad = 25',
            'number edad = 25',
            'edad = 25 int'
          ],
          correctAnswerIndex: 1,
          explanation: 'La sintaxis "int edad = 25" es la forma estándar de declarar una variable entera, especificando el tipo, nombre y valor inicial.',
        ),
      ],
      estimatedMinutes: 8,
    ),

    Lesson(
      id: 'var_002',
      title: 'Tipos de Datos Básicos',
      description: 'Conoce los diferentes tipos de datos: números, texto y booleanos',
      level: 1,
      category: 'Variables',
      concepts: ['int', 'String', 'bool', 'double'],
      content: '''
Los tipos de datos básicos más comunes son:

1. **Números enteros (int)**: 1, 25, -10
2. **Números decimales (double)**: 3.14, -2.5, 0.0
3. **Texto (String)**: "Hola", "Programación", "123"
4. **Booleanos (bool)**: true, false

Cada tipo tiene características específicas:
• Los enteros no tienen decimales
• Los strings van entre comillas
• Los booleanos solo pueden ser verdadero o falso
      ''',
      questions: [
        Question(
          id: 'var_002_q1',
          question: '¿Qué tipo de dato usarías para almacenar la edad de una persona?',
          options: ['String', 'bool', 'int', 'double'],
          correctAnswerIndex: 2,
          explanation: 'La edad es un número entero, por lo que se usa el tipo "int".',
        ),
        Question(
          id: 'var_002_q2',
          question: '¿Cuál de estos valores es un booleano?',
          options: ['25', '"verdadero"', 'true', '1.5'],
          correctAnswerIndex: 2,
          explanation: 'Los booleanos solo pueden ser "true" o "false", sin comillas.',
        ),
      ],
      estimatedMinutes: 10,
    ),

    // Lecciones de Condicionales
    Lesson(
      id: 'cond_001',
      title: 'Estructuras Condicionales IF',
      description: 'Aprende a tomar decisiones en tu código con if-else',
      level: 2,
      category: 'Condicionales',
      concepts: ['if', 'else', 'condiciones', 'operadores'],
      content: '''
Las estructuras condicionales permiten que tu programa tome decisiones.

Sintaxis básica:
if (condición) {
    // código si es verdadero
} else {
    // código si es falso
}

Ejemplo:
int edad = 18;
if (edad >= 18) {
    print("Eres mayor de edad");
} else {
    print("Eres menor de edad");
}

Los operadores de comparación son:
• == (igual)
• != (diferente)
• > (mayor que)
• < (menor que)
• >= (mayor o igual)
• <= (menor o igual)
      ''',
      questions: [
        Question(
          id: 'cond_001_q1',
          question: '¿Qué imprime este código si edad = 20?\nif (edad >= 18) { print("Mayor"); } else { print("Menor"); }',
          options: ['Mayor', 'Menor', 'Error', 'Nada'],
          correctAnswerIndex: 0,
          explanation: 'Como 20 >= 18 es verdadero, se ejecuta el primer bloque e imprime "Mayor".',
        ),
        Question(
          id: 'cond_001_q2',
          question: '¿Cuál es el operador para "diferente de"?',
          options: ['<>', '!=', '==', '=/='],
          correctAnswerIndex: 1,
          explanation: 'El operador "!=" significa "no igual" o "diferente de".',
        ),
      ],
      estimatedMinutes: 12,
    ),

    // Lecciones de Bucles
    Lesson(
      id: 'loop_001',
      title: 'Bucles FOR básicos',
      description: 'Repite código de forma eficiente con bucles for',
      level: 2,
      category: 'Bucles',
      concepts: ['for', 'iteración', 'contador', 'repetición'],
      content: '''
Los bucles FOR permiten repetir código un número específico de veces.

Sintaxis:
for (inicialización; condición; incremento) {
    // código a repetir
}

Ejemplo:
for (int i = 0; i < 5; i++) {
    print("Número: " + i.toString());
}

Esto imprime:
Número: 0
Número: 1
Número: 2
Número: 3
Número: 4

Partes del bucle:
• Inicialización: int i = 0 (se ejecuta una vez)
• Condición: i < 5 (se verifica antes de cada iteración)
• Incremento: i++ (se ejecuta después de cada iteración)
      ''',
      questions: [
        Question(
          id: 'loop_001_q1',
          question: '¿Cuántas veces se ejecuta este bucle?\nfor (int i = 1; i <= 3; i++) { print(i); }',
          options: ['2 veces', '3 veces', '4 veces', '1 vez'],
          correctAnswerIndex: 1,
          explanation: 'El bucle se ejecuta con i=1, i=2, i=3, por lo tanto 3 veces.',
        ),
        Question(
          id: 'loop_001_q2',
          question: '¿Qué hace i++ en un bucle for?',
          options: [
            'Resta 1 a i',
            'Suma 1 a i',
            'Multiplica i por 2',
            'Reinicia i a 0'
          ],
          correctAnswerIndex: 1,
          explanation: 'i++ es una forma abreviada de escribir i = i + 1, incrementa el valor de i en 1.',
        ),
      ],
      estimatedMinutes: 15,
    ),

    // Lecciones de Funciones
    Lesson(
      id: 'func_001',
      title: 'Introducción a Funciones',
      description: 'Organiza tu código creando funciones reutilizables',
      level: 3,
      category: 'Funciones',
      concepts: ['función', 'parámetros', 'return', 'reutilización'],
      content: '''
Las funciones son bloques de código reutilizable que realizan una tarea específica.

Sintaxis básica:
tipoRetorno nombreFuncion(parámetros) {
    // código de la función
    return valor; // opcional
}

Ejemplo:
int sumar(int a, int b) {
    return a + b;
}

void saludar(String nombre) {
    print("Hola, " + nombre);
}

Ventajas de las funciones:
• Reutilización de código
• Organización mejor
• Fácil mantenimiento
• Menos errores

Llamar una función:
int resultado = sumar(5, 3); // resultado = 8
saludar("Ana"); // imprime "Hola, Ana"
      ''',
      questions: [
        Question(
          id: 'func_001_q1',
          question: '¿Qué devuelve esta función?\nint multiplicar(int x, int y) { return x * y; }\nmultiplicar(4, 3)',
          options: ['7', '12', '1', '43'],
          correctAnswerIndex: 1,
          explanation: 'La función multiplica 4 * 3 = 12 y devuelve ese valor.',
        ),
        Question(
          id: 'func_001_q2',
          question: '¿Qué significa "void" en una función?',
          options: [
            'La función devuelve un número',
            'La función no devuelve nada',
            'La función tiene errores',
            'La función es privada'
          ],
          correctAnswerIndex: 1,
          explanation: '"void" significa que la función no devuelve ningún valor, solo ejecuta código.',
        ),
      ],
      estimatedMinutes: 18,
    ),

    // Lecciones de Arrays
    Lesson(
      id: 'array_001',
      title: 'Arrays y Listas',
      description: 'Almacena múltiples valores en una sola variable',
      level: 3,
      category: 'Arrays',
      concepts: ['array', 'lista', 'índice', 'elementos'],
      content: '''
Los arrays (o listas) permiten almacenar múltiples valores en una sola variable.

Declaración:
List<int> numeros = [1, 2, 3, 4, 5];
List<String> nombres = ["Ana", "Luis", "María"];

Características importantes:
• Los índices empiezan en 0
• Se accede con corchetes: numeros[0] = 1
• Tienen longitud: numeros.length = 5

Operaciones comunes:
• Agregar: numeros.add(6)
• Eliminar: numeros.remove(3)
• Buscar: numeros.contains(4)

Ejemplo de uso:
List<String> frutas = ["manzana", "pera", "uva"];
print(frutas[0]); // imprime "manzana"
frutas.add("naranja");
print(frutas.length); // imprime 4
      ''',
      questions: [
        Question(
          id: 'array_001_q1',
          question: 'Si tienes List<int> nums = [10, 20, 30], ¿qué devuelve nums[1]?',
          options: ['10', '20', '30', '1'],
          correctAnswerIndex: 1,
          explanation: 'Los índices empiezan en 0, por lo que nums[1] es el segundo elemento: 20.',
        ),
        Question(
          id: 'array_001_q2',
          question: '¿Cómo obtienes el número de elementos en una lista?',
          options: ['lista.size', 'lista.count', 'lista.length', 'lista.total'],
          correctAnswerIndex: 2,
          explanation: 'En Dart, se usa .length para obtener el número de elementos en una lista.',
        ),
      ],
      estimatedMinutes: 20,
    ),
  ];
}
