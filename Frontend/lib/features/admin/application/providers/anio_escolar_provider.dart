import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/anio_escolar_model.dart';
import '../../infrastructure/repositories/anio_escolar_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// List provider — fetches all academic years
// ─────────────────────────────────────────────────────────────────────────────

final anioEscolarListProvider =
    FutureProvider<List<AnioEscolarModel>>((ref) async {
  final repo = ref.watch(anioEscolarRepositoryProvider);
  return repo.findAll();
});

// ─────────────────────────────────────────────────────────────────────────────
// CRUD Notifier
// ─────────────────────────────────────────────────────────────────────────────

class AnioEscolarCrudNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  AnioEscolarRepository get _repo =>
      ref.read(anioEscolarRepositoryProvider);

  void _refresh() => ref.invalidate(anioEscolarListProvider);

  Future<bool> crear(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _repo.create(data);
      _refresh();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<bool> actualizar(int id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _repo.update(id, data);
      _refresh();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<bool> activar(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.activar(id);
      _refresh();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<bool> desactivar(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.desactivar(id);
      _refresh();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<bool> eliminar(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.delete(id);
      _refresh();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final anioEscolarCrudProvider =
    AutoDisposeNotifierProvider<AnioEscolarCrudNotifier, AsyncValue<void>>(
  AnioEscolarCrudNotifier.new,
);



