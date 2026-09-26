import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/Home/model/inventory_health_model.dart';

final inventoryHealthData = <InventoryHealthModel>[
  InventoryHealthModel(
    title: "ALL MEDICINE",
    value: '1,248',
    icon: Icon(Icons.inventory_2_outlined),
  ),
  InventoryHealthModel(
    title: "INVENTORY VALUE",
    value: '₹8.42L',
    icon: Icon(Icons.attach_money_outlined,size:20),
  ),
  InventoryHealthModel(
    title: "LOW/OUT STOCK",
    value: '3',
    icon: Icon(Icons.warning_amber_outlined,size: 20),
  ),
  InventoryHealthModel(
    title: "EXPIRING SOON",
    value: '1',
    icon: Icon(Icons.watch_later_outlined,size: 20),
  ),
];
