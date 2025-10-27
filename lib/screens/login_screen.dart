import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtl = TextEditingController();
  final TextEditingController passCtl = TextEditingController();
  String _role = 'admin';
  final storage = const FlutterSecureStorage();
  final String apiBase = 'http://10.0.2.2:8000/api';

  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);
    try {
      final resp = await http.post(
        Uri.parse('$apiBase/token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailCtl.text.trim(),
          'password': passCtl.text,
          'role': _role,
        }),
      );
      setState(() => loading = false);

      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);

        // Save tokens
        await storage.write(key: 'access', value: body['access']);
        await storage.write(key: 'refresh', value: body['refresh']);

        // Save branch_name if exists
        if (body['user']?['branch_name'] != null &&
            body['user']['branch_name'].toString().isNotEmpty) {
          await storage.write(key: 'branch_name', value: body['user']['branch_name']);
        } else {
          await storage.delete(key: 'branch_name');
        }

        // Navigate according to role
        switch (_role) {
          case 'admin':
            Navigator.pushReplacementNamed(context, '/admin_dashboard',
                arguments: {
                    'user': body['user'],
                    'access': body['access'], // Token pass করুন
                });            break;
          case 'branch_admin':
            Navigator.pushReplacementNamed(context, '/branch_dashboard',
                arguments: {
                    'user': body['user'],
                    'access': body['access'], // Token pass করুন
                });            break;
          case 'inspector':
            Navigator.pushReplacementNamed(context, '/inspector_dashboard',
                arguments: {
                    'user': body['user'],
                    'access': body['access'], // Token pass করুন
                });
            break;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password ❌')),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server error ⚠️')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 104, 23),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circular Lock Icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.lock,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Welcome Back!!',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 7, 102, 11)),
                  ),
                  const Text(
                    'Login to continue',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 7, 102, 11)),
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 7, 102, 11)),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: emailCtl,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email, color: Colors.green),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passCtl,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.green),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _role,
                    decoration: InputDecoration(
                      labelText: 'Select Role',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: (v) => setState(() => _role = v ?? 'admin'),
                    items: const [
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      DropdownMenuItem(
                          value: 'branch_admin', child: Text('Branch Admin')),
                      DropdownMenuItem(value: 'inspector', child: Text('Inspector')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: loading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade900,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgot'),
                    child: const Text('Forgot password?',
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




