import 'package:drift/drift.dart';
import 'package:pharmace/Backend/model/Input/shop_owner_model.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/LocalDB/table/owner_auth_table.dart';

part 'owner_auth_dao.g.dart';

@DriftAccessor(tables: [OwnerAuthTable])
class OwnerAuthDao extends DatabaseAccessor<AppDatabase>
    with _$OwnerAuthDaoMixin {
  OwnerAuthDao(super.db);

  /// Save owner details from backend (clears any previous owner so only 1 row exists)
  Future<void> saveOwner(ShopOwnerModel owner) async {
    await transaction(() async {
      // 1. Delete previous owner data
      await delete(ownerAuthTable).go();

      // 2. Insert new owner
      await into(ownerAuthTable).insert(
        OwnerAuthTableCompanion.insert(
          id: owner.id ?? '',
          name: owner.name,
          email: owner.email,
          role: owner.role.value,
          isShopHave: Value(owner.isShopHave),
          createdAt: Value(owner.createdAt),
          selectedShopId: Value(owner.selectedShopId),
        ),
      );
    });
  }

  //UPDATE: Make isHaveShop = true

  Future<bool> updateIsHaveShop({required bool hasShop}) async {
    final count = await (update(
      ownerAuthTable,
    )).write(OwnerAuthTableCompanion(isShopHave: Value(hasShop)));
    return count > 0;
  }

  /// Retrieve current owner details
  Future<ShopOwnerModel?> getOwner() async {
    final row = await select(ownerAuthTable).getSingleOrNull();
    if (row == null) return null;

    return ShopOwnerModel(
      id: row.id,
      name: row.name,
      email: row.email,
      role: Role.values.firstWhere(
        (r) => r.value.toUpperCase() == row.role.toUpperCase(),
        orElse: () => Role.owner,
      ),
      isShopHave: row.isShopHave,
      createdAt: row.createdAt,
      selectedShopId: row.selectedShopId,
    );
  }

  /// Watch owner details as a Stream for reactive UI updates
  Stream<ShopOwnerModel?> watchOwner() {
    return select(ownerAuthTable).watchSingleOrNull().map((row) {
      if (row == null) return null;
      return ShopOwnerModel(
        id: row.id,
        name: row.name,
        email: row.email,
        role: Role.values.firstWhere(
          (r) => r.value.toUpperCase() == row.role.toUpperCase(),
          orElse: () => Role.owner,
        ),
        isShopHave: row.isShopHave,
        createdAt: row.createdAt,
        selectedShopId: row.selectedShopId,
      );
    });
  }

  /// Clear owner data on logout
  Future<int> deleteOwner() {
    return delete(ownerAuthTable).go();
  }

  /// Update the selected shop for the current owner
  Future<bool> updateSelectedShop(String? shopId) async {
    final count = await (update(
      ownerAuthTable,
    )).write(OwnerAuthTableCompanion(selectedShopId: Value(shopId)));
    return count > 0;
  }
}
