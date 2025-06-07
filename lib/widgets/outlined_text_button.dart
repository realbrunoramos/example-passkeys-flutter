import 'package:flutter/material.dart';

class OutlinedTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String content;
  final bool disabled;
  final bool isLoading;

  const OutlinedTextButton({
    super.key,
    required this.content,
    required this.onTap,
    this.disabled = false,
    this.isLoading = false,
  });

  void onPressed() {
    if (isLoading) return;
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!;
    final progressIndicatorSize = textStyle.fontSize! * 1.4;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(15),
      ),
      onPressed: disabled ? null : onPressed,
      child: isLoading
          ? SizedBox(
        height: progressIndicatorSize,
        width: progressIndicatorSize,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      )
          : Text(
        content,
        style: textStyle.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}