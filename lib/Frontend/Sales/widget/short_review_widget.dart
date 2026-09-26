import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/Sales/model/short_review_model.dart';

class ShortReviewWidget extends StatelessWidget {
  const ShortReviewWidget({super.key, required this.shortReviewItem});

  final ShortReviewModel shortReviewItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 74,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              shortReviewItem.value,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              shortReviewItem.title,
              style: theme.textTheme.labelMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
