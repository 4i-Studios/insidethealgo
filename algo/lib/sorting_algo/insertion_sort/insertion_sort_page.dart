import 'package:flutter/material.dart';
import '../../widgets/expandable_action_fab.dart';
import '../../widgets/algorithm_app_bar.dart';
import '../../widgets/algorithm_layout.dart';
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
      appBar: AlgorithmAppBar(
        title: const Text('Insertion Sort Algorithm Demo'),
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

      body: AlgorithmLayout(
        inputSection: HideableInputSection(
          child: _widgets.buildInputSection(context),
          hide: _logic.isSorting,
        ),
        animationArea: _widgets.buildAnimationArea(context),
        statusDisplay: _widgets.buildStatusDisplay(context),
        codeDisplay: _widgets.buildCodeAndControlsArea(context),
        floatingActionButton: ExpandableActionFab(
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
      ),
    );
  }
}
