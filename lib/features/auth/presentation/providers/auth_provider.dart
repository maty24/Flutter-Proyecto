import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_impl.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage.dart';

//3!
final authProvider = StateNotifierProvider<AuthNotifer, AuthState>((ref) {
  //estoy obteneindo los datasource o las funciones de las peiticones para el logn
  final authRespository = AuthRepositoryImpl();
  final keyValueStorage = KeyValueImpl();

  //a la clase le envio las funciones por el parametro
  return AuthNotifer(
    authRepository: authRespository,
    keyValueStorage: keyValueStorage,
  );
});

//! 2
class AuthNotifer extends StateNotifier<AuthState> {
  //requiro las funciones para hacer las peticiones
  final AuthRepository authRepository;
  final KeyValueStorage keyValueStorage;

  AuthNotifer({
    required this.authRepository,
    required this.keyValueStorage,
  }) : super(AuthState()) {
    //cuando se crea el notifer cuado se crea la primera intancia
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    //relentizo el login aproposito
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }

    // final user = await authRepository.login(email, password);
    // state =state.copyWith(user: user, authStatus: AuthStatus.authenticated)
  }

  void registerUser(String email, String password) async {}

  void checkAuthStatus() async {
    final token = await keyValueStorage.getValue<String>('token');
    if (token == null) return logout();
    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  //esto guarda el usuario y cambio el state de este provider
  void _setLoggedUser(User user) async {
    //guardamos el token
    await keyValueStorage.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  //para deslogearse
  Future<void> logout([String? errorMessage]) async {
    //removemos el token
    await keyValueStorage.removeKey('token');

    //cambio el state de este provider
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      //este es el error de mansaje para mostrar en pantalla
      errorMessage: errorMessage,
    );
  }
}

//! 1
enum AuthStatus { checking, authenticated, notAuthenticated }

//state
class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
