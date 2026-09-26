import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/model/Input/medicine_input_model.dart';
import 'package:pharmace/Frontend/Inventory/model/medicine_model.dart';
import 'package:pharmace/Frontend/Widget/AddMedicine/add_photo_widget.dart';
import 'package:pharmace/Frontend/Widget/AddMedicine/dosage_form_drop_down_widget.dart';
import 'package:pharmace/Frontend/Widget/text_feild_widget.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Provider/inventory_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  DosageForm? selectedDosageForm;
  DateTime? _expiryDate;
  DateTime? _manuFactureDate;
  bool _isLooseAvailable = false;
  String? _medicinePhotoPath;
  Schedules? chosenSchedule;
  ApiService apiService = ApiService();
  bool _isLoading = false;

  String formattedDate =
      '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}';

  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _genericNameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _catogoryController = TextEditingController();
  final TextEditingController _streangthController = TextEditingController();
  final TextEditingController _batchNumberController = TextEditingController();
  final TextEditingController _stockQuantityController =
      TextEditingController();
  final TextEditingController _minimumStockController = TextEditingController();
  final TextEditingController _tabletsPerStripController =
      TextEditingController();
  final TextEditingController _tabletsPriceController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Add Medicine')),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text('Medicine Photo', style: theme.textTheme.titleLarge),
                    SizedBox(height: 10),
                    AddPhotoWidget(
                      onPhotoChanged: (path) {
                        _medicinePhotoPath = path;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Besic information',
                      style: theme.textTheme.titleLarge,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          TextFieldWidget(
                            hintText: 'Medicine Name',
                            isRequired: true,
                            controller: _medicineNameController,
                          ),
                          SizedBox(height: 10),
                          TextFieldWidget(
                            hintText: 'Generic Name',
                            isRequired: true,
                            controller: _genericNameController,
                          ),
                          SizedBox(height: 10),
                          TextFieldWidget(
                            hintText: 'Brand Name',
                            controller: _brandNameController,
                          ),
                          SizedBox(height: 10),
                          TextFieldWidget(
                            hintText: 'Category',
                            isRequired: true,
                            controller: _catogoryController,
                          ),
                          SizedBox(height: 10),
                          TextFieldWidget(
                            hintText: 'Streangth',
                            isRequired: true,
                            controller: _streangthController,
                          ),
                          SizedBox(height: 10),
                          SchedulesDropDownWidget(
                            value: chosenSchedule,
                            onChanged: (value) {
                              setState(() => chosenSchedule = value);
                            },
                          ),
                          SizedBox(height: 10),
                          DosageFormDropDownWidget(
                            value: selectedDosageForm,
                            onChanged: (value) {
                              setState(() => selectedDosageForm = value);
                            },
                            required: true,
                          ),
                          SizedBox(height: 20),
                          Text('Batch', style: theme.textTheme.titleLarge),
                          SizedBox(height: 15),
                          TextFieldWidget(
                            hintText: 'Batch number',
                            isRequired: true,
                            controller: _batchNumberController,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: _manuFactureDate == null
                                  ? ''
                                  : '${_manuFactureDate!.day}/${_manuFactureDate!.month}/${_manuFactureDate!.year}',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Manufacture Date *',
                              suffixIcon: Icon(Icons.calendar_month),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (_manuFactureDate == null) {
                                return 'Please select manufacture date';
                              }
                              return null;
                            },
                            onTap: pickManuFactureDate,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: _expiryDate == null
                                  ? ''
                                  : '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Expiry Date *',
                              suffixIcon: Icon(Icons.calendar_month),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (_manuFactureDate == null) {
                                return 'Please select expiry date';
                              }
                              return null;
                            },
                            onTap: pickexpiryDate,
                          ),
                          SizedBox(height: 20),
                          Text('Inventory', style: theme.textTheme.titleLarge),
                          SizedBox(height: 15),
                          TextFieldWidget(
                            hintText: 'Quntity (Strips)',
                            isRequired: true,
                            controller: _stockQuantityController,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10),
                          TextFieldWidget(
                            hintText: 'Minimum stock level',
                            isRequired: true,
                            controller: _minimumStockController,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          Text('Loose sale', style: theme.textTheme.titleLarge),
                          SizedBox(height: 15),
                          _isLooseAvailableWidget(theme),
                          SizedBox(height: 20),
                          Text('Pricing', style: theme.textTheme.titleLarge),
                          SizedBox(height: 15),
                          TextFieldWidget(
                            hintText: 'Purchase price (per strip)',
                            isRequired: true,
                            controller: _purchasePriceController,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10),
                          TextFieldWidget(
                            hintText: 'Selling price (per strip)',
                            isRequired: true,
                            controller: _sellingPriceController,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10),
                          TextFieldWidget(
                            hintText: 'MRP (per strip)',
                            isRequired: true,
                            controller: _mrpController,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // if (_formKey.currentState?.validate() ?? false) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //       content: Text('Medicine added successfully!'),
                                //       duration: Duration(seconds: 2),
                                //     ),
                                //   );
                                //   MedicineModel medicineItem = MedicineModel(
                                //     medicineNmae: _medicineNameController.text
                                //         .trim(),
                                //     manufacturerName: _brandNameController.text
                                //         .trim(),
                                //     manufactureContackNo: '+9120253663',
                                //     stockValue: int.parse(
                                //       _stockQuantityController.text.trim(),
                                //     ),
                                //     price: double.parse(
                                //       _sellingPriceController.text.trim(),
                                //     ),
                                //     purchesePrice: double.parse(
                                //       _purchasePriceController.text.trim(),
                                //     ),
                                //     mrp: double.parse(_mrpController.text.trim()),
                                //     stockStatus: _calculateStock(
                                //       minLavel: int.parse(
                                //         _minimumStockController.text,
                                //       ),
                                //       stockLavel: int.parse(
                                //         _stockQuantityController.text,
                                //       ),
                                //     ),
                                //     imgUrl: _medicinePhotoPath,
                                //     minLevel: int.parse(
                                //       _minimumStockController.text.toString(),
                                //     ),
                                //     genericName: _genericNameController.text.trim(),
                                //     category: _catogoryController.text.trim(),
                                //     dosageForm: selectedDosageForm as DosageForm,
                                //     strength: _streangthController.text.trim(),
                                //     batchNo: _batchNumberController.text.trim(),
                                //     expData: _expiryDate.toString(),
                                //     addedBy: 'Soumen Maity',
                                //     updatedBy: 'Soumen Maity',
                                //     addDate: formattedDate,
                                //     upDate: formattedDate,
                                //     isLooseAv: _isLooseAvailable,
                                //     looseQuantity:
                                //         _tabletsPerStripController.text.isNotEmpty
                                //         ? int.parse(_tabletsPerStripController.text)
                                //         : null,
                                //     schedules: chosenSchedule as Schedules,
                                //   );
                                 
                                // }

                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  if (selectedDosageForm == null) {
                                    _showFeedbackSnackBar(
                                      context: context,
                                      message: 'Please select a dosage form.',
                                      isWarning: true,
                                    );
                                    return;
                                  }
                                  if (chosenSchedule == null) {
                                    _showFeedbackSnackBar(
                                      context: context,
                                      message:
                                          'Please select a schedule category.',
                                      isWarning: true,
                                    );
                                    return;
                                  }
                                  if (_manuFactureDate == null) {
                                    _showFeedbackSnackBar(
                                      context: context,
                                      message:
                                          'Please select a manufacture date.',
                                      isWarning: true,
                                    );
                                    return;
                                  }
                                  if (_expiryDate == null) {
                                    _showFeedbackSnackBar(
                                      context: context,
                                      message: 'Please select an expiry date.',
                                      isWarning: true,
                                    );
                                    return;
                                  }

                                  final shopId = ref
                                      .read(selectedShopProvider)
                                      ?.id;
                                  if (shopId == null || shopId.isEmpty) {
                                    if (!mounted) return;
                                    _showFeedbackSnackBar(
                                      context: context,
                                      message: 'Please select a shop first.',
                                      isWarning: true,
                                    );
                                    return;
                                  }

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    MedicineInputModel
                                    medicine = MedicineInputModel(
                                      medName: _medicineNameController.text
                                          .trim(),
                                      genericName: _genericNameController.text
                                          .trim(),
                                      brand: _brandNameController.text.trim(),
                                      category: _catogoryController.text.trim(),
                                      strength: _streangthController.text
                                          .trim(),
                                      imageUrl: "",
                                      batchNo: _batchNumberController.text
                                          .trim(),
                                      supplier: '',
                                      dosageForm:
                                          selectedDosageForm as DosageForm,
                                      schedule: chosenSchedule as Schedules,
                                      quantity: int.parse(
                                        _stockQuantityController.text.trim(),
                                      ),
                                      looseQuantity:
                                          _tabletsPerStripController
                                              .text
                                              .isNotEmpty
                                          ? int.parse(
                                              _tabletsPerStripController.text,
                                            )
                                          : 0,
                                      totalLooseInStrip: 0,
                                      minStockLevel:
                                          int.tryParse(
                                            _minimumStockController.text.trim(),
                                          ) ??
                                          0,
                                      maxStockLevel: 100,
                                      stockStatus: _calculateStock(
                                        minLavel:
                                            int.tryParse(
                                              _minimumStockController.text
                                                  .trim(),
                                            ) ??
                                            0,
                                        stockLavel: int.parse(
                                          _stockQuantityController.text.trim(),
                                        ),
                                      ),
                                      purchasePrice:
                                          double.tryParse(
                                            _purchasePriceController.text
                                                .trim(),
                                          ) ??
                                          0.0,
                                      sellingPrice:
                                          double.tryParse(
                                            _sellingPriceController.text.trim(),
                                          ) ??
                                          0.0,
                                      mrp:
                                          double.tryParse(
                                            _mrpController.text.trim(),
                                          ) ??
                                          0.0,
                                      manufactureDate: _manuFactureDate!
                                          .toString()
                                          .split(' ')[0],
                                      expiryDate: _expiryDate!.toString().split(
                                        ' ',
                                      )[0],
                                      avLoose: _isLooseAvailable,
                                    );

                                    final navigator = Navigator.of(context);
                                    final response = await apiService
                                        .addMedicine(shopId, medicine);
                                    if (!mounted) return;

                                    if (response.statusCode >= 200 &&
                                        response.statusCode < 300) {
                                      _showFeedbackSnackBar(
                                        context: context,
                                        message:
                                            '${medicine.medName} was saved to inventory successfully!',
                                        isSuccess: true,
                                      );
                                       if (response.data != null) {
                                         ref
                                             .read(inventoryProvider.notifier)
                                             .add(response.data!);
                                       }
                                       navigator.pop();
                                    } else {
                                      _showFeedbackSnackBar(
                                        context: context,
                                        message:
                                            response.message != null &&
                                                response.message!.isNotEmpty
                                            ? response.message!
                                            : 'Failed to add medicine (${response.statusCode}).',
                                        isError: true,
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      _showFeedbackSnackBar(
                                        context: context,
                                        message:
                                            'Network or processing error: $e',
                                        isError: true,
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                }
                              },
                              label: _isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Saving to Inventory...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 21,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Save Medicine',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isLoading
                                    ? AppColors.primaryLight
                                    : AppColors.primary,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: AppColors.primaryLight
                                    .withValues(alpha: 0.8),
                                disabledForegroundColor: Colors.white,
                                elevation: _isLoading ? 0 : 2,
                                shadowColor: AppColors.primary.withValues(
                                  alpha: 0.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) _buildLoadingOverlay(theme),
        ],
      ),
    );
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

  Widget _isLooseAvailableWidget(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sell as loose tablets',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Let customers buy fewer tablets than a full strip',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              Switch(
                value: _isLooseAvailable,
                onChanged: (value) {
                  setState(() {
                    _isLooseAvailable = value;
                  });
                },
              ),
            ],
          ),

          if (_isLooseAvailable) ...[
            Divider(height: 24),

            Text(
              'Tablets per strip',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),

            SizedBox(height: 8),

            TextFieldWidget(
              hintText: '10',
              keyboardType: TextInputType.number,
              controller: _tabletsPerStripController,
            ),

            SizedBox(height: 16),

            Text(
              'Price per tablet',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),

            SizedBox(height: 8),
            TextFieldWidget(
              hintText: '0.25',
              keyboardType: TextInputType.number,
              controller: _tabletsPriceController,
            ),

            SizedBox(height: 8),

            Text(
              'Enter strip selling price below to see a suggested rate,\n'
              'or set your own.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey.shade300,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> pickexpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Future<void> pickManuFactureDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      // initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _manuFactureDate = picked;
      });
    }
  }

  Widget _buildLoadingOverlay(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final medicineName = _medicineNameController.text.trim();

    return PopScope(
      canPop: false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withValues(alpha: 0.45),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF18201E) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 68,
                      height: 68,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medication_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Saving Medicine',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  medicineName.isNotEmpty
                      ? 'Syncing "$medicineName" with cloud inventory...'
                      : 'Transmitting details to your shop inventory...',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFeedbackSnackBar({
    required BuildContext context,
    required String message,
    bool isSuccess = false,
    bool isWarning = false,
    bool isError = false,
  }) {
    final icon = isSuccess
        ? Icons.check_circle_rounded
        : isWarning
        ? Icons.warning_amber_rounded
        : Icons.error_outline_rounded;

    final bgColor = isSuccess
        ? const Color(0xFF0D5E4D)
        : isWarning
        ? const Color(0xFF4A3210)
        : const Color(0xFF3B1818);

    final iconColor = isSuccess
        ? AppColors.successDark
        : isWarning
        ? AppColors.warningDark
        : AppColors.errorDark;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor,
        elevation: 6,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: iconColor.withValues(alpha: 0.3), width: 1),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        duration: Duration(seconds: isError ? 4 : 3),
      ),
    );
  }
}
