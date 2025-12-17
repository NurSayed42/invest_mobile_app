


// // // services/inspection_service.dart
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// // class InspectionService {
// //   static const String baseUrl = 'http://10.0.2.2:8000/api';
// //   final FlutterSecureStorage _storage = const FlutterSecureStorage();

// //   // Token নেওয়ার method - CORRECTED KEYS
// //   Future<String?> _getToken() async {
// //     try {
// //       // Login screen এ 'access' key-এ token save হয়, তাই 'access' key দিয়ে read করব
// //       final token = await _storage.read(key: 'access');
// //       print('Token from storage: ${token != null ? "Yes" : "No"}');
// //       return token;
// //     } catch (e) {
// //       print('Error getting token: $e');
// //       return null;
// //     }
// //   }

// //   // Get inspection statistics for dashboard
// //   Future<Map<String, dynamic>> getInspectionStats() async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return _getDefaultStats();
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/stats/');
// //       print('🔄 Calling API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('📊 API Response Status: ${response.statusCode}');
// //       print('📊 API Response Body: ${response.body}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Successfully parsed stats data: $data');
// //         return data;
// //       } else {
// //         print('❌ API Error: ${response.statusCode}');
// //         return _getDefaultStats();
// //       }
// //     } catch (e) {
// //       print('❌ Error in getInspectionStats: $e');
// //       return _getDefaultStats();
// //     }
// //   }

// //   // Default stats for error cases
// //   Map<String, dynamic> _getDefaultStats() {
// //     print('🔄 Using default stats');
// //     return {
// //       'total': 0,
// //       'pending': 0,
// //       'in_progress': 0,
// //       'completed': 0,
// //       'approved': 0,
// //       'rejected': 0,
// //     };
// //   }

// //   // Submit new inspection - UPDATED FOR COMPLETE DATA
// //   Future<bool> submitInspection(Map<String, dynamic> inspectionData) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No token found for submission');
// //         return false;
// //       }

// //       print('📤 Submitting inspection data...');
// //       print('📍 Location points: ${inspectionData['total_location_points']}');
// //       print('📷 Photos count: ${inspectionData['photos_count']}');
// //       print('🎥 Has video: ${inspectionData['has_video']}');
// //       print('📋 Checklist items: ${inspectionData['checklist_items']?.length}');
// //       print('📄 Documents count: ${inspectionData['documents_count']}');

// //       final response = await http.post(
// //         Uri.parse('$baseUrl/inspections/'),
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $token',
// //         },
// //         body: json.encode(inspectionData),
// //       );

// //       print('📤 Submission Response: ${response.statusCode}');
// //       print('📤 Response Body: ${response.body}');

// //       if (response.statusCode == 201) {
// //         print('✅ Inspection submitted successfully');
// //         return true;
// //       } else {
// //         print('❌ Submission failed: ${response.statusCode}');
// //         return false;
// //       }
// //     } catch (e) {
// //       print('❌ Error submitting inspection: $e');
// //       return false;
// //     }
// //   }

// //   // Get inspections by status
// //   Future<List<dynamic>> getInspectionsByStatus(String status) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return [];
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/by_status/?status=$status');
// //       print('🔄 Calling API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('📋 API Response Status: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Successfully loaded ${data.length} inspections with status: $status');
// //         return data;
// //       } else {
// //         print('❌ API Error: ${response.statusCode}');
// //         return [];
// //       }
// //     } catch (e) {
// //       print('❌ Error in getInspectionsByStatus: $e');
// //       return [];
// //     }
// //   }

// //   // Update inspection status only
// //   Future<bool> updateInspectionStatus(int inspectionId, String status) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No token found for status update');
// //         return false;
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/$inspectionId/update_status/');
// //       print('🔄 Calling API: $url');
// //       print('📝 Updating inspection $inspectionId to status: $status');

// //       final response = await http.patch(
// //         url,
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $token',
// //         },
// //         body: json.encode({
// //           'status': status,
// //         }),
// //       );

// //       print('📝 Update Response: ${response.statusCode}');
// //       print('📝 Response Body: ${response.body}');

// //       if (response.statusCode == 200) {
// //         print('✅ Inspection status updated successfully');
// //         return true;
// //       } else {
// //         print('❌ Status update failed: ${response.statusCode}');
// //         return false;
// //       }
// //     } catch (e) {
// //       print('❌ Error updating inspection status: $e');
// //       return false;
// //     }
// //   }

// //   // Update entire inspection (for edit form) - UPDATED FOR COMPLETE DATA
// //   Future<bool> updateInspection(int inspectionId, Map<String, dynamic> inspectionData) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No token found for update');
// //         return false;
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/$inspectionId/');
// //       print('🔄 Calling UPDATE API: $url');
// //       print('📝 Updating inspection $inspectionId');
// //       print('📍 Location points: ${inspectionData['total_location_points']}');
// //       print('📷 Photos count: ${inspectionData['photos_count']}');
// //       print('🎥 Has video: ${inspectionData['has_video']}');

// //       final response = await http.put(
// //         url,
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $token',
// //         },
// //         body: json.encode(inspectionData),
// //       );

// //       print('📝 Update Response: ${response.statusCode}');
// //       print('📝 Response Body: ${response.body}');

// //       if (response.statusCode == 200) {
// //         print('✅ Inspection updated successfully');
// //         return true;
// //       } else {
// //         print('❌ Update failed: ${response.statusCode}');
// //         return false;
// //       }
// //     } catch (e) {
// //       print('❌ Error updating inspection: $e');
// //       return false;
// //     }
// //   }

// //   // Get single inspection by ID
// //   Future<Map<String, dynamic>?> getInspectionById(int inspectionId) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return null;
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/$inspectionId/');
// //       print('🔄 Calling API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('📋 API Response Status: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Successfully loaded inspection: $inspectionId');
        
// //         // Debug print important data
// //         if (data != null) {
// //           print('📊 Inspection Data Summary:');
// //           print('   Client: ${data['client_name'] ?? 'N/A'}');
// //           print('   Industry: ${data['industry_name'] ?? 'N/A'}');
// //           print('   Status: ${data['status'] ?? 'N/A'}');
// //           print('   Location Points: ${data['total_location_points'] ?? 0}');
// //           print('   Photos Count: ${data['photos_count'] ?? 0}');
// //           print('   Has Video: ${data['has_video'] ?? false}');
// //           print('   Documents Count: ${data['documents_count'] ?? 0}');
// //         }
        
