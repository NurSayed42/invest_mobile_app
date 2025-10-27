


import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_screen.dart';
import 'inspections_list_screen.dart';
import 'assigned_inspections_screen.dart'; // NEW IMPORT
import '../services/inspection_service.dart';

class InspectorDashboard extends StatefulWidget {
  const InspectorDashboard({super.key});

  @override
  State<InspectorDashboard> createState() => _InspectorDashboardState();
}

class _InspectorDashboardState extends State<InspectorDashboard> {
  final storage = const FlutterSecureStorage();
  final InspectionService _inspectionService = InspectionService();
  
  Map<String, dynamic> stats = {
    'total': 0,
    'pending': 0,
    'approved': 0,
    'rejected': 0,
  };
  
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkTokenAndLoadStats();
  }

  Future<void> _checkTokenAndLoadStats() async {
    try {
      final accessToken = await storage.read(key: 'access');
      final refreshToken = await storage.read(key: 'refresh');
      final branchName = await storage.read(key: 'branch_name');

      print('🔑 Token Check:');
      print('  - access: ${accessToken != null ? "Yes" : "No"}');
      print('  - refresh: ${refreshToken != null ? "Yes" : "No"}');
      print('  - branch_name: ${branchName ?? "Not found"}');

      if (accessToken == null) {
        print('❌ No access token found! Redirecting to login...');
        _redirectToLogin();
        return;
      }

      await _loadStats();
    } catch (e) {
      print('Error in token check: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    });
  }

  Future<void> _loadStats() async {
    try {
      setState(() {
        isLoading = true;
      });

      final statsData = await _inspectionService.getInspectionStats();
      
      setState(() {
        stats = statsData;
        isLoading = false;
      });
      
      print('✅ Stats loaded successfully: $statsData');
    } catch (e) {
      print('❌ Error loading stats: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    await storage.delete(key: 'access');
    await storage.delete(key: 'refresh');
    await storage.delete(key: 'branch_name');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // Navigation to different inspection lists
  void _navigateToInspectionsList(String status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InspectionsListScreen(filterStatus: status),
      ),
    );
  }

  // NEW: Navigate to assigned inspections
  void _navigateToAssignedInspections() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AssignedInspectionsScreen(),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
    required String status,
  }) {
    return GestureDetector(
      onTap: () => _navigateToInspectionsList(status),
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic>? args = routeArgs is Map<String, dynamic> ? routeArgs : null;
    final user = args?['user'];
    final name = user?['user_name'] ?? 'Inspector';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF116045),
        title: Text(
          "Welcome, $name 👋",
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
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: "Refresh",
            onPressed: _loadStats,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  
                  // Navigation Buttons - All with same size
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _buildNavButton('All Inspections', Icons.list_alt, 'all'),
                      _buildNavButton('Pending', Icons.pending, 'Pending'),
                      _buildNavButton('Approved', Icons.verified, 'Approved'),
                      _buildNavButton('Rejected', Icons.cancel, 'Rejected'),
                      // NEW: Assigned Inspections Button
                      _buildAssignedInspectionsButton(),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Statistics Section
                  const Text(
                    "Inspection Statistics",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF116045),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Statistics Grid - Now clickable
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.93,
                    children: [
                      // Total Inspections Card
                      _buildStatCard(
                        title: 'Total Inspections',
                        count: stats['total'] ?? 0,
                        color: const Color(0xFF116045),
                        icon: Icons.assignment,
                        status: 'all',
                      ),

                      // Pending Card
                      _buildStatCard(
                        title: 'Pending',
                        count: stats['pending'] ?? 0,
                        color: Colors.orange,
                        icon: Icons.pending_actions,
                        status: 'Pending',
                      ),

                      // Approved Card
                      _buildStatCard(
                        title: 'Approved',
                        count: stats['approved'] ?? 0,
                        color: Colors.green,
                        icon: Icons.verified,
                        status: 'Approved',
                      ),

                      // Rejected Card
                      _buildStatCard(
                        title: 'Rejected',
                        count: stats['rejected'] ?? 0,
                        color: Colors.red,
                        icon: Icons.cancel,
                        status: 'Rejected',
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Create New Inspection Button

                ],
              ),
            ),
    );
  }

  Widget _buildNavButton(String text, IconData icon, String status) {
    return SizedBox(
      width: 150, // Fixed width for all buttons
      height: 50,  // Fixed height for all buttons
      child: ElevatedButton.icon(
        onPressed: () => _navigateToInspectionsList(status),
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF116045),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFF116045)),
          ),
        ),
      ),
    );
  }

  // NEW: Assigned Inspections Button
  Widget _buildAssignedInspectionsButton() {
    return SizedBox(
      width: 315, // Same width as other buttons
      height: 50,  // Same height as other buttons
      child: ElevatedButton.icon(
        onPressed: _navigateToAssignedInspections,
        icon: const Icon(Icons.assignment_turned_in, size: 20),
        label: const Text(
          "Assigned Inspections",
          style: TextStyle(fontSize: 15), // Slightly smaller font for two lines
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2), // Different color to distinguish
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}