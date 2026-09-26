import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pharmace/Frontend/Sales/model/inv_model.dart';
import 'package:pharmace/Frontend/Sales/model/medicine_bill_model.dart';
import 'package:pharmace/Frontend/service/bill_pdf_service.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Provider/sales_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';
import 'package:printing/printing.dart';

class BillDetailsScreen extends ConsumerWidget {
  const BillDetailsScreen({
    super.key,
    required this.invId,
    this.phoneNo,
    this.referredBy,
    this.cashierName = 'Arindam Sengupta',
    this.discount,
    this.tax,
  });

  final String invId;
  final String? phoneNo;
  final String? referredBy;
  final String cashierName;
  final double? discount;
  final double? tax;
  String _formatDateTime(InvModel invItem) {
    if (invItem.date.isNotEmpty) return invItem.date;
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final amPm = now.hour >= 12 ? 'PM' : 'AM';
    return 'Today, $hour:$minute $amPm';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedShop = ref.watch(selectedShopProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final salesState = ref.watch(salesProvider);

    final invItem = salesState.allItems.firstWhere(
      (item) => item.invNo == invId,
    );
    final calculatedSubtotal = invItem.selectedMedicine.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    final effectiveSubtotal = calculatedSubtotal > 0
        ? calculatedSubtotal
        : invItem.value;

    var effectiveDiscount = _calculateDiscount(invItem, calculatedSubtotal);

    var effectiveTax = _calculateTax(invItem, calculatedSubtotal);
    if (discount == null && tax == null && calculatedSubtotal > 0) {
      if (calculatedSubtotal > invItem.value) {
        effectiveDiscount = calculatedSubtotal - invItem.value;
      } else if (invItem.value > calculatedSubtotal) {
        effectiveTax = invItem.value - calculatedSubtotal;
      }
    }

    final bool isPaid =
        invItem.paymentType != PaymentType.due &&
        invItem.paymentType != PaymentType.refunded;

    final String displayCustomer = invItem.customerName.trim().isNotEmpty
        ? invItem.customerName
        : 'Walk-in Customer';

    final String customerTypeLabel = invItem.customerType == 0
        ? 'Walk-in Customer'
        : 'Online';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          invId.startsWith('#') ? invId : '#$invId',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= Header Meta Info Row =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDateTime(invItem),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Cashier: $cashierName',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  _buildStatusPill(isPaid, isDark, invItem),
                ],
              ),

              SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Color(0xFFECEEF0),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            selectedShop!.shopName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${selectedShop.city}, ${selectedShop.state}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${selectedShop.phone}  ·  GST: ${selectedShop.gstNumber ?? '--'}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? AppColors.darkDivider : Color(0xFFEFF1F3),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customer',
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          displayCustomer,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customer type',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          customerTypeLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),

