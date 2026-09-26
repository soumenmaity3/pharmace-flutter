import 'package:flutter/material.dart';
import 'package:pharmace/Backend/model/Input/medicine_input_model.dart';
import 'package:pharmace/Frontend/Inventory/model/medicine_model.dart';

class DosageFormDropDownWidget extends StatelessWidget {
  final DosageForm? value;
  final ValueChanged<DosageForm?> onChanged;
  final bool required;

  const DosageFormDropDownWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<DosageForm>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: required ? 'Dosage Form *' : 'Dosage Form',
        border: const OutlineInputBorder(),
      ),
      items: DosageForm.values.map((form) {
        return DropdownMenuItem(
          value: form,
          child: Text(form.name), // e.g. "tablet" — see note below for nicer labels
        );
      }).toList(),
      onChanged: onChanged,
      validator: required
          ? (value) {
              if (value == null) {
                return 'Please select dosage form';
              }
              return null;
            }
          : null,
    );
  }
}


class SchedulesDropDownWidget extends StatelessWidget {
  final Schedules? value;
  final ValueChanged<Schedules?> onChanged;
  final bool required;

  const SchedulesDropDownWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Schedules>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: required ? 'Schedules *' : 'Schedules',
        border: const OutlineInputBorder(),
      ),
      items: Schedules.values.map((form) {
        return DropdownMenuItem(
          value: form,
          child: Text(form.name),
        );
      }).toList(),
      onChanged: onChanged,
      validator: required
          ? (value) {
              if (value == null) {
                return 'Please select Schedules';
              }
              return null;
            }
          : null,
    );
  }
}