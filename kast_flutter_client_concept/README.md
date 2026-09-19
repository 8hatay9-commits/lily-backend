# Kast Remote Client Concept

A focused Flutter interaction prototype built around the public Kast product and the Flutter Developer role.

## Why this exists

Kast's product combines window-level remote streaming, touch-to-mouse translation, direct terminal access, adaptive quality, port forwarding and a security-first device model. This prototype explores how those capabilities can feel inside a compact iOS/Android/desktop Flutter client.

## Working flows

- Host device list with online/offline state
- Per-window selection instead of whole-desktop selection
- Session negotiation state and reconnect/end controls
- Live-changing latency, FPS, bitrate, packet-loss and route telemetry
- Adaptive-quality selection with codec/state feedback
- Touch cursor placement, pinch zoom and trackpad-style pointer mode
- Modifier-key bar for CTRL / ALT / SHIFT / META
- Direct-terminal interaction demo with keyboard input
- Port-forwarding controls
- Device/security model surfaces
- Responsive layouts for phone and desktop widths

## Verification

- Dart analyzer: **No issues found**
- Flutter widget tests: **4/4 passed**
- Responsive tests: **390x844 mobile** and **1200x900 desktop**
- Tested end-to-end prototype path: device -> window picker -> session
- Tested terminal command interaction

## Important scope note

This is an interaction and client-state prototype. The media canvas and network telemetry are simulated so the demo does not claim a production WebRTC transport, live capture daemon, signaling service, TURN infrastructure, or encryption implementation that is not present.

The intent is to demonstrate product thinking, Flutter UI engineering, responsive behavior, interaction design, state transitions and a clear boundary where a real WebRTC transport layer would plug in.

## Stack

Flutter / Dart / Material 3 / ChangeNotifier state model / CustomPainter / Widget Testing

Built specifically as a relevant work sample for Kast.