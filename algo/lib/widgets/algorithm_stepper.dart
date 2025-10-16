import 'package:flutter/material.dart';

class AlgorithmStep {
  final String title;
  final String description;
  final bool isActive;
  final bool isCompleted;

  const AlgorithmStep({
    required this.title,
    required this.description,
    this.isActive = false,
    this.isCompleted = false,
  });
}

class AlgorithmStepper extends StatelessWidget {
  final List<AlgorithmStep> steps;
  final int currentStep;
  final Axis direction;

  const AlgorithmStepper({
    Key? key,
    required this.steps,
    required this.currentStep,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.vertical) {
      return Column(
        children: steps.asMap().entries.map((entry) {
          return _buildStepItem(entry.key, entry.value, isVertical: true);
        }).toList(),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: steps.asMap().entries.map((entry) {
          return _buildStepItem(entry.key, entry.value, isVertical: false);
        }).toList(),
      ),
    );
  }

  Widget _buildStepItem(int index, AlgorithmStep step, {required bool isVertical}) {
    Color getStepColor() {
      if (step.isCompleted) return Colors.green;
      if (step.isActive || index == currentStep) return Colors.blue;
      return Colors.grey;
    }

    Widget stepWidget = Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: getStepColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: getStepColor()),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            step.isCompleted ? Icons.check : Icons.radio_button_unchecked,
            color: getStepColor(),
            size: 16,
          ),
          const SizedBox(height: 4),
          Text(
            step.title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: getStepColor(),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    if (isVertical) {
      return Column(
        children: [
          stepWidget,
          if (index < steps.length - 1)
            Container(
              height: 20,
              width: 2,
              color: Colors.grey.shade300,
            ),
        ],
      );
    }

    return Row(
      children: [
        stepWidget,
        if (index < steps.length - 1)
          Container(
            height: 2,
            width: 20,
            color: Colors.grey.shade300,
          ),
      ],
    );
  }
}