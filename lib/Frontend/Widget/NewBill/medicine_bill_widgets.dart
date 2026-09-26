import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/Sales/model/medicine_bill_model.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

class MedicineBillWidgets extends StatefulWidget {
  const MedicineBillWidgets({
    super.key,
    required this.medicineItem,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  final MedicineBillModel medicineItem;
  final VoidCallback onDelete;
  final void Function(int stripQty, int looseQty, double totalPrice)
  onQuantityChanged;
  @override
  State<MedicineBillWidgets> createState() => _MedicineBillWidgetsState();
}

class _MedicineBillWidgetsState extends State<MedicineBillWidgets> {
  int stripCount = 1;
  int looseCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    final loose = widget.medicineItem.loose;

    totalPrice = widget.medicineItem.price * stripCount;

    if (widget.medicineItem.isLooseAv && loose != null && loose > 0) {
      totalPrice += (widget.medicineItem.price / loose) * looseCount;
    }

    // widget.onTotalPriceChanged(totalPrice);
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.medicineItem.medicineName,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        '₹${widget.medicineItem.price}/strip'
                        '${(!widget.medicineItem.isLooseAv || widget.medicineItem.loose == null || widget.medicineItem.loose == 0) ? '' : ' · ₹${(widget.medicineItem.price / widget.medicineItem.loose!).toStringAsFixed(2)}/tab'}',
                      ),
                    ],
                  ),
                ),

                // Delete button
                IconButton(
                  onPressed: widget.onDelete,
                  icon: Icon(Icons.delete_outline, color: AppColors.warning),
                  tooltip: 'Remove medicine',
                ),

                SizedBox(width: 4),

                Text(
                  '₹${totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _stripCartItem(title: 'Strip', theme: theme),
                SizedBox(width: 8),
                if (widget.medicineItem.isLooseAv &&
                    widget.medicineItem.loose! > 0)
                  _looseCartItem(title: 'Loose', theme: theme),
              ],
            ),
            SizedBox(height: 8),
            Text(
              widget.medicineItem.isLooseAv &&
                      widget.medicineItem.loose != null &&
                      widget.medicineItem.loose! > 0
                  ? '${widget.medicineItem.loose} tabs/strip · '
                        '$looseCount/${widget.medicineItem.loose} loose used'
                  : '',
            ),
          ],
        ),
      ),
    );
  }

  void _sendUpdate() {
    double totalPrice = widget.medicineItem.price * stripCount;
    final loose = widget.medicineItem.loose;

    if (widget.medicineItem.isLooseAv && loose != null && loose > 0) {
      totalPrice += (widget.medicineItem.price / loose) * looseCount;
    }

    widget.onQuantityChanged(stripCount, looseCount, totalPrice);
  }

  Widget _stripCartItem({required String title, required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: theme.focusColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),

          const SizedBox(width: 8),

          InkWell(
            onTap: () {
              if (stripCount > 0) {
                setState(() {
                  stripCount--;
                });

                _sendUpdate();
              }

              if (stripCount == 0 && looseCount == 0) {
                widget.onDelete();
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.lightSurfaceVariant),
              ),
              child: const Icon(Icons.remove, size: 16, color: AppColors.black),
            ),
          ),

          const SizedBox(width: 8),

          Text('$stripCount', style: theme.textTheme.titleLarge),

          const SizedBox(width: 8),

          InkWell(
            onTap: () {
              setState(() {
                stripCount++;
              });

              _sendUpdate();
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFDDF5EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 18, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _looseCartItem({required String title, required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: theme.focusColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),

          const SizedBox(width: 8),

          InkWell(
            onTap: () {
              if (looseCount > 0) {
                setState(() {
                  looseCount--;
                });
                _sendUpdate();
              }

              if (stripCount == 0 && looseCount == 0) {
                widget.onDelete();
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.lightSurfaceVariant),
              ),
              child: const Icon(Icons.remove, size: 16),
            ),
          ),

          const SizedBox(width: 8),
          Text('$looseCount', style: theme.textTheme.titleLarge),

          const SizedBox(width: 8),

          InkWell(
            onTap: () {
              setState(() {
                looseCount++;
                if (looseCount >= widget.medicineItem.loose!) {
                  stripCount++;
                  looseCount -= widget.medicineItem.loose!;
                }
              });
              _sendUpdate();
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFDDF5EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 18, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
