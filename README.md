# Programming Tutor 📱

Una aplicación móvil educativa desarrollada en Flutter que enseña conceptos básicos de programación de manera interactiva, similar a Duolingo, con un sistema de recomendaciones personalizadas basado en el algoritmo K-Nearest Neighbors (KNN).

## 🎯 Características Principales

### ✨ Funcionalidades Core
- **Lecciones Interactivas**: Aprende programación paso a paso con ejercicios prácticos
- **Sistema de Progreso**: Seguimiento detallado del rendimiento del usuario
- **Recomendaciones Inteligentes**: Algoritmo KNN que sugiere contenido personalizado
- **Interfaz Amigable**: Diseño moderno y didáctico inspirado en apps educativas

### 🧠 Algoritmo KNN Integrado
- Analiza el rendimiento del usuario (puntuación, tiempo, intentos)
- Encuentra usuarios similares usando distancia euclidiana
- Genera recomendaciones basadas en patrones de aprendizaje
- Explica el razonamiento detrás de cada sugerencia

## 🏗️ Arquitectura del Proyecto

### 📁 Estructura de Carpetas
```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── models/                      # Modelos de datos
│   ├── user.dart               # Modelo de usuario
│   ├── lesson.dart             # Modelo de lecciones
│   └── user_progress.dart      # Modelo de progreso y recomendaciones
├── services/                    # Lógica de negocio
│   ├── auth_service.dart       # Autenticación de usuarios
│   ├── lesson_service.dart     # Gestión de lecciones
│   ├── progress_service.dart   # Seguimiento de progreso
│   └── knn_service.dart        # Algoritmo KNN para recomendaciones
├── screens/                     # Pantallas de la aplicación
│   ├── auth/
│   │   └── login_screen.dart   # Login y registro
│   ├── lessons/
│   │   ├── lessons_screen.dart # Lista de lecciones
│   │   └── lesson_detail_screen.dart # Detalles y ejercicios
│   └── progress/
│       └── progress_screen.dart # Progreso y recomendaciones
└── widgets/                     # Componentes reutilizables
    ├── custom_button.dart      # Botón personalizado
    ├── custom_text_field.dart  # Campo de texto personalizado
    ├── lesson_card.dart        # Tarjeta de lección
    ├── stats_card.dart         # Tarjeta de estadísticas
    ├── progress_chart.dart     # Gráfico de progreso
    └── recommendation_card.dart # Tarjeta de recomendación
```

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK (versión 3.10.0 o superior)
- Dart SDK (versión 3.0.0 o superior)
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd programming_tutor
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 📚 Funcionalidades Detalladas

### 🔐 Sistema de Autenticación
- **Registro de usuarios**: Crear cuenta con nombre, email y contraseña
- **Inicio de sesión**: Autenticación simple con validación
- **Persistencia**: Los datos se guardan localmente usando SharedPreferences

### 📖 Lecciones Interactivas
- **Categorías disponibles**:
  - Variables y tipos de datos
  - Estructuras condicionales
  - Bucles y repetición
  - Funciones
  - Arrays y listas

- **Formato de lecciones**:
  - Contenido teórico explicativo
  - Ejercicios de opción múltiple
  - Explicaciones detalladas de respuestas
  - Sistema de puntuación y tiempo

### 📊 Sistema de Progreso
- **Métricas tracked**:
  - Puntuación por lección
  - Tiempo invertido
  - Número de intentos
  - Progreso por categoría

- **Visualizaciones**:
  - Gráficos de barras por categoría
  - Estadísticas generales
  - Historial de lecciones recientes

### 🤖 Algoritmo KNN para Recomendaciones

#### ¿Cómo Funciona?
1. **Recolección de datos**: Analiza el progreso del usuario actual
2. **Cálculo de similitud**: Encuentra usuarios con patrones similares usando distancia euclidiana
3. **Generación de recomendaciones**: Sugiere lecciones que usuarios similares completaron exitosamente
4. **Explicación**: Proporciona razones claras para cada recomendación

#### Métricas Utilizadas
- **Score**: Puntuación obtenida (0-100)
- **Tiempo**: Minutos invertidos en la lección
- **Intentos**: Número de veces que intentó completar
- **Nivel**: Nivel actual del usuario

#### Fórmula de Distancia
```dart
// Distancia euclidiana normalizada
double distance = sqrt(
  ((score1 - score2) / 100)² + 
  ((time1 - time2) / 20)² + 
  ((attempts1 - attempts2) / 5)² + 
  ((level1 - level2) / 10)²
);
```

