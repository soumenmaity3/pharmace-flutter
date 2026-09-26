import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';
import 'package:pharmace/Frontend/Inventory/model/medicine_model.dart';
import 'package:pharmace/Frontend/Widget/AddMedicine/add_photo_widget.dart';
import 'package:pharmace/Frontend/Widget/MedicineDetails/adjust_stock_widget.dart';
import 'package:pharmace/Frontend/Widget/MedicineDetails/medicine_edit_widget.dart';
import 'package:pharmace/Frontend/Widget/employee_status_dialog.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Provider/shop_provider.dart';

class MedicineDetailsScreen extends ConsumerStatefulWidget {
  const MedicineDetailsScreen({super.key, required this.medicineItem});
  final MedicineOutputModel medicineItem;

  @override
  ConsumerState<MedicineDetailsScreen> createState() =>
      _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends ConsumerState<MedicineDetailsScreen> {
  late MedicineOutputModel medicineItem;


  @override
  void initState() {
    super.initState();
    medicineItem = widget.medicineItem;
    // _initUpdatedByNameFuture();
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text('Medicine')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddPhotoWidget(
                imageUrl: medicineItem.imgUrl,
                dosageForm: medicineItem.dosageForm,
                medicineName: medicineItem.medicineNmae,
                category: medicineItem.category,
                height: 200,
                isEditable: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicineItem.medicineNmae,
                        style: theme.textTheme.titleLarge,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${medicineItem.manufacturerName} . ${medicineItem.dosageForm.label}',
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                  _buildStatusPill(
                    stockStatus: medicineItem.stockStatus,
                    theme: theme,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  _buildStockInfoItem(
                    value: '${medicineItem.stockValue}',
                    label: 'Strips in stock',
                    theme: theme,
                  ),
                  const SizedBox(width: 10),
                  _buildStockInfoItem(
                    value: '₹${medicineItem.price}',
                    label: 'Per strip',
                    theme: theme,
                  ),
                  const SizedBox(width: 10),
                  _buildStockInfoItem(
                    value: '${medicineItem.minLevel}',
                    label: 'Min. level',
                    theme: theme,
                  ),
                ],
              ),
              SizedBox(height: 15),
              medicineItem.isLooseAv
                  ? _looseWidget(
                      tabs: medicineItem.looseQuantity,
                      tabsPrice: 0.25,
                      theme: theme,
                    )
                  : Container(),
              SizedBox(height: 15),
              Text('Basic information', style: theme.textTheme.titleLarge),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      label: 'Generic name',
                      value: medicineItem.genericName,
                      theme: theme,
                    ),
                    _buildDetailRow(
                      label: 'Category',
                      value: medicineItem.category,
                      theme: theme,
                    ),
                    _buildDetailRow(
                      label: 'Dosage form',
                      value: medicineItem.dosageForm.label.toString(),
                      theme: theme,
                    ),
                    _buildDetailRow(
                      label: 'Strength',
                      value: medicineItem.strength,
                      showDivider: false,
                      theme: theme,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text('Batch information', style: theme.textTheme.titleLarge),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      label: 'Batch number',
                      value: medicineItem.batchNo,
                      theme: theme,
                    ),
                    _buildDetailRow(
                      label: 'Expiry date',
                      value: medicineItem.expData,
                      showDivider: false,
                      theme: theme,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text('Pricing', style: theme.textTheme.titleLarge),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      label: 'Purchase price',
                      value: '₹${medicineItem.purchesePrice}',
                      theme: theme,
                    ),
                    _buildDetailRow(
                      label: 'Selling price',
                      value: '₹${medicineItem.price}',
                      theme: theme,
                    ),
                    _buildDetailRow(
                      label: 'MRP',
                      value: '₹${medicineItem.mrp}',
                      showDivider: false,
                      theme: theme,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text('Supplier', style: theme.textTheme.titleLarge),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      label: 'Supplier name',
                      value: medicineItem.manufacturerName,
                      theme: theme,
                    ),
                    _buildDetailRow(
                      label: 'Contact',
                      value: medicineItem.manufactureContackNo,
                      showDivider: false,
                      theme: theme,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text('Record history', style: theme.textTheme.titleLarge),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.successDark.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(medicineItem.addedBy?.name ?? ''),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Added by',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                              Text(medicineItem.addedBy?.name ?? 'Unknown'),
                            ],
                          ),
                        ),
                        Text(
                          medicineItem.addDate ?? '',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: isDark
                          ? AppColors.darkDivider
                          : AppColors.lightDivider,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.successDark.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(medicineItem.updatedBy?.name ?? ''),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last updated by',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                              Text(medicineItem.updatedBy?.name ?? 'Unknown'),
                            ],
                          ),
                        ),
                        Text(
                          medicineItem.upDate,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      icon: Icon(Icons.settings_outlined, size: 19),
                      label: 'Edit',
                      backgroundColor: theme.cardColor,
                      onTap: () async {
                        final selectedShop = ref.watch(selectedShopProvider);
                        if (selectedShop!.isOwnerEmployee == false) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EmployeeStatusDialog();
                            },
                          );
                        } else {
                          final updated = await showMedicineEditBottomSheet(
                            context: context,
                            medicineItem: medicineItem,
                          );
                          if (updated != null && mounted) {
                            setState(() {
                              medicineItem = updated;
                              // _initUpdatedByNameFuture();
                            });
                          }
                        }
                      },
                      theme: theme,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _actionButton(
                      icon: FaIcon(FontAwesomeIcons.cubes, size: 19),
                      label: 'Adjust stock',
                      backgroundColor: AppColors.primary,
                      onTap: () async {
                        final selectedShop = ref.watch(selectedShopProvider);
                        if (selectedShop!.isOwnerEmployee == false) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EmployeeStatusDialog();
                            },
                          );
                        } else {
                          final updated = await showAdjustStockBottomSheet(
                            context: context,
                            medicineItem: medicineItem,
                          );
                          if (updated != null && mounted) {
                            setState(() {
                              medicineItem = updated;
                              // _initUpdatedByNameFuture();
                            });
                          }
                        }
                      },
                      theme: theme,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildStatusPill({
    required StockStatus stockStatus,
    required ThemeData theme,
  }) {
    if (stockStatus == StockStatus.inStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/inventory_outline.svg',
              width: 14,
              height: 14,
              colorFilter: ColorFilter.mode(
                AppColors.successDark,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              medicineItem.stockStatus.label.toString(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.successDark,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    } else if (stockStatus == StockStatus.lowStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, size: 14, color: AppColors.warningDark),

            const SizedBox(width: 6),
            Text(
              medicineItem.stockStatus.label.toString(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.warningDark,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    } else if (stockStatus == StockStatus.expiring) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.watch_later_outlined,
              size: 14,
              color: AppColors.warning,
            ),

            const SizedBox(width: 6),
            Text(
              medicineItem.stockStatus.label.toString(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.warningDark,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    } else if (stockStatus == StockStatus.outOfStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 14, color: AppColors.errorDark),

            const SizedBox(width: 6),
            Text(
              medicineItem.stockStatus.label.toString(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.errorDark,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _actionButton({
    required Widget icon,
    required String label,
    required Color backgroundColor,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return '';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Widget _buildStockInfoItem({
    required String value,
    required String label,
    required ThemeData theme,
  }) {
    final bool isDark = theme.brightness == Brightness.dark;
    return Expanded(
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: theme.textTheme.titleLarge),
            SizedBox(height: 6),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.lightTextTertiary
                    : AppColors.darkTextTertiary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _looseWidget({
    required int tabs,
    required double tabsPrice,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(left: 10, top: 15, bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.successDark.withValues(alpha: isDark ? 0.05 : 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 15,
              color: AppColors.success,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loose sales available',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.success,
                ),
              ),
              // SizedBox(height: 10),
              Text(
                '$tabs tabs/strip · ₹$tabsPrice/tablet',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    bool showDivider = true,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              Text(value, style: theme.textTheme.titleSmall),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
      ],
    );
  }
}
