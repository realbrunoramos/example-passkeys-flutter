import 'package:corbado_auth/corbado_auth.dart';
import 'package:corbado_auth_example/auth_provider.dart';
import 'package:corbado_auth_example/screens/helper.dart';
import 'package:corbado_auth_example/widgets/filled_text_button.dart';
import 'package:corbado_auth_example/widgets/outlined_text_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import '../widgets/debug_info.dart';

class EditProfilePage extends HookConsumerWidget {
  EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final corbado = ref.watch(corbadoProvider);

    final fullName = useTextEditingController(text: user.value!.username);
    final email = useTextEditingController(text: user.value!.email);

    Future<void> makeRequest() async {
      final url = Uri.parse('https://www.corbado.com');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${user.value!.idToken}',
          'Content-Type': 'application/json',
        },
      );
    }

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
        title: const Text('Editar Perfil'),
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
                      'Editar Perfil',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: fullName,
                      decoration: InputDecoration(
                        labelText: 'Nome Completo',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: email,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledTextButton(
                        isLoading: isLoading.value,
                        onTap: () async {
                          if (isLoading.value) return;
                          isLoading.value = true;
                          error.value = null;
                          try {
                            await corbado.changeUsername(fullName: fullName.text);
                            showSimpleNotification(
                              const Text(
                                'Nome alterado com sucesso.',
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
                        content: 'Guardar Alterações',
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