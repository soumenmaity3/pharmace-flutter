import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';

class OpenCloseBottomSheetWidget extends StatelessWidget {
  const OpenCloseBottomSheetWidget({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Close your shop?', style: theme.textTheme.titleLarge),
          SizedBox(height: 10),
          Text(
            'Staff and customers will see the shop marked as closed, and new sales will be paused until you reopen.',
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onTap,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.error),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              elevation: const WidgetStatePropertyAll(0),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            child: const Text('Close Shop'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
              foregroundColor: WidgetStatePropertyAll(appColors.textPrimary),

              // Removes hover, pressed and focus overlay
              overlayColor: WidgetStatePropertyAll(Colors.transparent),

              elevation: WidgetStatePropertyAll(0),

              padding: WidgetStatePropertyAll(
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),

              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: appColors.border, width: 1),
                ),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(color: appColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

typedef StatusChangeCallback = FutureOr<bool?> Function(bool value);

class OpenCloseSwitchWidget extends StatefulWidget {
  final bool initialIsOpen;
  final StatusChangeCallback? onStatusChanged;

  const OpenCloseSwitchWidget({
    super.key,
    this.initialIsOpen = true,
    this.onStatusChanged,
  });

  @override
  State<OpenCloseSwitchWidget> createState() => _OpenCloseSwitchWidgetState();
}

class _OpenCloseSwitchWidgetState extends State<OpenCloseSwitchWidget> {
  late bool _isOpen;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.initialIsOpen;
  }

  @override
  void didUpdateWidget(covariant OpenCloseSwitchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIsOpen != widget.initialIsOpen) {
      setState(() {
        _isOpen = widget.initialIsOpen;
      });
    }
  }

  Future<void> _toggle() async {
    // Ignore repeated taps until the current status update has finished.
    if (_isUpdating) return;

    if (_isOpen) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return OpenCloseBottomSheetWidget(
            onTap: () async {
              if (_isUpdating) return;

              setState(() {
                _isUpdating = true;
              });
              Navigator.pop(context);
              setState(() {
                _isOpen = false;
              });

              try {
                final result = await widget.onStatusChanged?.call(false);
                if (result == false && mounted) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              } finally {
                if (mounted) {
                  setState(() {
                    _isUpdating = false;
                  });
                }
              }
            },
          );
        },
      );
    } else {
      setState(() {
        _isOpen = true;
        _isUpdating = true;
      });

      try {
        final result = await widget.onStatusChanged?.call(true);
        if (result == false && mounted) {
          setState(() {
            _isOpen = false;
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUpdating = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Shop status toggle',
      value: _isOpen ? 'Open' : 'Closed',
      toggled: _isOpen,
      child: GestureDetector(
        onTap: _isUpdating ? null : _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 90,
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _isOpen ? AppColors.successDark : AppColors.errorDark,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: _isOpen
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    _isOpen ? 'OPEN' : 'CLOSED',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: _isOpen
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isOpen ? Icons.check : Icons.close,
                    size: 16,
                    color: _isOpen
                        ? AppColors.successDark
                        : AppColors.errorDark,
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