// //         return data;
// //       } else if (response.statusCode == 404) {
// //         print('❌ Inspection not found: $inspectionId');
// //         return null;
// //       } else {
// //         print('❌ API Error: ${response.statusCode}');
// //         return null;
// //       }
// //     } catch (e) {
// //       print('❌ Error in getInspectionById: $e');
// //       return null;
// //     }
// //   }

// //   // Delete inspection
// //   Future<bool> deleteInspection(int inspectionId) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No token found for deletion');
// //         return false;
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/$inspectionId/');
// //       print('🔄 Calling DELETE API: $url');

// //       final response = await http.delete(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       );

// //       print('🗑️ Delete Response: ${response.statusCode}');

// //       if (response.statusCode == 204) {
// //         print('✅ Inspection deleted successfully');
// //         return true;
// //       } else {
// //         print('❌ Delete failed: ${response.statusCode}');
// //         return false;
// //       }
// //     } catch (e) {
// //       print('❌ Error deleting inspection: $e');
// //       return false;
// //     }
// //   }

// //   // Get all inspections for current user (with optional filters)
// //   Future<List<dynamic>> getAllInspections({Map<String, String>? filters}) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return [];
// //       }

// //       String url = '$baseUrl/inspections/';
      
// //       // Add filters to URL if provided
// //       if (filters != null && filters.isNotEmpty) {
// //         final filterParams = filters.entries
// //             .where((entry) => entry.value.isNotEmpty)
// //             .map((entry) => '${entry.key}=${entry.value}')
// //             .join('&');
        
// //         if (filterParams.isNotEmpty) {
// //           url += '?$filterParams';
// //         }
// //       }

// //       final uri = Uri.parse(url);
// //       print('🔄 Calling API: $uri');

// //       final response = await http.get(
// //         uri,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('📋 API Response Status: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Successfully loaded ${data.length} inspections');
        
// //         // Print summary of loaded inspections
// //         if (data.isNotEmpty) {
// //           print('📊 Loaded Inspections Summary:');
// //           for (int i = 0; i < data.length && i < 3; i++) {
// //             final inspection = data[i];
// //             print('   ${i + 1}. ${inspection['client_name']} - ${inspection['status']}');
// //           }
// //           if (data.length > 3) {
// //             print('   ... and ${data.length - 3} more');
// //           }
// //         }
        
// //         return data;
// //       } else {
// //         print('❌ API Error: ${response.statusCode}');
// //         return [];
// //       }
// //     } catch (e) {
// //       print('❌ Error in getAllInspections: $e');
// //       return [];
// //     }
// //   }

// //   // Search inspections by client name or industry
// //   Future<List<dynamic>> searchInspections(String query) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return [];
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/?search=$query');
// //       print('🔄 Calling SEARCH API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('🔍 Search Response Status: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Search found ${data.length} inspections for query: $query');
// //         return data;
// //       } else {
// //         print('❌ Search API Error: ${response.statusCode}');
// //         return [];
// //       }
// //     } catch (e) {
// //       print('❌ Error in searchInspections: $e');
// //       return [];
// //     }
// //   }

// //   // Get inspection counts by different categories
// //   Future<Map<String, dynamic>> getInspectionAnalytics() async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return {};
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/stats/');
// //       print('🔄 Calling Analytics API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('📈 Analytics Response Status: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Successfully loaded analytics data');
// //         return data;
// //       } else {
// //         print('❌ Analytics API Error: ${response.statusCode}');
// //         return {};
// //       }
// //     } catch (e) {
// //       print('❌ Error in getInspectionAnalytics: $e');
// //       return {};
// //     }
// //   }

// //   // Upload documents for inspection
// //   Future<bool> uploadInspectionDocuments(int inspectionId, List<String> documentPaths) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No token found for document upload');
// //         return false;
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/$inspectionId/upload_documents/');
// //       print('🔄 Calling Document Upload API: $url');
// //       print('📎 Uploading ${documentPaths.length} documents');

// //       var request = http.MultipartRequest('POST', url);
// //       request.headers['Authorization'] = 'Bearer $token';

// //       // Add each document to the request
// //       for (var path in documentPaths) {
// //         var file = await http.MultipartFile.fromPath('documents', path);
// //         request.files.add(file);
// //       }

// //       final response = await request.send();
// //       print('📎 Document Upload Response: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         print('✅ Documents uploaded successfully');
// //         return true;
// //       } else {
// //         print('❌ Document upload failed: ${response.statusCode}');
// //         return false;
// //       }
// //     } catch (e) {
// //       print('❌ Error uploading documents: $e');
// //       return false;
// //     }
// //   }

// //   // Get user profile information
// //   Future<Map<String, dynamic>?> getUserProfile() async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return null;
// //       }

// //       final url = Uri.parse('$baseUrl/users/me/');
// //       print('🔄 Calling User Profile API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('👤 Profile Response Status: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Successfully loaded user profile');
// //         return data;
// //       } else {
// //         print('❌ Profile API Error: ${response.statusCode}');
// //         return null;
// //       }
// //     } catch (e) {
// //       print('❌ Error in getUserProfile: $e');
// //       return null;
// //     }
// //   }

// //   // Refresh access token
// //   Future<String?> refreshToken() async {
// //     try {
// //       final refreshToken = await _storage.read(key: 'refresh');
// //       if (refreshToken == null) {
// //         print('❌ No refresh token found');
// //         return null;
// //       }

// //       final url = Uri.parse('$baseUrl/token/refresh/');
// //       print('🔄 Calling Token Refresh API: $url');

// //       final response = await http.post(
// //         url,
// //         headers: {
// //           'Content-Type': 'application/json',
// //         },
// //         body: json.encode({
// //           'refresh': refreshToken,
// //         }),
// //       );

// //       print('🔄 Token Refresh Response: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         final newAccessToken = data['access'];
        
