import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';
import 'package:pharmace/Frontend/Inventory/model/medicine_model.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
// import 'package:pharmace/theme/app_theme_extension.dart';

class MedicineListWidget extends StatelessWidget {
  const MedicineListWidget({super.key, required this.medicineItem, this.onTap});
  final MedicineOutputModel medicineItem;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // final appColors = Theme.of(context).extension<AppThemeExtension>()!;

    final Color statusColor;

    if (medicineItem.stockStatus == StockStatus.inStock) {
      statusColor = AppColors.success;
    } else if (medicineItem.stockStatus == StockStatus.lowStock) {
      statusColor = AppColors.goldDark;
    } else {
      statusColor = AppColors.errorDark;
    }

    String stockStatusText;

    switch (medicineItem.stockStatus) {
      case StockStatus.inStock:
        stockStatusText = 'In stock';
        break;
      case StockStatus.lowStock:
        stockStatusText = 'Low stock';
        break;
      case StockStatus.expiring:
        stockStatusText = 'Expiring Soon';
        break;
      default:
        stockStatusText = 'Out of stock';
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Medicine icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/inventory_outline.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        statusColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),

                if (medicineItem.isLooseAv)
                  Positioned(
                    right: -7,
                    bottom: -7,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade800,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.scissors,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(width: 16),

            // Medicine information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicineItem.medicineNmae,
                    style: theme.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4),

                  Text(
                    '${medicineItem.manufacturerName} · '
                    '${medicineItem.stockValue} in stock',
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // Price + stock status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${medicineItem.price}',
                  style: theme.textTheme.titleMedium,
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '•',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 18,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      stockStatusText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _svgNavIcon(String path, Color color) {
  //   return SvgPicture.asset(path, width: 24, height: 24, color: color);
  // }
}
