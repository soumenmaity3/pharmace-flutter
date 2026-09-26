import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Frontend/Sales/model/inv_model.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/Provider/database_provider.dart';

final salesProvider = StateNotifierProvider<SalesNotifier, SalesState>((ref) {
  final db = ref.watch(databaseProvider);
  return SalesNotifier(db);
});

class SalesNotifier extends StateNotifier<SalesState> {
  AppDatabase db;
  SalesNotifier(this.db)
    : super(SalesState(allItems: [], filterItems: [], search: '')) {
    loadAllBill();
  }

  Future<void> loadAllBill() async {
    final items = await db.billDao.getAllBills();
    state = state.copyWith(allItems: items, filterItems: items);
  }

  Future<void> addItem(InvModel model) async {
    final updateList = [...state.allItems, model];
    state = state.copyWith(allItems: updateList, filterItems: updateList);
    await db.billDao.insertBill(model);
  }

  Future<void> updatePaymentType(String invNo, PaymentType type)async {
    final updatedList = state.allItems.map((item) {
      if (item.invNo == invNo) {
        return item.copyWith(paymentType: type);
      }
      return item;
    }).toList();
await db.billDao.updatePaymenType(invNo: invNo, paymentType: type);
    state = state.copyWith(allItems: updatedList, filterItems: updatedList);
  }

  void searchItem(String query) {
    final searchQuery = query.toLowerCase().trim();
    state = state.copyWith(
      filterItems: _searchItem(state.allItems, searchQuery),
    );
  }

  List<InvModel> _searchItem(List<InvModel> item, String query) {
    if (query.isEmpty) {
      return item;
    }
    return item.where((item) {
      return item.customerName.toLowerCase().contains(query) ||
          item.invNo.toLowerCase().contains(query) ||
          item.value.toString().contains(query);
    }).toList();
  }

  void filterItem(String query) {
    final filterQuery = query.toLowerCase().trim();
    if (filterQuery == 'all') {
      state = state.copyWith(filterItems: state.allItems);
      return;
    }
    state = state.copyWith(
      filterItems: _filterItem(state.allItems, filterQuery),
    );
  }

  List<InvModel> _filterItem(List<InvModel> items, String query) {
    return items.where((item) {
      return item.paymentType.toString().toLowerCase().contains(query);
    }).toList();
  }
}

class SalesState {
  final List<InvModel> allItems;
  final List<InvModel> filterItems;
  final String search;

  SalesState({
    required this.allItems,
    required this.filterItems,
    required this.search,
  });
  SalesState copyWith({
    List<InvModel>? allItems,
    List<InvModel>? filterItems,
    String? search,
  }) {
    return SalesState(
      allItems: allItems ?? this.allItems,
      filterItems: filterItems ?? this.filterItems,
      search: search ?? this.search,
    );
  }
}
