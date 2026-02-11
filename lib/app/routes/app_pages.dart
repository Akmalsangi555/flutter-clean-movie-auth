//
// import 'package:get/get.dart';
// import '../../features/auth/presentation/pages/login_page.dart';
// import '../../features/auth/presentation/pages/signup_page.dart';
// import '../../features/auth/presentation/pages/movies/home_page.dart';
// import '../../app/bindings/auth_binding.dart';
//
// import '../../features/auth/presentation/pages/splash_page.dart';
// import 'app_routes.dart';
//
// import 'auth_middleware.dart';
//
//
// class AppPages {
//   static final pages = [
//     GetPage(
//       name: Routes.SPLASH,
//       page: () => const SplashPage(),
//       binding: AuthBinding(),
//     ),
//
//     // Auth Pages
//     GetPage(
//       name: Routes.LOGIN,
//       page: () => LoginPage(),
//       binding: AuthBinding(),
//     ),
//     GetPage(
//       name: Routes.SIGNUP,
//       page: () => SignupPage(),
//       binding: AuthBinding(),
//     ),
//
//     // Protected Pages (require authentication)
//     GetPage(
//       name: Routes.HOME,
//       page: () => HomePage(),
//       binding: AuthBinding(),
//       middlewares: [AuthMiddleware()], // Protect home route
//     ),
//     // GetPage(
//     //   name: Routes.WEBVIEW,
//     //   page: () => WebviewPage(),
//     //   binding: AuthBinding(),
//     //   middlewares: [AuthMiddleware()], // Protect webview route
//     // ),
//   ];
// }
//
