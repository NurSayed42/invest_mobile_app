// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../services/inspection_service.dart';
// import 'inspection_detail_screen.dart';

// class InspectionsListScreen extends StatefulWidget {
//   final String filterStatus;

//   const InspectionsListScreen({super.key, required this.filterStatus});

//   @override
//   State<InspectionsListScreen> createState() => _InspectionsListScreenState();
// }

// class _InspectionsListScreenState extends State<InspectionsListScreen> {
//   final InspectionService _inspectionService = InspectionService();
//   final storage = const FlutterSecureStorage();
  
//   List<dynamic> inspections = [];
//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadInspections();
//   }

//   Future<void> _loadInspections() async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });

//       final inspectionsData = await _inspectionService.getInspectionsByStatus(widget.filterStatus);
      
//       setState(() {
//         inspections = inspectionsData;
//         isLoading = false;
//       });
      
//       print('✅ Inspections loaded: ${inspections.length} items');
//     } catch (e) {
//       print('❌ Error loading inspections: $e');
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Failed to load inspections';
//       });
//     }
//   }

//   String _getStatusColor(String status) {
//     switch (status) {
//       case 'Approved':
//         return '0xFF4CAF50'; // Green
//       case 'Rejected':
//         return '0xFFF44336'; // Red
//       case 'Pending':
//         return '0xFFFF9800'; // Orange
//       case 'In Progress':
//         return '0xFF2196F3'; // Blue
//       case 'Completed':
//         return '0xFF9C27B0'; // Purple
//       default:
//         return '0xFF757575'; // Grey
//     }
//   }

//   String _getStatusDisplayText(String status) {
//     if (widget.filterStatus == 'all') {
//       return 'All Inspections';
//     }
//     return '$status Inspections';
//   }

//   void _navigateToDetail(Map<String, dynamic> inspection) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => InspectionDetailScreen(
//           inspection: inspection,
//           onUpdate: _loadInspections,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FFF9),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF116045),
//         title: Text(
//           _getStatusDisplayText(widget.filterStatus),
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _loadInspections,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage != null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         errorMessage!,
//                         style: const TextStyle(fontSize: 16, color: Colors.red),
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: _loadInspections,
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : inspections.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.inbox, size: 64, color: Colors.grey),
//                           const SizedBox(height: 16),
//                           Text(
//                             'No ${widget.filterStatus == 'all' ? '' : widget.filterStatus} inspections found',
//                             style: const TextStyle(fontSize: 18, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: inspections.length,
//                       itemBuilder: (context, index) {
//                         final inspection = inspections[index];
//                         final status = inspection['status'] ?? 'Unknown';
//                         final colorHex = _getStatusColor(status);
//                         final color = Color(int.parse(colorHex));

//                         return Card(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           elevation: 2,
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.all(16),
//                             leading: Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: color.withOpacity(0.2),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 _getStatusIcon(status),
//                                 color: color,
//                                 size: 24,
//                               ),
//                             ),
//                             title: Text(
//                               inspection['client_name'] ?? 'Unnamed Client',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Industry: ${inspection['industry_name'] ?? 'N/A'}',
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Text(
//                                   'Branch: ${inspection['branch_name'] ?? 'N/A'}',
//                                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                       decoration: BoxDecoration(
//                                         color: color.withOpacity(0.1),
//                                         borderRadius: BorderRadius.circular(4),
//                                         border: Border.all(color: color),
//                                       ),
//                                       child: Text(
//                                         status,
//                                         style: TextStyle(
//                                           color: color,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.visibility, color: Color(0xFF116045)),
//                               onPressed: () => _navigateToDetail(inspection),
//                               tooltip: 'View Details',
//                             ),
//                             onTap: () => _navigateToDetail(inspection),
//                           ),
//                         );
//                       },
//                     ),
//     );
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case 'Approved':
//         return Icons.verified;
//       case 'Rejected':
//         return Icons.cancel;
//       case 'Pending':
//         return Icons.pending;
//       case 'In Progress':
//         return Icons.settings;
//       case 'Completed':
//         return Icons.task_alt;
//       default:
//         return Icons.assignment;
//     }
//   }
// }

import 'package:flutter/material.dart';
import '../services/inspection_service.dart';
import 'inspection_detail_screen.dart';

class InspectionsListScreen extends StatefulWidget {
  final String filterStatus;

  const InspectionsListScreen({super.key, required this.filterStatus});

  @override
  State<InspectionsListScreen> createState() => _InspectionsListScreenState();
}

class _InspectionsListScreenState extends State<InspectionsListScreen> {
  final InspectionService _inspectionService = InspectionService();
  
  List<dynamic> inspections = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInspections();
  }

  Future<void> _loadInspections() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      print('🔄 Loading inspections with status: ${widget.filterStatus}');

      final inspectionsData = await _inspectionService.getInspectionsByStatus(widget.filterStatus);
      
      setState(() {
        inspections = inspectionsData;
        isLoading = false;
      });
      
      print('✅ Inspections loaded: ${inspections.length} items');
    } catch (e) {
      print('❌ Error loading inspections: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load inspections: ${e.toString()}';
      });
    }
  }

  String _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return '0xFF4CAF50'; // Green
      case 'Rejected':
        return '0xFFF44336'; // Red
      case 'Pending':
        return '0xFFFF9800'; // Orange
      case 'In Progress':
        return '0xFF2196F3'; // Blue
      case 'Completed':
        return '0xFF9C27B0'; // Purple
      default:
        return '0xFF757575'; // Grey
    }
  }

  String _getStatusDisplayText(String status) {
    if (status == 'all') {
      return 'All Inspections';
    }
    return '$status Inspections';
  }

  void _navigateToDetail(Map<String, dynamic> inspection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InspectionDetailScreen(
          inspection: inspection,
          onUpdate: _loadInspections,
        ),
      ),
    );
  }

  Widget _buildInspectionCard(Map<String, dynamic> inspection, int index) {
    final status = inspection['status'] ?? 'Unknown';
    final colorHex = _getStatusColor(status);
    final color = Color(int.parse(colorHex));

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatusIcon(status),
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          inspection['client_name']?.toString() ?? 'Unnamed Client',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Industry: ${inspection['industry_name']?.toString() ?? 'N/A'}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              'Branch: ${inspection['branch_name']?.toString() ?? 'N/A'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.visibility, color: Color(0xFF116045)),
          onPressed: () => _navigateToDetail(inspection),
          tooltip: 'View Details',
        ),
        onTap: () => _navigateToDetail(inspection),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Approved':
        return Icons.verified;
      case 'Rejected':
        return Icons.cancel;
      case 'Pending':
        return Icons.pending;
      case 'In Progress':
        return Icons.settings;
      case 'Completed':
        return Icons.task_alt;
      default:
        return Icons.assignment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF116045),
        title: Text(
          _getStatusDisplayText(widget.filterStatus),
          style: const TextStyle(
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
            onPressed: _loadInspections,
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
                  Text('Loading inspections...'),
                ],
              ),
            )
          : errorMessage != null
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
                          errorMessage!,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadInspections,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF116045),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : inspections.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inbox, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No ${widget.filterStatus == 'all' ? '' : widget.filterStatus} inspections found',
                            style: const TextStyle(
                              fontSize: 18, 
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'There are no inspections in this category',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadInspections,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        itemCount: inspections.length,
                        itemBuilder: (context, index) {
                          return _buildInspectionCard(inspections[index], index);
                        },
                      ),
                    ),
    );
  }
}