// //         // Save new access token
// //         await _storage.write(key: 'access', value: newAccessToken);
// //         print('✅ Token refreshed successfully');
// //         return newAccessToken;
// //       } else {
// //         print('❌ Token refresh failed: ${response.statusCode}');
// //         return null;
// //       }
// //     } catch (e) {
// //       print('❌ Error refreshing token: $e');
// //       return null;
// //     }
// //   }

// //   // Check if user is authenticated
// //   Future<bool> isAuthenticated() async {
// //     try {
// //       final token = await _getToken();
// //       if (token == null) {
// //         return false;
// //       }

// //       // Optional: Verify token is valid by making a simple API call
// //       final url = Uri.parse('$baseUrl/users/me/');
// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //         },
// //       ).timeout(const Duration(seconds: 5));

// //       return response.statusCode == 200;
// //     } catch (e) {
// //       print('❌ Error checking authentication: $e');
// //       return false;
// //     }
// //   }

// //   // Logout user
// //   Future<void> logout() async {
// //     try {
// //       await _storage.delete(key: 'access');
// //       await _storage.delete(key: 'refresh');
// //       await _storage.delete(key: 'branch_name');
// //       print('✅ User logged out successfully');
// //     } catch (e) {
// //       print('❌ Error during logout: $e');
// //     }
// //   }

// //   // NEW: Get branch information
// //   Future<String?> getBranchName() async {
// //     try {
// //       return await _storage.read(key: 'branch_name');
// //     } catch (e) {
// //       print('❌ Error getting branch name: $e');
// //       return null;
// //     }
// //   }

// //   // NEW: Save branch information
// //   Future<void> saveBranchName(String branchName) async {
// //     try {
// //       await _storage.write(key: 'branch_name', value: branchName);
// //       print('✅ Branch name saved: $branchName');
// //     } catch (e) {
// //       print('❌ Error saving branch name: $e');
// //     }
// //   }

// //   // NEW: Validate inspection data before submission
// //   bool validateInspectionData(Map<String, dynamic> data) {
// //     try {
// //       // Check required fields
// //       if (data['client_name'] == null || data['client_name'].toString().isEmpty) {
// //         print('❌ Validation failed: Client name is required');
// //         return false;
// //       }

// //       if (data['industry_name'] == null || data['industry_name'].toString().isEmpty) {
// //         print('❌ Validation failed: Industry name is required');
// //         return false;
// //       }

// //       if (data['branch_name'] == null || data['branch_name'].toString().isEmpty) {
// //         print('❌ Validation failed: Branch name is required');
// //         return false;
// //       }

// //       // Check if location data exists
// //       if (data['location_points'] == null || data['total_location_points'] == 0) {
// //         print('⚠️ Warning: No location data captured');
// //       }

// //       // Check if photos exist
// //       if (data['has_photos'] == false) {
// //         print('⚠️ Warning: No photos uploaded');
// //       }

// //       print('✅ Inspection data validation passed');
// //       return true;
// //     } catch (e) {
// //       print('❌ Error validating inspection data: $e');
// //       return false;
// //     }
// //   }

// //   // NEW: Get inspection by client name
// //   Future<List<dynamic>> getInspectionsByClient(String clientName) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return [];
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/by_client/?client_name=$clientName');
// //       print('🔄 Calling API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('📋 API Response Status: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Successfully loaded ${data.length} inspections for client: $clientName');
// //         return data;
// //       } else {
// //         print('❌ API Error: ${response.statusCode}');
// //         return [];
// //       }
// //     } catch (e) {
// //       print('❌ Error in getInspectionsByClient: $e');
// //       return [];
// //     }
// //   }

// //   // NEW: Get recent inspections
// //   Future<List<dynamic>> getRecentInspections({int limit = 10}) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return [];
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/recent/?limit=$limit');
// //       print('🔄 Calling API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('📋 API Response Status: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Successfully loaded ${data.length} recent inspections');
// //         return data;
// //       } else {
// //         print('❌ API Error: ${response.statusCode}');
// //         return [];
// //       }
// //     } catch (e) {
// //       print('❌ Error in getRecentInspections: $e');
// //       return [];
// //     }
// //   }

// //   // NEW: Export inspection data
// //   Future<String?> exportInspectionData(int inspectionId, String format) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No token found for export');
// //         return null;
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/$inspectionId/export/?format=$format');
// //       print('🔄 Calling Export API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //         },
// //       );

// //       print('📤 Export Response: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         print('✅ Inspection data exported successfully');
// //         return response.body;
// //       } else {
// //         print('❌ Export failed: ${response.statusCode}');
// //         return null;
// //       }
// //     } catch (e) {
// //       print('❌ Error exporting inspection data: $e');
// //       return null;
// //     }
// //   }

// //   // NEW: Get inspection timeline
// //   Future<List<dynamic>> getInspectionTimeline(int inspectionId) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return [];
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/$inspectionId/timeline/');
// //       print('🔄 Calling Timeline API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('📋 API Response Status: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Successfully loaded inspection timeline with ${data.length} events');
// //         return data;
// //       } else {
// //         print('❌ API Error: ${response.statusCode}');
// //         return [];
// //       }
// //     } catch (e) {
// //       print('❌ Error in getInspectionTimeline: $e');
// //       return [];
// //     }
// //   }

// //   // NEW: Bulk update inspection status
// //   Future<bool> bulkUpdateInspectionStatus(List<int> inspectionIds, String status) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No token found for bulk update');
// //         return false;
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/bulk_update_status/');
// //       print('🔄 Calling Bulk Update API: $url');
// //       print('📝 Updating ${inspectionIds.length} inspections to status: $status');

// //       final response = await http.post(
// //         url,
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $token',
// //         },
// //         body: json.encode({
// //           'inspection_ids': inspectionIds,
// //           'status': status,
// //         }),
// //       );

// //       print('📝 Bulk Update Response: ${response.statusCode}');
// //       print('📝 Response Body: ${response.body}');

// //       if (response.statusCode == 200) {
// //         print('✅ Bulk status update successful');
// //         return true;
// //       } else {
// //         print('❌ Bulk status update failed: ${response.statusCode}');
// //         return false;
// //       }
// //     } catch (e) {
// //       print('❌ Error in bulk update inspection status: $e');
// //       return false;
// //     }
// //   }

