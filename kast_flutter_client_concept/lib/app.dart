import 'package:flutter/material.dart';
import 'controller.dart';
import 'mock_data.dart';
import 'models.dart';
import 'widgets.dart';

class KastConceptApp extends StatelessWidget {
  const KastConceptApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: kastAccent,
      brightness: Brightness.dark,
      surface: kastSurface,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kast Remote Client Concept',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: scheme,
        scaffoldBackgroundColor: kastBg,
        dividerColor: kastBorder,
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: kastText,
              displayColor: kastText,
            ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kastSurface2,
          hintStyle: const TextStyle(color: kastMuted),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kastBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kastBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kastAccent),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFF0D1118),
          indicatorColor: Color(0x2056E39F),
          height: 68,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      home: const KastShell(),
    );
  }
}

class KastShell extends StatefulWidget {
  const KastShell({super.key});

  @override
  State<KastShell> createState() => _KastShellState();
}

class _KastShellState extends State<KastShell> {
  final controller = KastController();
  int tab = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(_refresh);
  }

  @override
  void dispose() {
    controller
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        controller: controller,
        onSession: () => setState(() => tab = 1),
      ),
      SessionPage(controller: controller),
      TerminalPage(controller: controller),
      SettingsPage(controller: controller),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const _Backdrop(),
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  children: [
                    _TopBar(
                      connected: controller.connected,
                      onHome: () => setState(() => tab = 0),
                    ),
                    Expanded(
                      child: IndexedStack(index: tab, children: pages),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.devices_rounded),
            selectedIcon: Icon(Icons.devices_rounded, color: kastAccent),
            label: 'Devices',
          ),
          NavigationDestination(
            icon: Icon(Icons.cast_outlined),
            selectedIcon: Icon(Icons.cast_rounded, color: kastAccent),
            label: 'Session',
          ),
          NavigationDestination(
            icon: Icon(Icons.terminal_outlined),
            selectedIcon: Icon(Icons.terminal_rounded, color: kastAccent),
            label: 'Terminal',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_rounded),
            selectedIcon: Icon(Icons.tune_rounded, color: kastAccent),
            label: 'Control',
          ),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-.9, -1),
              radius: 1.35,
              colors: [
                Color(0x1856E39F),
                Color(0x00080A0F),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.connected,
    required this.onHome,
  });

  final bool connected;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 13, 18, 7),
      child: Row(
        children: [
          InkWell(
            onTap: onHome,
            borderRadius: BorderRadius.circular(14),
            child: const KastLogo(compact: true),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: connected
                  ? kastAccent.withValues(alpha: .08)
                  : kastSurface2,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: connected
                    ? kastAccent.withValues(alpha: .3)
                    : kastBorder,
              ),
            ),
            child: Row(
              children: [
                StatusDot(online: connected, size: 7),
                const SizedBox(width: 7),
                Text(
                  connected ? 'Encrypted session' : 'Secure idle',
                  style: TextStyle(
                    color: connected ? kastAccent : kastMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.controller,
    required this.onSession,
  });

  final KastController controller;
  final VoidCallback onSession;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 850;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Hero(wide: wide),
              const SizedBox(height: 18),
              if (controller.connected)
                _ResumeCard(
                  controller: controller,
                  onSession: onSession,
                ),
              if (controller.connected) const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your computers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.3,
                      ),
                    ),
                  ),
                  Text(
                    '2 online',
                    style: TextStyle(
                      color: kastAccent.withValues(alpha: .9),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < hosts.length; i++) ...[
                      Expanded(
                        child: HostCard(
                          host: hosts[i],
                          onTap: () => _chooseWindow(context, hosts[i]),
                        ),
                      ),
                      if (i != hosts.length - 1) const SizedBox(width: 11),
                    ],
                  ],
                )
              else
                for (var i = 0; i < hosts.length; i++) ...[
                  HostCard(
                    host: hosts[i],
                    onTap: () => _chooseWindow(context, hosts[i]),
                  ),
                  if (i != hosts.length - 1) const SizedBox(height: 10),
                ],
              const SizedBox(height: 18),
              _SecurityStrip(wide: wide),
            ],
          ),
        );
      },
    );
  }

  void _chooseWindow(BuildContext context, HostDevice host) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0D1118),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 2, 18, 18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Choose a window on ${host.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Kast streams individual windows instead of exposing your whole desktop.',
                  style: TextStyle(color: kastMuted, height: 1.4),
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < windows.length; i++) ...[
                  WindowCard(
                    window: windows[i],
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      await controller.connect(host, windows[i]);
                      onSession();
                    },
                  ),
                  if (i != windows.length - 1) const SizedBox(height: 9),
                ],
                const SizedBox(height: 9),
                WindowCard(
                  window: terminalWindow,
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await controller.connect(host, terminalWindow);
                    onSession();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(wide ? 26 : 21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF121A1D), Color(0xFF0D111A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF234238)),
        boxShadow: [
          BoxShadow(
            color: kastAccent.withValues(alpha: .08),
            blurRadius: 40,
            spreadRadius: -14,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.radar_rounded, color: kastAccent, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'REMOTE WITHOUT COMPROMISE',
                      style: TextStyle(
                        color: kastAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Text(
                  wide
                      ? 'Your workstation,\ninside your pocket.'
                      : 'Your workstation, inside your pocket.',
                  style: TextStyle(
                    fontSize: wide ? 34 : 28,
                    height: 1.02,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.3,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Window-level streaming, direct terminal access and precise touch-to-mouse control in one focused client.',
                  style: TextStyle(
                    color: kastMuted,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 17),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    MetricChip(
                      label: 'Transport',
                      value: 'WebRTC-ready',
                      icon: Icons.hub_rounded,
                    ),
                    MetricChip(
                      label: 'Input',
                      value: 'Touch bridge',
                      icon: Icons.touch_app_rounded,
                      accent: kastBlue,
                    ),
                    MetricChip(
                      label: 'Security',
                      value: 'E2E model',
                      icon: Icons.lock_rounded,
                      accent: kastPurple,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (wide) ...[
            const SizedBox(width: 26),
            const SizedBox(
              width: 170,
              height: 170,
              child: _HeroOrb(),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroOrb extends StatelessWidget {
  const _HeroOrb();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 142,
          height: 142,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                kastAccent.withValues(alpha: .16),
                Colors.transparent,
              ],
            ),
            border: Border.all(color: kastAccent.withValues(alpha: .2)),
          ),
        ),
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kastSurface2,
            border: Border.all(color: kastBorder),
          ),
          child: const Icon(
            Icons.desktop_windows_rounded,
            color: kastAccent,
            size: 36,
          ),
        ),
        const Positioned(
          left: 10,
          bottom: 26,
          child: _OrbitBadge(icon: Icons.phone_iphone_rounded),
        ),
        const Positioned(
          right: 8,
          top: 20,
          child: _OrbitBadge(icon: Icons.tablet_mac_rounded),
        ),
      ],
    );
  }
}

