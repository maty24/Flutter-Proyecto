import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

//! 3 - StateNotiferProvider - consume afuera

//el autoDispose hace que limpia  cuando sale de la pagina , en este caso del login
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  //solo le mando la referencia de loginUser, no lo va a ejecutar desde aca
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(
    loginUserCallback: loginUserCallback,
  );
});

//! 2-Implementando el notifer
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;

  //al super le mandamos el estado inicial, no puede ser syncrono
  LoginFormNotifier({required this.loginUserCallback})
      : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  onFormSubmit() async {
    _touchEveryField();

    //si el state de is valid no hace nada
    if (!state.isValid) return;

    //cambio el state para que apreto el boton login
    state = state.copyWith(isPosting: true);

    //le envio los parametros de la funcion
    await loginUserCallback(state.email.value, state.password.value);
    
    //vuelvo a tener el false para usar el boton
    state = state.copyWith(isPosting: false);
  }

  //se ejcuta cuando se ejecuta la funcion onFormSubmit
  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    //sobreescribo el statre
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([ email, password ]),
    );
  }
}

//! 1- state del provider
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    //cuadno estan en pure es porque estan vacio
    this.password = const Password.pure(),
  });

  //para regresar una nueva instancia del objeto
  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) => LoginFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
  );

  //para poder imprimir en consola
  @override
  String toString() {
    return '''
  LoginFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
    ''';
  }
}
