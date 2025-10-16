import 'package:flutter/material.dart';

import '../components/algorithm_state.dart';

// Re-export CodeLine from algorithm_state.dart for backward compatibility
export '../components/algorithm_state.dart' show CodeLine;

class CodeDisplay extends StatelessWidget {
  final String title;
  final List<CodeLine> codeLines;
  final int highlightedLine;
  final Function(String)? getTextColor;

  const CodeDisplay({
    Key? key,
    required this.title,
    required this.codeLines,
    this.highlightedLine = -1,
    this.getTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Expanded(child: SingleChildScrollView(child: _buildCodeContainer())),
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
        children: [_buildCodeHeader(), _buildCodeContent()],
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
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${title.replaceAll(' ', '')}.dart',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
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
                color: isHighlighted
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.transparent,
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
                  _buildSyntaxHighlightedText(codeLine),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSyntaxHighlightedText(CodeLine codeLine) {
    // Always use the advanced syntax highlighting instead of simple color function
    return RichText(
      text: TextSpan(
        children: _parseCodeLine('${'  ' * codeLine.indent}${codeLine.text}'),
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'monospace',
          color: Colors.white,
        ),
      ),
    );
  }

  List<TextSpan> _parseCodeLine(String line) {
    List<TextSpan> spans = [];
    String remaining = line;

    while (remaining.isNotEmpty) {
      bool matched = false;

      // Check for comments first (highest priority)
      RegExp commentRegex = RegExp(r'//.*$|/\*.*?\*/');
      Match? commentMatch = commentRegex.firstMatch(remaining);
      if (commentMatch != null && commentMatch.start == 0) {
        spans.add(
          TextSpan(
            text: commentMatch.group(0)!,
            style: const TextStyle(
              color: Color(0xFF6A9955),
              fontStyle: FontStyle.italic,
            ),
          ),
        );
        remaining = remaining.substring(commentMatch.end);
        matched = true;
      }

      // Check for strings
      if (!matched) {
        RegExp stringRegex = RegExp(r'''(['"`])(?:(?!\1)[^\\]|\\.)*.?\1''');
        Match? stringMatch = stringRegex.firstMatch(remaining);
        if (stringMatch != null && stringMatch.start == 0) {
          spans.add(
            TextSpan(
              text: stringMatch.group(0)!,
              style: const TextStyle(color: Color(0xFFCE9178)),
            ),
          );
          remaining = remaining.substring(stringMatch.end);
          matched = true;
        }
      }

      // Check for numbers
      if (!matched) {
        RegExp numberRegex = RegExp(r'\b\d+\.?\d*[fFdDlL]?\b');
        Match? numberMatch = numberRegex.firstMatch(remaining);
        if (numberMatch != null && numberMatch.start == 0) {
          spans.add(
            TextSpan(
              text: numberMatch.group(0)!,
              style: const TextStyle(color: Color(0xFFB5CEA8)),
            ),
          );
          remaining = remaining.substring(numberMatch.end);
          matched = true;
        }
      }

      // Check for keywords
      if (!matched) {
        List<String> keywords = [
          'abstract',
          'as',
          'assert',
          'async',
          'await',
          'break',
          'case',
          'catch',
          'class',
          'const',
          'continue',
          'default',
          'do',
          'else',
          'enum',
          'extends',
          'external',
          'factory',
          'false',
          'final',
          'finally',
          'for',
          'function',
          'get',
          'if',
          'implements',
          'import',
          'in',
          'interface',
          'is',
          'library',
          'mixin',
          'new',
          'null',
          'operator',
          'part',
          'return',
          'set',
          'static',
          'super',
          'switch',
          'this',
          'throw',
          'true',
          'try',
          'typedef',
          'var',
          'void',
          'while',
          'with',
          'yield',
          'late',
          'required',
          'covariant',
          'deferred',
          'export',
          'hide',
          'show',
          'sync',
          'rethrow',
        ];

        for (String keyword in keywords) {
          RegExp keywordRegex = RegExp(r'\b' + RegExp.escape(keyword) + r'\b');
          Match? keywordMatch = keywordRegex.firstMatch(remaining);
          if (keywordMatch != null && keywordMatch.start == 0) {
            spans.add(
              TextSpan(
                text: keywordMatch.group(0)!,
                style: const TextStyle(
                  color: Color(0xFF569CD6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
            remaining = remaining.substring(keywordMatch.end);
            matched = true;
            break;
          }
        }
      }

      // Check for types and classes
      if (!matched) {
        List<String> types = [
          'bool',
          'int',
          'double',
          'String',
          'List',
          'Map',
          'Set',
          'Future',
          'Stream',
          'Widget',
          'StatelessWidget',
          'StatefulWidget',
          'State',
          'BuildContext',
          'Color',
          'TextStyle',
          'EdgeInsets',
          'BorderRadius',
          'BoxDecoration',
          'Container',
          'Column',
          'Row',
          'Stack',
          'Positioned',
          'Expanded',
          'Flexible',
          'SizedBox',
          'Padding',
          'Margin',
          'Align',
          'Center',
          'AnimatedContainer',
          'GestureDetector',
          'InkWell',
          'Material',
          'Scaffold',
          'AppBar',
          'FloatingActionButton',
          'TextField',
          'TextFormField',
          'Form',
          'GlobalKey',
          'Key',
          'ValueKey',
          'ObjectKey',
          'Animation',
          'AnimationController',
          'Tween',
          'Curve',
          'Duration',
          'Timer',
          'StreamBuilder',
          'FutureBuilder',
          'ChangeNotifier',
          'ValueNotifier',
          'dynamic',
          'Object',
          'Function',
          'Iterable',
          'Iterator',
          'Comparable',
        ];

        for (String type in types) {
          RegExp typeRegex = RegExp(r'\b' + RegExp.escape(type) + r'\b');
          Match? typeMatch = typeRegex.firstMatch(remaining);
          if (typeMatch != null && typeMatch.start == 0) {
            spans.add(
              TextSpan(
                text: typeMatch.group(0)!,
                style: const TextStyle(
                  color: Color(0xFF4EC9B0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
            remaining = remaining.substring(typeMatch.end);
            matched = true;
            break;
          }
        }
      }

      // Check for annotations/decorators
      if (!matched) {
        RegExp annotationRegex = RegExp(r'@[a-zA-Z_][a-zA-Z0-9_]*');
        Match? annotationMatch = annotationRegex.firstMatch(remaining);
        if (annotationMatch != null && annotationMatch.start == 0) {
          spans.add(
            TextSpan(
              text: annotationMatch.group(0)!,
              style: const TextStyle(color: Color(0xFFFFD700)),
            ),
          );
          remaining = remaining.substring(annotationMatch.end);
          matched = true;
        }
      }

      // Check for function/method names
      if (!matched) {
        RegExp functionRegex = RegExp(r'\b[a-zA-Z_][a-zA-Z0-9_]*(?=\s*\()');
        Match? functionMatch = functionRegex.firstMatch(remaining);
        if (functionMatch != null && functionMatch.start == 0) {
          spans.add(
            TextSpan(
              text: functionMatch.group(0)!,
              style: const TextStyle(color: Color(0xFFDCDCAA)),
            ),
          );
          remaining = remaining.substring(functionMatch.end);
          matched = true;
        }
      }

      // Check for property access
      if (!matched) {
        RegExp propertyRegex = RegExp(r'(?<=\.)[a-zA-Z_][a-zA-Z0-9_]*');
        Match? propertyMatch = propertyRegex.firstMatch(remaining);
        if (propertyMatch != null && propertyMatch.start == 0) {
          spans.add(
            TextSpan(
              text: propertyMatch.group(0)!,
              style: const TextStyle(color: Color(0xFF9CDCFE)),
            ),
          );
          remaining = remaining.substring(propertyMatch.end);
          matched = true;
        }
      }

      // Check for operators
      if (!matched) {
        RegExp operatorRegex = RegExp(
          r'[+\-*/=<>!&|%^~?:;,.\[\]{}()]|=>|<=|>=|==|!=|&&|\|\||<<|>>|\+\+|--|\+=|-=|\*=|/=|%=|&=|\|=|\^=|<<=|>>=',
        );
        Match? operatorMatch = operatorRegex.firstMatch(remaining);
        if (operatorMatch != null && operatorMatch.start == 0) {
          spans.add(
            TextSpan(
              text: operatorMatch.group(0)!,
              style: const TextStyle(color: Color(0xFFD4D4D4)),
            ),
          );
          remaining = remaining.substring(operatorMatch.end);
          matched = true;
        }
      }

      // Check for identifiers (variables, class names, etc.)
      if (!matched) {
        RegExp identifierRegex = RegExp(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b');
        Match? identifierMatch = identifierRegex.firstMatch(remaining);
        if (identifierMatch != null && identifierMatch.start == 0) {
          String identifier = identifierMatch.group(0)!;
          // Check if it's a class name (starts with uppercase)
          Color identifierColor = identifier[0].toUpperCase() == identifier[0]
              ? const Color(0xFF4EC9B0)
              : const Color(0xFF9CDCFE);

          spans.add(
            TextSpan(
              text: identifier,
              style: TextStyle(color: identifierColor),
            ),
          );
          remaining = remaining.substring(identifierMatch.end);
          matched = true;
        }
      }

      // Default: add single character
      if (!matched) {
        spans.add(
          TextSpan(
            text: remaining[0],
            style: const TextStyle(color: Colors.white),
          ),
        );
        remaining = remaining.substring(1);
      }
    }

    return spans;
  }

  // Simplified static method - now only used as fallback
  static Color Function(String) getDefaultTextColor() {
    return (String text) {
      // This is now just a fallback - the main syntax highlighting
      // is handled by _parseCodeLine()
      return Colors.white;
    };
  }
}
