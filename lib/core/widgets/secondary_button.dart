import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = icon != null
        ? OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 20),
            label: Text(label),
          )
        : OutlinedButton(
            onPressed: onPressed,
            child: Text(label),
          );

    return isExpanded ? SizedBox(width: double.infinity, child: child) : child;
  }
}
