import 'package:flutter/material.dart';

class CodeLine {
  final int line;
  final String text;
  final int indent;

  const CodeLine({
    required this.line,
    required this.text,
    required this.indent,
  });
}

class CodeDisplay extends StatelessWidget {
  final String title;
  final List<CodeLine> codeLines;
  final int highlightedLine;
  final Function(String) getTextColor;

  const CodeDisplay({
    Key? key,
    required this.title,
    required this.codeLines,
    this.highlightedLine = -1,
    required this.getTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: _buildCodeContainer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeHeader(),
          _buildCodeContent(),
        ],
      ),
    );
  }

  Widget _buildCodeHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D30),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Text(
            '${title.replaceAll(' ', '')}.dart',
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: codeLines.map((codeLine) {
            bool isHighlighted = highlightedLine == codeLine.line;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: isHighlighted ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${codeLine.line + 1}',
                      style: const TextStyle(
                        color: Color(0xFF858585),
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${'  ' * codeLine.indent}${codeLine.text}',
                    style: TextStyle(
                      color: getTextColor(codeLine.text),
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}