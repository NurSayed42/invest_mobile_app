import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/inspection_service.dart';
import 'create_inspection_screen.dart';

class InspectionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> inspection;
  final VoidCallback onUpdate;

  const InspectionDetailScreen({
    super.key,
    required this.inspection,
    required this.onUpdate,
  });

  @override
  State<InspectionDetailScreen> createState() => _InspectionDetailScreenState();
}

class _InspectionDetailScreenState extends State<InspectionDetailScreen> {
  final InspectionService _inspectionService = InspectionService();
  bool isLoading = false;
  bool _showAllLocations = false;

  // Helper method to safely get list data
  List<dynamic> _getSafeList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is String) {
      try {
        return json.decode(data);
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  // Helper method to safely get map data
  Map<String, dynamic> _getSafeMap(dynamic data) {
    if (data == null) return {};
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      try {
        return Map<String, dynamic>.from(json.decode(data));
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  // Navigate to edit form with existing data
  void _navigateToEditForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateInspectionScreen(
          inspectionData: widget.inspection,
          isEditMode: true,
        ),
      ),
    ).then((result) {
      if (result == true) {
        widget.onUpdate();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inspection updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    });
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF116045),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF116045),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isImportant = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF116045),
                fontSize: isImportant ? 14 : 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: TextStyle(
                fontSize: isImportant ? 14 : 13,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(status), size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Location Tracking Section
  Widget _buildLocationSection() {
    final inspection = widget.inspection;
    
    final locationPoints = _getSafeList(inspection['location_points']);
    final totalPoints = inspection['total_location_points'] ?? locationPoints.length;
    final startTime = inspection['location_start_time'];
    final endTime = inspection['location_end_time'];
    
    if (locationPoints.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Location Tracking Data'),
        _buildInfoCard('Location Summary', [
          _buildInfoRow('Total Points Captured', totalPoints.toString()),
          _buildInfoRow('Tracking Started', _formatDateTime(startTime)),
          _buildInfoRow('Tracking Ended', _formatDateTime(endTime)),
          const SizedBox(height: 12),
          
          // First and Last Location
          if (locationPoints.isNotEmpty) ...[
            const Text(
              'Location Points:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF116045),
              ),
            ),
            const SizedBox(height: 8),
            _buildLocationPoint('First Location', locationPoints.first),
            const SizedBox(height: 8),
            _buildLocationPoint('Last Location', locationPoints.last),
            const SizedBox(height: 12),
          ],
          
          // Toggle to show all locations
          if (locationPoints.length > 2) ...[
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showAllLocations = !_showAllLocations;
                });
              },
              icon: Icon(_showAllLocations ? Icons.visibility_off : Icons.visibility),
              label: Text(_showAllLocations ? 'Hide All Locations' : 'Show All Locations'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF116045),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
          ],
          
          // All locations (if toggled)
          if (_showAllLocations && locationPoints.length > 2) ...[
            const Text(
              'All Location Points:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF116045),
              ),
            ),
            const SizedBox(height: 8),
            ...locationPoints.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;
              return _buildLocationPoint('Point ${index + 1}', point);
            }),
          ],
          
          // Map View Buttons
          const SizedBox(height: 12),
          const Text(
            'View on Map:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF116045),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openInteractiveMap,
                  icon: const Icon(Icons.map),
                  label: const Text('Interactive Map'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openGoogleMaps,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Google Maps'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ],
    );
  }

  Widget _buildLocationPoint(String label, dynamic point) {
    final latitude = point['latitude']?.toStringAsFixed(6) ?? 'N/A';
    final longitude = point['longitude']?.toStringAsFixed(6) ?? 'N/A';
    final timestamp = point['timestamp'] ?? '';
    final accuracy = point['accuracy']?.toStringAsFixed(2) ?? 'N/A';
    final speed = point['speed']?.toStringAsFixed(2) ?? 'N/A';
    
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xFF116045),
            ),
          ),
          const SizedBox(height: 4),
          _buildCompactInfoRow('Coordinates', '$latitude, $longitude'),
          _buildCompactInfoRow('Accuracy', '$accuracy meters'),
          if (speed != 'N/A' && double.parse(speed) > 0)
            _buildCompactInfoRow('Speed', '$speed m/s'),
          _buildCompactInfoRow('Time', _formatDateTime(timestamp)),
        ],
      ),
    );
  }

  Widget _buildCompactInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openInteractiveMap() {
    final locationPoints = _getSafeList(widget.inspection['location_points']);
    if (locationPoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No location data available to show on map'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapViewScreen(
          locationPoints: locationPoints,
          inspection: widget.inspection,
        ),
      ),
    );
  }

  void _openGoogleMaps() {
    final locationPoints = _getSafeList(widget.inspection['location_points']);
    if (locationPoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No location data available to show on map'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Open first location in Google Maps
    final firstPoint = locationPoints.first;
    final lat = firstPoint['latitude'];
    final lng = firstPoint['longitude'];
    
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid location coordinates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    _launchURL(url);
  }

  Future<void> _launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch Google Maps'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Section K: Checklist
  Widget _buildSectionK() {
    final inspection = widget.inspection;
    
    final checklistItems = _getSafeMap(inspection['checklist_items']);
    if (checklistItems.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('K. Checklist'),
        _buildInfoCard('Checklist Verification', _buildChecklistItems(checklistItems)),
      ],
    );
  }

  List<Widget> _buildChecklistItems(Map<String, dynamic> checklistItems) {
    List<Widget> items = [];
    
    checklistItems.forEach((key, value) {
      items.add(_buildChecklistRow(key, value));
    });
    
    return items;
  }

  Widget _buildChecklistRow(String label, dynamic value) {
    String statusText;
    Color statusColor;
    IconData statusIcon;
    
    if (value == true) {
      statusText = 'Yes';
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (value == false) {
      statusText = 'No';
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusText = 'N/A';
      statusColor = Colors.orange;
      statusIcon = Icons.help;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 14, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section L: Site Photos & Video
  Widget _buildSectionL() {
    final inspection = widget.inspection;
    
    final sitePhotos = _getSafeList(inspection['site_photos']);
    final siteVideo = _getSafeMap(inspection['site_video']);
    
    if (sitePhotos.isEmpty && siteVideo.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('L. Site Photos & Video Documentation'),
        _buildInfoCard('Media Documentation', [
          if (sitePhotos.isNotEmpty) ...[
            _buildInfoRow('Site Photos', '${sitePhotos.length} photos uploaded'),
            const SizedBox(height: 12),
            _buildPhotosGrid(sitePhotos),
            const SizedBox(height: 16),
          ],
          
          if (siteVideo.isNotEmpty && siteVideo['base64_data'] != null) ...[
            _buildInfoRow('Site Video', '1 video uploaded'),
            const SizedBox(height: 12),
            _buildVideoPreview(siteVideo),
            const SizedBox(height: 8),
          ],
        ]),
      ],
    );
  }

  Widget _buildPhotosGrid(List<dynamic> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Site Photos:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF116045),
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            return GestureDetector(
              onTap: () => _showPhotoFullScreen(photo, index, photos),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                  color: Colors.grey[100],
                ),
                child: _buildPhotoThumbnail(photo, index),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPhotoThumbnail(dynamic photo, int index) {
    final base64Data = photo['base64_data'];
    
    if (base64Data != null && base64Data is String && base64Data.isNotEmpty) {
      try {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            base64Decode(base64Data),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderThumbnail('Photo ${index + 1}', Icons.photo);
            },
          ),
        );
      } catch (e) {
        return _buildPlaceholderThumbnail('Photo ${index + 1}', Icons.photo);
      }
    } else {
      return _buildPlaceholderThumbnail('Photo ${index + 1}', Icons.photo);
    }
  }

  Widget _buildVideoPreview(Map<String, dynamic> video) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Site Video:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF116045),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showVideoFullScreen(video),
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.grey[100],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.videocam, size: 40, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  video['file_name'] ?? 'Site Video',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (video['file_size'] != null)
                  Text(
                    _formatFileSize(video['file_size']),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderThumbnail(String title, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showPhotoFullScreen(dynamic photo, int currentIndex, List<dynamic> allPhotos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewScreen(
          photos: allPhotos,
          initialIndex: currentIndex,
        ),
      ),
    );
  }

  void _showVideoFullScreen(Map<String, dynamic> video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoViewScreen(
          video: video,
        ),
      ),
    );
  }

  void _showPhotoInfo(dynamic photo, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Photo ${index + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photo['description'] != null)
              Text('Description: ${photo['description']}'),
            if (photo['file_size'] != null)
              Text('Size: ${_formatFileSize(photo['file_size'])}'),
            if (photo['uploaded_at'] != null)
              Text('Uploaded: ${_formatDate(photo['uploaded_at'])}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVideoInfo(Map<String, dynamic> video) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(video['file_name'] ?? 'Site Video'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (video['description'] != null)
              Text('Description: ${video['description']}'),
            if (video['file_size'] != null)
              Text('Size: ${_formatFileSize(video['file_size'])}'),
            if (video['uploaded_at'] != null)
              Text('Uploaded: ${_formatDate(video['uploaded_at'])}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(dynamic size) {
    if (size == null) return 'Unknown size';
    
    final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = (log(bytes) / log(1024)).floor();
    
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  // Section M: Documents Upload - FIXED VERSION
  Widget _buildSectionM() {
    final inspection = widget.inspection;
    final documents = _getSafeList(inspection['uploaded_documents']);
    
    if (documents.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('M. Supporting Documents'),
        _buildInfoCard('Uploaded Documents', [
          _buildInfoRow('Total Documents', '${documents.length} documents uploaded'),
          const SizedBox(height: 12),
          ...documents.asMap().entries.map((entry) => 
            _buildDocumentItem(entry.value, entry.key)
          ),
        ]),
      ],
    );
  }

  Widget _buildDocumentItem(Map<String, dynamic> doc, int index) {
    final fileName = doc['name'] ?? 'Document ${index + 1}';
    final filePath = doc['file_path'] ?? '';
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: _getDocumentIcon(fileName),
        title: Text(fileName),
        subtitle: Text(
          filePath.isNotEmpty ? 'Tap to view document' : 'No file path available'
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              onPressed: () => _showDocumentFullScreen(doc, index),
              tooltip: 'View Document',
            ),
            IconButton(
              icon: const Icon(Icons.info, color: Colors.green),
              onPressed: () => _showDocumentInfo(doc, index),
              tooltip: 'Document Info',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDocumentIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, color: Colors.red, size: 30);
      case 'doc':
      case 'docx':
        return const Icon(Icons.description, color: Colors.blue, size: 30);
      case 'jpg':
      case 'jpeg':
      case 'png':
        return const Icon(Icons.photo, color: Colors.green, size: 30);
      case 'mp4':
      case 'avi':
      case 'mov':
        return const Icon(Icons.videocam, color: Colors.purple, size: 30);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.grey, size: 30);
    }
  }

  void _showDocumentFullScreen(Map<String, dynamic> doc, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewScreen(
          document: doc,
          index: index,
        ),
      ),
    );
  }

  void _showDocumentInfo(Map<String, dynamic> doc, int index) {
    final fileName = doc['name'] ?? 'Document ${index + 1}';
    final filePath = doc['file_path'] ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(fileName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${_getDocumentType(fileName)}'),
            if (filePath.isNotEmpty)
              Text('Path: $filePath'),
            if (doc['file_size'] != null)
              Text('Size: ${_formatFileSize(doc['file_size'])}'),
            if (doc['upload_date'] != null)
              Text('Uploaded: ${_formatDate(doc['upload_date'])}'),
            if (doc['description'] != null)
              Text('Description: ${doc['description']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getDocumentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return 'PDF Document';
      case 'doc':
      case 'docx':
        return 'Word Document';
      case 'jpg':
      case 'jpeg':
        return 'JPEG Image';
      case 'png':
        return 'PNG Image';
      case 'mp4':
      case 'avi':
      case 'mov':
        return 'Video File';
      default:
        return 'File';
    }
  }

  // Section I: Working Capital Assessment
  Widget _buildSectionI() {
    final inspection = widget.inspection;
    final workingCapitalItems = _getSafeList(inspection['working_capital_items']);
    
    if (workingCapitalItems.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('I. Working Capital Assessment'),
        _buildInfoCard('Working Capital Items', [
          for (var item in workingCapitalItems)
            _buildInfoRow(
              item['name'] ?? 'Item', 
              'Unit: ${item['unit'] ?? ''}, Rate: ${item['rate'] ?? ''}, Amount: ${item['amount'] ?? ''}'
            ),
        ]),
      ],
    );
  }

