import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';
import 'package:pharmace/Frontend/Sales/model/inv_model.dart';
import 'package:pharmace/Frontend/Sales/model/medicine_bill_model.dart';
import 'package:pharmace/Frontend/Widget/NewBill/medicine_bill_widgets.dart';
import 'package:pharmace/Frontend/Widget/NewBill/new_bill_search_medicine_widget.dart';
import 'package:pharmace/Frontend/Widget/text_feild_widget.dart';
import 'package:pharmace/Frontend/screens/other_screen/bill_details_screen.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Provider/inventory_provider.dart';
import 'package:pharmace/Provider/sales_provider.dart';

class NewBillScreen extends ConsumerStatefulWidget {
  const NewBillScreen({super.key});

  @override
  ConsumerState<NewBillScreen> createState() => _NewBillScreenState();
}

class _NewBillScreenState extends ConsumerState<NewBillScreen> {
  int _selectedCustomerType = 0;
  final _formKey = GlobalKey<FormState>();
  List<MedicineOutputModel> _searchMedicine = [];
  final List<MedicineBillModel> _selectedMedicine = [];
  String _medicineSearchQuery = '';
  final Map<String, (int strip, int loose, double price)> _medicineQuantities =
      {};
  double get totalPrice {
    return _medicineQuantities.values.fold(0.0, (sum, v) => sum + v.$3);
  }

  final Random _random = Random();
  late final int number;
  late final String invId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  PaymentType _paymentType = PaymentType.upi;

