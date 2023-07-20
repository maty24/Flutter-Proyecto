import 'package:teslo_shop/features/auth/domain/entity/user.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  //verificar si el usario esta autenticado o activo
  Future<User> checkAuthStatus(String token);
}
