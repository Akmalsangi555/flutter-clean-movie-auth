
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:webflow_auth_app/app/colors/app_colors.dart';
import 'package:webflow_auth_app/app/routes/app_routes.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:webflow_auth_app/features/domain/entities/user_entity.dart';
import 'package:webflow_auth_app/features/domain/use_cases/login_use_case.dart';
import 'package:webflow_auth_app/features/domain/use_cases/logout_use_case.dart';
import 'package:webflow_auth_app/features/domain/use_cases/signup_use_case.dart';
import 'package:webflow_auth_app/features/domain/use_cases/check_auth_status_use_case.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/storage_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LogoutUseCase _logoutUseCase;
  final StorageService _storageService;

  AuthController({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required LogoutUseCase logoutUseCase,
    required StorageService storageService,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _checkAuthStatusUseCase = checkAuthStatusUseCase,
        _logoutUseCase = logoutUseCase,
        _storageService = storageService;

  // Observable variables
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final user = Rxn<UserEntity>();
  final errorMessage = Rxn<String>();
  final isAuthenticated = false.obs;
  final isCheckingAuth = true.obs;

  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  // Computed properties
  bool get isLoggedIn => isAuthenticated.value;
  bool get isChecking => isCheckingAuth.value;
  bool get isLoadingLogin => isLoading.value;
  UserEntity? get currentUser => user.value;
  String? get currentUserName => user.value?.firstName;
  String? get currentUserEmail => user.value?.email;
  bool get isPasswordMatch => passwordController.text == confirmPasswordController.text;

  @override
  void onInit() async {
    super.onInit();
    // Small delay for web to ensure storage is ready
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    checkAuthStatus();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // Email validation
  bool isValidEmail(String email) {
    return GetUtils.isEmail(email.trim());
  }

  // Password validation
  String? validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // Phone validation
  String? validatePhone(String phone) {
    if (phone.isEmpty) return 'Phone number is required';
    if (phone.length < 11) return 'Enter a valid 11-digit phone number';
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) return 'Phone number must contain only digits';
    return null;
  }

  // Auto clear error message
  void _autoClearError() {
    Future.delayed(const Duration(seconds: 3), () {
      if (errorMessage.value != null) {
        errorMessage.value = null;
      }
    });
  }

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
    try {
      isCheckingAuth.value = true;

      final result = await _checkAuthStatusUseCase();

      result.fold(
            (exception) {
          isAuthenticated.value = false;
          user.value = null;
          print('Auth check failed: $exception');
        },
            (userEntity) {
          if (userEntity != null) {
            isAuthenticated.value = true;
            user.value = userEntity;
            print('User authenticated: ${userEntity.email}');
          } else {
            isAuthenticated.value = false;
            user.value = null;
            print('No user found');
          }
        },
      );
    } catch (e) {
      isAuthenticated.value = false;
      user.value = null;
      print('Auth check error: $e');
    } finally {
      isCheckingAuth.value = false;
    }
  }

  // Login method
  Future<void> login(String email, String password, BuildContext context) async {
    // Email validation
    if (email.isEmpty) {
      errorMessage.value = 'Email is required';
      _autoClearError();
      return;
    }

    if (!isValidEmail(email)) {
      errorMessage.value = 'Please enter a valid email address';
      _autoClearError();
      return;
    }

    // Password validation
    if (password.isEmpty) {
      errorMessage.value = 'Password is required';
      _autoClearError();
      return;
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      errorMessage.value = passwordError;
      _autoClearError();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final params = LoginParams(
        email: email.trim(),
        password: password,
      );

      final result = await _loginUseCase(params);

      result.fold(
            (exception) {
          errorMessage.value = _getErrorMessage(exception);
          _autoClearError();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage.value!),
              backgroundColor: Colors.red.shade900,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
            (userEntity) {
          user.value = userEntity;
          isAuthenticated.value = true;
          errorMessage.value = null;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome back ${userEntity.firstName ?? ""}!'),
              backgroundColor: AppColors.primaryColor,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );

          // Navigate with go_router
          context.go('/home');
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      _autoClearError();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage.value!),
          backgroundColor: Colors.red.shade900,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Signup method
  Future<void> signup(BuildContext context) async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final phoneNumber = phoneController.text.trim();

    // Validation
    if (firstName.isEmpty) {
      errorMessage.value = 'First name is required';
      _autoClearError();
      return;
    }

    if (lastName.isEmpty) {
      errorMessage.value = 'Last name is required';
      _autoClearError();
      return;
    }

    if (email.isEmpty) {
      errorMessage.value = 'Email is required';
      _autoClearError();
      return;
    }

    if (!isValidEmail(email)) {
      errorMessage.value = 'Please enter a valid email address';
      _autoClearError();
      return;
    }

    if (password.isEmpty) {
      errorMessage.value = 'Password is required';
      _autoClearError();
      return;
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      errorMessage.value = passwordError;
      _autoClearError();
      return;
    }

    if (confirmPassword.isEmpty) {
      errorMessage.value = 'Please confirm your password';
      _autoClearError();
      return;
    }

    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match';
      _autoClearError();
      return;
    }

    if (phoneNumber.isEmpty) {
      errorMessage.value = 'Phone number is required';
      _autoClearError();
      return;
    }

    final phoneError = validatePhone(phoneNumber);
    if (phoneError != null) {
      errorMessage.value = phoneError;
      _autoClearError();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final params = SignupParams(
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      final result = await _signupUseCase(params);

      result.fold(
            (exception) {
          if (exception is BadRequestException) {
            final errorMsg = exception.toString().toLowerCase();

            if (errorMsg.contains('phone') &&
                (errorMsg.contains('taken') || errorMsg.contains('already') || errorMsg.contains('exists'))) {

              errorMessage.value = 'This phone number is already registered.';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Phone number already registered. Would you like to login?'),
                  backgroundColor: Colors.orange.shade900,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  action: SnackBarAction(
                    label: 'Login',
                    textColor: Colors.white,
                    onPressed: () {
                      context.go('/login', extra: {'email': '', 'phone': phoneNumber});
                    },
                  ),
                ),
              );
            } else if (errorMsg.contains('email') &&
                (errorMsg.contains('taken') || errorMsg.contains('already') || errorMsg.contains('exists'))) {

              errorMessage.value = 'This email is already registered.';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Email already registered. Would you like to login?'),
                  backgroundColor: Colors.orange.shade900,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  action: SnackBarAction(
                    label: 'Login',
                    textColor: Colors.white,
                    onPressed: () {
                      context.go('/login', extra: {'email': email});
                    },
                  ),
                ),
              );
            } else {
              errorMessage.value = _getErrorMessage(exception);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage.value!),
                  backgroundColor: Colors.red.shade900,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }
          } else {
            errorMessage.value = _getErrorMessage(exception);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage.value!),
                backgroundColor: Colors.red.shade900,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }

          _autoClearError();
        },
            (userEntity) {
          user.value = userEntity;
          errorMessage.value = null;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Account created successfully! Please login.'),
              backgroundColor: Colors.green.shade900,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );

          clearControllers();
          resetPasswordVisibility();

          // Navigate to login with email
          Future.delayed(const Duration(milliseconds: 500), () {
            context.go('/login', extra: {'email': email, 'fromSignup': true});
          });
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      _autoClearError();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage.value!),
          backgroundColor: Colors.red.shade900,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  Future<void> logout(BuildContext context) async {
    try {
      isLoading.value = true;

      final result = await _logoutUseCase();

      result.fold(
            (exception) {
          _clearSession();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Logged out locally'),
              backgroundColor: Colors.orange.shade900,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          context.go('/login');
        },
            (_) {
          _clearSession();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Logged out successfully'),
              backgroundColor: Colors.green.shade900,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          context.go('/login');
        },
      );
    } catch (e) {
      _clearSession();
      context.go('/login');
    } finally {
      isLoading.value = false;
    }
  }

  void _clearSession() {
    isAuthenticated.value = false;
    user.value = null;
    clearControllers();
  }

  // Error message mapper
  String _getErrorMessage(AppException exception) {
    if (exception is InternetException) {
      return 'No internet connection. Please check your network.';
    } else if (exception is RequestTimeOutException) {
      return 'Request timeout. Please try again.';
    } else if (exception is UnauthorizedException) {
      return 'Invalid email or password.';
    } else if (exception is ServerException) {
      return 'Server error. Please try again later.';
    } else if (exception is BadRequestException) {
      final errorMessage = exception.toString().toLowerCase();

      if (errorMessage.contains('phone') && errorMessage.contains('taken')) {
        return 'This phone number is already registered.';
      }
      if (errorMessage.contains('email') && errorMessage.contains('taken')) {
        return 'This email is already registered.';
      }
      return 'Invalid request. Please check your information.';
    } else if (exception is NotFoundException) {
      return 'Resource not found.';
    } else {
      return exception.toString().replaceAll('AppException: ', '');
    }
  }

  // UI Helpers
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void clearError() {
    errorMessage.value = null;
  }

  void clearControllers() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
  }

  void resetPasswordVisibility() {
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }

  bool isLoginFormValid(String email, String password) {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        isValidEmail(email) &&
        password.length >= 6;
  }

  bool isSignupFormValid() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        isValidEmail(emailController.text.trim()) &&
        passwordController.text.length >= 6 &&
        isPasswordMatch;
  }
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}
