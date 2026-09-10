import '../data/repositories/festivo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/festivo_model.dart';

/// Año actualmente visualizado en el calendario de festivos.
/// Por defecto, el año actual del dispositivo.
final festivosAnioProvider = StateProvider<int>(
  (ref) => DateTime.now().year,
);

/// Lista de festivos cargada del backend (filtrada por provincia configurada).
/// Reactiva al año seleccionado.
final festivosListProvider = FutureProvider<List<FestivoModel>>((ref) async {
  final anio = ref.watch(festivosAnioProvider);
  final repo  = ref.watch(festivoRepositoryProvider);
  return repo.getFestivos(anio);
});

/// Lista de CCAA disponibles para el selector de provincia (solo Admin).
/// Solo se carga una vez (no reactiva a cambios de año).
final provinciasListProvider = FutureProvider<List<Map<String, String>>>((ref) async {
  return ref.watch(festivoRepositoryProvider).getProvincias();
});

/// Provincia actualmente configurada en el sistema.
final provinciaActualProvider = FutureProvider<Map<String, String>>((ref) async {
  // Se invalida cuando el admin cambia la provincia
  return ref.watch(festivoRepositoryProvider).getProvinciaActual();
});

/// Notifier para cambiar la provincia de festivos (solo Admin).
class ProvinciaNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Cambia la provincia y refresca listas de festivos.
  Future<bool> cambiarProvincia(String codigoISO) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(festivoRepositoryProvider).cambiarProvincia(codigoISO);
      ref.invalidate(festivosListProvider);
      ref.invalidate(provinciaActualProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Sincroniza los festivos con la API de Nager.Date.
  Future<bool> sincronizar(int anio) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(festivoRepositoryProvider).sincronizarFestivos(anio);
      ref.invalidate(festivosListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final provinciaNotifierProvider =
    NotifierProvider<ProvinciaNotifier, AsyncValue<void>>(
  ProvinciaNotifier.new,
);



