import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateUserScreen extends StatefulWidget {
  final String role; // branch_admin or inspector
  const CreateUserScreen({super.key, required this.role});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController nameCtl = TextEditingController();
  final TextEditingController emailCtl = TextEditingController();
  final TextEditingController passCtl = TextEditingController();
  final TextEditingController empIdCtl = TextEditingController();
  final TextEditingController branchCtl = TextEditingController();

  final storage = const FlutterSecureStorage();
  final String apiBase = 'http://10.0.2.2:8000/api';

  bool loading = false;

  Future<void> createUser() async {
    setState(() => loading = true);
    final token = await storage.read(key: 'access');
    final endpoint =
        widget.role == 'branch_admin' ? 'branch-admin/create/' : 'inspector/create/';

    // Branch name handle
    String branchName = '';
    if (widget.role == 'branch_admin') {
      branchName = branchCtl.text.trim();
    } else if (widget.role == 'inspector') {
      branchName = (await storage.read(key: 'branch_name')) ?? '';
      if (branchName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Branch name not found. Login branch admin first.')),
        );
        setState(() => loading = false);
        return;
      }
    }

    final resp = await http.post(
      Uri.parse('$apiBase/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'user_name': nameCtl.text.trim(),
        'email': emailCtl.text.trim(),
        'password': passCtl.text,
        'employee_id': empIdCtl.text.trim(),
        'branch_name': branchName,
        'role': widget.role,
      }),
    );

    setState(() => loading = false);
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User created successfully ✅')),
      );
      Navigator.pop(context);
    } else {
      final body = jsonDecode(resp.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create ${widget.role.replaceAll("_", " ").toUpperCase()}',
          style: const TextStyle(color: Colors.white), // <-- explicitly white
        ),
        backgroundColor: Colors.green.shade900,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.green.shade900, // card background
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Enter User Details',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  buildTextField(controller: nameCtl, label: 'Username'),
                  const SizedBox(height: 16),
                  buildTextField(controller: emailCtl, label: 'Email'),
                  const SizedBox(height: 16),
                  buildTextField(controller: passCtl, label: 'Password', obscure: true),
                  const SizedBox(height: 16),
                  buildTextField(controller: empIdCtl, label: 'Employee ID', isNumber: true),
                  const SizedBox(height: 16),
                  if (widget.role == 'branch_admin')
                    buildTextField(controller: branchCtl, label: 'Branch Name'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: loading ? null : createUser,
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.green)
                          : Text('Create User', style: TextStyle(fontSize: 18, color: Colors.green.shade900)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
