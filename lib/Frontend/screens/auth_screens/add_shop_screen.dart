import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/model/Input/shop_model.dart';
import 'package:pharmace/Frontend/Widget/text_feild_widget.dart';
import 'package:pharmace/Frontend/service/location_service.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/Provider/database_provider.dart';

class AddShopScreen extends ConsumerStatefulWidget {
  const AddShopScreen({super.key, this.onCompleted});

  final VoidCallback? onCompleted;

  @override
  ConsumerState<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends ConsumerState<AddShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _licenseController = TextEditingController();
  final _gstController = TextEditingController();
  final ApiService _apiService = ApiService();

  int _currentStep = 0;

  // Live location capture state
  bool _isCapturingLocation = false;
  bool _isLocationCaptured = false;
  String? _capturedCoordinates;
  String? _capturedAddressHint;

  bool _hasInAppLocationPermission = false;

  Future<void> _captureLiveLocation() async {
    // 1. Request in-app permission dialog if not granted yet (in-app, not settings)
    if (!_hasInAppLocationPermission) {
      final granted =
          await LocationService.instance.requestInAppPermission(context);
      if (!granted) {
        return;
      }
      _hasInAppLocationPermission = true;
    }

    setState(() => _isCapturingLocation = true);

    try {
      final locData =
          await LocationService.instance.getCurrentLocationAddress();

      if (!mounted) return;

      if (locData != null) {
        setState(() {
          _isCapturingLocation = false;
          _isLocationCaptured = true;
          _capturedCoordinates = locData.formattedCoordinates;

          final addr = locData.address;
          final city = locData.city;
          _capturedAddressHint = addr.isNotEmpty
              ? '$addr, $city'
              : (_addressController.text.trim().isNotEmpty
                  ? _addressController.text.trim()
                  : 'Location detected');

          // Fill all location fields
          if (locData.address.isNotEmpty) {
            _addressController.text = locData.address;
          }
          if (locData.city.isNotEmpty) {
            _cityController.text = locData.city;
          }
          if (locData.state.isNotEmpty) {
            _stateController.text = locData.state;
          }
          if (locData.pincode.isNotEmpty) {
            _pincodeController.text = locData.pincode;
          }
        });
      } else {
        setState(() => _isCapturingLocation = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to detect location. Please check your internet connection.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCapturingLocation = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static const _steps = [
    _ShopStep('Your pharmacy', "Let's start with the basics"),
    _ShopStep('Contact details', 'How customers and staff can reach you'),
    _ShopStep('Shop address', 'Where is the pharmacy located'),
    _ShopStep('Legal information', 'For verification — you can add this later'),
  ];

  @override
  void dispose() {
    _shopNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _licenseController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  Future<void> _continue(AppDatabase db) async {
    if (_currentStep < _steps.length - 1) {
      if (!(_formKey.currentState?.validate() ?? false)) return;
      setState(() => _currentStep++);
      return;
    }
    // Last step → Add shop API
    await addShop(db);
  }

  Future<void> addShop(AppDatabase db) async {
    final ShopModel shop = ShopModel(
      shopName: _shopNameController.text.trim(),
      shopEmail: _emailController.text.trim().toLowerCase(),
      gstNumber: _gstController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
      verifyStatus: Verify.pending,

      logoUrl: null,
      isOpen: false,
    );

    try {
      final result = await _apiService.addShop(shop);

      if (!mounted) return;

      if (result.statusCode >= 200 &&
          result.statusCode < 300 &&
          result.data != null) {
        await db.ownerAuthDao.updateIsHaveShop(hasShop: true);

        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(content: Text('Shop added successfully')),
          );
        widget.onCompleted?.call();

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'Failed to add shop')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeExtension>()!;
    final step = _steps[_currentStep];
    final isLastStep = _currentStep == _steps.length - 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
        title: const Text('Add your shop'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StepProgress(
                  currentStep: _currentStep,
                  totalSteps: _steps.length,
                ),
                const SizedBox(height: 24),
                Text(
                  'STEP ${_currentStep + 1} OF ${_steps.length}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(step.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(
                  step.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: appColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 30),
                if (_currentStep == 0) ...[
                  _FieldLabel(label: 'Shop name'),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    controller: _shopNameController,
                    hintText: 'e.g. Sengupta Medical Hall',
                    isRequired: true,
                  ),
                ],
                if (_currentStep == 1) ...[
                  _FieldLabel(label: 'Shop email'),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    controller: _emailController,
                    hintText: 'e.g. contact@yourpharmacy.in',
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel(label: 'Phone number'),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    controller: _phoneController,
                    hintText: 'e.g. +91 98300 45123',
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                  ),
                ],
                if (_currentStep == 2) ...[
                  _FieldLabel(label: 'Address'),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    controller: _addressController,
                    hintText: 'Street, area',
                    isRequired: true,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _LabeledInput(
                          label: 'City',
                          controller: _cityController,
                          hintText: 'e.g. Kolkata',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _LabeledInput(
                          label: 'State',
                          controller: _stateController,
                          hintText: 'e.g. West Bengal',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel(label: 'Pincode'),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    controller: _pincodeController,
                    hintText: 'e.g. 700001',
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _locationCaptureCard(theme, appColors),
                ],
                if (_currentStep == 3) ...[
                  _FieldLabel(label: 'Pharmacy license number', optional: true),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    controller: _licenseController,
                    hintText: 'e.g. WB/PH/2019/00452',
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel(label: 'GST number', optional: true),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    controller: _gstController,
                    hintText: 'e.g. 19ABCDE1234F1Z5',
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Adding these now speeds up shop verification. You can also complete them later from Shop Profile.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () async {
                      _continue(ref.watch(databaseProvider));
                    },
                    child: Text(isLastStep ? 'Add shop' : 'Continue'),
                  ),
                ),
                if (isLastStep)
                  TextButton(
                    onPressed:  () async {
                      _continue(ref.watch(databaseProvider));
                    },
                    child: const Text('Skip for now'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationCaptureCard(ThemeData theme, AppThemeExtension appColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(label: 'Shop GPS location', optional: true),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isLocationCaptured
                ? AppColors.primary.withValues(alpha: 0.05)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isLocationCaptured
                  ? AppColors.primary
                  : appColors.border,
              width: _isLocationCaptured ? 1.5 : 1,
            ),
            boxShadow: [
              if (_isLocationCaptured)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: _isLocationCaptured
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : (_isCapturingLocation
                              ? AppColors.warning.withValues(alpha: 0.12)
                              : AppColors.primary.withValues(alpha: 0.1)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isLocationCaptured
                          ? Icons.location_on_rounded
                          : (_isCapturingLocation
                              ? Icons.radar_rounded
                              : Icons.my_location_rounded),
                      color: _isLocationCaptured
                          ? AppColors.primary
                          : (_isCapturingLocation
                              ? AppColors.warning
                              : AppColors.primary),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isLocationCaptured
                                  ? 'Location Tagged'
                                  : 'Shop Geo-Tagging',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_isLocationCaptured)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.successDark.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 12,
                                      color: AppColors.successDark,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Captured',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.successDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isLocationCaptured
                              ? (_capturedAddressHint ?? 'Coordinates pinned to store address')
                              : 'Pin your pharmacy’s live GPS coordinates for licensing verification and nearby customer searches.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: appColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (_isLocationCaptured && _capturedCoordinates != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: appColors.border,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.gps_fixed,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _capturedCoordinates!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Accuracy: ~6m',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: _isLocationCaptured
                    ? OutlinedButton.icon(
                        onPressed: _isCapturingLocation ? null : _captureLiveLocation,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Re-capture Location'),
                      )
                    : ElevatedButton.icon(
                        onPressed: _isCapturingLocation ? null : _captureLiveLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: _isCapturingLocation
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.my_location_rounded, size: 18),
                        label: Text(
                          _isCapturingLocation
                              ? 'Detecting GPS coordinates...'
                              : 'Capture Live Location',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.currentStep, required this.totalSteps});

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
        (index) => Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 6),
            decoration: BoxDecoration(
              color: index <= currentStep
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).extension<AppThemeExtension>()!.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledInput extends StatelessWidget {
  const _LabeledInput({
    required this.label,
    required this.controller,
    required this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label),
        const SizedBox(height: 8),
        TextFieldWidget(
          controller: controller,
          hintText: hintText,
          isRequired: true,
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, this.optional = false});

  final String label;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeExtension>()!;
    return RichText(
      text: TextSpan(
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: appColors.textSecondary),
        children: [
          TextSpan(text: label),
          if (optional)
            TextSpan(
              text: ' (optional)',
              style: TextStyle(color: appColors.textTertiary),
            ),
        ],
      ),
    );
  }
}

class _ShopStep {
  const _ShopStep(this.title, this.subtitle);

  final String title;
  final String subtitle;
}
