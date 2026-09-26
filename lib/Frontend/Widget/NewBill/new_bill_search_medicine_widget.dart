import 'package:flutter/material.dart';
import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

class NewBillSearchMedicineWidget extends StatelessWidget {
  const NewBillSearchMedicineWidget({
    super.key,
    required this.medicineItem,
    this.onAddMedicine,
  });

  final MedicineOutputModel medicineItem;
  final VoidCallback? onAddMedicine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onAddMedicine,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicineItem.medicineNmae,
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  '${medicineItem.manufacturerName} · ₹${medicineItem.price} · ${medicineItem.stockValue} strips left',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            const Icon(Icons.add, color: AppColors.success),
          ],
        ),
      ),
    );
  }
}
