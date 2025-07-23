import 'package:flutter/material.dart';

class ExpandableSpeedControl extends StatefulWidget {
  final double speed;
  final Function(double) onSpeedChanged;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableSpeedControl({
    super.key,
    required this.speed,
    required this.onSpeedChanged,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<ExpandableSpeedControl> createState() => _ExpandableSpeedControlState();
}

class _ExpandableSpeedControlState extends State<ExpandableSpeedControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

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
        animation: _expandAnimation,
        builder: (context, child) {
          return Container(
            height: 56,
            width: 56 + (_expandAnimation.value * 200), // Expand by 200 pixels
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
                        opacity: (_expandAnimation.value - 0.5) * 2, // fade in from 0.5 to 1.0
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
                                  activeTrackColor: Colors.white.withOpacity(0.7),
                                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                                  thumbColor: Colors.white,
                                  overlayColor: Colors.white.withOpacity(0.1),
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
          );
        },
      ),
    );
  }
} 