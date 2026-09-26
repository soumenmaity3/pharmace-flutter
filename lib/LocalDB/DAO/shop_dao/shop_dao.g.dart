// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_dao.dart';

// ignore_for_file: type=lint
mixin _$ShopDaoMixin on DatabaseAccessor<AppDatabase> {
  $ShopTableTable get shopTable => attachedDatabase.shopTable;
  ShopDaoManager get managers => ShopDaoManager(this);
}

class ShopDaoManager {
  final _$ShopDaoMixin _db;
  ShopDaoManager(this._db);
  $$ShopTableTableTableManager get shopTable =>
      $$ShopTableTableTableManager(_db.attachedDatabase, _db.shopTable);
}
