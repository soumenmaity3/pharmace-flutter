import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Frontend/Home/data/recent_sales_data.dart';
import 'package:pharmace/Frontend/Home/model/recent_sales_model.dart';

final recentSalesProvider = StateNotifierProvider<SalesNotifier, RecentSalesState>((ref) {
  return SalesNotifier();
});

class SalesNotifier extends StateNotifier<RecentSalesState> {
  SalesNotifier()
    : super(
        RecentSalesState(
          allSales: recentSalesdata.toList(),
          filterSales: recentSalesdata.toList(),
          search: '',
        ),
      );
  void addSales() {
    List<RecentSalesModel> item = recentSalesdata;
    state = state.copyWith(
      allSales: item.toList(),
      filterSales: item.toList(),
      search: '',
    );
  }
}

class RecentSalesState {
  final List<RecentSalesModel> allSales;
  final List<RecentSalesModel> filterSales;
  final String search;

  RecentSalesState({
    required this.allSales,
    required this.filterSales,
    required this.search,
  });
  RecentSalesState copyWith({
    List<RecentSalesModel>? allSales,
    List<RecentSalesModel>? filterSales,
    String? search,
  }) {
    return RecentSalesState(
      allSales: allSales ?? this.allSales,
      filterSales: filterSales ?? this.filterSales,
      search: search ?? this.search,
    );
  }
}
