import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth_provider.dart';

class DebugInfo extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corbadoAuth = ref.watch(corbadoProvider);
    final rpIdSnapshot = useFuture(corbadoAuth.rpId, initialData: "");

    return Positioned(
      left: 8,
      top: 8,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              'ID do Projeto: ${corbadoAuth.projectId}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            SelectableText(
              'RPID: ${rpIdSnapshot.data}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}