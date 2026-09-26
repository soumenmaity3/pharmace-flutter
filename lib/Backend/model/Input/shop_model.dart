class ShopModel {
  final String shopName;
  final String? shopEmail;
  final String? phone;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String? licenseNumber;
  final String? gstNumber;
  final Verify verifyStatus;
  final String? logoUrl;
  final bool? isOpen;

  ShopModel({
    required this.shopName,
    this.shopEmail,
    this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.licenseNumber,
    this.gstNumber,
    required this.verifyStatus,
    this.logoUrl,
    this.isOpen,
  });

  ///dart to json
  Map<String, dynamic> toJson() {
    return {
      'shopName': shopName,
      'shopEmail': shopEmail,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'licenseNumber': licenseNumber,
      'gstNumber': gstNumber,
      'verifyStatus': verifyStatus.label,
      'logoUrl': logoUrl,
      'isOpen': isOpen,
    };
  }

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      shopName: json['shopName']?.toString() ?? '',
      shopEmail: json['shopEmail']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      licenseNumber: json['licenseNumber']?.toString() ?? '',
      gstNumber: json['gstNumber']?.toString() ?? '',

      verifyStatus: Verify.values.firstWhere(
        (status) => status.label == json['verifyStatus'],
        orElse: () => Verify.pending,
      ),

      logoUrl: json['logoUrl']?.toString(),
      isOpen: json['isOpen'] as bool?,
    );
  }
}

enum Verify {
  pending('Pending'),
  verified('Verified'),
  rejected('Rejected');

  final String label;

  const Verify(this.label);
}
