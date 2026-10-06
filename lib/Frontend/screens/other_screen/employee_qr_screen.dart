import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/model/Output/emp_invite.dart';
import 'package:pharmace/Frontend/Employees/model/employee_model.dart';
import 'package:pharmace/Frontend/Widget/AddEmployee/qr_code_widget.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Provider/shop_provider.dart';
import 'package:share_plus/share_plus.dart';

class EmployeeQrScreen extends ConsumerStatefulWidget {
  const EmployeeQrScreen(this.inviteDetails, {super.key});
  final EmpInvite inviteDetails;

  @override
  ConsumerState<EmployeeQrScreen> createState() => _EmployeeQrScreenState();
}

class _EmployeeQrScreenState extends ConsumerState<EmployeeQrScreen> {
  late EmpInvite _currentInvite;
  bool _isRegenerating = false;

  @override
  void initState() {
    super.initState();
    _currentInvite = widget.inviteDetails;
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

  Future<void> _copyCode() async {
    final code = _currentInvite.inviteId;
    if (code.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: code));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invitation code copied'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _shareInvitation(
    String pharmacyName,
    String employeeRole,
  ) async {
    final code = _currentInvite.inviteId;
    final message =
        'You are invited to join $pharmacyName as $employeeRole.\n\n'
        'Download the Pharmase Employee app and use invitation code: $code or scan the QR code to join.';
    try {
      await SharePlus.instance.share(ShareParams(text: message));
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: message));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invitation details copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _regenerateCode() async {
    if (_isRegenerating) return;

    final shopId = _currentInvite.shopId.isNotEmpty
        ? _currentInvite.shopId
        : (ref.read(selectedShopProvider)?.id ?? '');

    if (shopId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop ID not found')),
      );
      return;
    }

    setState(() => _isRegenerating = true);

    final response = await ApiService().generateInviteCode(
      shopId: shopId,
      empInvite: _currentInvite,
    );

    setState(() => _isRegenerating = false);

    if (!mounted) return;

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        response.data != null) {
      setState(() {
        _currentInvite = response.data!;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New invitation code generated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.message ??
                'Failed to regenerate code (${response.statusCode})',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedShop = ref.watch(selectedShopProvider);
    final pharmacyName = selectedShop?.shopName ?? 'Pharmacy';
    final employeeRole = _getRoleName(_currentInvite.empRole);
    final inviteCode = _currentInvite.inviteId;

    return Scaffold(
      appBar: AppBar(title: const Text('Invite employee')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Column(
                  children: [
                    // ------------------------------------------------
                    // SECURE INVITATION
                    // ------------------------------------------------
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: theme.focusColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Secure invitation',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ------------------------------------------------
                    // TITLE
                    // ------------------------------------------------
                    Text(
                      'Invite New employee',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),

                    const SizedBox(height: 8),

                    // ------------------------------------------------
                    // SUBTITLE
                    // ------------------------------------------------
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.lightTextSecondary,
                        ),
                        children: [
                          const TextSpan(text: 'as '),
                          TextSpan(
                            text: employeeRole,
                            style: theme.textTheme.titleMedium,
                          ),
                          const TextSpan(text: ' at '),
                          TextSpan(
                            text: pharmacyName,
                            style: theme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ------------------------------------------------
                    // MAIN CARD
                    // ------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 26),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Column(
                        children: [
                          // ------------------------------------------
                          // INSTRUCTION
                          // ------------------------------------------
                          Text(
                            'Scan this QR code to join the pharmacy',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkTextTertiary,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ------------------------------------------
                          // QR
                          // ------------------------------------------
                          QrCodeWidget(
                            data: inviteCode.isNotEmpty
                                ? inviteCode
                                : 'No Invite Code',
                            size: 220,
                          ),

                          const SizedBox(height: 26),

                          // ------------------------------------------
                          // DIVIDER + OR ENTER CODE
                          // ------------------------------------------
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: AppColors.darkDivider,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                child: Text(
                                  'OR ENTER CODE',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.darkTextTertiary,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: AppColors.darkDivider,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 15,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'This code expires in 10 minutes.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          // ------------------------------------------
                          // INVITE CODE
                          // ------------------------------------------
                          Container(
                            width: double.infinity,
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: theme.focusColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    inviteCode.isNotEmpty
                                        ? inviteCode
                                        : '--------',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed:
                                      inviteCode.isNotEmpty ? _copyCode : null,
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.copy_outlined,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'Copy',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ------------------------------------------------
                    // BOTTOM INSTRUCTION
                    // ------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text.rich(
                        TextSpan(
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 14,
                            height: 1.55,
                          ),
                          children: [
                            TextSpan(
                              text: 'Ask employee to open the ',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppColors.darkTextTertiary,
                              ),
                            ),
                            const TextSpan(
                              text: 'Pharmase Employee',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7C8C9C),
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' app and enter this code or\nscan the QR to join.',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppColors.darkTextTertiary,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: inviteCode.isNotEmpty
                            ? () => _shareInvitation(
                                pharmacyName,
                                employeeRole,
                              )
                            : null,
                        icon: SvgPicture.asset(
                          'assets/icons/share.svg',
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            AppColors.goldLight,
                            BlendMode.srcIn,
                          ),
                        ),
                        label: Text(
                          'Share Invitation',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.goldLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.goldLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: _isRegenerating ? null : _regenerateCode,
                        icon: _isRegenerating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.refresh, size: 20),
                        label: Text(
                          _isRegenerating
                              ? 'Regenerating...'
                              : 'Regenerate code',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: theme.cardColor,
                          side: const BorderSide(
                            color: AppColors.darkBorder,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Done'),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

