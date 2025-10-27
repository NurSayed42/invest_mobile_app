

// import 'dart:io';
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:geolocator/geolocator.dart';
// import '../services/inspection_service.dart';

// class CreateInspectionScreen extends StatefulWidget {
//   final Map<String, dynamic>? inspectionData;
//   final bool isEditMode;

//   const CreateInspectionScreen({
//     super.key,
//     this.inspectionData,
//     this.isEditMode = false,
//   });

//   @override
//   State<CreateInspectionScreen> createState() => _CreateInspectionScreenState();
// }

// class _CreateInspectionScreenState extends State<CreateInspectionScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final InspectionService _inspectionService = InspectionService();
//   final FlutterSecureStorage storage = const FlutterSecureStorage();

//   // Location Tracking Variables
//   bool _isLocationTracking = false;
//   List<Map<String, dynamic>> _locationPoints = [];
//   Timer? _locationTimer;
//   DateTime? _locationStartTime;
//   DateTime? _locationEndTime;

//   // Section A - Company's Client's Information
//   TextEditingController clientNameController = TextEditingController();
//   TextEditingController groupNameController = TextEditingController();
//   TextEditingController industryNameController = TextEditingController();
//   TextEditingController natureOfBusinessController = TextEditingController();
//   TextEditingController legalStatusController = TextEditingController();
//   TextEditingController dateOfEstablishmentController = TextEditingController();
//   TextEditingController officeAddressController = TextEditingController();
//   TextEditingController showroomAddressController = TextEditingController();
//   TextEditingController factoryAddressController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController accountNoController = TextEditingController();
//   TextEditingController accountIdController = TextEditingController();
//   TextEditingController tinController = TextEditingController();
//   TextEditingController dateOfOpeningController = TextEditingController();
//   TextEditingController vatRegController = TextEditingController();
//   TextEditingController firstInvestmentDateController = TextEditingController();
//   TextEditingController sectorCodeController = TextEditingController();
//   TextEditingController tradeLicenseController = TextEditingController();
//   TextEditingController economicPurposeController = TextEditingController();
//   String? selectedInvestmentCategory;

//   // Section B - Owner Information
//   TextEditingController ownerNameController = TextEditingController();
//   TextEditingController ownerAgeController = TextEditingController();
//   TextEditingController fatherNameController = TextEditingController();
//   TextEditingController motherNameController = TextEditingController();
//   TextEditingController spouseNameController = TextEditingController();
//   TextEditingController academicQualificationController = TextEditingController();
//   TextEditingController childrenInfoController = TextEditingController();
//   TextEditingController businessSuccessorController = TextEditingController();
//   TextEditingController residentialAddressController = TextEditingController();
//   TextEditingController permanentAddressController = TextEditingController();

//   // Section C - Partners/Directors
//   List<Partner> partners = [Partner()];

//   // Section D - Purpose
//   TextEditingController purposeInvestmentController = TextEditingController();
//   TextEditingController purposeBankGuaranteeController = TextEditingController();
//   TextEditingController periodInvestmentController = TextEditingController();

//   // Section E - Proposed Facilities
//   String? selectedFacilityType;
//   TextEditingController existingLimitController = TextEditingController();
//   TextEditingController appliedLimitController = TextEditingController();
//   TextEditingController recommendedLimitController = TextEditingController();
//   TextEditingController bankPercentageController = TextEditingController();
//   TextEditingController clientPercentageController = TextEditingController();

//   // Section F - Present Outstanding
//   String? selectedOutstandingType;
//   TextEditingController limitController = TextEditingController();
//   TextEditingController netOutstandingController = TextEditingController();
//   TextEditingController grossOutstandingController = TextEditingController();

//   // Section G - Business Analysis
//   String? marketSituation;
//   String? clientPosition;
//   List<Competitor> competitors = List.generate(5, (index) => Competitor());
//   String? businessReputation;
//   String? productionType;
//   TextEditingController productNameController = TextEditingController();
//   TextEditingController productionCapacityController = TextEditingController();
//   TextEditingController actualProductionController = TextEditingController();
//   TextEditingController profitabilityObservationController = TextEditingController();
  
//   // Labor Force Data
//   TextEditingController maleOfficerController = TextEditingController();
//   TextEditingController femaleOfficerController = TextEditingController();
//   TextEditingController skilledOfficerController = TextEditingController();
//   TextEditingController unskilledOfficerController = TextEditingController();
//   TextEditingController maleWorkerController = TextEditingController();
//   TextEditingController femaleWorkerController = TextEditingController();
//   TextEditingController skilledWorkerController = TextEditingController();
//   TextEditingController unskilledWorkerController = TextEditingController();

//   // Key Employees
//   List<Employee> employees = [Employee()];

//   // Section H - Property & Assets
//   TextEditingController cashBalanceController = TextEditingController();
//   TextEditingController stockTradeFinishedController = TextEditingController();
//   TextEditingController stockTradeFinancialController = TextEditingController();
//   TextEditingController accountsReceivableController = TextEditingController();
//   TextEditingController advanceDepositController = TextEditingController();
//   TextEditingController otherCurrentAssetsController = TextEditingController();
//   TextEditingController landBuildingController = TextEditingController();
//   TextEditingController plantMachineryController = TextEditingController();
//   TextEditingController otherAssetsController = TextEditingController();
//   TextEditingController ibblController = TextEditingController();
//   TextEditingController otherBanksController = TextEditingController();
//   TextEditingController borrowingSourcesController = TextEditingController();
//   TextEditingController accountsPayableController = TextEditingController();
//   TextEditingController otherCurrentLiabilitiesController = TextEditingController();
//   TextEditingController longTermLiabilitiesController = TextEditingController();
//   TextEditingController otherNonCurrentLiabilitiesController = TextEditingController();
//   TextEditingController paidUpCapitalController = TextEditingController();
//   TextEditingController retainedEarningController = TextEditingController();
//   TextEditingController resourcesController = TextEditingController();

//   // Section I - Working Capital Assessment
//   List<WorkingCapitalItem> workingCapitalItems = [
//     WorkingCapitalItem('Raw Materials (imported)'),
//     WorkingCapitalItem('Raw Materials (Local)'),
//     WorkingCapitalItem('Work in Process'),
//     WorkingCapitalItem('Finished goods'),
//   ];

//   // Section J - Godown Particulars
//   TextEditingController godownLocationController = TextEditingController();
//   TextEditingController godownCapacityController = TextEditingController();
//   TextEditingController godownSpaceController = TextEditingController();
//   TextEditingController godownNatureController = TextEditingController();
//   TextEditingController godownOwnerController = TextEditingController();
//   TextEditingController distanceFromBranchController = TextEditingController();
//   TextEditingController itemsToStoreController = TextEditingController();
//   bool warehouseLicense = false;
//   bool godownGuard = false;
//   bool dampProof = false;
//   bool easyAccess = false;
//   bool letterDisclaimer = false;
//   bool insurancePolicy = false;
//   bool godownHired = false;

//   // Section K - Checklist
//   Map<String, bool?> checklistItems = {
//     'Business establishment physically verified': null,
//     'Honesty and integrity ascertained': null,
//     'Confidential Report obtained': null,
//     'CIB report obtained': null,
//     'Items permissible by Islamic Shariah': null,
//     'Items not restricted by Bangladesh Bank': null,
//     'Items permissible by Investment Policy': null,
//     'Market Price verified': null,
//     'Constant market demand': null,
//     'F-167 A duly filled': null,
//     'F-167 B property filled': null,
//     'Application particulars verified': null,
//     'IRC, ERC, VAT copies enclosed': null,
//     'TIN Certificate enclosed': null,
//     'Rental Agreement enclosed': null,
//     'Trade License enclosed': null,
//     'Partnership Deed enclosed': null,
//     'Memorandum & Articles enclosed': null,
//     'Board resolution enclosed': null,
//     'Directors particulars enclosed': null,
//     'Current Account Statement enclosed': null,
//     'Creditors/Debtors list enclosed': null,
//     'IRC form with documents enclosed': null,
//     'Audited Balance sheet enclosed': null,
//   };

//   // Section L - Site Photos & Video
//   List<File> sitePhotos = [];
//   File? siteVideo;

//   // Section M - Documents Upload
//   List<DocumentFile> uploadedDocuments = [];

//   // Status field for edit mode
//   String? selectedStatus;

//   // Lists for dropdowns
//   List<String> investmentCategories = [
//     'Agriculture (AG)',
//     'Large & Medium Scale Industry-LM',
//     'Working Capital (Jute) WJ',
//     'Working Capital (other than Jute) WO',
//     'Jute Trading (JT)',
//     'Jute & Jute goods Export (JE)',
//     'Other Exports (OE)',
//     'Other Commercial Investments (OC)',
//     'Urban Housing (UH)',
//     'Special program',
//     'Others (OT)'
//   ];

//   List<String> facilityTypes = [
//     'Bai-Murabaha',
//     'Bai-Muajjal',
//     'Bai-Salam',
//     'Mudaraba',
//     'BB LC/ BILLS',
//     'FBN/FBP/IBP',
//     'Others'
//   ];

//   List<String> outstandingTypes = [
//     'Bai-Murabaha TR',
//     'Bai-Muajjal TR',
//     'Bai-Salam',
//     'BB LC/ BILLS',
//     'FBN/FBP/IBP',
//     'None',
//     'Others'
//   ];

//   List<String> marketSituations = [
//     'Highly Saturated',
//     'Saturated',
//     'Low Demand Gap',
//     'High Demand Gap'
//   ];

//   List<String> clientPositions = [
//     'Market Leader',
//     'Medium',
//     'Weak',
//     'Deteriorating'
//   ];

//   List<String> reputationOptions = [
//     'Very Good',
//     'Good',
//     'Bad'
//   ];

//   List<String> productionTypes = [
//     'Export Oriented',
//     'Import Substitute',
//     'Agro Based'
//   ];

//   List<String> statusOptions = [
//     'Pending',
//     'In Progress',
//     'Completed',
//     'Approved',
//     'Rejected'
//   ];

//   final ImagePicker _imagePicker = ImagePicker();
//   bool _isLoading = false;

//   // Auto-calculation values
//   double _currentAssetsSubTotal = 0.0;
//   double _fixedAssetsSubTotal = 0.0;
//   double _totalAssets = 0.0;
//   double _currentLiabilitiesSubTotal = 0.0;
//   double _totalLiabilities = 0.0;
//   double _totalEquity = 0.0;
//   double _grandTotal = 0.0;
//   double _netWorth = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFormData();
//     _setupAutoCalculations();
//     _checkExistingLocationData();
//   }

//   void _checkExistingLocationData() {
//     if (widget.isEditMode && widget.inspectionData != null) {
//       final data = widget.inspectionData!;
//       if (data['location_points'] != null && data['location_points'] is List) {
//         setState(() {
//           _locationPoints = List<Map<String, dynamic>>.from(data['location_points']);
//         });
//       }
//       if (data['location_start_time'] != null) {
//         _locationStartTime = DateTime.parse(data['location_start_time']);
//       }
//       if (data['location_end_time'] != null) {
//         _locationEndTime = DateTime.parse(data['location_end_time']);
//       }
//     }
//   }

//   // Location Tracking Methods
//   Future<void> _startLocationTracking() async {
//     // Check location permissions
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         _showSnackBar('Location permissions are required for tracking', isError: true);
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       _showSnackBar('Location permissions are permanently denied. Please enable them in settings.', isError: true);
//       return;
//     }

//     setState(() {
//       _isLocationTracking = true;
//       _locationStartTime = DateTime.now();
//       _locationPoints.clear();
//     });

//     // Get first location immediately
//     await _getCurrentLocation();

//     // Start periodic location updates every 5 minutes
//     _locationTimer = Timer.periodic(Duration(minutes: 5), (Timer t) async {
//       await _getCurrentLocation();
//     });

//     _showSnackBar('Location tracking started successfully!', isError: false);
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );

