import 'package:flutter/material.dart';
import '../../widgets/algorithm_app_bar.dart';
import '../../widgets/algorithm_layout.dart';
import '../../widgets/expandable_action_fab.dart';
import 'merge_sort_logic.dart';
import 'merge_sort_widgets.dart';
import 'merge_sort_guide.dart';

class MergeSortPage extends StatefulWidget {
  const MergeSortPage({super.key});

  @override
  State<MergeSortPage> createState() => _MergeSortPageState();
}

class _MergeSortPageState extends State<MergeSortPage>
    with TickerProviderStateMixin {
  late final MergeSortLogic _logic;
  late final MergeSortWidgets _widgets;

  @override
  void initState() {
    super.initState();
    _logic = MergeSortLogic(
      onStateChanged: () => setState(() {}),
      vsync: this,
    );
    _widgets = MergeSortWidgets(_logic);
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
        title: const Text('Merge Sort Algorithm Demo'),
        actions: [
          TextButton.icon(
            label: const Text(
              'Guide',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            icon: const Icon(Icons.book, size: 18, color: Colors.white),
            onPressed: () => MergeSortGuide.show(context),
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
