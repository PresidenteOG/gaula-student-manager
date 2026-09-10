import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/curso_model.dart';
import '../../../shared/providers/horario_provider.dart';
import '../../infrastructure/repositories/curso_repository.dart';

/// Provider para el filtro de año escolar en la pantalla de cursos.
final selectedAnioEscolarFilterProvider = StateProvider<int?>((ref) => null);

/// Provider que carga la lista de cursos desde el backend.
final cursosListProvider = FutureProvider.autoDispose<List<CursoModel>>((ref) async {
  final repo = ref.watch(cursoRepositoryProvider);
  final yearId = ref.watch(selectedAnioEscolarFilterProvider);
  if (yearId != null) {
    return repo.findByAnio(yearId);
  }
  return repo.findAll();
});

/// Obtiene las materias de un curso.
final cursoMateriasProvider = FutureProvider.autoDispose.family<List<dynamic>, int>((ref, cursoId) async {
  final repo = ref.watch(cursoRepositoryProvider);
  return repo.findMateriasByCurso(cursoId);
});

/// Obtiene las clases (sesiones) de una materia por su ID.
final clasesByMateriaProvider = FutureProvider.autoDispose.family<List<dynamic>, int>((ref, materiaId) async {
  final repo = ref.watch(cursoRepositoryProvider);
  return repo.findClasesByMateria(materiaId);
});


/// Notifier para operaciones CRUD sobre cursos.
class CursosCrudNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  CursoRepository get _repo => ref.read(cursoRepositoryProvider);

  Future<bool> crear(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _repo.create(data);
      ref.invalidate(cursosListProvider);
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
      ref.invalidate(cursosListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> generarHorario(int cursoId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.generarHorario(cursoId);
      ref.invalidate(cursoHorarioProvider(cursoId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updateMateriaColor(int materiaId, String hexColor, int cursoId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateMateriaColor(materiaId, hexColor);
      ref.invalidate(cursosListProvider);
      ref.invalidate(cursoHorarioProvider(cursoId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final cursosCrudProvider = AutoDisposeNotifierProvider<CursosCrudNotifier, AsyncValue<void>>(
  CursosCrudNotifier.new,
);