//       Map<String, dynamic> locationPoint = {
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//         'accuracy': position.accuracy,
//         'altitude': position.altitude,
//         'speed': position.speed,
//         'speed_accuracy': position.speedAccuracy,
//         'heading': position.heading,
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       setState(() {
//         _locationPoints.add(locationPoint);
//       });

//       print('📍 Location captured: ${position.latitude}, ${position.longitude}');
//     } catch (e) {
//       print('Error getting location: $e');
//       _showSnackBar('Error getting location: $e', isError: true);
//     }
//   }

//   void _stopLocationTracking() {
//     if (_locationTimer != null) {
//       _locationTimer!.cancel();
//       _locationTimer = null;
//     }

//     setState(() {
//       _isLocationTracking = false;
//       _locationEndTime = DateTime.now();
//     });

//     _showSnackBar('Location tracking stopped. ${_locationPoints.length} points captured.', isError: false);
//   }

//   void _setupAutoCalculations() {
//     // Add listeners for auto-calculation fields
//     cashBalanceController.addListener(_calculateAssets);
//     stockTradeFinishedController.addListener(_calculateAssets);
//     stockTradeFinancialController.addListener(_calculateAssets);
//     accountsReceivableController.addListener(_calculateAssets);
//     advanceDepositController.addListener(_calculateAssets);
//     otherCurrentAssetsController.addListener(_calculateAssets);
//     landBuildingController.addListener(_calculateAssets);
//     plantMachineryController.addListener(_calculateAssets);
//     otherAssetsController.addListener(_calculateAssets);
    
//     ibblController.addListener(_calculateLiabilities);
//     otherBanksController.addListener(_calculateLiabilities);
//     borrowingSourcesController.addListener(_calculateLiabilities);
//     accountsPayableController.addListener(_calculateLiabilities);
//     otherCurrentLiabilitiesController.addListener(_calculateLiabilities);
//     longTermLiabilitiesController.addListener(_calculateLiabilities);
//     otherNonCurrentLiabilitiesController.addListener(_calculateLiabilities);
    
//     paidUpCapitalController.addListener(_calculateEquity);
//     retainedEarningController.addListener(_calculateEquity);
//     resourcesController.addListener(_calculateEquity);

//     // Working capital calculations
//     for (var item in workingCapitalItems) {
//       item.unitController.addListener(() => _calculateWorkingCapitalItem(item));
//       item.rateController.addListener(() => _calculateWorkingCapitalItem(item));
//       item.tiedUpDaysController.addListener(() => _calculateWorkingCapitalItem(item));
//     }
//   }

//   void _calculateAssets() {
//     double currentAssets = _parseDouble(cashBalanceController.text) +
//         _parseDouble(stockTradeFinishedController.text) +
//         _parseDouble(stockTradeFinancialController.text) +
//         _parseDouble(accountsReceivableController.text) +
//         _parseDouble(advanceDepositController.text) +
//         _parseDouble(otherCurrentAssetsController.text);

//     double fixedAssets = _parseDouble(landBuildingController.text) +
//         _parseDouble(plantMachineryController.text) +
//         _parseDouble(otherAssetsController.text);

//     setState(() {
//       _currentAssetsSubTotal = currentAssets;
//       _fixedAssetsSubTotal = fixedAssets;
//       _totalAssets = currentAssets + fixedAssets;
//       _calculateNetWorth();
//     });
//   }

//   void _calculateLiabilities() {
//     double currentLiabilities = _parseDouble(ibblController.text) +
//         _parseDouble(otherBanksController.text) +
//         _parseDouble(borrowingSourcesController.text) +
//         _parseDouble(accountsPayableController.text) +
//         _parseDouble(otherCurrentLiabilitiesController.text);

//     double longTerm = _parseDouble(longTermLiabilitiesController.text);
//     double otherNonCurrent = _parseDouble(otherNonCurrentLiabilitiesController.text);

//     setState(() {
//       _currentLiabilitiesSubTotal = currentLiabilities;
//       _totalLiabilities = currentLiabilities + longTerm + otherNonCurrent;
//       _calculateNetWorth();
//     });
//   }

//   void _calculateEquity() {
//     double equity = _parseDouble(paidUpCapitalController.text) +
//         _parseDouble(retainedEarningController.text) +
//         _parseDouble(resourcesController.text);

//     setState(() {
//       _totalEquity = equity;
//       _grandTotal = _totalLiabilities + _totalEquity;
//       _calculateNetWorth();
//     });
//   }

//   void _calculateNetWorth() {
//     setState(() {
//       _netWorth = _totalAssets - _totalLiabilities;
//     });
//   }

//   void _calculateWorkingCapitalItem(WorkingCapitalItem item) {
//     double unit = _parseDouble(item.unitController.text);
//     double rate = _parseDouble(item.rateController.text);
//     double tiedUpDays = _parseDouble(item.tiedUpDaysController.text);

//     // Calculate amount (d = unit * rate)
//     double amount = unit * rate;
//     if (amount > 0 && item.amountController.text != amount.toString()) {
//       item.amountController.text = amount.toStringAsFixed(2);
//     }

//     // Calculate amount_dxe (amount * tiedUpDays)
//     double amountDxe = amount * tiedUpDays;
//     if (amountDxe > 0 && item.amountDxeController.text != amountDxe.toString()) {
//       item.amountDxeController.text = amountDxe.toStringAsFixed(2);
//     }
//   }

//   double _parseDouble(String text) {
//     if (text.isEmpty) return 0.0;
//     return double.tryParse(text) ?? 0.0;
//   }

//   void _initializeFormData() {
//     if (widget.isEditMode && widget.inspectionData != null) {
//       final data = widget.inspectionData!;
//       print('📝 Initializing form with existing data: ${data['id']}');
      
//       // Section A - Company's Client's Information
//       clientNameController.text = data['client_name'] ?? '';
//       groupNameController.text = data['group_name'] ?? '';
//       industryNameController.text = data['industry_name'] ?? '';
//       natureOfBusinessController.text = data['nature_of_business'] ?? '';
//       legalStatusController.text = data['legal_status'] ?? '';
//       dateOfEstablishmentController.text = data['date_of_establishment'] ?? '';
//       officeAddressController.text = data['office_address'] ?? '';
//       showroomAddressController.text = data['showroom_address'] ?? '';
//       factoryAddressController.text = data['factory_address'] ?? '';
//       phoneController.text = data['phone_number'] ?? '';
//       accountNoController.text = data['account_number'] ?? '';
//       accountIdController.text = data['account_id'] ?? '';
//       tinController.text = data['tin_number'] ?? '';
//       dateOfOpeningController.text = data['date_of_opening'] ?? '';
//       vatRegController.text = data['vat_reg_number'] ?? '';
//       firstInvestmentDateController.text = data['first_investment_date'] ?? '';
//       sectorCodeController.text = data['sector_code'] ?? '';
//       tradeLicenseController.text = data['trade_license'] ?? '';
//       economicPurposeController.text = data['economic_purpose_code'] ?? '';
//       selectedInvestmentCategory = data['investment_category'];
      
//       // Section B - Owner Information
//       ownerNameController.text = data['owner_name'] ?? '';
//       ownerAgeController.text = data['owner_age'] ?? '';
//       fatherNameController.text = data['father_name'] ?? '';
//       motherNameController.text = data['mother_name'] ?? '';
//       spouseNameController.text = data['spouse_name'] ?? '';
//       academicQualificationController.text = data['academic_qualification'] ?? '';
//       childrenInfoController.text = data['children_info'] ?? '';
//       businessSuccessorController.text = data['business_successor'] ?? '';
//       residentialAddressController.text = data['residential_address'] ?? '';
//       permanentAddressController.text = data['permanent_address'] ?? '';
      
//       // Section C - Partners/Directors
//       if (data['partners_directors'] != null && data['partners_directors'] is List) {
//         partners.clear();
//         for (var partnerData in data['partners_directors']) {
//           Partner partner = Partner();
//           partner.nameController.text = partnerData['name'] ?? '';
//           partner.ageController.text = partnerData['age'] ?? '';
//           partner.qualificationController.text = partnerData['qualification'] ?? '';
//           partner.shareController.text = partnerData['share'] ?? '';
//           partner.statusController.text = partnerData['status'] ?? '';
//           partner.relationshipController.text = partnerData['relationship'] ?? '';
//           partners.add(partner);
//         }
//         if (partners.isEmpty) partners.add(Partner());
//       }
      
//       // Section D - Purpose
//       purposeInvestmentController.text = data['purpose_investment'] ?? '';
//       purposeBankGuaranteeController.text = data['purpose_bank_guarantee'] ?? '';
//       periodInvestmentController.text = data['period_investment'] ?? '';
      
//       // Section E - Proposed Facilities
//       selectedFacilityType = data['facility_type'];
//       existingLimitController.text = data['existing_limit'] ?? '';
//       appliedLimitController.text = data['applied_limit'] ?? '';
//       recommendedLimitController.text = data['recommended_limit'] ?? '';
//       bankPercentageController.text = data['bank_percentage'] ?? '';
//       clientPercentageController.text = data['client_percentage'] ?? '';
      
//       // Section F - Present Outstanding
//       selectedOutstandingType = data['outstanding_type'];
//       limitController.text = data['limit_amount'] ?? '';
//       netOutstandingController.text = data['net_outstanding'] ?? '';
//       grossOutstandingController.text = data['gross_outstanding'] ?? '';
      
//       // Section G - Business Analysis
//       marketSituation = data['market_situation'];
//       clientPosition = data['client_position'];
//       businessReputation = data['business_reputation'];
//       productionType = data['production_type'];
//       productNameController.text = data['product_name'] ?? '';
//       productionCapacityController.text = data['production_capacity'] ?? '';
//       actualProductionController.text = data['actual_production'] ?? '';
//       profitabilityObservationController.text = data['profitability_observation'] ?? '';
      
//       // Labor Force
//       maleOfficerController.text = data['male_officer'] ?? '';
//       femaleOfficerController.text = data['female_officer'] ?? '';
//       skilledOfficerController.text = data['skilled_officer'] ?? '';
//       unskilledOfficerController.text = data['unskilled_officer'] ?? '';
//       maleWorkerController.text = data['male_worker'] ?? '';
//       femaleWorkerController.text = data['female_worker'] ?? '';
//       skilledWorkerController.text = data['skilled_worker'] ?? '';
//       unskilledWorkerController.text = data['unskilled_worker'] ?? '';
      
//       // Competitors
//       if (data['competitors'] != null && data['competitors'] is List) {
//         for (int i = 0; i < data['competitors'].length && i < competitors.length; i++) {
//           var competitorData = data['competitors'][i];
//           competitors[i].nameController.text = competitorData['name'] ?? '';
//           competitors[i].addressController.text = competitorData['address'] ?? '';
//           competitors[i].marketShareController.text = competitorData['market_share'] ?? '';
//         }
//       }
      
//       // Key Employees
//       if (data['key_employees'] != null && data['key_employees'] is List) {
//         employees.clear();
//         for (var employeeData in data['key_employees']) {
//           Employee employee = Employee();
//           employee.nameController.text = employeeData['name'] ?? '';
//           employee.designationController.text = employeeData['designation'] ?? '';
//           employee.ageController.text = employeeData['age'] ?? '';
//           employee.qualificationController.text = employeeData['qualification'] ?? '';
//           employee.experienceController.text = employeeData['experience'] ?? '';
//           employees.add(employee);
//         }
//         if (employees.isEmpty) employees.add(Employee());
//       }
      
//       // Section H - Property & Assets
//       cashBalanceController.text = data['cash_balance'] ?? '';
//       stockTradeFinishedController.text = data['stock_trade_finished'] ?? '';
//       stockTradeFinancialController.text = data['stock_trade_financial'] ?? '';
//       accountsReceivableController.text = data['accounts_receivable'] ?? '';
//       advanceDepositController.text = data['advance_deposit'] ?? '';
//       otherCurrentAssetsController.text = data['other_current_assets'] ?? '';
//       landBuildingController.text = data['land_building'] ?? '';
//       plantMachineryController.text = data['plant_machinery'] ?? '';
//       otherAssetsController.text = data['other_assets'] ?? '';
//       ibblController.text = data['ibbl_investment'] ?? '';
//       otherBanksController.text = data['other_banks_investment'] ?? '';
//       borrowingSourcesController.text = data['borrowing_sources'] ?? '';
//       accountsPayableController.text = data['accounts_payable'] ?? '';
//       otherCurrentLiabilitiesController.text = data['other_current_liabilities'] ?? '';
//       longTermLiabilitiesController.text = data['long_term_liabilities'] ?? '';
//       otherNonCurrentLiabilitiesController.text = data['other_non_current_liabilities'] ?? '';
//       paidUpCapitalController.text = data['paid_up_capital'] ?? '';
//       retainedEarningController.text = data['retained_earning'] ?? '';
//       resourcesController.text = data['resources'] ?? '';
      
//       // Section I - Working Capital Assessment
//       if (data['working_capital_items'] != null && data['working_capital_items'] is List) {
//         for (int i = 0; i < data['working_capital_items'].length && i < workingCapitalItems.length; i++) {
//           var itemData = data['working_capital_items'][i];
//           workingCapitalItems[i].unitController.text = itemData['unit'] ?? '';
//           workingCapitalItems[i].rateController.text = itemData['rate'] ?? '';
//           workingCapitalItems[i].amountController.text = itemData['amount'] ?? '';
//           workingCapitalItems[i].tiedUpDaysController.text = itemData['tied_up_days'] ?? '';
//           workingCapitalItems[i].amountDxeController.text = itemData['amount_dxe'] ?? '';
//         }
//       }
      
//       // Section J - Godown Particulars
//       godownLocationController.text = data['godown_location'] ?? '';
//       godownCapacityController.text = data['godown_capacity'] ?? '';
//       godownSpaceController.text = data['godown_space'] ?? '';
//       godownNatureController.text = data['godown_nature'] ?? '';
//       godownOwnerController.text = data['godown_owner'] ?? '';
//       distanceFromBranchController.text = data['distance_from_branch'] ?? '';
//       itemsToStoreController.text = data['items_to_store'] ?? '';
//       warehouseLicense = data['warehouse_license'] ?? false;
//       godownGuard = data['godown_guard'] ?? false;
//       dampProof = data['damp_proof'] ?? false;
//       easyAccess = data['easy_access'] ?? false;
//       letterDisclaimer = data['letter_disclaimer'] ?? false;
//       insurancePolicy = data['insurance_policy'] ?? false;
//       godownHired = data['godown_hired'] ?? false;
      
//       // Section K - Checklist
//       if (data['checklist_items'] != null && data['checklist_items'] is Map) {
//         checklistItems = Map<String, bool?>.from(data['checklist_items']);
//       }
      
//       // Status
//       selectedStatus = data['status'] ?? 'Pending';
      
//       print('✅ Form initialized with existing data');
      
//       // Calculate initial values
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _calculateAssets();
//         _calculateLiabilities();
//         _calculateEquity();
//       });
//     }
//   }

//   // Print submission summary for debugging
//   void _printSubmissionSummary() {
//     print('=== INSPECTION SUBMISSION SUMMARY ===');
//     print('📍 Location Points: ${_locationPoints.length}');
//     print('📊 Form Sections: A, B, C, D, E, F, G, H, I, J, K, L, M');
//     print('📷 Photos: ${sitePhotos.length} files');
//     print('🎥 Video: ${siteVideo != null ? "Yes" : "No"}');
//     print('📋 Checklist Items: ${checklistItems.length}');
//     print('👥 Partners: ${partners.length}');
//     print('💼 Employees: ${employees.length}');
//     print('🏢 Competitors: ${competitors.length}');
//     print('💰 Working Capital Items: ${workingCapitalItems.length}');
//     print('📄 Documents: ${uploadedDocuments.length}');
//     print('====================================');
//   }

//   // Enhanced submit with comprehensive data handling
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       // Print submission summary
//       _printSubmissionSummary();

//       // Stop location tracking if active
//       if (_isLocationTracking) {
//         _stopLocationTracking();
//       }

//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         final String? branchName = await storage.read(key: 'branch_name');
        
//         if (branchName == null || branchName.isEmpty) {
//           _showSnackBar('Branch information not found. Please login again.', isError: true);
//           setState(() {
//             _isLoading = false;
//           });
//           return;
//         }

//         // Prepare comprehensive inspection data
//         Map<String, dynamic> inspectionData = {
//           'branch_name': branchName,
          
//           // Location Data
//           'location_points': _locationPoints,
//           'location_start_time': _locationStartTime?.toIso8601String(),
//           'location_end_time': _locationEndTime?.toIso8601String(),
//           'total_location_points': _locationPoints.length,
          
//           // Section A - Company's Client's Information
//           'client_name': clientNameController.text,
//           'group_name': groupNameController.text,
//           'industry_name': industryNameController.text,
//           'nature_of_business': natureOfBusinessController.text,
//           'legal_status': legalStatusController.text,
//           'date_of_establishment': dateOfEstablishmentController.text,
//           'office_address': officeAddressController.text,
//           'showroom_address': showroomAddressController.text,
//           'factory_address': factoryAddressController.text,
//           'phone_number': phoneController.text,
//           'account_number': accountNoController.text,
//           'account_id': accountIdController.text,
//           'tin_number': tinController.text,
//           'date_of_opening': dateOfOpeningController.text,
//           'vat_reg_number': vatRegController.text,
//           'first_investment_date': firstInvestmentDateController.text,
//           'sector_code': sectorCodeController.text,
//           'trade_license': tradeLicenseController.text,
//           'economic_purpose_code': economicPurposeController.text,
//           'investment_category': selectedInvestmentCategory ?? '',
          
//           // Section B - Owner Information
//           'owner_name': ownerNameController.text,
//           'owner_age': ownerAgeController.text,
//           'father_name': fatherNameController.text,
//           'mother_name': motherNameController.text,
//           'spouse_name': spouseNameController.text,
//           'academic_qualification': academicQualificationController.text,
//           'children_info': childrenInfoController.text,
//           'business_successor': businessSuccessorController.text,
//           'residential_address': residentialAddressController.text,
//           'permanent_address': permanentAddressController.text,
          
//           // Section C - Partners/Directors
//           'partners_directors': partners.map((partner) => {
//             'name': partner.nameController.text,
//             'age': partner.ageController.text,
//             'qualification': partner.qualificationController.text,
//             'share': partner.shareController.text,
//             'status': partner.statusController.text,
//             'relationship': partner.relationshipController.text,
//           }).toList(),
          
//           // Section D - Purpose
//           'purpose_investment': purposeInvestmentController.text,
//           'purpose_bank_guarantee': purposeBankGuaranteeController.text,
//           'period_investment': periodInvestmentController.text,
          
//           // Section E - Proposed Facilities
//           'facility_type': selectedFacilityType ?? '',
//           'existing_limit': existingLimitController.text,
//           'applied_limit': appliedLimitController.text,
//           'recommended_limit': recommendedLimitController.text,
//           'bank_percentage': bankPercentageController.text,
//           'client_percentage': clientPercentageController.text,
          
//           // Section F - Present Outstanding
//           'outstanding_type': selectedOutstandingType ?? '',
//           'limit_amount': limitController.text,
//           'net_outstanding': netOutstandingController.text,
//           'gross_outstanding': grossOutstandingController.text,
          
//           // Section G - Business Analysis
//           'market_situation': marketSituation ?? '',
//           'client_position': clientPosition ?? '',
//           'competitors': competitors.map((competitor) => {
//             'name': competitor.nameController.text,
//             'address': competitor.addressController.text,
//             'market_share': competitor.marketShareController.text,
//           }).toList(),
//           'business_reputation': businessReputation ?? '',
//           'production_type': productionType ?? '',
//           'product_name': productNameController.text,
//           'production_capacity': productionCapacityController.text,
//           'actual_production': actualProductionController.text,
//           'profitability_observation': profitabilityObservationController.text,
          
//           // Labor Force
//           'male_officer': maleOfficerController.text,
//           'female_officer': femaleOfficerController.text,
//           'skilled_officer': skilledOfficerController.text,
//           'unskilled_officer': unskilledOfficerController.text,
//           'male_worker': maleWorkerController.text,
//           'female_worker': femaleWorkerController.text,
//           'skilled_worker': skilledWorkerController.text,
//           'unskilled_worker': unskilledWorkerController.text,
          
//           // Key Employees
//           'key_employees': employees.map((employee) => {
//             'name': employee.nameController.text,
//             'designation': employee.designationController.text,
//             'age': employee.ageController.text,
//             'qualification': employee.qualificationController.text,
//             'experience': employee.experienceController.text,
//           }).toList(),
          
//           // Section H - Property & Assets
//           'cash_balance': cashBalanceController.text,
//           'stock_trade_finished': stockTradeFinishedController.text,
//           'stock_trade_financial': stockTradeFinancialController.text,
//           'accounts_receivable': accountsReceivableController.text,
//           'advance_deposit': advanceDepositController.text,
//           'other_current_assets': otherCurrentAssetsController.text,
//           'land_building': landBuildingController.text,
//           'plant_machinery': plantMachineryController.text,
//           'other_assets': otherAssetsController.text,
//           'ibbl_investment': ibblController.text,
//           'other_banks_investment': otherBanksController.text,
//           'borrowing_sources': borrowingSourcesController.text,
//           'accounts_payable': accountsPayableController.text,
//           'other_current_liabilities': otherCurrentLiabilitiesController.text,
//           'long_term_liabilities': longTermLiabilitiesController.text,
//           'other_non_current_liabilities': otherNonCurrentLiabilitiesController.text,
//           'paid_up_capital': paidUpCapitalController.text,
//           'retained_earning': retainedEarningController.text,
//           'resources': resourcesController.text,
          
//           // Auto-calculated financial values
//           'current_assets_subtotal': _currentAssetsSubTotal,
//           'fixed_assets_subtotal': _fixedAssetsSubTotal,
//           'total_assets': _totalAssets,
//           'current_liabilities_subtotal': _currentLiabilitiesSubTotal,
//           'total_liabilities': _totalLiabilities,
//           'total_equity': _totalEquity,
//           'grand_total': _grandTotal,
//           'net_worth': _netWorth,
          
//           // Section I - Working Capital Assessment
//           'working_capital_items': workingCapitalItems.map((item) => {
//             'name': item.name,
//             'unit': item.unitController.text,
//             'rate': item.rateController.text,
//             'amount': item.amountController.text,
//             'tied_up_days': item.tiedUpDaysController.text,
//             'amount_dxe': item.amountDxeController.text,
//           }).toList(),
          
//           // Section J - Godown Particulars
//           'godown_location': godownLocationController.text,
//           'godown_capacity': godownCapacityController.text,
//           'godown_space': godownSpaceController.text,
//           'godown_nature': godownNatureController.text,
//           'godown_owner': godownOwnerController.text,
//           'distance_from_branch': distanceFromBranchController.text,
//           'items_to_store': itemsToStoreController.text,
//           'warehouse_license': warehouseLicense,
//           'godown_guard': godownGuard,
//           'damp_proof': dampProof,
//           'easy_access': easyAccess,
//           'letter_disclaimer': letterDisclaimer,
//           'insurance_policy': insurancePolicy,
//           'godown_hired': godownHired,
          
//           // Section K - Checklist
//           'checklist_items': checklistItems,
          
//           // Section L - Site Photos & Video
//           'site_photos': await _preparePhotosData(),
//           'site_video': await _prepareVideoData(),
          
//           // Section M - Documents Upload
//           'uploaded_documents': _prepareDocumentsData(),
          
//           // Status field
//           'status': selectedStatus ?? 'Pending',
          
//           // Timestamp
//           'submitted_at': DateTime.now().toIso8601String(),
//         };

//         bool success;
//         if (widget.isEditMode) {
//           // UPDATE existing inspection
//           success = await _inspectionService.updateInspection(
//             widget.inspectionData!['id'],
//             inspectionData,
//           );
//         } else {
//           // CREATE new inspection
//           success = await _inspectionService.submitInspection(inspectionData);
//         }

//         setState(() {
//           _isLoading = false;
//         });

//         if (success) {
//           _showSnackBar(
//             widget.isEditMode 
//               ? 'Inspection updated successfully! ✅' 
//               : 'Inspection submitted successfully! ✅',
//             isError: false
//           );
          
//           // Return true to indicate success
//           if (mounted) {
//             Navigator.of(context).pop(true);
//           }
//         } else {
//           _showSnackBar(
//             widget.isEditMode 
//               ? 'Failed to update inspection. Please try again.' 
//               : 'Failed to submit inspection. Please try again.',
//             isError: true
//           );
//         }
//       } catch (e) {
//         setState(() {
//           _isLoading = false;
//         });
//         _showSnackBar('Error: $e', isError: true);
//         print('❌ Submission error: $e');
//       }
//     } else {
//       _showSnackBar('Please fill all required fields correctly.', isError: true);
//     }
//   }

//   // Prepare photos data for submission
//   Future<List<Map<String, dynamic>>> _preparePhotosData() async {
//     List<Map<String, dynamic>> photosData = [];
    
//     for (int i = 0; i < sitePhotos.length; i++) {
//       File photo = sitePhotos[i];
//       List<int> bytes = await photo.readAsBytes();
//       String base64Image = base64Encode(bytes);
      
//       photosData.add({
//         'index': i,
//         'file_name': 'site_photo_${i + 1}.jpg',
//         'file_size': await photo.length(),
//         'base64_data': base64Image,
//         'uploaded_at': DateTime.now().toIso8601String(),
//         'description': 'Site photo ${i + 1}'
//       });
//     }
    
//     return photosData;
//   }

//   // Prepare video data for submission
//   Future<Map<String, dynamic>?> _prepareVideoData() async {
//     if (siteVideo == null) return null;
    
//     File video = siteVideo!;
//     List<int> bytes = await video.readAsBytes();
//     String base64Video = base64Encode(bytes);
    
//     return {
//       'file_name': 'site_video.mp4',
//       'file_size': await video.length(),
//       'base64_data': base64Video,
//       'uploaded_at': DateTime.now().toIso8601String(),
//       'description': 'Site documentation video'
//     };
//   }

//   // Prepare documents data for submission
//   List<Map<String, dynamic>> _prepareDocumentsData() {
//     return uploadedDocuments.map((doc) => {
//       'name': doc.name,
//       'file_path': doc.path,
//       'upload_date': doc.uploadDate.toIso8601String(),
//       'file_type': _getFileType(doc.name),
//     }).toList();
//   }

//   String _getFileType(String fileName) {
//     String extension = fileName.split('.').last.toLowerCase();
//     if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
//       return 'image';
//     } else if (['pdf'].contains(extension)) {
//       return 'pdf';
//     } else if (['doc', 'docx'].contains(extension)) {
//       return 'document';
//     } else {
//       return 'other';
//     }
//   }

//   void _clearForm() {
//     // Clear all text controllers
//     clientNameController.clear();
//     groupNameController.clear();
//     industryNameController.clear();
//     natureOfBusinessController.clear();
//     legalStatusController.clear();
//     dateOfEstablishmentController.clear();
//     officeAddressController.clear();
//     showroomAddressController.clear();
//     factoryAddressController.clear();
//     phoneController.clear();
//     accountNoController.clear();
//     accountIdController.clear();
//     tinController.clear();
//     dateOfOpeningController.clear();
//     vatRegController.clear();
//     firstInvestmentDateController.clear();
//     sectorCodeController.clear();
//     tradeLicenseController.clear();
//     economicPurposeController.clear();
    
//     ownerNameController.clear();
//     ownerAgeController.clear();
//     fatherNameController.clear();
//     motherNameController.clear();
//     spouseNameController.clear();
//     academicQualificationController.clear();
//     childrenInfoController.clear();
//     businessSuccessorController.clear();
//     residentialAddressController.clear();
//     permanentAddressController.clear();
    
//     purposeInvestmentController.clear();
//     purposeBankGuaranteeController.clear();
//     periodInvestmentController.clear();
    
//     existingLimitController.clear();
//     appliedLimitController.clear();
//     recommendedLimitController.clear();
//     bankPercentageController.clear();
//     clientPercentageController.clear();
    
//     limitController.clear();
//     netOutstandingController.clear();
//     grossOutstandingController.clear();
    
//     productNameController.clear();
//     productionCapacityController.clear();
//     actualProductionController.clear();
//     profitabilityObservationController.clear();
    
//     maleOfficerController.clear();
//     femaleOfficerController.clear();
//     skilledOfficerController.clear();
//     unskilledOfficerController.clear();
//     maleWorkerController.clear();
//     femaleWorkerController.clear();
//     skilledWorkerController.clear();
//     unskilledWorkerController.clear();
    
//     cashBalanceController.clear();
//     stockTradeFinishedController.clear();
//     stockTradeFinancialController.clear();
//     accountsReceivableController.clear();
//     advanceDepositController.clear();
//     otherCurrentAssetsController.clear();
//     landBuildingController.clear();
//     plantMachineryController.clear();
//     otherAssetsController.clear();
//     ibblController.clear();
//     otherBanksController.clear();
//     borrowingSourcesController.clear();
//     accountsPayableController.clear();
//     otherCurrentLiabilitiesController.clear();
//     longTermLiabilitiesController.clear();
//     otherNonCurrentLiabilitiesController.clear();
//     paidUpCapitalController.clear();
//     retainedEarningController.clear();
//     resourcesController.clear();
    
//     godownLocationController.clear();
//     godownCapacityController.clear();
//     godownSpaceController.clear();
//     godownNatureController.clear();
//     godownOwnerController.clear();
//     distanceFromBranchController.clear();
//     itemsToStoreController.clear();
    
//     // Clear dropdowns and selections
//     setState(() {
//       selectedInvestmentCategory = null;
//       selectedFacilityType = null;
//       selectedOutstandingType = null;
//       marketSituation = null;
//       clientPosition = null;
//       businessReputation = null;
//       productionType = null;
//       selectedStatus = 'Pending';
      
//       warehouseLicense = false;
//       godownGuard = false;
//       dampProof = false;
//       easyAccess = false;
//       letterDisclaimer = false;
//       insurancePolicy = false;
//       godownHired = false;
      
//       // Clear dynamic lists
//       partners = [Partner()];
//       employees = [Employee()];
//       sitePhotos = [];
//       siteVideo = null;
//       uploadedDocuments = [];
      
//       // Reset checklist
//       checklistItems = checklistItems.map((key, value) => MapEntry(key, null));
      
//       // Reset working capital items
//       for (var item in workingCapitalItems) {
//         item.unitController.clear();
//         item.rateController.clear();
//         item.amountController.clear();
//         item.tiedUpDaysController.clear();
//         item.amountDxeController.clear();
//       }

//       // Reset location data
//       _isLocationTracking = false;
//       _locationPoints.clear();
//       _locationStartTime = null;
//       _locationEndTime = null;
//       if (_locationTimer != null) {
//         _locationTimer!.cancel();
//         _locationTimer = null;
//       }

//       // Reset calculated values
//       _currentAssetsSubTotal = 0.0;
//       _fixedAssetsSubTotal = 0.0;
//       _totalAssets = 0.0;
//       _currentLiabilitiesSubTotal = 0.0;
//       _totalLiabilities = 0.0;
//       _totalEquity = 0.0;
//       _grandTotal = 0.0;
//       _netWorth = 0.0;
//     });
//   }

//   // Media handling methods
//   Future<void> _pickSitePhotos() async {
//     try {
//       final List<XFile> images = await _imagePicker.pickMultiImage(
//         maxWidth: 1920, maxHeight: 1080, imageQuality: 85);
//       if (images != null && images.isNotEmpty) {
//         setState(() {
//           for (var image in images) {
//             if (sitePhotos.length < 10) sitePhotos.add(File(image.path));
//           }
//         });
//         _showSnackBar('${images.length} photos selected', isError: false);
//       }
//     } catch (e) {
//       _showSnackBar('Error picking photos: $e', isError: true);
//     }
//   }

//   Future<void> _pickSiteVideo() async {
//     try {
//       final XFile? video = await _imagePicker.pickVideo(
//         source: ImageSource.camera, maxDuration: Duration(minutes: 2));
//       if (video != null) {
//         setState(() {
//           siteVideo = File(video.path);
//         });
//         _showSnackBar('Video selected successfully', isError: false);
//       }
//     } catch (e) {
//       _showSnackBar('Error picking video: $e', isError: true);
//     }
//   }

//   Future<void> _pickDocuments() async {
//     try {
//       final XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
//       if (file != null) {
//         setState(() {
//           uploadedDocuments.add(DocumentFile(
//             name: file.name, 
//             path: file.path, 
//             uploadDate: DateTime.now()
//           ));
//         });
//         _showSnackBar('Document added: ${file.name}', isError: false);
//       }
//     } catch (e) {
//       _showSnackBar('Error picking document: $e', isError: true);
//     }
//   }

//   void _removeSitePhoto(int index) {
//     setState(() {
//       sitePhotos.removeAt(index);
//     });
//     _showSnackBar('Photo removed', isError: false);
//   }

//   void _removeSiteVideo() {
//     setState(() {
//       siteVideo = null;
//     });
//     _showSnackBar('Video removed', isError: false);
//   }

//   void _removeDocument(int index) {
//     setState(() {
//       uploadedDocuments.removeAt(index);
//     });
//     _showSnackBar('Document removed', isError: false);
//   }

//   void _showSnackBar(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Colors.green,
//         duration: Duration(seconds: 3),
//       )
//     );
//   }

//   // UI Helper methods
//   Widget _buildSectionContainer(String title, Widget child) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16),
//       margin: EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF116045))),
//           SizedBox(height: 16),
//           child,
//         ],
//       ),
//     );
//   }

//   Widget _buildSubSectionHeader(String title) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(8),
//       margin: EdgeInsets.only(top: 16, bottom: 8),
//       decoration: BoxDecoration(
//         color: Colors.grey[100], 
//         border: Border.all(color: Colors.grey), 
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller, {bool isRequired = false, int maxLines = 1}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           labelText: '$label${isRequired ? ' *' : ''}',
//           border: OutlineInputBorder(),
//           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         ),
//         validator: isRequired ? (value) {
//           if (value == null || value.isEmpty) return 'Please enter $label';
//           return null;
//         } : null,
//       ),
//     );
//   }

//   Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged, {bool isRequired = false}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           labelText: '$label${isRequired ? ' *' : ''}',
//           border: OutlineInputBorder(),
//           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         ),
//         items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
//         onChanged: onChanged,
//         validator: isRequired ? (value) {
//           if (value == null || value.isEmpty) return 'Please select $label';
//           return null;
//         } : null,
//       ),
//     );
//   }

//   Widget _buildRadioGroup(String title, List<String> options, String? selectedValue, Function(String?) onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//         ...options.map((option) {
//           return RadioListTile<String>(
//             title: Text(option),
//             value: option,
//             groupValue: selectedValue,
//             onChanged: onChanged,
//           );
//         }).toList(),
//       ],
//     );
//   }

//   Widget _buildCheckboxOption(String label, bool value, Function(bool?) onChanged) {
//     return CheckboxListTile(
//       title: Text(label),
//       value: value,
//       onChanged: onChanged,
//     );
//   }

//   List<Widget> _buildChecklistItems(int start, int end) {
//     List<Widget> items = [];
//     var entries = checklistItems.entries.toList();
//     for (int i = start; i <= end && i < entries.length; i++) {
//       var entry = entries[i];
//       items.add(_buildChecklistRow(entry.key, entry.value, (value) {
//         setState(() { checklistItems[entry.key] = value; });
//       }));
//     }
//     return items;
//   }

//   Widget _buildChecklistRow(String label, bool? value, Function(bool?) onChanged) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8),
//       child: Row(
//         children: [
//           Expanded(flex: 3, child: Text(label, style: TextStyle(fontSize: 14))),
//           Radio<bool>(value: true, groupValue: value, onChanged: onChanged),
//           Text('Yes', style: TextStyle(fontSize: 12)),
//           SizedBox(width: 10),
//           Radio<bool>(value: false, groupValue: value, onChanged: onChanged),
//           Text('No', style: TextStyle(fontSize: 12)),
//           SizedBox(width: 10),
//           Radio<bool?>(value: null, groupValue: value, onChanged: onChanged),
//           Text('N/A', style: TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }

//   Widget _buildPartnerRow(Partner partner, int index) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 10),
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text('Partner/Director ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Spacer(),
//                 if (partners.length > 1) IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => _removePartner(index),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             _buildTextField('Name with Father\'s / husband\'s', partner.nameController),
//             _buildTextField('Age', partner.ageController),
//             _buildTextField('Academic Qualification', partner.qualificationController),
//             _buildTextField('Extent of Share (%)', partner.shareController),
//             _buildTextField('Status', partner.statusController),
//             _buildTextField('Relationship with Chairman /MD name', partner.relationshipController),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCompetitorRow(Competitor competitor, int index) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 8),
//       child: Padding(
//         padding: EdgeInsets.all(8),
//         child: Column(
//           children: [
//             Text('Competitor ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
//             _buildTextField('Name', competitor.nameController),
//             _buildTextField('Address', competitor.addressController),
//             _buildTextField('Market Share', competitor.marketShareController),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmployeeRow(Employee employee, int index) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 10),
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text('Employee ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Spacer(),
//                 if (employees.length > 1) IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => _removeEmployee(index),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             _buildTextField('Name', employee.nameController),
//             _buildTextField('Designation', employee.designationController),
//             _buildTextField('Age', employee.ageController),
//             _buildTextField('Education Qualification', employee.qualificationController),
//             _buildTextField('Experience', employee.experienceController),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAssetCard(String label, TextEditingController controller) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 4),
//       elevation: 1,
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//             SizedBox(height: 8),
//             TextFormField(
//               controller: controller,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'Enter amount in Tk.',
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 prefixText: 'Tk. ',
//               ),
//               onChanged: (value) {
//                 // Trigger calculations when values change
//                 if (label.contains('Cash') || label.contains('Stock') || label.contains('Accounts') || 
//                     label.contains('Advance') || label.contains('Other current') || 
//                     label.contains('Land') || label.contains('Plant') || label.contains('Other assets')) {
//                   _calculateAssets();
//                 } else if (label.contains('IBBL') || label.contains('Others') || label.contains('Borrowing') || 
//                            label.contains('Accounts Payable') || label.contains('Other current liabilities') ||
//                            label.contains('Long Term') || label.contains('Other non-current')) {
//                   _calculateLiabilities();
//                 } else if (label.contains('Paid up capital') || label.contains('Retained') || label.contains('Resources')) {
//                   _calculateEquity();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDocumentChip(String label) {
//     return Chip(
//       label: Text(label),
//       backgroundColor: Colors.blue[100],
//       labelStyle: TextStyle(fontSize: 12),
//     );
//   }

//   Widget _buildDocumentItem(DocumentFile doc, int index) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 4),
//       child: ListTile(
//         leading: Icon(Icons.description, color: Colors.blue),
//         title: Text(doc.name),
//         subtitle: Text('Uploaded: ${_formatDate(doc.uploadDate)}'),
//         trailing: IconButton(
//           icon: Icon(Icons.delete, color: Colors.red),
//           onPressed: () => _removeDocument(index),
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

//   // Methods for dynamic lists
//   void _addPartner() { 
//     setState(() { partners.add(Partner()); }); 
//   }
  
//   void _removePartner(int index) { 
//     setState(() { partners.removeAt(index); }); 
//   }
  
//   void _addEmployee() { 
//     setState(() { employees.add(Employee()); }); 
//   }
  
//   void _removeEmployee(int index) { 
//     setState(() { employees.removeAt(index); }); 
//   }

//   // Location Tracking UI
//   Widget _buildLocationTrackingSection() {
//     return _buildSectionContainer('Location Tracking', Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Automatically capture location every 5 minutes while filling the form',
//           style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//         ),
//         SizedBox(height: 16),
        
//         // Location Status
//         Container(
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: _isLocationTracking ? Colors.green[50] : Colors.grey[100],
//             border: Border.all(color: _isLocationTracking ? Colors.green : Colors.grey),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 _isLocationTracking ? Icons.location_on : Icons.location_off,
//                 color: _isLocationTracking ? Colors.green : Colors.grey,
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _isLocationTracking ? 'Location Tracking Active' : 'Location Tracking Inactive',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: _isLocationTracking ? Colors.green : Colors.grey,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       _isLocationTracking 
//                           ? '${_locationPoints.length} points captured • Started: ${_formatTime(_locationStartTime!)}'
//                           : 'Click "Start Location" to begin tracking',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
        
//         SizedBox(height: 16),
        
//         // Location Buttons
//         Row(
//           children: [
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: _isLocationTracking ? null : _startLocationTracking,
//                 icon: Icon(Icons.play_arrow),
//                 label: Text('Start Location'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: _isLocationTracking ? _stopLocationTracking : null,
//                 icon: Icon(Icons.stop),
//                 label: Text('Stop Location'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//           ],
//         ),
        
//         SizedBox(height: 16),
        
//         // Location Points Summary
//         if (_locationPoints.isNotEmpty) ...[
//           _buildSubSectionHeader('Location Points Captured'),
//           Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.blue[50],
//               border: Border.all(color: Colors.blue),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Total Points:', style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text('${_locationPoints.length}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 if (_locationStartTime != null) 
//                   Text('Started: ${_formatDateTime(_locationStartTime!)}'),
//                 if (_locationEndTime != null) 
//                   Text('Ended: ${_formatDateTime(_locationEndTime!)}'),
//                 SizedBox(height: 8),
//                 Text(
//                   'Latest: ${_locationPoints.last['latitude']?.toStringAsFixed(4)}, ${_locationPoints.last['longitude']?.toStringAsFixed(4)}',
//                   style: TextStyle(fontSize: 12, fontFamily: 'Monospace'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ],
//     ));
//   }

//   String _formatTime(DateTime date) => '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//   String _formatDateTime(DateTime date) => '${_formatDate(date)} ${_formatTime(date)}';

//   // Section Builders
//   Widget _buildSectionA() {
//     return _buildSectionContainer('A. Company\'s Client\'s Information', Column(children: [
//       _buildTextField('Name of the Client', clientNameController, isRequired: true),
//       _buildTextField('Group Name (if any)', groupNameController),
//       _buildTextField('Industry Name (as per CIB)', industryNameController, isRequired: true),
//       _buildTextField('Nature of Business', natureOfBusinessController, isRequired: true),
//       _buildTextField('Legal Status', legalStatusController, isRequired: true),
//       _buildTextField('Date of Establishment', dateOfEstablishmentController, isRequired: true),
//       _buildSubSectionHeader('Address'),
//       _buildTextField('Office', officeAddressController, isRequired: true),
//       _buildTextField('Show Room', showroomAddressController),
//       _buildTextField('Factory / Godown/ Depot', factoryAddressController),
//       _buildTextField('Phone / Mobile no (office)', phoneController, isRequired: true),
//       _buildTextField('Current A/C no', accountNoController, isRequired: true),
//       _buildTextField('A/C ID no', accountIdController, isRequired: true),
//       _buildTextField('TIN', tinController, isRequired: true),
//       _buildTextField('Date of Opening', dateOfOpeningController),
//       _buildTextField('VAT Reg: no', vatRegController),
//       _buildTextField('Date of 1st Investment availed', firstInvestmentDateController),
//       _buildTextField('Sector Code', sectorCodeController),
//       _buildTextField('Trade License No & Date', tradeLicenseController, isRequired: true),
//       _buildTextField('Economic Purpose Code', economicPurposeController),
//       _buildSubSectionHeader('Investment Category'),
//       _buildDropdown('Select Investment Category', selectedInvestmentCategory, investmentCategories, (value) {
//         setState(() { selectedInvestmentCategory = value; });
//       }, isRequired: true),
//     ]));
//   }

//   Widget _buildSectionB() {
//     return _buildSectionContainer('B. Owner Information', Column(children: [
//       _buildTextField('Name of the Owner (S) & status', ownerNameController, isRequired: true),
//       _buildTextField('Age', ownerAgeController),
//       _buildTextField('Father\'s Name', fatherNameController),
//       _buildTextField('Mother\'s Name', motherNameController),
//       _buildTextField('Spouse\'s Name', spouseNameController),
//       _buildTextField('Academic Qualification', academicQualificationController),
//       _buildTextField('No. of Children with age', childrenInfoController),
//       _buildTextField('Business Successor: \n(Name relations Age & qualification)', businessSuccessorController),
//       _buildTextField('Residential Address:', residentialAddressController, isRequired: true),
//       _buildTextField('Permanent Address:', permanentAddressController, isRequired: true),
//     ]));
//   }

//   Widget _buildSectionC() {
//     return _buildSectionContainer('C. List of Partners / Directors', Column(children: [
//       ...partners.asMap().entries.map((entry) => _buildPartnerRow(entry.value, entry.key)),
//       SizedBox(height: 10),
//       ElevatedButton.icon(
//         onPressed: _addPartner,
//         icon: Icon(Icons.add),
//         label: Text('Add Another Partner/Director'),
//         style: ElevatedButton.styleFrom( backgroundColor: Color(0xFF116045),foregroundColor: Colors.white,),
//       ),
//     ]));
//   }

//   Widget _buildSectionD() {
//     return _buildSectionContainer('D. Purpose of Investment / Facilities', Column(children: [
//       _buildTextField('Purpose of Investment', purposeInvestmentController, isRequired: true),
//       _buildTextField('Purpose of Bank Guarantee', purposeBankGuaranteeController),
//       _buildTextField('Period of Investment', periodInvestmentController, isRequired: true),
//     ]));
//   }

//   Widget _buildSectionE() {
//     return _buildSectionContainer('E. Details of proposed Facilities/Investment', Column(children: [
//       _buildDropdown('Select Facility Type', selectedFacilityType, facilityTypes, (value) {
//         setState(() { selectedFacilityType = value; });
//       }, isRequired: true),
//       SizedBox(height: 16),
//       Table(
//         border: TableBorder.all(),
//         children: [
//           TableRow(children: [
//             TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Existing Limit (tk)'))),
//             TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//               controller: existingLimitController,
//               decoration: InputDecoration(hintText: 'Enter amount'),
//             ))),
//           ]),
//           TableRow(children: [
//             TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Limit Applied by the client (tk)'))),
//             TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//               controller: appliedLimitController,
//               decoration: InputDecoration(hintText: 'Enter amount'),
//             ))),
//           ]),
//           TableRow(children: [
//             TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Limit Recommended By the Branch (tk)'))),
//             TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//               controller: recommendedLimitController,
//               decoration: InputDecoration(hintText: 'Enter amount'),
//             ))),
//           ]),
//         ],
//       ),
//       SizedBox(height: 16),
//       _buildSubSectionHeader('Rate of return profit sharing ratio'),
//       Row(children: [
//         Expanded(child: TextFormField(
//           controller: bankPercentageController,
//           decoration: InputDecoration(labelText: 'Bank (%)', border: OutlineInputBorder())
//         )),
//         SizedBox(width: 16),
//         Expanded(child: TextFormField(
//           controller: clientPercentageController,
//           decoration: InputDecoration(labelText: 'Client (%)', border: OutlineInputBorder())
//         )),
//       ]),
//     ]));
//   }

//   Widget _buildSectionF() {
//     return _buildSectionContainer('F. Break up of Present Outstanding', Column(children: [
//       _buildDropdown('Select Outstanding Type', selectedOutstandingType, outstandingTypes, (value) {
//         setState(() { selectedOutstandingType = value; });
//       },isRequired: true),
//       SizedBox(height: 16),
//       Table(
//         border: TableBorder.all(),
//         children: [
//           TableRow(children: [
//             TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Limit'))),
//             TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//               controller: limitController,
//               decoration: InputDecoration(hintText: 'Enter limit'),
//             ))),
//           ]),
//           TableRow(children: [
//             TableCell(child: Column(children: [
//               Padding(padding: EdgeInsets.all(8), child: Text('Outstanding:')),
//               Table(border: TableBorder.all(), children: [
//                 TableRow(children: [
//                   TableCell(child: Padding(padding: EdgeInsets.all(4), child: Text('Net'))),
//                   TableCell(child: Padding(padding: EdgeInsets.all(4), child: TextFormField(
//                     controller: netOutstandingController,
//                     decoration: InputDecoration(hintText: 'Net amount'),
//                   ))),
//                 ]),
//                 TableRow(children: [
//                   TableCell(child: Padding(padding: EdgeInsets.all(4), child: Text('Gross'))),
//                   TableCell(child: Padding(padding: EdgeInsets.all(4), child: TextFormField(
//                     controller: grossOutstandingController,
//                     decoration: InputDecoration(hintText: 'Gross amount'),
//                   ))),
//                 ]),
//               ]),
//             ])),
//             TableCell(child: Container()),
//           ]),
//         ],
//       ),
//     ]));
//   }

//   Widget _buildSectionG() {
//     return _buildSectionContainer('G. Business Industry / Analysis', Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSubSectionHeader('Market Situation'),
//         _buildRadioGroup('', marketSituations, marketSituation, (value) { 
//           setState(() { marketSituation = value; }); 
//         }),
//         SizedBox(height: 16),
//         _buildSubSectionHeader('Client\'s Position in the Industry'),
//         _buildRadioGroup('', clientPositions, clientPosition, (value) { 
//           setState(() { clientPosition = value; }); 
//         }),
//         SizedBox(height: 16),
//         _buildSubSectionHeader('Name of 5 main competitors'),
//         ...competitors.asMap().entries.map((entry) => _buildCompetitorRow(entry.value, entry.key)),
//         SizedBox(height: 16),
//         _buildSubSectionHeader('Business reputation'),
//         _buildRadioGroup('', reputationOptions, businessReputation, (value) { 
//           setState(() { businessReputation = value; }); 
//         }),
//         SizedBox(height: 16),
//         _buildSubSectionHeader('Production'),
//         _buildRadioGroup('', productionTypes, productionType, (value) { 
//           setState(() { productionType = value; }); 
//         }),
//         SizedBox(height: 16),
//         _buildTextField('Name of the Product', productNameController),
//         _buildTextField('Production Capacity: Units / Year', productionCapacityController),
//         _buildTextField('Actual Production: Units / Year', actualProductionController),
//         SizedBox(height: 16),
//         _buildTextField('Observation on profitability / marketability of the goods', profitabilityObservationController, maxLines: 3),
//         SizedBox(height: 16),
//         _buildSubSectionHeader('Size of the labor force'),
//         Table(
//           border: TableBorder.all(),
//           children: [
//             TableRow(children: [
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text(''))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Male'))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Female'))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Skilled'))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Unskilled'))),
//             ]),
//             TableRow(children: [
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Officer / Staff'))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//                 controller: maleOfficerController,
//                 decoration: InputDecoration(hintText: 'Count'),
//               ))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//                 controller: femaleOfficerController,
//                 decoration: InputDecoration(hintText: 'Count'),
//               ))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//                 controller: skilledOfficerController,
//                 decoration: InputDecoration(hintText: 'Count'),
//               ))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//                 controller: unskilledOfficerController,
//                 decoration: InputDecoration(hintText: 'Count'),
//               ))),
//             ]),
//             TableRow(children: [
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Labor / Worker'))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//                 controller: maleWorkerController,
//                 decoration: InputDecoration(hintText: 'Count'),
//               ))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//                 controller: femaleWorkerController,
//                 decoration: InputDecoration(hintText: 'Count'),
//               ))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//                 controller: skilledWorkerController,
//                 decoration: InputDecoration(hintText: 'Count'),
//               ))),
//               TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
//                 controller: unskilledWorkerController,
//                 decoration: InputDecoration(hintText: 'Count'),
//               ))),
//             ]),
//           ],
//         ),
//         SizedBox(height: 16),
//         _buildSubSectionHeader('Name of the key employee of the Firm'),
//         ...employees.asMap().entries.map((entry) => _buildEmployeeRow(entry.value, entry.key)),
//         SizedBox(height: 10),
//         ElevatedButton.icon(
//           onPressed: _addEmployee,
//           icon: Icon(Icons.add),
//           label: Text('Add Another Employee'),
//           style: ElevatedButton.styleFrom( backgroundColor: Color(0xFF116045),foregroundColor: Colors.white,),
//         ),
//       ],
//     ));
//   }

