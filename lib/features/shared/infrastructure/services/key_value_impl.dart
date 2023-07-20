import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage.dart';

class KeyValueImpl extends KeyValueStorage {
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    //el T es generico puede ser un int,string,bool y mediente eso que haga lo siguiente
    switch (T) {
      //si el generico es un entero obengo
      case int:
        return prefs.getInt(key) as T?;

      //si el genericp es un string
      case String:
        return prefs.getString(key) as T?;
      default:
        throw UnimplementedError(
            'GET not implemented for type ${T.runtimeType}');
    }
  }

  //establecer un valor
  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    //el T es generico puede ser un int,string,bool y mediente eso que haga lo siguiente
    switch (T) {
      //si el generico es un entero
      case int:
        prefs.setInt(key, value as int);
        break;
      //si el genericp es un string
      case String:
        prefs.setString(key, value as String);
        break;
      default:
        throw UnimplementedError(
            'GET not implemented for type ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }
}
