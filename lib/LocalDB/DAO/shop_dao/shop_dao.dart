import 'package:drift/drift.dart';
import 'package:pharmace/Backend/model/Output/shop_return_model.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/LocalDB/table/shop_table.dart';

part 'shop_dao.g.dart';

@DriftAccessor(tables: [ShopTable])
class ShopDao extends DatabaseAccessor<AppDatabase> with _$ShopDaoMixin {
  ShopDao(super.db);

  /// Save or sync the entire list of shops from the API
  Future<void> syncShops(List<ShopReturnModel> shops) async {
    await transaction(() async {
      await batch((b) {
        b.insertAllOnConflictUpdate(
          shopTable,
          shops.map(
            (shop) => ShopTableCompanion.insert(
              id: shop.id,
              shopName: shop.shopName,
              shopCode: shop.shopCode,
              shopEmail: shop.shopEmail,
              phone: shop.phone,
              address: shop.address,
              city: shop.city,
              state: shop.state,
              pincode: shop.pincode,
              licenseNumber: Value(shop.licenseNumber),
              gstNumber: Value(shop.gstNumber),
              verifyStatus: Value(shop.verifyStatus.label),
              logoUrl: Value(shop.logoUrl),
              isOpen: Value(shop.isOpen),
              ownerId: Value(shop.owner.id),
              isOwnerEmployee: Value(shop.isOwnerEmployee),
            ),
          ),
        );
      });
    });
  }

  ///Get shop details by id
  // Future<ShopTableData?> getShopById(String shopId) {
  //   return (select(
  //     shopTable,
  //   )..where((item) => item.id.equals(shopId))).getSingleOrNull();
  // }

  /// Get all cached shops
  Future<List<ShopTableData>> getAllShops() => select(shopTable).get();

  /// Watch shops in real-time
  Stream<List<ShopTableData>> watchShops() => select(shopTable).watch();

  /// Update shop open/closed status
  Future<int> updateShopStatus(String shopId, bool isOpen) {
    return (update(shopTable)..where((t) => t.id.equals(shopId))).write(
      ShopTableCompanion(isOpen: Value(isOpen)),
    );
  }

  /// Update whether owner is marked as an employee for this shop
  Future<int> updateOwnerEmployeeStatus(String shopId, bool isOwnerEmployee) {
    return (update(shopTable)..where((t) => t.id.equals(shopId))).write(
      ShopTableCompanion(isOwnerEmployee: Value(isOwnerEmployee)),
    );
  }

  Future<int> deleteAllData(){
    return delete(shopTable).go();
  }
}
