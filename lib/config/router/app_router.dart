import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifer.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  return GoRouter(
    initialLocation: '/splash',
    //esto cuadno cambia va a evaluar el redirect, va a estar pendiente
    //el refreshListenable esta esperando algo de change notifer
    refreshListenable: goRouterNotifier,
    routes: [
      //* Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
    ],

    redirect: (context, state) {
      //el state es el estado de gorouter que es todo la informacion , en cual ruta estoy,etc

      //esto es para donde va a ir la persona osea si apreto el boton de login me a tirar a 
      final isGoingTo = state.subloc;

      //tenemos el status de la aplicacion
      final authStatus = goRouterNotifier.authStatus;

      //si esta cargando me retorna al splash
      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) return null;

       //si no esta autenticado me retorna al login
      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