//   Widget _buildSectionH() {
//     return _buildSectionContainer('H. Property & Assets', Column(children: [
//       Card(
//         elevation: 2,
//         child: Padding(
//           padding: EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Property & Assets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[800])),
//               SizedBox(height: 16),
//               _buildSubSectionHeader('Current Assets'),
//               _buildAssetCard('1. Cash & Bank Balance', cashBalanceController),
//               _buildAssetCard('Stock in trade & investment/finished goods', stockTradeFinishedController),
//               _buildAssetCard('2. Stock in trade & investment/financial goods', stockTradeFinancialController),
//               _buildAssetCard('3. Accounts receivable (Sundry Debtors)', accountsReceivableController),
//               _buildAssetCard('4. Advance Deposit & Pre-payment', advanceDepositController),
//               _buildAssetCard('5. Other current assets', otherCurrentAssetsController),
//               SizedBox(height: 8),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text('Sub-Total (a):', style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10)),
//                     Text(' Tk. ${_currentAssetsSubTotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               _buildSubSectionHeader('Fixed Assets'),
//               _buildAssetCard('6. Land, Building & other immovable assets', landBuildingController),
//               _buildAssetCard('7. Plant, Machinery & furniture & fixture', plantMachineryController),
//               _buildAssetCard('8. Other assets', otherAssetsController),
//               SizedBox(height: 8),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text('Sub-Total (b): ', style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10)),
//                     Text('Tk. ${_fixedAssetsSubTotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                 decoration: BoxDecoration(color: Colors.blue[50], border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(8)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text('A. Grand Total (a+b): ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//                     Text('Tk. ${_totalAssets.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       SizedBox(height: 16),
//       Card(
//         elevation: 2,
//         child: Padding(
//           padding: EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Liabilities and Owner\'s Equity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red[800])),
//               SizedBox(height: 16),
//               _buildSubSectionHeader('Current Liabilities'),
//               Card(
//                 margin: EdgeInsets.symmetric(vertical: 4),
//                 color: Colors.grey[100],
//                 elevation: 1,
//                 child: Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Text('1. Investment from Bank/Financial Institutions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//               Padding(padding: EdgeInsets.only(left: 16), child: _buildAssetCard('a) IBBL', ibblController)),
//               Padding(padding: EdgeInsets.only(left: 16), child: _buildAssetCard('b) Others', otherBanksController)),
//               _buildAssetCard('2. Borrowing from other sources', borrowingSourcesController),
//               _buildAssetCard('3. Accounts Payable (Sundry Creditors)', accountsPayableController),
//               _buildAssetCard('4. Others', otherCurrentLiabilitiesController),
//               SizedBox(height: 8),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text('Sub-Total (a): ', style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10)),
//                     Text('Tk. ${_currentLiabilitiesSubTotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               _buildSubSectionHeader('Long Term Liability'),
//               _buildAssetCard('Long Term Liability', longTermLiabilitiesController),
//               SizedBox(height: 16),
//               _buildSubSectionHeader('Other non-current liabilities'),
//               _buildAssetCard('Other non-current liabilities', otherNonCurrentLiabilitiesController),
//               SizedBox(height: 8),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('B. Total Liabilities (a+b+c): ', style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10)),
//                     Text('Tk. ${_totalLiabilities.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               _buildSubSectionHeader('Owner\'s Equity'),
//               _buildAssetCard('d. Paid up capital / owner\'s Capital Balance as per last account', paidUpCapitalController),
//               _buildAssetCard('e. Resources', resourcesController),
//               _buildAssetCard('I. Retained Earning / Net Profit for the year transferred to Balance Sheet', retainedEarningController),
//               SizedBox(height: 8),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text('C. Total Equity (d+e+f): ', style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10)),
//                     Text('Tk. ${_totalEquity.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                 decoration: BoxDecoration(color: Colors.green[50], border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(8)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text('Grand Total (a+b+c+d+e+f): ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//                     Text('Tk. ${_grandTotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       SizedBox(height: 16),
//       Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         decoration: BoxDecoration(color: Colors.orange[50], border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(8)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text('NET WORTH\n(Total Assets - Total Liabilities): ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.orange[800])),
//             Text('Tk. ${_netWorth.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange[800])),
//           ],
//         ),
//       ),
//     ]));
//   }

