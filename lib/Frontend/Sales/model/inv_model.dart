import 'package:pharmace/Frontend/Sales/model/medicine_bill_model.dart';

class InvModel {
  final String invNo;
  final int customerType;
  final String customerName;
  final String date;
  final double value;
  final PaymentType paymentType;
  List<MedicineBillModel> selectedMedicine;

  InvModel({
    required this.invNo,
    required this.customerName,
    required this.date,
    required this.value,
    required this.paymentType,
    required this.selectedMedicine, required this.customerType,
  });
  InvModel copyWith({PaymentType? paymentType}) {
    return InvModel(
      invNo: invNo,
      customerName: customerName,
      date: date,
      value: value,
      paymentType: paymentType ?? this.paymentType,
      selectedMedicine: selectedMedicine, customerType: customerType,
    );
  }
}

enum PaymentType {
  upi('UPI'),
  cash('Cash'),
  card('Card'),
  refunded('Refunded'),
  due('Due');

  const PaymentType([this.label]);

  final String? label;
}
