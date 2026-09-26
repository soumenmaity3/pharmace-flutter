import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/Home/model/expiring_soon_model.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

class ExpiringSoonWidget extends StatelessWidget {
  const ExpiringSoonWidget({
    super.key,
    required this.expiringSoonItem,
    this.onTap,
  });
  final ExpiringSoonModel expiringSoonItem;
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
                    expiringSoonItem.medicineName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Expires ${expiringSoonItem.expDate}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1D6), // light gold
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    size: 14,
                    color: AppColors.gold,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Expiring Soon",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
