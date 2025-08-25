import 'package:flutter/material.dart';

class ColorLegendItem {
  final Color color;
  final String label;

  const ColorLegendItem({
    required this.color,
    required this.label,
  });
}

class ColorLegend extends StatelessWidget {
  final List<ColorLegendItem> items;
  final double itemSize;
  final double fontSize;

  const ColorLegend({
    Key? key,
    required this.items,
    this.itemSize = 12,
    this.fontSize = 11,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items
              .map((item) => _buildLegendItem(item.color, item.label))
              .expand((widget) => [widget, const SizedBox(width: 12)])
              .take(items.length * 2 - 1)
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: itemSize,
          height: itemSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: fontSize)),
      ],
    );
  }
}