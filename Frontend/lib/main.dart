import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' show FlutterQuillLocalizations;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:gaula_frontend/l10n/app_localizations.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'router/app_router.dart';
import 'shared/theme/app_theme.dart';
import 'package:flutter/services.dart';

/// Punto de entrada de la aplicación GAULA.
/// ProviderScope envuelve toda la app para Riverpod 2.x.
import 'dart:async';

void main() async {
  runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Inicializar localización para fechas (necesario para DateFormat en Dashboard)
    await Future.wait([
      initializeDateFormatting('es_ES', null),
      initializeDateFormatting('ca', null),
      initializeDateFormatting('en', null),
    ]);

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    runApp(
      const ProviderScope(
        child: GaulaApp(),
      ),
    );
  }, zoneSpecification: ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      if (line.trim() == 'animate: true') {
        return; // Mute "animate: true" logs
      }
      parent.print(zone, line);
    },
  ));
}

/// Widget raíz de la aplicación.
/// Configura el router, el tema y el layout responsivo.
class GaulaApp extends ConsumerWidget {
  const GaulaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Leer el router desde Riverpod para que sea reactivo al estado de sesión
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      // ── Metadatos de la app ──
      title: 'GAULA — Gestor de Clases',
      debugShowCheckedModeBanner: false,

      // ── Tema: modo oscuro por defecto ──
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      locale: ref.watch(localeProvider),

      // ── Localización (incluye FlutterQuill para el editor de reglamento) ──
      localizationsDelegates: const [
        AppLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
        Locale('ca'),
      ],

      // ── Router (GoRouter) ──
      routerConfig: router,

      // ── Layout Responsivo ──
      // Adapta la UI de móvil a escritorio sin media queries manuales
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0,    end: 450,  name: MOBILE),
          const Breakpoint(start: 451,  end: 800,  name: TABLET),
          const Breakpoint(start: 801,  end: 1100, name: DESKTOP),
          const Breakpoint(start: 1101, end: 1920, name: '4K'),
        ],
      ),
    );
  }
}
