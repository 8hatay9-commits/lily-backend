import 'dart:async';

class AnythinkConfig {
  const AnythinkConfig({
    required this.baseUrl,
    required this.apiKey,
  });

  final String baseUrl;
  final String apiKey;
}

class AnythinkSession {
  const AnythinkSession({
    required this.userId,
    required this.email,
    required this.accessToken,
  });

  final String userId;
  final String email;
  final String accessToken;
}

class AnythinkFile {
  const AnythinkFile({
    required this.name,
    required this.sizeBytes,
    required this.url,
  });
  final String name;
  final int sizeBytes;
  final String url;
}

class AnythinkClient {
  AnythinkClient(this.config)
      : auth = AnythinkAuth(),
        storage = AnythinkStorage(),
        rest = AnythinkRest();

  final AnythinkConfig config;
  final AnythinkAuth auth;
  final AnythinkStorage storage;
  final AnythinkRest rest;
}

class AnythinkAuth {
  AnythinkSession? _session;

  AnythinkSession? get session => _session;

  Future<AnythinkSession> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (email.trim().isEmpty || password.length < 4) {
      throw StateError('Enter a valid email and password.');
    }
    _session = AnythinkSession(
      userId: 'usr_demo_1024',
      email: email.trim(),
      accessToken: 'demo_token_••••••••',
    );
    return _session!;
  }

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    _session = null;
  }
}

class AnythinkStorage {
  final List<AnythinkFile> _files = <AnythinkFile>[
    const AnythinkFile(
      name: 'avatar.png',
      sizeBytes: 184320,
      url: 'https://cdn.example.dev/avatar.png',
    ),
  ];

  List<AnythinkFile> get files => List.unmodifiable(_files);

  Future<AnythinkFile> uploadDemoFile() async {
    await Future<void>.delayed(const Duration(milliseconds: 520));
    final name = 'brief-${_files.length + 1}.pdf';
    final file = AnythinkFile(
      name: name,
      sizeBytes: 348160,
      url: 'https://cdn.example.dev/$name',
    );
    _files.add(file);
    return file;
  }
}

class AnythinkRest {
  Future<Map<String, Object>> getHealth() async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return <String, Object>{
      'status': 'ok',
      'region': 'edge-eu-1',
      'latency_ms': 42,
    };
  }

  Future<List<Map<String, Object>>> listProjects() async {
    await Future<void>.delayed(const Duration(milliseconds: 430));
    return <Map<String, Object>>[
      <String, Object>{
        'id': 'prj_01',
        'name': 'Mobile launch',
        'environment': 'production',
      },
      <String, Object>{
        'id': 'prj_02',
        'name': 'SDK playground',
        'environment': 'sandbox',
      },
    ];
  }
}