import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/Sales/model/inv_model.dart';
import 'package:pharmace/Frontend/Sales/model/medicine_bill_model.dart';
import 'package:pharmace/Frontend/Widget/NewBill/medicine_bill_confirm_widget.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

class BillPdfWidget extends StatelessWidget {
  const BillPdfWidget({
    super.key,
    required this.invId,
    required this.customerName,
    required this.customerType,
    required this.total,
    required this.paymentType,
    this.phone,
    required this.medicineItems,
  });

  final String invId;
  final String customerName;
  final int customerType;
  final double total;
  final PaymentType paymentType;
  final String? phone;
  final List<MedicineBillModel> medicineItems;

  Widget _infoRow({
    required String title,
    required String value,
    bool boldValue = false,
    required ThemeData theme,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.textTheme.bodyLarge)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(16),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sengupta Medical Hall',
                style: theme.textTheme.headlineMedium,
              ),

              SizedBox(height: 6),

              Text(
                'Kolkata, West Bengal',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.darkTextTertiary,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 6),

              Text(
                '+91 98300 45123 \n GST 19ABCDE1234F1Z5',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.darkTextTertiary,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),

              Divider(color: AppColors.darkDivider),
              _infoRow(
                title: 'Invoice',
                value: '#$invId',
                boldValue: true,
                theme: theme,
              ),

              _infoRow(
                title: 'Date & time',
                value: 'Today, 3:32 pm',
                theme: theme,
              ),

              _infoRow(
                title: 'Cashier',
                value: 'Arindam Sengupta',
                theme: theme,
              ),

              Divider(color: AppColors.darkDivider),
              _infoRow(title: 'Customer', value: customerName, theme: theme),

              _infoRow(
                title: 'Customer type',
                value: customerType == 0 ? 'Walk-in Customer' : 'Online',
                theme: theme,
              ),

              Divider(color: AppColors.darkDivider),
              Column(
                children: List.generate(
                  medicineItems.length,
                  (idx) => MedicineBillConfirmWidget(
                    medicineItem: medicineItems[idx],
                  ),
                ),
              ),
              Divider(color: AppColors.darkDivider),
              _infoRow(title: 'Subtotal', value: '₹$total', theme: theme),

              _infoRow(
                title: 'Total',
                value: '₹$total',
                boldValue: true,
                theme: theme,
              ),

              Divider(color: AppColors.darkDivider),
              _infoRow(
                title: 'Payment method',
                value: paymentType.name,
                theme: theme,
              ),

              SizedBox(height: 20),

              Text(
                'Thank you for shopping with us!',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.darkTextTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
