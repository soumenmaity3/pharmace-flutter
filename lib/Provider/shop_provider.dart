import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/model/api_response.dart';
import 'package:pharmace/Backend/model/Output/shop_return_model.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/Provider/database_provider.dart';
import 'package:pharmace/Provider/owner_provider.dart';

/// All shops for the current owner
final shopProvider = AsyncNotifierProvider<ShopNotifier, List<ShopTableData>>(
  () {
    return ShopNotifier();
  },
);

class ShopNotifier extends AsyncNotifier<List<ShopTableData>> {
  @override
  Future<List<ShopTableData>> build() async {
    final db = ref.watch(databaseProvider);
    return await db.shopDao.getAllShops();
  }

  Future<void> saveShops(List<ShopReturnModel> shops) async {
    final db = ref.read(databaseProvider);
    await db.shopDao.syncShops(shops);
    // Re-fetch from DB to get correct ShopTableData objects
    state = AsyncData(await db.shopDao.getAllShops());
  }

  /// Select a shop by ID — persists to OwnerAuthTable and refreshes ownerProvider
  Future<void> selectShop(String shopId) async {
    final db = ref.read(databaseProvider);
    await db.ownerAuthDao.updateSelectedShop(shopId);
    ref.invalidate(ownerProvider);
  }

  /// Update shop status: First backend update, then Drift update
  Future<ApiResponse<bool>> updateShopStatus(String shopId, bool isOpen) async {
    // 1. First: Call backend API
    final response = await ApiService().toggleShopStatus(shopId);

    // 2. Second: If backend succeeds, update Drift database
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final db = ref.read(databaseProvider);
      final newStatus = response.data ?? isOpen;
      await db.shopDao.updateShopStatus(shopId, newStatus);
      state = AsyncData(await db.shopDao.getAllShops());
    }

    return response;
  }

  /// Update owner employee status in Drift and update state
  Future<void> updateOwnerEmployeeStatus(String shopId, bool isOwnerEmployee) async {
    final db = ref.read(databaseProvider);
    await db.shopDao.updateOwnerEmployeeStatus(shopId, isOwnerEmployee);
    state = AsyncData(await db.shopDao.getAllShops());
  }
}

/// The currently selected shop, derived reactively from owner + shop list
final selectedShopProvider = Provider<ShopTableData?>((ref) {
  final ownerAsync = ref.watch(ownerProvider);
  final shopsAsync = ref.watch(shopProvider);

  final owner = ownerAsync.valueOrNull;
  final shops = shopsAsync.valueOrNull;

  if (owner == null || shops == null || shops.isEmpty) return null;

  final selectedId = owner.selectedShopId;

  if (selectedId == null) {
    // No shop explicitly selected — default to the first shop
    return shops.first;
  }

  // Find the matching shop, fallback to first if ID no longer exists
  return shops.firstWhere((s) => s.id == selectedId, orElse: () => shops.first);
});
