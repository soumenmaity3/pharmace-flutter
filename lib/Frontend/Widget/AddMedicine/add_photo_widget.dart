import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmace/Frontend/Inventory/model/medicine_model.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

class AddPhotoWidget extends StatefulWidget {
  const AddPhotoWidget({
    super.key,
    this.imageUrl,
    this.dosageForm,
    this.medicineName,
    this.category,
    this.height = 190,
    this.isEditable = true,
    this.onPhotoChanged,
  });

  final String? imageUrl;
  final DosageForm? dosageForm;
  final String? medicineName;
  final String? category;
  final double height;
  final bool isEditable;
  final ValueChanged<String?>? onPhotoChanged;

  @override
  State<AddPhotoWidget> createState() => _AddPhotoWidgetState();
}

class _AddPhotoWidgetState extends State<AddPhotoWidget> {
  late String? _currentImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(covariant AddPhotoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _currentImageUrl = widget.imageUrl;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
      // On Windows/desktop, ImageSource.camera is not supported by file_selector, fallback to gallery
      final actualSource = isDesktop ? ImageSource.gallery : source;

      final XFile? image = await _picker.pickImage(
        source: actualSource,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _currentImageUrl = image.path;
        });
        widget.onPhotoChanged?.call(image.path);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Failed to pick image';
        if (e.toString().contains('channel-error') ||
            e.toString().contains('MissingPluginException') ||
            e.toString().contains('Unable to establish connection on channel')) {
          errorMessage =
              'Please completely restart (stop & rebuild) the app to link newly added native plugins on Windows.';
        } else {
          errorMessage = 'Failed to pick image: $e';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Widget _buildDosageIcon(DosageForm? form, {double size = 20, Color? color}) {
    final c = color ?? AppColors.primary;
    if (form == null) {
      return Icon(Icons.medication_outlined, size: size, color: c);
    }
    switch (form) {
      case DosageForm.tablet:
        return FaIcon(FontAwesomeIcons.pills, size: size, color: c);
      case DosageForm.capsule:
        return FaIcon(FontAwesomeIcons.capsules, size: size, color: c);
      case DosageForm.injection:
        return FaIcon(FontAwesomeIcons.syringe, size: size, color: c);
      case DosageForm.syrup:
      case DosageForm.suspension:
      case DosageForm.solution:
        return FaIcon(FontAwesomeIcons.prescriptionBottle, size: size, color: c);
      case DosageForm.drops:
        return Icon(Icons.water_drop_outlined, size: size, color: c);
      case DosageForm.spray:
      case DosageForm.inhaler:
      case DosageForm.respules:
        return FaIcon(FontAwesomeIcons.sprayCan, size: size, color: c);
      case DosageForm.gel:
      case DosageForm.cream:
      case DosageForm.ointment:
        return Icon(Icons.sanitizer_outlined, size: size, color: c);
      case DosageForm.powder:
      case DosageForm.other:
        return FaIcon(FontAwesomeIcons.mortarPestle, size: size, color: c);
    }
  }

  Widget _buildImageWidget(String pathOrUrl) {
    final isNetwork = pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isNetwork) {
      return Image.network(
        pathOrUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: AppColors.primary,
              strokeWidth: 2.5,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackErrorView(Theme.of(context), isDark);
        },
      );
    } else {
      return Image.file(
        File(pathOrUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackErrorView(Theme.of(context), isDark);
        },
      );
    }
  }

  Widget _buildPreviewError(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.black54,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.broken_image_outlined, size: 50, color: Colors.white70),
          const SizedBox(height: 12),
          Text(
            'Unable to load image',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(BuildContext context, String pathOrUrl) {
    final isNetwork = pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://');

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.8,
                  maxScale: 3.5,
                  child: isNetwork
                      ? Image.network(
                          pathOrUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => _buildPreviewError(context),
                        )
                      : Image.file(
                          File(pathOrUrl),
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => _buildPreviewError(context),
                        ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPhotoOptions(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _currentImageUrl != null && _currentImageUrl!.isNotEmpty
                      ? 'Update Medicine Photo'
                      : 'Add Medicine Photo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose an option to capture or upload the photo',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                if (!isDesktop) ...[
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                    ),
                    title: const Text('Take photo'),
                    subtitle: const Text('Use camera to click picture'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  const SizedBox(height: 6),
                ],
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                  ),
                  title: Text(isDesktop ? 'Browse files / photos' : 'Choose from gallery'),
                  subtitle: Text(
                    isDesktop
                        ? 'Pick an image file from your computer'
                        : 'Pick from your saved photos',
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_outline, color: AppColors.error),
                    ),
                    title: Text(
                      'Remove photo',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: () {
                      setState(() {
                        _currentImageUrl = null;
                      });
                      widget.onPhotoChanged?.call(null);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hasImage = _currentImageUrl != null && _currentImageUrl!.trim().isNotEmpty;

    if (hasImage) {
      return _buildImageCard(context, theme, isDark, _currentImageUrl!);
    } else {
      return _buildPlaceholderCard(context, theme, isDark);
    }
  }

  Widget _buildImageCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String imageUrl,
  ) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            GestureDetector(
              onTap: () => _showImagePreview(context, imageUrl),
              child: _buildImageWidget(imageUrl),
            ),

            // Subtle gradient scrim at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 70,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.65),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Top Badge (Category / Dosage Form)
            if (widget.dosageForm != null || widget.category != null)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDosageIcon(
                        widget.dosageForm,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.dosageForm?.label ?? widget.category ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Top Right: Full-screen Preview Button
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.black.withValues(alpha: 0.5),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _showImagePreview(context, imageUrl),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.fullscreen_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Right: Edit / Change Photo Button (if editable)
            if (widget.isEditable)
              Positioned(
                bottom: 12,
                right: 12,
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  elevation: 3,
                  shadowColor: Colors.black.withValues(alpha: 0.3),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => _showPhotoOptions(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.camera_alt, color: Colors.white, size: 15),
                          const SizedBox(width: 6),
                          Text(
                            'Change',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final hasMedicineContext = widget.dosageForm != null || widget.medicineName != null;

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.cardColor,
            isDark
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.primaryContainer.withValues(alpha: 0.35),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: widget.isEditable ? () => _showPhotoOptions(context) : null,
          child: Stack(
            children: [
              // Top-left dosage badge if available
              if (widget.dosageForm != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryDark.withValues(alpha: 0.4)
                          : AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDosageIcon(
                          widget.dosageForm,
                          size: 13,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.dosageForm!.label ?? '',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Center content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primary.withValues(alpha: 0.18)
                            : AppColors.primaryLight.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: hasMedicineContext
                            ? _buildDosageIcon(
                                widget.dosageForm,
                                size: 26,
                                color: AppColors.primary,
                              )
                            : const Icon(
                                Icons.camera_alt_outlined,
                                size: 26,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      hasMedicineContext ? 'No medicine photo' : 'Add medicine photo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (widget.isEditable)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_a_photo_outlined,
                                size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Upload Photo',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        'JPG, PNG or WebP',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.lightTextTertiary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackErrorView(ThemeData theme, bool isDark) {
    return Container(
      color: theme.cardColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 38,
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
            const SizedBox(height: 8),
            Text(
              'Image failed to load',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