## 🎨 Diseño y UX

### Paleta de Colores
- **Primario**: Azul (#4A90E2) - Confianza y aprendizaje
- **Fondo**: Gris claro (#F8F9FA) - Limpieza y claridad
- **Acentos**: Colores por categoría para mejor organización

### Principios de Diseño
- **Simplicidad**: Interfaz limpia sin elementos distractores
- **Consistencia**: Componentes reutilizables con estilo uniforme
- **Accesibilidad**: Textos legibles y contrastes apropiados
- **Feedback**: Indicadores claros de progreso y estado

## 🧪 Datos de Ejemplo

La aplicación incluye datos de muestra para demostrar el algoritmo KNN:

### Usuarios Simulados
- **Usuario 1**: Principiante con buen rendimiento
- **Usuario 2**: Intermedio con rendimiento variable  
- **Usuario 3**: Avanzado con excelente rendimiento
- **Usuario 4**: Principiante con dificultades

### Lecciones Incluidas
- 6 lecciones completas con ejercicios
- Contenido progresivo de nivel 1 a 3
- Ejercicios de opción múltiple con explicaciones

## 🔧 Tecnologías Utilizadas

### Framework y Lenguaje
- **Flutter**: Framework de desarrollo móvil multiplataforma
- **Dart**: Lenguaje de programación optimizado para UI

### Dependencias Principales
- **shared_preferences**: Almacenamiento local de datos
- **cupertino_icons**: Iconos nativos de iOS

### Patrones de Arquitectura
- **Separación de responsabilidades**: Modelos, servicios, vistas separados
- **Programación orientada a objetos**: Clases bien definidas y reutilizables
- **Gestión de estado**: Estado local con StatefulWidget

## 📈 Algoritmo KNN - Explicación Técnica

### Implementación del K-Nearest Neighbors

```dart
// Ejemplo simplificado del algoritmo
List<Recommendation> generateRecommendations({
  required List<UserProgress> userProgress,
  required List<UserProgress> allProgress,
  required List<Lesson> availableLessons,
  int k = 5,
}) {
  // 1. Calcular perfil del usuario
  List<double> userProfile = calculateUserProfile(userProgress);
  
  // 2. Encontrar usuarios similares
  List<SimilarUser> similarUsers = findSimilarUsers(
    userProfile, allProgress, k
  );
  
  // 3. Generar recomendaciones
  return generateRecommendationsFromSimilarUsers(
    similarUsers, userProgress, availableLessons
  );
}
```

### Ventajas del Enfoque KNN
- **Simplicidad**: Fácil de entender e implementar
- **Efectividad**: Funciona bien con datos de comportamiento
- **Explicabilidad**: Permite explicar por qué se hace una recomendación
- **Adaptabilidad**: Se mejora automáticamente con más datos

## 🎓 Propósito Educativo

### Para Estudiantes
- **Código limpio**: Ejemplos de buenas prácticas en Flutter/Dart
- **Arquitectura clara**: Separación de responsabilidades bien definida
- **Comentarios explicativos**: Código autodocumentado para aprendizaje
- **Algoritmos aplicados**: Implementación práctica de conceptos teóricos

### Conceptos Demostrados
- Desarrollo móvil con Flutter
- Algoritmos de machine learning (KNN)
- Persistencia de datos local
- Diseño de interfaces de usuario
- Arquitectura de software limpia

## 🚀 Próximas Mejoras

### Funcionalidades Futuras
- [ ] Más tipos de ejercicios (código interactivo, drag & drop)
- [ ] Sistema de logros y badges
- [ ] Modo offline completo
- [ ] Sincronización en la nube
- [ ] Análisis más avanzado de patrones de aprendizaje

### Mejoras Técnicas
- [ ] Implementación de otros algoritmos de recomendación
- [ ] Base de datos más robusta (SQLite)
- [ ] Tests unitarios y de integración
- [ ] Optimización de rendimiento
- [ ] Internacionalización (i18n)

## 📄 Licencia

Este proyecto está desarrollado con fines educativos. Siéntete libre de usar, modificar y aprender del código.

## 👥 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

---

**¡Feliz aprendizaje! 🎉**

*Desarrollado como ejemplo de aplicación educativa con algoritmos de machine learning integrados.*
