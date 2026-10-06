import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/model/Output/emp_invite.dart';
import 'package:pharmace/Frontend/Widget/AddEmployee/role_widget.dart';
import 'package:pharmace/Frontend/Widget/text_feild_widget.dart';
import 'package:pharmace/Frontend/screens/other_screen/employee_qr_screen.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';
import 'package:pharmace/Provider/owner_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';

import 'package:pharmace/Backend/model/Input/shop_owner_model.dart';
import 'package:pharmace/Frontend/Employees/model/employee_model.dart';

class AddEmployeesScreen extends ConsumerStatefulWidget {
  const AddEmployeesScreen({super.key, required this.isRequestForSelfEmployee});
  final bool isRequestForSelfEmployee;

  @override
  ConsumerState<AddEmployeesScreen> createState() => _AddEmployeesScreenState();
}

class _AddEmployeesScreenState extends ConsumerState<AddEmployeesScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isSelfEmployee = false;
  bool _isLoading = false;
  RoleEmp selectedRole = RoleEmp.manager;
  final ApiService apiService = ApiService();

  final List<String> roles = ['Manager', 'Pharmacist', 'Cashier', 'Staff'];

  @override
  void initState() {
    super.initState();
    _isSelfEmployee = widget.isRequestForSelfEmployee;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedShop = ref.read(selectedShopProvider);
      final owner = ref.read(ownerProvider).value;
      final isAlreadyOwnerEmployee = selectedShop?.isOwnerEmployee ?? false;

      if (isAlreadyOwnerEmployee) {
        if (_isSelfEmployee) {
          setState(() {
            _isSelfEmployee = false;
          });
        }
      } else if (_isSelfEmployee) {
        setState(() {
          selectedRole = RoleEmp.manager;
          if (owner != null) {
            _nameController.text = owner.name;
            _emailController.text = owner.email;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleSelfEmployee(ShopOwnerModel? owner, {bool isAlreadyOwnerEmployee = false}) {
    if (isAlreadyOwnerEmployee) return;
    setState(() {
      _isSelfEmployee = !_isSelfEmployee;
      if (_isSelfEmployee) {
        selectedRole = RoleEmp.manager;
        if (owner != null) {
          _nameController.text = owner.name;
          _emailController.text = owner.email;
        }
      } else {
        selectedRole = RoleEmp.cashier;
        _nameController.clear();
        _emailController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeExtension>();
    final owner = ref.watch(ownerProvider).value;
    final selectedShop = ref.watch(selectedShopProvider);
    final isAlreadyOwnerEmployee = selectedShop?.isOwnerEmployee ?? false;

    ref.listen<AsyncValue<ShopOwnerModel?>>(ownerProvider, (previous, next) {
      final newOwner = next.value;
      if (_isSelfEmployee && newOwner != null) {
        if (_nameController.text.isEmpty) {
          _nameController.text = newOwner.name;
        }
        if (_emailController.text.isEmpty) {
          _emailController.text = newOwner.email;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Add Employees')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mark as self employee button / card
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: _isSelfEmployee
                          ? const Color(0xFF087563).withValues(alpha: 0.08)
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isSelfEmployee
                            ? const Color(0xFF087563)
                            : (appColors?.border ?? theme.dividerColor),
                        width: _isSelfEmployee ? 1.5 : 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: isAlreadyOwnerEmployee
                            ? null
                            : () => _toggleSelfEmployee(
                                owner,
                                isAlreadyOwnerEmployee: isAlreadyOwnerEmployee,
                              ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _isSelfEmployee
                                      ? const Color(0xFF087563)
                                      : const Color(
                                          0xFF087563,
                                        ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.badge_outlined,
                                  color: _isSelfEmployee
                                      ? Colors.white
                                      : const Color(0xFF087563),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: [
                                        Text(
                                          'Mark as self employee',
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isAlreadyOwnerEmployee
                                                ? (appColors?.disabled ??
                                                    Colors.grey.shade300)
                                                : (_isSelfEmployee
                                                    ? const Color(0xFF087563)
                                                    : (appColors?.disabled ??
                                                        Colors.grey.shade300)),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            isAlreadyOwnerEmployee
                                                ? 'Already registered'
                                                : 'Owner',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: isAlreadyOwnerEmployee
                                                  ? (appColors?.textSecondary ??
                                                      Colors.grey.shade700)
                                                  : (_isSelfEmployee
                                                      ? Colors.white
                                                      : (appColors?.textSecondary ??
                                                          Colors.grey.shade700)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isAlreadyOwnerEmployee
                                          ? 'Owner is already registered as an employee for this shop'
                                          : (_isSelfEmployee
                                              ? 'Using your owner account details'
                                              : 'Assign yourself (Shop Owner) as an employee'),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color:
                                                appColors?.textSecondary ??
                                                Colors.grey,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _isSelfEmployee,
                                activeThumbColor: const Color(0xFF087563),
                                onChanged: isAlreadyOwnerEmployee
                                    ? null
                                    : (_) => _toggleSelfEmployee(
                                        owner,
                                        isAlreadyOwnerEmployee:
                                            isAlreadyOwnerEmployee,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Text('Full name', style: theme.textTheme.titleSmall),

                  const SizedBox(height: 10),

                  TextFieldWidget(
                    controller: _nameController,
                    hintText: 'e.g. Soumen Maity',
                    isRequired: true,
                  ),

                  const SizedBox(height: 15),

                  Text('Email address', style: theme.textTheme.titleSmall),

                  const SizedBox(height: 10),

                  TextFieldWidget(
                    controller: _emailController,
                    hintText: 'name@example.com',
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 15),

                  Text('Role', style: theme.textTheme.titleSmall),

                  const SizedBox(height: 10),

                  // Role selection
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: roles.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 4,
                        ),
                    itemBuilder: (context, index) {
                      final role = roles[index];

                      return RoleWidget(
                        title: role,
                        isSelected:
                            selectedRole.name.toLowerCase() ==
                            role.toLowerCase(),
                        isEnabled: !_isSelfEmployee,
                        onTap: () {
                          if (!_isSelfEmployee) {
                            setState(() {
                              selectedRole = RoleEmp.fromString(role);
                            });
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Action button: Done for self employee, Generate invitation for external employee
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final shopId =
                                    // owner?.selectedShopId ??
                                    ref.read(selectedShopProvider)?.id;

                                if (shopId == null || shopId.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'No shop selected. Please select a shop first.',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                if (_isSelfEmployee) {
                                  setState(() => _isLoading = true);
                                  final response = await apiService
                                      .markSelfEmployee(shopId);
                                  setState(() => _isLoading = false);

                                  if (response.statusCode >= 200 &&
                                      response.statusCode < 300) {
                                    await ref
                                        .read(shopProvider.notifier)
                                        .updateOwnerEmployeeStatus(
                                          shopId,
                                          true,
                                        );
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Owner marked as Manager employee successfully',
                                        ),
                                        backgroundColor: const Color(
                                          0xFF087563,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  } else {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          response.message ??
                                              'Failed to mark self as employee (${response.statusCode})',
                                        ),
                                        backgroundColor: Colors.red.shade700,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  setState(() => _isLoading = true);
                                  final inviteRequest = EmpInvite(
                                    '',
                                    shopId,
                                    empEmail: _emailController.text.trim(),
                                    empRole: selectedRole,
                                    empName: _nameController.text.trim()
                                  );
                                  final response = await apiService
                                      .generateInviteCode(
                                        shopId: shopId,
                                        empInvite: inviteRequest,
                                      );
                                  setState(() => _isLoading = false);

                                  if (!context.mounted) return;

                                  if (response.statusCode >= 200 &&
                                      response.statusCode < 300) {
                                    final inviteData =
                                        response.data ?? inviteRequest;
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (builder) =>
                                            EmployeeQrScreen(inviteData),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          response.message ??
                                              'Failed to generate invitation code (${response.statusCode})',
                                        ),
                                        backgroundColor: Colors.red.shade700,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              _isSelfEmployee
                                  ? Icons.check_circle_outline
                                  : Icons.qr_code_2,
                            ),
                      label: Text(
                        _isLoading
                            ? 'Saving...'
                            : (_isSelfEmployee
                                  ? 'Done'
                                  : 'Generate invitation'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF087563),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
