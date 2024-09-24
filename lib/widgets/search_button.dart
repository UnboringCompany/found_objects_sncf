/// A widget that displays a search button.
///
/// This widget provides a button that navigates to a search page when pressed.
/// The button has a custom style that includes a text label and an icon.
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  /// Called when the button is pressed.
  final VoidCallback onPressed;

  /// Constructs a new instance of the [SearchButton] widget.
  const SearchButton({super.key, required this.onPressed});

  /// Builds the [SearchButton] widget.
  ///
  /// This method returns a [Row] widget that contains the search button.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.only(left: 16, right: 0),
                ),
                foregroundColor: WidgetStateProperty.all(
                  const Color(0xFFF3F3F3),
                ),
                backgroundColor: WidgetStateProperty.all(
                  const Color(0xFFF3F3F3),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quand avez-vous perdu quelque chose ?',
                    style: TextStyle(
                      color: Color(0xFF656A6E),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8EE9FE),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF0B1320),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
