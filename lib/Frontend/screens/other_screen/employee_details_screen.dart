import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/model/Output/emp_invite.dart';
import 'package:pharmace/Frontend/Employees/model/employee_model.dart';
import 'package:pharmace/Frontend/Employees/model/employee_task.dart';
import 'package:pharmace/Frontend/screens/other_screen/employee_qr_screen.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Provider/employee_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';

class EmployeeDetailsScreen extends ConsumerStatefulWidget {
  const EmployeeDetailsScreen({super.key, required this.empId});

  final String empId;

  @override
  ConsumerState<EmployeeDetailsScreen> createState() =>
      _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends ConsumerState<EmployeeDetailsScreen> {
  final List<EmployeeTask> _tasks = [];

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getRoleColor(RoleEmp role) {
    switch (role) {
      case RoleEmp.manager:
        return AppColors.managerForeground;
      case RoleEmp.pharmacist:
        return AppColors.pharmacistForeground;
      case RoleEmp.cashier:
        return AppColors.cashierForeground;
      case RoleEmp.staff:
        return AppColors.staffForeground;
    }
  }

  Color _getRoleBgColor(RoleEmp role, bool isDark) {
    if (isDark) {
      return _getRoleColor(role).withValues(alpha: 0.18);
    }
    switch (role) {
      case RoleEmp.manager:
        return AppColors.managerBackground;
      case RoleEmp.pharmacist:
        return AppColors.pharmacistBackground;
      case RoleEmp.cashier:
        return AppColors.cashierBackground;
      case RoleEmp.staff:
        return AppColors.staffBackground;
    }
  }

  String _getRoleName(RoleEmp role) {
    switch (role) {
      case RoleEmp.manager:
        return 'Manager';
      case RoleEmp.pharmacist:
        return 'Pharmacist';
      case RoleEmp.cashier:
        return 'Cashier';
      case RoleEmp.staff:
        return 'Staff';
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'EM';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    EmployeeModel currentEmployee = ref
        .watch(employeeProvider)
        .allEmployee
        .firstWhere((item) => item.id == widget.empId);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final roleColor = _getRoleColor(currentEmployee.role);
    final roleBgColor = _getRoleBgColor(currentEmployee.role, isDark);

    return Scaffold(
      appBar: AppBar(title: const Text('Employee Details'), centerTitle: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroCard(
                theme,
                isDark,
                roleColor,
                roleBgColor,
                widget.empId,
              ),
              const SizedBox(height: 14),
              _buildStatusToggleCard(theme, isDark, widget.empId),
              const SizedBox(height: 14),
              _buildInvitedCodeCard(theme, isDark, widget.empId),
              const SizedBox(height: 14),
              _buildQuickActions(theme, isDark, widget.empId),
              const SizedBox(height: 20),
              _buildTasksSection(theme, isDark, widget.empId),
              const SizedBox(height: 20),
              Text('Performance Overview', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              _buildPerformanceMetrics(theme, isDark, widget.empId),
              const SizedBox(height: 22),
              Text('Contact & Employment', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              _buildInformationCard(theme, isDark, widget.empId),
              const SizedBox(height: 22),
              Text('Role & System Access', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              _buildPermissionsCard(theme, isDark, roleColor, widget.empId),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Activity', style: theme.textTheme.titleLarge),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Today',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildActivityFeed(theme, isDark),
              const SizedBox(height: 24),
              _buildBottomActionButtons(theme, isDark, widget.empId),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusToggleCard(ThemeData theme, bool isDark, String empId) {
    EmployeeModel currentEmployee = ref.watch(
      employeeProvider.select(
        (select) => select.allEmployee.firstWhere((item) => item.id == empId),
      ),
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: currentEmployee.isActive
              ? AppColors.success.withValues(alpha: isDark ? 0.4 : 0.3)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: currentEmployee.isActive
                      ? AppColors.success.withValues(alpha: isDark ? 0.18 : 0.1)
                      : AppColors.disabled.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  currentEmployee.isActive
                      ? Icons.verified_user_rounded
                      : Icons.pause_circle_outline_rounded,
                  color: currentEmployee.isActive
                      ? AppColors.success
                      : AppColors.disabled,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          currentEmployee.isActive
                              ? 'Active Employee'
                              : 'Inactive Employee',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: currentEmployee.isActive
                                ? (isDark
                                      ? AppColors.successDark
                                      : AppColors.success)
                                : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: currentEmployee.isActive
                                ? AppColors.success.withValues(alpha: 0.12)
                                : AppColors.disabled.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            currentEmployee.isActive ? 'ON DUTY' : 'SUSPENDED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: currentEmployee.isActive
                                  ? AppColors.success
                                  : (isDark
                                        ? AppColors.darkTextTertiary
                                        : AppColors.lightTextTertiary),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      currentEmployee.isActive
                          ? 'Employee is authorized for billing & operations'
                          : 'Login access and terminal operations suspended',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(width: 8),
              // Switch.adaptive(
              //   value: currentEmployee.isActive,
              //   activeTrackColor: AppColors.success,
              //   onChanged: (bool value) {
              //     ref
              //         .read(employeeProvider.notifier)
              //         .updateEmployeeStatus(
              //           employeeId: currentEmployee.id,
              //           isActive: !currentEmployee.isActive,
              //         );
              //   },
              // ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (!currentEmployee.isActive) {
                      ref
                          .read(employeeProvider.notifier)
                          .updateEmployeeStatus(
                            employeeId: currentEmployee.id,
                            isActive: !currentEmployee.isActive,
                          );
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: currentEmployee.isActive
                          ? AppColors.success.withValues(
                              alpha: isDark ? 0.2 : 0.12,
                            )
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: currentEmployee.isActive
                            ? AppColors.success
                            : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 15,
                          color: currentEmployee.isActive
                              ? AppColors.success
                              : (isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors.lightTextTertiary),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Mark Active',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: currentEmployee.isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: currentEmployee.isActive
                                ? AppColors.success
                                : (isDark
                                      ? AppColors.darkTextTertiary
                                      : AppColors.lightTextTertiary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (currentEmployee.isActive) {
                      ref
                          .read(employeeProvider.notifier)
                          .updateEmployeeStatus(
                            employeeId: currentEmployee.id,
                            isActive: !currentEmployee.isActive,
                          );
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: !currentEmployee.isActive
                          ? AppColors.error.withValues(
                              alpha: isDark ? 0.2 : 0.1,
                            )
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: !currentEmployee.isActive
                            ? AppColors.error
                            : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pause_circle_rounded,
                          size: 15,
                          color: !currentEmployee.isActive
                              ? AppColors.error
                              : (isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors.lightTextTertiary),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Mark Inactive',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: !currentEmployee.isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: !currentEmployee.isActive
                                ? AppColors.error
                                : (isDark
                                      ? AppColors.darkTextTertiary
                                      : AppColors.lightTextTertiary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvitedCodeCard(ThemeData theme, bool isDark, String empId) {
    EmployeeModel currentEmployee = ref.watch(
      employeeProvider.select(
        (items) => items.allEmployee.firstWhere((item) => item.id == empId),
      ),
    );
    const inviteCode = 'PHR-82X9-K9';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.vpn_key_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Invitation Code',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Active Pass',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Share this code or QR pass with ${currentEmployee.name} to log in to the terminal.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    inviteCode,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy Code',
                  onPressed: () =>
                      _copyToClipboard(inviteCode, 'Invitation code'),
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  color: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 4),
                ElevatedButton.icon(
                  onPressed: () {
                    final shop = ref.read(selectedShopProvider);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EmployeeQrScreen(
                          EmpInvite(
                            inviteCode,
                            shop!.id,
                            empEmail: currentEmployee.email,
                            empRole: currentEmployee.role,
                            empName: currentEmployee.name,
                            ownerId: shop.ownerId!
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.qr_code_2_rounded, size: 16),
                  label: const Text('QR Pass'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 36),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(
    ThemeData theme,
    bool isDark,
    Color roleColor,
    Color roleBgColor,
    String empId,
  ) {
    EmployeeModel currentEmployee = ref.watch(
      employeeProvider.select(
        (select) => select.allEmployee.firstWhere((item) => item.id == empId),
      ),
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with dual ring styling & role glow
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          roleColor.withValues(alpha: 0.25),
                          roleColor.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: roleColor.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(currentEmployee.name),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: roleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: currentEmployee.isActive
                          ? AppColors.success
                          : AppColors.disabled,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.cardColor, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Name, Role & Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            currentEmployee.name,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Role Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: roleBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getRoleIcon(currentEmployee.role),
                                size: 12,
                                color: roleColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _getRoleName(currentEmployee.role),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: roleColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Active / Inactive Status Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: currentEmployee.isActive
                                ? AppColors.success.withValues(alpha: 0.12)
                                : AppColors.disabled.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentEmployee.isActive
                                      ? AppColors.success
                                      : AppColors.disabled,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                currentEmployee.isActive
                                    ? 'On Duty'
                                    : 'Inactive',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: currentEmployee.isActive
                                      ? AppColors.success
                                      : (isDark
                                            ? AppColors.darkTextTertiary
                                            : AppColors.lightTextTertiary),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ID: EMP-${currentEmployee.id}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Sengupta Medical Hall',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    currentEmployee.joinDate,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme, bool isDark, String empId) {
    EmployeeModel currentEmployee = ref.watch(
      employeeProvider.select(
        (items) => items.allEmployee.firstWhere((item) => item.id == empId),
      ),
    );
    return Row(
      children: [
        // Call Action
        Expanded(
          child: _quickActionButton(
            icon: Icons.phone_outlined,
            label: 'Call',
            theme: theme,
            isDark: isDark,
            onTap: () {
              _copyToClipboard(currentEmployee.phone, 'Phone number');
            },
          ),
        ),
        const SizedBox(width: 10),

        // Email Action
        Expanded(
          child: _quickActionButton(
            icon: Icons.email_outlined,
            label: 'Email',
            theme: theme,
            isDark: isDark,
            onTap: () {
              _copyToClipboard(currentEmployee.email, 'Email address');
            },
          ),
        ),
        const SizedBox(width: 10),

        // Give Task Action
        Expanded(
          child: _quickActionButton(
            icon: Icons.add_task_rounded,
            label: 'Give Task',
            theme: theme,
            isDark: isDark,
            highlight: true,
            onTap: () => _showGiveTaskBottomSheet(
              context,
              theme,
              isDark,
              empId,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTasksSection(ThemeData theme, bool isDark, String empId) {
    // EmployeeModel currentEmployee = ref.watch(
    //   employeeProvider.select(
    //     (items) => items.allEmployee.firstWhere((item) => item.id == empId),
    //   ),
    // );
    final pendingCount = _tasks.where((t) => !t.isCompleted).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Assigned Tasks',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: pendingCount > 0
                          ? AppColors.warning.withValues(alpha: 0.12)
                          : AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$pendingCount Pending',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: pendingCount > 0
                            ? AppColors.warningDark
                            : AppColors.successDark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.task_alt_rounded,
                      size: 36,
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'No tasks assigned currently',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tasks.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                indent: 40,
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final priorityColor = _getPriorityColor(task.priority);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            task.isCompleted = !task.isCompleted;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                task.isCompleted
                                    ? 'Task marked as completed'
                                    : 'Task marked as pending',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: task.isCompleted
                                ? AppColors.success
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: task.isCompleted
                                  ? AppColors.success
                                  : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder),
                              width: 1.5,
                            ),
                          ),
                          child: task.isCompleted
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? (isDark
                                          ? AppColors.darkTextTertiary
                                          : AppColors.lightTextTertiary)
                                    : null,
                              ),
                            ),
                            if (task.description.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                task.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ],
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 13,
                                  color: isDark
                                      ? AppColors.darkTextTertiary
                                      : AppColors.lightTextTertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.dueTime,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextTertiary
                                        : AppColors.lightTextTertiary,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: priorityColor.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _getPriorityLabel(task.priority),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: priorityColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 16),
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          setState(() {
                            _tasks.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task removed'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required ThemeData theme,
    required bool isDark,
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    final bgColor = highlight
        ? AppColors.primary.withValues(alpha: isDark ? 0.18 : 0.1)
        : theme.cardColor;

    final fgColor = highlight ? AppColors.primary : theme.colorScheme.onSurface;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: highlight
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: fgColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics(ThemeData theme, bool isDark, String empId) {
    EmployeeModel currentEmployee = ref.watch(
      employeeProvider.select(
        (items) => items.allEmployee.firstWhere((item) => item.id == empId),
      ),
    );
    return Row(
      children: [
        // Revenue Metric
        Expanded(
          child: _metricCard(
            title: 'Revenue',
            value: '₹${currentEmployee.revenueValue}',
            badge: '+12.5%',
            badgeColor: AppColors.success,
            icon: Icons.trending_up_rounded,
            theme: theme,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),

        // Sales Metric
        Expanded(
          child: _metricCard(
            title: 'Sales Orders',
            value: '${currentEmployee.sales}',
            subtitle: 'transactions',
            icon: Icons.receipt_long_outlined,
            theme: theme,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),

        // Rating Metric
        Expanded(
          child: _metricCard(
            title: 'Rating',
            value: '${currentEmployee.rating}',
            badge: 'Top',
            badgeColor: AppColors.gold,
            icon: Icons.star_rounded,
            theme: theme,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    String? subtitle,
    String? badge,
    Color? badgeColor,
    required IconData icon,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 16,
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
              ),
              if (badge != null && badgeColor != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle ?? title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.lightTextTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard(ThemeData theme, bool isDark, String empId) {
    EmployeeModel currentEmployee = ref.watch(
      employeeProvider.select(
        (items) => items.allEmployee.firstWhere((item) => item.id == empId),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: currentEmployee.phone,
            actionIcon: Icons.copy_rounded,
            onAction: () =>
                _copyToClipboard(currentEmployee.phone, 'Phone number'),
            theme: theme,
            isDark: isDark,
          ),
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email Address',
            value: currentEmployee.email,
            actionIcon: Icons.copy_rounded,
            onAction: () =>
                _copyToClipboard(currentEmployee.email, 'Email address'),
            theme: theme,
            isDark: isDark,
          ),
          _buildInfoRow(
            icon: Icons.schedule_outlined,
            label: 'Current Shift',
            value: 'Morning (09:00 AM - 05:30 PM)',
            theme: theme,
            isDark: isDark,
          ),
          _buildInfoRow(
            icon: Icons.point_of_sale_outlined,
            label: 'Assigned Counter',
            value: 'Counter #01 (Front Desk)',
            theme: theme,
            isDark: isDark,
          ),
          _buildInfoRow(
            icon: Icons.event_available_outlined,
            label: 'Employment Date',
            value: currentEmployee.joinDate,
            showDivider: false,
            theme: theme,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    IconData? actionIcon,
    VoidCallback? onAction,
    bool showDivider = true,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (actionIcon != null && onAction != null)
                IconButton(
                  onPressed: onAction,
                  icon: Icon(actionIcon, size: 18),
                  color: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
      ],
    );
  }

  Widget _buildPermissionsCard(
    ThemeData theme,
    bool isDark,
    Color roleColor,
    String empId
  ) {
    EmployeeModel currentEmployee = ref.watch(
      employeeProvider.select(
        (items) => items.allEmployee.firstWhere((item) => item.id == empId),
      ),
    );
    final permissions = _getPermissionsForRole(currentEmployee.role);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security_rounded, size: 18, color: roleColor),
              const SizedBox(width: 8),
              Text(
                'Access granted based on ${_getRoleName(currentEmployee.role)} role',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: permissions.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: item.granted
                      ? AppColors.primary.withValues(
                          alpha: isDark ? 0.12 : 0.07,
                        )
                      : (isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.lightSurfaceVariant),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.granted
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.granted
                          ? Icons.check_circle_rounded
                          : Icons.cancel_outlined,
                      size: 14,
                      color: item.granted
                          ? AppColors.primary
                          : (isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: item.granted
                            ? theme.colorScheme.onSurface
                            : (isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary),
                        fontWeight: item.granted
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeed(ThemeData theme, bool isDark) {
    final activities = [
      _ActivityItem(
        title: 'Billed Invoice #INV-1092',
        description: 'Paracetamol 650mg, Amoxicillin 500mg · ₹840',
        time: '14m ago',
        icon: Icons.receipt_rounded,
        color: AppColors.success,
      ),
      _ActivityItem(
        title: 'Stock Check Completed',
        description: 'Verified 42 items in Aisle B-2',
        time: '1h ago',
        icon: Icons.inventory_2_outlined,
        color: AppColors.primary,
      ),
      _ActivityItem(
        title: 'Clocked In',
        description: 'Morning Shift started at Front Counter',
        time: '08:58 AM',
        icon: Icons.login_rounded,
        color: AppColors.gold,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          indent: 56,
          endIndent: 16,
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
        itemBuilder: (context, index) {
          final item = activities[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(item.icon, size: 18, color: item.color),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.time,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomActionButtons(
    ThemeData theme,
    bool isDark,
    String empId,
  ) {
    EmployeeModel currentEmployee = ref.watch(
      employeeProvider.select(
        (items) => items.allEmployee.firstWhere((item) => item.id == empId),
      ),
    );
    return Row(
      children: [
        // Edit Profile Button
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => _showEditEmployeeBottomSheet(
                context,
                theme,
                isDark,
                currentEmployee,
              ),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Details'),
              style: OutlinedButton.styleFrom(
                backgroundColor: theme.cardColor,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Give Task Button
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _showGiveTaskBottomSheet(
                context,
                theme,
                isDark,
                empId,
              ),
              icon: const Icon(Icons.add_task_rounded, size: 18),
              label: const Text('Give Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showGiveTaskBottomSheet(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String empId,
  ) {
    EmployeeModel currentEmployee = ref.watch(
      employeeProvider.select(
        (items) => items.allEmployee.firstWhere((item) => item.id == empId),
      ),
    );
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;
    String selectedDue = 'Today · End of Shift';

    final templates = [
      {
        'title': 'Audit Rack Expiry',
        'desc': 'Check batch expiry dates for syrups and liquids in Rack A & B',
      },
      {
        'title': 'Restock Shelves',
        'desc': 'Refill fast-moving OTC drugs and strips at front counter',
      },
      {
        'title': 'Bill Reconciliation',
        'desc': 'Verify POS transactions and total cash in register drawer',
      },
      {
        'title': 'Clean Dispensary',
        'desc': 'Sanitize medicine dispensing counter and arrange stock',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.lightDivider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.add_task_rounded,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Give Task',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Assign to ${currentEmployee.name}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Quick Templates', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: templates.map((t) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ActionChip(
                              label: Text(t['title']!),
                              onPressed: () {
                                setSheetState(() {
                                  titleController.text = t['title']!;
                                  descriptionController.text = t['desc']!;
                                });
                              },
                              backgroundColor: isDark
                                  ? AppColors.darkSurfaceVariant
                                  : AppColors.lightSurfaceVariant,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Task Title', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Verify incoming shipment',
                        prefixIcon: Icon(Icons.edit_note_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Instructions / Notes',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Optional instructions for employee...',
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('Priority', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: TaskPriority.values.map((priority) {
                        final isSelected = selectedPriority == priority;
                        final pColor = _getPriorityColor(priority);
                        return ChoiceChip(
                          label: Text(_getPriorityLabel(priority)),
                          selected: isSelected,
                          selectedColor: pColor.withValues(alpha: 0.18),
                          side: BorderSide(
                            color: isSelected ? pColor : Colors.transparent,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? pColor
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setSheetState(() {
                                selectedPriority = priority;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text('Due Date / Time', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          [
                            'Today · End of Shift',
                            'Within 2 Hours',
                            'Tomorrow Morning',
                          ].map((due) {
                            final isSelected = selectedDue == due;
                            return ChoiceChip(
                              label: Text(due),
                              selected: isSelected,
                              selectedColor: AppColors.primary.withValues(
                                alpha: 0.18,
                              ),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : theme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setSheetState(() {
                                    selectedDue = due;
                                  });
                                }
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final title = titleController.text.trim();
                          if (title.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a task title'),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            _tasks.insert(
                              0,
                              EmployeeTask(
                                id: DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                title: title,
                                description: descriptionController.text.trim(),
                                dueTime: selectedDue,
                                priority: selectedPriority,
                              ),
                            );
                          });
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Task assigned to ${currentEmployee.name}',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_task_rounded),
                        label: const Text('Assign Task'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditEmployeeBottomSheet(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    EmployeeModel currentEmployee,
  ) {
    final nameController = TextEditingController(text: currentEmployee.name);
    final phoneController = TextEditingController(text: currentEmployee.phone);
    final emailController = TextEditingController(text: currentEmployee.email);
    RoleEmp selectedRole = currentEmployee.role;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Employee Profile',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Full Name', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Phone Number', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 6),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Email Address', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 6),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Assign Role', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: RoleEmp.values.map((role) {
                      final isSelected = selectedRole == role;
                      return ChoiceChip(
                        label: Text(_getRoleName(role)),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setSheetState(() {
                              selectedRole = role;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        currentEmployee = EmployeeModel(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          joinDate: currentEmployee.joinDate,
                          revenueValue: currentEmployee.revenueValue,
                          sales: currentEmployee.sales,
                          rating: currentEmployee.rating,
                          role: selectedRole,
                          id: currentEmployee.id,
                        );
                        ref
                            .watch(employeeProvider.notifier)
                            .updateEmployee(currentEmployee);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.success;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.high:
        return AppColors.error;
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low Priority';
      case TaskPriority.medium:
        return 'Medium Priority';
      case TaskPriority.high:
        return 'Urgent';
    }
  }

  IconData _getRoleIcon(RoleEmp role) {
    switch (role) {
      case RoleEmp.manager:
        return Icons.admin_panel_settings_outlined;
      case RoleEmp.pharmacist:
        return Icons.medical_services_outlined;
      case RoleEmp.cashier:
        return Icons.point_of_sale_outlined;
      case RoleEmp.staff:
        return Icons.badge_outlined;
    }
  }

  List<_PermissionItem> _getPermissionsForRole(RoleEmp role) {
    switch (role) {
      case RoleEmp.manager:
        return [
          _PermissionItem('Billing & Checkout', true),
          _PermissionItem('Inventory Management', true),
          _PermissionItem('Price Override & Discounts', true),
          _PermissionItem('Staff Management', true),
          _PermissionItem('Financial Reports', true),
          _PermissionItem('Refund Approvals', true),
        ];
      case RoleEmp.pharmacist:
        return [
          _PermissionItem('Billing & Checkout', true),
          _PermissionItem('Prescription Validation', true),
          _PermissionItem('Inventory Adjustments', true),
          _PermissionItem('Expiry Returns', true),
          _PermissionItem('Price Override & Discounts', false),
          _PermissionItem('Staff Management', false),
        ];
      case RoleEmp.cashier:
        return [
          _PermissionItem('Billing & Checkout', true),
          _PermissionItem('Cash Drawer Access', true),
          _PermissionItem('View Stock Levels', true),
          _PermissionItem('Inventory Adjustments', false),
          _PermissionItem('Discounts Approval', false),
          _PermissionItem('Financial Reports', false),
        ];
      case RoleEmp.staff:
        return [
          _PermissionItem('View Inventory', true),
          _PermissionItem('Stock Inward Assistance', true),
          _PermissionItem('Billing & Checkout', false),
          _PermissionItem('Price Override', false),
          _PermissionItem('Reports Access', false),
          _PermissionItem('Settings Access', false),
        ];
    }
  }
}

class _PermissionItem {
  final String title;
  final bool granted;

  _PermissionItem(this.title, this.granted);
}

class _ActivityItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;

  _ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });
}
