import 'package:flutter/material.dart';

class ActionButton {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
  });
}

class ExpandableActionFab extends StatefulWidget {
  final double speed;
  final Function(double) onSpeedChanged;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<ActionButton> actionButtons;

  const ExpandableActionFab({
    super.key,
    required this.speed,
    required this.onSpeedChanged,
    required this.isExpanded,
    required this.onTap,
    this.actionButtons = const [],
  });

  @override
  State<ExpandableActionFab> createState() => _ExpandableActionFabState();
}

class _ExpandableActionFabState extends State<ExpandableActionFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _buttonAnimation;
  late List<Animation<double>> _buttonStaggeredAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 600,
      ), // Increased duration for smoother animation
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Main button animation with bounce effect
    _buttonAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    );

    // Initialize empty list - will be populated in didChangeDependencies or didUpdateWidget
    _buttonStaggeredAnimations = [];
  }

  void _updateButtonAnimations() {
    // Clear existing animations
    _buttonStaggeredAnimations.clear();

    // Create animations based on actual button count
    final int buttonCount = widget.actionButtons.length;
    _buttonStaggeredAnimations = List.generate(buttonCount, (index) {
      // Reverse the index so bottom button starts first
      int reversedIndex = (buttonCount - 1) - index;
      double startInterval = 0.3 + (reversedIndex * 0.1); // Bottom button starts first
      double endInterval = startInterval + 0.25; // Shorter, snappier animation
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(
          startInterval,
          endInterval.clamp(0.0, 1.0),
          curve: Curves.easeOutQuart, // Smooth, elegant curve
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateButtonAnimations();
  }

  @override
  void didUpdateWidget(ExpandableActionFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    // Update button animations if the action buttons list has changed
    if (widget.actionButtons != oldWidget.actionButtons) {
      _updateButtonAnimations();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: AnimatedBuilder(
        animation: _controller, // Listen to the main controller instead
        builder: (context, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Action Buttons (appear above speed control)
              if (widget.actionButtons.isNotEmpty && _buttonAnimation.value > 0)
                ...widget.actionButtons.asMap().entries.map((entry) {
                  int index = entry.key;
                  ActionButton button = entry.value;

                  // Get the staggered animation for this specific button
                  Animation<double> staggeredAnimation =
                      _buttonStaggeredAnimations[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Transform.scale(
                      // Simple scale animation - button grows from 0 to 1
                      scale: staggeredAnimation.value.clamp(0.0, 1.0),
                      child: Opacity(
                        // Simple fade in
                        opacity: staggeredAnimation.value.clamp(0.0, 1.0),
                        child: Container(
                          // Add subtle shadow and glow effect
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: staggeredAnimation.value > 0.5
                                ? [
                                    BoxShadow(
                                      color: button.color.withValues(alpha: 0.3),
                                      blurRadius: (8 * staggeredAnimation.value)
                                          .clamp(0.0, 8.0),
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: SizedBox(
                            width: 120,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: button.onPressed,
                              icon: Icon(button.icon, size: 16),
                              label: Text(
                                button.label,
                                style: const TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: button.onPressed != null
                                    ? button.color
                                    : button.color.withOpacity(0.6),
                                foregroundColor: button.onPressed != null
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                                disabledBackgroundColor: button.color
                                    .withOpacity(0.6),
                                disabledForegroundColor: Colors.white
                                    .withOpacity(0.7),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                elevation: button.onPressed != null ? 4 : 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),

              // Speed Control (existing functionality)
              Container(
                height: 56,
                width:
                    56 + (_expandAnimation.value * 200), // Expand by 200 pixels
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      // Speed Slider
                      if (_expandAnimation.value > 0.5)
                        Positioned(
                          left: 24,
                          right: 64,
                          child: Opacity(
                            opacity:
                                (_expandAnimation.value - 0.5) *
                                2, // fade in from 0.5 to 1.0
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: Colors.white
                                          .withOpacity(0.7),
                                      inactiveTrackColor: Colors.white
                                          .withOpacity(0.3),
                                      thumbColor: Colors.white,
                                      overlayColor: Colors.white.withOpacity(
                                        0.1,
                                      ),
                                      trackHeight: 2,
                                    ),
                                    child: Slider(
                                      value: widget.speed,
                                      min: 0.5,
                                      max: 3.0,
                                      divisions: 5,
                                      onChanged: widget.onSpeedChanged,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${widget.speed}x',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // FAB
                      Positioned(
                        right: 0,
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: InkWell(
                            onTap: widget.onTap,
                            customBorder: const CircleBorder(),
                            child: Center(
                              child: Transform.scale(
                                scale:
                                    1.0 +
                                    (_expandAnimation.value *
                                        0.1), // Subtle pulse effect
                                child: AnimatedRotation(
                                  duration: const Duration(milliseconds: 600),
                                  turns: widget.isExpanded
                                      ? 0.75
                                      : 0, // More dramatic rotation
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return RotationTransition(
                                        turns: animation,
                                        child: ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      widget.isExpanded
                                          ? Icons.close
                                          : Icons.add,
                                      key: ValueKey(widget.isExpanded),
                                      color: const Color.fromARGB(
                                        255,
                                        85,
                                        76,
                                        76,
                                      ),
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
