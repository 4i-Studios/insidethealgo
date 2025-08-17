## Sorting-algorithm 3-file template (Page / Controller / View)

This short template explains a minimal, easy-to-follow structure you can copy for each sorting algorithm visualizer.
Keep it lightweight — don't over-engineer. The pattern works well when algorithms have different animations and UI needs.

High-level idea
- Page: thin wiring layer (scaffolding, input fields, FABs, SnackBars). No animation controllers, no algorithm internals.
- Controller: a `ChangeNotifier` (or other simple state holder) that owns the algorithm's state and logic (numbers, indices, flags, totals, control methods). UI-agnostic.
- View: a `StatefulWidget` that owns `AnimationController`s and renders the animated visuals. It listens to the controller and animates in response to state changes.

Why this split?
- Keeps animation code where it belongs (View) so each algorithm can implement custom animations.
- Keeps algorithm logic testable and UI-agnostic (Controller).
- Keeps pages simple to read and maintain (Page).

Folder / file convention
lib/sorting_algo/<algorithm>/
- <algorithm>_page.dart  — scaffold, TextField, FAB, navigation.
- <algorithm>_controller.dart — ChangeNotifier class: public API + state.
- <algorithm>_view.dart — StatefulWidget that renders bars and code and owns AnimationControllers.

Controller contract (recommended minimal API)
- Properties (read-only for UI):
  - `List<int> numbers`
  - `bool isSorting, isPaused, isSwapping, isSorted`
  - `int comparingIndex1, comparingIndex2, currentI, currentJ`
  - `int totalComparisons, totalSwaps`
  - `double speed`
  - `String currentStep, operationIndicator`
- Methods (mutating; call notifyListeners internally):
  - `bool setArrayFromInput(String csv)` — parse input, return success
  - `Future<void> start()`
  - `void stop()`
  - `void reset()`
  - `void shuffle()`
  - `void updateSpeed(double)`
  - `void togglePause()`
  - `void toggleSortOrder()`

Notes:
- Controller should never import `package:flutter/material.dart` or call `ScaffoldMessenger` — pages do that.
- Controller should call `notifyListeners()` whenever state changes. UI (Page/View) should not call `notifyListeners()` on the controller.

View responsibilities
- Own `AnimationController`s and any animation timing.
- Subscribe to controller via `controller.addListener(...)` and call `setState` to rebuild animated widgets when state changes.
- Translate controller state into animations (for example, when `isSwapping` becomes true, start a swap animation; when animation completes, allow controller to perform the array mutation or vice-versa depending on contract).

Page responsibilities
- Create and dispose the controller (or obtain it via provider if you prefer global state).
- Provide TextFields, Buttons, and SnackBars. Call controller API methods; show errors using `controller.lastErrorMessage`.
- Host the `ExpandableActionFab` or other controls. Avoid placing widgets that use `Positioned` inside non-Stack parents (see pitfalls).

Minimal code examples

Controller skeleton (lib/sorting_algo/xxx/xxx_controller.dart)
```dart
import 'package:flutter/foundation.dart';

class XxxController extends ChangeNotifier {
  List<int> numbers = [5,3,8,1];
  bool isSorting = false;
  bool isPaused = false;
  int comparingIndex1 = -1;
  int comparingIndex2 = -1;
  double speed = 1.0;

  bool setArrayFromInput(String csv) {
    // parse, set numbers, validate
    notifyListeners();
    return true;
  }

  Future<void> start() async {
    if (isSorting) return;
    isSorting = true;
    notifyListeners();
    // algorithm loop: set indices, call notifyListeners(), await delays and pause checks
    isSorting = false;
    notifyListeners();
  }

  void togglePause() {
    if (!isSorting) return;
    isPaused = !isPaused;
    notifyListeners();
  }
}
```

