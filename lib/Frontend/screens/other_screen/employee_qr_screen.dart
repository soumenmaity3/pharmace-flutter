import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmace/Frontend/Widget/AddEmployee/qr_code_widget.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

class EmployeeQrScreen extends StatefulWidget {
  const EmployeeQrScreen({super.key});

  @override
  State<EmployeeQrScreen> createState() => _EmployeeQrScreenState();
}

class _EmployeeQrScreenState extends State<EmployeeQrScreen> {
  // Change these values from your API/backend.
  final String employeeRole = 'Cashier';
  final String pharmacyName = 'Sengupta Medical Hall';

  final String inviteCode = 'PHR-82X9-K4';

  // IMPORTANT:
  // This is the actual data encoded inside the QR.
  //
  // Ideally use your invitation URL or invitation ID here.
  final String qrData = 'PHR-82X9-K4';

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: inviteCode));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invitation code copied'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Invite employee')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                      padding: EdgeInsets.symmetric(
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
                          Icon(
                            Icons.verified_user_outlined,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 5),
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

                    SizedBox(height: 20),

                    // ------------------------------------------------
                    // TITLE
                    // ------------------------------------------------
                    Text(
                      'Invite New employee',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),

                    SizedBox(height: 8),

                    // ------------------------------------------------
                    // SUBTITLE
                    // ------------------------------------------------
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.lightTextSecondary,
                        ),
                        children: [
                          const TextSpan(text: 'as '),

                          TextSpan(
                            text: employeeRole,
                            style: theme.textTheme.titleMedium,
                          ),

                          TextSpan(text: ' at '),

                          TextSpan(
                            text: pharmacyName,
                            style: theme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // ------------------------------------------------
                    // MAIN CARD
                    // ------------------------------------------------
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 26),
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

                          SizedBox(height: 24),

                          // ------------------------------------------
                          // QR
                          // ------------------------------------------
                          QrCodeWidget(data: qrData, size: 220),

                          SizedBox(height: 26),

                          // ------------------------------------------
                          // DIVIDER + OR ENTER CODE
                          // ------------------------------------------
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors.darkDivider,
                                  thickness: 1,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  'OR ENTER CODE',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.darkTextTertiary,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Divider(
                                  color: AppColors.darkDivider,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

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

                          SizedBox(height: 22),

                          // ------------------------------------------
                          // INVITE CODE
                          // ------------------------------------------
                          Container(
                            width: double.infinity,
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: theme.focusColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    inviteCode,
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),

                                TextButton.icon(
                                  onPressed: _copyCode,
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                  icon: Icon(Icons.copy_outlined, size: 18),
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

                    SizedBox(height: 26),

                    // ------------------------------------------------
                    // BOTTOM INSTRUCTION
                    // ------------------------------------------------
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Text.rich(
                        TextSpan(
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 14,
                            height: 1.55,
                          ),
                          // fontSize: 14,
                          // height: 1.55,
                          children: [
                            TextSpan(
                              text: 'Ask New to open the ',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppColors.darkTextTertiary,
                              ),
                            ),
                            TextSpan(
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

                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Share invitation
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/share.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
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
                    SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Regenerate code
                        },
                        icon: Icon(Icons.refresh, size: 20),
                        label: Text(
                          'Regenerate code',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: theme.cardColor,
                          side: BorderSide(
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
                    SizedBox(height: 20),
                    TextButton(onPressed: () {}, child: Text('Done')),
                    SizedBox(height: 30),
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
