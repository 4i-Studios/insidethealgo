import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/expandable_action_fab.dart';
import 'selection_sort_logic.dart';
import 'selection_sort_widgets.dart';
import 'selection_sort_guide.dart';

class SelectionSortPage extends StatefulWidget {
  const SelectionSortPage({super.key});

  @override
  State<SelectionSortPage> createState() => _SelectionSortPageState();
}

class _SelectionSortPageState extends State<SelectionSortPage>
    with TickerProviderStateMixin {
  late final SelectionSortLogic _logic;
  late final SelectionSortWidgets _widgets;

  @override
  void initState() {
    super.initState();
    _logic = SelectionSortLogic(
      onStateChanged: () => setState(() {}),
      vsync: this,
    );
    _widgets = SelectionSortWidgets(_logic);
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
        title: const Text('Selection Sort Algorithm Demo'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            label: const Text(
              'Guide',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            icon: const Icon(Icons.book, size: 18, color: Colors.white),
            onPressed: () => SelectionSortGuide.show(context),
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