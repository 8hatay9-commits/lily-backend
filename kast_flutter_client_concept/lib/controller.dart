import 'dart:async';
import 'package:flutter/foundation.dart';
import 'models.dart';
import 'mock_data.dart';

class KastController extends ChangeNotifier {
  HostDevice? selectedHost;
  RemoteWindow? selectedWindow;
  ConnectionPhase phase = ConnectionPhase.idle;
  StreamQuality quality = StreamQuality.auto;
  SessionTelemetry telemetry = defaultTelemetry;
  bool keyboardVisible = false;
  bool ctrl = false;
  bool alt = false;
  bool shift = false;
  bool meta = false;
  bool pointerLocked = false;
  double zoom = 1;
  String cursorHint = 'Tap to click • pinch to zoom';
  int _tick = 0;
  Timer? _timer;

  List<PortForwardRule> ports = const [
    PortForwardRule(localPort: 3000, label: 'Frontend dev server', enabled: true),
    PortForwardRule(localPort: 8000, label: 'API service', enabled: false),
    PortForwardRule(localPort: 5432, label: 'Postgres', enabled: false),
  ];

  bool get connected => phase == ConnectionPhase.connected;

  Future<void> connect(HostDevice host, RemoteWindow window) async {
    selectedHost = host;
    selectedWindow = window;
    phase = ConnectionPhase.negotiating;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!host.online) {
      phase = ConnectionPhase.idle;
      notifyListeners();
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 650));
    phase = ConnectionPhase.connected;
    _startTelemetry();
    notifyListeners();
  }

  Future<void> reconnect() async {
    if (selectedHost == null || selectedWindow == null) return;
    phase = ConnectionPhase.reconnecting;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 850));
    phase = ConnectionPhase.connected;
    notifyListeners();
  }

  void endSession() {
    _timer?.cancel();
    phase = ConnectionPhase.ended;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    selectedHost = null;
    selectedWindow = null;
    phase = ConnectionPhase.idle;
    telemetry = defaultTelemetry;
    keyboardVisible = false;
    zoom = 1;
    notifyListeners();
  }

  void setQuality(StreamQuality value) {
    quality = value;
    notifyListeners();
  }

  void toggleKeyboard() {
    keyboardVisible = !keyboardVisible;
    notifyListeners();
  }

  void toggleModifier(String key) {
    if (key == 'ctrl') {
      ctrl = !ctrl;
    } else if (key == 'alt') {
      alt = !alt;
    } else if (key == 'shift') {
      shift = !shift;
    } else if (key == 'meta') {
      meta = !meta;
    }
    notifyListeners();
  }

  void togglePointerLock() {
    pointerLocked = !pointerLocked;
    cursorHint = pointerLocked
        ? 'Trackpad mode • drag to move cursor'
        : 'Tap to click • pinch to zoom';
    notifyListeners();
  }

  void setZoom(double value) {
    zoom = value.clamp(1.0, 2.4);
    notifyListeners();
  }

  void togglePort(int index) {
    ports = [
      for (var i = 0; i < ports.length; i++)
        if (i == index)
          ports[i].copyWith(enabled: !ports[i].enabled)
        else
          ports[i],
    ];
    notifyListeners();
  }

  void _startTelemetry() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      _tick++;
      final latencyPattern = [23, 21, 25, 19, 22, 20, 24, 21];
      final fpsPattern = [60, 60, 59, 60, 58, 60, 60, 59];
      final bitratePattern = [13.8, 14.2, 13.1, 15.0, 14.5, 13.9, 14.7, 14.1];
      final lossPattern = [0.18, 0.10, 0.22, 0.08, 0.15, 0.11, 0.19, 0.09];
      final i = _tick % latencyPattern.length;
      telemetry = SessionTelemetry(
        latencyMs: latencyPattern[i],
        fps: fpsPattern[i],
        bitrateMbps: bitratePattern[i],
        packetLoss: lossPattern[i],
        codec: quality == StreamQuality.ultra4k ? 'AV1' : 'H.264',
        relay: i == 4 ? 'TURN' : 'P2P',
      );
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}