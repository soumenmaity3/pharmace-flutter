import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmace/Frontend/Widget/text_feild_widget.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';
import 'package:pharmace/LocalDB/database.dart';
Future<void> showEditShopDetailsBottomSheet({
  required BuildContext context,
  required ShopTableData? shop,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EditShopDetailsBottomSheet(shop: shop),
  );
}

class EditShopDetailsBottomSheet extends StatefulWidget {
  const EditShopDetailsBottomSheet({super.key, this.shop});

  final ShopTableData? shop;

  @override
  State<EditShopDetailsBottomSheet> createState() =>
      _EditShopDetailsBottomSheetState();
}

class _EditShopDetailsBottomSheetState
    extends State<EditShopDetailsBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _shopNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _licenseController;
  late final TextEditingController _gstController;

  bool _isSubmitting = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked != null && mounted) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _showImageSourcePicker() {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeExtension>()!;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: appColors.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Text('Choose photo', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                title: const Text('Take a photo'),
                subtitle: Text(
                  'Use your camera',
                  style: TextStyle(color: appColors.textTertiary),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                title: const Text('Choose from gallery'),
                subtitle: Text(
                  'Pick an existing image',
                  style: TextStyle(color: appColors.textTertiary),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_selectedImage != null || widget.shop?.logoUrl != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: appColors.dangerContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: appColors.danger,
                      size: 22,
                    ),
                  ),
                  title: const Text('Remove photo'),
                  subtitle: Text(
                    'Reset to default',
                    style: TextStyle(color: appColors.textTertiary),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _selectedImage = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final shop = widget.shop;
    _shopNameController = TextEditingController(text: shop?.shopName ?? '');
    _emailController = TextEditingController(text: shop?.shopEmail ?? '');
    _phoneController = TextEditingController(text: shop?.phone ?? '');
    _addressController = TextEditingController(text: shop?.address ?? '');
    _cityController = TextEditingController(text: shop?.city ?? '');
    _stateController = TextEditingController(text: shop?.state ?? '');
    _pincodeController = TextEditingController(text: shop?.pincode ?? '');
    _licenseController =
        TextEditingController(text: shop?.licenseNumber ?? '');
    _gstController = TextEditingController(text: shop?.gstNumber ?? '');
  }

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

  void _handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    // TODO: Call API / update local DB with edited fields
    // For now, just close the sheet after a brief delay to show the loading state.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppThemeExtension>()!;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Drag handle ───
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: appColors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),

          // ─── Scrollable content ───
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Header ──
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            color: colors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Edit shop details',
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Update your pharmacy information',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: appColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close_rounded,
                            color: appColors.textTertiary,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: colors.surfaceContainerHighest,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Divider(height: 1, color: appColors.border),
                    const SizedBox(height: 24),

                    // ── Section: Shop logo ──
                    _SectionHeader(
                      icon: Icons.image_outlined,
                      label: 'Shop logo',
                      appColors: appColors,
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: GestureDetector(
                        onTap: _showImageSourcePicker,
                        child: Column(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: colors.primaryContainer,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: appColors.border,
                                  width: 1.5,
                                ),
                                image: _selectedImage != null
                                    ? DecorationImage(
                                        image: FileImage(_selectedImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : (widget.shop?.logoUrl != null &&
                                            widget.shop!.logoUrl!.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              widget.shop!.logoUrl!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null),
                              ),
                              child: (_selectedImage == null &&
                                      (widget.shop?.logoUrl == null ||
                                          widget.shop!.logoUrl!.isEmpty))
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo_outlined,
                                          color: colors.primary,
                                          size: 28,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Add logo',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: colors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        margin: const EdgeInsets.all(6),
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: colors.surface,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.edit_rounded,
                                          size: 16,
                                          color: colors.primary,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tap to change shop logo',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: appColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Section: Basic info ──
                    _SectionHeader(
                      icon: Icons.storefront_outlined,
                      label: 'Basic information',
                      appColors: appColors,
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel(label: 'Shop name', appColors: appColors),
                    const SizedBox(height: 8),
                    TextFieldWidget(
                      controller: _shopNameController,
                      hintText: 'e.g. Sengupta Medical Hall',
                      isRequired: true,
                    ),

                    const SizedBox(height: 28),

                    // ── Section: Contact ──
                    _SectionHeader(
                      icon: Icons.contact_phone_outlined,
                      label: 'Contact details',
                      appColors: appColors,
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel(label: 'Email', appColors: appColors),
                    const SizedBox(height: 8),
                    TextFieldWidget(
                      controller: _emailController,
                      hintText: 'e.g. contact@pharmacy.in',
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Phone number', appColors: appColors),
                    const SizedBox(height: 8),
                    TextFieldWidget(
                      controller: _phoneController,
                      hintText: 'e.g. +91 98300 45123',
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 28),

                    // ── Section: Address ──
                    _SectionHeader(
                      icon: Icons.location_on_outlined,
                      label: 'Shop address',
                      appColors: appColors,
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel(label: 'Address', appColors: appColors),
                    const SizedBox(height: 8),
                    TextFieldWidget(
                      controller: _addressController,
                      hintText: 'Street, area',
                      isRequired: true,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(
                                label: 'City',
                                appColors: appColors,
                              ),
                              const SizedBox(height: 8),
                              TextFieldWidget(
                                controller: _cityController,
                                hintText: 'e.g. Kolkata',
                                isRequired: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(
                                label: 'State',
                                appColors: appColors,
                              ),
                              const SizedBox(height: 8),
                              TextFieldWidget(
                                controller: _stateController,
                                hintText: 'e.g. West Bengal',
                                isRequired: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Pincode', appColors: appColors),
                    const SizedBox(height: 8),
                    TextFieldWidget(
                      controller: _pincodeController,
                      hintText: 'e.g. 700001',
                      isRequired: true,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 28),

                    // ── Section: Legal ──
                    _SectionHeader(
                      icon: Icons.verified_user_outlined,
                      label: 'Legal information',
                      appColors: appColors,
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel(
                      label: 'Pharmacy license number',
                      appColors: appColors,
                      optional: true,
                    ),
                    const SizedBox(height: 8),
                    TextFieldWidget(
                      controller: _licenseController,
                      hintText: 'e.g. WB/PH/2019/00452',
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(
                      label: 'GST number',
                      appColors: appColors,
                      optional: true,
                    ),
                    const SizedBox(height: 8),
                    TextFieldWidget(
                      controller: _gstController,
                      hintText: 'e.g. 19ABCDE1234F1Z5',
                    ),

                    const SizedBox(height: 32),

                    // ── Save button ──
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleSave,
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                ),
                              )
                            : const Text('Save changes'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 48,
                      child: TextButton(
                        onPressed:
                            _isSubmitting ? null : () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helper widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.appColors,
  });

  final IconData icon;
  final String label;
  final AppThemeExtension appColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    required this.appColors,
    this.optional = false,
  });

  final String label;
  final AppThemeExtension appColors;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: appColors.textSecondary,
            ),
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
