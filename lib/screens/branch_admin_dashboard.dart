



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'create_user_screen.dart';
import 'user_list_screen.dart';
import 'login_screen.dart';
import 'new_inspection_screen.dart'; // Add this import

class BranchAdminDashboard extends StatefulWidget {
  const BranchAdminDashboard({super.key});

  @override
  State<BranchAdminDashboard> createState() => _BranchAdminDashboardState();
}

class _BranchAdminDashboardState extends State<BranchAdminDashboard> {
  final storage = const FlutterSecureStorage();

  Map<String, dynamic> inspectionStats = {
    "all": 0,
    "pending": 0,
    "approved": 0,
    "rejected": 0,
  };
  String branchName = '';
  String userName = '';
  bool isLoading = true;

  final String apiBase = 'http://localhost:8000/api';

  @override
  void initState() {
    super.initState();
    loadBranchInfo();
  }

  /// Load branch info from storage and fetch stats
  Future<void> loadBranchInfo() async {
    branchName = await storage.read(key: 'branch_name') ?? '';
    debugPrint("✅ Branch Name from Storage: $branchName");

    userName = await storage.read(key: 'user_name') ?? '';
    await fetchInspectionStats();
  }

  /// Fetch branch-wise inspection stats from API with JWT token
  Future<void> fetchInspectionStats() async {
    try {
      if (branchName.isEmpty) {
        debugPrint("⚠️ No branch name found in storage.");
        setState(() => isLoading = false);
        return;
      }

      String? token = await storage.read(key: 'access');

      if (token == null) {
        debugPrint("⚠️ No access token found. Logging out...");
        logout(context);
        return;
      }

      final url = Uri.parse('$apiBase/branch/inspection-stats/?branch_name=$branchName');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint("📡 API: $url");
      debugPrint("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          inspectionStats = jsonDecode(response.body);
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        debugPrint("❌ Unauthorized! Logging out...");
        logout(context);
      } else {
        debugPrint("❌ Failed to load stats: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("🚨 Error fetching stats: $e");
      setState(() => isLoading = false);
    }
  }

  /// Refresh stats when returning from new inspection
  Future<void> _refreshStats() async {
    await fetchInspectionStats();
  }

  /// Logout function
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

  /// Stat card builder
  Widget buildStatCard(String title, int count, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.85), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(3, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Button builder
  Widget buildButton(String label, Color color, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF116045),
        title: const Text(
          'Branch Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "👋 Welcome, ${userName.isNotEmpty ? userName : 'User'}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "🏢 Branch: ${branchName.isNotEmpty ? branchName : 'Not found'}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: branchName.isNotEmpty
                          ? Colors.green.shade800
                          : Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Inspection Overview",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      buildStatCard("All", inspectionStats["all"] ?? 0,
                          Colors.blue, () {}),
                      buildStatCard("Pending", inspectionStats["pending"] ?? 0,
                          Colors.orange, () {}),
                      buildStatCard("Approved", inspectionStats["approved"] ?? 0,
                          Colors.green, () {}),
                      buildStatCard("Rejected", inspectionStats["rejected"] ?? 0,
                          Colors.red, () {}),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // NEW: Create Inspection Button
                  buildButton(
                    "Assign Inspector",
                    Colors.purple.shade800,
                    Icons.add_circle_outline,
                    () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NewInspectionScreen(),
                        ),
                      );
                      
                      // Refresh stats if inspection was created successfully
                      if (result == true) {
                        _refreshStats();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  buildButton(
                    "Create Inspector",
                    Colors.green.shade900,
                    Icons.person_add_alt_1,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateUserScreen(role: 'inspector'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildButton(
                    "View Inspectors",
                    Colors.red.shade900,
                    Icons.group,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const UserListScreen(endpoint: 'inspector/list'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
