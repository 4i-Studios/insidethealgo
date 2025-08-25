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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              inputSection,
              Expanded(
                flex: 3,
                child: animationArea,
              ),
              if (statusDisplay != null) statusDisplay!,
              Expanded(
                flex: 2,
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
    );
  }
}