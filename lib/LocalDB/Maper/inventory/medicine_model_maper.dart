import 'package:drift/drift.dart';
import 'package:pharmace/Backend/model/Input/medicine_input_model.dart';
import 'package:pharmace/Backend/model/Output/employee_return_model.dart';
import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';
import 'package:pharmace/Frontend/Inventory/model/medicine_model.dart';
import 'package:pharmace/LocalDB/database.dart';

extension MedicineOutputModelMapper on MedicineOutputModel {
  MedicineTableCompanion toCompanion() {
    return MedicineTableCompanion.insert(
      id: id ?? '',
      medName: medName,
      genericName: genericName,
      brand: brand,
      category: category,
      strength: strength,
      dosageForm: dosageForm.label ?? dosageForm.name,
      schedule: Value(schedule.label ?? schedule.name),
      imageUrl: Value(imageUrl),
      batchNo: batchNo,
      quantity: Value(quantity),
      avLoose: Value(avLoose),
      looseQuantity: Value(looseQuantity),
      totalLooseInStrip: Value(totalLooseInStrip),
      minStockLevel: Value(minStockLevel),
      maxStockLevel: Value(maxStockLevel),
      purchasePrice: Value(purchasePrice),
      sellingPrice: Value(sellingPrice),
      mrp: Value(mrp),
      manufactureDate: manufactureDate,
      expiryDate: expiryDate,
      supplier: Value(supplier),
      addDate: Value(addDate),
      updateDate: Value(updateDate),
      shopId: Value(shop?.id),
      addedBy: Value(
        (addedBy?.name != null && addedBy!.name.trim().isNotEmpty)
            ? addedBy!.name.trim()
            : addedBy?.id,
      ),
      updatedBy: Value(
        (updatedBy?.name != null && updatedBy!.name.trim().isNotEmpty)
            ? updatedBy!.name.trim()
            : updatedBy?.id,
      ),
    );
  }
}

extension MedicineTableDataMapper on MedicineTableData {
  MedicineOutputModel toOutputModel() {
    return MedicineOutputModel(
      id: id,
      medName: medName,
      genericName: genericName,
      brand: brand,
      category: category,
      strength: strength,
      dosageForm: _parseDosageForm(dosageForm),
      schedule: _parseSchedules(schedule),
      imageUrl: imageUrl,
      batchNo: batchNo,
      quantity: quantity,
      avLoose: avLoose,
      looseQuantity: looseQuantity ?? 0,
      totalLooseInStrip: totalLooseInStrip ?? 0,
      minStockLevel: minStockLevel,
      maxStockLevel: maxStockLevel,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      mrp: mrp,
      manufactureDate: manufactureDate,
      expiryDate: expiryDate,
      addDate: addDate,
      updateDate: updateDate,
      supplier: supplier,
      addedBy: addedBy != null && addedBy!.trim().isNotEmpty
          ? EmployeeReturnModel(id: addedBy!.trim(), name: addedBy!.trim(), email: '')
          : null,
      updatedBy: updatedBy != null && updatedBy!.trim().isNotEmpty
          ? EmployeeReturnModel(id: updatedBy!.trim(), name: updatedBy!.trim(), email: '')
          : null,
    );
  }

  // Alias for backward compatibility
  MedicineOutputModel toMedicineModel() => toOutputModel();

  static DosageForm _parseDosageForm(String value) {
    for (final form in DosageForm.values) {
      if (form.name.toLowerCase() == value.toLowerCase() ||
          (form.label?.toLowerCase() == value.toLowerCase())) {
        return form;
      }
    }
    return DosageForm.tablet;
  }

  static Schedules _parseSchedules(String value) {
    for (final s in Schedules.values) {
      if (s.name.toLowerCase() == value.toLowerCase() ||
          (s.label?.toLowerCase() == value.toLowerCase())) {
        return s;
      }
    }
    return Schedules.none;
  }
}