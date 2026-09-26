import 'package:pharmace/Backend/model/Output/medicine_output_model.dart';

typedef MedicineModel = MedicineOutputModel;

enum StockStatus {
  inStock('In Stock'),
  lowStock('Low Stock'),
  expiring('Expiring'),
  outOfStock('Out Of Stock');

  const StockStatus(this.label);

  final String? label;
}

enum DosageForm {
  injection('Injection'),
  tablet('Tablet'),
  suspension('Suspension'),
  gel('Gel'),
  capsule('Capsule'),
  other('Other'),
  cream('Cream'),
  drops('Drops'),
  syrup('Syrup'),
  solution('Solution'),
  powder('Powder'),
  ointment('Ointment'),
  spray('Spray'),
  respules('Respules'),
  inhaler('Inhaler');

  const DosageForm(this.label);

  final String? label;
}
