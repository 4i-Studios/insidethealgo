import 'package:flutter/material.dart';

class TreeNode {
  final List<int> array;
  final int level;
  final bool isLeaf;
  final bool isActive;
  final Color color;

  const TreeNode({
    required this.array,
    required this.level,
    this.isLeaf = false,
    this.isActive = false,
    this.color = Colors.blue,
  });
}

class TreeVisualization extends StatelessWidget {
  final List<int> rootArray;
  final String title;
  final Function(List<int>, int) buildTreeStructure;
  final int maxLevels;

  const TreeVisualization({
    Key? key,
    required this.rootArray,
    this.title = 'Divide & Conquer Tree',
    required this.buildTreeStructure,
    this.maxLevels = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildTreeStructure(rootArray, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TreeNodeWidget extends StatelessWidget {
  final TreeNode node;
  final double fontSize;

  const TreeNodeWidget({
    Key? key,
    required this.node,
    this.fontSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color nodeColor = node.isLeaf
        ? Colors.green.shade100
        : node.isActive
            ? Colors.orange.shade100
            : node.color.withOpacity(0.3);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: nodeColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: node.isActive ? Colors.red : Colors.grey.shade400,
          width: node.isActive ? 2 : 1,
        ),
      ),
      child: Text(
        '[${node.array.join(',')}]',
        style: TextStyle(
          fontSize: (fontSize - node.level).clamp(8, 14).toDouble(),
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class TreeLinePainter extends CustomPainter {
  final Color lineColor;
  final double strokeWidth;

  TreeLinePainter({
    this.lineColor = Colors.grey,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth;

    // Draw branching lines
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.25, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.75, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}