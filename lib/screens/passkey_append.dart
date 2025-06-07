import 'package:corbado_auth/corbado_auth.dart';
import 'package:corbado_auth_example/screens/helper.dart';
import 'package:corbado_auth_example/widgets/filled_text_button.dart';
import 'package:corbado_auth_example/widgets/outlined_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasskeyAppendScreen extends HookWidget implements CorbadoScreen<PasskeyAppendBlock> {
  final PasskeyAppendBlock block;

  PasskeyAppendScreen(this.block);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final maybeError = block.error;
        if (maybeError != null) {
          showNotificationError(context, maybeError.detailedError());
        }
      });
    }, [block.error]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            'Configurar Passkey',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Inicie sessão de forma rápida e segura com Touch ID ou Face ID em vez de palavras-passe.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledTextButton(
            isLoading: block.data.primaryLoading,
            onTap: () async {
              await block.passkeyAppend();
            },
            content: 'Criar Passkey',
          ),
        ),
        const SizedBox(height: 16),
        if (block.data.preferredFallback != null)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedTextButton(
              onTap: () => block.data.preferredFallback!.onTap(),
              content: block.data.preferredFallback!.label,
            ),
          )
        else
          Container(),
        if (block.data.canBeSkipped)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedTextButton(
              onTap: block.skipPasskeyAppend,
              content: 'Talvez Mais Tarde',
            ),
          )
        else
          Container(),
        const SizedBox(height: 16),
      ],
    );
  }
}