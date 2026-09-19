import 'package:flutter/material.dart';
import 'models.dart';

const hosts = <HostDevice>[
  HostDevice(
    id: 'host-win-01',
    name: 'Workstation',
    platform: HostPlatform.windows,
    online: true,
    location: 'Home office',
    lastSeen: 'Online now',
  ),
  HostDevice(
    id: 'host-linux-02',
    name: 'Build Server',
    platform: HostPlatform.linux,
    online: true,
    location: 'Cloud VM',
    lastSeen: 'Online now',
  ),
  HostDevice(
    id: 'host-mac-03',
    name: 'MacBook Pro',
    platform: HostPlatform.macos,
    online: false,
    location: 'Travel',
    lastSeen: '18 min ago',
  ),
];

const windows = <RemoteWindow>[
  RemoteWindow(
    id: 'win-vscode',
    title: 'Visual Studio Code',
    subtitle: 'kast-client • lib/session',
    type: RemoteWindowType.vscode,
    icon: Icons.code_rounded,
  ),
  RemoteWindow(
    id: 'win-chrome',
    title: 'Chrome',
    subtitle: 'localhost:5173 • Dashboard',
    type: RemoteWindowType.chrome,
    icon: Icons.public_rounded,
  ),
  RemoteWindow(
    id: 'win-figma',
    title: 'Figma',
    subtitle: 'Kast Mobile • Streaming UX',
    type: RemoteWindowType.figma,
    icon: Icons.design_services_rounded,
  ),
];

const terminalWindow = RemoteWindow(
  id: 'term-01',
  title: 'Direct Terminal',
  subtitle: 'Direct session • crisp text mode',
  type: RemoteWindowType.terminal,
  icon: Icons.terminal_rounded,
);

const defaultTelemetry = SessionTelemetry(
  latencyMs: 23,
  fps: 60,
  bitrateMbps: 13.8,
  packetLoss: 0.18,
  codec: 'H.264',
  relay: 'P2P',
);