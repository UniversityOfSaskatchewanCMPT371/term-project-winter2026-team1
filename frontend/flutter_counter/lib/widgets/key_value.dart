import 'package:flutter/material.dart';

/// Widget for displaying key-value pairs with monospace formatting
class KeyValue extends StatelessWidget {
  const KeyValue({super.key, required this.keyLabel, required this.value});

  final String keyLabel;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Colors.black,
            fontSize: 13,
          ),
          children: [
            TextSpan(
              text: '$keyLabel: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
