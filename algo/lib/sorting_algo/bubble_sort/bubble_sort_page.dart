import 'package:flutter/material.dart';
import '../../widgets/algorithm_app_bar.dart';
import '../../widgets/algorithm_layout.dart';
import '../../widgets/expandable_action_fab.dart';
import 'bubble_sort_logic.dart';
import 'bubble_sort_widgets.dart';
import 'bubble_sort_guide.dart';

class BubbleSortPage extends StatefulWidget {
  const BubbleSortPage({super.key});

  @override
  State<BubbleSortPage> createState() => _BubbleSortPageState();
}

class _BubbleSortPageState extends State<BubbleSortPage>
    with TickerProviderStateMixin {
  late final BubbleSortLogic _logic;
  late final BubbleSortWidgets _widgets;

  @override
  void initState() {
    super.initState();
    _logic = BubbleSortLogic(
      onStateChanged: () => setState(() {}),
      vsync: this,
    );
    _widgets = BubbleSortWidgets(_logic);
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
        title: const Text('Bubble Sort Algorithm Demo'),
        actions: [
          TextButton.icon(
            label: const Text(
              'Guide',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            icon: const Icon(Icons.book, size: 18, color: Colors.white),
            onPressed: () => BubbleSortGuide.show(context),
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
              onPressed: _logic.isSorting
                  ? (_logic.isPaused ? _logic.onPlayPausePressed : _logic.onPlayPausePressed)
                  : _logic.onPlayPausePressed,
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