// //   // NEW: Get inspection summary
// //   Future<Map<String, dynamic>?> getInspectionSummary(int inspectionId) async {
// //     try {
// //       String? token = await _getToken();
// //       if (token == null) {
// //         print('❌ No authentication token found');
// //         return null;
// //       }

// //       final url = Uri.parse('$baseUrl/inspections/$inspectionId/summary/');
// //       print('🔄 Calling Summary API: $url');

// //       final response = await http.get(
// //         url,
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       ).timeout(const Duration(seconds: 10));

// //       print('📋 API Response Status: ${response.statusCode}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Successfully loaded inspection summary');
// //         return data;
// //       } else {
// //         print('❌ API Error: ${response.statusCode}');
// //         return null;
// //       }
// //     } catch (e) {
// //       print('❌ Error in getInspectionSummary: $e');
// //       return null;
// //     }
// //   }
// // }

// // services/inspection_service.dart - COMPLETELY FIXED VERSION


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// class InspectionService {
//   static const String baseUrl = 'http://10.0.2.2:8000/api';
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();


//   // Token নেওয়ার method - CORRECTED KEYS
//   Future<String?> _getToken() async {
//     try {
//       // Login screen এ 'access' key-এ token save হয়, তাই 'access' key দিয়ে read করব
//       final token = await _storage.read(key: 'access');
//       print('Token from storage: ${token != null ? "Yes" : "No"}');
//       return token;
//     } catch (e) {
//       print('Error getting token: $e');
//       return null;
//     }
//   }


//   // Get inspection statistics for dashboard
//   Future<Map<String, dynamic>> getInspectionStats() async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return _getDefaultStats();
//       }


//       final url = Uri.parse('$baseUrl/inspections/stats/');
//       print('🔄 Calling API: $url');


//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('📊 API Response Status: ${response.statusCode}');
//       print('📊 API Response Body: ${response.body}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Successfully parsed stats data: $data');
//         return data;
//       } else {
//         print('❌ API Error: ${response.statusCode}');
//         return _getDefaultStats();
//       }
//     } catch (e) {
//       print('❌ Error in getInspectionStats: $e');
//       return _getDefaultStats();
//     }
//   }


//   // Default stats for error cases
//   Map<String, dynamic> _getDefaultStats() {
//     print('🔄 Using default stats');
//     return {
//       'total': 0,
//       'pending': 0,
//       'in_progress': 0,
//       'completed': 0,
//       'approved': 0,
//       'rejected': 0,
//     };
//   }


//   // Submit new inspection - UPDATED FOR BASE64 MEDIA DATA
//   Future<bool> submitInspection(Map<String, dynamic> inspectionData) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No token found for submission');
//         return false;
//       }


//       // Validate inspection data
//       if (!validateInspectionData(inspectionData)) {
//         return false;
//       }


//       print('📤 Submitting inspection data with BASE64 media...');
//       print('📍 Location points: ${inspectionData['total_location_points']}');
     
//       // Print media information
//       if (inspectionData['site_photos'] != null) {
//         print('📷 Photos count: ${inspectionData['site_photos'].length} (Base64 format)');
//       }
//       if (inspectionData['site_video'] != null) {
//         print('🎥 Has video: Yes (Base64 format)');
//       }
//       if (inspectionData['uploaded_documents'] != null) {
//         print('📄 Documents count: ${inspectionData['uploaded_documents'].length} (Base64 format)');
//       }
     
//       print('📋 Checklist items: ${inspectionData['checklist_items']?.length}');


//       final response = await http.post(
//         Uri.parse('$baseUrl/inspections/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(inspectionData),
//       );


//       print('📤 Submission Response: ${response.statusCode}');
//       print('📤 Response Body: ${response.body}');


//       if (response.statusCode == 201) {
//         print('✅ Inspection submitted successfully with Base64 media');
//         return true;
//       } else {
//         print('❌ Submission failed: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Error submitting inspection: $e');
//       return false;
//     }
//   }


//   // Get inspections by status
//   Future<List<dynamic>> getInspectionsByStatus(String status) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return [];
//       }


//       final url = Uri.parse('$baseUrl/inspections/by_status/?status=$status');
//       print('🔄 Calling API: $url');


//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('📋 API Response Status: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Successfully loaded ${data.length} inspections with status: $status');
//         return data;
//       } else {
//         print('❌ API Error: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('❌ Error in getInspectionsByStatus: $e');
//       return [];
//     }
//   }


//   // Update inspection status only
//   Future<bool> updateInspectionStatus(int inspectionId, String status) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No token found for status update');
//         return false;
//       }


//       final url = Uri.parse('$baseUrl/inspections/$inspectionId/update_status/');
//       print('🔄 Calling API: $url');
//       print('📝 Updating inspection $inspectionId to status: $status');


//       final response = await http.patch(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode({
//           'status': status,
//         }),
//       );


//       print('📝 Update Response: ${response.statusCode}');
//       print('📝 Response Body: ${response.body}');


//       if (response.statusCode == 200) {
//         print('✅ Inspection status updated successfully');
//         return true;
//       } else {
//         print('❌ Status update failed: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Error updating inspection status: $e');
//       return false;
//     }
//   }


//   // Update entire inspection (for edit form) - UPDATED FOR BASE64 MEDIA DATA
//   Future<bool> updateInspection(int inspectionId, Map<String, dynamic> inspectionData) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No token found for update');
//         return false;
//       }


//       final url = Uri.parse('$baseUrl/inspections/$inspectionId/');
//       print('🔄 Calling UPDATE API: $url');
//       print('📝 Updating inspection $inspectionId with Base64 media');
//       print('📍 Location points: ${inspectionData['total_location_points']}');
     
//       // Print media information
//       if (inspectionData['site_photos'] != null) {
//         print('📷 Photos count: ${inspectionData['site_photos'].length} (Base64 format)');
//       }
//       if (inspectionData['site_video'] != null) {
//         print('🎥 Has video: Yes (Base64 format)');
//       }


//       final response = await http.put(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(inspectionData),
//       );


//       print('📝 Update Response: ${response.statusCode}');
//       print('📝 Response Body: ${response.body}');