//   Widget _buildSectionI() {
//     return _buildSectionContainer('I. Working Capital Assessment: N/A', Column(children: [
//       SizedBox(
//         width: double.infinity,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Container(
//             constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
//             child: DataTable(
//               columnSpacing: 20,
//               dataRowHeight: 60,
//               headingRowHeight: 80,
//               border: TableBorder.all(color: Colors.black, width: 1),
//               columns: [
//                 DataColumn(label: SizedBox(width: 150, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold)))),
//                 DataColumn(label: SizedBox(width: 250, child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Daily Requirements', style: TextStyle(fontWeight: FontWeight.bold)),
//                     SizedBox(height: 4),
//                     Row(children: [
//                       Expanded(child: Text('Unit (b)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
//                       Expanded(child: Text('Rate (c)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
//                       Expanded(child: Text('Amount (d)\nd\\e', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
//                     ]),
//                   ],
//                 ))),
//                 DataColumn(label: SizedBox(width: 120, child: Text('Tied up period\nin Days\n(e)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
//                 DataColumn(label: SizedBox(width: 120, child: Text('Amount\nd\\e', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
//               ],
//               rows: workingCapitalItems.map((item) {
//                 return DataRow(cells: [
//                   DataCell(SizedBox(width: 150, child: Text(item.name, style: TextStyle(fontSize: 12)))),
//                   DataCell(Row(children: [
//                     Expanded(child: TextFormField(
//                       controller: item.unitController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         hintText: 'Unit',
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                       ),
//                       onChanged: (value) => _calculateWorkingCapitalItem(item),
//                     )),
//                     SizedBox(width: 4),
//                     Expanded(child: TextFormField(
//                       controller: item.rateController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         hintText: 'Rate',
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                       ),
//                       onChanged: (value) => _calculateWorkingCapitalItem(item),
//                     )),
//                     SizedBox(width: 4),
//                     Expanded(child: TextFormField(
//                       controller: item.amountController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         hintText: 'Amount',
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                       ),
//                       readOnly: true, // This field is auto-calculated
//                     )),
//                   ])),
//                   DataCell(
//                     TextFormField(
//                       controller: item.tiedUpDaysController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         hintText: 'Days',
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                       ),
//                       onChanged: (value) => _calculateWorkingCapitalItem(item),
//                     ),
//                   ),
//                   DataCell(
//                     TextFormField(
//                       controller: item.amountDxeController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         hintText: 'Amount',
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                       ),
//                       readOnly: true, // This field is auto-calculated
//                     ),
//                   ),
//                 ]);
//               }).toList(),
//             ),
//           ),
//         ),
//       ),
//       SizedBox(height: 16),
//       Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           'Note: Amount (d) = Unit (b) × Rate (c)\nAmount d\\e = Amount (d) × Tied up period (e)',
//           style: TextStyle(fontSize: 12, color: Colors.grey[700], fontStyle: FontStyle.italic),
//         ),
//       ),
//     ]));
//   }

//   Widget _buildSectionJ() {
//     return _buildSectionContainer('J. Particulars of the godown for storing MPI/Murabaha goods', Column(children: [
//       _buildTextField('Location of the godown', godownLocationController),
//       _buildTextField('Capacity of godown', godownCapacityController),
//       _buildTextField('Space of godown (Length X Width X Height)', godownSpaceController),
//       _buildTextField('Nature of Godown (Pucca/Semi Pucca and class of godown)', godownNatureController),
//       _buildTextField('Owner of godown (Bank/Client/Third Party)', godownOwnerController),
//       _buildTextField('Distance from the branch (K.M./Mile)', distanceFromBranchController),
//       _buildTextField('item to be stored', itemsToStoreController),
//       SizedBox(height: 16),
//       _buildSubSectionHeader('Godown Facilities'),
//       _buildCheckboxOption('Whether Ware-House License has been obtained from the Competent authority', warehouseLicense, (value) { 
//         setState(() { warehouseLicense = value ?? false; }); 
//       }),
//       _buildCheckboxOption('Whether godown is watched over by the godown guard round the clock', godownGuard, (value) { 
//         setState(() { godownGuard = value ?? false; }); 
//       }),
//       _buildCheckboxOption('Whether godown is damp proof and safe from rain/flood water and other common hazards', dampProof, (value) { 
//         setState(() { dampProof = value ?? false; }); 
//       }),
//       _buildCheckboxOption('Whether the officials of the Branch have easy access to the godown', easyAccess, (value) { 
//         setState(() { easyAccess = value ?? false; }); 
//       }),
//       _buildCheckboxOption('Whether letter of disclaimer is obtained', letterDisclaimer, (value) { 
//         setState(() { letterDisclaimer = value ?? false; }); 
//       }),
//       _buildCheckboxOption('Whether Insurance Policy obtained / updated', insurancePolicy, (value) { 
//         setState(() { insurancePolicy = value ?? false; }); 
//       }),
//       _buildCheckboxOption('Whether the Godown hired by the Bank', godownHired, (value) { 
//         setState(() { godownHired = value ?? false; }); 
//       }),
//     ]));
//   }

//   Widget _buildSectionK() {
//     return _buildSectionContainer('K. Checklist', Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSubSectionHeader('General'),
//         ..._buildChecklistItems(0, 14),
//         _buildSubSectionHeader('Constitution of the Firm'),
//         ..._buildChecklistItems(15, 20),
//         _buildSubSectionHeader('Financial Statements'),
//         ..._buildChecklistItems(21, 24),
//       ],
//     ));
//   }

//   Widget _buildSectionL() {
//     return _buildSectionContainer('L. Site Photos & Video Documentation', Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Upload site photos and video documentation for verification', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//         SizedBox(height: 16),
//         _buildSubSectionHeader('Site Photos (up to 10 images)'),
//         Text('Upload clear photos of the business site, premises, and operations', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//         SizedBox(height: 12),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 8,
//             mainAxisSpacing: 8,
//             childAspectRatio: 1,
//           ),
//           itemCount: sitePhotos.length + 1,
//           itemBuilder: (context, index) {
//             if (index == sitePhotos.length) {
//               return GestureDetector(
//                 onTap: _pickSitePhotos,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.blue, width: 2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.add_photo_alternate, size: 40, color: Colors.blue),
//                       SizedBox(height: 4),
//                       Text('Add Photo', style: TextStyle(color: Colors.blue)),
//                     ],
//                   ),
//                 ),
//               );
//             } else {
//               return Stack(children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     image: DecorationImage(
//                       image: FileImage(sitePhotos[index]),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 4,
//                   right: 4,
//                   child: GestureDetector(
//                     onTap: () => _removeSitePhoto(index),
//                     child: Container(
//                       padding: EdgeInsets.all(4),
//                       decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//                       child: Icon(Icons.close, size: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ]);
//             }
//           },
//         ),
//         SizedBox(height: 20),
//         _buildSubSectionHeader('Site Video (Short documentation)'),
//         Text('Upload a short video (max 2 minutes) showing the business operations and premises', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//         SizedBox(height: 12),
//         Container(
//           width: double.infinity,
//           height: 120,
//           decoration: BoxDecoration(
//             border: Border.all(color: siteVideo != null ? Colors.green : Colors.blue, width: 2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: siteVideo != null ? Stack(children: [
//             Center(child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.videocam, size: 40, color: Colors.green),
//                 SizedBox(height: 8),
//                 Text('Video Selected', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
//                 Text('Tap to change', style: TextStyle(fontSize: 12, color: Colors.grey)),
//               ],
//             )),
//             Positioned(
//               top: 8,
//               right: 8,
//               child: GestureDetector(
//                 onTap: _removeSiteVideo,
//                 child: Container(
//                   padding: EdgeInsets.all(4),
//                   decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//                   child: Icon(Icons.close, size: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ]) : GestureDetector(
//             onTap: _pickSiteVideo,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.video_camera_back, size: 40, color: Colors.blue),
//                 SizedBox(height: 8),
//                 Text('Upload Video', style: TextStyle(color: Colors.blue)),
//                 Text('(Max 2 minutes)', style: TextStyle(fontSize: 12, color: Colors.grey)),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 8),
//         if (sitePhotos.isNotEmpty || siteVideo != null) Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text('${sitePhotos.length} photos ${siteVideo != null ? '+ 1 video' : ''} uploaded', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ],
//     ));
//   }

//   Widget _buildSectionM() {
//     return _buildSectionContainer('M. Supporting Documents Upload', Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Upload all relevant supporting documents (unlimited files)', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//         SizedBox(height: 16),
//         _buildSubSectionHeader('Recommended Documents'),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: [
//             _buildDocumentChip('Trade License'),
//             _buildDocumentChip('TIN Certificate'),
//             _buildDocumentChip('VAT Certificate'),
//             _buildDocumentChip('Bank Statements'),
//             _buildDocumentChip('Audit Reports'),
//             _buildDocumentChip('Property Documents'),
//             _buildDocumentChip('Partnership Deed'),
//             _buildDocumentChip('Memorandum'),
//             _buildDocumentChip('Others'),
//           ],
//         ),
//         SizedBox(height: 16),
//         GestureDetector(
//           onTap: _pickDocuments,
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(vertical: 40),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.blue, width: 2),
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.blue[50],
//             ),
//             child: Column(children: [
//               Icon(Icons.cloud_upload, size: 50, color: Colors.blue),
//               SizedBox(height: 16),
//               Text('Click to Upload Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
//               SizedBox(height: 8),
//               Text('Supported formats: PDF, DOC, DOCX, JPG, PNG\nMaximum file size: 10MB per file', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//             ]),
//           ),
//         ),
//         SizedBox(height: 16),
//         if (uploadedDocuments.isNotEmpty) ...[
//           _buildSubSectionHeader('Uploaded Documents (${uploadedDocuments.length})'),
//           ...uploadedDocuments.asMap().entries.map((entry) => _buildDocumentItem(entry.value, entry.key)),
//         ],
//       ],
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isEditMode ? 'Edit Inspection' : 'Create New Inspection'),
//         backgroundColor: Color(0xFF116045),
//         foregroundColor: Colors.white,
//         actions: [
//           if (widget.isEditMode) 
//             IconButton(
//               icon: Icon(Icons.refresh),
//               onPressed: _clearForm,
//               tooltip: 'Reset Form',
//             ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Location Tracking Section at the top
//                     _buildLocationTrackingSection(),
//                     SizedBox(height: 20),

//                     _buildSectionA(),
//                     SizedBox(height: 20),
//                     _buildSectionB(),
//                     SizedBox(height: 20),
//                     _buildSectionC(),
//                     SizedBox(height: 20),
//                     _buildSectionD(),
//                     SizedBox(height: 20),
//                     _buildSectionE(),
//                     SizedBox(height: 20),
//                     _buildSectionF(),
//                     SizedBox(height: 20),
//                     _buildSectionG(),
//                     SizedBox(height: 20),
//                     _buildSectionH(),
//                     SizedBox(height: 20),
//                     _buildSectionI(),
//                     SizedBox(height: 20),
//                     _buildSectionJ(),
//                     SizedBox(height: 20),
//                     _buildSectionK(),
//                     SizedBox(height: 20),
//                     _buildSectionL(),
//                     SizedBox(height: 20),
//                     _buildSectionM(),
//                     SizedBox(height: 20),
                    
//                     // Status dropdown for edit mode
//                     // if (widget.isEditMode) ...[
//                     //   _buildSectionContainer('Inspection Status', 
//                     //     _buildDropdown('Status', selectedStatus, statusOptions, (value) {
//                     //       setState(() { selectedStatus = value; });
//                     //     }, isRequired: true)
//                     //   ),
//                     //   SizedBox(height: 20),
//                     // ],
                    
