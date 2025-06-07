import 'package:corbado_auth/corbado_auth.dart';
import 'package:corbado_auth_example/auth_provider.dart';
import 'package:corbado_auth_example/screens/helper.dart';
import 'package:corbado_auth_example/widgets/filled_text_button.dart';
import 'package:corbado_auth_example/widgets/outlined_text_button.dart';
import 'package:corbado_auth_example/widgets/passkey_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import '../widgets/debug_info.dart';

class PasskeyListPage extends HookConsumerWidget {
  PasskeyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corbado = ref.watch(corbadoProvider);
    final passkeys = ref.watch(passkeysProvider).value ?? [];

    final isLoading = useState<bool>(false);
    final error = useState<String?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final maybeError = error.value;
        if (maybeError != null) {
          showNotificationError(context, maybeError);
        }
      });
      return null;
    }, [error.value]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerir Passkeys'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[100]!, Colors.grey[300]!],
          ),
        ),
        child: Stack(
          children: [
            DebugInfo(),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'As Suas Passkeys',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView(
                        children: passkeys
                            .map(
                              (p) => SizedBox(
                            width: double.infinity,
                            child: PasskeyCard(
                              passkey: p,
                              onDelete: (String credentialID) async {
                                if (isLoading.value) return;
                                isLoading.value = true;
                                error.value = null;
                                try {
                                  await corbado.deletePasskey(credentialID: credentialID);
                                  showSimpleNotification(
                                    const Text(
                                      'Passkey eliminada com sucesso.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: const Icon(Icons.check, color: Colors.green),
                                    background: Theme.of(context).colorScheme.primary,
                                  );
                                } on CorbadoError catch (e) {
                                  error.value = e.translatedError;
                                } catch (e) {
                                  error.value = e.toString();
                                } finally {
                                  isLoading.value = false;
                                }
                              },
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledTextButton(
                        onTap: () async {
                          if (isLoading.value) return;
                          isLoading.value = true;
                          error.value = null;
                          try {
                            await corbado.appendPasskey();
                            showSimpleNotification(
                              const Text(
                                'Passkey criada com sucesso.',
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: const Icon(Icons.check, color: Colors.green),
                              background: Theme.of(context).colorScheme.primary,
                            );
                          } on CorbadoError catch (e) {
                            error.value = e.translatedError;
                          } catch (e) {
                            error.value = e.toString();
                          } finally {
                            isLoading.value = false;
                          }
                        },
                        content: 'Adicionar Passkey',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedTextButton(
                        onTap: context.pop,
                        content: 'Voltar',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}