//       if (response.statusCode == 200) {
//         print('✅ Inspection updated successfully with Base64 media');
//         return true;
//       } else {
//         print('❌ Update failed: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Error updating inspection: $e');
//       return false;
//     }
//   }


//   // Get single inspection by ID
//   Future<Map<String, dynamic>?> getInspectionById(int inspectionId) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return null;
//       }


//       final url = Uri.parse('$baseUrl/inspections/$inspectionId/');
//       print('🔄 Calling API: $url');


//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('📋 API Response Status: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Successfully loaded inspection: $inspectionId');
       
//         // Debug print important data
//         if (data != null) {
//           print('📊 Inspection Data Summary:');
//           print('   Client: ${data['client_name'] ?? 'N/A'}');
//           print('   Industry: ${data['industry_name'] ?? 'N/A'}');
//           print('   Status: ${data['status'] ?? 'N/A'}');
//           print('   Location Points: ${data['total_location_points'] ?? 0}');
         
//           // Print media information
//           if (data['site_photos'] != null) {
//             print('   Photos Count: ${data['site_photos'].length}');
//           }
//           if (data['site_video'] != null) {
//             print('   Has Video: Yes');
//           }
//           if (data['uploaded_documents'] != null) {
//             print('   Documents Count: ${data['uploaded_documents'].length}');
//           }
//         }
       
//         return data;
//       } else if (response.statusCode == 404) {
//         print('❌ Inspection not found: $inspectionId');
//         return null;
//       } else {
//         print('❌ API Error: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Error in getInspectionById: $e');
//       return null;
//     }
//   }


//   // Delete inspection
//   Future<bool> deleteInspection(int inspectionId) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No token found for deletion');
//         return false;
//       }


//       final url = Uri.parse('$baseUrl/inspections/$inspectionId/');
//       print('🔄 Calling DELETE API: $url');


//       final response = await http.delete(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );


//       print('🗑️ Delete Response: ${response.statusCode}');


//       if (response.statusCode == 204) {
//         print('✅ Inspection deleted successfully');
//         return true;
//       } else {
//         print('❌ Delete failed: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Error deleting inspection: $e');
//       return false;
//     }
//   }


//   // Get all inspections for current user (with optional filters)
//   Future<List<dynamic>> getAllInspections({Map<String, String>? filters}) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return [];
//       }


//       String url = '$baseUrl/inspections/';
     
//       // Add filters to URL if provided
//       if (filters != null && filters.isNotEmpty) {
//         final filterParams = filters.entries
//             .where((entry) => entry.value.isNotEmpty)
//             .map((entry) => '${entry.key}=${entry.value}')
//             .join('&');
       
//         if (filterParams.isNotEmpty) {
//           url += '?$filterParams';
//         }
//       }


//       final uri = Uri.parse(url);
//       print('🔄 Calling API: $uri');


//       final response = await http.get(
//         uri,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('📋 API Response Status: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Successfully loaded ${data.length} inspections');
       
//         // Print summary of loaded inspections
//         if (data.isNotEmpty) {
//           print('📊 Loaded Inspections Summary:');
//           for (int i = 0; i < data.length && i < 3; i++) {
//             final inspection = data[i];
//             print('   ${i + 1}. ${inspection['client_name']} - ${inspection['status']}');
//           }
//           if (data.length > 3) {
//             print('   ... and ${data.length - 3} more');
//           }
//         }
       
//         return data;
//       } else {
//         print('❌ API Error: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('❌ Error in getAllInspections: $e');
//       return [];
//     }
//   }


//   // Search inspections by client name or industry
//   Future<List<dynamic>> searchInspections(String query) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return [];
//       }


//       final url = Uri.parse('$baseUrl/inspections/?search=$query');
//       print('🔄 Calling SEARCH API: $url');


//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('🔍 Search Response Status: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Search found ${data.length} inspections for query: $query');
//         return data;
//       } else {
//         print('❌ Search API Error: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('❌ Error in searchInspections: $e');
//       return [];
//     }
//   }


//   // Get inspection counts by different categories
//   Future<Map<String, dynamic>> getInspectionAnalytics() async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return {};
//       }


//       final url = Uri.parse('$baseUrl/inspections/stats/');
//       print('🔄 Calling Analytics API: $url');


//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('📈 Analytics Response Status: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Successfully loaded analytics data');
//         return data;
//       } else {
//         print('❌ Analytics API Error: ${response.statusCode}');
//         return {};
//       }
//     } catch (e) {
//       print('❌ Error in getInspectionAnalytics: $e');
//       return {};
//     }
//   }


//   // Upload documents for inspection
//   Future<bool> uploadInspectionDocuments(int inspectionId, List<String> documentPaths) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No token found for document upload');
//         return false;
//       }


//       final url = Uri.parse('$baseUrl/inspections/$inspectionId/upload_documents/');
//       print('🔄 Calling Document Upload API: $url');
//       print('📎 Uploading ${documentPaths.length} documents');


//       var request = http.MultipartRequest('POST', url);
//       request.headers['Authorization'] = 'Bearer $token';


//       // Add each document to the request
//       for (var path in documentPaths) {
//         var file = await http.MultipartFile.fromPath('documents', path);
//         request.files.add(file);
//       }


//       final response = await request.send();
//       print('📎 Document Upload Response: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         print('✅ Documents uploaded successfully');
//         return true;
//       } else {
//         print('❌ Document upload failed: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Error uploading documents: $e');
//       return false;
//     }
//   }


//   // Get user profile information
//   Future<Map<String, dynamic>?> getUserProfile() async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return null;
//       }


//       final url = Uri.parse('$baseUrl/users/me/');
//       print('🔄 Calling User Profile API: $url');


//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('👤 Profile Response Status: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Successfully loaded user profile');
//         return data;
//       } else {
//         print('❌ Profile API Error: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Error in getUserProfile: $e');
//       return null;
//     }
//   }


//   // Refresh access token
//   Future<String?> refreshToken() async {
//     try {
//       final refreshToken = await _storage.read(key: 'refresh');
//       if (refreshToken == null) {
//         print('❌ No refresh token found');
//         return null;
//       }


//       final url = Uri.parse('$baseUrl/token/refresh/');
//       print('🔄 Calling Token Refresh API: $url');


