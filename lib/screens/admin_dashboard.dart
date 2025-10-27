
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'create_user_screen.dart';
import 'user_list_screen.dart';
import 'login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final storage = const FlutterSecureStorage();
  Map<String, dynamic> stats = {
    "all": 0,
    "pending": 0,
    "approved": 0,
    "rejected": 0,
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      final url = Uri.parse('http://10.0.2.2:8000/api/inspection/stats/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          stats = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        debugPrint("Failed to load stats: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching stats: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> logout(BuildContext context) async {
    await storage.deleteAll();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget buildStatCard(String title, int count, Color color) {
    return Card(
      elevation: 5,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 160,
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(count.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String label, Color color, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white), // icon white
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white, // text white
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // rounded edges
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Inspection Overview",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),

                  // Stats cards grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: 1.1,
                    children: [
                      buildStatCard("All", stats["all"] ?? 0, Colors.blue),
                      buildStatCard("Pending", stats["pending"] ?? 0, Colors.orange),
                      buildStatCard("Approved", stats["approved"] ?? 0, Colors.green),
                      buildStatCard("Rejected", stats["rejected"] ?? 0, Colors.red),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Buttons for branch admin
                  buildButton(
                    "Create Branch Admin",
                    Colors.green.shade900, // deep green
                    Icons.person_add,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CreateUserScreen(role: 'branch_admin')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildButton(
                    "View Branch Admins",
                    Colors.red.shade900, // deep red
                    Icons.list,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const UserListScreen(endpoint: 'branch-admin/list')),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