//                     // Submit Button
//                     Center(
//                       child: Column(
//                         children: [
//                           ElevatedButton(
//                             onPressed: _submitForm,
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                               backgroundColor: widget.isEditMode ? Colors.orange.shade800 : Colors.green.shade900,
//                               foregroundColor: Colors.white,
//                             ),
//                             child: _isLoading 
//                                 ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                                 : Text(widget.isEditMode ? 'Update Inspection' : 'Submit Complete Form'),
//                           ),
//                           SizedBox(height: 10),
//                           if (!widget.isEditMode)
//                             TextButton(
//                               onPressed: _clearForm,
//                               child: Text('Clear Form', style: TextStyle(color: Colors.red)),
//                             ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   @override
//   void dispose() {
//     // Stop location tracking if active
//     if (_locationTimer != null) {
//       _locationTimer!.cancel();
//     }

//     // Dispose all controllers
//     clientNameController.dispose();
//     groupNameController.dispose();
//     industryNameController.dispose();
//     natureOfBusinessController.dispose();
//     legalStatusController.dispose();
//     dateOfEstablishmentController.dispose();
//     officeAddressController.dispose();
//     showroomAddressController.dispose();
//     factoryAddressController.dispose();
//     phoneController.dispose();
//     accountNoController.dispose();
//     accountIdController.dispose();
//     tinController.dispose();
//     dateOfOpeningController.dispose();
//     vatRegController.dispose();
//     firstInvestmentDateController.dispose();
//     sectorCodeController.dispose();
//     tradeLicenseController.dispose();
//     economicPurposeController.dispose();
//     ownerNameController.dispose();
//     ownerAgeController.dispose();
//     fatherNameController.dispose();
//     motherNameController.dispose();
//     spouseNameController.dispose();
//     academicQualificationController.dispose();
//     childrenInfoController.dispose();
//     businessSuccessorController.dispose();
//     residentialAddressController.dispose();
//     permanentAddressController.dispose();
//     purposeInvestmentController.dispose();
//     purposeBankGuaranteeController.dispose();
//     periodInvestmentController.dispose();
//     existingLimitController.dispose();
//     appliedLimitController.dispose();
//     recommendedLimitController.dispose();
//     bankPercentageController.dispose();
//     clientPercentageController.dispose();
//     limitController.dispose();
//     netOutstandingController.dispose();
//     grossOutstandingController.dispose();
//     productNameController.dispose();
//     productionCapacityController.dispose();
//     actualProductionController.dispose();
//     profitabilityObservationController.dispose();
//     maleOfficerController.dispose();
//     femaleOfficerController.dispose();
//     skilledOfficerController.dispose();
//     unskilledOfficerController.dispose();
//     maleWorkerController.dispose();
//     femaleWorkerController.dispose();
//     skilledWorkerController.dispose();
//     unskilledWorkerController.dispose();
//     cashBalanceController.dispose();
//     stockTradeFinishedController.dispose();
//     stockTradeFinancialController.dispose();
//     accountsReceivableController.dispose();
//     advanceDepositController.dispose();
//     otherCurrentAssetsController.dispose();
//     landBuildingController.dispose();
//     plantMachineryController.dispose();
//     otherAssetsController.dispose();
//     ibblController.dispose();
//     otherBanksController.dispose();
//     borrowingSourcesController.dispose();
//     accountsPayableController.dispose();
//     otherCurrentLiabilitiesController.dispose();
//     longTermLiabilitiesController.dispose();
//     otherNonCurrentLiabilitiesController.dispose();
//     paidUpCapitalController.dispose();
//     retainedEarningController.dispose();
//     resourcesController.dispose();
//     godownLocationController.dispose();
//     godownCapacityController.dispose();
//     godownSpaceController.dispose();
//     godownNatureController.dispose();
//     godownOwnerController.dispose();
//     distanceFromBranchController.dispose();
//     itemsToStoreController.dispose();
    
//     for (var item in workingCapitalItems) { item.dispose(); }
//     for (var partner in partners) { partner.dispose(); }
//     for (var employee in employees) { employee.dispose(); }
//     for (var competitor in competitors) { competitor.dispose(); }
    
//     super.dispose();
//   }
// }

// class Partner {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController qualificationController = TextEditingController();
//   TextEditingController shareController = TextEditingController();
//   TextEditingController statusController = TextEditingController();
//   TextEditingController relationshipController = TextEditingController();
  
//   void dispose() {
//     nameController.dispose();
//     ageController.dispose();
//     qualificationController.dispose();
//     shareController.dispose();
//     statusController.dispose();
//     relationshipController.dispose();
//   }
// }

// class Employee {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController designationController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController qualificationController = TextEditingController();
//   TextEditingController experienceController = TextEditingController();
  
//   void dispose() {
//     nameController.dispose();
//     designationController.dispose();
//     ageController.dispose();
//     qualificationController.dispose();
//     experienceController.dispose();
//   }
// }

// class Competitor {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController marketShareController = TextEditingController();
  
//   void dispose() {
//     nameController.dispose();
//     addressController.dispose();
//     marketShareController.dispose();
//   }
// }

// class WorkingCapitalItem {
//   String name;
//   TextEditingController unitController = TextEditingController();
//   TextEditingController rateController = TextEditingController();
//   TextEditingController amountController = TextEditingController();
//   TextEditingController tiedUpDaysController = TextEditingController();
//   TextEditingController amountDxeController = TextEditingController();
  
//   WorkingCapitalItem(this.name);
  
//   void dispose() {
//     unitController.dispose();
//     rateController.dispose();
//     amountController.dispose();
//     tiedUpDaysController.dispose();
//     amountDxeController.dispose();
//   }
// }

// class DocumentFile {
//   String name;
//   String path;
//   DateTime uploadDate;
  
//   DocumentFile({required this.name, required this.path, required this.uploadDate});
// }



import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import '../services/inspection_service.dart';

class CreateInspectionScreen extends StatefulWidget {
  final Map<String, dynamic>? inspectionData;
  final bool isEditMode;

  const CreateInspectionScreen({
    super.key,
    this.inspectionData,
    this.isEditMode = false,
  });

  @override
  State<CreateInspectionScreen> createState() => _CreateInspectionScreenState();
}

