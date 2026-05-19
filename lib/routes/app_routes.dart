part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const MAIN = _Paths.MAIN;
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
}

abstract class _Paths {
  _Paths._();

  static const MAIN = '/main';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
}
