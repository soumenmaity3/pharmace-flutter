import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/model/Input/medicine_input_model.dart';
import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';
import 'package:pharmace/Frontend/Inventory/model/medicine_model.dart';
import 'package:pharmace/Frontend/Widget/AddMedicine/add_photo_widget.dart';
import 'package:pharmace/Frontend/Widget/AddMedicine/dosage_form_drop_down_widget.dart';
import 'package:pharmace/Frontend/Widget/text_feild_widget.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';
import 'package:pharmace/Provider/inventory_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';

/// Helper function to open MedicineEditWidget as a modal bottom sheet
Future<MedicineOutputModel?> showMedicineEditBottomSheet({
  required BuildContext context,
  required MedicineOutputModel medicineItem,
  Function(MedicineOutputModel updatedMedicine)? onUpdated,
}) {
  return showModalBottomSheet<MedicineOutputModel>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) =>
        MedicineEditWidget(medicineItem: medicineItem, onUpdated: onUpdated),
  );
}

class MedicineEditWidget extends ConsumerStatefulWidget {
  const MedicineEditWidget({
    super.key,
    required this.medicineItem,
    this.onUpdated,
  });

  final MedicineOutputModel medicineItem;
  final Function(MedicineOutputModel updatedMedicine)? onUpdated;

  static Future<MedicineOutputModel?> show(
    BuildContext context, {
    required MedicineOutputModel medicineItem,
    Function(MedicineOutputModel updatedMedicine)? onUpdated,
  }) {
    return showMedicineEditBottomSheet(
      context: context,
      medicineItem: medicineItem,
      onUpdated: onUpdated,
    );
  }

  @override
  ConsumerState<MedicineEditWidget> createState() => _MedicineEditWidgetState();
}

