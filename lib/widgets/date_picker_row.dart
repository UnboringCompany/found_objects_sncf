/// A widget that displays two date pickers for selecting a start and end date.
///
/// This widget provides text fields for displaying the selected start and end dates, and uses the [showDatePicker] function to display a date picker dialog when the text fields are tapped.
/// It also allows customizing the theme of the date picker dialog.
library;
import 'package:flutter/material.dart';

class DatePickerRow extends StatefulWidget {
  /// Called when the start date is changed.
  final void Function(DateTime? date) onStartDateChanged;

  /// Called when the end date is changed.
  final void Function(DateTime? date) onEndDateChanged;

  /// Constructs a new instance of the [DatePickerRow] widget.
  const DatePickerRow({
    super.key,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerRowState createState() => _DatePickerRowState();
}

class _DatePickerRowState extends State<DatePickerRow> {
  /// The text editing controller for the start date text field.   
  final TextEditingController _startDateController = TextEditingController();

  /// The text editing controller for the end date text field.
  final TextEditingController _endDateController = TextEditingController();

  /// Displays a date picker dialog and updates the specified text field with the selected date.
  ///
  /// [context] The build context.
  /// [controller] The text editing controller for the text field to update.
  /// [onDateChanged] The callback function to call when the date is changed
  Future<void> _selectDate(BuildContext context, TextEditingController controller, void Function(DateTime? date) onDateChanged) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("fr", "FR"),
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF8EE9FE),
              onPrimary: Colors.black,
              surface: Color(0xFF0B1320),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.blue[900],
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toLocal().toString().split(' ')[0];
      });
      onDateChanged(picked);
    }
  }

  // Builds the [DatePickerRow] widget.
  ///
  /// This method returns a [Row] widget that contains the start and end date text fields.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // A partir du
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2C343A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: () => _selectDate(context, _startDateController, widget.onStartDateChanged),
              child: AbsorbPointer(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _startDateController,
                  decoration: const InputDecoration(
                    hintText: 'A partir du',
                    hintStyle: TextStyle(color: Color(0xFF656A6E)),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Jusqu'au
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2C343A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: () => _selectDate(context, _endDateController, widget.onEndDateChanged),
              child: AbsorbPointer(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _endDateController,
                  decoration: const InputDecoration(
                    hintText: 'Jusqu\'au',
                    hintStyle: TextStyle(color: Color(0xFF656A6E)),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
