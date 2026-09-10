import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/application/providers/auth_provider.dart';

final teacherDashboardProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.maybeWhen(
    authenticated: (user) => user.id,
    orElse: () => null,
  );

  if (userId == null) return {};

  final dio = ref.watch(dioClientProvider);
  final res = await dio.get('profesores/$userId/dashboard');
  return res.data as Map<String, dynamic>;
});

final proximaSesionProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.maybeWhen(
    authenticated: (user) => user.id,
    orElse: () => null,
  );

  if (userId == null) return null;

  final dio = ref.watch(dioClientProvider);
  try {
    final res = await dio.get(ApiConstants.proximaSesionProfesor(userId));
    if (res.data == null) return null;
    return res.data as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
});

final sesionesPendientesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.maybeWhen(
    authenticated: (user) => user.id,
    orElse: () => null,
  );

  if (userId == null) return [];

  final dio = ref.watch(dioClientProvider);
  try {
    final res = await dio.get(
      ApiConstants.sesionesPendientesHoy(userId),
      queryParameters: {
        'filtroHoras': 'activas',
        'quitarHechos': true
      }
    );
    return List<Map<String, dynamic>>.from(res.data ?? []);
  } catch (_) {
    return [];
  }
});

final sesionesProximasProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.maybeWhen(
    authenticated: (user) => user.id,
    orElse: () => null,
  );

  if (userId == null) return [];

  final dio = ref.watch(dioClientProvider);
  try {
    final res = await dio.get(
      ApiConstants.sesionesPendientesHoy(userId),
      queryParameters: {
        'filtroHoras': 'proximas',
        'quitarHechos': true
      }
    );
    return List<Map<String, dynamic>>.from(res.data ?? []);
  } catch (_) {
    return [];
  }
});




