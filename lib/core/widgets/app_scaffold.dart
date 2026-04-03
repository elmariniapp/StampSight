import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
              automaticallyImplyLeading: showBackButton,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