@override
  Widget build(BuildContext context) {
    final inspection = widget.inspection;
    final currentStatus = inspection['status'] ?? 'Unknown';

    // SAFELY GET ALL LISTS HERE - BEFORE BUILD
    final locationPoints = _getSafeList(inspection['location_points']);
    final sitePhotos = _getSafeList(inspection['site_photos']);
    final siteVideo = _getSafeMap(inspection['site_video']);
    final uploadedDocuments = _getSafeList(inspection['uploaded_documents']);
    final workingCapitalItems = _getSafeList(inspection['working_capital_items']);
    final checklistItems = _getSafeMap(inspection['checklist_items']);
    final partnersDirectors = _getSafeList(inspection['partners_directors']);
    final competitors = _getSafeList(inspection['competitors']);
    final keyEmployees = _getSafeList(inspection['key_employees']);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF116045),
        title: const Text(
          'Inspection Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToEditForm,
        backgroundColor: const Color(0xFF116045),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card with Basic Info
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _getStatusIcon(currentStatus),
                                size: 40,
                                color: _getStatusColor(currentStatus),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Client Name with label
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Client Name: ",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          TextSpan(
                                            text: inspection['client_name'] ?? 'Unnamed Client',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF116045),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Company Name with label
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Company: ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          TextSpan(
                                            text: inspection['company_name'] ?? 'No Company',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Status Badge - First line
                                    _buildStatusBadge(currentStatus),
                                    const SizedBox(height: 12),
                                    // Edit Button - Second line (half width)
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.5, // 50% width
                                      child: ElevatedButton.icon(
                                        onPressed: _navigateToEditForm,
                                        icon: const Icon(Icons.edit),
                                        label: const Text('Edit Inspection'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF116045),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Location Tracking Section - Added at the top
                  _buildLocationSection(),

                  // Section A: Company's Client's Information
                  _buildSectionTitle('A. Company\'s Client\'s Information'),
                  _buildInfoCard('Basic Information', [
                    _buildInfoRow('Client Name', inspection['client_name'] ?? '', isImportant: true),
                    _buildInfoRow('Group Name', inspection['group_name'] ?? ''),
                    _buildInfoRow('Industry Name', inspection['industry_name'] ?? ''),
                    _buildInfoRow('Nature of Business', inspection['nature_of_business'] ?? ''),
                    _buildInfoRow('Legal Status', inspection['legal_status'] ?? ''),
                    _buildInfoRow('Date of Establishment', inspection['date_of_establishment'] ?? ''),
                  ]),

                  _buildInfoCard('Address Information', [
                    _buildInfoRow('Office Address', inspection['office_address'] ?? ''),
                    _buildInfoRow('Showroom Address', inspection['showroom_address'] ?? ''),
                    _buildInfoRow('Factory Address', inspection['factory_address'] ?? ''),
                  ]),

                  _buildInfoCard('Contact & Registration', [
                    _buildInfoRow('Phone Number', inspection['phone_number'] ?? ''),
                    _buildInfoRow('Account Number', inspection['account_number'] ?? ''),
                    _buildInfoRow('Account ID', inspection['account_id'] ?? ''),
                    _buildInfoRow('TIN Number', inspection['tin_number'] ?? ''),
                    _buildInfoRow('Date of Opening', inspection['date_of_opening'] ?? ''),
                    _buildInfoRow('VAT Reg Number', inspection['vat_reg_number'] ?? ''),
                    _buildInfoRow('First Investment Date', inspection['first_investment_date'] ?? ''),
                    _buildInfoRow('Sector Code', inspection['sector_code'] ?? ''),
                    _buildInfoRow('Trade License', inspection['trade_license'] ?? ''),
                    _buildInfoRow('Economic Purpose Code', inspection['economic_purpose_code'] ?? ''),
                    _buildInfoRow('Investment Category', inspection['investment_category'] ?? ''),
                  ]),

                  // Section B: Owner Information
                  _buildSectionTitle('B. Owner Information'),
                  _buildInfoCard('Personal Information', [
                    _buildInfoRow('Owner Name', inspection['owner_name'] ?? '', isImportant: true),
                    _buildInfoRow('Owner Age', inspection['owner_age'] ?? ''),
                    _buildInfoRow('Father Name', inspection['father_name'] ?? ''),
                    _buildInfoRow('Mother Name', inspection['mother_name'] ?? ''),
                    _buildInfoRow('Spouse Name', inspection['spouse_name'] ?? ''),
                    _buildInfoRow('Academic Qualification', inspection['academic_qualification'] ?? ''),
                    _buildInfoRow('Children Info', inspection['children_info'] ?? ''),
                    _buildInfoRow('Business Successor', inspection['business_successor'] ?? ''),
                  ]),

                  _buildInfoCard('Address', [
                    _buildInfoRow('Residential Address', inspection['residential_address'] ?? ''),
                    _buildInfoRow('Permanent Address', inspection['permanent_address'] ?? ''),
                  ]),

                  // Section C: Partners/Directors - FIXED
                  if (partnersDirectors.isNotEmpty) _buildSectionTitle('C. Partners/Directors'),
                  if (partnersDirectors.isNotEmpty)
                    _buildInfoCard('Partners & Directors', [
                      for (var partner in partnersDirectors)
                        Column(
                          children: [
                            _buildInfoRow('Name', partner['name'] ?? 'N/A'),
                            _buildInfoRow('Age', partner['age'] ?? 'N/A'),
                            _buildInfoRow('Qualification', partner['qualification'] ?? 'N/A'),
                            _buildInfoRow('Share', partner['share'] ?? 'N/A'),
                            _buildInfoRow('Status', partner['status'] ?? 'N/A'),
                            _buildInfoRow('Relationship', partner['relationship'] ?? 'N/A'),
                            const Divider(),
                          ],
                        ),
                    ]),

                  // Section D: Purpose
                  _buildSectionTitle('D. Purpose'),
                  _buildInfoCard('Investment Purpose', [
                    _buildInfoRow('Purpose of Investment', inspection['purpose_investment'] ?? ''),
                    _buildInfoRow('Purpose of Bank Guarantee', inspection['purpose_bank_guarantee'] ?? ''),
                    _buildInfoRow('Period of Investment', inspection['period_investment'] ?? ''),
                  ]),

                  // Section E: Proposed Facilities
                  _buildSectionTitle('E. Proposed Facilities'),
                  _buildInfoCard('Facility Details', [
                    _buildInfoRow('Facility Type', inspection['facility_type'] ?? ''),
                    _buildInfoRow('Existing Limit', inspection['existing_limit'] ?? ''),
                    _buildInfoRow('Applied Limit', inspection['applied_limit'] ?? ''),
                    _buildInfoRow('Recommended Limit', inspection['recommended_limit'] ?? ''),
                    _buildInfoRow('Bank Percentage', inspection['bank_percentage'] ?? ''),
                    _buildInfoRow('Client Percentage', inspection['client_percentage'] ?? ''),
                  ]),

                  // Section F: Present Outstanding
                  _buildSectionTitle('F. Present Outstanding'),
                  _buildInfoCard('Outstanding Details', [
                    _buildInfoRow('Outstanding Type', inspection['outstanding_type'] ?? ''),
                    _buildInfoRow('Limit Amount', inspection['limit_amount'] ?? ''),
                    _buildInfoRow('Net Outstanding', inspection['net_outstanding'] ?? ''),
                    _buildInfoRow('Gross Outstanding', inspection['gross_outstanding'] ?? ''),
                  ]),

                  // Section G: Business Analysis
                  _buildSectionTitle('G. Business Analysis'),
                  _buildInfoCard('Market Analysis', [
                    _buildInfoRow('Market Situation', inspection['market_situation'] ?? ''),
                    _buildInfoRow('Client Position', inspection['client_position'] ?? ''),
                    _buildInfoRow('Business Reputation', inspection['business_reputation'] ?? ''),
                    _buildInfoRow('Production Type', inspection['production_type'] ?? ''),
                    _buildInfoRow('Product Name', inspection['product_name'] ?? ''),
                    _buildInfoRow('Production Capacity', inspection['production_capacity'] ?? ''),
                    _buildInfoRow('Actual Production', inspection['actual_production'] ?? ''),
                    _buildInfoRow('Profitability Observation', inspection['profitability_observation'] ?? ''),
                  ]),

                  // Competitors - FIXED
                  if (competitors.isNotEmpty)
                    _buildInfoCard('Competitors Analysis', [
                      for (var competitor in competitors)
                        if (competitor['name'] != null && competitor['name'].toString().isNotEmpty)
                          Column(
                            children: [
                              _buildInfoRow('Competitor Name', competitor['name'] ?? ''),
                              _buildInfoRow('Address', competitor['address'] ?? ''),
                              _buildInfoRow('Market Share', competitor['market_share'] ?? ''),
                              const Divider(),
                            ],
                          ),
                    ]),

                  // Labor Force
                  _buildInfoCard('Labor Force', [
                    _buildInfoRow('Male Officer', inspection['male_officer'] ?? ''),
                    _buildInfoRow('Female Officer', inspection['female_officer'] ?? ''),
                    _buildInfoRow('Skilled Officer', inspection['skilled_officer'] ?? ''),
                    _buildInfoRow('Unskilled Officer', inspection['unskilled_officer'] ?? ''),
                    _buildInfoRow('Male Worker', inspection['male_worker'] ?? ''),
                    _buildInfoRow('Female Worker', inspection['female_worker'] ?? ''),
                    _buildInfoRow('Skilled Worker', inspection['skilled_worker'] ?? ''),
                    _buildInfoRow('Unskilled Worker', inspection['unskilled_worker'] ?? ''),
                  ]),

                  // Key Employees - FIXED
                  if (keyEmployees.isNotEmpty)
                    _buildInfoCard('Key Employees', [
                      for (var employee in keyEmployees)
                        Column(
                          children: [
                            _buildInfoRow('Name', employee['name'] ?? 'N/A'),
                            _buildInfoRow('Designation', employee['designation'] ?? 'N/A'),
                            _buildInfoRow('Age', employee['age'] ?? 'N/A'),
                            _buildInfoRow('Qualification', employee['qualification'] ?? 'N/A'),
                            _buildInfoRow('Experience', employee['experience'] ?? 'N/A'),
                            const Divider(),
                          ],
                        ),
                    ]),

                  // Section H: Property & Assets
                  _buildSectionTitle('H. Property & Assets'),
                  _buildInfoCard('Current Assets', [
                    _buildInfoRow('Cash Balance', inspection['cash_balance'] ?? ''),
                    _buildInfoRow('Stock Trade Finished', inspection['stock_trade_finished'] ?? ''),
                    _buildInfoRow('Stock Trade Financial', inspection['stock_trade_financial'] ?? ''),
                    _buildInfoRow('Accounts Receivable', inspection['accounts_receivable'] ?? ''),
                    _buildInfoRow('Advance Deposit', inspection['advance_deposit'] ?? ''),
                    _buildInfoRow('Other Current Assets', inspection['other_current_assets'] ?? ''),
                  ]),

                  _buildInfoCard('Fixed Assets', [
                    _buildInfoRow('Land Building', inspection['land_building'] ?? ''),
                    _buildInfoRow('Plant Machinery', inspection['plant_machinery'] ?? ''),
                    _buildInfoRow('Other Assets', inspection['other_assets'] ?? ''),
                  ]),

                  _buildInfoCard('Investments', [
                    _buildInfoRow('IBBL Investment', inspection['ibbl_investment'] ?? ''),
                    _buildInfoRow('Other Banks Investment', inspection['other_banks_investment'] ?? ''),
                  ]),

                  _buildInfoCard('Liabilities & Capital', [
                    _buildInfoRow('Borrowing Sources', inspection['borrowing_sources'] ?? ''),
                    _buildInfoRow('Accounts Payable', inspection['accounts_payable'] ?? ''),
                    _buildInfoRow('Other Current Liabilities', inspection['other_current_liabilities'] ?? ''),
                    _buildInfoRow('Long Term Liabilities', inspection['long_term_liabilities'] ?? ''),
                    _buildInfoRow('Other Non Current Liabilities', inspection['other_non_current_liabilities'] ?? ''),
                    _buildInfoRow('Paid Up Capital', inspection['paid_up_capital'] ?? ''),
                    _buildInfoRow('Retained Earning', inspection['retained_earning'] ?? ''),
                    _buildInfoRow('Resources', inspection['resources'] ?? ''),
                  ]),

                  // Section I: Working Capital Assessment - FIXED
                  _buildSectionI(),

                  // Section J: Godown Particulars
                  _buildSectionTitle('J. Godown Particulars'),
                  _buildInfoCard('Godown Information', [
                    _buildInfoRow('Godown Location', inspection['godown_location'] ?? ''),
                    _buildInfoRow('Godown Capacity', inspection['godown_capacity'] ?? ''),
                    _buildInfoRow('Godown Space', inspection['godown_space'] ?? ''),
                    _buildInfoRow('Godown Nature', inspection['godown_nature'] ?? ''),
                    _buildInfoRow('Godown Owner', inspection['godown_owner'] ?? ''),
                    _buildInfoRow('Distance from Branch', inspection['distance_from_branch'] ?? ''),
                    _buildInfoRow('Items to Store', inspection['items_to_store'] ?? ''),
                  ]),

                  _buildInfoCard('Godown Facilities', [
                    _buildInfoRow('Warehouse License', inspection['warehouse_license'] == true ? 'Yes' : 'No'),
                    _buildInfoRow('Godown Guard', inspection['godown_guard'] == true ? 'Yes' : 'No'),
                    _buildInfoRow('Damp Proof', inspection['damp_proof'] == true ? 'Yes' : 'No'),
                    _buildInfoRow('Easy Access', inspection['easy_access'] == true ? 'Yes' : 'No'),
                    _buildInfoRow('Letter Disclaimer', inspection['letter_disclaimer'] == true ? 'Yes' : 'No'),
                    _buildInfoRow('Insurance Policy', inspection['insurance_policy'] == true ? 'Yes' : 'No'),
                    _buildInfoRow('Godown Hired', inspection['godown_hired'] == true ? 'Yes' : 'No'),
                  ]),

                  // Section K: Checklist - FIXED
                  _buildSectionK(),

                  // Section L: Site Photos & Video - FIXED
                  _buildSectionL(),

                  // Section M: Documents Upload - FIXED
                  _buildSectionM(),

                  // Timestamps
                  _buildSectionTitle('Additional Information'),
                  _buildInfoCard('Timestamps', [
                    _buildInfoRow('Created At', _formatDate(inspection['created_at'])),
                    _buildInfoRow('Updated At', _formatDate(inspection['updated_at'])),
                    _buildInfoRow('Branch Name', inspection['branch_name'] ?? ''),
                    _buildInfoRow('Inspector', inspection['inspector_name'] ?? 'N/A'),
                    _buildInfoRow('Status', inspection['status'] ?? 'N/A'),
                  ]),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  String _formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) return 'N/A';
  
  try {
    // Parse the date string from Django
    final date = DateTime.parse(dateString);
    
    // Convert to Bangladesh time (UTC+6)
    final bangladeshTime = date.add(const Duration(hours: 6));
    
    // Format date and time
    final day = bangladeshTime.day.toString().padLeft(2, '0');
    final month = bangladeshTime.month.toString().padLeft(2, '0');
    final year = bangladeshTime.year;
    final hour = bangladeshTime.hour.toString().padLeft(2, '0');
    final minute = bangladeshTime.minute.toString().padLeft(2, '0');
    
    return '$day/$month/$year $hour:$minute';
  } catch (e) {
    return 'Invalid Date';
  }
}

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return 'N/A';
    
    try {
      final date = DateTime.parse(dateTimeString);
      final bangladeshTime = date.add(const Duration(hours: 6));
      
      final day = bangladeshTime.day.toString().padLeft(2, '0');
      final month = bangladeshTime.month.toString().padLeft(2, '0');
      final year = bangladeshTime.year;
      final hour = bangladeshTime.hour.toString().padLeft(2, '0');
      final minute = bangladeshTime.minute.toString().padLeft(2, '0');
      
      return '$day/$month/$year $hour:$minute';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Completed':
        return Colors.purple;
      default:
        return Colors.grey;
    }
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
}