View skeleton (lib/sorting_algo/xxx/xxx_view.dart)
```dart
import 'package:flutter/material.dart';
import 'xxx_controller.dart';

class XxxView extends StatefulWidget {
  final XxxController controller;
  const XxxView({Key? key, required this.controller}) : super(key: key);
  @override
  State<XxxView> createState() => _XxxViewState();
}

class _XxxViewState extends State<XxxView> with SingleTickerProviderStateMixin {
  late AnimationController anim;
  @override
  void initState() {
    super.initState();
    anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    widget.controller.addListener(_onController);
  }

  void _onController() {
    // start animations when controller flags change
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onController);
    anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Column(children: [/* bars, animated using anim and c.* */]);
  }
}
```

Page skeleton (lib/sorting_algo/xxx/xxx_page.dart)
```dart
import 'package:flutter/material.dart';
import 'xxx_controller.dart';
import 'xxx_view.dart';

class XxxPage extends StatefulWidget { /* ... */ }

class _XxxPageState extends State<XxxPage> {
  late final XxxController controller;
  final TextEditingController inputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = XxxController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xxx Sort')),
      body: Column(children: [
        // input row
        Expanded(child: XxxView(controller: controller)),
      ]),
      floatingActionButton: /* your FAB */,
    );
  }
}
```

Migration steps (split an existing page into 3 files)
1. Create `<algo>_controller.dart`. Move all algorithm state variables and logic loops into methods on the controller. Replace any direct UI calls (ScaffoldMessenger, context use) with returning error strings or setting `lastErrorMessage` on the controller.
2. Create `<algo>_view.dart`. Move widget code that owns `AnimationController`s here. Make it accept the controller and listen to it. The view must not mutate algorithm internals except by calling controller methods.
3. Edit `<algo>_page.dart`. Keep scaffold, text input, FAB, and instantiate the controller. Embed the view and call controller methods from buttons.

Common pitfalls
- Incorrect use of ParentDataWidget (Positioned / Stack):
  - The `Positioned` widget can only be used inside a `Stack`. If you build a FAB or custom action widget that returns `Positioned` at its root, it will crash when placed inside `Scaffold.floatingActionButton` or any non-Stack parent.
  - Fix: Have the FAB widget return a non-Positioned widget (for example, a `SizedBox` or `Column`) and let the parent place it, or ensure you use your `Positioned` only inside a `Stack` that you control.

- RenderFlex overflow in wide layout:
  - Use `Expanded`, `Flexible`, or constrain the width of side panels (e.g. `SizedBox(width: 420)`) and use `LayoutBuilder` to switch to side-by-side only on sufficiently wide screens.

- Calling `notifyListeners()` incorrectly:
  - Only controller methods should call `notifyListeners()`. Do not call it from the page or view.

Edge cases / when an algorithm needs extra UI
- If an algorithm requires multiple animations, create multiple `AnimationController`s inside the View; keep names clear (swapController, highlightController).
- If the controller needs to request an animation to complete before mutating the array (or vice versa), define a small contract:
  - Option A (Controller-driven): controller sets `isSwapping=true`, calls `notifyListeners()`, awaits a fixed delay, then performs swap and sets `isSwapping=false`.
  - Option B (View-driven callback): controller exposes a `Future<void> onAnimateSwap(int i, int j)` callback field that the page/view sets; controller awaits that future before committing the swap. Use this only when precise sync is required.

Checklist you can follow when creating a new algorithm page from the template
1. Copy the three-file folder structure.
2. Implement the controller API and simple algorithm loop without animation details.
3. Implement the view: add AnimationControllers and wire them to controller flags.
4. Implement the page: inputs, FAB, error SnackBars. Test the controller and view together.

If you want, I can:
- Split the current `bubble_sort_page.dart` into controller/view/page automatically using this template.
- Or provide a minimal working reference implementation (small runnable example) for one sort.

---
Place this file in `lib/sorting_algo/` and copy the pattern into each algorithm folder.
