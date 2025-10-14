import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

/// Servicio de autenticación que maneja login, registro y sesión de usuario
/// Utiliza SharedPreferences para persistir datos localmente
class AuthService {
  static const String _userKey = 'current_user';
  static const String _usersKey = 'registered_users';

  /// Registra un nuevo usuario en la aplicación
  Future<bool> register(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Verificar si el email ya está registrado
      List<User> existingUsers = await _getRegisteredUsers();
      bool emailExists = existingUsers.any((user) => user.email == email);
      
      if (emailExists) {
        throw Exception('El email ya está registrado');
      }

      // Crear nuevo usuario
      User newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        currentLevel: 1,
        totalScore: 0,
        lessonsCompleted: 0,
        averageTimePerLesson: 0.0,
        lastActivity: DateTime.now(),
      );

      // Guardar usuario en la lista de usuarios registrados
      existingUsers.add(newUser);
      await _saveRegisteredUsers(existingUsers);

      // Establecer como usuario actual
      await _setCurrentUser(newUser);

      return true;
    } catch (e) {
      print('Error en registro: $e');
      return false;
    }
  }

  /// Inicia sesión con email y contraseña
  Future<bool> login(String email, String password) async {
    try {
      // En una app real, aquí verificarías la contraseña
      // Por simplicidad, solo verificamos que el email exista
      List<User> users = await _getRegisteredUsers();
      User? user = users.where((u) => u.email == email).firstOrNull;
      
      if (user == null) {
        throw Exception('Usuario no encontrado');
      }

      // Actualizar última actividad
      User updatedUser = user.copyWith(lastActivity: DateTime.now());
      await _setCurrentUser(updatedUser);

      return true;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }

  /// Cierra la sesión del usuario actual
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  /// Obtiene el usuario actualmente autenticado
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString(_userKey);
      
      if (userJson == null) return null;
      
      Map<String, dynamic> userMap = json.decode(userJson);
      return User.fromMap(userMap);
    } catch (e) {
      print('Error obteniendo usuario actual: $e');
      return null;
    }
  }

  /// Actualiza los datos del usuario actual
  Future<bool> updateCurrentUser(User user) async {
    try {
      await _setCurrentUser(user);
      
      // También actualizar en la lista de usuarios registrados
      List<User> users = await _getRegisteredUsers();
      int index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = user;
        await _saveRegisteredUsers(users);
      }
      
      return true;
    } catch (e) {
      print('Error actualizando usuario: $e');
      return false;
    }
  }

  /// Verifica si hay un usuario autenticado
  Future<bool> isLoggedIn() async {
    User? user = await getCurrentUser();
    return user != null;
  }

  /// Métodos privados para manejo de datos

  /// Establece el usuario actual en SharedPreferences
  Future<void> _setCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = json.encode(user.toMap());
    await prefs.setString(_userKey, userJson);
  }

  /// Obtiene la lista de usuarios registrados
  Future<List<User>> _getRegisteredUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? usersJson = prefs.getString(_usersKey);
      
      if (usersJson == null) return [];
      
      List<dynamic> usersList = json.decode(usersJson);
      return usersList.map((userMap) => User.fromMap(userMap)).toList();
    } catch (e) {
      print('Error obteniendo usuarios registrados: $e');
      return [];
    }
  }

  /// Guarda la lista de usuarios registrados
  Future<void> _saveRegisteredUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> usersList = users.map((user) => user.toMap()).toList();
    String usersJson = json.encode(usersList);
    await prefs.setString(_usersKey, usersJson);
  }
}
