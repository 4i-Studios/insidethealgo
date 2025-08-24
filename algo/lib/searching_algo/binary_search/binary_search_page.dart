import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/expandable_action_fab.dart';
import 'binary_search_logic.dart';
import 'binary_search_widgets.dart';
import 'binary_search_guide.dart';

class BinarySearchPage extends StatefulWidget {
  const BinarySearchPage({super.key});

  @override
  State<BinarySearchPage> createState() => _BinarySearchPageState();
}

class _BinarySearchPageState extends State<BinarySearchPage>
    with TickerProviderStateMixin {
  late final BinarySearchLogic _logic;
  late final BinarySearchWidgets _widgets;

  @override
  void initState() {
    super.initState();
    _logic = BinarySearchLogic(
      onStateChanged: () => setState(() {}),
      vsync: this,
    );
    _widgets = BinarySearchWidgets(_logic);
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
        title: const Text('Binary Search Algorithm Demo'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            label: const Text(
              'Guide',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            icon: const Icon(Icons.book, size: 18, color: Colors.white),
            onPressed: () => BinarySearchGuide.show(context),
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
                flex: 4,
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
                icon: _logic.isSearching
                    ? (_logic.isPaused ? Icons.play_arrow : Icons.pause)
                    : Icons.play_arrow,
                label: _logic.isSearching
                    ? (_logic.isPaused ? 'Play' : 'Pause')
                    : 'Start',
                color: Colors.indigo,
              ),
              ActionButton(
                onPressed: _logic.isSearching ? _logic.stopSearching : null,
                icon: Icons.stop,
                label: 'Stop',
                color: Colors.red,
              ),
              ActionButton(
                onPressed: !_logic.isSearching ? _logic.resetArray : null,
                icon: Icons.refresh,
                label: 'Reset',
                color: Colors.orange,
              ),
              ActionButton(
                onPressed: !_logic.isSearching ? _logic.sortArray : null,
                icon: Icons.sort,
                label: 'Sort',
                color: Colors.indigo,
              ),
            ],
          ),
        ],
      ),
    );
  }
}