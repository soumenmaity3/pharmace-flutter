# Local Storage Security, Privacy & Efficiency Guide

This guide establishes the standards for **Security**, **Privacy**, and **High Performance** when storing data locally in the **Pharmace** application.

---

## 1. The Storage Hierarchy: Where Does Data Belong?

Not all data should be stored in the same place. Storing sensitive data in the wrong place is a major security vulnerability.

```mermaid
graph TD
    Data[Incoming Data] --> IsAuth{Authentication Secrets?}
    IsAuth -- Yes --> SecureStorage[FlutterSecureStorage<br/>- JWT Tokens<br/>- Refresh Tokens<br/>- Encryption Keys]
    IsAuth -- No --> IsLarge{Structured Business Data?}
    IsLarge -- Yes --> DriftDB[Drift SQLite Database<br/>- Medicines & Stock<br/>- Invoices & Bills<br/>- Shop & Owner Details]
    IsLarge -- No --> SimplePrefs[SharedPreferences<br/>- Theme Mode (Dark/Light)<br/>- Language Preferences<br/>- Simple UI flags]
```

### 📋 Storage Matrix

| Data Type | Storage Solution | Why? |
| :--- | :--- | :--- |
| **JWT Access & Refresh Tokens** | `FlutterSecureStorage` | Encrypted natively via Android Keystore, iOS Keychain, Windows DPAPI. |
| **User Passwords** | ❌ **NEVER STORE** | Never store passwords locally (neither plaintext nor hashed). Only use JWT tokens. |
| **Owner & Shop Profile** | `Drift SQLite` | Fast offline access, structured relational data. |
| **Invoices & Medicines** | `Drift SQLite` | Large datasets, relational queries, complex filtering. |
| **Images & Medicine Photos** | `Local File System` (`path_provider`) | Save files to disk and store only the **file path** (`String`) in SQLite. Never store large raw bytes/blobs in SQLite. |
| **UI Theme (Dark / Light)** | `SharedPreferences` | Lightweight key-value data with instant synchronous read. |

---

## 2. Security & Privacy Rules (What to Enforce)

### 🔒 Rule 1: Zero Plaintext Credentials
- **Never save raw passwords** in `OwnerAuthTable` or any SQLite table.
- When backend returns `"password": "$2a$12$..."`, **do not store the hash locally**. Hashes can be extracted from rooted devices or backup images.

### 🔒 Rule 2: Multi-User / Shared Device Sanitization (Logout Protocol)
In retail pharmacies, multiple employees or owners often use the same tablet or desktop PC.
When logging out, **all sensitive cached data must be wiped**:

```dart
Future<void> performSafeLogout(WidgetRef ref) async {
  // 1. Delete JWT Token from Secure Storage
  await SecureStorageService.deleteToken();

  // 2. Wipe owner & sensitive session data from SQLite
  final db = ref.read(databaseProvider);
  await db.transaction(() async {
    await db.ownerAuthDao.deleteOwner();
    // Optional: Clear customer info or pending drafts if needed
  });
}
```

### 🔒 Rule 3: Database Encryption (SQLCipher)
For production environments handling sensitive medical and billing records, encrypt the entire SQLite file on disk using **SQLCipher**:
- The encryption key is generated randomly on first install and stored securely in `FlutterSecureStorage`.
- Even if an attacker physically extracts `medicine_inventory.sqlite`, the file cannot be opened without the key.

---

## 3. High Efficiency & Performance Best Practices

### ⚡ 1. Indexing: Speeding Up Search by 10x–50x
By default, searching columns like `medicineName`, `invNo`, or `phone` requires SQLite to scan every row in the table (Full Table Scan).

**Add indexes on frequently searched columns in your Drift tables:**

```dart
class MedicineTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineNmae => text()();
  TextColumn get genericName => text()();
  
  // Create an index for ultra-fast name search
  @override
  List<Set<Column>> get uniqueKeys => [];
  
  @override
  List<Index> get indexes => [
    Index('med_name_idx', 'CREATE INDEX med_name_idx ON medicine_table (medicine_nmae)'),
  ];
}
```

### ⚡ 2. Batch Operations: The 50x Insert Speedup
Never execute database writes in a `for` loop:

❌ **BAD (Slow - commits every row individually):**
```dart
for (final shop in shopList) {
  await into(shopTable).insert(shop.toCompanion()); // 100 round-trips!
}
```

✅ **GOOD (Fast - single native SQLite transaction):**
```dart
await batch((b) {
  b.insertAllOnConflictUpdate(shopTable, companions);
});
```

### ⚡ 3. Pagination for Large Datasets (Lazy Loading)
Never load 10,000 invoices into memory at once. It causes UI stutters and high RAM consumption.

```dart
Future<List<BillTableData>> getBillsPaged({required int page, int limit = 20}) {
  return (select(billTable)
    ..orderBy([(t) => OrderingTerm.desc(t.date)])
    ..limit(limit, offset: page * limit))
    .get();
}
```

### ⚡ 4. Never Store Images in SQLite (Bloat Prevention)
Storing Base64 strings or BLOB image bytes inside SQLite increases database size exponentially and slows down read queries.

✅ **The Correct Pattern:**
1. Save image to disk using `path_provider`: `/app_flutter/images/med_123.jpg`.
2. Save only the file path string in `MedicineTable.imgUrl`.

---

## 4. 🚫 Critical Anti-Patterns (What to Avoid)

| Anti-Pattern | Why It Is Dangerous | What to Do Instead |
| :--- | :--- | :--- |
| **Storing JWT in SQLite or SharedPreferences** | Plaintext files on Android/Windows are easily readable. | Always use `FlutterSecureStorage`. |
| **Storing Passwords locally** | Data theft risk if device is stolen. | Authenticate with JWT; never store credentials. |
| **Calling APIs when offline without checking** | Frustrates cashiers with network timeout spinners. | Show cached SQLite data instantly. |
| **Unbounded Queries (`SELECT * FROM table`)** | Crashes the app when database grows to tens of thousands of rows. | Use `.limit(50)` and paginate. |
| **Not using Transactions for Related Tables** | If app crashes during bill creation, items are inserted without a parent bill (corrupted DB). | Wrap related writes in `transaction(() async { ... })`. |
| **Leaving Old Cache Forever** | App storage balloons to gigabytes over months. | Add a periodic purge for bills older than 1–2 years if synced to cloud. |

---

## 5. Offline Sync Pattern (The Gold Standard)

To sync local SQLite with your cloud backend reliably, include these standard sync tracking columns in your tables:

```dart
class SyncableTable extends Table {
  // Flag indicating if record is synced to backend
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  
  // Timestamp of last update
  DateTimeColumn get lastModified => dateTime().withDefault(currentDateAndTime)();
}
```

### The Sync Flow:
1. **Local Changes**: Set `isSynced = false`.
2. **Network Available**: Background worker uploads rows where `isSynced == false`.
3. **Server Confirms**: Update row to `isSynced = true`.
