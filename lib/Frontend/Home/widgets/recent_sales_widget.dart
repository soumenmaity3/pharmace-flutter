import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/Home/model/recent_sales_model.dart';

class RecentSalesWidget extends StatelessWidget {
  const RecentSalesWidget({
    super.key,
    required this.recentSalesItem,
    this.onTap,
  });
  final RecentSalesModel recentSalesItem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${recentSalesItem.invNo}',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  'Today, ${recentSalesItem.time} • ${recentSalesItem.name}',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            Text('₹${recentSalesItem.value}',style: theme.textTheme.titleLarge,),
          ],
        ),
      ),
    );
  }
}
