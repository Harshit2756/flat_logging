import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onPressed;
  final String buttonText;
  final bool showButton;
  const EmptyWidget({super.key, required this.message, this.onPressed, this.buttonText = 'Retry', this.showButton = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(message, style: Theme.of(context).textTheme.titleMedium),
          if (showButton) const SizedBox(height: 16),
          if (showButton) ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
        ],
      ),
    );
  }
}
