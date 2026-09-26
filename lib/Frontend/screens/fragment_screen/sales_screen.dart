import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Frontend/Sales/data/short_review_data.dart';
import 'package:pharmace/Frontend/Sales/model/inv_model.dart';
import 'package:pharmace/Frontend/Sales/widget/inv_widget.dart';
import 'package:pharmace/Frontend/Sales/widget/sales_search_bar.dart';
import 'package:pharmace/Frontend/Sales/widget/short_review_widget.dart';
import 'package:pharmace/Frontend/screens/other_screen/bill_details_screen.dart';
import 'package:pharmace/Frontend/screens/other_screen/new_bill_screen.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Provider/sales_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final sales = ref.watch(salesProvider);
    // List<InvModel> filteredInvData = sales.filterItems;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sales', style: theme.textTheme.titleLarge),
          actions: [
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
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => NewBillScreen()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          titlePadding: const EdgeInsets.fromLTRB(
                            24,
                            24,
                            24,
                            8,
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(
                            24,
                            8,
                            24,
                            16,
                          ),
                          actionsPadding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            16,
                          ),

                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.info_outline,
                                  color: Colors.orange,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Employee Status',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          content: const Text(
                            'You haven’t marked yourself as an employee yet. '
                            'Please update your employee status before continuing.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),

                          actions: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Got it',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                _shortReview(),
                SizedBox(height: 10),
                SalesSearchBar(
                  onChanged: (value) {
                    final query = value.toLowerCase().trim();
                    ref.read(salesProvider.notifier).searchItem(query);
                  },
                  onFilterTap: () {
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(100, 200, 0, 0),
                      items: [
                        PopupMenuItem(value: 'all', child: const Text('All')),
                        PopupMenuItem(value: 'due', child: const Text('Due')),
                        PopupMenuItem(value: 'upi', child: const Text('UPI')),
                        PopupMenuItem(value: 'cash', child: const Text('Cash')),
                        PopupMenuItem(value: 'card', child: const Text('Card')),
                        PopupMenuItem(
                          value: 'refunded',
                          child: const Text('Refunded'),
                        ),
                        // PopupMenuItem(value: 'date', child: const Text('Date')),
                      ],
                    ).then((value) {
                      if (value != null) {
                        ref.read(salesProvider.notifier).filterItem(value);
                      }
                    });
                  },
                ),
                SizedBox(height: 10),
                Consumer(
                  builder: (_, ref, _) {
                    final filteredInvData = ref.watch(
                      salesProvider.select((item) => item.filterItems),
                    );
                    return _invList(theme, filteredInvData);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _invList(ThemeData theme, List<InvModel> filteredInvData) {
    return filteredInvData.isNotEmpty
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
              itemCount: filteredInvData.length,
              itemBuilder: (context, index) {
                return InvWidget(
                  invItem: filteredInvData[index],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BillDetailsScreen(
                          invId: filteredInvData[index].invNo,
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
                    width: 0,
                    decoration: BoxDecoration(
                      color: AppColors.successDark.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: AppColors.success,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text("No sales found", style: theme.textTheme.titleMedium),

                  const SizedBox(height: 5),

                  Text(
                    'Sales will appear here once you add a sale\n'
                    'or when a transaction matches your search.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
  }

  SizedBox _shortReview() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shortReviewData.length,
        itemBuilder: (context, index) {
          return ShortReviewWidget(shortReviewItem: shortReviewData[index]);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 24);
        },
      ),
    );
  }
}
