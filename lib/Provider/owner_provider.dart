import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/model/Input/shop_owner_model.dart';
import 'package:pharmace/Provider/database_provider.dart';

final ownerProvider = AsyncNotifierProvider<OwnerNotifier, ShopOwnerModel?>(
  OwnerNotifier.new,
);

class OwnerNotifier extends AsyncNotifier<ShopOwnerModel?> {
  @override
  FutureOr<ShopOwnerModel?> build() async {
    final db = ref.watch(databaseProvider);
    return await db.ownerAuthDao.getOwner();
  }

  /// Save or update owner and update Riverpod state immediately
  Future<void> saveOwner(ShopOwnerModel owner) async {
    final db = ref.read(databaseProvider);
    await db.ownerAuthDao.saveOwner(owner);
    state = AsyncData(owner);
  }

  /// Delete owner from DB (on logout)
  Future<void> clearOwner() async {
    final db = ref.read(databaseProvider);
    await db.ownerAuthDao.deleteOwner();
    state = const AsyncData(null);
  }
}
