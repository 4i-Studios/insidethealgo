import "dart:math" as math;
    import "package:flutter/material.dart";

import "../sorting_algo/merge_sort/merge_sort_logic.dart";

    class AnimatedTreeNode extends StatelessWidget {
      final MergeSortLogic logic; // Add logic as a required parameter
      final List<int> array;
      final int level;
      final bool isLeaf;
      final int startIndex;
      final int endIndex;
      final double width;
      final NodeState state;
      final bool isActive;
      final Animation<double>? mergeAnimation;

      const AnimatedTreeNode({
        Key? key,
        required this.logic, // Pass logic here
        required this.array,
        required this.level,
        required this.isLeaf,
        required this.startIndex,
        required this.endIndex,
        required this.width,
        required this.state,
        required this.isActive,
        this.mergeAnimation,
      }) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          width: width,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _getNodeColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getBorderColor(),
              width: isActive ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive ? Colors.black26 : Colors.black12,
                blurRadius: isActive ? 12 : 4,
                offset: Offset(0, isActive ? 6 : 2),
                spreadRadius: isActive ? 2 : 0,
              ),
            ],
          ),
          child: AnimatedScale(
            scale: isActive ? 1.08 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNodeHeader(),
                const SizedBox(height: 8),
                _buildNodeContent(),
                if (state == NodeState.merging && mergeAnimation != null)
                  _buildMergeAnimation(),
              ],
            ),
          ),
        );
      }

      Widget _buildNodeHeader() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _getStateIcon(),
            const SizedBox(width: 6),
            Text(
              '[$startIndex-$endIndex]',
              style: TextStyle(
                fontSize: (12 - (level * 0.5)).clamp(9, 12),
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
            ),
          ],
        );
      }

      Widget _buildNodeContent() {
        return Container(
          constraints: BoxConstraints(maxWidth: width - 24),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            runSpacing: 4,
            children: array.asMap().entries.map((entry) {
              final int index = entry.key;
              final int value = entry.value;
              return _buildAnimatedElement(value, index);
            }).toList(),
          ),
        );
      }

      Widget _buildAnimatedElement(int value, int index) {
        final bool isHighlighted = _isElementHighlighted(value, index);
        final bool isBeingMerged = _isElementBeingMerged(value, index);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: _getElementColor(isHighlighted, isBeingMerged),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getElementBorderColor(isHighlighted, isBeingMerged),
              width: isHighlighted ? 2 : 1,
            ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: (10 - (level * 0.3)).clamp(7, 10),
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
              color: _getElementTextColor(isHighlighted, isBeingMerged),
            ),
            child: Text('$value'),
          ),
        );
      }

      bool _isElementHighlighted(int value, int index) {
        if (mergeAnimation != null && state == NodeState.merging) {
          // Highlight elements currently being compared or moved during merge
          return true;
        }
        return false;
      }

      bool _isElementBeingMerged(int value, int index) {
        return state == NodeState.merging && mergeAnimation != null;
      }

      Color _getElementColor(bool isHighlighted, bool isBeingMerged) {
        if (isHighlighted && isBeingMerged) return Colors.purple.shade100;
        if (isHighlighted) return Colors.blue.shade100;
        if (isBeingMerged) return Colors.orange.shade100;

        switch (state) {
          case NodeState.completed:
            return Colors.green.shade50;
          case NodeState.merging:
            return Colors.purple.shade50;
          case NodeState.dividing:
            return Colors.orange.shade50;
          default:
            return Colors.grey.shade100;
        }
      }

      Color _getElementBorderColor(bool isHighlighted, bool isBeingMerged) {
        if (isHighlighted) return Colors.blue.shade400;
        if (isBeingMerged) return Colors.purple.shade400;
        return Colors.grey.shade300;
      }

      Color _getElementTextColor(bool isHighlighted, bool isBeingMerged) {
        if (isHighlighted) return Colors.blue.shade800;
        if (isBeingMerged) return Colors.purple.shade800;
        return Colors.black87;
      }

      Widget _buildMergeAnimation() {
        return Container(
          margin: const EdgeInsets.only(top: 8),
          height: 40,
          child: AnimatedBuilder(
            animation: mergeAnimation!,
            builder: (context, child) {
              return Column(
                children: [
                  _buildElementComparisonRow(),
                  const SizedBox(height: 4),
                  _buildMergeProgressIndicator(),
                ],
              );
            },
          ),
        );
      }

      Widget _buildElementComparisonRow() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (logic.leftIndex >= 0 && logic.leftIndex < logic.leftArray.length)
              _buildComparisonElement(
                logic.leftArray[logic.leftIndex].value,
                Colors.blue.shade200,
                'L',
              ),
            AnimatedScale(
              scale: 0.8 + (0.4 * math.sin(mergeAnimation!.value * math.pi * 4)),
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.compare_arrows,
                color: Colors.purple.shade600,
                size: 16,
              ),
            ),
            if (logic.rightIndex >= 0 && logic.rightIndex < logic.rightArray.length)
              _buildComparisonElement(
                logic.rightArray[logic.rightIndex].value,
                Colors.orange.shade200,
                'R',
              ),
          ],
        );
      }

      Widget _buildComparisonElement(int value, Color color, String side) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.8), width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                side,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }

      Widget _buildMergeProgressIndicator() {
        return Container(
          width: width * 0.9,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade100, Colors.purple.shade300],
                  ),
                ),
              ),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: mergeAnimation!.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade400, Colors.purple.shade600],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (width * 0.9 - 20) * mergeAnimation!.value,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.shade300,
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      Color _getNodeColor() {
        switch (state) {
          case NodeState.unvisited:
            return Colors.blue.shade100;
          case NodeState.dividing:
            return Colors.orange.shade200;
          case NodeState.merging:
            return Colors.purple.shade200;
          case NodeState.completed:
            return isLeaf ? Colors.green.shade300 : Colors.green.shade200;
          case NodeState.merged:
            return Colors.teal.shade200;
        }
      }

      Color _getBorderColor() {
        if (isActive) return Colors.deepPurple.shade500;
        switch (state) {
          case NodeState.completed:
            return Colors.green.shade600;
          case NodeState.merging:
            return Colors.purple.shade500;
          case NodeState.dividing:
            return Colors.orange.shade500;
          default:
            return Colors.grey.shade400;
        }
      }

      Color _getTextColor() {
        return state == NodeState.completed ? Colors.green.shade800 : Colors.black87;
      }

      Widget _getStateIcon() {
        switch (state) {
          case NodeState.dividing:
            return Icon(Icons.call_split, size: 14, color: Colors.orange.shade700);
          case NodeState.merging:
            return Icon(Icons.merge_type, size: 14, color: Colors.purple.shade700);
          case NodeState.completed:
            return Icon(Icons.check_circle, size: 14, color: Colors.green.shade700);
          case NodeState.merged:
            return Icon(Icons.verified, size: 14, color: Colors.teal.shade700);
          default:
            return Icon(Icons.radio_button_unchecked, size: 14, color: Colors.grey.shade600);
        }
      }
    }

    enum NodeState {
      unvisited,
      dividing,
      merging,
      completed,
      merged,
    }