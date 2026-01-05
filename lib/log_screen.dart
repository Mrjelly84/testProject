import 'package:flutter/material.dart';
import 'database_helper.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Logs')),
      body: FutureBuilder<List<LogEntry>>(
        future: DatabaseHelper.instance.readAllLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No logs available.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final log = snapshot.data![index];
              return ListTile(
                title: Text(log.action),
                subtitle: Text('User: ${log.user} • ${log.timestamp.substring(0, 16).replaceAll('T', ' ')}'),
                leading: const Icon(Icons.history),
              );
            },
          );
        },
      ),
    );
  }
}
