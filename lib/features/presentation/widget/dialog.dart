import 'package:flutter/material.dart';


// dialog without button
class BasicDialog extends StatelessWidget {
  final String message;
  final bool isLoading;

  const BasicDialog({
    super.key,
    this.message = "Loading...",
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) const CircularProgressIndicator(),
            if (isLoading) const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}