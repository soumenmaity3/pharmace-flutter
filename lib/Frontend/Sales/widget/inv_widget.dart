import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/Sales/model/inv_model.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

class InvWidget extends StatelessWidget {
  const InvWidget({super.key, required this.invItem, this.onTap});
  final InvModel invItem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('# ${invItem.invNo}', style: theme.textTheme.titleLarge),
                Text(
                  '${invItem.customerName} · Today, ${invItem.date}',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('₹${invItem.value}', style: theme.textTheme.titleLarge),
                Text(
                  invItem.paymentType.name,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: invItem.paymentType == PaymentType.refunded
                        ? AppColors.errorDark
                        : invItem.paymentType == PaymentType.due
                        ? AppColors.gold
                        : AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
