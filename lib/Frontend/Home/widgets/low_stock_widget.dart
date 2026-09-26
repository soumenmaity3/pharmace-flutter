import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/Home/model/low_stock_list_model.dart';

class LowStockWidget extends StatelessWidget {
  const LowStockWidget({super.key, required this.lowStockListItem, this.onTap});

  final LowStockListModel lowStockListItem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lowStockListItem.medName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Only ${lowStockListItem.leftItem} units left',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            // const SizedBox(width: 12),

            Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.45),
            ),
          ],
        ),
      ),
    );
  }
}