                    if (phoneNo != null && phoneNo!.trim().isNotEmpty) ...[
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phone',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            phoneNo!.trim(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (referredBy != null &&
                        referredBy!.trim().isNotEmpty) ...[
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Referred by',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            referredBy!.trim(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],

                    SizedBox(height: 14),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? AppColors.darkDivider : Color(0xFFEFF1F3),
                    ),
                    SizedBox(height: 16),
                    if (invItem.selectedMedicine.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Text(
                            'No item details available',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                            ),
                          ),
                        ),
                      )
                    else
                      ...invItem.selectedMedicine.asMap().entries.map((entry) {
                        final item = entry.value;
                        final isLast =
                            entry.key == invItem.selectedMedicine.length - 1;

                        return Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.medicineName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      _formatItemSubtitle(item),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? AppColors.darkTextTertiary
                                            : Color(0xFF8A939E),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '₹${item.totalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                    SizedBox(height: 16),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? AppColors.darkDivider : Color(0xFFEFF1F3),
                    ),
                    SizedBox(height: 14),
                    _buildSummaryRow(
                      title: 'Subtotal',
                      value: '₹${effectiveSubtotal.toStringAsFixed(2)}',
                      isDark: isDark,
                    ),

                    if (effectiveDiscount > 0) ...[
                      SizedBox(height: 10),
                      _buildSummaryRow(
                        title: 'Discount',
                        value: '−₹${effectiveDiscount.toStringAsFixed(2)}',
                        isDark: isDark,
                      ),
                    ],

                    if (effectiveTax > 0) ...[
                      SizedBox(height: 10),
                      _buildSummaryRow(
                        title: 'Tax',
                        value: '₹${effectiveTax.toStringAsFixed(2)}',
                        isDark: isDark,
                      ),
                    ],

                    SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          '₹${invItem.value.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? AppColors.darkDivider : Color(0xFFEFF1F3),
                    ),
                    SizedBox(height: 14),
                    Center(
                      child: Text(
                        'Thank you for shopping with us!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextTertiary
                              : Color(0xFF8A939E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Color(0xFFECEEF0),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment method',
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      invItem.paymentType.label ??
                          invItem.paymentType.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      isDark: isDark,
                      onTap: () => _handleShare(context, invItem, ref),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _actionButton(
                      icon: Icons.download_rounded,
                      label: 'Save',
                      isDark: isDark,
                      onTap: () => _handleSave(context, invItem, ref),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _actionButton(
                      icon: Icons.print_outlined,
                      label: 'Print',
                      isDark: isDark,
                      onTap: () => _handlePrint(context, invItem, ref),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    invItem.paymentType == PaymentType.due
                        ? ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Due payment can't be refunded"),
                              backgroundColor: AppColors.error,
                            ),
                          )
                        : _handleRefund(context, ref, invItem);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.errorDarkContainer.withValues(alpha: 0.3)
                          : Color(0xFFFFF9F9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? AppColors.errorDark.withValues(alpha: 0.5)
                            : Color(0xFFF3C7C7),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.errorDark
                              : Color(0xFFC73636),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Refund sale',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.errorDark
                                : Color(0xFFC73636),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              InkWell(
                onTap: () {
                  _clickPaid(context, ref, isDark);
                },
                child: invItem.paymentType == PaymentType.due
                    ? Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primaryDark.withValues(alpha: 0.3)
                              : Color(0xFFFFF9F9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? AppColors.success.withValues(alpha: 0.5)
                                : Color(0xFFF3C7C7),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Mark as paid',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(height: 16),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formatItemSubtitle(MedicineBillModel item) {
    if (item.looseQty > 0 && item.strip > 0) {
      final perTabPrice = (item.loose != null && item.loose! > 0)
          ? (item.price / item.loose!)
          : item.price;
      final stripText = item.strip == 1 ? '1 strip' : '${item.strip} strips';
      return '$stripText + ${item.looseQty} loose · ₹${perTabPrice.toStringAsFixed(2)}/tab';
    } else if (item.looseQty > 0) {
      final perTabPrice = (item.loose != null && item.loose! > 0)
          ? (item.price / item.loose!)
          : item.price;
      return '${item.strip} strips + ${item.looseQty} loose · ₹${perTabPrice.toStringAsFixed(2)}/tab';
    } else if (item.strip > 0) {
      final stripLabel = item.medicineName.toLowerCase().contains('sachet')
          ? (item.strip == 1 ? 'sachet' : 'sachets')
          : (item.strip == 1 ? 'strip' : 'strips');
      return '${item.strip} $stripLabel × ₹${item.price.toStringAsFixed(2)}';
    } else {
      return '1 unit × ₹${item.price.toStringAsFixed(2)}';
    }
  }

  double _subtotal(List<MedicineBillModel> medicineList) {
    return medicineList.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  double _calculateDiscount(InvModel invItem, double subtotal) {
    if (discount != null) return discount!;

    if (subtotal > invItem.value) {
      return subtotal - invItem.value;
    }

    return 0;
  }

  double _calculateTax(InvModel invItem, double subtotal) {
    if (tax != null) return tax!;

    if (invItem.value > subtotal && subtotal > 0) {
      return invItem.value - subtotal;
    }

    return 0;
  }

  Future<void> _handleShare(
    BuildContext context,
    InvModel invItem,
    WidgetRef ref,
  ) async {
    try {
      final subtotal = _subtotal(invItem.selectedMedicine);

      final calculatedDiscount = _calculateDiscount(invItem, subtotal);

      final calculatedTax = _calculateTax(invItem, subtotal);
      final selectedShop = ref.watch(selectedShopProvider);

      await BillPdfService.sharePdf(
        invId: invId,
        customerName: invItem.customerName.trim().isNotEmpty
            ? invItem.customerName
            : 'Walk-in Customer',
        customerType: invItem.customerType,
        total: invItem.value,
        paymentType:
            invItem.paymentType.label ?? invItem.paymentType.name.toUpperCase(),
        items: invItem.selectedMedicine,
        phoneNo: phoneNo,
        referredBy: referredBy,
        cashierName: cashierName,
        dateTime: _formatDateTime(invItem),

        discount: calculatedDiscount > 0 ? calculatedDiscount : null,

        tax: calculatedTax > 0 ? calculatedTax : null,
        shopName: selectedShop!.shopName,
        shopAddress: selectedShop.address,
        shopPhone: selectedShop.phone,
        gstNumber: selectedShop.gstNumber ?? '--',
        dlNumber: selectedShop.licenseNumber ?? '--',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to share PDF: $e')));
      }
    }
  }

  Future<void> _handleSave(
    BuildContext context,
    InvModel invItem,
    WidgetRef ref,
  ) async {
    try {
      final subtotal = _subtotal(invItem.selectedMedicine);

      final calculatedDiscount = _calculateDiscount(invItem, subtotal);

      final calculatedTax = _calculateTax(invItem, subtotal);
      final selectedShop = ref.watch(selectedShopProvider);
      final file = await BillPdfService.saveAndOpenPdf(
        invId: invId,
        customerName: invItem.customerName.trim().isNotEmpty
            ? invItem.customerName
            : 'Walk-in Customer',
        customerType: invItem.customerType,
        total: invItem.value,
        paymentType:
            invItem.paymentType.label ?? invItem.paymentType.name.toUpperCase(),
        items: invItem.selectedMedicine,
        phoneNo: phoneNo,
        referredBy: referredBy,
        cashierName: cashierName,
        dateTime: _formatDateTime(invItem),
        discount: calculatedDiscount > 0 ? calculatedDiscount : null,
        tax: calculatedTax > 0 ? calculatedTax : null,
        openImmediately: true,
        shopName: selectedShop!.shopName,
        shopAddress: selectedShop.address,
        shopPhone: selectedShop.phone,
        gstNumber: selectedShop.gstNumber ?? '--',
        dlNumber: selectedShop.licenseNumber ?? '--',
      );

      final isDownloads = file.path.contains('/Download');
      final locationDescription = isDownloads ? 'Downloads' : 'device storage';

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invoice saved to $locationDescription: ${file.uri.pathSegments.last}',
            ),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 4),
            action: SnackBarAction(
              label: 'OPEN',
              textColor: Colors.white,
              onPressed: () {
                BillPdfService.openPdf(file.path);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save invoice: $e')));
      }
    }
  }

  Future<void> _handlePrint(
    BuildContext context,
    InvModel invItem,
    WidgetRef ref,
  ) async {
    try {
      final subtotal = _subtotal(invItem.selectedMedicine);

      final calculatedDiscount = _calculateDiscount(invItem, subtotal);

      final calculatedTax = _calculateTax(invItem, subtotal);
      final selectedShop = ref.watch(selectedShopProvider);
      final pdfData = await BillPdfService.generatePdf(
        invId: invId,
        customerName: invItem.customerName.trim().isNotEmpty
            ? invItem.customerName
            : 'Walk-in Customer',
        customerType: invItem.customerType,
        total: invItem.value,
        paymentType:
            invItem.paymentType.label ?? invItem.paymentType.name.toUpperCase(),
        items: invItem.selectedMedicine,
        phoneNo: phoneNo,
        referredBy: referredBy,
        cashierName: cashierName,
        dateTime: _formatDateTime(invItem),
        discount: calculatedDiscount > 0 ? calculatedDiscount : null,
        tax: calculatedTax > 0 ? calculatedTax : null,
        shopName: selectedShop!.shopName,
        shopAddress: selectedShop.address,
        shopPhone: selectedShop.phone,
        gstNumber: selectedShop.gstNumber ?? '--',
        dlNumber: selectedShop.licenseNumber ?? '--',
      );

      final cleanId = invId.replaceAll('#', '');
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfData,
        name: 'Invoice_$cleanId',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to print: $e')));
      }
    }
  }

  void _handleRefund(BuildContext context, WidgetRef ref, InvModel invItem) {
    if (invItem.paymentType == PaymentType.refunded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This invoice has already been refunded')),
      );
      return;
    }

    if (invItem.paymentType == PaymentType.due) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Due payment can't be refunded"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 10),
              Text('Refund Sale'),
            ],
          ),
          content: Text(
            'Are you sure you want to refund invoice #${invItem.invNo}?\n\n'
            'This action will change the payment status to refunded.'
            'Refunded invoice payment type cannot be changed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () {
                ref
                    .read(salesProvider.notifier)
                    .updatePaymentType(invItem.invNo, PaymentType.refunded);

                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Invoice #${invItem.invNo} refunded successfully',
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              child: const Text('Confirm Refund'),
            ),
          ],
        );
      },
    );
  }

  void _clickPaid(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          titlePadding: EdgeInsets.fromLTRB(24, 24, 16, 8),
          contentPadding: EdgeInsets.fromLTRB(24, 8, 24, 16),
          actionsPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),

          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Mark as Paid',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),

              IconButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                icon: Icon(
                  Icons.close_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invoice #$invId',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),

              SizedBox(height: 6),

              Text(
                'Select the payment method used by the customer.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),

              SizedBox(height: 20),

              _buildPaymentOption(
                context: dialogContext,
                ref: ref,
                isDark: isDark,
                icon: Icons.qr_code_rounded,
                title: 'UPI',
                subtitle: 'Google Pay, PhonePe, Paytm',
                paymentType: PaymentType.upi,
              ),

              SizedBox(height: 10),

              _buildPaymentOption(
                context: dialogContext,
                ref: ref,
                isDark: isDark,
                icon: Icons.payments_outlined,
                title: 'Cash',
                subtitle: 'Received payment in cash',
                paymentType: PaymentType.cash,
              ),

              SizedBox(height: 10),

              _buildPaymentOption(
                context: dialogContext,
                ref: ref,
                isDark: isDark,
                icon: Icons.credit_card_rounded,
                title: 'Card',
                subtitle: 'Credit or debit card',
                paymentType: PaymentType.card,
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required BuildContext context,
    required WidgetRef ref,
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required PaymentType paymentType,
  }) {
    return InkWell(
      onTap: () {
        ref.read(salesProvider.notifier).updatePaymentType(invId, paymentType);

        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: EdgeInsets.all(14),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          color: isDark ? AppColors.darkSurface : Colors.white,

          border: Border.all(
            color: isDark ? AppColors.darkBorder : Color(0xFFE4E7EB),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),

                color: isDark ? AppColors.darkBorder : Color(0xFFF4F6F8),
              ),

              child: Icon(
                icon,
                size: 22,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),

            SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(bool isPaid, bool isDark, InvModel invItem) {
    if (invItem.paymentType == PaymentType.due) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.warningDarkContainer : Color(0xFFFBF0DC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.warningDark : Color(0xFFF0CCA0),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule,
              size: 14,
              color: isDark ? AppColors.warningDark : AppColors.warning,
            ),
            SizedBox(width: 4),
            Text(
              'Due',
              style: TextStyle(
                color: isDark ? AppColors.warningDark : AppColors.warning,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    if (invItem.paymentType == PaymentType.refunded) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.errorDarkContainer : Color(0xFFFBEAEA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.errorDark : Color(0xFFF5C2C2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh_rounded,
              size: 14,
              color: isDark ? AppColors.errorDark : AppColors.error,
            ),
            SizedBox(width: 4),
            Text(
              'Refunded',
              style: TextStyle(
                color: isDark ? AppColors.errorDark : AppColors.error,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.successDarkContainer : Color(0xFFE8F8F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.successDark : Color(0xFFBBE5CE),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 14,
            color: isDark ? AppColors.successDark : AppColors.success,
          ),
          SizedBox(width: 4),
          Text(
            'Paid',
            style: TextStyle(
              color: isDark ? AppColors.successDark : AppColors.success,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Color(0xFFE4E7EB),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
