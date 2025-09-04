import 'package:flutter/material.dart';

class InputSection extends StatelessWidget {
  final TextEditingController controller;
  final bool isDisabled;
  final VoidCallback onSetPressed;
  final String hintText;

  const InputSection({
    Key? key,
    required this.controller,
    required this.isDisabled,
    required this.onSetPressed,
    this.hintText = 'Enter up to 10 numbers (e.g. 5,2,9)',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      hintText: hintText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: isDisabled ? null : onSetPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Set', style: TextStyle(fontSize: 13)),
                  ),
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