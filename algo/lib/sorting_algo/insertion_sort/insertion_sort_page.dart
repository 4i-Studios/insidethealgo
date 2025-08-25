import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/expandable_action_fab.dart';
import 'insertion_sort_logic.dart';
import 'insertion_sort_widgets.dart';
import 'insertion_sort_guide.dart';

class InsertionSortPage extends StatefulWidget {
  const InsertionSortPage({super.key});

  @override
  State<InsertionSortPage> createState() => _InsertionSortPageState();
}

class _InsertionSortPageState extends State<InsertionSortPage>
    with TickerProviderStateMixin {
  late final InsertionSortLogic _logic;
  late final InsertionSortWidgets _widgets;

  @override
  void initState() {
    super.initState();
    _logic = InsertionSortLogic(
      onStateChanged: () => setState(() {}),
      vsync: this,
    );
    _widgets = InsertionSortWidgets(_logic);
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertion Sort Algorithm Demo'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            label: const Text(
              'Guide',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            icon: const Icon(Icons.book, size: 18, color: Colors.white),
            onPressed: () => InsertionSortGuide.show(context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              // Input section
              _widgets.buildInputSection(context),

              // Animation area
              Expanded(
                flex: 3,
                child: _widgets.buildAnimationArea(context),
              ),

              // Status display
              _widgets.buildStatusDisplay(context),

              // Code and controls area
              Flexible(
                flex: 6,
                child: _widgets.buildCodeAndControlsArea(context),
              ),
            ],
          ),

          // Floating action button
          ExpandableActionFab(
            speed: _logic.speed,
            onSpeedChanged: _logic.updateSpeed,
            isExpanded: _logic.isSpeedControlExpanded,
            onTap: () => _logic.toggleSpeedControl(),
            actionButtons: [
              ActionButton(
                onPressed: _logic.onPlayPausePressed,
                icon: _logic.isSorting
                    ? (_logic.isPaused ? Icons.play_arrow : Icons.pause)
                    : Icons.play_arrow,
                label: _logic.isSorting
                    ? (_logic.isPaused ? 'Play' : 'Pause')
                    : 'Start',
                color: Colors.green,
              ),
              ActionButton(
                onPressed: _logic.isSorting ? _logic.stopSorting : null,
                icon: Icons.stop,
                label: 'Stop',
                color: Colors.red,
              ),
              ActionButton(
                onPressed: !_logic.isSorting ? _logic.resetArray : null,
                icon: Icons.refresh,
                label: 'Reset',
                color: Colors.orange,
              ),
              ActionButton(
                onPressed: !_logic.isSorting ? _logic.shuffleArray : null,
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