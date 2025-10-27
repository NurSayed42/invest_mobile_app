import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/branch_admin_dashboard.dart';
import 'screens/inspector_dashboard.dart';
import 'screens/create_inspection_screen.dart'; // Import


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvestTraker',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (c) => const WelcomeScreen(),
        '/login': (c) => const LoginScreen(),
        '/forgot': (c) => const ForgotScreen(),
        '/admin_dashboard': (c) =>  AdminDashboard(),
        '/branch_dashboard': (c) =>  BranchAdminDashboard(),
        '/inspector_dashboard': (c) =>  InspectorDashboard(),
        '/create_inspection': (c) =>  CreateInspectionScreen()
      },
    );
  }
}