//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'refresh': refreshToken,
//         }),
//       );


//       print('🔄 Token Refresh Response: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final newAccessToken = data['access'];
       
//         // Save new access token
//         await _storage.write(key: 'access', value: newAccessToken);
//         print('✅ Token refreshed successfully');
//         return newAccessToken;
//       } else {
//         print('❌ Token refresh failed: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Error refreshing token: $e');
//       return null;
//     }
//   }


//   // Check if user is authenticated
//   Future<bool> isAuthenticated() async {
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         return false;
//       }


//       // Optional: Verify token is valid by making a simple API call
//       final url = Uri.parse('$baseUrl/users/me/');
//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       ).timeout(const Duration(seconds: 5));


//       return response.statusCode == 200;
//     } catch (e) {
//       print('❌ Error checking authentication: $e');
//       return false;
//     }
//   }


//   // Logout user
//   Future<void> logout() async {
//     try {
//       await _storage.delete(key: 'access');
//       await _storage.delete(key: 'refresh');
//       await _storage.delete(key: 'branch_name');
//       print('✅ User logged out successfully');
//     } catch (e) {
//       print('❌ Error during logout: $e');
//     }
//   }


//   // NEW: Get branch information
//   Future<String?> getBranchName() async {
//     try {
//       return await _storage.read(key: 'branch_name');
//     } catch (e) {
//       print('❌ Error getting branch name: $e');
//       return null;
//     }
//   }


//   // NEW: Save branch information
//   Future<void> saveBranchName(String branchName) async {
//     try {
//       await _storage.write(key: 'branch_name', value: branchName);
//       print('✅ Branch name saved: $branchName');
//     } catch (e) {
//       print('❌ Error saving branch name: $e');
//     }
//   }


//   // NEW: Validate inspection data before submission
//   bool validateInspectionData(Map<String, dynamic> data) {
//     try {
//       // Check required fields
//       if (data['client_name'] == null || data['client_name'].toString().isEmpty) {
//         print('❌ Validation failed: Client name is required');
//         return false;
//       }


//       if (data['industry_name'] == null || data['industry_name'].toString().isEmpty) {
//         print('❌ Validation failed: Industry name is required');
//         return false;
//       }


//       if (data['branch_name'] == null || data['branch_name'].toString().isEmpty) {
//         print('❌ Validation failed: Branch name is required');
//         return false;
//       }


//       // Check if location data exists
//       if (data['location_points'] == null || data['total_location_points'] == 0) {
//         print('⚠️ Warning: No location data captured');
//       }


//       // Check if photos exist
//       if (data['site_photos'] == null || data['site_photos'].isEmpty) {
//         print('⚠️ Warning: No photos uploaded');
//       }


//       print('✅ Inspection data validation passed');
//       return true;
//     } catch (e) {
//       print('❌ Error validating inspection data: $e');
//       return false;
//     }
//   }


//   // NEW: Get inspection by client name
//   Future<List<dynamic>> getInspectionsByClient(String clientName) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return [];
//       }


//       final url = Uri.parse('$baseUrl/inspections/by_client/?client_name=$clientName');
//       print('🔄 Calling API: $url');


//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('📋 API Response Status: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Successfully loaded ${data.length} inspections for client: $clientName');
//         return data;
//       } else {
//         print('❌ API Error: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('❌ Error in getInspectionsByClient: $e');
//       return [];
//     }
//   }


//   // NEW: Get recent inspections
//   Future<List<dynamic>> getRecentInspections({int limit = 10}) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return [];
//       }


//       final url = Uri.parse('$baseUrl/inspections/recent/?limit=$limit');
//       print('🔄 Calling API: $url');


//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('📋 API Response Status: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Successfully loaded ${data.length} recent inspections');
//         return data;
//       } else {
//         print('❌ API Error: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('❌ Error in getRecentInspections: $e');
//       return [];
//     }
//   }


//   // NEW: Get specific media file from inspection
//   Future<Map<String, dynamic>?> getMediaFile(int inspectionId, String mediaType, int fileIndex) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return null;
//       }


//       final url = Uri.parse('$baseUrl/inspections/$inspectionId/media/$mediaType/$fileIndex/');
//       print('🔄 Calling Media API: $url');


//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('📋 Media API Response Status: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Successfully loaded media file: $mediaType index $fileIndex');
//         return data;
//       } else {
//         print('❌ Media API Error: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Error in getMediaFile: $e');
//       return null;
//     }
//   }


//   // NEW: Convert base64 string to displayable image
//   String getImageFromBase64(String base64String) {
//     try {
//       return base64String;
//     } catch (e) {
//       print('❌ Error converting base64 to image: $e');
//       return '';
//     }
//   }


//   // NEW: Utility to check if base64 data is valid
//   bool isValidBase64(String base64String) {
//     try {
//       base64.decode(base64String);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }


//   // NEW: Get inspection summary
//   Future<Map<String, dynamic>?> getInspectionSummary(int inspectionId) async {
//     try {
//       String? token = await _getToken();
//       if (token == null) {
//         print('❌ No authentication token found');
//         return null;
//       }


//       final url = Uri.parse('$baseUrl/inspections/$inspectionId/summary/');
//       print('🔄 Calling Summary API: $url');


//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));


//       print('📋 API Response Status: ${response.statusCode}');


//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('✅ Successfully loaded inspection summary');
//         return data;
//       } else {
//         print('❌ API Error: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Error in getInspectionSummary: $e');
//       return null;
//     }
//   }
// }


