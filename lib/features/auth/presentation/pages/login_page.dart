
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webflow_auth_app/app/colors/app_colors.dart';
import 'package:webflow_auth_app/features/auth/presentation/widgets/round_button.dart';
import 'package:webflow_auth_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:webflow_auth_app/features/auth/presentation/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final AuthController controller = Get.find();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withValues(alpha: 0.5),
              AppColors.primaryColorLight.withValues(alpha: 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to your account",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textColor86,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      label: "Email",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email required";
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Password Field with Obx for visibility toggle
                    Obx(
                      () => CustomTextField(
                        controller: _passwordController,
                        label: "Password",
                        isPassword: !controller.isPasswordVisible.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.textColor86,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password required";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login Button - Always clickable, validation happens on press
                    Obx(
                      () => RoundButton(
                        title: "Login",
                        loading: controller
                            .isLoading
                            .value, // This disables button when loading
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.login(
                              _emailController.text.trim(),
                              _passwordController.text,
                              context,
                            );
                          }
                        },
                        gradientColors: const [
                          AppColors.primaryColor,
                          AppColors.primaryColorLight,
                        ],
                        textColor: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Signup Link
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: AppColors.textColor86,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Signup",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/signup');
                              },
                          ),
                        ],
                      ),
                    ),

                    // Error Message Display
                    Obx(() {
                      if (controller.errorMessage.value != null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            controller.errorMessage.value!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
