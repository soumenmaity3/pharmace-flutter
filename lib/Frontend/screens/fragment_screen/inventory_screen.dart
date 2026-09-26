import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';
import 'package:pharmace/Frontend/Inventory/widget/medicine_list_widget.dart';
import 'package:pharmace/Frontend/Sales/widget/sales_search_bar.dart';
import 'package:pharmace/Frontend/Widget/employee_status_dialog.dart';
import 'package:pharmace/Frontend/screens/other_screen/add_medicine_screen.dart';
import 'package:pharmace/Frontend/screens/other_screen/medicine_details_screen.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/Provider/inventory_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  bool _isLoading = false;
  String? _currentShopId;

  // Pagination state
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedShopId = ref.read(selectedShopProvider)?.id;
      if (selectedShopId != null) {
        _currentShopId = selectedShopId;
        _fetchInventory(page: 0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll - 200) &&
        !_isLoading &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await _fetchInventory(page: _currentPage + 1);
  }

  Future<void> _fetchInventory({int page = 0}) async {
    final shopId = ref.read(selectedShopProvider)?.id;
    if (shopId == null || shopId.isEmpty) return;

    if (page == 0) {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _currentPage = 0;
          _hasMore = true;
        });
      }
    }

    try {
      final response = await ref
          .read(inventoryProvider.notifier)
          .fetchAndSyncFromBackend(shopId: shopId, page: page, size: 20);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final fetchedList = response.data ?? [];
        if (mounted) {
          setState(() {
            _hasMore = fetchedList.length >= 20;
            _currentPage = page;
          });
        }
      } else if (mounted &&
          (response.statusCode < 200 || response.statusCode >= 300) &&
          response.message != null &&
          response.message!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error fetching inventory: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  String _formatWorth(double worth) {
    if (worth >= 100000) {
      return '₹${(worth / 100000).toStringAsFixed(2)}L';
    } else if (worth >= 1000) {
      return '₹${(worth / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${worth.toStringAsFixed(2)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Listen for shop changes and refresh inventory automatically
    ref.listen<ShopTableData?>(selectedShopProvider, (previous, next) {
      if (next?.id != null && next?.id != _currentShopId) {
        _currentShopId = next!.id;
        _fetchInventory(page: 0);
      }
    });

    final allItems = ref.watch(
      inventoryProvider.select((items) => items.allItems),
    );
    final totalCount = allItems.length;
    final totalWorth = allItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.stockValue),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inventory', style: theme.textTheme.titleLarge),
          actions: [
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: () {
                  final isSelf =
                      ref.read(
                        selectedShopProvider.select(
                          (shop) => shop?.isOwnerEmployee,
                        ),
                      ) ??
                      false;

                  if (isSelf) {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => const AddMedicineScreen(),
                          ),
                        )
                        .then((_) {
                          // Refresh inventory when returning from Add Medicine
                          _fetchInventory(page: 0);
                        });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EmployeeStatusDialog();
                      },
                    );
                  }
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
        body: RefreshIndicator(
          onRefresh: () => _fetchInventory(page: 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        totalCount.toString(),
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'medicines · worth',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatWorth(totalWorth),
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SalesSearchBar(
                    onChanged: (value) {
                      final query = value.toLowerCase().trim();
                      ref.read(inventoryProvider.notifier).search(query);
                    },
                    onFilterTap: () {
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                        items: const [
                          PopupMenuItem(value: 'all', child: Text('All')),
                          PopupMenuItem(
                            value: 'inStock',
                            child: Text('In Stock'),
                          ),
                          PopupMenuItem(
                            value: 'lowStock',
                            child: Text('Low Stock'),
                          ),
                          PopupMenuItem(
                            value: 'outOfStock',
                            child: Text('Out of Stock'),
                          ),
                          PopupMenuItem(value: 'loose', child: Text('Loose')),
                          PopupMenuItem(
                            value: 'expiring',
                            child: Text('Expiring'),
                          ),
                        ],
                      ).then((value) {
                        if (value != null) {
                          ref.read(inventoryProvider.notifier).filter(value);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (_, ref, _) {
                      final filteredMedData = ref.watch(
                        inventoryProvider.select(
                          (items) => items.filteredItems,
                        ),
                      );
                      return _medicineList(theme, filteredMedData);
                    },
                  ),
                  if (_isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
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

  Widget _medicineList(
    ThemeData theme,
    List<MedicineOutputModel> filteredMedData,
  ) {
    if (_isLoading && filteredMedData.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 250,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Fetching inventory...'),
            ],
          ),
        ),
      );
    }

    return filteredMedData.isNotEmpty
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: theme.cardColor,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredMedData.length,
              itemBuilder: (context, index) {
                return MedicineListWidget(
                  medicineItem: filteredMedData[index],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MedicineDetailsScreen(
                          medicineItem: filteredMedData[index],
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
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
                    child: SvgPicture.asset(
                      'assets/icons/inventory_outline.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.success,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "No Inventory found",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Inventory items will appear here once you add them\n'
                    ' or when they match your search.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
  }
}
