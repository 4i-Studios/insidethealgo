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

class ExpandableSpeedControl extends StatefulWidget {
  final double speed;
  final Function(double) onSpeedChanged;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<ActionButton> actionButtons;

  const ExpandableSpeedControl({
    super.key,
    required this.speed,
    required this.onSpeedChanged,
    required this.isExpanded,
    required this.onTap,
    this.actionButtons = const [],
  });

  @override
  State<ExpandableSpeedControl> createState() => _ExpandableSpeedControlState();
}

class _ExpandableSpeedControlState extends State<ExpandableSpeedControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    // Button animation starts after speed control expands
    _buttonAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(ExpandableSpeedControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
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
                ...widget.actionButtons.map((button) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Transform.scale(
                      scale: 0.8 + (_buttonAnimation.value * 0.2),
                      child: Opacity(
                        opacity: _buttonAnimation.value,
                        child: SizedBox(
                          width: 120,
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: button.onPressed, // Now functional!
                            icon: Icon(button.icon, size: 16),
                            label: Text(
                              button.label,
                              style: const TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: button.onPressed != null
                                  ? button.color
                                  : button.color.withOpacity(
                                      0.6,
                                    ), // Muted but visible when disabled
                              foregroundColor: button.onPressed != null
                                  ? Colors.white
                                  : Colors.white.withOpacity(
                                      0.7,
                                    ), // Slightly muted text when disabled
                              disabledBackgroundColor: button.color.withOpacity(
                                0.6,
                              ), // Explicitly set disabled color
                              disabledForegroundColor: Colors.white.withOpacity(
                                0.7,
                              ), // Explicitly set disabled text color
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              elevation: button.onPressed != null
                                  ? 4
                                  : 2, // Less shadow when disabled
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
                                  Icons.speed,
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
                              child: AnimatedRotation(
                                duration: const Duration(milliseconds: 300),
                                turns: widget.isExpanded ? 0.5 : 0,
                                child: const Icon(
                                  Icons.speed,
                                  color: Colors.white,
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
