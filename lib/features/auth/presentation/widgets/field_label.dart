import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final String label;
  final bool required;

  const FieldLabel({super.key, required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff1A1A1A),
              fontFamily: 'IBMPlexSansArabic',
            ),
            children: [
              if (required)
                const TextSpan(
                  text: '* ',
                  style: TextStyle(color: Colors.red),
                ),
              TextSpan(text: label),
            ],
          ),
        ),
      ),
    );
  }
}