class _OrbitBadge extends StatelessWidget {
  const _OrbitBadge({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 39,
      decoration: BoxDecoration(
        color: const Color(0xFF111820),
        shape: BoxShape.circle,
        border: Border.all(color: kastAccent.withValues(alpha: .25)),
      ),
      child: Icon(icon, size: 17, color: kastAccent),
    );
  }
}
class _ResumeCard extends StatelessWidget {
  const _ResumeCard({
    required this.controller,
    required this.onSession,
  });

  final KastController controller;
  final VoidCallback onSession;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      highlight: true,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: kastAccent.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.cast_connected_rounded, color: kastAccent),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active encrypted session',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.selectedHost?.name ?? 'Host'} • ${controller.selectedWindow?.title ?? 'Window'}',
                  style: const TextStyle(color: kastMuted, fontSize: 11.5),
                ),
              ],
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: onSession,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Resume'),
          ),
        ],
      ),
    );
  }
}

class _SecurityStrip extends StatelessWidget {
  const _SecurityStrip({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.lock_outline_rounded,
        'End-to-end model',
        'Stream content stays device-bound'
      ),
      (
        Icons.visibility_off_outlined,
        'Zero-knowledge relay',
        'Relay path carries encrypted bytes'
      ),
      (
        Icons.history_toggle_off_rounded,
        'No retention',
        'Sessions disappear when they end'
      ),
    ];

