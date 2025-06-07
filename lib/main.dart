import 'dart:async';

import 'package:corbado_auth/corbado_auth.dart';
import 'package:corbado_auth_example/auth_provider.dart';
import 'package:corbado_auth_example/pages/loading_page.dart';
import 'package:corbado_auth_example/router.dart';
import 'package:corbado_telemetry_api_client/corbado_telemetry_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LoadingPage());

  final projectId = getProjectID();

  final corbadoAuth = CorbadoAuth();
  await corbadoAuth.init(
      projectId: projectId, telemetryDisabled: CORBADO_TELEMETRY_DISABLED);

  if (!CORBADO_TELEMETRY_DISABLED) {
    // Telemetry is used to help us understand how the example is used.
    unawaited(CorbadoTelemetryApiClient(
      projectId: projectId,
    ).sendEvent(
      type: TelemetryEventType.EXAMPLE_APPLICATION_OPENED,
      payload: {
        'exampleName': 'corbado/examples/dart-flutter',
      },
    ));
  }

  runApp(ProviderScope(
    overrides: [
      corbadoProvider.overrideWithValue(corbadoAuth),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return OverlaySupport.global(
      child: MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF1A237E),
            onPrimary: Colors.white,
            secondary: Color(0xFF4DD0E1),
            onSecondary: Colors.black,
            error: Colors.redAccent,
            onError: Colors.white,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          scaffoldBackgroundColor: Colors.grey[100],
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}