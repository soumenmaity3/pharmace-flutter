
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';
import 'package:pharmace/Frontend/Inventory/model/medicine_model.dart';
import 'package:pharmace/Frontend/Widget/text_feild_widget.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';
import 'package:pharmace/Provider/inventory_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';

enum StockAdjustmentType {
  add(label: 'Add Stock', icon: Icons.add_circle_outline, sign: '+'),
  remove(label: 'Remove Stock', icon: Icons.remove_circle_outline, sign: '-'),
  set(label: 'Set Exact', icon: Icons.tune_rounded, sign: '=');

  const StockAdjustmentType({
    required this.label,
    required this.icon,
    required this.sign,
  });

  final String label;
  final IconData icon;
  final String sign;
}

/// Helper function to display the Adjust Stock bottom sheet
Future<MedicineOutputModel?> showAdjustStockBottomSheet({
  required BuildContext context,
  required MedicineOutputModel medicineItem,
  Function(MedicineOutputModel updatedMedicine)? onAdjusted,
}) {
  return showModalBottomSheet<MedicineOutputModel>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) =>
        AdjustStockWidget(medicineItem: medicineItem, onAdjusted: onAdjusted),
  );
}

class AdjustStockWidget extends ConsumerStatefulWidget {
  const AdjustStockWidget({
    super.key,
    required this.medicineItem,
    this.onAdjusted,
  });

  final MedicineOutputModel medicineItem;
  final Function(MedicineOutputModel updatedMedicine)? onAdjusted;

  /// Static helper for showing modal
  static Future<MedicineOutputModel?> show(
    BuildContext context, {
    required MedicineOutputModel medicineItem,
    Function(MedicineOutputModel updatedMedicine)? onAdjusted,
  }) {
    return showAdjustStockBottomSheet(
      context: context,
      medicineItem: medicineItem,
      onAdjusted: onAdjusted,
    );
  }

  @override
  ConsumerState<AdjustStockWidget> createState() => _AdjustStockWidgetState();
}

class _AdjustStockWidgetState extends ConsumerState<AdjustStockWidget> {
  StockAdjustmentType _selectedType = StockAdjustmentType.add;
  late final TextEditingController _stripQtyController;
  late final TextEditingController _looseQtyController;
  late final TextEditingController _notesController;

  int _stripAdjustment = 1;
  int _looseAdjustment = 0;
  String _selectedReason = 'New Restock';
  bool _isSubmitting = false;

  ApiService apiService = ApiService();

  final Map<StockAdjustmentType, List<String>> _reasonMap = {
    StockAdjustmentType.add: [
      'New Restock',
      'Supplier Delivery',
      'Customer Return',
      'Audit Correction',
      'Other',
    ],
    StockAdjustmentType.remove: [
      'Damaged / Broken',
      'Expired Stock',
      'Customer Dispense',
      'Audit Shrinkage',
      'Supplier Return',
      'Other',
    ],
    StockAdjustmentType.set: [
      'Physical Stock Audit',
      'Inventory Reconciliation',
      'Initial Count Correction',
      'Other',
    ],
  };

  @override
  void initState() {
    super.initState();
    _stripAdjustment = _selectedType == StockAdjustmentType.set
        ? widget.medicineItem.quantity
        : 1;
    _looseAdjustment = _selectedType == StockAdjustmentType.set
        ? widget.medicineItem.looseQuantity
        : 0;

    _stripQtyController = TextEditingController(text: '$_stripAdjustment');
    _looseQtyController = TextEditingController(text: '$_looseAdjustment');
    _notesController = TextEditingController();
    _selectedReason = _reasonMap[_selectedType]!.first;
  }

