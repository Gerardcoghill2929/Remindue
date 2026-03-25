import 'package:flutter/material.dart';
import 'package:remindue/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final String styleType;

  const MyButton({
    super.key,
    required this.label,
    required this.onTap,
    this.styleType = 'primary',
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final normalizedStyle = styleType.toLowerCase();

    final backgroundColor = switch (normalizedStyle) {
      'secondary' => Colors.white,
      'outline' => Colors.transparent,
      _ => primaryColor,
    };

    final textColor = switch (normalizedStyle) {
      'secondary' => Colors.black,
      'outline' => isDarkMode ? Colors.white : Colors.black,
      _ => Colors.white,
    };

    final borderColor = switch (normalizedStyle) {
      'outline' => isDarkMode ? Colors.white : Colors.black,
      _ => Colors.transparent,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}