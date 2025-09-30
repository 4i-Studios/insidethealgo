# InsideTheAlgo · Interactive Algorithm Visualizer

InsideTheAlgo is a Flutter application that helps students and curious builders *see* how classic sorting and searching algorithms behave. The app ships with interactive controls, real-time metrics, animated code walkthroughs, and reusable widgets so you can extend the catalog with your own visualizations.

<p align="center">
	<img src="assets/images/ita_logo.png" alt="InsideTheAlgo logo" width="140" />
</p>

---

## Quick links

- [✨ Features](#-features)
- [🧠 Algorithms included](#-algorithms-included)
- [🧱 Architecture at a glance](#-architecture-at-a-glance)
- [🚀 Getting started](#-getting-started)
- [🕹️ Using the simulator](#️-using-the-simulator)
- [✅ Quality checks](#-quality-checks)
- [🛠️ Troubleshooting & known gaps](#️-troubleshooting--known-gaps)
- [🤝 Contributing](#-contributing)
- [🗺️ Roadmap ideas](#️-roadmap-ideas)

---

## ✨ Features

- **Interactive visualizations** for bubble sort (classic and optimized), insertion sort, selection sort, merge sort, linear search, and binary search.
- **LIVE code tracing** via the shared `CodeDisplay` widget that highlights the line currently executing.
- **Metrics, legends, and status banners** that surface comparisons, swaps, steps, and the algorithm’s current decision.
- **Expandable speed & action controls**: pause/resume, stop, shuffle, reset, and toggle sort order are grouped in the `ExpandableActionFab` with a smooth slider.
- **Custom inputs**: enter your own arrays or target values before running a simulation.
- **Guide overlays** (e.g., Binary Search Guide) to explain prerequisites and terminology.
- **Portrait-first experience**: the app locks to portrait on mobile for stable layouts, while remaining responsive on desktop/web.

## 🧠 Algorithms included

| Category | Screen | Highlights |
| --- | --- | --- |
| Bubble Sort | `BubbleSortPage` | Animated bubble swap transitions, color legend, metrics panel, ascending/descending mode |
| Modified Bubble Sort | `ModifiedBubbleSortPage` | Early termination optimization with the same visual treatment |
| Selection Sort | `SelectionSortPage` | Highlights minimum selection and sorted segments |
| Insertion Sort | `InsertionSortPage` | Shows insertion pointer progress and sorted prefix |
| Merge Sort | `MergeSortPage` | Visualizes divide-and-conquer merging steps |
| Linear Search | `LinearSearchPage` | Sequential comparison feedback with step counter |
| Binary Search | `BinarySearchPage` | Midpoint focus, discarded ranges, and animated search window |

Adding a new algorithm only requires wiring the logic/controller pair and passing your widgets into `AlgorithmLayout`.

## 🧱 Architecture at a glance

```
lib/
├── main.dart                # Entry point, portrait lock, MaterialApp setup
├── algorithm_list_page.dart # Category filter & navigation to algorithm demos
├── sorting_algo/            # Sorting algorithm logic/widget pairs
│   ├── bubble_sort/
│   ├── insertion_sort/
│   ├── merge_sort/
│   ├── mod_bubble_sort/
│   └── selection_sort/
├── searching_algo/          # Searching algorithm logic/widget pairs
│   ├── binary_search/
│   └── linear_search/
└── widgets/                 # Reusable UI pieces (layout, code display, FAB, etc.)
```

Most algorithm screens follow the same pattern:

1. **Logic class** (`*_logic.dart`) encapsulates algorithm state, timers, animations, and exposes callbacks.
2. **Widgets helper** (`*_widgets.dart`) builds input areas, visualization canvases, metrics, and code panes.
3. **Page** (`*_page.dart`) composes everything using `AlgorithmLayout` and the shared controls.

## 🚀 Getting started

### Prerequisites

- Flutter SDK **3.24+** with Dart **3.8** (matches `environment.sdk` in `pubspec.yaml`).
- Android Studio / Xcode for native builds, or Chrome for web previews.
- An emulator or physical device. The app is portrait-only on mobile by design.

### Install dependencies & run

```bash
flutter pub get
flutter run
```

You can target Android, iOS, macOS, Windows, Linux, or the web. Running on mobile gives the smoothest animation experience.

### Optional tooling

- Update adaptive icons with `flutter pub run flutter_launcher_icons` (already configured in `pubspec.yaml`).
- If you add assets, register them in the `flutter.assets` section of `pubspec.yaml`.

## 🕹️ Using the simulator

Each algorithm view shares a consistent UX:

- **Input strip**: enter custom arrays or targets and tap **Set**. Fields disable during an active run.
- **Animation canvas**: animated bars, bubbles, or cards visualize comparisons, swaps, and focus ranges.
- **Status & metrics**: banners and metric chips outline the current operation, counts, and sorted segments.
- **Code panel**: highlights each line as it executes so learners can connect visuals to pseudocode.
- **Floating controls**: tap the FAB to expand the action rail (Start/Pause, Stop, Reset, Shuffle/Sort, speed slider). Some algorithms add extra toggles such as ascending/descending order.
- **Guides**: binary search exposes a helper dialog explaining why sorting is required before running.

Tip: supply shorter arrays (5‑10 items) when demoing on smaller screens to keep the visualization readable.

## ✅ Quality checks

- `flutter analyze` — static analysis with `flutter_lints`. Currently flags several legacy styling APIs (e.g., `withOpacity`) awaiting cleanup.
- `flutter test` — widget tests. The default sample test references an older `InsideTheAlgoApp` widget and will fail until the suite is updated to the current `BubbleSortApp` entry point.

Update the README if you change these commands or their expected results.

## 🛠️ Troubleshooting & known gaps

- **Analyzer warnings**: focus on migrating deprecated Material color APIs and tightening lint coverage.
- **Widget test failure**: `test/widget_test.dart` expects a modern home screen that is no longer present. Refresh the test to match the current UI (Algorithm list scaffold) or reintroduce the themed landing page.
- **Runtime stability**: prior UI overhauls introduced crashes. Keep animations lightweight on older devices and throttle speed multipliers if you add new ones.
- **CI/CD**: there is no automation yet. Add GitHub Actions or Codemagic to run analyzer/tests on pull requests.

## 🤝 Contributing

1. Fork the repository and create a feature branch.
2. Run `flutter pub get` and ensure analyzer/tests pass (or document known failures).
3. Add or update unit/widget tests when changing behavior.
4. Open a pull request summarizing the algorithm or UI improvement.

Please keep new widgets modular so they can be reused across algorithm pages.

## 🗺️ Roadmap ideas

- Reinstate a modern home experience with hero sections and curated cards.
- Add more algorithms (quick sort, heap sort, BFS/DFS) with reusable visualization primitives.
- Improve accessibility: larger tap targets, announce status updates, add high-contrast theme.
- Export run history or stepped explanations as shareable lessons.

---

### Reference docs

- [Flutter Documentation](https://docs.flutter.dev/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Widget Catalog](https://docs.flutter.dev/ui/widgets)

> Have ideas or spot a bug? Open an issue and include screenshots or analyzer output so others can reproduce quickly.