  @override
  void dispose() {
    _stripQtyController.dispose();
    _looseQtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _calculatedNewQuantity {
    final current = widget.medicineItem.quantity;
    switch (_selectedType) {
      case StockAdjustmentType.add:
        return current + _stripAdjustment;
      case StockAdjustmentType.remove:
        final res = current - _stripAdjustment;
        return res < 0 ? 0 : res;
      case StockAdjustmentType.set:
        return _stripAdjustment < 0 ? 0 : _stripAdjustment;
    }
  }

  int get _calculatedNewLooseQuantity {
    if (!widget.medicineItem.avLoose) return 0;
    final currentLoose = widget.medicineItem.looseQuantity;
    switch (_selectedType) {
      case StockAdjustmentType.add:
        return currentLoose + _looseAdjustment;
      case StockAdjustmentType.remove:
        final res = currentLoose - _looseAdjustment;
        return res < 0 ? 0 : res;
      case StockAdjustmentType.set:
        return _looseAdjustment < 0 ? 0 : _looseAdjustment;
    }
  }

  StockStatus _getProjectedStatus(int newQty) {
    if (newQty <= 0) return StockStatus.outOfStock;
    if (newQty <= widget.medicineItem.minStockLevel) {
      return StockStatus.lowStock;
    }
    return StockStatus.inStock;
  }

  void _onTypeChanged(StockAdjustmentType type) {
    setState(() {
      _selectedType = type;
      _selectedReason = _reasonMap[type]!.first;
      if (type == StockAdjustmentType.set) {
        _stripAdjustment = widget.medicineItem.quantity;
        _looseAdjustment = widget.medicineItem.looseQuantity;
      } else {
        _stripAdjustment = 1;
        _looseAdjustment = 0;
      }
      _stripQtyController.text = '$_stripAdjustment';
      _looseQtyController.text = '$_looseAdjustment';
    });
  }

  void _applyQuickPill(int amount) {
    setState(() {
      if (_selectedType == StockAdjustmentType.set) {
        _stripAdjustment = amount;
      } else {
        _stripAdjustment = (_stripAdjustment + amount).clamp(1, 99999);
      }
      _stripQtyController.text = '$_stripAdjustment';
    });
  }

  Future<void> _handleSave() async {
    if (_isSubmitting) return;

    if (_stripAdjustment < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity cannot be negative')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final newQuantity = _calculatedNewQuantity;
      final newLooseQuantity = _calculatedNewLooseQuantity;

      final now = DateTime.now();
      final formattedDate =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

      MedicineOutputModel updatedMedicine = widget.medicineItem.copyWith(
        quantity: newQuantity,
        looseQuantity: newLooseQuantity,
        updateDate: formattedDate,
      );

      // Demo simulation delay
      await Future.delayed(const Duration(milliseconds: 300));

      final selectedShop = ref.read(selectedShopProvider);
      if (selectedShop != null && widget.medicineItem.id != null) {
        final response = await apiService.adjustStock(
          shopId: selectedShop.id,
          invId: widget.medicineItem.id!,
          adjustStock: newQuantity,
          adjustLooseStock: newLooseQuantity,
        );
        if (response.statusCode >= 200 &&
            response.statusCode < 300 &&
            response.data != null) {
          updatedMedicine = response.data!;
        }
      }

      await ref
          .read(inventoryProvider.notifier)
          .updateMedicine(updatedMedicine);

      if (!mounted) return;

      widget.onAdjusted?.call(updatedMedicine);
      Navigator.of(context).pop(updatedMedicine);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text('Stock adjusted to $newQuantity strips'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppThemeExtension>();
    final newQty = _calculatedNewQuantity;
    final projectedStatus = _getProjectedStatus(newQty);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
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

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.cubes,
                      size: 20,
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
                        'Adjust Stock',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.medicineItem.medName} (${widget.medicineItem.dosageForm.label ?? widget.medicineItem.dosageForm.name})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              appColors?.textSecondary ??
                              (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Scrollable Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Adjustment Type Selector (Add / Remove / Set)
                  _buildTypeSelector(theme, isDark),
                  const SizedBox(height: 18),

                  // Quick Pill buttons
                  _buildQuickPills(theme, isDark),
                  const SizedBox(height: 16),

                  // Strips Quantity Stepper Card
                  _buildQuantityCard(
                    theme: theme,
                    isDark: isDark,
                    title: 'Strips Quantity',
                    subtitle:
                        'Full medicine strips to ${_selectedType.label.toLowerCase()}',
                    controller: _stripQtyController,
                    currentValue: _stripAdjustment,
                    onDecrement: () {
                      if (_stripAdjustment >
                          (_selectedType == StockAdjustmentType.set ? 0 : 1)) {
                        setState(() {
                          _stripAdjustment--;
                          _stripQtyController.text = '$_stripAdjustment';
                        });
                      }
                    },
                    onIncrement: () {
                      setState(() {
                        _stripAdjustment++;
                        _stripQtyController.text = '$_stripAdjustment';
                      });
                    },
                    onChanged: (val) {
                      final parsed = int.tryParse(val) ?? 0;
                      setState(() => _stripAdjustment = parsed);
                    },
                  ),

                  // Loose Tablets (if enabled)
                  if (widget.medicineItem.avLoose) ...[
                    const SizedBox(height: 14),
                    _buildQuantityCard(
                      theme: theme,
                      isDark: isDark,
                      title: 'Loose Tablets',
                      subtitle:
                          'Individual tablets (${widget.medicineItem.looseQuantity} currently in loose stock)',
                      controller: _looseQtyController,
                      currentValue: _looseAdjustment,
                      onDecrement: () {
                        if (_looseAdjustment > 0) {
                          setState(() {
                            _looseAdjustment--;
                            _looseQtyController.text = '$_looseAdjustment';
                          });
                        }
                      },
                      onIncrement: () {
                        setState(() {
                          _looseAdjustment++;
                          _looseQtyController.text = '$_looseAdjustment';
                        });
                      },
                      onChanged: (val) {
                        final parsed = int.tryParse(val) ?? 0;
                        setState(() => _looseAdjustment = parsed);
                      },
                    ),
                  ],

                  const SizedBox(height: 18),

                  // Reason for Adjustment
                  Text(
                    'Reason for Adjustment',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _reasonMap[_selectedType]!.map((reason) {
                      final isSelected = _selectedReason == reason;
                      return ChoiceChip(
                        label: Text(reason),
                        selected: isSelected,
                        selectedColor: AppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 13,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedReason = reason);
                          }
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Remarks / Notes
                  TextFieldWidget(
                    hintText: 'Additional notes / reference (optional)',
                    controller: _notesController,
                    prefixIcon: Icons.notes_rounded,
                  ),

                  const SizedBox(height: 20),

                  // Projected Summary Card
                  _buildPreviewCard(
                    theme: theme,
                    isDark: isDark,
                    newQty: newQty,
                    projectedStatus: projectedStatus,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
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
                                const Icon(Icons.check_rounded, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Confirm Adjustment',
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

  Widget _buildTypeSelector(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: StockAdjustmentType.values.map((type) {
          final isSelected = _selectedType == type;
          Color activeColor = AppColors.primary;
          if (type == StockAdjustmentType.remove) {
            activeColor = AppColors.error;
          } else if (type == StockAdjustmentType.add) {
            activeColor = AppColors.success;
          }

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _onTypeChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? theme.cardColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type.icon,
                      size: 16,
                      color: isSelected
                          ? activeColor
                          : (isDark ? Colors.white60 : Colors.black54),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      type.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? activeColor
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickPills(ThemeData theme, bool isDark) {
    List<int> pills = [1, 5, 10, 25, 50];
    if (_selectedType == StockAdjustmentType.set) {
      pills = [0, 10, 25, 50, 100];
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: pills.map((amount) {
          final label = _selectedType == StockAdjustmentType.set
              ? '$amount'
              : '${_selectedType.sign}$amount';
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(label),
              backgroundColor: theme.cardColor,
              labelStyle: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onPressed: () => _applyQuickPill(amount),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuantityCard({
    required ThemeData theme,
    required bool isDark,
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required int currentValue,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrement Button
              Material(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onDecrement,
                  child: Container(
                    height: 48,
                    width: 48,
                    alignment: Alignment.center,
                    child: const Icon(Icons.remove, size: 22),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Quantity Input Box
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: onChanged,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                    enabled: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Increment Button
              Material(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onIncrement,
                  child: Container(
                    height: 48,
                    width: 48,
                    alignment: Alignment.center,
                    child: const Icon(Icons.add, size: 22),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard({
    required ThemeData theme,
    required bool isDark,
    required int newQty,
    required StockStatus projectedStatus,
  }) {
    Color statusColor = AppColors.success;
    if (projectedStatus == StockStatus.outOfStock) {
      statusColor = AppColors.error;
    } else if (projectedStatus == StockStatus.lowStock) {
      statusColor = AppColors.warning;
    }

    final statusLabel = projectedStatus.label ?? projectedStatus.name;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Adjustment Summary',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryColumn(
                label: 'Current',
                value: '${widget.medicineItem.quantity}',
                theme: theme,
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Colors.grey,
              ),
              _buildSummaryColumn(
                label: 'Adjustment',
                value: _selectedType == StockAdjustmentType.set
                    ? 'set to $_stripAdjustment'
                    : '${_selectedType.sign}$_stripAdjustment',
                theme: theme,
                valueColor: _selectedType == StockAdjustmentType.remove
                    ? AppColors.error
                    : AppColors.success,
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Colors.grey,
              ),
              _buildSummaryColumn(
                label: 'Resulting Stock',
                value: '$newQty strips',
                theme: theme,
                valueColor: statusColor,
                isBold: true,
              ),
            ],
          ),
          if (newQty <= widget.medicineItem.minStockLevel && newQty > 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Resulting stock will be at or below minimum level (${widget.medicineItem.minStockLevel}).',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.warningDark,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryColumn({
    required String label,
    required String value,
    required ThemeData theme,
    Color? valueColor,
    bool isBold = false,
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
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
