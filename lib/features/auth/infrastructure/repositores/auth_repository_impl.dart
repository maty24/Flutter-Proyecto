import 'package:teslo_shop/features/auth/domain/datasource/auth_datasource.dart';
import 'package:teslo_shop/features/auth/domain/entity/user.dart';
import 'package:teslo_shop/features/auth/infrastructure/datasources/auth_datasource_impl.dart';

import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;
  AuthRepositoryImpl([AuthDataSource? dataSource])
      : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
