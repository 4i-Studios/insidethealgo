import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/expandable_action_fab.dart';
import 'merge_sort_logic.dart';
import 'merge_sort_widgets.dart';

class MergeSortPage extends StatefulWidget {
  const MergeSortPage({super.key});

  @override
  State<MergeSortPage> createState() => _MergeSortPageState();
}

class _MergeSortPageState extends State<MergeSortPage>
    with TickerProviderStateMixin {
  late MergeSortLogic logic;
  late MergeSortWidgets widgets;
  double speed = 1.0;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    logic = MergeSortLogic(this);
    widgets = MergeSortWidgets(logic);
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merge Sort Visualization'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: logic,
            builder: (context, child) {
              return Column(
                children: [
                  widgets.buildInputSection(context),
                  Expanded(flex: 1, child: widgets.buildAnimationArea(context)),
                  widgets.buildStatusDisplay(context),
                  Expanded(flex: 2, child: widgets.buildCodeDisplay(context)),
                ],
              );
            },
          ),
          ExpandableActionFab(
            speed: speed,
            onSpeedChanged: (newSpeed) {
              setState(() {
                speed = newSpeed;
              });
            },
            isExpanded: isExpanded,
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            actionButtons: [
              ActionButton(
                onPressed: logic.isSorting ? null : () => logic.startSort(),
                icon: Icons.play_arrow,
                label: 'Start',
                color: Colors.green,
              ),
              ActionButton(
                onPressed: !logic.isSorting ? () => logic.resetArray() : null,
                icon: Icons.refresh,
                label: 'Reset',
                color: Colors.orange,
              ),
              ActionButton(
                onPressed: !logic.isSorting ? () => logic.shuffleArray() : null,
                icon: Icons.shuffle,
                label: 'Shuffle',
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
