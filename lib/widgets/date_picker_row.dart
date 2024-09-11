import 'package:flutter/material.dart';

class DatePickerRow extends StatefulWidget {
  const DatePickerRow({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerRowState createState() => _DatePickerRowState();
}

class _DatePickerRowState extends State<DatePickerRow> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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
                dialogBackgroundColor:Colors.blue[900],
              ),
              child: child!,
            );
          },
        );
    if (picked != null) {
      setState(() {
        controller.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

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
              onTap: () => _selectDate(context, _startDateController),
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
              onTap: () => _selectDate(context, _endDateController),
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