// inspection_service.dart - COMPLETE FIXED VERSION WITH JSON PARSING
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InspectionService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Token নেওয়ার method
  Future<String?> _getToken() async {
    try {
      final token = await _storage.read(key: 'access');
      print('🔑 Token from storage: ${token != null ? "Yes" : "No"}');
      return token;
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }

  // Get inspection statistics for dashboard
  Future<Map<String, dynamic>> getInspectionStats() async {
    try {
      String? token = await _getToken();
      if (token == null) {
        print('❌ No authentication token found');
        return _getDefaultStats();
      }

      final url = Uri.parse('$baseUrl/inspections/stats/');
      print('🔄 Calling Stats API: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📊 Stats API Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Successfully parsed stats data: $data');
        return data;
      } else {
        print('❌ Stats API Error: ${response.statusCode}');
        return _getDefaultStats();
      }
    } catch (e) {
      print('❌ Error in getInspectionStats: $e');
      return _getDefaultStats();
    }
  }

  // Default stats for error cases
  Map<String, dynamic> _getDefaultStats() {
    return {
      'total': 0,
      'pending': 0,
      'in_progress': 0,
      'completed': 0,
      'approved': 0,
      'rejected': 0,
    };
  }

  // Get inspections by status
  Future<List<dynamic>> getInspectionsByStatus(String status) async {
    try {
      String? token = await _getToken();
      if (token == null) {
        print('❌ No authentication token found');
        return [];
      }

      final url = Uri.parse('$baseUrl/inspections/by_status/?status=$status');
      print('🔄 Calling Inspections by Status API: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('📋 Inspections API Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Successfully loaded ${data.length} inspections with status: $status');
        
        return data;
      } else {
        print('❌ Inspections API Error: ${response.statusCode}');
        return await _getAllInspectionsAndFilter(status);
      }
    } catch (e) {
      print('❌ Error in getInspectionsByStatus: $e');
      return [];
    }
  }

  // Fallback method if by_status endpoint fails
  Future<List<dynamic>> _getAllInspectionsAndFilter(String status) async {
    try {
      String? token = await _getToken();
      if (token == null) return [];

      final url = Uri.parse('$baseUrl/inspections/');
      print('🔄 Calling Fallback API: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final allInspections = json.decode(response.body);
        print('✅ Fallback: Loaded ${allInspections.length} total inspections');
        
        List<dynamic> filteredInspections;
        if (status == 'all') {
          filteredInspections = allInspections;
        } else {
          filteredInspections = allInspections.where((inspection) {
            final inspectionStatus = inspection['status']?.toString() ?? '';
            return inspectionStatus.toLowerCase() == status.toLowerCase();
          }).toList();
        }
        
        print('✅ Fallback: Filtered to ${filteredInspections.length} inspections with status: $status');
        return filteredInspections;
      }
      return [];
    } catch (e) {
      print('❌ Error in fallback method: $e');
      return [];
    }
  }

  // Get all inspections for current user
  Future<List<dynamic>> getAllInspections() async {
    return await getInspectionsByStatus('all');
  }

  // Submit new inspection
  Future<bool> submitInspection(Map<String, dynamic> inspectionData) async {
    try {
      String? token = await _getToken();
      if (token == null) {
        print('❌ No token found for submission');
        return false;
      }

      if (!validateInspectionData(inspectionData)) {
        return false;
      }

      print('📤 Submitting inspection data...');

      final response = await http.post(
        Uri.parse('$baseUrl/inspections/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(inspectionData),
      );

      print('📤 Submission Response: ${response.statusCode}');

      if (response.statusCode == 201) {
        print('✅ Inspection submitted successfully');
        return true;
      } else {
        print('❌ Submission failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error submitting inspection: $e');
      return false;
    }
  }

  // Update inspection status
  Future<bool> updateInspectionStatus(int inspectionId, String status) async {
    try {
      String? token = await _getToken();
      if (token == null) {
        print('❌ No token found for status update');
        return false;
      }

      final url = Uri.parse('$baseUrl/inspections/$inspectionId/update_status/');
      print('🔄 Calling Status Update API: $url');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'status': status}),
      );

      print('📝 Update Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Inspection status updated successfully');
        return true;
      } else {
        print('❌ Status update failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating inspection status: $e');
      return false;
    }
  }

  // Update entire inspection
  Future<bool> updateInspection(int inspectionId, Map<String, dynamic> inspectionData) async {
    try {
      String? token = await _getToken();
      if (token == null) {
        print('❌ No token found for update');
        return false;
      }

      final url = Uri.parse('$baseUrl/inspections/$inspectionId/');
      print('🔄 Calling UPDATE API: $url');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(inspectionData),
      );

      print('📝 Update Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Inspection updated successfully');
        return true;
      } else {
        print('❌ Update failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating inspection: $e');
      return false;
    }
  }

  // Get single inspection by ID - IMPROVED WITH JSON PARSING
