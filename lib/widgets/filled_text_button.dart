import 'package:flutter/material.dart';

class FilledTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String content;
  final bool disabled;
  final bool isLoading;

  const FilledTextButton({
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

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black45,
        elevation: 5,
      ),
      onPressed: disabled ? null : onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
          height: progressIndicatorSize,
          width: progressIndicatorSize,
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        )
            : Text(
          content,
          style: textStyle.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}