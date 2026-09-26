import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Frontend/Employees/model/employee_model.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Provider/employee_provider.dart';
import 'package:pharmace/Provider/owner_provider.dart';

class EmployeeListWiddget extends ConsumerWidget {
  const EmployeeListWiddget({super.key, required this.employeeId, this.onTap});

  final String employeeId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final owner = ref.watch(ownerProvider).value;
    EmployeeModel employeeItem = ref
        .watch(employeeProvider)
        .allEmployee
        .firstWhere((item) => item.id == employeeId);

    final bool isOwner = owner != null &&
        (owner.email.trim().toLowerCase() == employeeItem.email.trim().toLowerCase() ||
         owner.name.trim().toLowerCase() == employeeItem.name.trim().toLowerCase());

    final String role;
    final Color roleColor;

    if (employeeItem.role == Role.pharmacist) {
      role = 'Pharmacist';
      roleColor = AppColors.pharmacistForeground;
    } else if (employeeItem.role == Role.manager) {
      role = 'Manager';
      roleColor = AppColors.managerForeground;
    } else if (employeeItem.role == Role.cashier) {
      role = 'Cashier';
      roleColor = AppColors.cashierForeground;
    } else {
      role = 'Staff';
      roleColor = AppColors.staffForeground;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOwner
                        ? AppColors.primary.withValues(alpha: 0.18)
                        : AppColors.successDark.withValues(alpha: 0.2),
                    border: isOwner
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      getInitials(employeeItem.name),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isOwner ? AppColors.primary : null,
                        fontWeight: isOwner ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                ),
                if (isOwner)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.cardColor,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.shield,
                        size: 9,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // Employee information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          employeeItem.name,
                          style: theme.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isOwner) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Owner',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    employeeItem.email,
                    style: theme.textTheme.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Role
            Text(
              role,
              style: theme.textTheme.bodyMedium?.copyWith(color: roleColor),
            ),
          ],
        ),
      ),
    );
  }

  String getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return '';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
