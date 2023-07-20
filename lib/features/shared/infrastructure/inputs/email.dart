import 'package:formz/formz.dart';

// Define input validation errors
enum EmailError { empty, format }

// Extend FormzInput and provide the input type and error type.
class Email extends FormzInput<String, EmailError> {

  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  // Call super.pure to represent an unmodified form input.
  const Email.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Email.dirty( String value ) : super.dirty(value);



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == EmailError.empty ) return 'El campo es requerido';
    if ( displayError == EmailError.format ) return 'No tiene formato de correo electrónico';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  EmailError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return EmailError.empty;
    if ( !emailRegExp.hasMatch(value) ) return EmailError.format;

    return null;
  }
}
/*
En el paquete Formz, pure y dirty son dos estados que puede tener un FormzInput.

    pure: Este estado representa un input de formulario que no ha sido modificado por el usuario. Por ejemplo, cuando se carga un formulario por primera vez y los campos aún no han sido llenados o cambiados por el usuario, esos campos están en estado pure. En tu código, cuando creas una instancia de Email con Email.pure(), estás creando un input de correo electrónico que no ha sido modificado.

    dirty: Este estado representa un input de formulario que ha sido modificado por el usuario. Por ejemplo, cuando un usuario escribe algo en un campo de formulario, ese campo se convierte en dirty. En tu código, cuando creas una instancia de Email con Email.dirty(value), estás creando un input de correo electrónico que ha sido modificado con el valor proporcionado.

Estos dos estados son útiles para controlar cuándo se debe realizar la validación de los inputs y para optimizar el rendimiento de la validación. Por ejemplo, puedes decidir validar un input solo cuando se convierte en dirty para evitar la validación innecesaria de inputs pure.
 */