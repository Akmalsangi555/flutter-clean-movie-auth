//
// import 'package:webflow_auth_app/app/bindings/auth_binding.dart';
//
// import 'app_routes.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../../features/auth/presentation/controllers/auth_controller.dart';
//
// class AuthMiddleware extends GetMiddleware {
//   @override
//   int? get priority => 1;
//
//   @override
//   RouteSettings? redirect(String? route) {
//     try {
//       // Try to find AuthController
//       if (Get.isRegistered<AuthController>()) {
//         final authController = Get.find<AuthController>();
//
//         // Wait for auth check to complete if it's still running
//         if (authController.isCheckingAuth.value) {
//           // Still checking, stay on current route or go to splash
//           if (route != Routes.SPLASH) {
//             return const RouteSettings(name: Routes.SPLASH);
//           }
//           return null;
//         }
//
//         // If not authenticated and not on login/signup/splash, redirect to login
//         if (!authController.isAuthenticated.value) {
//           if (route != Routes.LOGIN &&
//               route != Routes.SIGNUP &&
//               route != Routes.SPLASH) {
//             return const RouteSettings(name: Routes.LOGIN);
//           }
//         }
//
//         // If authenticated and trying to access auth pages, redirect to home
//         if (authController.isAuthenticated.value) {
//           if (route == Routes.LOGIN ||
//               route == Routes.SIGNUP ||
//               route == Routes.SPLASH) {
//             return const RouteSettings(name: Routes.HOME);
//           }
//         }
//       } else {
//         // Controller not registered yet, redirect to splash
//         if (route != Routes.SPLASH) {
//           return const RouteSettings(name: Routes.SPLASH);
//         }
//       }
//     } catch (e) {
//       // Error finding controller, redirect to splash
//       if (route != Routes.SPLASH) {
//         return const RouteSettings(name: Routes.SPLASH);
//       }
//     }
//
//     return null;
//   }
//
//   @override
//   GetPage? onPageCalled(GetPage? page) {
//     // Ensure AuthBinding is called for protected routes
//     if (page?.name == Routes.HOME || page?.name == Routes.WEBVIEW) {
//       if (!Get.isRegistered<AuthController>()) {
//         // Force AuthBinding to run
//         AuthBinding().dependencies();
//       }
//     }
//     return super.onPageCalled(page);
//   }
// }
