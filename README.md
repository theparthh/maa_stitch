# Maa Design Stitch Viewer

A lightweight, 100% offline Android & cross-platform Flutter application built to parse and visually display embroidery design files (`.dst`, `.emb`, `.dhp`).

## Features

- **Android Intent Handler:** Opens `.dst`, `.emb`, and `.dhp` files directly from file managers, WhatsApp, Gmail, or email attachments.
- **Interactive Stitch Canvas:** High-resolution rendering engine using `InteractiveViewer` with smooth pan, pinch-zoom, and double-tap zoom reset.
- **Stitch Playback Simulation:** Trace stitch paths step-by-step with play/pause and 1x, 2x, 5x, 10x speed multipliers.
- **Layer & View Toggles:** Filter specific thread color layers, toggle grid overlay, jump needle lines, and individual stitch points.
- **Design Analytics:** Detailed breakdown of total stitches, color changes, estimated thread consumption, jump counts, and mm/cm dimensions.
- **100% Offline:** Zero network requests, zero backend dependency.

## App Palette
- **Primary Color:** `#0d295f` (Navy/Deep Indigo)
- **Secondary Color:** `#4FAC5C` (Stitch Emerald Green)
- **Standard Tokens:** Blue, White, Red, Black, Green, Grey, Transparent

## Architecture & Dependencies
- **State Management:** `flutter_bloc` with explicit sealed events/states.
- **Routing:** `auto_route` (`@RoutePage()`, `AppRouteHandler.route`).
- **Dependency Injection:** `get_it` (`lib/app/di/`).
- **Clean Architecture:** `lib/features/<feature>/` (`data/`, `domain/`, `presentation/`).

## Feature Documentation
- [Splash Feature](file:///Users/theparth/Desktop/maa_design_stitch_viewer/lib/features/splash/README.md)
- [Home Feature](file:///Users/theparth/Desktop/maa_design_stitch_viewer/lib/features/home/README.md)
- [Viewer Feature](file:///Users/theparth/Desktop/maa_design_stitch_viewer/lib/features/viewer/README.md)
