import 'package:flutter/material.dart';

class MaybeGenericError extends StatelessWidget {
  final String? message;

  const MaybeGenericError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message!,
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}