
import 'package:flutter/material.dart';
import 'package:webflow_auth_app/app/colors/app_colors.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;
  final double width;
  final Color textColor;
  final List<Color>? gradientColors;
  final bool enabled;

  const RoundButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.loading = false,
    this.height = 50,
    this.width = double.infinity,
    this.textColor = Colors.white,
    this.gradientColors,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = enabled && !loading && onPressed != null;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: gradientColors != null && isEnabled
              ? LinearGradient(
            colors: gradientColors!,
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ) : null,
          color: !isEnabled
              ? AppColors.textColorCO
              : (gradientColors == null ? Colors.green : null),
          borderRadius: BorderRadius.circular(50),
          boxShadow: isEnabled
              ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: loading
            ? Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: textColor,
              strokeWidth: 3,
            ),
          ),
        )
            : Center(
          child: Text(
            title,
            style: TextStyle(
              color: isEnabled ? textColor : AppColors.textColor86,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
