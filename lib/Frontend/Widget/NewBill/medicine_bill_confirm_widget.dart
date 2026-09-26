import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/Sales/model/medicine_bill_model.dart';

class MedicineBillConfirmWidget extends StatelessWidget {
  const MedicineBillConfirmWidget({super.key, required this.medicineItem});

  final MedicineBillModel medicineItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            medicineItem.medicineName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
        ),

        const SizedBox(height: 6),

        Row(
          children: [
            Expanded(
              child: Text(
                [
                  if (medicineItem.strip > 0) '${medicineItem.strip} strip',

                  if (medicineItem.isLooseAv && medicineItem.looseQty > 0)
                    '${medicineItem.looseQty} loose',
                ].join(' + '),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w200,
                  fontSize: 17,
                ),
              ),
            ),

            Text(
              '₹${medicineItem.totalPrice.toStringAsFixed(2)}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
