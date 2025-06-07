import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

void showNotificationError(BuildContext context, String message) {
  showSimpleNotification(
    Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    leading: const Icon(Icons.cancel, color: Colors.red),
    background: Theme.of(context).colorScheme.primary,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}