import 'package:corbado_auth/corbado_auth.dart';
import 'package:corbado_auth_example/auth_provider.dart';
import 'package:corbado_auth_example/screens/email_edit.dart';
import 'package:corbado_auth_example/screens/email_verify_otp.dart';
import 'package:corbado_auth_example/screens/login_init.dart';
import 'package:corbado_auth_example/screens/passkey_append.dart';
import 'package:corbado_auth_example/screens/passkey_verify.dart';
import 'package:corbado_auth_example/screens/signup_init.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/debug_info.dart';

class AuthPage extends HookConsumerWidget {
  AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corbadoAuth = ref.watch(corbadoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticação Segura'),
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
                child: CorbadoAuthComponent(
                  corbadoAuth: corbadoAuth,
                  components: CorbadoScreens(
                    signupInit: SignupInitScreen.new,
                    loginInit: LoginInitScreen.new,
                    emailVerifyOtp: EmailVerifyOtpScreen.new,
                    passkeyAppend: PasskeyAppendScreen.new,
                    passkeyVerify: PasskeyVerifyScreen.new,
                    emailEdit: EmailEditScreen.new,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}