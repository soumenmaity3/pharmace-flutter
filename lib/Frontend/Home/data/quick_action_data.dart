import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmace/Frontend/Home/model/quick_action_model.dart';
import 'package:pharmace/Frontend/screens/other_screen/add_employees_screen.dart';
import 'package:pharmace/Frontend/screens/other_screen/add_medicine_screen.dart';
import 'package:pharmace/Frontend/screens/other_screen/new_bill_screen.dart';
import 'package:pharmace/Frontend/screens/other_screen/reports_screen.dart';

final quickActionData = <QuickActionModel>[
  QuickActionModel(
    icon: Icon(Icons.shopping_cart_outlined),
    title: "New bill",
    screen: NewBillScreen(),
  ),
  QuickActionModel(
    icon: Icon(Icons.add),
    title: "Medicine",
    screen: AddMedicineScreen(),
  ),
  QuickActionModel(
    icon: Icon(Icons.person_add_alt),
    title: "Employee",
    screen: AddEmployeesScreen(isRequestForSelfEmployee: false,),
  ),
  QuickActionModel(
    icon: FaIcon(FontAwesomeIcons.cubes),
    title: "Reports",
    screen: ReportsScreen(),
  ),
];
