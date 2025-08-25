import 'package:flutter/material.dart';

class InputSection extends StatelessWidget {
  final TextEditingController controller;
  final bool isDisabled;
  final VoidCallback onSetPressed;
  final String labelText;
  final String hintText;

  const InputSection({
    Key? key,
    required this.controller,
    required this.isDisabled,
    required this.onSetPressed,
    this.labelText = 'Enter numbers (comma separated)',
    this.hintText = 'e.g., 64, 34, 25, 12, 22',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: labelText,
                      border: const OutlineInputBorder(),
                      hintText: hintText,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: isDisabled ? null : onSetPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Set'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}