import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/curso_plantilla_model.dart';
import '../../infrastructure/repositories/curso_plantilla_repository.dart';

/// Provider que carga la lista de cursos desde el backend.
final cursoPlantillasListProvider = FutureProvider<List<CursoPlantillaModel>>((ref) async {
  final repo = ref.watch(cursoPlantillaRepositoryProvider);
  return repo.findAll();
});

/// Notifier para operaciones CRUD sobre cursos.
class CursoPlantillasCrudNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  CursoPlantillaRepository get _repo => ref.read(cursoPlantillaRepositoryProvider);

  Future<bool> crear(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _repo.create(data);
      ref.invalidate(cursoPlantillasListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> actualizar(int id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _repo.update(id, data);
      ref.invalidate(cursoPlantillasListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> eliminar(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.delete(id);
      ref.invalidate(cursoPlantillasListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final cursoPlantillasCrudProvider = AutoDisposeNotifierProvider<CursoPlantillasCrudNotifier, AsyncValue<void>>(
  CursoPlantillasCrudNotifier.new,
);



