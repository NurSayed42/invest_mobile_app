
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class NewInspectionScreen extends StatefulWidget {
  const NewInspectionScreen({super.key});

  @override
  State<NewInspectionScreen> createState() => _NewInspectionScreenState();
}

class _NewInspectionScreenState extends State<NewInspectionScreen> {
  final storage = const FlutterSecureStorage();
  final String apiBase = 'http://10.0.2.2:8000/api';

  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  String _project = '';
  String _clientName = '';
  String _industryName = '';
  String _phoneNumber = '';
  String? _assignedInspector;
  
  List<dynamic> inspectors = [];
  bool isLoading = true;
  bool isSubmitting = false;
  String branchName = '';

  @override
  void initState() {
    super.initState();
    loadBranchInfo();
    fetchInspectors();
  }

  Future<void> loadBranchInfo() async {
    branchName = await storage.read(key: 'branch_name') ?? '';
    debugPrint("✅ Branch Name: $branchName");
  }

  Future<void> fetchInspectors() async {
    try {
      String? token = await storage.read(key: 'access');

      if (token == null) {
        debugPrint("⚠️ No access token found");
        setState(() => isLoading = false);
        return;
      }

      // Get current branch name
      String currentBranch = await storage.read(key: 'branch_name') ?? '';
      
      // ✅ CORRECTED URL: Use inspector list endpoint
      final url = Uri.parse('$apiBase/inspector/list/');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint("📡 Fetching inspectors: $url");
      debugPrint("📥 Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          inspectors = data;
          isLoading = false;
        });
        debugPrint("✅ Inspectors loaded: ${inspectors.length}");
        
        // Debug: Print inspector details
        for (var inspector in inspectors) {
          debugPrint("👤 Inspector: ${inspector['user_name']} - ID: ${inspector['id']}");
        }
      } else {
        debugPrint("❌ Failed to load inspectors: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("🚨 Error fetching inspectors: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> createInspection() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => isSubmitting = true);

    try {
      String? token = await storage.read(key: 'access');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication error. Please login again.")),
        );
        setState(() => isSubmitting = false);
        return;
      }

      // ✅ CORRECTED URL: Use new-inspections/create endpoint
      final url = Uri.parse('$apiBase/new-inspections/create/');
      
      // Prepare the request data
      final requestData = {
        'project': _project,
        'client_name': _clientName,
        'industry_name': _industryName,
        'phone_number': _phoneNumber,
        'assigned_inspector': _assignedInspector, // This should be the user ID
        'branch_name': branchName,
        // Remove 'status': 'pending' - it will be set automatically in serializer
      };

      debugPrint("📡 Creating inspection: $url");
      debugPrint("📤 Request data: $requestData");
      debugPrint("👤 Selected Inspector ID: $_assignedInspector");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestData),
      );

      debugPrint("📥 Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inspection created successfully!")),
        );
        Navigator.of(context).pop(true); // Return success
      } else {
        final errorResponse = json.decode(response.body);
        debugPrint("❌ Error response: $errorResponse");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create inspection: ${errorResponse.toString()}")),
        );
      }
    } catch (e) {
      debugPrint("🚨 Error creating inspection: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF116045),
        title: const Text(
          'Create New Inspection',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Project Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.work),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter project name';
                        }
                        return null;
                      },
                      onSaved: (value) => _project = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Client Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter client name';
                        }
                        return null;
                      },
                      onSaved: (value) => _clientName = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Industry Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter industry name';
                        }
                        return null;
                      },
                      onSaved: (value) => _industryName = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone Number *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                      onSaved: (value) => _phoneNumber = value!,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Assigned Inspector *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.engineering),
                      ),
                      value: _assignedInspector,
                      items: inspectors.map<DropdownMenuItem<String>>((inspector) {
                        return DropdownMenuItem<String>(
                          value: inspector['id'].toString(),
                          child: Text(
                            '${inspector['user_name']} (${inspector['email']})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an inspector';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _assignedInspector = value;
                        });
                        debugPrint("Selected Inspector ID: $value");
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.add_task, color: Colors.white),
                        label: Text(
                          isSubmitting ? 'Creating...' : 'Create Inspection',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF116045),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isSubmitting ? null : createInspection,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}