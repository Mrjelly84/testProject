import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import 'api/database_api.dart';

class ExitScreen extends StatefulWidget {
  const ExitScreen({super.key});

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exit App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Thank you for using the Inventory App!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (Platform.isAndroid) {
                  await DatabaseApi.instance.disconnect();
                  SystemNavigator.pop();
                  return;
                }

                if (Platform.isIOS) {
                  await DatabaseApi.instance.disconnect();
                  if (!mounted) return;
                  // Using State.context after an `await` is safe here because
                  // we guard with `mounted`. Suppress analyzer warning.
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  return;
                }

                // On desktop (Windows, macOS, Linux) exit the process.
                await DatabaseApi.instance.disconnect();
                exit(0);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Exit Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Builder(
              builder: (ctx) => TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    ctx,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Back to Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
