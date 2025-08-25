import 'package:flutter/material.dart';
import 'status_chip.dart';
import 'array_chip.dart';

class MetricItem {
  final String label;
  final dynamic value;
  final Color color;
  final bool isArray;

  const MetricItem({
    required this.label,
    required this.value,
    required this.color,
    this.isArray = false,
  });
}

class MetricsPanel extends StatelessWidget {
  final List<MetricItem> metrics;
  final String? title;
  final double height;

  const MetricsPanel({
    Key? key,
    required this.metrics,
    this.title,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
          ],
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: metrics.map((metric) {
                  if (metric.isArray && metric.value is List<int>) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ArrayChip(
                        label: metric.label,
                        array: metric.value as List<int>,
                        color: metric.color,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: StatusChip(
                        label: metric.label,
                        value: metric.value.toString(),
                        color: metric.color,
                      ),
                    );
                  }
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}