// Get single inspection by ID - IMPROVED WITH BETTER ERROR HANDLING
Future<Map<String, dynamic>?> getInspectionById(int inspectionId) async {
  try {
    String? token = await _getToken();
    if (token == null) {
      print('❌ No authentication token found');
      return null;
    }

    final url = Uri.parse('$baseUrl/inspections/$inspectionId/');
    print('🔄 Calling Single Inspection API: $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    print('📋 Single Inspection API Response Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Successfully loaded inspection: $inspectionId');
      
      // Parse JSON fields safely with better error handling
      final parsedData = _parseInspectionData(data);
      
      // Debug: Print field types to identify issues
      print('🔍 Field Types Analysis:');
      _debugFieldTypes(parsedData);
      
      print('📊 Inspection Data Summary:');
      print('   Client: ${parsedData['client_name'] ?? 'N/A'}');
      print('   Industry: ${parsedData['industry_name'] ?? 'N/A'}');
      print('   Status: ${parsedData['status'] ?? 'N/A'}');
      print('   Photos: ${parsedData['site_photos'] is List ? parsedData['site_photos'].length : 'N/A'}');
      print('   Location Points: ${parsedData['location_points'] is List ? parsedData['location_points'].length : 'N/A'}');
      
      return parsedData;
    } else {
      print('❌ Single Inspection API Error: ${response.statusCode}');
      print('❌ Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('❌ Error in getInspectionById: $e');
    return null;
  }
}

// NEW: Debug method to check field types
void _debugFieldTypes(Map<String, dynamic> data) {
  final criticalFields = [
    'site_photos', 'site_video', 'uploaded_documents', 
    'location_points', 'partners_directors', 'competitors',
    'key_employees', 'working_capital_items', 'checklist_items'
  ];
  
  for (var field in criticalFields) {
    final value = data[field];
    print('   $field: ${value.runtimeType} - $value');
  }
}
  // NEW METHOD: Safely parse inspection data with JSON fields
// NEW METHOD: Safely parse inspection data with JSON fields - FIXED VERSION
Map<String, dynamic> _parseInspectionData(Map<String, dynamic> data) {
  try {
    // Helper function to parse JSON fields safely
    dynamic parseField(dynamic fieldData) {
      if (fieldData == null) {
        // Return appropriate default based on expected type
        return null;
      }
      
      // If it's already a List or Map, return as is
      if (fieldData is List) return fieldData;
      if (fieldData is Map) return fieldData;
      
      // If it's a string, try to parse as JSON
      if (fieldData is String) {
        try {
          // Check if it's a JSON string
          if (fieldData.trim().startsWith('[') || fieldData.trim().startsWith('{')) {
            final parsed = json.decode(fieldData);
            return parsed;
          } else {
            // If it's not valid JSON format, return the string as is
            return fieldData;
          }
        } catch (e) {
          print('⚠️ JSON parse error for field (returning as string): $e');
          // If parsing fails, return the original string
          return fieldData;
        }
      }
      
      // For any other type, return as is
      return fieldData;
    }

    // Parse all fields that might be stored as JSON strings
    return {
      ...data,
      'site_photos': parseField(data['site_photos']) ?? [],
      'site_video': parseField(data['site_video']),
      'uploaded_documents': parseField(data['uploaded_documents']) ?? [],
      'location_points': parseField(data['location_points']) ?? [],
      'partners_directors': parseField(data['partners_directors']) ?? [],
      'competitors': parseField(data['competitors']) ?? [],
      'key_employees': parseField(data['key_employees']) ?? [],
      'working_capital_items': parseField(data['working_capital_items']) ?? [],
      'checklist_items': parseField(data['checklist_items']) ?? {},
    };
  } catch (e) {
    print('❌ Error parsing inspection data: $e');
    // Return original data if parsing fails, but ensure critical fields exist
    return {
      ...data,
      'site_photos': data['site_photos'] is List ? data['site_photos'] : [],
      'site_video': data['site_video'] is Map ? data['site_video'] : null,
      'uploaded_documents': data['uploaded_documents'] is List ? data['uploaded_documents'] : [],
      'location_points': data['location_points'] is List ? data['location_points'] : [],
      'partners_directors': data['partners_directors'] is List ? data['partners_directors'] : [],
      'competitors': data['competitors'] is List ? data['competitors'] : [],
      'key_employees': data['key_employees'] is List ? data['key_employees'] : [],
      'working_capital_items': data['working_capital_items'] is List ? data['working_capital_items'] : [],
      'checklist_items': data['checklist_items'] is Map ? data['checklist_items'] : {},
    };
  }
}
  // Delete inspection
  Future<bool> deleteInspection(int inspectionId) async {
    try {
      String? token = await _getToken();
      if (token == null) {
        print('❌ No token found for deletion');
        return false;
      }

      final url = Uri.parse('$baseUrl/inspections/$inspectionId/');
      print('🔄 Calling DELETE API: $url');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🗑️ Delete Response: ${response.statusCode}');

      if (response.statusCode == 204) {
        print('✅ Inspection deleted successfully');
        return true;
      } else {
        print('❌ Delete failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting inspection: $e');
      return false;
    }
  }

  // Get assigned inspections (for AssignedInspectionsScreen)
  Future<List<dynamic>> getAssignedInspections() async {
    try {
      String? token = await _getToken();
      if (token == null) {
        print('❌ No authentication token found');
        return [];
      }

      final url = Uri.parse('$baseUrl/new-inspections/list/');
      print('🔄 Calling Assigned Inspections API: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📋 Assigned Inspections Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Successfully loaded ${data.length} assigned inspections');
        return data;
      } else {
        print('❌ Assigned Inspections API Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error in getAssignedInspections: $e');
      return [];
    }
  }

  // Get current user info
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      String? token = await _getToken();
      if (token == null) {
        print('❌ No authentication token found');
        return null;
      }

      final url = Uri.parse('$baseUrl/current-user/');
      print('🔄 Calling Current User API: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('👤 Current User Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Successfully loaded current user data');
        return data;
      } else {
        print('❌ Current User API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error in getCurrentUser: $e');
      return null;
    }
  }

  // Validate inspection data before submission
  bool validateInspectionData(Map<String, dynamic> data) {
    try {
      if (data['client_name'] == null || data['client_name'].toString().isEmpty) {
        print('❌ Validation failed: Client name is required');
        return false;
      }

      if (data['industry_name'] == null || data['industry_name'].toString().isEmpty) {
        print('❌ Validation failed: Industry name is required');
        return false;
      }

      print('✅ Inspection data validation passed');
      return true;
    } catch (e) {
      print('❌ Error validating inspection data: $e');
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _storage.delete(key: 'access');
      await _storage.delete(key: 'refresh');
      await _storage.delete(key: 'branch_name');
      print('✅ User logged out successfully');
    } catch (e) {
      print('❌ Error during logout: $e');
    }
  }

  // NEW: Refresh token method
  Future<String?> refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh');
      if (refreshToken == null) {
        print('❌ No refresh token found');
        return null;
      }

      final url = Uri.parse('$baseUrl/token/refresh/');
      print('🔄 Calling Token Refresh API: $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'refresh': refreshToken,
        }),
      );

      print('🔄 Token Refresh Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newAccessToken = data['access'];
       
        await _storage.write(key: 'access', value: newAccessToken);
        print('✅ Token refreshed successfully');
        return newAccessToken;
      } else {
        print('❌ Token refresh failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error refreshing token: $e');
      return null;
    }
  }

  // NEW: Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return false;
      }

      final url = Uri.parse('$baseUrl/current-user/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error checking authentication: $e');
      return false;
    }
  }

  // NEW: Search inspections
  Future<List<dynamic>> searchInspections(String query) async {
    try {
      String? token = await _getToken();
      if (token == null) {
        print('❌ No authentication token found');
        return [];
      }

      final url = Uri.parse('$baseUrl/inspections/?search=$query');
      print('🔄 Calling SEARCH API: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('🔍 Search Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Search found ${data.length} inspections for query: $query');
        return data;
      } else {
        print('❌ Search API Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error in searchInspections: $e');
      return [];
    }
  }
}