import 'package:flutter/material.dart';

/// AlgorithmAppBar
/// Lightweight AppBar component preserving existing styling and actions.
class AlgorithmAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;

  const AlgorithmAppBar({Key? key, required this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: Colors.blue.shade700,
      foregroundColor: Colors.white,
      elevation: 2,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