class _CreateInspectionScreenState extends State<CreateInspectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final InspectionService _inspectionService = InspectionService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Location Tracking Variables
  bool _isLocationTracking = false;
  List<Map<String, dynamic>> _locationPoints = [];
  Timer? _locationTimer;
  DateTime? _locationStartTime;
  DateTime? _locationEndTime;

  // Section A - Company's Client's Information
  TextEditingController clientNameController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController industryNameController = TextEditingController();
  TextEditingController natureOfBusinessController = TextEditingController();
  TextEditingController legalStatusController = TextEditingController();
  TextEditingController dateOfEstablishmentController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController showroomAddressController = TextEditingController();
  TextEditingController factoryAddressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController accountIdController = TextEditingController();
  TextEditingController tinController = TextEditingController();
  TextEditingController dateOfOpeningController = TextEditingController();
  TextEditingController vatRegController = TextEditingController();
  TextEditingController firstInvestmentDateController = TextEditingController();
  TextEditingController sectorCodeController = TextEditingController();
  TextEditingController tradeLicenseController = TextEditingController();
  TextEditingController economicPurposeController = TextEditingController();
  String? selectedInvestmentCategory;

  // Section B - Owner Information
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController ownerAgeController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController spouseNameController = TextEditingController();
  TextEditingController academicQualificationController = TextEditingController();
  TextEditingController childrenInfoController = TextEditingController();
  TextEditingController businessSuccessorController = TextEditingController();
  TextEditingController residentialAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();

  // Section C - Partners/Directors
  List<Partner> partners = [Partner()];

  // Section D - Purpose
  TextEditingController purposeInvestmentController = TextEditingController();
  TextEditingController purposeBankGuaranteeController = TextEditingController();
  TextEditingController periodInvestmentController = TextEditingController();

  // Section E - Proposed Facilities
  String? selectedFacilityType;
  TextEditingController existingLimitController = TextEditingController();
  TextEditingController appliedLimitController = TextEditingController();
  TextEditingController recommendedLimitController = TextEditingController();
  TextEditingController bankPercentageController = TextEditingController();
  TextEditingController clientPercentageController = TextEditingController();

  // Section F - Present Outstanding
  String? selectedOutstandingType;
  TextEditingController limitController = TextEditingController();
  TextEditingController netOutstandingController = TextEditingController();
  TextEditingController grossOutstandingController = TextEditingController();

  // Section G - Business Analysis
  String? marketSituation;
  String? clientPosition;
  List<Competitor> competitors = List.generate(5, (index) => Competitor());
  String? businessReputation;
  String? productionType;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productionCapacityController = TextEditingController();
  TextEditingController actualProductionController = TextEditingController();
  TextEditingController profitabilityObservationController = TextEditingController();
  
  // Labor Force Data
  TextEditingController maleOfficerController = TextEditingController();
  TextEditingController femaleOfficerController = TextEditingController();
  TextEditingController skilledOfficerController = TextEditingController();
  TextEditingController unskilledOfficerController = TextEditingController();
  TextEditingController maleWorkerController = TextEditingController();
  TextEditingController femaleWorkerController = TextEditingController();
  TextEditingController skilledWorkerController = TextEditingController();
  TextEditingController unskilledWorkerController = TextEditingController();

  // Key Employees
  List<Employee> employees = [Employee()];

  // Section H - Property & Assets
  TextEditingController cashBalanceController = TextEditingController();
  TextEditingController stockTradeFinishedController = TextEditingController();
  TextEditingController stockTradeFinancialController = TextEditingController();
  TextEditingController accountsReceivableController = TextEditingController();
  TextEditingController advanceDepositController = TextEditingController();
  TextEditingController otherCurrentAssetsController = TextEditingController();
  TextEditingController landBuildingController = TextEditingController();
  TextEditingController plantMachineryController = TextEditingController();
  TextEditingController otherAssetsController = TextEditingController();
  TextEditingController ibblController = TextEditingController();
  TextEditingController otherBanksController = TextEditingController();
  TextEditingController borrowingSourcesController = TextEditingController();
  TextEditingController accountsPayableController = TextEditingController();
  TextEditingController otherCurrentLiabilitiesController = TextEditingController();
  TextEditingController longTermLiabilitiesController = TextEditingController();
  TextEditingController otherNonCurrentLiabilitiesController = TextEditingController();
  TextEditingController paidUpCapitalController = TextEditingController();
  TextEditingController retainedEarningController = TextEditingController();
  TextEditingController resourcesController = TextEditingController();

  // Section I - Working Capital Assessment
  List<WorkingCapitalItem> workingCapitalItems = [
    WorkingCapitalItem('Raw Materials (imported)'),
    WorkingCapitalItem('Raw Materials (Local)'),
    WorkingCapitalItem('Work in Process'),
    WorkingCapitalItem('Finished goods'),
  ];

  // Section J - Godown Particulars
  TextEditingController godownLocationController = TextEditingController();
  TextEditingController godownCapacityController = TextEditingController();
  TextEditingController godownSpaceController = TextEditingController();
  TextEditingController godownNatureController = TextEditingController();
  TextEditingController godownOwnerController = TextEditingController();
  TextEditingController distanceFromBranchController = TextEditingController();
  TextEditingController itemsToStoreController = TextEditingController();
  bool warehouseLicense = false;
  bool godownGuard = false;
  bool dampProof = false;
  bool easyAccess = false;
  bool letterDisclaimer = false;
  bool insurancePolicy = false;
  bool godownHired = false;

  // Section K - Checklist
  Map<String, bool?> checklistItems = {
    'Business establishment physically verified': null,
    'Honesty and integrity ascertained': null,
    'Confidential Report obtained': null,
    'CIB report obtained': null,
    'Items permissible by Islamic Shariah': null,
    'Items not restricted by Bangladesh Bank': null,
    'Items permissible by Investment Policy': null,
    'Market Price verified': null,
    'Constant market demand': null,
    'F-167 A duly filled': null,
    'F-167 B property filled': null,
    'Application particulars verified': null,
    'IRC, ERC, VAT copies enclosed': null,
    'TIN Certificate enclosed': null,
    'Rental Agreement enclosed': null,
    'Trade License enclosed': null,
    'Partnership Deed enclosed': null,
    'Memorandum & Articles enclosed': null,
    'Board resolution enclosed': null,
    'Directors particulars enclosed': null,
    'Current Account Statement enclosed': null,
    'Creditors/Debtors list enclosed': null,
    'IRC form with documents enclosed': null,
    'Audited Balance sheet enclosed': null,
  };

  // Section L - Site Photos & Video
  List<File> sitePhotos = [];
  File? siteVideo;

  // Section M - Documents Upload
  List<DocumentFile> uploadedDocuments = [];

  // Status field for edit mode
  String? selectedStatus;

  // Lists for dropdowns
  List<String> investmentCategories = [
    'Agriculture (AG)',
    'Large & Medium Scale Industry-LM',
    'Working Capital (Jute) WJ',
    'Working Capital (other than Jute) WO',
    'Jute Trading (JT)',
    'Jute & Jute goods Export (JE)',
    'Other Exports (OE)',
    'Other Commercial Investments (OC)',
    'Urban Housing (UH)',
    'Special program',
    'Others (OT)'
  ];

  List<String> facilityTypes = [
    'Bai-Murabaha',
    'Bai-Muajjal',
    'Bai-Salam',
    'Mudaraba',
    'BB LC/ BILLS',
    'FBN/FBP/IBP',
    'Others'
  ];

  List<String> outstandingTypes = [
    'Bai-Murabaha TR',
    'Bai-Muajjal TR',
    'Bai-Salam',
    'BB LC/ BILLS',
    'FBN/FBP/IBP',
    'None',
    'Others'
  ];

  List<String> marketSituations = [
    'Highly Saturated',
    'Saturated',
    'Low Demand Gap',
    'High Demand Gap'
  ];

  List<String> clientPositions = [
    'Market Leader',
    'Medium',
    'Weak',
    'Deteriorating'
  ];

  List<String> reputationOptions = [
    'Very Good',
    'Good',
    'Bad'
  ];

  List<String> productionTypes = [
    'Export Oriented',
    'Import Substitute',
    'Agro Based'
  ];

  List<String> statusOptions = [
    'Pending',
    'In Progress',
    'Completed',
    'Approved',
    'Rejected'
  ];

  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  // Auto-calculation values
  double _currentAssetsSubTotal = 0.0;
  double _fixedAssetsSubTotal = 0.0;
  double _totalAssets = 0.0;
  double _currentLiabilitiesSubTotal = 0.0;
  double _totalLiabilities = 0.0;
  double _totalEquity = 0.0;
  double _grandTotal = 0.0;
  double _netWorth = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _setupAutoCalculations();
    _checkExistingLocationData();
  }

  void _checkExistingLocationData() {
    if (widget.isEditMode && widget.inspectionData != null) {
      final data = widget.inspectionData!;
      if (data['location_points'] != null && data['location_points'] is List) {
        setState(() {
          _locationPoints = List<Map<String, dynamic>>.from(data['location_points']);
        });
      }
      if (data['location_start_time'] != null) {
        _locationStartTime = DateTime.parse(data['location_start_time']);
      }
      if (data['location_end_time'] != null) {
        _locationEndTime = DateTime.parse(data['location_end_time']);
      }
    }
  }

  // Location Tracking Methods
  Future<void> _startLocationTracking() async {
    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permissions are required for tracking', isError: true);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar('Location permissions are permanently denied. Please enable them in settings.', isError: true);
      return;
    }

    setState(() {
      _isLocationTracking = true;
      _locationStartTime = DateTime.now();
      _locationPoints.clear();
    });

    // Get first location immediately
    await _getCurrentLocation();

    // Start periodic location updates every 5 minutes
    _locationTimer = Timer.periodic(Duration(minutes: 5), (Timer t) async {
      await _getCurrentLocation();
    });

    _showSnackBar('Location tracking started successfully!', isError: false);
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      Map<String, dynamic> locationPoint = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'speed': position.speed,
        'speed_accuracy': position.speedAccuracy,
        'heading': position.heading,
        'timestamp': DateTime.now().toIso8601String(),
      };

      setState(() {
        _locationPoints.add(locationPoint);
      });

      print('📍 Location captured: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error getting location: $e');
      _showSnackBar('Error getting location: $e', isError: true);
    }
  }

  void _stopLocationTracking() {
    if (_locationTimer != null) {
      _locationTimer!.cancel();
      _locationTimer = null;
    }

    setState(() {
      _isLocationTracking = false;
      _locationEndTime = DateTime.now();
    });

    _showSnackBar('Location tracking stopped. ${_locationPoints.length} points captured.', isError: false);
  }

  void _setupAutoCalculations() {
    // Add listeners for auto-calculation fields
    cashBalanceController.addListener(_calculateAssets);
    stockTradeFinishedController.addListener(_calculateAssets);
    stockTradeFinancialController.addListener(_calculateAssets);
    accountsReceivableController.addListener(_calculateAssets);
    advanceDepositController.addListener(_calculateAssets);
    otherCurrentAssetsController.addListener(_calculateAssets);
    landBuildingController.addListener(_calculateAssets);
    plantMachineryController.addListener(_calculateAssets);
    otherAssetsController.addListener(_calculateAssets);
    
    ibblController.addListener(_calculateLiabilities);
    otherBanksController.addListener(_calculateLiabilities);
    borrowingSourcesController.addListener(_calculateLiabilities);
    accountsPayableController.addListener(_calculateLiabilities);
    otherCurrentLiabilitiesController.addListener(_calculateLiabilities);
    longTermLiabilitiesController.addListener(_calculateLiabilities);
    otherNonCurrentLiabilitiesController.addListener(_calculateLiabilities);
    
    paidUpCapitalController.addListener(_calculateEquity);
    retainedEarningController.addListener(_calculateEquity);
    resourcesController.addListener(_calculateEquity);

    // Working capital calculations
    for (var item in workingCapitalItems) {
      item.unitController.addListener(() => _calculateWorkingCapitalItem(item));
      item.rateController.addListener(() => _calculateWorkingCapitalItem(item));
      item.tiedUpDaysController.addListener(() => _calculateWorkingCapitalItem(item));
    }
  }

  void _calculateAssets() {
    double currentAssets = _parseDouble(cashBalanceController.text) +
        _parseDouble(stockTradeFinishedController.text) +
        _parseDouble(stockTradeFinancialController.text) +
        _parseDouble(accountsReceivableController.text) +
        _parseDouble(advanceDepositController.text) +
        _parseDouble(otherCurrentAssetsController.text);

    double fixedAssets = _parseDouble(landBuildingController.text) +
        _parseDouble(plantMachineryController.text) +
        _parseDouble(otherAssetsController.text);

    setState(() {
      _currentAssetsSubTotal = currentAssets;
      _fixedAssetsSubTotal = fixedAssets;
      _totalAssets = currentAssets + fixedAssets;
      _calculateNetWorth();
    });
  }

  void _calculateLiabilities() {
    double currentLiabilities = _parseDouble(ibblController.text) +
        _parseDouble(otherBanksController.text) +
        _parseDouble(borrowingSourcesController.text) +
        _parseDouble(accountsPayableController.text) +
        _parseDouble(otherCurrentLiabilitiesController.text);

    double longTerm = _parseDouble(longTermLiabilitiesController.text);
    double otherNonCurrent = _parseDouble(otherNonCurrentLiabilitiesController.text);

    setState(() {
      _currentLiabilitiesSubTotal = currentLiabilities;
      _totalLiabilities = currentLiabilities + longTerm + otherNonCurrent;
      _calculateNetWorth();
    });
  }

  void _calculateEquity() {
    double equity = _parseDouble(paidUpCapitalController.text) +
        _parseDouble(retainedEarningController.text) +
        _parseDouble(resourcesController.text);

    setState(() {
      _totalEquity = equity;
      _grandTotal = _totalLiabilities + _totalEquity;
      _calculateNetWorth();
    });
  }

  void _calculateNetWorth() {
    setState(() {
      _netWorth = _totalAssets - _totalLiabilities;
    });
  }

  void _calculateWorkingCapitalItem(WorkingCapitalItem item) {
    double unit = _parseDouble(item.unitController.text);
    double rate = _parseDouble(item.rateController.text);
    double tiedUpDays = _parseDouble(item.tiedUpDaysController.text);

    // Calculate amount (d = unit * rate)
    double amount = unit * rate;
    if (amount > 0 && item.amountController.text != amount.toString()) {
      item.amountController.text = amount.toStringAsFixed(2);
    }

    // Calculate amount_dxe (amount * tiedUpDays)
    double amountDxe = amount * tiedUpDays;
    if (amountDxe > 0 && item.amountDxeController.text != amountDxe.toString()) {
      item.amountDxeController.text = amountDxe.toStringAsFixed(2);
    }
  }

  double _parseDouble(String text) {
    if (text.isEmpty) return 0.0;
    return double.tryParse(text) ?? 0.0;
  }

  void _initializeFormData() {
    if (widget.isEditMode && widget.inspectionData != null) {
      final data = widget.inspectionData!;
      print('📝 Initializing form with existing data: ${data['id']}');
      
      // Section A - Company's Client's Information - AUTO LOAD FROM CARD DATA
      clientNameController.text = data['client_name'] ?? '';
      groupNameController.text = data['group_name'] ?? '';
      industryNameController.text = data['industry_name'] ?? '';
      natureOfBusinessController.text = data['nature_of_business'] ?? '';
      legalStatusController.text = data['legal_status'] ?? '';
      dateOfEstablishmentController.text = data['date_of_establishment'] ?? '';
      officeAddressController.text = data['office_address'] ?? '';
      showroomAddressController.text = data['showroom_address'] ?? '';
      factoryAddressController.text = data['factory_address'] ?? '';
      phoneController.text = data['phone_number'] ?? '';
      accountNoController.text = data['account_number'] ?? '';
      accountIdController.text = data['account_id'] ?? '';
      tinController.text = data['tin_number'] ?? '';
      dateOfOpeningController.text = data['date_of_opening'] ?? '';
      vatRegController.text = data['vat_reg_number'] ?? '';
      firstInvestmentDateController.text = data['first_investment_date'] ?? '';
      sectorCodeController.text = data['sector_code'] ?? '';
      tradeLicenseController.text = data['trade_license'] ?? '';
      economicPurposeController.text = data['economic_purpose_code'] ?? '';
      selectedInvestmentCategory = data['investment_category'];
      
      // Section B - Owner Information - AUTO LOAD FROM CARD DATA
      ownerNameController.text = data['owner_name'] ?? '';
      ownerAgeController.text = data['owner_age'] ?? '';
      fatherNameController.text = data['father_name'] ?? '';
      motherNameController.text = data['mother_name'] ?? '';
      spouseNameController.text = data['spouse_name'] ?? '';
      academicQualificationController.text = data['academic_qualification'] ?? '';
      childrenInfoController.text = data['children_info'] ?? '';
      businessSuccessorController.text = data['business_successor'] ?? '';
      residentialAddressController.text = data['residential_address'] ?? '';
      permanentAddressController.text = data['permanent_address'] ?? '';
      
      // Section C - Partners/Directors
      if (data['partners_directors'] != null && data['partners_directors'] is List) {
        partners.clear();
        for (var partnerData in data['partners_directors']) {
          Partner partner = Partner();
          partner.nameController.text = partnerData['name'] ?? '';
          partner.ageController.text = partnerData['age'] ?? '';
          partner.qualificationController.text = partnerData['qualification'] ?? '';
          partner.shareController.text = partnerData['share'] ?? '';
          partner.statusController.text = partnerData['status'] ?? '';
          partner.relationshipController.text = partnerData['relationship'] ?? '';
          partners.add(partner);
        }
        if (partners.isEmpty) partners.add(Partner());
      }
      
      // Section D - Purpose
      purposeInvestmentController.text = data['purpose_investment'] ?? '';
      purposeBankGuaranteeController.text = data['purpose_bank_guarantee'] ?? '';
      periodInvestmentController.text = data['period_investment'] ?? '';
      
      // Section E - Proposed Facilities
      selectedFacilityType = data['facility_type'];
      existingLimitController.text = data['existing_limit'] ?? '';
      appliedLimitController.text = data['applied_limit'] ?? '';
      recommendedLimitController.text = data['recommended_limit'] ?? '';
      bankPercentageController.text = data['bank_percentage'] ?? '';
      clientPercentageController.text = data['client_percentage'] ?? '';
      
      // Section F - Present Outstanding
      selectedOutstandingType = data['outstanding_type'];
      limitController.text = data['limit_amount'] ?? '';
      netOutstandingController.text = data['net_outstanding'] ?? '';
      grossOutstandingController.text = data['gross_outstanding'] ?? '';
      
      // Section G - Business Analysis
      marketSituation = data['market_situation'];
      clientPosition = data['client_position'];
      businessReputation = data['business_reputation'];
      productionType = data['production_type'];
      productNameController.text = data['product_name'] ?? '';
      productionCapacityController.text = data['production_capacity'] ?? '';
      actualProductionController.text = data['actual_production'] ?? '';
      profitabilityObservationController.text = data['profitability_observation'] ?? '';
      
      // Labor Force
      maleOfficerController.text = data['male_officer'] ?? '';
      femaleOfficerController.text = data['female_officer'] ?? '';
      skilledOfficerController.text = data['skilled_officer'] ?? '';
      unskilledOfficerController.text = data['unskilled_officer'] ?? '';
      maleWorkerController.text = data['male_worker'] ?? '';
      femaleWorkerController.text = data['female_worker'] ?? '';
      skilledWorkerController.text = data['skilled_worker'] ?? '';
      unskilledWorkerController.text = data['unskilled_worker'] ?? '';
      
      // Competitors
      if (data['competitors'] != null && data['competitors'] is List) {
        for (int i = 0; i < data['competitors'].length && i < competitors.length; i++) {
          var competitorData = data['competitors'][i];
          competitors[i].nameController.text = competitorData['name'] ?? '';
          competitors[i].addressController.text = competitorData['address'] ?? '';
          competitors[i].marketShareController.text = competitorData['market_share'] ?? '';
        }
      }
      
      // Key Employees
      if (data['key_employees'] != null && data['key_employees'] is List) {
        employees.clear();
        for (var employeeData in data['key_employees']) {
          Employee employee = Employee();
          employee.nameController.text = employeeData['name'] ?? '';
          employee.designationController.text = employeeData['designation'] ?? '';
          employee.ageController.text = employeeData['age'] ?? '';
          employee.qualificationController.text = employeeData['qualification'] ?? '';
          employee.experienceController.text = employeeData['experience'] ?? '';
          employees.add(employee);
        }
        if (employees.isEmpty) employees.add(Employee());
      }
      
      // Section H - Property & Assets
      cashBalanceController.text = data['cash_balance'] ?? '';
      stockTradeFinishedController.text = data['stock_trade_finished'] ?? '';
      stockTradeFinancialController.text = data['stock_trade_financial'] ?? '';
      accountsReceivableController.text = data['accounts_receivable'] ?? '';
      advanceDepositController.text = data['advance_deposit'] ?? '';
      otherCurrentAssetsController.text = data['other_current_assets'] ?? '';
      landBuildingController.text = data['land_building'] ?? '';
      plantMachineryController.text = data['plant_machinery'] ?? '';
      otherAssetsController.text = data['other_assets'] ?? '';
      ibblController.text = data['ibbl_investment'] ?? '';
      otherBanksController.text = data['other_banks_investment'] ?? '';
      borrowingSourcesController.text = data['borrowing_sources'] ?? '';
      accountsPayableController.text = data['accounts_payable'] ?? '';
      otherCurrentLiabilitiesController.text = data['other_current_liabilities'] ?? '';
      longTermLiabilitiesController.text = data['long_term_liabilities'] ?? '';
      otherNonCurrentLiabilitiesController.text = data['other_non_current_liabilities'] ?? '';
      paidUpCapitalController.text = data['paid_up_capital'] ?? '';
      retainedEarningController.text = data['retained_earning'] ?? '';
      resourcesController.text = data['resources'] ?? '';
      
      // Section I - Working Capital Assessment
      if (data['working_capital_items'] != null && data['working_capital_items'] is List) {
        for (int i = 0; i < data['working_capital_items'].length && i < workingCapitalItems.length; i++) {
          var itemData = data['working_capital_items'][i];
          workingCapitalItems[i].unitController.text = itemData['unit'] ?? '';
          workingCapitalItems[i].rateController.text = itemData['rate'] ?? '';
          workingCapitalItems[i].amountController.text = itemData['amount'] ?? '';
          workingCapitalItems[i].tiedUpDaysController.text = itemData['tied_up_days'] ?? '';
          workingCapitalItems[i].amountDxeController.text = itemData['amount_dxe'] ?? '';
        }
      }
      
      // Section J - Godown Particulars
      godownLocationController.text = data['godown_location'] ?? '';
      godownCapacityController.text = data['godown_capacity'] ?? '';
      godownSpaceController.text = data['godown_space'] ?? '';
      godownNatureController.text = data['godown_nature'] ?? '';
      godownOwnerController.text = data['godown_owner'] ?? '';
      distanceFromBranchController.text = data['distance_from_branch'] ?? '';
      itemsToStoreController.text = data['items_to_store'] ?? '';
      warehouseLicense = data['warehouse_license'] ?? false;
      godownGuard = data['godown_guard'] ?? false;
      dampProof = data['damp_proof'] ?? false;
      easyAccess = data['easy_access'] ?? false;
      letterDisclaimer = data['letter_disclaimer'] ?? false;
      insurancePolicy = data['insurance_policy'] ?? false;
      godownHired = data['godown_hired'] ?? false;
      
      // Section K - Checklist
      if (data['checklist_items'] != null && data['checklist_items'] is Map) {
        checklistItems = Map<String, bool?>.from(data['checklist_items']);
      }
      
      // Status
      selectedStatus = data['status'] ?? 'Pending';
      
      print('✅ Form initialized with existing data');
      
      // Calculate initial values
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateAssets();
        _calculateLiabilities();
        _calculateEquity();
      });
    } else if (!widget.isEditMode && widget.inspectionData != null) {
      // NEW: Auto-load data when coming from assigned inspections (not edit mode)
      final data = widget.inspectionData!;
      print('🎯 Auto-loading data from assigned inspection card');
      
      // Section A - Company's Client's Information - AUTO LOAD FROM CARD
      clientNameController.text = data['client_name'] ?? '';
      industryNameController.text = data['industry_name'] ?? '';
      phoneController.text = data['phone_number'] ?? '';
      
      // Debug information
      print('📋 Loaded from assigned inspection:');
      print('   Client Name: ${clientNameController.text}');
      print('   Industry: ${industryNameController.text}');
      print('   Phone: ${phoneController.text}');
      print('   Project: ${data['project'] ?? 'N/A'}');
    }
  }

  // Print submission summary for debugging
  void _printSubmissionSummary() {
    print('=== INSPECTION SUBMISSION SUMMARY ===');
    print('📍 Location Points: ${_locationPoints.length}');
    print('📊 Form Sections: A, B, C, D, E, F, G, H, I, J, K, L, M');
    print('📷 Photos: ${sitePhotos.length} files');
    print('🎥 Video: ${siteVideo != null ? "Yes" : "No"}');
    print('📋 Checklist Items: ${checklistItems.length}');
    print('👥 Partners: ${partners.length}');
    print('💼 Employees: ${employees.length}');
    print('🏢 Competitors: ${competitors.length}');
    print('💰 Working Capital Items: ${workingCapitalItems.length}');
    print('📄 Documents: ${uploadedDocuments.length}');
    print('====================================');
  }

  // Enhanced submit with comprehensive data handling
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Print submission summary
      _printSubmissionSummary();

      // Stop location tracking if active
      if (_isLocationTracking) {
        _stopLocationTracking();
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final String? branchName = await storage.read(key: 'branch_name');
        
        if (branchName == null || branchName.isEmpty) {
          _showSnackBar('Branch information not found. Please login again.', isError: true);
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Prepare comprehensive inspection data
        Map<String, dynamic> inspectionData = {
          'branch_name': branchName,
          
          // Location Data
          'location_points': _locationPoints,
          'location_start_time': _locationStartTime?.toIso8601String(),
          'location_end_time': _locationEndTime?.toIso8601String(),
          'total_location_points': _locationPoints.length,
          
          // Section A - Company's Client's Information
          'client_name': clientNameController.text,
          'group_name': groupNameController.text,
          'industry_name': industryNameController.text,
          'nature_of_business': natureOfBusinessController.text,
          'legal_status': legalStatusController.text,
          'date_of_establishment': dateOfEstablishmentController.text,
          'office_address': officeAddressController.text,
          'showroom_address': showroomAddressController.text,
          'factory_address': factoryAddressController.text,
          'phone_number': phoneController.text,
          'account_number': accountNoController.text,
          'account_id': accountIdController.text,
          'tin_number': tinController.text,
          'date_of_opening': dateOfOpeningController.text,
          'vat_reg_number': vatRegController.text,
          'first_investment_date': firstInvestmentDateController.text,
          'sector_code': sectorCodeController.text,
          'trade_license': tradeLicenseController.text,
          'economic_purpose_code': economicPurposeController.text,
          'investment_category': selectedInvestmentCategory ?? '',
          
          // Section B - Owner Information
          'owner_name': ownerNameController.text,
          'owner_age': ownerAgeController.text,
          'father_name': fatherNameController.text,
          'mother_name': motherNameController.text,
          'spouse_name': spouseNameController.text,
          'academic_qualification': academicQualificationController.text,
          'children_info': childrenInfoController.text,
          'business_successor': businessSuccessorController.text,
          'residential_address': residentialAddressController.text,
          'permanent_address': permanentAddressController.text,
          
          // Section C - Partners/Directors
          'partners_directors': partners.map((partner) => {
            'name': partner.nameController.text,
            'age': partner.ageController.text,
            'qualification': partner.qualificationController.text,
            'share': partner.shareController.text,
            'status': partner.statusController.text,
            'relationship': partner.relationshipController.text,
          }).toList(),
          
          // Section D - Purpose
          'purpose_investment': purposeInvestmentController.text,
          'purpose_bank_guarantee': purposeBankGuaranteeController.text,
          'period_investment': periodInvestmentController.text,
          
          // Section E - Proposed Facilities
          'facility_type': selectedFacilityType ?? '',
          'existing_limit': existingLimitController.text,
          'applied_limit': appliedLimitController.text,
          'recommended_limit': recommendedLimitController.text,
          'bank_percentage': bankPercentageController.text,
          'client_percentage': clientPercentageController.text,
          
          // Section F - Present Outstanding
          'outstanding_type': selectedOutstandingType ?? '',
          'limit_amount': limitController.text,
          'net_outstanding': netOutstandingController.text,
          'gross_outstanding': grossOutstandingController.text,
          
          // Section G - Business Analysis
          'market_situation': marketSituation ?? '',
          'client_position': clientPosition ?? '',
          'competitors': competitors.map((competitor) => {
            'name': competitor.nameController.text,
            'address': competitor.addressController.text,
            'market_share': competitor.marketShareController.text,
          }).toList(),
          'business_reputation': businessReputation ?? '',
          'production_type': productionType ?? '',
          'product_name': productNameController.text,
          'production_capacity': productionCapacityController.text,
          'actual_production': actualProductionController.text,
          'profitability_observation': profitabilityObservationController.text,
          
          // Labor Force
          'male_officer': maleOfficerController.text,
          'female_officer': femaleOfficerController.text,
          'skilled_officer': skilledOfficerController.text,
          'unskilled_officer': unskilledOfficerController.text,
          'male_worker': maleWorkerController.text,
          'female_worker': femaleWorkerController.text,
          'skilled_worker': skilledWorkerController.text,
          'unskilled_worker': unskilledWorkerController.text,
          
          // Key Employees
          'key_employees': employees.map((employee) => {
            'name': employee.nameController.text,
            'designation': employee.designationController.text,
            'age': employee.ageController.text,
            'qualification': employee.qualificationController.text,
            'experience': employee.experienceController.text,
          }).toList(),
          
          // Section H - Property & Assets
          'cash_balance': cashBalanceController.text,
          'stock_trade_finished': stockTradeFinishedController.text,
          'stock_trade_financial': stockTradeFinancialController.text,
          'accounts_receivable': accountsReceivableController.text,
          'advance_deposit': advanceDepositController.text,
          'other_current_assets': otherCurrentAssetsController.text,
          'land_building': landBuildingController.text,
          'plant_machinery': plantMachineryController.text,
          'other_assets': otherAssetsController.text,
          'ibbl_investment': ibblController.text,
          'other_banks_investment': otherBanksController.text,
          'borrowing_sources': borrowingSourcesController.text,
          'accounts_payable': accountsPayableController.text,
          'other_current_liabilities': otherCurrentLiabilitiesController.text,
          'long_term_liabilities': longTermLiabilitiesController.text,
          'other_non_current_liabilities': otherNonCurrentLiabilitiesController.text,
          'paid_up_capital': paidUpCapitalController.text,
          'retained_earning': retainedEarningController.text,
          'resources': resourcesController.text,
          
          // Auto-calculated financial values
          'current_assets_subtotal': _currentAssetsSubTotal,
          'fixed_assets_subtotal': _fixedAssetsSubTotal,
          'total_assets': _totalAssets,
          'current_liabilities_subtotal': _currentLiabilitiesSubTotal,
          'total_liabilities': _totalLiabilities,
          'total_equity': _totalEquity,
          'grand_total': _grandTotal,
          'net_worth': _netWorth,
          
          // Section I - Working Capital Assessment
          'working_capital_items': workingCapitalItems.map((item) => {
            'name': item.name,
            'unit': item.unitController.text,
            'rate': item.rateController.text,
            'amount': item.amountController.text,
            'tied_up_days': item.tiedUpDaysController.text,
            'amount_dxe': item.amountDxeController.text,
          }).toList(),
          
          // Section J - Godown Particulars
          'godown_location': godownLocationController.text,
          'godown_capacity': godownCapacityController.text,
          'godown_space': godownSpaceController.text,
          'godown_nature': godownNatureController.text,
          'godown_owner': godownOwnerController.text,
          'distance_from_branch': distanceFromBranchController.text,
          'items_to_store': itemsToStoreController.text,
          'warehouse_license': warehouseLicense,
          'godown_guard': godownGuard,
          'damp_proof': dampProof,
          'easy_access': easyAccess,
          'letter_disclaimer': letterDisclaimer,
          'insurance_policy': insurancePolicy,
          'godown_hired': godownHired,
          
          // Section K - Checklist
          'checklist_items': checklistItems,
          
          // Section L - Site Photos & Video
          'site_photos': await _preparePhotosData(),
          'site_video': await _prepareVideoData(),
          
          // Section M - Documents Upload
          'uploaded_documents': _prepareDocumentsData(),
          
          // Status field
          'status': selectedStatus ?? 'Pending',
          
          // Timestamp
          'submitted_at': DateTime.now().toIso8601String(),
        };

        bool success;
        if (widget.isEditMode) {
          // UPDATE existing inspection
          success = await _inspectionService.updateInspection(
            widget.inspectionData!['id'],
            inspectionData,
          );
        } else {
          // CREATE new inspection
          success = await _inspectionService.submitInspection(inspectionData);
        }

        setState(() {
          _isLoading = false;
        });

        if (success) {
          _showSnackBar(
            widget.isEditMode 
              ? 'Inspection updated successfully! ✅' 
              : 'Inspection submitted successfully! ✅',
            isError: false
          );
          
          // Return true to indicate success
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        } else {
          _showSnackBar(
            widget.isEditMode 
              ? 'Failed to update inspection. Please try again.' 
              : 'Failed to submit inspection. Please try again.',
            isError: true
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Error: $e', isError: true);
        print('❌ Submission error: $e');
      }
    } else {
      _showSnackBar('Please fill all required fields correctly.', isError: true);
    }
  }

  // Prepare photos data for submission
  Future<List<Map<String, dynamic>>> _preparePhotosData() async {
    List<Map<String, dynamic>> photosData = [];
    
    for (int i = 0; i < sitePhotos.length; i++) {
      File photo = sitePhotos[i];
      List<int> bytes = await photo.readAsBytes();
      String base64Image = base64Encode(bytes);
      
      photosData.add({
        'index': i,
        'file_name': 'site_photo_${i + 1}.jpg',
        'file_size': await photo.length(),
        'base64_data': base64Image,
        'uploaded_at': DateTime.now().toIso8601String(),
        'description': 'Site photo ${i + 1}'
      });
    }
    
    return photosData;
  }

  // Prepare video data for submission
  Future<Map<String, dynamic>?> _prepareVideoData() async {
    if (siteVideo == null) return null;
    
    File video = siteVideo!;
    List<int> bytes = await video.readAsBytes();
    String base64Video = base64Encode(bytes);
    
    return {
      'file_name': 'site_video.mp4',
      'file_size': await video.length(),
      'base64_data': base64Video,
      'uploaded_at': DateTime.now().toIso8601String(),
      'description': 'Site documentation video'
    };
  }

  // Prepare documents data for submission
  List<Map<String, dynamic>> _prepareDocumentsData() {
    return uploadedDocuments.map((doc) => {
      'name': doc.name,
      'file_path': doc.path,
      'upload_date': doc.uploadDate.toIso8601String(),
      'file_type': _getFileType(doc.name),
    }).toList();
  }

  String _getFileType(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
      return 'image';
    } else if (['pdf'].contains(extension)) {
      return 'pdf';
    } else if (['doc', 'docx'].contains(extension)) {
      return 'document';
    } else {
      return 'other';
    }
  }

  void _clearForm() {
    // Clear all text controllers
    clientNameController.clear();
    groupNameController.clear();
    industryNameController.clear();
    natureOfBusinessController.clear();
    legalStatusController.clear();
    dateOfEstablishmentController.clear();
    officeAddressController.clear();
    showroomAddressController.clear();
    factoryAddressController.clear();
    phoneController.clear();
    accountNoController.clear();
    accountIdController.clear();
    tinController.clear();
    dateOfOpeningController.clear();
    vatRegController.clear();
    firstInvestmentDateController.clear();
    sectorCodeController.clear();
    tradeLicenseController.clear();
    economicPurposeController.clear();
    
    ownerNameController.clear();
    ownerAgeController.clear();
    fatherNameController.clear();
    motherNameController.clear();
    spouseNameController.clear();
    academicQualificationController.clear();
    childrenInfoController.clear();
    businessSuccessorController.clear();
    residentialAddressController.clear();
    permanentAddressController.clear();
    
    purposeInvestmentController.clear();
    purposeBankGuaranteeController.clear();
    periodInvestmentController.clear();
    
    existingLimitController.clear();
    appliedLimitController.clear();
    recommendedLimitController.clear();
    bankPercentageController.clear();
    clientPercentageController.clear();
    
    limitController.clear();
    netOutstandingController.clear();
    grossOutstandingController.clear();
    
    productNameController.clear();
    productionCapacityController.clear();
    actualProductionController.clear();
    profitabilityObservationController.clear();
    
    maleOfficerController.clear();
    femaleOfficerController.clear();
    skilledOfficerController.clear();
    unskilledOfficerController.clear();
    maleWorkerController.clear();
    femaleWorkerController.clear();
    skilledWorkerController.clear();
    unskilledWorkerController.clear();
    
    cashBalanceController.clear();
    stockTradeFinishedController.clear();
    stockTradeFinancialController.clear();
    accountsReceivableController.clear();
    advanceDepositController.clear();
    otherCurrentAssetsController.clear();
    landBuildingController.clear();
    plantMachineryController.clear();
    otherAssetsController.clear();
    ibblController.clear();
    otherBanksController.clear();
    borrowingSourcesController.clear();
    accountsPayableController.clear();
    otherCurrentLiabilitiesController.clear();
    longTermLiabilitiesController.clear();
    otherNonCurrentLiabilitiesController.clear();
    paidUpCapitalController.clear();
    retainedEarningController.clear();
    resourcesController.clear();
    
    godownLocationController.clear();
    godownCapacityController.clear();
    godownSpaceController.clear();
    godownNatureController.clear();
    godownOwnerController.clear();
    distanceFromBranchController.clear();
    itemsToStoreController.clear();
    
    // Clear dropdowns and selections
    setState(() {
      selectedInvestmentCategory = null;
      selectedFacilityType = null;
      selectedOutstandingType = null;
      marketSituation = null;
      clientPosition = null;
      businessReputation = null;
      productionType = null;
      selectedStatus = 'Pending';
      
      warehouseLicense = false;
      godownGuard = false;
      dampProof = false;
      easyAccess = false;
      letterDisclaimer = false;
      insurancePolicy = false;
      godownHired = false;
      
      // Clear dynamic lists
      partners = [Partner()];
      employees = [Employee()];
      sitePhotos = [];
      siteVideo = null;
      uploadedDocuments = [];
      
      // Reset checklist
      checklistItems = checklistItems.map((key, value) => MapEntry(key, null));
      
      // Reset working capital items
      for (var item in workingCapitalItems) {
        item.unitController.clear();
        item.rateController.clear();
        item.amountController.clear();
        item.tiedUpDaysController.clear();
        item.amountDxeController.clear();
      }

      // Reset location data
      _isLocationTracking = false;
      _locationPoints.clear();
      _locationStartTime = null;
      _locationEndTime = null;
      if (_locationTimer != null) {
        _locationTimer!.cancel();
        _locationTimer = null;
      }

      // Reset calculated values
      _currentAssetsSubTotal = 0.0;
      _fixedAssetsSubTotal = 0.0;
      _totalAssets = 0.0;
      _currentLiabilitiesSubTotal = 0.0;
      _totalLiabilities = 0.0;
      _totalEquity = 0.0;
      _grandTotal = 0.0;
      _netWorth = 0.0;
    });
  }

  // Media handling methods
  Future<void> _pickSitePhotos() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920, maxHeight: 1080, imageQuality: 85);
      if (images != null && images.isNotEmpty) {
        setState(() {
          for (var image in images) {
            if (sitePhotos.length < 10) sitePhotos.add(File(image.path));
          }
        });
        _showSnackBar('${images.length} photos selected', isError: false);
      }
    } catch (e) {
      _showSnackBar('Error picking photos: $e', isError: true);
    }
  }

  Future<void> _pickSiteVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.camera, maxDuration: Duration(minutes: 2));
      if (video != null) {
        setState(() {
          siteVideo = File(video.path);
        });
        _showSnackBar('Video selected successfully', isError: false);
      }
    } catch (e) {
      _showSnackBar('Error picking video: $e', isError: true);
    }
  }

  Future<void> _pickDocuments() async {
    try {
      final XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          uploadedDocuments.add(DocumentFile(
            name: file.name, 
            path: file.path, 
            uploadDate: DateTime.now()
          ));
        });
        _showSnackBar('Document added: ${file.name}', isError: false);
      }
    } catch (e) {
      _showSnackBar('Error picking document: $e', isError: true);
    }
  }

  void _removeSitePhoto(int index) {
    setState(() {
      sitePhotos.removeAt(index);
    });
    _showSnackBar('Photo removed', isError: false);
  }

  void _removeSiteVideo() {
    setState(() {
      siteVideo = null;
    });
    _showSnackBar('Video removed', isError: false);
  }

  void _removeDocument(int index) {
    setState(() {
      uploadedDocuments.removeAt(index);
    });
    _showSnackBar('Document removed', isError: false);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      )
    );
  }

  // UI Helper methods
  Widget _buildSectionContainer(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF116045))),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildSubSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100], 
        border: Border.all(color: Colors.grey), 
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isRequired = false, int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          return null;
        } : null,
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged, {bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) return 'Please select $label';
          return null;
        } : null,
      ),
    );
  }

  Widget _buildRadioGroup(String title, List<String> options, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: selectedValue,
            onChanged: onChanged,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCheckboxOption(String label, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }

  List<Widget> _buildChecklistItems(int start, int end) {
    List<Widget> items = [];
    var entries = checklistItems.entries.toList();
    for (int i = start; i <= end && i < entries.length; i++) {
      var entry = entries[i];
      items.add(_buildChecklistRow(entry.key, entry.value, (value) {
        setState(() { checklistItems[entry.key] = value; });
      }));
    }
    return items;
  }

  Widget _buildChecklistRow(String label, bool? value, Function(bool?) onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: TextStyle(fontSize: 14))),
          Radio<bool>(value: true, groupValue: value, onChanged: onChanged),
          Text('Yes', style: TextStyle(fontSize: 12)),
          SizedBox(width: 10),
          Radio<bool>(value: false, groupValue: value, onChanged: onChanged),
          Text('No', style: TextStyle(fontSize: 12)),
          SizedBox(width: 10),
          Radio<bool?>(value: null, groupValue: value, onChanged: onChanged),
          Text('N/A', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPartnerRow(Partner partner, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text('Partner/Director ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                if (partners.length > 1) IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removePartner(index),
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildTextField('Name with Father\'s / husband\'s', partner.nameController),
            _buildTextField('Age', partner.ageController),
            _buildTextField('Academic Qualification', partner.qualificationController),
            _buildTextField('Extent of Share (%)', partner.shareController),
            _buildTextField('Status', partner.statusController),
            _buildTextField('Relationship with Chairman /MD name', partner.relationshipController),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitorRow(Competitor competitor, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text('Competitor ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField('Name', competitor.nameController),
            _buildTextField('Address', competitor.addressController),
            _buildTextField('Market Share', competitor.marketShareController),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeRow(Employee employee, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text('Employee ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                if (employees.length > 1) IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeEmployee(index),
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildTextField('Name', employee.nameController),
            _buildTextField('Designation', employee.designationController),
            _buildTextField('Age', employee.ageController),
            _buildTextField('Education Qualification', employee.qualificationController),
            _buildTextField('Experience', employee.experienceController),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCard(String label, TextEditingController controller) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount in Tk.',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                prefixText: 'Tk. ',
              ),
              onChanged: (value) {
                // Trigger calculations when values change
                if (label.contains('Cash') || label.contains('Stock') || label.contains('Accounts') || 
                    label.contains('Advance') || label.contains('Other current') || 
                    label.contains('Land') || label.contains('Plant') || label.contains('Other assets')) {
                  _calculateAssets();
                } else if (label.contains('IBBL') || label.contains('Others') || label.contains('Borrowing') || 
                           label.contains('Accounts Payable') || label.contains('Other current liabilities') ||
                           label.contains('Long Term') || label.contains('Other non-current')) {
                  _calculateLiabilities();
                } else if (label.contains('Paid up capital') || label.contains('Retained') || label.contains('Resources')) {
                  _calculateEquity();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue[100],
      labelStyle: TextStyle(fontSize: 12),
    );
  }

  Widget _buildDocumentItem(DocumentFile doc, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(Icons.description, color: Colors.blue),
        title: Text(doc.name),
        subtitle: Text('Uploaded: ${_formatDate(doc.uploadDate)}'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeDocument(index),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  // Methods for dynamic lists
  void _addPartner() { 
    setState(() { partners.add(Partner()); }); 
  }
  
  void _removePartner(int index) { 
    setState(() { partners.removeAt(index); }); 
  }
  
  void _addEmployee() { 
    setState(() { employees.add(Employee()); }); 
  }
  
  void _removeEmployee(int index) { 
    setState(() { employees.removeAt(index); }); 
  }

  // Location Tracking UI
  Widget _buildLocationTrackingSection() {
    return _buildSectionContainer('Location Tracking', Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Automatically capture location every 5 minutes while filling the form',
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        SizedBox(height: 16),
        
        // Location Status
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isLocationTracking ? Colors.green[50] : Colors.grey[100],
            border: Border.all(color: _isLocationTracking ? Colors.green : Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                _isLocationTracking ? Icons.location_on : Icons.location_off,
                color: _isLocationTracking ? Colors.green : Colors.grey,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isLocationTracking ? 'Location Tracking Active' : 'Location Tracking Inactive',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isLocationTracking ? Colors.green : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _isLocationTracking 
                          ? '${_locationPoints.length} points captured • Started: ${_formatTime(_locationStartTime!)}'
                          : 'Click "Start Location" to begin tracking',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 16),
        
        // Location Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isLocationTracking ? null : _startLocationTracking,
                icon: Icon(Icons.play_arrow),
                label: Text('Start Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isLocationTracking ? _stopLocationTracking : null,
                icon: Icon(Icons.stop),
                label: Text('Stop Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16),
        
        // Location Points Summary
        if (_locationPoints.isNotEmpty) ...[
          _buildSubSectionHeader('Location Points Captured'),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Points:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${_locationPoints.length}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
                SizedBox(height: 8),
                if (_locationStartTime != null) 
                  Text('Started: ${_formatDateTime(_locationStartTime!)}'),
                if (_locationEndTime != null) 
                  Text('Ended: ${_formatDateTime(_locationEndTime!)}'),
                SizedBox(height: 8),
                Text(
                  'Latest: ${_locationPoints.last['latitude']?.toStringAsFixed(4)}, ${_locationPoints.last['longitude']?.toStringAsFixed(4)}',
                  style: TextStyle(fontSize: 12, fontFamily: 'Monospace'),
                ),
              ],
            ),
          ),
        ],
      ],
    ));
  }

  String _formatTime(DateTime date) => '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  String _formatDateTime(DateTime date) => '${_formatDate(date)} ${_formatTime(date)}';

  // Section Builders
  Widget _buildSectionA() {
    return _buildSectionContainer('A. Company\'s Client\'s Information', Column(children: [
      _buildTextField('Name of the Client', clientNameController, isRequired: true),
      _buildTextField('Group Name (if any)', groupNameController),
      _buildTextField('Industry Name (as per CIB)', industryNameController, isRequired: true),
      _buildTextField('Nature of Business', natureOfBusinessController, isRequired: true),
      _buildTextField('Legal Status', legalStatusController, isRequired: true),
      _buildTextField('Date of Establishment', dateOfEstablishmentController, isRequired: true),
      _buildSubSectionHeader('Address'),
      _buildTextField('Office', officeAddressController, isRequired: true),
      _buildTextField('Show Room', showroomAddressController),
      _buildTextField('Factory / Godown/ Depot', factoryAddressController),
      _buildTextField('Phone / Mobile no (office)', phoneController, isRequired: true),
      _buildTextField('Current A/C no', accountNoController, isRequired: true),
      _buildTextField('A/C ID no', accountIdController, isRequired: true),
      _buildTextField('TIN', tinController, isRequired: true),
      _buildTextField('Date of Opening', dateOfOpeningController),
      _buildTextField('VAT Reg: no', vatRegController),
      _buildTextField('Date of 1st Investment availed', firstInvestmentDateController),
      _buildTextField('Sector Code', sectorCodeController),
      _buildTextField('Trade License No & Date', tradeLicenseController, isRequired: true),
      _buildTextField('Economic Purpose Code', economicPurposeController),
      _buildSubSectionHeader('Investment Category'),
      _buildDropdown('Select Investment Category', selectedInvestmentCategory, investmentCategories, (value) {
        setState(() { selectedInvestmentCategory = value; });
      }, isRequired: true),
    ]));
  }

  Widget _buildSectionB() {
    return _buildSectionContainer('B. Owner Information', Column(children: [
      _buildTextField('Name of the Owner (S) & status', ownerNameController, isRequired: true),
      _buildTextField('Age', ownerAgeController),
      _buildTextField('Father\'s Name', fatherNameController),
      _buildTextField('Mother\'s Name', motherNameController),
      _buildTextField('Spouse\'s Name', spouseNameController),
      _buildTextField('Academic Qualification', academicQualificationController),
      _buildTextField('No. of Children with age', childrenInfoController),
      _buildTextField('Business Successor: \n(Name relations Age & qualification)', businessSuccessorController),
      _buildTextField('Residential Address:', residentialAddressController, isRequired: true),
      _buildTextField('Permanent Address:', permanentAddressController, isRequired: true),
    ]));
  }

  Widget _buildSectionC() {
    return _buildSectionContainer('C. List of Partners / Directors', Column(children: [
      ...partners.asMap().entries.map((entry) => _buildPartnerRow(entry.value, entry.key)),
      SizedBox(height: 10),
      ElevatedButton.icon(
        onPressed: _addPartner,
        icon: Icon(Icons.add),
        label: Text('Add Another Partner/Director'),
        style: ElevatedButton.styleFrom( backgroundColor: Color(0xFF116045),foregroundColor: Colors.white,),
      ),
    ]));
  }

  Widget _buildSectionD() {
    return _buildSectionContainer('D. Purpose of Investment / Facilities', Column(children: [
      _buildTextField('Purpose of Investment', purposeInvestmentController, isRequired: true),
      _buildTextField('Purpose of Bank Guarantee', purposeBankGuaranteeController),
      _buildTextField('Period of Investment', periodInvestmentController, isRequired: true),
    ]));
  }

  Widget _buildSectionE() {
    return _buildSectionContainer('E. Details of proposed Facilities/Investment', Column(children: [
      _buildDropdown('Select Facility Type', selectedFacilityType, facilityTypes, (value) {
        setState(() { selectedFacilityType = value; });
      }, isRequired: true),
      SizedBox(height: 16),
      Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [
            TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Existing Limit (tk)'))),
            TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
              controller: existingLimitController,
              decoration: InputDecoration(hintText: 'Enter amount'),
            ))),
          ]),
          TableRow(children: [
            TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Limit Applied by the client (tk)'))),
            TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
              controller: appliedLimitController,
              decoration: InputDecoration(hintText: 'Enter amount'),
            ))),
          ]),
          TableRow(children: [
            TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Limit Recommended By the Branch (tk)'))),
            TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
              controller: recommendedLimitController,
              decoration: InputDecoration(hintText: 'Enter amount'),
            ))),
          ]),
        ],
      ),
      SizedBox(height: 16),
      _buildSubSectionHeader('Rate of return profit sharing ratio'),
      Row(children: [
        Expanded(child: TextFormField(
          controller: bankPercentageController,
          decoration: InputDecoration(labelText: 'Bank (%)', border: OutlineInputBorder())
        )),
        SizedBox(width: 16),
        Expanded(child: TextFormField(
          controller: clientPercentageController,
          decoration: InputDecoration(labelText: 'Client (%)', border: OutlineInputBorder())
        )),
      ]),
    ]));
  }

  Widget _buildSectionF() {
    return _buildSectionContainer('F. Break up of Present Outstanding', Column(children: [
      _buildDropdown('Select Outstanding Type', selectedOutstandingType, outstandingTypes, (value) {
        setState(() { selectedOutstandingType = value; });
      },isRequired: true),
      SizedBox(height: 16),
      Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [
            TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Limit'))),
            TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
              controller: limitController,
              decoration: InputDecoration(hintText: 'Enter limit'),
            ))),
          ]),
          TableRow(children: [
            TableCell(child: Column(children: [
              Padding(padding: EdgeInsets.all(8), child: Text('Outstanding:')),
              Table(border: TableBorder.all(), children: [
                TableRow(children: [
                  TableCell(child: Padding(padding: EdgeInsets.all(4), child: Text('Net'))),
                  TableCell(child: Padding(padding: EdgeInsets.all(4), child: TextFormField(
                    controller: netOutstandingController,
                    decoration: InputDecoration(hintText: 'Net amount'),
                  ))),
                ]),
                TableRow(children: [
                  TableCell(child: Padding(padding: EdgeInsets.all(4), child: Text('Gross'))),
                  TableCell(child: Padding(padding: EdgeInsets.all(4), child: TextFormField(
                    controller: grossOutstandingController,
                    decoration: InputDecoration(hintText: 'Gross amount'),
                  ))),
                ]),
              ]),
            ])),
            TableCell(child: Container()),
          ]),
        ],
      ),
    ]));
  }

  Widget _buildSectionG() {
    return _buildSectionContainer('G. Business Industry / Analysis', Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubSectionHeader('Market Situation'),
        _buildRadioGroup('', marketSituations, marketSituation, (value) { 
          setState(() { marketSituation = value; }); 
        }),
        SizedBox(height: 16),
        _buildSubSectionHeader('Client\'s Position in the Industry'),
        _buildRadioGroup('', clientPositions, clientPosition, (value) { 
          setState(() { clientPosition = value; }); 
        }),
        SizedBox(height: 16),
        _buildSubSectionHeader('Name of 5 main competitors'),
        ...competitors.asMap().entries.map((entry) => _buildCompetitorRow(entry.value, entry.key)),
        SizedBox(height: 16),
        _buildSubSectionHeader('Business reputation'),
        _buildRadioGroup('', reputationOptions, businessReputation, (value) { 
          setState(() { businessReputation = value; }); 
        }),
        SizedBox(height: 16),
        _buildSubSectionHeader('Production'),
        _buildRadioGroup('', productionTypes, productionType, (value) { 
          setState(() { productionType = value; }); 
        }),
        SizedBox(height: 16),
        _buildTextField('Name of the Product', productNameController),
        _buildTextField('Production Capacity: Units / Year', productionCapacityController),
        _buildTextField('Actual Production: Units / Year', actualProductionController),
        SizedBox(height: 16),
        _buildTextField('Observation on profitability / marketability of the goods', profitabilityObservationController, maxLines: 3),
        SizedBox(height: 16),
        _buildSubSectionHeader('Size of the labor force'),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text(''))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Male'))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Female'))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Skilled'))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Unskilled'))),
            ]),
            TableRow(children: [
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Officer / Staff'))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
                controller: maleOfficerController,
                decoration: InputDecoration(hintText: 'Count'),
              ))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
                controller: femaleOfficerController,
                decoration: InputDecoration(hintText: 'Count'),
              ))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
                controller: skilledOfficerController,
                decoration: InputDecoration(hintText: 'Count'),
              ))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
                controller: unskilledOfficerController,
                decoration: InputDecoration(hintText: 'Count'),
              ))),
            ]),
            TableRow(children: [
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Labor / Worker'))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
                controller: maleWorkerController,
                decoration: InputDecoration(hintText: 'Count'),
              ))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
                controller: femaleWorkerController,
                decoration: InputDecoration(hintText: 'Count'),
              ))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
                controller: skilledWorkerController,
                decoration: InputDecoration(hintText: 'Count'),
              ))),
              TableCell(child: Padding(padding: EdgeInsets.all(8), child: TextFormField(
                controller: unskilledWorkerController,
                decoration: InputDecoration(hintText: 'Count'),
              ))),
            ]),
          ],
        ),
        SizedBox(height: 16),
        _buildSubSectionHeader('Name of the key employee of the Firm'),
        ...employees.asMap().entries.map((entry) => _buildEmployeeRow(entry.value, entry.key)),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _addEmployee,
          icon: Icon(Icons.add),
          label: Text('Add Another Employee'),
          style: ElevatedButton.styleFrom( backgroundColor: Color(0xFF116045),foregroundColor: Colors.white,),
        ),
      ],
    ));
  }

  Widget _buildSectionH() {
    return _buildSectionContainer('H. Property & Assets', Column(children: [
      Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Property & Assets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[800])),
              SizedBox(height: 16),
              _buildSubSectionHeader('Current Assets'),
              _buildAssetCard('1. Cash & Bank Balance', cashBalanceController),
              _buildAssetCard('Stock in trade & investment/finished goods', stockTradeFinishedController),
              _buildAssetCard('2. Stock in trade & investment/financial goods', stockTradeFinancialController),
              _buildAssetCard('3. Accounts receivable (Sundry Debtors)', accountsReceivableController),
              _buildAssetCard('4. Advance Deposit & Pre-payment', advanceDepositController),
              _buildAssetCard('5. Other current assets', otherCurrentAssetsController),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Sub-Total (a):', style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10)),
                    Text(' Tk. ${_currentAssetsSubTotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _buildSubSectionHeader('Fixed Assets'),
              _buildAssetCard('6. Land, Building & other immovable assets', landBuildingController),
              _buildAssetCard('7. Plant, Machinery & furniture & fixture', plantMachineryController),
              _buildAssetCard('8. Other assets', otherAssetsController),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Sub-Total (b): ', style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10)),
                    Text('Tk. ${_fixedAssetsSubTotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(color: Colors.blue[50], border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('A. Grand Total (a+b): ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                    Text('Tk. ${_totalAssets.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 16),
      Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Liabilities and Owner\'s Equity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red[800])),
              SizedBox(height: 16),
              _buildSubSectionHeader('Current Liabilities'),
              Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey[100],
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('1. Investment from Bank/Financial Institutions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 16), child: _buildAssetCard('a) IBBL', ibblController)),
              Padding(padding: EdgeInsets.only(left: 16), child: _buildAssetCard('b) Others', otherBanksController)),
              _buildAssetCard('2. Borrowing from other sources', borrowingSourcesController),
              _buildAssetCard('3. Accounts Payable (Sundry Creditors)', accountsPayableController),
              _buildAssetCard('4. Others', otherCurrentLiabilitiesController),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Sub-Total (a): ', style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10)),
                    Text('Tk. ${_currentLiabilitiesSubTotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _buildSubSectionHeader('Long Term Liability'),
              _buildAssetCard('Long Term Liability', longTermLiabilitiesController),
              SizedBox(height: 16),
              _buildSubSectionHeader('Other non-current liabilities'),
              _buildAssetCard('Other non-current liabilities', otherNonCurrentLiabilitiesController),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('B. Total Liabilities (a+b+c): ', style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10)),
                    Text('Tk. ${_totalLiabilities.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _buildSubSectionHeader('Owner\'s Equity'),
              _buildAssetCard('d. Paid up capital / owner\'s Capital Balance as per last account', paidUpCapitalController),
              _buildAssetCard('e. Resources', resourcesController),
              _buildAssetCard('I. Retained Earning / Net Profit for the year transferred to Balance Sheet', retainedEarningController),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('C. Total Equity (d+e+f): ', style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10)),
                    Text('Tk. ${_totalEquity.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(color: Colors.green[50], border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Grand Total (a+b+c+d+e+f): ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                    Text('Tk. ${_grandTotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 16),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: Colors.orange[50], border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('NET WORTH\n(Total Assets - Total Liabilities): ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.orange[800])),
            Text('Tk. ${_netWorth.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange[800])),
          ],
        ),
      ),
    ]));
  }

  Widget _buildSectionI() {
    return _buildSectionContainer('I. Working Capital Assessment: N/A', Column(children: [
      SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: DataTable(
              columnSpacing: 20,
              dataRowHeight: 60,
              headingRowHeight: 80,
              border: TableBorder.all(color: Colors.black, width: 1),
              columns: [
                DataColumn(label: SizedBox(width: 150, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold)))),
                DataColumn(label: SizedBox(width: 250, child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Daily Requirements', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Row(children: [
                      Expanded(child: Text('Unit (b)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Rate (c)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Amount (d)\nd\\e', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                    ]),
                  ],
                ))),
                DataColumn(label: SizedBox(width: 120, child: Text('Tied up period\nin Days\n(e)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
                DataColumn(label: SizedBox(width: 120, child: Text('Amount\nd\\e', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)))),
              ],
              rows: workingCapitalItems.map((item) {
                return DataRow(cells: [
                  DataCell(SizedBox(width: 150, child: Text(item.name, style: TextStyle(fontSize: 12)))),
                  DataCell(Row(children: [
                    Expanded(child: TextFormField(
                      controller: item.unitController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Unit',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      ),
                      onChanged: (value) => _calculateWorkingCapitalItem(item),
                    )),
                    SizedBox(width: 4),
                    Expanded(child: TextFormField(
                      controller: item.rateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Rate',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      ),
                      onChanged: (value) => _calculateWorkingCapitalItem(item),
                    )),
                    SizedBox(width: 4),
                    Expanded(child: TextFormField(
                      controller: item.amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      ),
                      readOnly: true, // This field is auto-calculated
                    )),
                  ])),
                  DataCell(
                    TextFormField(
                      controller: item.tiedUpDaysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Days',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      ),
                      onChanged: (value) => _calculateWorkingCapitalItem(item),
                    ),
                  ),
                  DataCell(
                    TextFormField(
                      controller: item.amountDxeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      ),
                      readOnly: true, // This field is auto-calculated
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
      SizedBox(height: 16),
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Note: Amount (d) = Unit (b) × Rate (c)\nAmount d\\e = Amount (d) × Tied up period (e)',
          style: TextStyle(fontSize: 12, color: Colors.grey[700], fontStyle: FontStyle.italic),
        ),
      ),
    ]));
  }

  Widget _buildSectionJ() {
    return _buildSectionContainer('J. Particulars of the godown for storing MPI/Murabaha goods', Column(children: [
      _buildTextField('Location of the godown', godownLocationController),
      _buildTextField('Capacity of godown', godownCapacityController),
      _buildTextField('Space of godown (Length X Width X Height)', godownSpaceController),
      _buildTextField('Nature of Godown (Pucca/Semi Pucca and class of godown)', godownNatureController),
      _buildTextField('Owner of godown (Bank/Client/Third Party)', godownOwnerController),
      _buildTextField('Distance from the branch (K.M./Mile)', distanceFromBranchController),
      _buildTextField('item to be stored', itemsToStoreController),
      SizedBox(height: 16),
      _buildSubSectionHeader('Godown Facilities'),
      _buildCheckboxOption('Whether Ware-House License has been obtained from the Competent authority', warehouseLicense, (value) { 
        setState(() { warehouseLicense = value ?? false; }); 
      }),
      _buildCheckboxOption('Whether godown is watched over by the godown guard round the clock', godownGuard, (value) { 
        setState(() { godownGuard = value ?? false; }); 
      }),
      _buildCheckboxOption('Whether godown is damp proof and safe from rain/flood water and other common hazards', dampProof, (value) { 
        setState(() { dampProof = value ?? false; }); 
      }),
      _buildCheckboxOption('Whether the officials of the Branch have easy access to the godown', easyAccess, (value) { 
        setState(() { easyAccess = value ?? false; }); 
      }),
      _buildCheckboxOption('Whether letter of disclaimer is obtained', letterDisclaimer, (value) { 
        setState(() { letterDisclaimer = value ?? false; }); 
      }),
      _buildCheckboxOption('Whether Insurance Policy obtained / updated', insurancePolicy, (value) { 
        setState(() { insurancePolicy = value ?? false; }); 
      }),
      _buildCheckboxOption('Whether the Godown hired by the Bank', godownHired, (value) { 
        setState(() { godownHired = value ?? false; }); 
      }),
    ]));
  }

  Widget _buildSectionK() {
    return _buildSectionContainer('K. Checklist', Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubSectionHeader('General'),
        ..._buildChecklistItems(0, 14),
        _buildSubSectionHeader('Constitution of the Firm'),
        ..._buildChecklistItems(15, 20),
        _buildSubSectionHeader('Financial Statements'),
        ..._buildChecklistItems(21, 24),
      ],
    ));
  }

  Widget _buildSectionL() {
    return _buildSectionContainer('L. Site Photos & Video Documentation', Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upload site photos and video documentation for verification', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        SizedBox(height: 16),
        _buildSubSectionHeader('Site Photos (up to 10 images)'),
        Text('Upload clear photos of the business site, premises, and operations', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: sitePhotos.length + 1,
          itemBuilder: (context, index) {
            if (index == sitePhotos.length) {
              return GestureDetector(
                onTap: _pickSitePhotos,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, size: 40, color: Colors.blue),
                      SizedBox(height: 4),
                      Text('Add Photo', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              );
            } else {
              return Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(sitePhotos[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeSitePhoto(index),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ]);
            }
          },
        ),
        SizedBox(height: 20),
        _buildSubSectionHeader('Site Video (Short documentation)'),
        Text('Upload a short video (max 2 minutes) showing the business operations and premises', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: siteVideo != null ? Colors.green : Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: siteVideo != null ? Stack(children: [
            Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam, size: 40, color: Colors.green),
                SizedBox(height: 8),
                Text('Video Selected', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                Text('Tap to change', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            )),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: _removeSiteVideo,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ]) : GestureDetector(
            onTap: _pickSiteVideo,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_camera_back, size: 40, color: Colors.blue),
                SizedBox(height: 8),
                Text('Upload Video', style: TextStyle(color: Colors.blue)),
                Text('(Max 2 minutes)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        if (sitePhotos.isNotEmpty || siteVideo != null) Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('${sitePhotos.length} photos ${siteVideo != null ? '+ 1 video' : ''} uploaded', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    ));
  }

  Widget _buildSectionM() {
    return _buildSectionContainer('M. Supporting Documents Upload', Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upload all relevant supporting documents (unlimited files)', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        SizedBox(height: 16),
        _buildSubSectionHeader('Recommended Documents'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildDocumentChip('Trade License'),
            _buildDocumentChip('TIN Certificate'),
            _buildDocumentChip('VAT Certificate'),
            _buildDocumentChip('Bank Statements'),
            _buildDocumentChip('Audit Reports'),
            _buildDocumentChip('Property Documents'),
            _buildDocumentChip('Partnership Deed'),
            _buildDocumentChip('Memorandum'),
            _buildDocumentChip('Others'),
          ],
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: _pickDocuments,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue[50],
            ),
            child: Column(children: [
              Icon(Icons.cloud_upload, size: 50, color: Colors.blue),
              SizedBox(height: 16),
              Text('Click to Upload Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
              SizedBox(height: 8),
              Text('Supported formats: PDF, DOC, DOCX, JPG, PNG\nMaximum file size: 10MB per file', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ]),
          ),
        ),
        SizedBox(height: 16),
        if (uploadedDocuments.isNotEmpty) ...[
          _buildSubSectionHeader('Uploaded Documents (${uploadedDocuments.length})'),
          ...uploadedDocuments.asMap().entries.map((entry) => _buildDocumentItem(entry.value, entry.key)),
        ],
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Inspection' : 'Create New Inspection'),
        backgroundColor: Color(0xFF116045),
        foregroundColor: Colors.white,
        actions: [
          if (widget.isEditMode) 
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _clearForm,
              tooltip: 'Reset Form',
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Tracking Section at the top
                    _buildLocationTrackingSection(),
                    SizedBox(height: 20),

                    _buildSectionA(),
                    SizedBox(height: 20),
                    _buildSectionB(),
                    SizedBox(height: 20),
                    _buildSectionC(),
                    SizedBox(height: 20),
                    _buildSectionD(),
                    SizedBox(height: 20),
                    _buildSectionE(),
                    SizedBox(height: 20),
                    _buildSectionF(),
                    SizedBox(height: 20),
                    _buildSectionG(),
                    SizedBox(height: 20),
                    _buildSectionH(),
                    SizedBox(height: 20),
                    _buildSectionI(),
                    SizedBox(height: 20),
                    _buildSectionJ(),
                    SizedBox(height: 20),
                    _buildSectionK(),
                    SizedBox(height: 20),
                    _buildSectionL(),
                    SizedBox(height: 20),
                    _buildSectionM(),
                    SizedBox(height: 20),
                    
                    // Submit Button
                    Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              backgroundColor: widget.isEditMode ? Colors.orange.shade800 : Colors.green.shade900,
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading 
                                ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : Text(widget.isEditMode ? 'Update Inspection' : 'Submit Complete Form'),
                          ),
                          SizedBox(height: 10),
                          if (!widget.isEditMode)
                            TextButton(
                              onPressed: _clearForm,
                              child: Text('Clear Form', style: TextStyle(color: Colors.red)),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    // Stop location tracking if active
    if (_locationTimer != null) {
      _locationTimer!.cancel();
    }

    // Dispose all controllers
    clientNameController.dispose();
    groupNameController.dispose();
    industryNameController.dispose();
    natureOfBusinessController.dispose();
    legalStatusController.dispose();
    dateOfEstablishmentController.dispose();
    officeAddressController.dispose();
    showroomAddressController.dispose();
    factoryAddressController.dispose();
    phoneController.dispose();
    accountNoController.dispose();
    accountIdController.dispose();
    tinController.dispose();
    dateOfOpeningController.dispose();
    vatRegController.dispose();
    firstInvestmentDateController.dispose();
    sectorCodeController.dispose();
    tradeLicenseController.dispose();
    economicPurposeController.dispose();
    ownerNameController.dispose();
    ownerAgeController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    spouseNameController.dispose();
    academicQualificationController.dispose();
    childrenInfoController.dispose();
    businessSuccessorController.dispose();
    residentialAddressController.dispose();
    permanentAddressController.dispose();
    purposeInvestmentController.dispose();
    purposeBankGuaranteeController.dispose();
    periodInvestmentController.dispose();
    existingLimitController.dispose();
    appliedLimitController.dispose();
    recommendedLimitController.dispose();
    bankPercentageController.dispose();
    clientPercentageController.dispose();
    limitController.dispose();
    netOutstandingController.dispose();
    grossOutstandingController.dispose();
    productNameController.dispose();
    productionCapacityController.dispose();
    actualProductionController.dispose();
    profitabilityObservationController.dispose();
    maleOfficerController.dispose();
    femaleOfficerController.dispose();
    skilledOfficerController.dispose();
    unskilledOfficerController.dispose();
    maleWorkerController.dispose();
    femaleWorkerController.dispose();
    skilledWorkerController.dispose();
    unskilledWorkerController.dispose();
    cashBalanceController.dispose();
    stockTradeFinishedController.dispose();
    stockTradeFinancialController.dispose();
    accountsReceivableController.dispose();
    advanceDepositController.dispose();
    otherCurrentAssetsController.dispose();
    landBuildingController.dispose();
    plantMachineryController.dispose();
    otherAssetsController.dispose();
    ibblController.dispose();
    otherBanksController.dispose();
    borrowingSourcesController.dispose();
    accountsPayableController.dispose();
    otherCurrentLiabilitiesController.dispose();
    longTermLiabilitiesController.dispose();
    otherNonCurrentLiabilitiesController.dispose();
    paidUpCapitalController.dispose();
    retainedEarningController.dispose();
    resourcesController.dispose();
    godownLocationController.dispose();
    godownCapacityController.dispose();
    godownSpaceController.dispose();
    godownNatureController.dispose();
    godownOwnerController.dispose();
    distanceFromBranchController.dispose();
    itemsToStoreController.dispose();
    
    for (var item in workingCapitalItems) { item.dispose(); }
    for (var partner in partners) { partner.dispose(); }
    for (var employee in employees) { employee.dispose(); }
    for (var competitor in competitors) { competitor.dispose(); }
    
    super.dispose();
  }
}

class Partner {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController shareController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController relationshipController = TextEditingController();
  
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    qualificationController.dispose();
    shareController.dispose();
    statusController.dispose();
    relationshipController.dispose();
  }
}

class Employee {
  TextEditingController nameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    ageController.dispose();
    qualificationController.dispose();
    experienceController.dispose();
  }
}

class Competitor {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController marketShareController = TextEditingController();
  
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    marketShareController.dispose();
  }
}

class WorkingCapitalItem {
  String name;
  TextEditingController unitController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController tiedUpDaysController = TextEditingController();
  TextEditingController amountDxeController = TextEditingController();
  
  WorkingCapitalItem(this.name);
  
  void dispose() {
    unitController.dispose();
    rateController.dispose();
    amountController.dispose();
    tiedUpDaysController.dispose();
    amountDxeController.dispose();
  }
}

class DocumentFile {
  String name;
  String path;
  DateTime uploadDate;
  
  DocumentFile({required this.name, required this.path, required this.uploadDate});
}