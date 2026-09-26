import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/Home/model/quick_action_model.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

class QuickActionWidget extends StatelessWidget {
  const QuickActionWidget({
    super.key,
    required this.quickActionItem,
    this.onTap,
  });
  final QuickActionModel quickActionItem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: quickActionItem.icon),
          ),
          SizedBox(height: 5),
          Text(
            quickActionItem.title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
