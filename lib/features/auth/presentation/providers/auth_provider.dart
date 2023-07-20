import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

//3!
final authProvider = StateNotifierProvider<AuthNotifer, AuthState>((ref) {
  //estoy obteneindo los datasource o las funciones de las peiticones para el logn
  final authRespository = AuthRepositoryImpl();

  //a la clase le envio las funciones por el parametro
  return AuthNotifer(
    authRepository: authRespository,
  );
});

//! 2
class AuthNotifer extends StateNotifier<AuthState> {
  //requiro las funciones para hacer las peticiones
  final AuthRepository authRepository;

  AuthNotifer({
    required this.authRepository,
  }) : super(AuthState());

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

  void checkAuthStatus() async {}

  //esto guarda el usuario y cambio el state de este provider
  void _setLoggedUser(User user) {
    // TODO: necesito guardar el token físicamente
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  //para deslogearse
  Future<void> logout([String? errorMessage]) async {
    // TODO: limpiar token

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
