import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pharmace/Frontend/Sales/model/medicine_bill_model.dart';
import 'package:share_plus/share_plus.dart';

class BillPdfService {
  // ============================================
  // BRAND & APP CONFIGURATION
  // ============================================
  static const String appPromotionUrl = 'https://pharmace.app';
  static const String appDownloadUrl = 'https://pharmace.app/download';

  // Design Color Palette (Matching Pharmace App Theme)
  static final PdfColor _primaryColor = PdfColor.fromHex('#0E6B58');
  static final PdfColor _primaryDark = PdfColor.fromHex('#0A5347');
  static final PdfColor _primaryLight = PdfColor.fromHex('#EBF5F3');
  static final PdfColor _textPrimary = PdfColor.fromHex('#171B1F');
  static final PdfColor _textSecondary = PdfColor.fromHex('#5C6470');
  static final PdfColor _textTertiary = PdfColor.fromHex('#8A939E');
  static final PdfColor _borderColor = PdfColor.fromHex('#E6E8EB');
  static final PdfColor _cardBg = PdfColor.fromHex('#F8FAF9');
  static final PdfColor _rowAlternate = PdfColor.fromHex('#FAFCFB');

  // ============================================
  // GENERATE PDF
  // ============================================
  static Future<Uint8List> generatePdf({
    required String invId,
    required String customerName,
    required int customerType,
    required double total,
    required String paymentType,
    List<MedicineBillModel>? items,
    String? phoneNo,
    String? referredBy,
    String cashierName = 'Arindam Sengupta',
    String? dateTime,
    double? discount,
    double? tax,
    required String shopName,// = 'Sengupta Medical Hall',
    required String shopAddress,// = 'Kolkata, West Bengal',
    required String shopPhone,// = '+91 98300 45123',
    required String gstNumber,// = '19ABCDE1234F1Z5',
    required String dlNumber,// = 'WB-KOL-2023-145892',
    String? appDownloadUrl,
  }) async {
    // Load Unicode Font (Noto Sans)
    final fontData = await rootBundle.load(
      'assets/fonts/NotoSans-VariableFont_wdth,wght.ttf',
    );
    final notoFont = pw.Font.ttf(fontData);

    final pdf = pw.Document();

    final String cleanInvId = invId.startsWith('#') ? invId : '#$invId';
    final String formattedDate = dateTime ?? _formatCurrentDate();
    final double calculatedSubtotal = (items != null && items.isNotEmpty)
        ? items.fold<double>(0.0, (sum, item) => sum + item.totalPrice)
        : total;
    final double effectiveSubtotal =
        calculatedSubtotal > 0 ? calculatedSubtotal : total;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        theme: pw.ThemeData.withFont(
          base: notoFont,
          bold: notoFont,
        ),
        build: (pw.Context context) {
          return [
            // 1. Top Decorative Brand Bar & Header
            _buildHeader(
              shopName: shopName,
              shopAddress: shopAddress,
              shopPhone: shopPhone,
              gstNumber: gstNumber,
              dlNumber: dlNumber,
              invId: cleanInvId,
              dateTime: formattedDate,
              paymentType: paymentType,
            ),

            pw.SizedBox(height: 12),

            // 2. Customer & Billing Info Side-by-Side Cards
            _buildCustomerAndBillingCard(
              customerName: customerName,
              customerType: customerType,
              phoneNo: phoneNo,
              referredBy: referredBy,
              cashierName: cashierName,
              paymentType: paymentType,
            ),

            pw.SizedBox(height: 14),

            // 3. Medicine Items Table
            _buildItemsTable(
              items: items,
              fallbackTotal: total,
            ),

            pw.SizedBox(height: 12),

            // 4. Totals Breakdown & Terms & Conditions
            _buildTotalsAndTerms(
              subtotal: effectiveSubtotal,
              discount: discount,
              tax: tax,
              total: total,
              paymentType: paymentType,
            ),

            pw.SizedBox(height: 14),

            // 5. Verification, Signatory & Promotion Footer
            _buildFooter(
              shopName: shopName,
              invId: cleanInvId,
              appDownloadUrl: appDownloadUrl,
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ============================================
  // HEADER SECTION
  // ============================================
  static pw.Widget _buildHeader({
    required String shopName,
    required String shopAddress,
    required String shopPhone,
    required String gstNumber,
    required String dlNumber,
    required String invId,
    required String dateTime,
    required String paymentType,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Top Green Accent Bar
        pw.Container(
          height: 4,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            color: _primaryColor,
            borderRadius: pw.BorderRadius.circular(2),
          ),
        ),

        pw.SizedBox(height: 12),

        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            // Left: Pharmacy Info
            pw.Expanded(
              flex: 3,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    shopName,
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: _primaryDark,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Retail Pharmacy & Healthcare Solutions',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: _textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '$shopAddress · Contact: $shopPhone',
                    style: pw.TextStyle(
                      fontSize: 8.5,
                      color: _textSecondary,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Row(
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: pw.BoxDecoration(
                          color: _primaryLight,
                          borderRadius: pw.BorderRadius.circular(3),
                        ),
                        child: pw.Text(
                          'GSTIN: $gstNumber',
                          style: pw.TextStyle(
                            fontSize: 7.5,
                            fontWeight: pw.FontWeight.bold,
                            color: _primaryDark,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 6),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#EEF2F6'),
                          borderRadius: pw.BorderRadius.circular(3),
                        ),
                        child: pw.Text(
                          'D.L. No: $dlNumber',
                          style: pw.TextStyle(
                            fontSize: 7.5,
                            fontWeight: pw.FontWeight.bold,
                            color: _textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(width: 14),

            // Right: Tax Invoice Card
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: _cardBg,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: _borderColor, width: 0.8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'TAX INVOICE',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            fontWeight: pw.FontWeight.bold,
                            color: _primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        _buildStatusBadge(paymentType),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      invId,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      dateTime,
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================
  // STATUS BADGE
  // ============================================
  static pw.Widget _buildStatusBadge(String paymentType) {
    final cleanType = paymentType.toLowerCase();
    PdfColor bg;
    PdfColor border;
    PdfColor text;
    String label;

    if (cleanType == 'due') {
      bg = PdfColor.fromHex('#FBF0DC');
      border = PdfColor.fromHex('#F0CCA0');
      text = PdfColor.fromHex('#B4700F');
      label = 'DUE';
    } else if (cleanType == 'refunded') {
      bg = PdfColor.fromHex('#FBEAEA');
      border = PdfColor.fromHex('#F5C2C2');
      text = PdfColor.fromHex('#BE3B3B');
      label = 'REFUNDED';
    } else {
      bg = PdfColor.fromHex('#E7F5EC');
      border = PdfColor.fromHex('#BBE5CE');
      text = PdfColor.fromHex('#1E8E5A');
      label = 'PAID';
    }

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: pw.BorderRadius.circular(4),
        border: pw.Border.all(color: border, width: 0.8),
      ),
      child: pw.Text(
        label,
        style: pw.TextStyle(
          color: text,
          fontSize: 7.5,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================
  // CUSTOMER & BILLING DETAILS CARD
  // ============================================
  static pw.Widget _buildCustomerAndBillingCard({
    required String customerName,
    required int customerType,
    required String? phoneNo,
    required String? referredBy,
    required String cashierName,
    required String paymentType,
  }) {
    final displayCustomer = customerName.trim().isNotEmpty
        ? customerName
        : 'Walk-in Customer';

    final displayType = customerType == 0 ? 'Walk-in' : 'Online';
    final hasPhone = phoneNo != null && phoneNo.trim().isNotEmpty;
    final displayPhone = hasPhone ? phoneNo.trim() : '—';
    final hasReferredBy = referredBy != null && referredBy.trim().isNotEmpty;
    final displayReferredBy = hasReferredBy ? referredBy.trim() : '—';

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: pw.BoxDecoration(
        color: _cardBg,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _borderColor, width: 0.8),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Left: Billed To / Customer Details
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'CUSTOMER DETAILS',
                  style: pw.TextStyle(
                    fontSize: 7.5,
                    fontWeight: pw.FontWeight.bold,
                    color: _textTertiary,
                    letterSpacing: 0.4,
                  ),
                ),
                pw.SizedBox(height: 3),
                _buildInfoLine('Name: ', displayCustomer, isBold: true),
                pw.SizedBox(height: 2),
                _buildInfoLine('Phone: ', displayPhone),
                pw.SizedBox(height: 2),
                _buildInfoLine('Type: ', displayType),
              ],
            ),
          ),

          pw.Container(
            width: 1,
            height: 48,
            color: _borderColor,
            margin: const pw.EdgeInsets.symmetric(horizontal: 12),
          ),

          // Right: Doctor & Transaction Info
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'PRESCRIPTION & BILLING',
                  style: pw.TextStyle(
                    fontSize: 7.5,
                    fontWeight: pw.FontWeight.bold,
                    color: _textTertiary,
                    letterSpacing: 0.4,
                  ),
                ),
                pw.SizedBox(height: 3),
                _buildInfoLine(
                  'Referred By: ',
                  displayReferredBy,
                  valueColor: hasReferredBy ? _primaryDark : null,
                  isBold: hasReferredBy,
                ),
                pw.SizedBox(height: 2),
                _buildInfoLine('Cashier: ', cashierName),
                pw.SizedBox(height: 2),
                _buildInfoLine(
                  'Payment: ',
                  paymentType.toUpperCase(),
                  valueColor: _primaryDark,
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoLine(
    String label,
    String value, {
    bool isBold = false,
    PdfColor? valueColor,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 8.5,
            color: _textSecondary,
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 8.5,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: valueColor ?? _textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================
  // MEDICINES TABLE
  // ============================================
  static pw.Widget _buildItemsTable({
    required List<MedicineBillModel>? items,
    required double fallbackTotal,
  }) {
    final bool hasItems = items != null && items.isNotEmpty;

    return pw.Container(
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _borderColor, width: 0.8),
      ),
      child: pw.ClipRRect(
        horizontalRadius: 6,
        verticalRadius: 6,
        child: pw.Column(
          children: [
            // Table Header Row
            pw.Container(
              color: _primaryColor,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              child: pw.Row(
                children: [
                  pw.SizedBox(
                    width: 22,
                    child: pw.Text(
                      '#',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Text(
                      'ITEM & PACKAGING DETAILS',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'QTY / PACK',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'RATE',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'AMOUNT',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Table Rows
            if (!hasItems)
              // Fallback single line item if no item list provided
              _buildTableRow(
                index: 1,
                name: 'Pharmacy Medicines / Products',
                subtitle: 'Consolidated Bill Items',
                qtyText: '1 Unit',
                rateText: '₹${fallbackTotal.toStringAsFixed(2)}',
                amountText: '₹${fallbackTotal.toStringAsFixed(2)}',
                isEven: false,
                isLast: true,
              )
            else
              ...items.asMap().entries.map((entry) {
                final int idx = entry.key + 1;
                final MedicineBillModel item = entry.value;
                final bool isLast = entry.key == items.length - 1;

                return _buildTableRow(
                  index: idx,
                  name: item.medicineName,
                  subtitle: _formatItemSubtitle(item),
                  qtyText: _formatItemQty(item),
                  rateText: '₹${item.price.toStringAsFixed(2)}',
                  amountText: '₹${item.totalPrice.toStringAsFixed(2)}',
                  isEven: entry.key.isEven,
                  isLast: isLast,
                );
              }),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTableRow({
    required int index,
    required String name,
    required String subtitle,
    required String qtyText,
    required String rateText,
    required String amountText,
    required bool isEven,
    required bool isLast,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: isEven ? _rowAlternate : PdfColors.white,
        border: isLast
            ? null
            : pw.Border(
                bottom: pw.BorderSide(color: _borderColor, width: 0.6),
              ),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.SizedBox(
            width: 22,
            child: pw.Text(
              '$index',
              style: pw.TextStyle(
                fontSize: 8.5,
                color: _textSecondary,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  name,
                  style: pw.TextStyle(
                    fontSize: 9.5,
                    fontWeight: pw.FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                pw.SizedBox(height: 1),
                pw.Text(
                  subtitle,
                  style: pw.TextStyle(
                    fontSize: 7.5,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              qtyText,
              style: pw.TextStyle(
                fontSize: 8.5,
                color: _textPrimary,
              ),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              rateText,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                fontSize: 8.5,
                color: _textSecondary,
              ),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              amountText,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                fontSize: 9.5,
                fontWeight: pw.FontWeight.bold,
                color: _textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // TOTALS & TERMS SECTION
  // ============================================
  static pw.Widget _buildTotalsAndTerms({
    required double subtotal,
    required double? discount,
    required double? tax,
    required double total,
    required String paymentType,
  }) {
    final double effectiveDiscount = discount ?? 0.0;
    final double effectiveTax = tax ?? 0.0;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Left Column: Terms & Disclaimers
        pw.Expanded(
          flex: 6,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: _cardBg,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: _borderColor, width: 0.8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'TERMS & HEALTH ADVISORY',
                  style: pw.TextStyle(
                    fontSize: 7.5,
                    fontWeight: pw.FontWeight.bold,
                    color: _textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
                pw.SizedBox(height: 4),
                _buildBulletPoint(
                  '1. Goods once sold cannot be returned without original cash memo.',
                ),
                _buildBulletPoint(
                  '2. Medicines must be stored under recommended conditions (< 25°C).',
                ),
                _buildBulletPoint(
                  '3. Take scheduled drugs strictly under prescription advice.',
                ),
                _buildBulletPoint(
                  '4. Any discrepancy should be reported within 24 hours.',
                ),
              ],
            ),
          ),
        ),

        pw.SizedBox(width: 14),

        // Right Column: Summary Card
        pw.Expanded(
          flex: 5,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: _borderColor, width: 0.8),
            ),
            child: pw.Column(
              children: [
                _buildSummaryLine(
                  label: 'Subtotal',
                  value: '₹${subtotal.toStringAsFixed(2)}',
                ),

                if (effectiveDiscount > 0) ...[
                  pw.SizedBox(height: 4),
                  _buildSummaryLine(
                    label: 'Discount',
                    value: '−₹${effectiveDiscount.toStringAsFixed(2)}',
                    valueColor: PdfColor.fromHex('#1E8E5A'),
                  ),
                ],

                if (effectiveTax > 0) ...[
                  pw.SizedBox(height: 4),
                  _buildSummaryLine(
                    label: 'Tax (GST)',
                    value: '+₹${effectiveTax.toStringAsFixed(2)}',
                  ),
                ],

                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 5),
                  child: pw.Divider(color: _borderColor, thickness: 0.8),
                ),

                // Total Box
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: pw.BoxDecoration(
                    color: _primaryLight,
                    borderRadius: pw.BorderRadius.circular(4),
                    border: pw.Border.all(color: _primaryColor, width: 0.8),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total Payable',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: _primaryDark,
                        ),
                      ),
                      pw.Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: _primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildBulletPoint(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 7,
          color: _textSecondary,
          height: 1.2,
        ),
      ),
    );
  }

  static pw.Widget _buildSummaryLine({
    required String label,
    required String value,
    PdfColor? valueColor,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 8.5,
            color: _textSecondary,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: valueColor ?? _textPrimary,
          ),
        ),
      ],
    );
  }

  // ============================================
  // FOOTER & VERIFICATION SECTION
  // ============================================
  static pw.Widget _buildFooter({
    required String shopName,
    required String invId,
    String? appDownloadUrl,
  }) {
    final String effectiveDownloadUrl =
        appDownloadUrl ?? BillPdfService.appDownloadUrl;
    final String effectiveVerifyUrl =
        '$appPromotionUrl?inv=${Uri.encodeComponent(invId)}';

    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            // Left: Authorized Signatory & Health Wish
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Wishing you a speedy recovery & good health!',
                  style: pw.TextStyle(
                    fontSize: 7.5,
                    fontWeight: pw.FontWeight.bold,
                    color: _primaryDark,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  width: 140,
                  height: 1,
                  color: _borderColor,
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Authorized Pharmacist Signatory',
                  style: pw.TextStyle(
                    fontSize: 7.5,
                    fontWeight: pw.FontWeight.bold,
                    color: _textSecondary,
                  ),
                ),
                pw.Text(
                  'For $shopName',
                  style: pw.TextStyle(
                    fontSize: 7,
                    color: _textTertiary,
                  ),
                ),
              ],
            ),

            // Right: Dual QR Cards (Bill Verification + App Branding)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: _cardBg,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: _borderColor, width: 0.8),
              ),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // QR 1: Verify Invoice
                  pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: effectiveVerifyUrl,
                        width: 38,
                        height: 38,
                      ),
                      pw.SizedBox(width: 6),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Verify Bill',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: _textPrimary,
                            ),
                          ),
                          pw.SizedBox(height: 1),
                          pw.Text(
                            'Scan for e-copy',
                            style: pw.TextStyle(
                              fontSize: 6.5,
                              color: _textSecondary,
                            ),
                          ),
                          pw.Text(
                            'Tax compliant',
                            style: pw.TextStyle(
                              fontSize: 6,
                              color: _textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Vertical Divider
                  pw.Container(
                    width: 0.8,
                    height: 38,
                    color: _borderColor,
                    margin: const pw.EdgeInsets.symmetric(horizontal: 9),
                  ),

                  // QR 2: App Branding & Download
                  pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: effectiveDownloadUrl,
                        width: 38,
                        height: 38,
                        color: _primaryDark,
                      ),
                      pw.SizedBox(width: 6),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Pharmace App',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          pw.SizedBox(height: 1),
                          pw.Text(
                            'Scan to Download',
                            style: pw.TextStyle(
                              fontSize: 6.5,
                              fontWeight: pw.FontWeight.bold,
                              color: _textSecondary,
                            ),
                          ),
                          pw.Text(
                            'Order refills online',
                            style: pw.TextStyle(
                              fontSize: 6,
                              color: _textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 8),

        // Bottom hairline note
        pw.Center(
          child: pw.Text(
            'This is a computer-generated tax invoice and does not require a physical signature.',
            style: pw.TextStyle(
              fontSize: 6.5,
              color: _textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================
  // FORMATTING HELPERS
  // ============================================
  static String _formatItemSubtitle(MedicineBillModel item) {
    if (item.looseQty > 0 && item.strip > 0) {
      final perTabPrice = (item.loose != null && item.loose! > 0)
          ? (item.price / item.loose!)
          : item.price;
      final stripText = item.strip == 1 ? '1 strip' : '${item.strip} strips';
      return '$stripText + ${item.looseQty} tabs · ₹${perTabPrice.toStringAsFixed(2)}/tab';
    } else if (item.looseQty > 0) {
      final perTabPrice = (item.loose != null && item.loose! > 0)
          ? (item.price / item.loose!)
          : item.price;
      return '${item.looseQty} loose tabs · ₹${perTabPrice.toStringAsFixed(2)}/tab';
    } else if (item.strip > 0) {
      final stripLabel = item.medicineName.toLowerCase().contains('sachet')
          ? (item.strip == 1 ? 'sachet' : 'sachets')
          : (item.strip == 1 ? 'strip' : 'strips');
      return '${item.strip} $stripLabel × ₹${item.price.toStringAsFixed(2)}';
    } else {
      return '1 unit × ₹${item.price.toStringAsFixed(2)}';
    }
  }

  static String _formatItemQty(MedicineBillModel item) {
    if (item.looseQty > 0 && item.strip > 0) {
      final stripText = item.strip == 1 ? '1 Strip' : '${item.strip} Strips';
      return '$stripText + ${item.looseQty} Tabs';
    } else if (item.looseQty > 0) {
      return '${item.looseQty} Tabs';
    } else if (item.strip > 0) {
      final stripLabel = item.medicineName.toLowerCase().contains('sachet')
          ? (item.strip == 1 ? '1 Sachet' : '${item.strip} Sachets')
          : (item.strip == 1 ? '1 Strip' : '${item.strip} Strips');
      return stripLabel;
    } else {
      return '1 Unit';
    }
  }

  static String _formatCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final day = now.day.toString().padLeft(2, '0');
    final month = months[now.month - 1];
    final year = now.year;
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final amPm = now.hour >= 12 ? 'PM' : 'AM';
    return '$day $month $year, $hour:$minute $amPm';
  }

  // ============================================
  // SHARE PDF
  // ============================================
  static Future<void> sharePdf({
    required String invId,
    required String customerName,
    required int customerType,
    required double total,
    required String paymentType,
    List<MedicineBillModel>? items,
    String? phoneNo,
    String? referredBy,
    String cashierName = 'Arindam Sengupta',
    String? dateTime,
    double? discount,
    double? tax,
    required String shopName,// = 'Sengupta Medical Hall',
    required String shopAddress,// = 'Kolkata, West Bengal',
    required String shopPhone,// = '+91 98300 45123',
    required String gstNumber,// = '19ABCDE1234F1Z5',
    required String dlNumber,// = 'WB-KOL-2023-145892',
    String? appDownloadUrl,
  }) async {
    // Generate PDF
    final Uint8List pdfData = await generatePdf(
      invId: invId,
      customerName: customerName,
      customerType: customerType,
      total: total,
      paymentType: paymentType,
      items: items,
      phoneNo: phoneNo,
      referredBy: referredBy,
      cashierName: cashierName,
      dateTime: dateTime,
      discount: discount,
      tax: tax,
      shopName: shopName,
      shopAddress: shopAddress,
      shopPhone: shopPhone,
      gstNumber: gstNumber,
      dlNumber: dlNumber,
      appDownloadUrl: appDownloadUrl,
    );

    // Temporary directory
    final directory = await getTemporaryDirectory();

    final cleanId = invId.replaceAll('#', '');

    // Create PDF file
    final file = File(
      '${directory.path}/Invoice_$cleanId.pdf',
    );

    // Save PDF
    await file.writeAsBytes(pdfData);

    // Share ONLY the PDF
    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
    );
  }

  // ============================================
  // SAVE AND OPEN PDF
  // ============================================
  static Future<File> saveAndOpenPdf({
    required String invId,
    required String customerName,
    required int customerType,
    required double total,
    required String paymentType,
    List<MedicineBillModel>? items,
    String? phoneNo,
    String? referredBy,
    String cashierName = 'Arindam Sengupta',
    String? dateTime,
    double? discount,
    double? tax,
    required String shopName,// = 'Sengupta Medical Hall',
    required String shopAddress,// = 'Kolkata, West Bengal',
    required String shopPhone,// = '+91 98300 45123',
    required String gstNumber,// = '19ABCDE1234F1Z5',
    required String dlNumber,// = 'WB-KOL-2023-145892',
    String? appDownloadUrl,
    bool openImmediately = true,
  }) async {
    final Uint8List pdfData = await generatePdf(
      invId: invId,
      customerName: customerName,
      customerType: customerType,
      total: total,
      paymentType: paymentType,
      items: items,
      phoneNo: phoneNo,
      referredBy: referredBy,
      cashierName: cashierName,
      dateTime: dateTime,
      discount: discount,
      tax: tax,
      shopName: shopName,
      shopAddress: shopAddress,
      shopPhone: shopPhone,
      gstNumber: gstNumber,
      dlNumber: dlNumber,
      appDownloadUrl: appDownloadUrl,
    );

    final cleanId = invId.replaceAll('#', '');
    final fileName = 'Invoice_$cleanId.pdf';

    Directory? targetDir;

    if (Platform.isAndroid) {
      // 1. Try public Downloads folder (/storage/emulated/0/Download)
      final publicDownloads = Directory('/storage/emulated/0/Download');
      if (await publicDownloads.exists()) {
        try {
          final testPath =
              '${publicDownloads.path}/.test_${DateTime.now().millisecondsSinceEpoch}';
          final testFile = File(testPath);
          await testFile.writeAsString('test');
          await testFile.delete();
          targetDir = publicDownloads;
        } catch (_) {
          // Public directory not directly writable on scoped storage
        }
      }

      // 2. Try external downloads directory (Android/data/.../files/Download)
      if (targetDir == null) {
        try {
          final extDirs = await getExternalStorageDirectories(
            type: StorageDirectory.downloads,
          );
          if (extDirs != null && extDirs.isNotEmpty) {
            targetDir = extDirs.first;
          }
        } catch (_) {}
      }

      // 3. Try external storage directory
      if (targetDir == null) {
        try {
          final extDir = await getExternalStorageDirectory();
          if (extDir != null) {
            targetDir = extDir;
          }
        } catch (_) {}
      }
    }

    // 4. Try standard downloads directory (Desktop / iOS / fallback)
    if (targetDir == null) {
      try {
        final dlDir = await getDownloadsDirectory();
        if (dlDir != null) {
          targetDir = dlDir;
        }
      } catch (_) {}
    }

    // 5. Fallback to application documents directory
    targetDir ??= await getApplicationDocumentsDirectory();

    final file = File('${targetDir.path}/$fileName');
    await file.writeAsBytes(pdfData);

    if (openImmediately) {
      await openPdf(file.path);
    }

    return file;
  }

  // ============================================
  // OPEN PDF
  // ============================================
  static Future<OpenResult> openPdf(String filePath) async {
    return await OpenFilex.open(filePath, type: 'application/pdf');
  }
}