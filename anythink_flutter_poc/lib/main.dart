import 'package:flutter/material.dart';
import 'anythink_client.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6657E8);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anythink SDK Playground',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      ),
      home: const PlaygroundPage(),
    );
  }
}

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}
class _PlaygroundPageState extends State<PlaygroundPage> {
  final client = AnythinkClient(
    const AnythinkConfig(
      baseUrl: 'https://api.anythink.cloud',
      apiKey: 'sandbox_demo_key',
    ),
  );
  final email = TextEditingController(text: 'mobile@demo.dev');
  final password = TextEditingController(text: 'demo1234');

  bool busyAuth = false;
  bool busyUpload = false;
  bool busyApi = false;
  Map<String, Object>? health;
  String notice = 'Sandbox client initialized';

  Future<void> signIn() async {
    setState(() => busyAuth = true);
    try {
      final session = await client.auth.signIn(
        email: email.text,
        password: password.text,
      );
      setState(() => notice = 'Authenticated as ${session.email}');
    } catch (e) {
      setState(() => notice = e.toString());
    } finally {
      setState(() => busyAuth = false);
    }
  }

  Future<void> upload() async {
    setState(() => busyUpload = true);
    final file = await client.storage.uploadDemoFile();
    setState(() {
      busyUpload = false;
      notice = 'Uploaded ${file.name}';
    });
  }
  Future<void> ping() async {
    setState(() => busyApi = true);
    final result = await client.rest.getHealth();
    setState(() {
      health = result;
      busyApi = false;
      notice = 'API responded in ${result['latency_ms']} ms';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 860;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: wide ? 48 : 18,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _hero(),
                      const SizedBox(height: 18),
                      _stats(wide),
                      const SizedBox(height: 18),
                      if (wide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _authCard()),
                            const SizedBox(width: 18),
                            Expanded(child: _storageCard()),
                          ],
                        )
                      else ...[
                        _authCard(),
                        const SizedBox(height: 18),
                        _storageCard(),
                      ],
                      const SizedBox(height: 18),
                      _apiCard(),
                      const SizedBox(height: 18),
                      _codeCard(),
                      const SizedBox(height: 12),
                      Text(
                        notice,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF17152F), Color(0xFF3A2F80)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.hub_rounded, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anythink SDK Playground',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'A focused Flutter proof-of-concept for Auth, Storage and REST.',
                  style: TextStyle(color: Color(0xFFD9D5FF), fontSize: 14),
                ),
              ],
            ),
          ),
          const _StatusPill(),
        ],
      ),
    );
  }

  Widget _stats(bool wide) {
    final items = [
      ('Auth', 'session ready', Icons.lock_open_rounded),
      ('Storage', '${client.storage.files.length} objects', Icons.cloud_rounded),
      ('REST', health == null ? 'not tested' : 'healthy', Icons.bolt_rounded),
    ];
    if (!wide) {
      return Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _MetricCard(
              title: items[i].$1,
              value: items[i].$2,
              icon: items[i].$3,
            ),
            if (i != items.length - 1) const SizedBox(height: 10),
          ],
        ],
      );
    }
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: _MetricCard(
              title: items[i].$1,
              value: items[i].$2,
              icon: items[i].$3,
            ),
          ),
          if (i != items.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
  Widget _authCard() {
    final signedIn = client.auth.session != null;
    return _Panel(
      title: 'Authentication',
      subtitle: 'Simple, idiomatic async API',
      icon: Icons.key_rounded,
      child: Column(
        children: [
          TextField(
            controller: email,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: busyAuth ? null : signIn,
              icon: busyAuth
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(signedIn ? Icons.verified_rounded : Icons.login_rounded),
              label: Text(signedIn ? 'Refresh session' : 'Sign in'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _storageCard() {
    return _Panel(
      title: 'Storage',
      subtitle: 'Typed file model + upload flow',
      icon: Icons.folder_copy_rounded,
      child: Column(
        children: [
          for (final file in client.storage.files)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                child: Icon(Icons.insert_drive_file_rounded),
              ),
              title: Text(file.name),
              subtitle: Text('${(file.sizeBytes / 1024).round()} KB'),
              trailing: const Icon(Icons.check_circle_rounded),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: busyUpload ? null : upload,
              icon: const Icon(Icons.upload_rounded),
              label: Text(busyUpload ? 'Uploading…' : 'Upload demo file'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _apiCard() {
    return _Panel(
      title: 'REST health check',
      subtitle: 'Transport-ready API surface with predictable models',
      icon: Icons.http_rounded,
      child: Row(
        children: [
          Expanded(
            child: Text(
              health == null
                  ? 'No request sent yet.'
                  : 'status: ${health!['status']}  •  region: ${health!['region']}  •  latency: ${health!['latency_ms']} ms',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonalIcon(
            onPressed: busyApi ? null : ping,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(busyApi ? 'Calling…' : 'Run'),
          ),
        ],
      ),
    );
  }
  Widget _codeCard() {
    const code = '''final anythink = AnythinkClient(
  AnythinkConfig(baseUrl: apiUrl, apiKey: key),
);

await anythink.auth.signIn(
  email: email,
  password: password,
);

final file = await anythink.storage.upload(...);
final health = await anythink.rest.getHealth();''';
    return _Panel(
      title: 'Developer experience',
      subtitle: 'Small surface area, typed results, async by default',
      icon: Icons.code_rounded,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF17152F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const SelectableText(
          code,
          style: TextStyle(
            fontFamily: 'monospace',
            height: 1.55,
            color: Color(0xFFE8E5FF),
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                      Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9E8F2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2FBC8D).withValues(alpha: .16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: Color(0xFF62E6B6)),
          SizedBox(width: 7),
          Text('sandbox', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}