// Photo View Screen for Full Screen Photo Viewing
class PhotoViewScreen extends StatefulWidget {
  final List<dynamic> photos;
  final int initialIndex;

  const PhotoViewScreen({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPhotoItem(dynamic photo) {
    final base64Data = photo['base64_data'];
    
    if (base64Data != null && base64Data is String && base64Data.isNotEmpty) {
      try {
        return InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.memory(
            base64Decode(base64Data),
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorWidget();
            },
          ),
        );
      } catch (e) {
        return _buildErrorWidget();
      }
    } else {
      return _buildErrorWidget();
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load image',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(
            'Photo ${_currentIndex + 1}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showPhotoInfo() {
    final photo = widget.photos[_currentIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Photo ${_currentIndex + 1} Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photo['file_name'] != null)
              Text('File Name: ${photo['file_name']}'),
            if (photo['description'] != null)
              Text('Description: ${photo['description']}'),
            if (photo['file_size'] != null)
              Text('Size: ${_formatFileSize(photo['file_size'])}'),
            if (photo['uploaded_at'] != null)
              Text('Uploaded: ${_formatDate(photo['uploaded_at'])}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(dynamic size) {
    if (size == null) return 'Unknown size';
    
    final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = (log(bytes) / log(1024)).floor();
    
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    
    try {
      final date = DateTime.parse(dateString);
      final bangladeshTime = date.add(const Duration(hours: 6));
      
      final day = bangladeshTime.day.toString().padLeft(2, '0');
      final month = bangladeshTime.month.toString().padLeft(2, '0');
      final year = bangladeshTime.year;
      final hour = bangladeshTime.hour.toString().padLeft(2, '0');
      final minute = bangladeshTime.minute.toString().padLeft(2, '0');
      
      return '$day/$month/$year $hour:$minute';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Photo ${_currentIndex + 1} of ${widget.photos.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: _showPhotoInfo,
            tooltip: 'Photo Info',
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPhotoItem(widget.photos[index]);
            },
          ),
          
          // Photo counter indicator
          if (widget.photos.length > 1)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.photos.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Video View Screen for Full Screen Video Viewing
class VideoViewScreen extends StatelessWidget {
  final Map<String, dynamic> video;

  const VideoViewScreen({
    super.key,
    required this.video,
  });

  Widget _buildVideoContent() {
    final base64Data = video['base64_data'];
    
    if (base64Data != null && base64Data is String && base64Data.isNotEmpty) {
      try {
        // For Base64 video, we'll show a placeholder with download option
        // since VideoPlayerController.memory() is not available
        return _buildVideoPlaceholder();
      } catch (e) {
        return _buildErrorWidget('Failed to process video data');
      }
    } else {
      return _buildErrorWidget('No video data available');
    }
  }

  Widget _buildVideoPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videocam, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Video File',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            video['file_name'] ?? 'Site Video',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Text(
            'File Size: ${_formatFileSize(video['file_size'])}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement video download functionality
              _showDownloadMessage();
            },
            icon: const Icon(Icons.download),
            label: const Text('Download Video'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Video preview is not available for Base64 format.\nPlease download to view.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showDownloadMessage() {
    // This would typically download the file
    // For now, show a message
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('Download functionality would be implemented here'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showVideoInfo() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(video['file_name'] ?? 'Video Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (video['description'] != null)
              Text('Description: ${video['description']}'),
            if (video['file_size'] != null)
              Text('Size: ${_formatFileSize(video['file_size'])}'),
            if (video['uploaded_at'] != null)
              Text('Uploaded: ${_formatDate(video['uploaded_at'])}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(dynamic size) {
    if (size == null) return 'Unknown size';
    
    final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = (log(bytes) / log(1024)).floor();
    
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    
    try {
      final date = DateTime.parse(dateString);
      final bangladeshTime = date.add(const Duration(hours: 6));
      
      final day = bangladeshTime.day.toString().padLeft(2, '0');
      final month = bangladeshTime.month.toString().padLeft(2, '0');
      final year = bangladeshTime.year;
      final hour = bangladeshTime.hour.toString().padLeft(2, '0');
      final minute = bangladeshTime.minute.toString().padLeft(2, '0');
      
      return '$day/$month/$year $hour:$minute';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          video['file_name'] ?? 'Site Video',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: _showVideoInfo,
            tooltip: 'Video Info',
          ),
        ],
      ),
      body: _buildVideoContent(),
    );
  }
}

// Document View Screen for Full Screen Document Viewing - FIXED VERSION
class DocumentViewScreen extends StatefulWidget {
  final Map<String, dynamic> document;
  final int index;

  const DocumentViewScreen({
    super.key,
    required this.document,
    required this.index,
  });

  @override
  State<DocumentViewScreen> createState() => _DocumentViewScreenState();
}

class _DocumentViewScreenState extends State<DocumentViewScreen> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _loadError = false;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      final filePath = widget.document['file_path'];
      final base64Data = widget.document['base64_data'];
      
      if (filePath != null && filePath is String && filePath.isNotEmpty) {
        // Load from file path
        final file = File(filePath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          setState(() {
            _imageBytes = bytes;
            _isLoading = false;
          });
          return;
        }
      }
      
      if (base64Data != null && base64Data is String && base64Data.isNotEmpty) {
        // Load from base64 data
        final bytes = base64Decode(base64Data);
        setState(() {
          _imageBytes = bytes;
          _isLoading = false;
        });
        return;
      }
      
      // If neither file path nor base64 data is available
      setState(() {
        _isLoading = false;
        _loadError = true;
      });
    } catch (e) {
      print('Error loading document: $e');
      setState(() {
        _isLoading = false;
        _loadError = true;
      });
    }
  }

  Widget _buildDocumentContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading document...'),
          ],
        ),
      );
    }

    if (_loadError) {
      return _buildErrorWidget('Failed to load document');
    }

    final fileName = widget.document['name'] ?? 'Document ${widget.index + 1}';
    final extension = fileName.split('.').last.toLowerCase();

    if (_imageBytes != null) {
      if (['jpg', 'jpeg', 'png'].contains(extension)) {
        // For images, show the image
        return InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.memory(
            _imageBytes!,
            fit: BoxFit.contain,
          ),
        );
      } else {
        // For other file types, show a placeholder with download option
        return _buildDocumentPlaceholder(_getDocumentType(fileName), _getDocumentIconData(fileName));
      }
    } else {
      return _buildDocumentInfo();
    }
  }

  Widget _buildDocumentPlaceholder(String type, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            type,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            widget.document['name'] ?? 'Document ${widget.index + 1}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (widget.document['file_size'] != null)
            Text(
              'File Size: ${_formatFileSize(widget.document['file_size'])}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _showDownloadMessage();
            },
            icon: const Icon(Icons.download),
            label: const Text('Download Document'),
          ),
          const SizedBox(height: 10),
          if (widget.document['file_path'] != null)
            Text(
              'File Path: ${widget.document['file_path']}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentInfo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.insert_drive_file, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Document Information',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            widget.document['name'] ?? 'Document ${widget.index + 1}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (widget.document['file_path'] != null)
            Text(
              'File Path: ${widget.document['file_path']}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          if (widget.document['file_size'] != null)
            Text(
              'File Size: ${_formatFileSize(widget.document['file_size'])}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          if (widget.document['upload_date'] != null)
            Text(
              'Uploaded: ${_formatDate(widget.document['upload_date'])}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          const SizedBox(height: 20),
          const Text(
            'No document data available for preview.\nThis document may be stored on the server.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showDownloadMessage() {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('Download functionality would be implemented here'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDocumentInfo() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(widget.document['name'] ?? 'Document ${widget.index + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${_getDocumentType(widget.document['name'] ?? '')}'),
            if (widget.document['file_path'] != null)
              Text('Path: ${widget.document['file_path']}'),
            if (widget.document['file_size'] != null)
              Text('Size: ${_formatFileSize(widget.document['file_size'])}'),
            if (widget.document['upload_date'] != null)
              Text('Uploaded: ${_formatDate(widget.document['upload_date'])}'),
            if (widget.document['description'] != null)
              Text('Description: ${widget.document['description']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getDocumentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return 'PDF Document';
      case 'doc':
      case 'docx':
        return 'Word Document';
      case 'jpg':
      case 'jpeg':
        return 'JPEG Image';
      case 'png':
        return 'PNG Image';
      case 'mp4':
      case 'avi':
      case 'mov':
        return 'Video File';
      default:
        return 'File';
    }
  }

  IconData _getDocumentIconData(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.photo;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.videocam;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(dynamic size) {
    if (size == null) return 'Unknown size';
    
    final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = (log(bytes) / log(1024)).floor();
    
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    
    try {
      final date = DateTime.parse(dateString);
      final bangladeshTime = date.add(const Duration(hours: 6));
      
      final day = bangladeshTime.day.toString().padLeft(2, '0');
      final month = bangladeshTime.month.toString().padLeft(2, '0');
      final year = bangladeshTime.year;
      final hour = bangladeshTime.hour.toString().padLeft(2, '0');
      final minute = bangladeshTime.minute.toString().padLeft(2, '0');
      
      return '$day/$month/$year $hour:$minute';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.document['name'] ?? 'Document ${widget.index + 1}';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF116045),
        foregroundColor: Colors.white,
        title: Text(
          fileName,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: _showDocumentInfo,
            tooltip: 'Document Info',
          ),
        ],
      ),
      body: _buildDocumentContent(),
    );
  }
}

// Map View Screen
class MapViewScreen extends StatefulWidget {
  final List<dynamic> locationPoints;
  final Map<String, dynamic> inspection;

  const MapViewScreen({
    super.key,
    required this.locationPoints,
    required this.inspection,
  });

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  LatLngBounds? bounds;

  @override
  void initState() {
    super.initState();
    _initializeMapData();
  }

  void _initializeMapData() {
    // Create markers for all location points
    final List<LatLng> latLngList = [];
    
    for (int i = 0; i < widget.locationPoints.length; i++) {
      final point = widget.locationPoints[i];
      final lat = point['latitude'];
      final lng = point['longitude'];
      
      if (lat != null && lng != null) {
        final latLng = LatLng(lat, lng);
        latLngList.add(latLng);
        
        markers.add(
          Marker(
            markerId: MarkerId('point_$i'),
            position: latLng,
            infoWindow: InfoWindow(
              title: 'Point ${i + 1}',
              snippet: 'Accuracy: ${point['accuracy']?.toStringAsFixed(2) ?? 'N/A'}m\nTime: ${_formatTime(point['timestamp'])}',
            ),
            icon: i == 0 
                ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen) // Start point
                : i == widget.locationPoints.length - 1
                    ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed) // End point
                    : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Intermediate points
          ),
        );
      }
    }

    // Create polyline if there are multiple points
    if (latLngList.length > 1) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: latLngList,
          color: Colors.blue,
          width: 4,
        ),
      );
    }

    // Calculate bounds to fit all markers
    if (latLngList.isNotEmpty) {
      bounds = _createBounds(latLngList);
    }
  }

  LatLngBounds _createBounds(List<LatLng> points) {
    double? west, north, east, south;
    
    for (LatLng point in points) {
      if (west == null || point.longitude < west) west = point.longitude;
      if (east == null || point.longitude > east) east = point.longitude;
      if (south == null || point.latitude < south) south = point.latitude;
      if (north == null || point.latitude > north) north = point.latitude;
    }
    
    return LatLngBounds(
      southwest: LatLng(south!, west!),
      northeast: LatLng(north!, east!),
    );
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return 'N/A';
    
    try {
      final date = DateTime.parse(timestamp);
      final bangladeshTime = date.add(const Duration(hours: 6));
      return '${bangladeshTime.hour}:${bangladeshTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstPoint = widget.locationPoints.isNotEmpty ? widget.locationPoints.first : null;
    final initialLocation = firstPoint != null 
        ? LatLng(firstPoint['latitude'] ?? 23.8103, firstPoint['longitude'] ?? 90.4125)
        : const LatLng(23.8103, 90.4125); // Default to Dhaka

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF116045),
        title: Text(
          'Location Map - ${widget.inspection['client_name'] ?? 'Inspection'}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _fitToBounds,
            tooltip: 'Fit to all points',
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          // Fit bounds after map is created
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _fitToBounds();
          });
        },
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14,
        ),
        markers: markers,
        polylines: polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location Tracking Points: ${widget.locationPoints.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF116045),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Start Point'),
                const SizedBox(width: 16),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('End Point'),
                const SizedBox(width: 16),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Intermediate Points'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _fitToBounds() {
    if (bounds != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds!, 50),
      );
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}

// Global key for navigation context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();