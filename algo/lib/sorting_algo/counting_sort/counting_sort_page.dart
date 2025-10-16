import 'package:flutter/material.dart';
import '../../widgets/expandable_action_fab.dart';
import '../../widgets/algorithm_app_bar.dart';
import '../../widgets/algorithm_layout.dart';
import 'counting_sort_logic.dart';
import 'counting_sort_widgets.dart';
import 'counting_sort_guide.dart';

class CountingSortPage extends StatefulWidget {
  const CountingSortPage({super.key});

  @override
  State<CountingSortPage> createState() => _CountingSortPageState();
}

class _CountingSortPageState extends State<CountingSortPage>
    with TickerProviderStateMixin {
  late final CountingSortLogic _logic;
  late final CountingSortWidgets _widgets;

  @override
  void initState() {
    super.initState();
    _logic = CountingSortLogic(
      onStateChanged: () => setState(() {}),
      vsync: this,
    );
    _widgets = CountingSortWidgets(_logic);
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
        title: const Text('Counting Sort Algorithm Demo'),
        actions: [
          TextButton.icon(
            label: const Text(
              'Guide',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            icon: const Icon(Icons.book, size: 18, color: Colors.white),
            onPressed: () => CountingSortGuide.show(context),
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

