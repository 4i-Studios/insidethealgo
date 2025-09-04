import 'package:flutter/material.dart';

class AlgorithmLayout extends StatelessWidget {
  final Widget inputSection;
  final Widget animationArea;
  final Widget? statusDisplay;
  final Widget codeDisplay;
  final Widget floatingActionButton;

  const AlgorithmLayout({
    Key? key,
    required this.inputSection,
    required this.animationArea,
    this.statusDisplay,
    required this.codeDisplay,
    required this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hide inputSection if simulation is running
                if (!(inputSection is HideableInputSection && (inputSection as HideableInputSection).hide))
                  inputSection,
                Expanded(
                  flex: 6,
                  child: animationArea,
                ),
                if (statusDisplay != null) statusDisplay!,
                Expanded(
                  flex: 8,
                  child: codeDisplay,
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: floatingActionButton,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget to allow hiding input section
class HideableInputSection extends StatelessWidget {
  final Widget child;
  final bool hide;
  const HideableInputSection({required this.child, required this.hide});
  @override
  Widget build(BuildContext context) => hide ? const SizedBox.shrink() : child;
}