import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'api/database_api.dart';
import 'log_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    try {
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Please enter username and password');
      }

      if (username != 'admin' || password != 'admin') {
        throw Exception('Incorrect username or password');
      }

      await DatabaseApi.instance.connect();
      DatabaseApi.instance.setCurrentUser(username);
      await DatabaseApi.instance.addLog('Logged in');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InventoryScreen()),
      );
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _login, child: const Text('Login')),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogScreen()),
                );
              },
              child: const Text('View Activity Logs'),
            ),
          ),
        ],
      ),
    );
  }
}
