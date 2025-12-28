



import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'create_inspection_screen.dart'; // ADD THIS IMPORT

class AssignedInspectionsScreen extends StatefulWidget {
  const AssignedInspectionsScreen({super.key});

  @override
  State<AssignedInspectionsScreen> createState() => _AssignedInspectionsScreenState();
}

class _AssignedInspectionsScreenState extends State<AssignedInspectionsScreen> {
  final storage = const FlutterSecureStorage();
  final String apiBase = 'http://localhost:8000/api';

  List<dynamic> assignedInspections = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAssignedInspections();
  }

 Future<void> _loadAssignedInspections() async {
  try {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    String? token = await storage.read(key: 'access');
    if (token == null) {
      throw Exception('No authentication token found. Please login again.');
    }

    debugPrint("🔑 Loading current user information...");

    // Step 1: Get current user information
    final userResponse = await http.get(
      Uri.parse('$apiBase/current-user/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (userResponse.statusCode != 200) {
      throw Exception('Failed to get user information: ${userResponse.statusCode}');
    }

    final userData = json.decode(userResponse.body);
    final currentUserId = userData['id'];
    
    debugPrint("✅ Current User ID: $currentUserId");
    debugPrint("👤 Current User: ${userData['user_name']} (${userData['email']})");

    // Step 2: Load all new inspections
    final inspectionsResponse = await http.get(
      Uri.parse('$apiBase/new-inspections/list/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint("📥 Inspections API Response: ${inspectionsResponse.statusCode}");

    if (inspectionsResponse.statusCode == 200) {
      final allInspections = json.decode(inspectionsResponse.body);
      debugPrint("📋 Total inspections from API: ${allInspections.length}");

      // Filter inspections assigned to current user AND status is 'pending'
      final myAssignedInspections = allInspections.where((inspection) {
        final assignedInspectorId = inspection['assigned_inspector'];
        final status = inspection['status'];
        final isAssignedToMe = assignedInspectorId == currentUserId;
        final isPending = status == 'pending';
        
        if (isAssignedToMe && isPending) {
          debugPrint("🎯 Found pending assigned inspection: ${inspection['project']}");
        }
        
        return isAssignedToMe && isPending; // শুধু pending inspections
      }).toList();

      setState(() {
        assignedInspections = myAssignedInspections;
        isLoading = false;
      });

      debugPrint("✅ Pending assigned inspections loaded: ${assignedInspections.length}");
      
      // Show debug information
      if (assignedInspections.isEmpty) {
        debugPrint("ℹ️ No PENDING inspections assigned to user ID: $currentUserId");
        debugPrint("ℹ️ All assigned inspections (all statuses):");
        final allMyInspections = allInspections.where((inspection) {
          return inspection['assigned_inspector'] == currentUserId;
        }).toList();
        
        for (var inspection in allMyInspections) {
          debugPrint("   - ${inspection['project']} -> Status: ${inspection['status']}");
        }
      }
    } else {
      throw Exception('Failed to load inspections: ${inspectionsResponse.statusCode}');
    }
  } catch (e) {
    debugPrint("🚨 Error loading assigned inspections: $e");
    setState(() {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
    });
  }
}
  // NEW FUNCTION: Navigate to Create Inspection Screen
// NEW FUNCTION: Navigate to Create Inspection Screen with data
  void _navigateToCreateInspection(Map<String, dynamic> inspection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateInspectionScreen(
          inspectionData: inspection, // inspection data pass korchi
          isEditMode: false, // new inspection create hobe
        ),
      ),
    );
  }

  Widget _buildInspectionCard(Map<String, dynamic> inspection) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Name
            Row(
              children: [
                const Icon(Icons.work, color: Color(0xFF116045)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    inspection['project'] ?? 'No Project Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF116045),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Client Information
            _buildInfoRow('Client', Icons.person, inspection['client_name']),
            _buildInfoRow('Industry', Icons.business, inspection['industry_name']),
            _buildInfoRow('Phone', Icons.phone, inspection['phone_number']),
            
            const SizedBox(height: 12),
            
            // Status and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(inspection['status']),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getStatusText(inspection['status']),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _formatDate(inspection['created_at']),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            // NEW: Start Inspection Button
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _navigateToCreateInspection(inspection),
                icon: const Icon(Icons.play_arrow, size: 20),
                label: const Text(
                  'Start Inspection',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF116045),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, IconData icon, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'approved':
        return const Color(0xFF116045);
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF116045),
        title: const Text(
          'My Assigned Inspections',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadAssignedInspections,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your assigned inspections...'),
                ],
              ),
            )
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to load inspections',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadAssignedInspections,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF116045),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : assignedInspections.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_turned_in, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No Assigned Inspections',
                            style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'You don\'t have any inspections assigned to you at the moment.',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadAssignedInspections,
                      child: ListView.builder(
                        itemCount: assignedInspections.length,
                        itemBuilder: (context, index) {
                          final inspection = assignedInspections[index];
                          return _buildInspectionCard(inspection);
                        },
                      ),
                    ),
    );
  }
}