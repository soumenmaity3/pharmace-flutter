import 'package:pharmace/Frontend/Employees/model/employee_model.dart';

class EmpInvite {
  final String inviteId;
  final String empEmail;
  final String empName;

  final RoleEmp empRole;
  final String shopId;
  final String ownerId;

  EmpInvite(this.inviteId,
      this.shopId, {
        required this.empEmail,
        required this.empName,
        required this.empRole, required this.ownerId,
      });

  Map<String, dynamic> toJson() {
    return {
      'inviteId': inviteId,
      'empEmail': empEmail,
      'empRole': empRole.value,
      'shopId': shopId,
      'empName':empName,
      'ownerId':ownerId
    };
  }

  factory EmpInvite.fromJson(Map<String, dynamic> json) {
    return EmpInvite(
      json['inviteId']?.toString() ?? '',
      json['shopId']?.toString() ?? '',
      empEmail: json['empEmail']?.toString() ?? '',
      empRole: RoleEmp.fromString(json['empRole']?.toString()),
      empName: json['empName']?.toString()??'',
      ownerId: json['ownerId']?.toString()??''
    );
  }
}