  @override
  void initState() {
    super.initState();
    number = 1000 + _random.nextInt(9000);
    invId = 'INV-$number';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // print(totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: Text('New Bill', style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),

                Text('Customer type', style: theme.textTheme.titleLarge),

                SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _customerTypeButton(
                        title: 'Walk-in',
                        isSelected: _selectedCustomerType == 0,
                        onTap: () {
                          setState(() {
                            _selectedCustomerType = 0;
                          });
                        },
                        icon: Icons.trending_up,
                      ),
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: _customerTypeButton(
                        title: 'Online',
                        isSelected: _selectedCustomerType == 1,
                        onTap: () {
                          setState(() {
                            _selectedCustomerType = 1;
                          });
                        },
                        icon: Icons.public,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer name', style: theme.textTheme.titleSmall),
                      SizedBox(height: 10),
                      TextFieldWidget(
                        hintText: 'e.g. Meena Devi',
                        isRequired: true,
                        controller: _nameController,
                      ),
                      SizedBox(height: 15),
                      Text('Phone number', style: theme.textTheme.titleSmall),
                      SizedBox(height: 10),
                      TextFieldWidget(
                        hintText: '+91 987654321',
                        controller: _phoneController,
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            'Reffered by ',
                            style: theme.textTheme.titleSmall,
                          ),
                          Text(
                            '(Optional)',
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFieldWidget(
                        hintText: 'e.g. Doctore name',
                        isRequired: false,
                      ),
                      SizedBox(height: 15),
                      Text('Add Medicine', style: theme.textTheme.titleLarge),

                      SizedBox(height: 10),

                      TextFieldWidget(
                        hintText: 'Search Medicine to add',
                        onChanged: (value) {
                          final query = value.trim().toLowerCase();

                          setState(() {
                            _medicineSearchQuery = query;

                            if (query.isEmpty) {
                              _searchMedicine = [];
                            } else {
                              _searchMedicine = ref
                                  .watch(inventoryProvider)
                                  .allItems
                                  .where((item) {
                                    return item.medicineNmae
                                        .toLowerCase()
                                        .contains(query);
                                  })
                                  .toList();
                            }
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      _searchMedicineList(theme, _medicineSearchQuery),
                      Text(
                        _selectedMedicine.isEmpty ? '' : 'Bill Items',
                        style: theme.textTheme.titleLarge,
                      ),
                      SizedBox(height: 10),
                      _selectedMedicineList(theme),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _createBill(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customerTypeButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.successDark.withValues(alpha: 0.2)
              : AppColors.primaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(width: 2, color: AppColors.primaryLight)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _searchMedicineList(ThemeData theme, String query) {
    final searchQuery = query.trim();
    if (searchQuery.isEmpty) {
      return SizedBox.shrink();
    }
    if (_searchMedicine.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text('No data found', style: theme.textTheme.bodyMedium),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.cardColor,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _searchMedicine.length,
        itemBuilder: (context, index) {
          final medicine = _searchMedicine[index]; // MedicineModel now
          return NewBillSearchMedicineWidget(
            medicineItem: medicine, // ✅ types match
            onAddMedicine: () {
              final alreadyAdded = _selectedMedicine.any(
                (item) => item.id == medicine.id,
              );

              if (alreadyAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('This medicine is already added to the bill'),
                  ),
                );
                return;
              }

              setState(() {
                _selectedMedicine.add(
                  MedicineBillModel(
                    id: medicine.id ?? '',
                    medicineName: medicine.medicineNmae,
                    strip: 1,
                    price: medicine.price,
                    isLooseAv: medicine.isLooseAv,
                    loose: medicine.looseQuantity,
                    tagPrice: medicine.price,
                  ),
                );

                _searchMedicine = [];
              });
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }

  Widget _selectedMedicineList(ThemeData theme) {
    if (_selectedMedicine.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        for (int i = 0; i < _selectedMedicine.length; i++) ...[
          Builder(
            builder: (context) {
              final medicine = _selectedMedicine[i];

              return MedicineBillWidgets(
                key: ValueKey(medicine.id),
                medicineItem: medicine,

                onDelete: () {
                  setState(() {
                    _selectedMedicine.remove(medicine);
                    _medicineQuantities.remove(medicine.id);
                  });
                },

                onQuantityChanged: (stripCount, looseCount, totalPrice) {
                  setState(() {
                    _medicineQuantities[medicine.id] = (
                      stripCount,
                      looseCount,
                      totalPrice,
                    );

                    final index = _selectedMedicine.indexWhere(
                      (item) => item.id == medicine.id,
                    );

                    if (index != -1) {
                      _selectedMedicine[index] = _selectedMedicine[index]
                          .copyWith(
                            strip: stripCount,
                            looseQty: looseCount,
                            totalPrice: double.parse(
                              totalPrice.toStringAsFixed(2),
                            ),
                          );
                    }
                  });
                },
              );
            },
          ),

          if (i < _selectedMedicine.length - 1) Divider(),
        ],
      ],
    );
  }

  Widget _createBill(ThemeData theme) {
    if (_selectedMedicine.isEmpty) {
      return SizedBox.shrink();
    }

    // Cash, UPI and Card are paid.
    // Only Due is unpaid.
    final bool isPaid = _paymentType != PaymentType.due;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '₹${totalPrice.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          Text(
            'Payment',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SegmentedButton<PaymentType>(
              segments: [
                ButtonSegment<PaymentType>(
                  value: PaymentType.cash,
                  label: Text('Cash'),
                  // icon: Icon(Icons.payments_outlined),
                ),
                ButtonSegment<PaymentType>(
                  value: PaymentType.upi,
                  label: Text('UPI'),
                  // icon: Icon(Icons.qr_code_2),
                ),
                ButtonSegment<PaymentType>(
                  value: PaymentType.card,
                  label: Text('Card'),
                  // icon: Icon(Icons.credit_card_outlined),
                ),
                ButtonSegment<PaymentType>(
                  value: PaymentType.due,
                  label: Text('Due'),
                  // icon: Icon(Icons.schedule),
                ),
              ],
              selected: {_paymentType},
              onSelectionChanged: (Set<PaymentType> selection) {
                if (selection.isEmpty) return;

                setState(() {
                  _paymentType = selection.first;
                });
              },
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 14),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isPaid
                  ? Colors.green.withValues(alpha: 0.08)
                  : Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPaid
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.orange.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPaid ? Icons.check_circle : Icons.schedule,
                  size: 20,
                  color: isPaid ? Colors.green : Colors.orange,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isPaid
                        ? 'Payment received via ${_paymentType.name.toUpperCase()}'
                        : 'Payment will be collected later',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isPaid
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () async{
                // Validate first
                if (!(_formKey.currentState?.validate() ?? false)) {
                  return;
                }
                final invModel = InvModel(
                  invNo: invId,
                  customerName: _nameController.text.trim(),
                  date: '5:13 AM',
                  value: double.parse(totalPrice.toStringAsFixed(2)),
                  paymentType: _paymentType,
                  selectedMedicine: List<MedicineBillModel>.from(
                    _selectedMedicine,
                  ),
                  customerType: _selectedCustomerType,
                );
               await ref.read(salesProvider.notifier).addItem(invModel);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => BillDetailsScreen(invId: invId),
                  ),
                );
              },
              icon: Icon(
                isPaid ? Icons.receipt_long : Icons.receipt_long_outlined,
                color: Colors.white,
              ),
              label: Text(
                isPaid ? 'Generate & Mark as Paid' : 'Generate Bill',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