    if (!wide) {
      return Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _SecurityItem(
              icon: items[i].$1,
              title: items[i].$2,
              subtitle: items[i].$3,
            ),
            if (i != items.length - 1) const SizedBox(height: 9),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: _SecurityItem(
              icon: items[i].$1,
              title: items[i].$2,
              subtitle: items[i].$3,
            ),
          ),
          if (i != items.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _SecurityItem extends StatelessWidget {
  const _SecurityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 17,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(icon, color: kastAccent, size: 20),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: kastMuted, fontSize: 10.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class SessionPage extends StatelessWidget {
  const SessionPage({super.key, required this.controller});
  final KastController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.phase == ConnectionPhase.idle ||
        controller.phase == ConnectionPhase.ended) {
      return _EmptySession(controller: controller);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 880;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SessionHeader(controller: controller),
              const SizedBox(height: 12),
              SessionTelemetryStrip(telemetry: controller.telemetry),
              const SizedBox(height: 12),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          RemoteDesktopSurface(controller: controller),
                          const SizedBox(height: 10),
                          ModifierBar(controller: controller),
                        ],
                      ),
                    ),
                    const SizedBox(width: 13),
                    SizedBox(
                      width: 290,
                      child: _SessionSidebar(controller: controller),
                    ),
                  ],
                )
              else ...[
                RemoteDesktopSurface(controller: controller),
                const SizedBox(height: 10),
                ModifierBar(controller: controller),
                const SizedBox(height: 12),
                _SessionSidebar(controller: controller),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({required this.controller});
  final KastController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.selectedWindow?.title ?? 'Remote session',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${controller.selectedHost?.name ?? 'Host'} • ${controller.telemetry.relay} path',
                style: const TextStyle(color: kastMuted, fontSize: 11.5),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Reconnect',
          onPressed: controller.reconnect,
          icon: const Icon(Icons.refresh_rounded),
        ),
        const SizedBox(width: 7),
        IconButton.filled(
          tooltip: 'End session',
          style: IconButton.styleFrom(backgroundColor: kastRed),
          onPressed: controller.endSession,
          icon: const Icon(Icons.call_end_rounded),
        ),
      ],
    );
  }
}

class _SessionSidebar extends StatelessWidget {
  const _SessionSidebar({required this.controller});
  final KastController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Adaptive quality',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
              const SizedBox(height: 5),
              const Text(
                'Transport settings are represented as a client-side UX prototype.',
                style: TextStyle(color: kastMuted, fontSize: 10.5, height: 1.4),
              ),
              const SizedBox(height: 13),
              for (final value in StreamQuality.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: _QualityOption(
                    value: value,
                    selected: controller.quality == value,
                    onTap: () => controller.setQuality(value),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 11),
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Connection health',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                  ),
                  Text(
                    '${controller.telemetry.latencyMs} ms',
                    style: const TextStyle(
                      color: kastAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 70,
                child: LatencyGraph(value: controller.telemetry.latencyMs),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Codec', style: TextStyle(color: kastMuted, fontSize: 10.5)),
                  const Spacer(),
                  Text(controller.telemetry.codec, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Text('Route', style: TextStyle(color: kastMuted, fontSize: 10.5)),
                  const Spacer(),
                  Text(controller.telemetry.relay, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QualityOption extends StatelessWidget {
  const _QualityOption({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final StreamQuality value;
  final bool selected;
  final VoidCallback onTap;

  String get label => switch (value) {
        StreamQuality.auto => 'Auto adaptive',
        StreamQuality.hd720 => '720p efficient',
        StreamQuality.fullHd1080 => '1080p balanced',
        StreamQuality.ultra4k => '4K quality',
      };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? kastAccent.withValues(alpha: .08) : kastSurface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? kastAccent.withValues(alpha: .4) : kastBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              size: 17,
              color: selected ? kastAccent : kastMuted,
            ),
            const SizedBox(width: 9),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: selected ? kastText : kastMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _EmptySession extends StatelessWidget {
  const _EmptySession({required this.controller});
  final KastController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 110),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: GlassPanel(
            padding: const EdgeInsets.all(26),
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: kastAccent.withValues(alpha: .08),
                    shape: BoxShape.circle,
                    border: Border.all(color: kastAccent.withValues(alpha: .22)),
                  ),
                  child: const Icon(Icons.cast_rounded, color: kastAccent, size: 30),
                ),
                const SizedBox(height: 18),
                Text(
                  controller.phase == ConnectionPhase.ended
                      ? 'Session ended securely'
                      : 'No active stream',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose an online host and an application window from Devices. The prototype will simulate negotiation and expose the interaction layer.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kastMuted, height: 1.45),
                ),
                if (controller.phase == ConnectionPhase.ended) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: controller.reset,
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: const Text('Clear session'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key, required this.controller});