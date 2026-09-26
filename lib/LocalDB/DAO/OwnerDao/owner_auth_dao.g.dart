// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_auth_dao.dart';

// ignore_for_file: type=lint
mixin _$OwnerAuthDaoMixin on DatabaseAccessor<AppDatabase> {
  $OwnerAuthTableTable get ownerAuthTable => attachedDatabase.ownerAuthTable;
  OwnerAuthDaoManager get managers => OwnerAuthDaoManager(this);
}

class OwnerAuthDaoManager {
  final _$OwnerAuthDaoMixin _db;
  OwnerAuthDaoManager(this._db);
  $$OwnerAuthTableTableTableManager get ownerAuthTable =>
      $$OwnerAuthTableTableTableManager(
        _db.attachedDatabase,
        _db.ownerAuthTable,
      );
}
