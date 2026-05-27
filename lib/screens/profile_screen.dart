import 'package:flutter/material.dart';

import '../utils/edge_to_edge.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.userData,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const EdgeToEdgeBody(
        bottom: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return EdgeToEdgeBody(
      bottom: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundImage: NetworkImage(userData!['image']),
            ),
            const SizedBox(height: 20),
            Text(
              "${userData!['firstName']} ${userData!['lastName']}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(userData!['email']),
            const SizedBox(height: 10),
            Text(userData!['username']),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
