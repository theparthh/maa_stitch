---
name: flutter-shimmer
description: Use when implementing loading states in Flutter apps that need skeleton screens, placeholder animations, or smooth transitions from loading to loaded content
---

# Flutter Shimmer Loading Skill

## Overview

Shimmer loading is a skeleton screen pattern that shows animated placeholder content while data loads. The shimmer effect mimics content structure with a sweeping light animation that improves perceived performance and reduces cognitive load during wait times.

## When to Use

**Apply shimmer when:**
- Network requests take >200ms to complete
- List views load paginated or lazy-loaded content
- Cards, profiles, or detail screens fetch data asynchronously
- Content might load in unpredictable order

**Do NOT use shimmer when:**
- Operations complete <100ms (flash of shimmer then content)
- Content is already cached locally
- User triggered action that implies immediate feedback (button press)

## Core Pattern

### Minimal Shimmer Implementation

```dart
import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: widget.isLoading
          ? _ShimmerPlaceholder(animation: _animation)
          : widget.child,
    );
  }
}

class _ShimmerPlaceholder extends StatelessWidget {
  final Animation<double> animation;

  const _ShimmerPlaceholder({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFE0E0E0),
                Color(0xFFF5F5F5),
                Color(0xFFE0E0E0),
              ],
              stops: [
                animation.value - 0.3,
                animation.value,
                animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}
```

### Production-Ready Shimmer Widgets

```dart
/// Base shimmer container that mimics widget shape
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Shimmer text lines with varying widths
class ShimmerText extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double spacing;

  const ShimmerText({
    super.key,
    this.lines = 1,
    this.lineHeight = 14,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
          child: ShimmerBox(
            height: lineHeight,
            width: isLast ? 150 : double.infinity,
          ),
        );
      }),
    );
  }
}

/// Shimmer avatar (circle)
class ShimmerAvatar extends StatelessWidget {
  final double size;

  const ShimmerAvatar({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Shimmer image placeholder
class ShimmerImage extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerImage({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}
```

### Shimmer List Item (Common Pattern)

```dart
class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerAvatar(size: 56),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerText(lines: 2, lineHeight: 16, spacing: 8),
                SizedBox(height: 8),
                ShimmerText(lines: 1, lineHeight: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Shimmer Card (Detail Screen)

```dart
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerImage(height: 180, borderRadius: 8),
            SizedBox(height: 16),
            ShimmerText(lines: 2, lineHeight: 20, spacing: 10),
            SizedBox(height: 12),
            ShimmerText(lines: 3, lineHeight: 14, spacing: 6),
            SizedBox(height: 16),
            Row(
              children: [
                ShimmerAvatar(size: 32),
                SizedBox(width: 8),
                ShimmerBox(width: 100, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Animated Shimmer Effect

```dart
class AnimatedShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;

  const AnimatedShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  State<AnimatedShimmer> createState() => _AnimatedShimmerState();
}

class _AnimatedShimmerState extends State<AnimatedShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
```

## Quick Reference

| Widget | Purpose | Key Props |
|--------|---------|-----------|
| `ShimmerBox` | Generic rectangular placeholder | `width`, `height`, `borderRadius` |
| `ShimmerText` | Text lines placeholder | `lines`, `lineHeight`, `spacing` |
| `ShimmerAvatar` | Circular avatar placeholder | `size` |
| `ShimmerImage` | Image/card header placeholder | `width`, `height`, `borderRadius` |
| `AnimatedShimmer` | Wraps any widget with shimmer effect | `child`, `duration`, `colors` |

## Common Mistakes

**Mistake: Using shimmer for fast operations**
- Operations <100ms show a flash of shimmer then content
- Use inline loading spinners instead

**Mistake: Wrong animation duration**
- Too fast (<800ms): jarring effect
- Too slow (>2000ms): distracting, delays content perception
- Target: 1200-1800ms for optimal smoothness

**Mistake: Generic placeholder sizes**
- Match actual content proportions
- Avatar shimmer should be same size as real avatar
- Text line heights should match real text

**Mistake: No layout stability**
- Shimmer skeleton must occupy same space as real content
- Use fixed dimensions, not wrap_content
- Prevents layout shift when content loads

**Mistake: Animation jank**
- Always use `const` constructors where possible
- Avoid rebuilding parent widgets during animation
- Use `RepaintBoundary` for complex shimmer sections

## Transition Handling

```dart
class ShimmerSwitcher extends StatelessWidget {
  final bool isLoading;
  final Widget loadingWidget;
  final Widget child;

  const ShimmerSwitcher({
    super.key,
    required this.isLoading,
    required this.loadingWidget,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      },
      child: isLoading
          ? KeyedSubtree(key: const ValueKey('loading'), child: loadingWidget)
          : KeyedSubtree(key: const ValueKey('content'), child: child),
    );
  }
}
```

## Performance Tips

1. **Use `RepaintBoundary`** - Isolate shimmer repaints from main widget tree
2. **Avoid animations on large areas** - Shimmer large images separately from text
3. **Cache gradient positions** - Don't recalculate on every frame
4. **Consider `const` widgets** - Pre-build static parts of shimmer skeletons
5. **ListView.builder for lists** - Don't create all shimmer items at once

## Real-World Impact

- **Perceived performance**: Users see structure immediately, reducing perceived load time by 300-500ms
- **Reduced abandonment**: Apps with shimmer loading have 15-20% lower bounce rates
- **Better UX**: Animated shimmer maintains user attention during waits up to 3 seconds
