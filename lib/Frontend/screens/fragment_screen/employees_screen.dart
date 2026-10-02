import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/model/Input/shop_owner_model.dart';
import 'package:pharmace/Frontend/Employees/model/employee_model.dart';
import 'package:pharmace/Frontend/Employees/widget/employee_list_widdget.dart';
import 'package:pharmace/Frontend/Sales/widget/sales_search_bar.dart';
import 'package:pharmace/Frontend/screens/other_screen/add_employees_screen.dart';
import 'package:pharmace/Frontend/screens/other_screen/employee_details_screen.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Provider/employee_provider.dart';
import 'package:pharmace/Provider/owner_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  // ApiService apiService = ApiService();
  bool _isLoading = false;
  String? _currentShopId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedShopId = ref.read(selectedShopProvider)?.id;
      if (selectedShopId != null) {
        _currentShopId = selectedShopId;
        _fetchInventory(shopId: _currentShopId!);
      }
    });
  }

  Future<void> _fetchInventory({required String shopId}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ref
          .read(employeeProvider.notifier)
          .fetchAndSyncFromBackend(shopId: shopId);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Success: The provider usually updates the state internally,
        // but you can add specific success logic here if needed.
      } else {
        // Handle error status codes (e.g., 400, 401, 500)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to fetch employees: ${response.message}'),
            ),
          );
        }
      }
    } catch (e) {
      // Handle network or parsing errors
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final owner = ref.watch(ownerProvider).value;
    final selectedShop = ref.watch(selectedShopProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Employees', style: theme.textTheme.titleLarge),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const AddEmployeesScreen(
                        isRequestForSelfEmployee: false,
                      ),
                    ),
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.successDark.withValues(alpha: 0.2),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 2));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        SalesSearchBar(
                          onChanged: (value) {
                            final query = value.toLowerCase().trim();
                            ref.read(employeeProvider.notifier).search(query);
                          },
                          onFilterTap: () {
                            showMenu(
                              context: context,
                              position: const RelativeRect.fromLTRB(
                                100,
                                100,
                                0,
                                0,
                              ),
                              items: [
                                const PopupMenuItem(
                                  value: 'all',
                                  child: Text('All'),
                                ),
                                const PopupMenuItem(
                                  value: 'manager',
                                  child: Text('Manager'),
                                ),
                                const PopupMenuItem(
                                  value: 'pharmacist',
                                  child: Text('Pharmacist'),
                                ),
                                const PopupMenuItem(
                                  value: 'cashier',
                                  child: Text('Cashier'),
                                ),
                                const PopupMenuItem(
                                  value: 'staff',
                                  child: Text('Staff'),
                                ),
                              ],
                            ).then((value) {
                              if (value != null) {
                                ref
                                    .read(employeeProvider.notifier)
                                    .filteredEmployee(value);
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // --- Owner as Self-Employee Section ---
                        _ownerSelfEmployeeSection(
                          context,
                          theme,
                          owner,
                          selectedShop?.isOwnerEmployee ?? false,
                        ),

                        const SizedBox(height: 8),

                        // --- Staff Members List Section ---
                        Consumer(
                          builder: (_, ref, _) {
                            final filteredEmployee = ref
                                .watch(employeeProvider)
                                .filteredEmployee;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Staff Members',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.12,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          '${filteredEmployee.length}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _employeeList(theme, filteredEmployee),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  /// Self-Employee card when registered, or an invitation prompt when not registered
  Widget _ownerSelfEmployeeSection(
    BuildContext context,
    ThemeData theme,
    ShopOwnerModel? owner,
    bool isSelfEmployee,
  ) {
    if (owner == null) return const SizedBox.shrink();

    if (isSelfEmployee) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top tag row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'SHOP OWNER • SELF EMPLOYEE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successDark.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.successDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Active Shift',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.successDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Profile info row
            Row(
              children: [
                // Avatar with crown/shield badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.15),
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(owner.name),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
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
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                // Name and details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              owner.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
                              'Owner (You)',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        owner.email,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.textTheme.labelMedium?.color?.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Role chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.managerBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Manager',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.managerForeground,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Operational Note
            Row(
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 15,
                  color: AppColors.primaryLight,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'You are registered to dispense medicines and record bills under your account.',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.textTheme.labelSmall?.color?.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // Owner is NOT registered as self employee: Show prompt card
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.badge_outlined,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Work at the counter?',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Register yourself as a self-employee to handle counter sales and dispensing.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.75,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const AddEmployeesScreen(
                      isRequestForSelfEmployee: true,
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Register'),
            ),
          ],
        ),
      );
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Container _employeeList(ThemeData theme, List<EmployeeModel> allEmployee) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.cardColor,
      ),
      child: allEmployee.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allEmployee.length,
              itemBuilder: (context, index) {
                final employee = allEmployee[index];
                return EmployeeListWidget(
                  employeeId: employee.id,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>
                            EmployeeDetailsScreen(empId: employee.id),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            )
          : SizedBox(
              width: double.infinity,
              height: 250,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.people_outline),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "No Staff Members Found",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your team members will appear here once they are added to the shop or when they match your search criteria.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
