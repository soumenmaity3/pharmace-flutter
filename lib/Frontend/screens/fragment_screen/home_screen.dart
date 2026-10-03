import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmace/Frontend/Home/data/expiring_soon_data.dart';
import 'package:pharmace/Frontend/Home/data/inventory_health_data.dart';
import 'package:pharmace/Frontend/Home/data/low_stock_list_data.dart';
import 'package:pharmace/Frontend/Home/data/quick_action_data.dart';
import 'package:pharmace/Frontend/Home/data/recent_sales_data.dart';
import 'package:pharmace/Frontend/Home/widgets/open_close_bottom_sheet_widget.dart';
import 'package:pharmace/Frontend/Widget/employee_status_dialog.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Frontend/Home/widgets/expiring_soon_widget.dart';
import 'package:pharmace/Frontend/Home/widgets/inventory_health_widget.dart';
import 'package:pharmace/Frontend/Home/widgets/low_stock_widget.dart';
import 'package:pharmace/Frontend/Home/widgets/quick_action_widget.dart';
import 'package:pharmace/Frontend/Home/widgets/recent_sales_widget.dart';
import 'package:pharmace/Frontend/Home/widgets/sales_overview_card.dart';
import 'package:pharmace/Provider/owner_provider.dart';
import 'package:pharmace/Provider/recent_sales_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/Frontend/Profile/screens/notification_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  OverlayEntry? _shopOverlayEntry;
  final LayerLink _shopLayerLink = LayerLink();
  bool _isShopDropdownOpen = false;

  void _toggleShopDropdown() {
    if (_isShopDropdownOpen) {
      _removeShopOverlay();
    } else {
      _showShopOverlay();
    }
  }

  void _showShopOverlay() {
    final shops = ref.read(shopProvider).valueOrNull ?? [];
    if (shops.isEmpty) return; // nothing to show
    _shopOverlayEntry = _createShopOverlayEntry(shops);
    Overlay.of(context).insert(_shopOverlayEntry!);
    setState(() => _isShopDropdownOpen = true);
  }

  void _removeShopOverlay() {
    _shopOverlayEntry?.remove();
    _shopOverlayEntry = null;
    if (mounted) {
      setState(() => _isShopDropdownOpen = false);
    } else {
      _isShopDropdownOpen = false;
    }
  }

  OverlayEntry _createShopOverlayEntry(List<ShopTableData> shops) {
    final selectedShop = ref.read(selectedShopProvider);
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap-outside barrier to dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeShopOverlay,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          // The dropdown itself
          Positioned(
            width: 250,
            child: CompositedTransformFollower(
              link: _shopLayerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 24), // just below the shop name row
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(10),
                shadowColor: Colors.black26,
                color: Theme.of(context).cardColor,
                clipBehavior: Clip.antiAlias,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: shops.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final shop = shops[index];
                    final isSelected = shop.id == selectedShop?.id;
                    return ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      leading: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              size: 18,
                              color: Colors.blue,
                            )
                          : const Icon(Icons.storefront, size: 18),
                      title: Text(
                        shop.shopName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        ref.read(shopProvider.notifier).selectShop(shop.id);
                        _removeShopOverlay();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _shopOverlayEntry?.remove();
    _shopOverlayEntry = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(salesProvider.notifier).addSales();
    // });
  }

  bool isDeliveryEnabled = false;

  @override
  Widget build(BuildContext context) {
    print('build1');
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
          }
        } on SocketException catch (_) {
          print('not connected');
        }
      },
      displacement: 100.0,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Text(
                            "Good evening,",
                            style: theme.textTheme.labelMedium,
                          ),
                          Text(
                            ref.watch(ownerProvider).value?.name ?? '',
                            style: theme.textTheme.titleLarge,
                          ),
                          SizedBox(height: 5),
                          Consumer(
                            builder: (_, ref, _) {
                              final shopName =
                                  ref.watch(
                                    selectedShopProvider.select(
                                      (s) => s?.shopName,
                                    ),
                                  ) ??
                                  'No shop selected';
                              final verifyStatus = ref.watch(
                                selectedShopProvider.select(
                                  (s) => s?.verifyStatus,
                                ),
                              );

                              return CompositedTransformTarget(
                                link: _shopLayerLink,
                                child: InkWell(
                                  onTap: _toggleShopDropdown,
                                  child: Row(
                                    children: [
                                      Text(
                                        _shortShopName(shopName),
                                        style: theme.textTheme.labelSmall,
                                      ),
                                      const SizedBox(width: 5),
                                      _verificationStatus(
                                        _mapVerifyStatus(verifyStatus),
                                      ),
                                      const SizedBox(width: 4),
                                      FaIcon(
                                        _isShopDropdownOpen
                                            ? FontAwesomeIcons.angleUp
                                            : FontAwesomeIcons.angleDown,
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _deliveryStatus(
                            isAvailable: isDeliveryEnabled,
                            onTap: () {
                              _showDeliveryStatusBottomSheet(
                                context: context,
                                isCurrentlyAvailable: isDeliveryEnabled,
                                onToggle: () async {
                                  Navigator.pop(context);

                                  setState(() {
                                    isDeliveryEnabled = !isDeliveryEnabled;
                                  });
                                  // Optional: Call your API / Riverpod provider to update backend
                                  // await ref.read(shopProvider.notifier).updateDeliveryStatus(isDeliveryEnabled);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isDeliveryEnabled
                                            ? 'Delivery service enabled.'
                                            : 'Delivery service paused.',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(width: 10),
                          Consumer(
                            builder: (_, ref, _) {
                              final selectedShop = ref.watch(
                                selectedShopProvider,
                              );
                              return OpenCloseSwitchWidget(
                                key: ValueKey(selectedShop?.id),
                                initialIsOpen: selectedShop?.isOpen ?? true,
                                onStatusChanged: (value) async {
                                  if (selectedShop != null) {
                                    final res = await ref
                                        .read(shopProvider.notifier)
                                        .updateShopStatus(
                                          selectedShop.id,
                                          value,
                                        );

                                    final success =
                                        res.statusCode >= 200 &&
                                        res.statusCode < 300;

                                    if (!success && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            res.message ??
                                                'Failed to update status',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                    return success;
                                  }
                                  return false;
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Material(
                            color:
                                theme.cardTheme.color ??
                                theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const NotificationScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(
                                      Icons.notifications_outlined,
                                      size: 20,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    Positioned(
                                      right: -1,
                                      top: -1,
                                      child: Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                        ),
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
                  SizedBox(height: 10,),
                  _operationalPulseCard(theme,context),
                  SizedBox(height: 16),
                  _businessPulseCard(),
                  SizedBox(height: 16),
                  SalesOverviewCard(),
                  SizedBox(height: 10),
                  Text("Quick Actions", style: theme.textTheme.titleLarge),
                  SizedBox(height: 10),
                  _quickAnction(),
                  SizedBox(height: 5),
                  Text("Inventory Health", style: theme.textTheme.titleLarge),
                  SizedBox(height: 10),
                  _inventoryHealth(),
                  Text(
                    "Low stock medicines",
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 10),
                  _lowStockMedicineList(theme),
                  SizedBox(height: 10),
                  Text("Expiring Soon", style: theme.textTheme.titleLarge),
                  SizedBox(height: 10),
                  _expiringSoonList(theme),
                  SizedBox(height: 10),
                  Text("Recent Sales", style: theme.textTheme.titleLarge),
                  SizedBox(height: 10),
                  _recentSales(theme),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _shortShopName(String name) {
    if (name.length <= 25) {
      return name;
    }

    return '${name.substring(0, 15)}...';
  }

  ShopVerificationStatus _mapVerifyStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'verified':
        return ShopVerificationStatus.verified;
      case 'rejected':
        return ShopVerificationStatus.rejected;
      default:
        return ShopVerificationStatus.pending;
    }
  }

  Container _recentSales(ThemeData theme) {
    final salesState = ref.watch(recentSalesProvider);
    final sales = salesState.filterSales;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: sales.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              RecentSalesWidget(recentSalesItem: item),
              if (index < recentSalesdata.length - 1) Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Container _expiringSoonList(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: expiringSoonData.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ExpiringSoonWidget(expiringSoonItem: item),
              if (index < expiringSoonData.length - 1) Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Container _lowStockMedicineList(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: lowStockListData.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Column(
            children: [
              LowStockWidget(lowStockListItem: item),
              if (index < lowStockListData.length - 1) Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  GridView _inventoryHealth() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: inventoryHealthData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2,
      ),
      itemBuilder: ((context, index) => InventoryHealthWidget(
        inventoryHealthItem: inventoryHealthData[index],
      )),
    );
  }

  SizedBox _quickAnction() {
    return SizedBox(
      height: 95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: quickActionData.map((item) {
          return QuickActionWidget(
            quickActionItem: item,
            onTap: () {
              if (item.title == 'Employee' || item.title == 'Reports') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item.screen),
                );
                return;
              }
              final isSelf = ref.read(
                selectedShopProvider.select((shop) => shop?.isOwnerEmployee),
              );

              if (isSelf == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item.screen),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return EmployeeStatusDialog();
                  },
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _deliveryStatus({
    required VoidCallback onTap,
    bool isAvailable = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isAvailable
                  ? AppColors.primaryContainer
                  : AppColors.pharmacistBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delivery_dining_outlined,
              color: isAvailable ? AppColors.primary : AppColors.black,
              size: 22,
            ),
          ),

          // Corner indicator
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isAvailable ? AppColors.primaryLight : AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isAvailable ? Icons.check : Icons.not_interested,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeliveryStatusBottomSheet({
    required BuildContext context,
    required bool isCurrentlyAvailable,
    required VoidCallback onToggle,
  }) {
    final theme = Theme.of(context);
    final isTurningOff = isCurrentlyAvailable;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isTurningOff
                          ? AppColors.error.withValues(alpha: 0.12)
                          : AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delivery_dining_outlined,
                      color: isTurningOff ? AppColors.error : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTurningOff
                              ? 'Pause deliveries?'
                              : 'Turn on deliveries?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isTurningOff
                              ? 'Customers will not be able to order for home delivery.'
                              : 'Accept new orders for home delivery.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onToggle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isTurningOff
                      ? AppColors.error
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isTurningOff ? 'Pause Delivery' : 'Enable Delivery',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _businessPulseCard(
  /*{
  required String totalRevenue,
  required String todaySales,
  required String orders,
  required String avgOrder
}*/
) {
  return Container(
    height: 198,
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(20),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned(
            top: -55,
            right: -45,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: AppColors.lightBackground.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 10,
            right: 20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.lightBorder.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(22, 20, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's revenue",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            '₹24,850',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            size: 15,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '12.5%',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 19),

                // Divider
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.12),
                ),

                const Spacer(),

                // Statistics
                Row(
                  children: [
                    Expanded(
                      child: _businessStat(value: '126', label: 'Sales today'),
                    ),

                    _verticalDivider(),

                    Expanded(
                      child: _businessStat(value: '98', label: 'Orders'),
                    ),

                    _verticalDivider(),

                    Expanded(
                      child: _businessStat(value: '₹252', label: 'Avg. order'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _businessStat({required String value, required String label}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),

      const SizedBox(height: 4),

      Text(
        label,
        style: TextStyle(
          color: AppColors.whiteText60.withValues(alpha: 0.55),
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

Widget _verticalDivider() {
  return Container(
    width: 1,
    height: 32,
    color: AppColors.whiteText60.withValues(alpha: 0.12),
  );
}

Widget _sectionHeader(
    ThemeData theme, {
      required String title,
      required String subtitle,
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: theme.textTheme.titleLarge),
      const SizedBox(height: 3),
      Text(subtitle, style: theme.textTheme.bodySmall),
    ],
  );
}
Widget _operationalPulseCard(ThemeData theme,BuildContext context) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const NotificationScreen()),
      );
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: .22)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.priority_high_rounded,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Operations need attention',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${lowStockListData.length} low-stock items · ${expiringSoonData.length} expiring batches',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.warning),
        ],
      ),
    ),
  );
}


enum ShopVerificationStatus { verified, pending, rejected }

Widget _verificationStatus(ShopVerificationStatus status) {
  switch (status) {
    case ShopVerificationStatus.verified:
      return const Icon(Icons.verified_rounded, size: 15, color: Colors.blue);

    case ShopVerificationStatus.pending:
      return const Icon(Icons.pending_rounded, size: 15, color: Colors.orange);

    case ShopVerificationStatus.rejected:
      return const Icon(Icons.cancel_rounded, size: 15, color: Colors.red);
  }
}
