import 'package:flutter/material.dart';

enum HostPlatform { windows, macos, linux }
enum ConnectionPhase { idle, negotiating, connected, reconnecting, ended }
enum StreamQuality { auto, hd720, fullHd1080, ultra4k }
enum RemoteWindowType { vscode, chrome, terminal, figma }

class HostDevice {
  const HostDevice({
    required this.id,
    required this.name,
    required this.platform,
    required this.online,
    required this.location,
    required this.lastSeen,
  });

  final String id;
  final String name;
  final HostPlatform platform;
  final bool online;
  final String location;
  final String lastSeen;

  IconData get icon => switch (platform) {
        HostPlatform.windows => Icons.window_rounded,
        HostPlatform.macos => Icons.laptop_mac_rounded,
        HostPlatform.linux => Icons.terminal_rounded,
      };
}

class RemoteWindow {
  const RemoteWindow({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final RemoteWindowType type;
  final IconData icon;
}

class SessionTelemetry {
  const SessionTelemetry({
    required this.latencyMs,
    required this.fps,
    required this.bitrateMbps,
    required this.packetLoss,
    required this.codec,
    required this.relay,
  });

  final int latencyMs;
  final int fps;
  final double bitrateMbps;
  final double packetLoss;
  final String codec;
  final String relay;
}

class PortForwardRule {
  const PortForwardRule({
    required this.localPort,
    required this.label,
    required this.enabled,
  });

  final int localPort;
  final String label;
  final bool enabled;

  PortForwardRule copyWith({bool? enabled}) => PortForwardRule(
        localPort: localPort,
        label: label,
        enabled: enabled ?? this.enabled,
      );
}