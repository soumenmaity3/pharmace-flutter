import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _period = 'Month';

  static const _periods = ['Week', 'Month', 'Quarter'];
  static const _reportCategories = [
    'Sales',
    'Inventory',
    'Purchases',
    'Customers',
  ];
  static const _topMedicines = [
    ('Paracetamol 500mg', '₹850K'),
    ('ORS Sachet', '₹1,680K'),
    ('Cetirizine 10mg', '₹263K'),
    ('Azithromycin 250mg', '₹1,152K'),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        actions: [
          TextButton.icon(
            onPressed: () => _showMessage('Report export is being prepared.'),
            style: TextButton.styleFrom(
              overlayColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            icon: SvgPicture.asset(
              'assets/icons/export.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            label: Text('Export'),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PeriodTabs(
                periods: _periods,
                selected: _period,
                onChanged: (value) => setState(() => _period = value),
              ),
              const SizedBox(height: 28),
              Text(
                'Net profit this ${_period.toLowerCase()}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹1,86,400',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 36,
                      height: 1.1,
                      letterSpacing: -1.2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.north_east,
                          size: 16,
                          color: appColors.success,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '9.4%',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: appColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                '₹6.4L revenue − ₹4.53L cost of goods',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: appColors.textTertiary,
                ),
              ),
              const SizedBox(height: 28),
              _SnapshotGrid(colors: appColors),
              const SizedBox(height: 30),
              _ReportLinks(
                categories: _reportCategories,
                border: appColors.border,
                onTap: (category) => _showMessage('$category report selected'),
              ),
              const SizedBox(height: 30),
              const _SectionTitle(title: 'Top-selling medicines'),
              const SizedBox(height: 5),
              _RankedMedicineList(
                items: _topMedicines,
                border: appColors.border,
                colors: appColors,
              ),
              const SizedBox(height: 30),
              const _SectionTitle(title: 'Payment collection'),
              const SizedBox(height: 10),
              _PaymentBreakdown(colors: appColors, border: appColors.border),
              const SizedBox(height: 26),
              _InventoryAlert(
                label: '18 medicines low on stock',
                border: appColors.border,
                warning: appColors.warning,
                onTap: () => _showMessage('Low-stock inventory selected'),
              ),
              _InventoryAlert(
                label: '12 medicines expiring soon',
                border: appColors.border,
                warning: appColors.warning,
                onTap: () => _showMessage('Expiring inventory selected'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs({
    required this.periods,
    required this.selected,
    required this.onChanged,
  });
  final List<String> periods;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeExtension>()!;
    return Row(
      children: periods.map((period) {
        final isSelected = period == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 24),
          child: GestureDetector(
            onTap: () => onChanged(period),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    period,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? colors.textPrimary
                          : colors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 2.5,
                    width: 38,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ReportLinks extends StatelessWidget {
  const _ReportLinks({
    required this.categories,
    required this.border,
    required this.onTap,
  });
  final List<String> categories;
  final Color border;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(categories.length, (index) {
      final category = categories[index];
      return GestureDetector(
        onTap: () => onTap(category),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: index == 0 ? null : Border(top: BorderSide(color: border)),
          ),
          child: Row(
            children: [
              Expanded(child: Text('$category report')),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      );
    }),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title}) : onAction = null, action = null;
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              overlayColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            child: Text(action!),
          ),
      ],
    );
  }
}

class _RankedMedicineList extends StatelessWidget {
  const _RankedMedicineList({
    required this.items,
    required this.border,
    required this.colors,
  });
  final List<(String, String)> items;
  final Color border;
  final AppThemeExtension colors;

  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(items.length, (index) {
      final item = items[index];
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: index == 0 ? null : Border(top: BorderSide(color: border)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: Text(
                '${index + 1}',
                style: TextStyle(color: colors.textTertiary),
              ),
            ),
            Expanded(child: Text(item.$1, overflow: TextOverflow.ellipsis)),
            Text(item.$2, style: TextStyle(color: colors.textSecondary)),
          ],
        ),
      );
    }),
  );
}

class _SnapshotGrid extends StatelessWidget {
  const _SnapshotGrid({required this.colors});
  final AppThemeExtension colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Row(
      children: [
        Expanded(
          child: _SnapshotTile(
            icon: Icons.receipt_long_outlined,
            label: 'Orders',
            value: '2,548',
            detail: '+8.2% vs last month',
            accent: primary,
            tint: theme.colorScheme.primaryContainer,
            colors: colors,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SnapshotTile(
            icon: Icons.shopping_bag_outlined,
            label: 'Average order',
            value: '₹252',
            detail: '+₹18 vs last month',
            accent: colors.success,
            tint: colors.successContainer,
            colors: colors,
          ),
        ),
      ],
    );
  }
}

class _SnapshotTile extends StatelessWidget {
  const _SnapshotTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
    required this.accent,
    required this.tint,
    required this.colors,
  });
  final IconData icon;
  final String label;
  final String value;
  final String detail;
  final Color accent;
  final Color tint;
  final AppThemeExtension colors;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: colors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 17, color: accent),
        ),
        const SizedBox(height: 14),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 3),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 5),
        Text(
          detail,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: accent),
        ),
      ],
    ),
  );
}

class _PaymentBreakdown extends StatelessWidget {
  const _PaymentBreakdown({required this.colors, required this.border});
  final AppThemeExtension colors;
  final Color border;

  @override
  Widget build(BuildContext context) {
    const payments = [
      ('UPI', '₹3.18L', 50),
      ('Cash', '₹1.92L', 30),
      ('Card', '₹1.30L', 20),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: List.generate(payments.length, (index) {
          final payment = payments[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              border: index == 0
                  ? null
                  : Border(top: BorderSide(color: border)),
            ),
            child: Row(
              children: [
                _PaymentDot(index: index),
                const SizedBox(width: 10),
                Expanded(child: Text(payment.$1)),
                Text(
                  '${payment.$3}%',
                  style: TextStyle(color: colors.textTertiary),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: 52,
                  child: Text(
                    payment.$2,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _PaymentDot extends StatelessWidget {
  const _PaymentDot({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.primary,
      const Color(0xFF4B81B8),
      const Color(0xFFA9791F),
    ];
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(color: colors[index], shape: BoxShape.circle),
    );
  }
}

class _InventoryAlert extends StatelessWidget {
  const _InventoryAlert({
    required this.label,
    required this.border,
    required this.warning,
    required this.onTap,
  });
  final String label;
  final Color border;
  final Color warning;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: warning)),
          ),
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
    ),
  );
}