class _MedicineEditWidgetState extends ConsumerState<MedicineEditWidget>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TabController _tabController;

  // Controllers - Basic Info
  late final TextEditingController _medicineNameController;
  late final TextEditingController _genericNameController;
  late final TextEditingController _brandNameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _strengthController;
  late final TextEditingController _supplierController;

  // Controllers - Stock & Batch
  late final TextEditingController _stockQuantityController;
  late final TextEditingController _minStockController;
  late final TextEditingController _maxStockController;
  late final TextEditingController _batchNumberController;

  // Controllers - Pricing
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _mrpController;

  // Controllers - Loose Sales
  late final TextEditingController _looseQtyController;
  late final TextEditingController _totalLooseInStripController;

  late DosageForm _selectedDosageForm;
  late Schedules _selectedSchedule;
  DateTime? _manufactureDate;
  DateTime? _expiryDate;
  late bool _isLooseAvailable;
  String? _medicinePhotoPath;
  bool _isSubmitting = false;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    final med = widget.medicineItem;
    _medicineNameController = TextEditingController(text: med.medName);
    _genericNameController = TextEditingController(text: med.genericName);
    _brandNameController = TextEditingController(text: med.brand);
    _categoryController = TextEditingController(text: med.category);
    _strengthController = TextEditingController(text: med.strength);
    _supplierController = TextEditingController(text: med.supplier ?? '');

    _stockQuantityController = TextEditingController(text: '${med.quantity}');
    _minStockController = TextEditingController(text: '${med.minStockLevel}');
    _maxStockController = TextEditingController(text: '${med.maxStockLevel}');
    _batchNumberController = TextEditingController(text: med.batchNo);

    _purchasePriceController = TextEditingController(
      text: '${med.purchasePrice}',
    );
    _sellingPriceController = TextEditingController(
      text: '${med.sellingPrice}',
    );
    _mrpController = TextEditingController(text: '${med.mrp}');

    _looseQtyController = TextEditingController(text: '${med.looseQuantity}');
    _totalLooseInStripController = TextEditingController(
      text: '${med.totalLooseInStrip}',
    );

    _selectedDosageForm = med.dosageForm;
    _selectedSchedule = med.schedule;
    _isLooseAvailable = med.avLoose;
    _medicinePhotoPath = med.imageUrl;

    _parseDates(med);
  }

  void _parseDates(MedicineOutputModel med) {
    if (med.manufactureDate.isNotEmpty) {
      _manufactureDate = DateTime.tryParse(med.manufactureDate);
      if (_manufactureDate == null) {
        try {
          final parts = med.manufactureDate.split('/');
          if (parts.length == 3) {
            _manufactureDate = DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          }
        } catch (_) {}
      }
    }

    if (med.expiryDate.isNotEmpty) {
      _expiryDate = DateTime.tryParse(med.expiryDate);
      if (_expiryDate == null) {
        try {
          final parts = med.expiryDate.split('/');
          if (parts.length == 3) {
            _expiryDate = DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          }
        } catch (_) {}
      }
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _medicineNameController.dispose();
    _genericNameController.dispose();
    _brandNameController.dispose();
    _categoryController.dispose();
    _strengthController.dispose();
    _supplierController.dispose();
    _stockQuantityController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    _batchNumberController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _mrpController.dispose();
    _looseQtyController.dispose();
    _totalLooseInStripController.dispose();
    super.dispose();
  }

  Future<void> pickManuFactureDate() async {
    final now = DateTime.now();
    final initial = (_manufactureDate != null && !_manufactureDate!.isAfter(now))
        ? _manufactureDate!
        : now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: now,
      helpText: 'Select Manufacture Date',
    );

    if (picked != null) {
      setState(() {
        _manufactureDate = picked;
        // If expiry date was already set earlier than manufacture date, clear it
        if (_expiryDate != null && _expiryDate!.isBefore(picked)) {
          _expiryDate = null;
        }
      });
    }
  }

  Future<void> pickexpiryDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Expiry cannot be in the past; and cannot be before manufacture date
    final effectiveFirstDate = (_manufactureDate != null && _manufactureDate!.isAfter(today))
        ? _manufactureDate!
        : today;

    final initial = (_expiryDate != null && !_expiryDate!.isBefore(effectiveFirstDate))
        ? _expiryDate!
        : effectiveFirstDate.add(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: effectiveFirstDate,
      lastDate: DateTime(2100),
      helpText: 'Select Expiry Date',
    );

    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  double get _profitMargin {
    final purchase = double.tryParse(_purchasePriceController.text) ?? 0.0;
    final selling = double.tryParse(_sellingPriceController.text) ?? 0.0;
    if (selling <= 0) return 0.0;
    return ((selling - purchase) / selling) * 100.0;
  }

  double get _perTabletPrice {
    final selling = double.tryParse(_sellingPriceController.text) ?? 0.0;
    final tabs = int.tryParse(_totalLooseInStripController.text) ?? 0;
    if (tabs <= 0) return 0.0;
    return selling / tabs;
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check and fill required fields correctly'),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_manufactureDate != null && _manufactureDate!.isAfter(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Manufacture date cannot be in the future'),
        ),
      );
      return;
    }

    if (_expiryDate != null && _expiryDate!.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Expiry date cannot be in the past'),
        ),
      );
      return;
    }

    if (_manufactureDate != null &&
        _expiryDate != null &&
        _expiryDate!.isBefore(_manufactureDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Expiry date cannot be before manufacture date'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final now = DateTime.now();
      final formattedToday = now.toIso8601String().split('T')[0];

      final mDateStr = _manufactureDate != null
          ? _manufactureDate!.toIso8601String().split('T')[0]
          : widget.medicineItem.manufactureDate;

      final expDateStr = _expiryDate != null
          ? _expiryDate!.toIso8601String().split('T')[0]
          : widget.medicineItem.expiryDate;

      final updatedMedicine = widget.medicineItem.copyWith(
        medName: _medicineNameController.text.trim(),
        genericName: _genericNameController.text.trim(),
        brand: _brandNameController.text.trim(),
        category: _categoryController.text.trim(),
        strength: _strengthController.text.trim(),
        dosageForm: _selectedDosageForm,
        schedule: _selectedSchedule,
        imageUrl: _medicinePhotoPath,
        batchNo: _batchNumberController.text.trim(),
        quantity:
            int.tryParse(_stockQuantityController.text.trim()) ??
            widget.medicineItem.quantity,
        minStockLevel:
            int.tryParse(_minStockController.text.trim()) ??
            widget.medicineItem.minStockLevel,
        maxStockLevel:
            int.tryParse(_maxStockController.text.trim()) ??
            widget.medicineItem.maxStockLevel,
        purchasePrice:
            double.tryParse(_purchasePriceController.text.trim()) ??
            widget.medicineItem.purchasePrice,
        sellingPrice:
            double.tryParse(_sellingPriceController.text.trim()) ??
            widget.medicineItem.sellingPrice,
        mrp:
            double.tryParse(_mrpController.text.trim()) ??
            widget.medicineItem.mrp,
        avLoose: _isLooseAvailable,
        looseQuantity: _isLooseAvailable
            ? (int.tryParse(_looseQtyController.text.trim()) ?? 0)
            : 0,
        totalLooseInStrip: _isLooseAvailable
            ? (int.tryParse(_totalLooseInStripController.text.trim()) ?? 0)
            : 0,
        manufactureDate: mDateStr.toString(),
        expiryDate: expDateStr.toString(),
        updateDate: formattedToday,
        supplier: _supplierController.text.trim().isNotEmpty
            ? _supplierController.text.trim()
            : widget.medicineItem.supplier,
      );

      MedicineInputModel updateMedicine = MedicineInputModel(
        medName: _medicineNameController.text.trim(),
        genericName: _genericNameController.text.trim(),
        brand: _brandNameController.text.trim(),
        category: _categoryController.text.trim(),
        strength: _strengthController.text.trim(),
        imageUrl: _medicinePhotoPath ?? '',
        batchNo: _batchNumberController.text.trim(),
        supplier: _supplierController.text.trim(),
        dosageForm: _selectedDosageForm,
        schedule: _selectedSchedule,
        quantity:
            int.tryParse(_stockQuantityController.text.trim()) ??
            widget.medicineItem.quantity,
        looseQuantity: _isLooseAvailable
            ? (int.tryParse(_looseQtyController.text.trim()) ?? 0)
            : 0,
        totalLooseInStrip: _isLooseAvailable
            ? (int.tryParse(_totalLooseInStripController.text.trim()) ?? 0)
            : 0,
        minStockLevel:
            int.tryParse(_minStockController.text.trim()) ??
            widget.medicineItem.minStockLevel,
        maxStockLevel:
            int.tryParse(_maxStockController.text.trim()) ??
            widget.medicineItem.maxStockLevel,
        purchasePrice:
            double.tryParse(_purchasePriceController.text.trim()) ??
            widget.medicineItem.purchasePrice,
        sellingPrice:
            double.tryParse(_sellingPriceController.text.trim()) ??
            widget.medicineItem.sellingPrice,
        mrp:
            double.tryParse(_mrpController.text.trim()) ??
            widget.medicineItem.mrp,
        manufactureDate: mDateStr,
        expiryDate: expDateStr,
        avLoose: _isLooseAvailable,
        stockStatus: _calculateStock(
          minLavel:
              int.tryParse(_minStockController.text.trim()) ??
              widget.medicineItem.minStockLevel,
          stockLavel:
              int.tryParse(_stockQuantityController.text.trim()) ??
              widget.medicineItem.quantity,
        ),
      );

      if (mounted) {
        final selectedShop = ref.read(selectedShopProvider);
        MedicineOutputModel finalMedicine = updatedMedicine;

        if (selectedShop != null &&
            widget.medicineItem.id != null &&
            widget.medicineItem.id!.isNotEmpty) {
          final response = await apiService.updateMedicine(
            shopId: selectedShop.id,
            inputModel: updateMedicine,
            invId: widget.medicineItem.id!,
          );

          if (response.statusCode >= 200 &&
              response.statusCode < 300 &&
              response.data != null) {
            finalMedicine = response.data!;
          }
        }

        // 1. Update Riverpod state and SQLite local DB
        await ref
            .read(inventoryProvider.notifier)
            .updateMedicine(finalMedicine);

        if (!mounted) return;

        // 2. Trigger onUpdated callback
        widget.onUpdated?.call(finalMedicine);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success,
            content: Text('${finalMedicine.medName} updated successfully'),
          ),
        );

        // 3. Pop returning final updated medicine
        Navigator.of(context).pop(finalMedicine);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  StockStatus _calculateStock({
    required int minLavel,
    required int stockLavel,
  }) {
    if (stockLavel == 0) {
      return StockStatus.outOfStock;
    } else if (stockLavel >= minLavel) {
      return StockStatus.inStock;
    } else {
      return StockStatus.lowStock;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppThemeExtension>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.94,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // ─── Drag Handle ───
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color:
                    appColors?.border ??
                    (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),

          // ─── Header Bar ───
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
            child: Row(
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.edit_note_rounded,
                      size: 26,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Medicine',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.medicineItem.medName.isNotEmpty
                            ? widget.medicineItem.medName
                            : 'Update medicine details',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.lightTextTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),

          // ─── Modern Tab Bar ───
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              labelStyle: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  iconMargin: EdgeInsets.only(bottom: 2),
                  icon: Icon(Icons.medical_services_outlined, size: 18),
                  text: 'Basic Info',
                ),
                Tab(
                  iconMargin: EdgeInsets.only(bottom: 2),
                  icon: Icon(Icons.inventory_2_outlined, size: 18),
                  text: 'Batch & Stock',
                ),
                Tab(
                  iconMargin: EdgeInsets.only(bottom: 2),
                  icon: Icon(Icons.payments_outlined, size: 18),
                  text: 'Pricing',
                ),
                Tab(
                  iconMargin: EdgeInsets.only(bottom: 2),
                  icon: Icon(Icons.grain_rounded, size: 18),
                  text: 'Loose Sales',
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ─── Tab Views Content ───
          Expanded(
            child: Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicInfoTab(theme, isDark),
                  _buildBatchAndStockTab(theme, isDark),
                  _buildPricingTab(theme, isDark),
                  _buildLooseSalesTab(theme, isDark),
                ],
              ),
            ),
          ),

          // ─── Sticky Bottom Action Bar ───
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      onPressed: _isSubmitting ? null : _handleSave,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_rounded, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Save Changes',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TAB 1: BASIC INFO
  // ══════════════════════════════════════════════════════════════════
  Widget _buildBasicInfoTab(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo section
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Medicine Image',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Tap to change photo',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AddPhotoWidget(
                  imageUrl: _medicinePhotoPath,
                  dosageForm: _selectedDosageForm,
                  medicineName: _medicineNameController.text,
                  category: _categoryController.text,
                  height: 150,
                  isEditable: true,
                  onPhotoChanged: (path) {
                    setState(() => _medicinePhotoPath = path);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Primary details
          _buildFormCard(
            theme: theme,
            isDark: isDark,
            title: 'Identification',
            icon: Icons.badge_outlined,
            children: [
              TextFieldWidget(
                labelText: 'Medicine Name',
                hintText: 'Enter medicine name',
                isRequired: true,
                controller: _medicineNameController,
                prefixIcon: Icons.medication_outlined,
              ),
              const SizedBox(height: 14),
              TextFieldWidget(
                labelText: 'Generic Name (Active Ingredient)',
                hintText: 'e.g. Paracetamol, Amoxicillin',
                isRequired: true,
                controller: _genericNameController,
                prefixIcon: Icons.biotech_outlined,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      labelText: 'Brand / Mfr.',
                      hintText: 'e.g. Cipla, Sun Pharma',
                      controller: _brandNameController,
                      prefixIcon: Icons.business_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFieldWidget(
                      labelText: 'Strength',
                      hintText: 'e.g. 500mg, 10ml',
                      controller: _strengthController,
                      prefixIcon: Icons.fitness_center_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFieldWidget(
                labelText: 'Category',
                hintText: 'e.g. Antibiotic, Antipyretic',
                controller: _categoryController,
                prefixIcon: Icons.category_outlined,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Classification
          _buildFormCard(
            theme: theme,
            isDark: isDark,
            title: 'Classification & Form',
            icon: Icons.category_rounded,
            children: [
              _buildInputLabel(
                label: 'Dosage Form',
                isRequired: true,
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 6),
              DosageFormDropDownWidget(
                value: _selectedDosageForm,
                required: true,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedDosageForm = val);
                  }
                },
              ),
              const SizedBox(height: 14),
              _buildInputLabel(
                label: 'Schedule Category',
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 6),
              SchedulesDropDownWidget(
                value: _selectedSchedule,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedSchedule = val);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TAB 2: BATCH & STOCK
  // ══════════════════════════════════════════════════════════════════
  Widget _buildBatchAndStockTab(ThemeData theme, bool isDark) {
    final bool isNearExpiry =
        _expiryDate != null &&
        _expiryDate!.isBefore(DateTime.now().add(const Duration(days: 90)));

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stock Quantities Card
          _buildFormCard(
            theme: theme,
            isDark: isDark,
            title: 'Stock Quantities',
            icon: Icons.inventory_2_outlined,
            children: [
              TextFieldWidget(
                labelText: 'Current Stock (Strips)',
                hintText: 'Total strips in stock',
                keyboardType: TextInputType.number,
                isRequired: true,
                controller: _stockQuantityController,
                prefixIcon: Icons.warehouse_outlined,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      labelText: 'Min Level Alert',
                      hintText: 'Alert threshold',
                      keyboardType: TextInputType.number,
                      controller: _minStockController,
                      prefixIcon: Icons.warning_amber_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFieldWidget(
                      labelText: 'Max Stock Cap',
                      hintText: 'Max storage cap',
                      keyboardType: TextInputType.number,
                      controller: _maxStockController,
                      prefixIcon: Icons.arrow_upward_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Batch & Dates Card
          _buildFormCard(
            theme: theme,
            isDark: isDark,
            title: 'Batch & Lifespan',
            icon: Icons.calendar_month_outlined,
            children: [
              TextFieldWidget(
                labelText: 'Batch Number',
                hintText: 'e.g. BTH-8902',
                isRequired: true,
                controller: _batchNumberController,
                prefixIcon: Icons.qr_code_2_rounded,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildDateTile(
                      theme: theme,
                      isDark: isDark,
                      label: 'Mfg Date',
                      date: _manufactureDate,
                      onTap: pickManuFactureDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateTile(
                      theme: theme,
                      isDark: isDark,
                      label: 'Expiry Date',
                      date: _expiryDate,
                      isExpiry: true,
                      onTap: pickexpiryDate,
                    ),
                  ),
                ],
              ),
              if (isNearExpiry) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: AppColors.warningDark,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Warning: Expiry date is within 90 days.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.warningDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Supplier Info Card
          _buildFormCard(
            theme: theme,
            isDark: isDark,
            title: 'Supplier & Vendor',
            icon: Icons.local_shipping_outlined,
            children: [
              TextFieldWidget(
                labelText: 'Supplier / Distributor Name',
                hintText: 'Enter supplier name',
                controller: _supplierController,
                prefixIcon: Icons.storefront_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TAB 3: PRICING
  // ══════════════════════════════════════════════════════════════════
  Widget _buildPricingTab(ThemeData theme, bool isDark) {
    final margin = _profitMargin;
    final isProfitable = margin > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pricing Inputs Card
          _buildFormCard(
            theme: theme,
            isDark: isDark,
            title: 'Per Strip Pricing (₹)',
            icon: Icons.currency_rupee_rounded,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      labelText: 'Purchase Price',
                      hintText: 'Cost in ₹',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      isRequired: true,
                      controller: _purchasePriceController,
                      prefixIcon: Icons.shopping_cart_outlined,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFieldWidget(
                      labelText: 'Selling Price',
                      hintText: 'Price in ₹',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      isRequired: true,
                      controller: _sellingPriceController,
                      prefixIcon: Icons.sell_outlined,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFieldWidget(
                labelText: 'Maximum Retail Price (MRP)',
                hintText: 'MRP on strip in ₹',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                isRequired: true,
                controller: _mrpController,
                prefixIcon: Icons.price_check_outlined,
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Profit Margin & Analytics Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isProfitable
                  ? AppColors.success.withValues(alpha: isDark ? 0.08 : 0.05)
                  : AppColors.error.withValues(alpha: isDark ? 0.08 : 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isProfitable
                    ? AppColors.success.withValues(alpha: 0.3)
                    : AppColors.error.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profit Margin Calculation',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isProfitable
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${margin.toStringAsFixed(1)}% margin',
                        style: TextStyle(
                          color: isProfitable
                              ? AppColors.successDark
                              : AppColors.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPricingMetric(
                      label: 'Purchase',
                      value: '₹${_purchasePriceController.text}',
                      theme: theme,
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                    _buildPricingMetric(
                      label: 'Selling',
                      value: '₹${_sellingPriceController.text}',
                      theme: theme,
                      highlightColor: AppColors.primary,
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                    _buildPricingMetric(
                      label: 'Profit / Strip',
                      value:
                          '₹${((double.tryParse(_sellingPriceController.text) ?? 0) - (double.tryParse(_purchasePriceController.text) ?? 0)).toStringAsFixed(2)}',
                      theme: theme,
                      highlightColor: isProfitable
                          ? AppColors.successDark
                          : AppColors.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TAB 4: LOOSE SALES
  // ══════════════════════════════════════════════════════════════════
  Widget _buildLooseSalesTab(ThemeData theme, bool isDark) {
    final perTabPrice = _perTabletPrice;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Loose Toggle Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Column(
              children: [
                // SwitchListTile(
                //   contentPadding: EdgeInsets.zero,
                //   title: Text(
                //     'Enable Loose Sales',
                //     style: theme.textTheme.titleSmall?.copyWith(
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                //   subtitle: Text(
                //     'Allows selling individual tablets broken from strip',
                //     style: theme.textTheme.bodySmall?.copyWith(
                //       color: isDark
                //           ? AppColors.darkTextTertiary
                //           : AppColors.lightTextTertiary,
                //     ),
                //   ),
                //   value: _isLooseAvailable,
                //   activeTrackColor: AppColors.primary,
                //   onChanged: (val) {
                //     setState(() => _isLooseAvailable = val);
                //   },
                // ),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Enable Loose Sales'),
                    subtitle: Text('Allows selling individual tablets broken from strip',
                          style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                    ),
                    value: _isLooseAvailable,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _isLooseAvailable = val);
                    },
                  ),
                ),
                if (_isLooseAvailable) ...[
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldWidget(
                          labelText: 'Tablets Per Strip',
                          hintText: 'e.g. 10',
                          keyboardType: TextInputType.number,
                          controller: _totalLooseInStripController,
                          prefixIcon: Icons.format_list_numbered_rounded,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFieldWidget(
                          labelText: 'Current Loose Tablets',
                          hintText: 'e.g. 4',
                          keyboardType: TextInputType.number,
                          controller: _looseQtyController,
                          prefixIcon: Icons.pie_chart_outline_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (_isLooseAvailable) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: isDark ? 0.08 : 0.05,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calculate_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calculated Price per Tablet',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${perTabPrice.toStringAsFixed(2)} / tablet',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // HELPER WIDGETS
  // ══════════════════════════════════════════════════════════════════
  Widget _buildFormCard({
    required ThemeData theme,
    required bool isDark,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDateTile({
    required ThemeData theme,
    required bool isDark,
    required String label,
    required DateTime? date,
    bool isExpiry = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 15,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              date != null ? _formatDate(date) : 'Select date',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingMetric({
    required String label,
    required String value,
    required ThemeData theme,
    Color? highlightColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: highlightColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel({
    required String label,
    bool isRequired = false,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
