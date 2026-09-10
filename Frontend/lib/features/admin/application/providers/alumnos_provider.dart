import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/alumno_model.dart';
import '../../infrastructure/repositories/alumno_repository.dart';
import '../../../../core/network/paginated_response.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Provider de búsqueda — controla el texto del campo de búsqueda
// ─────────────────────────────────────────────────────────────────────────────

/// Texto de búsqueda actual (vací­o = mostrar todos).
final alumnosBusquedaProvider = StateProvider<String>((ref) => '');

// ─────────────────────────────────────────────────────────────────────────────
// Provider así­ncrono de la lista de alumnos
// ─────────────────────────────────────────────────────────────────────────────

/// Página actual de la lista de alumnos.
final alumnosPageProvider = StateProvider<int>((ref) => 0);

/// Tamaño de página para la lista de alumnos.
final alumnosPageSizeProvider = StateProvider<int>((ref) => 100);


/// Filtro de curso activo (null = todos).
final alumnosCursoFiltroProvider = StateProvider<int?>((ref) => null);

/// Lista de alumnos cargada del backend con paginación.
/// Reactivo a [alumnosBusquedaProvider], [alumnosCursoFiltroProvider], [alumnosPageProvider] y [alumnosPageSizeProvider].
final alumnosListProvider = FutureProvider<PaginatedResponse<AlumnoModel>>((ref) async {
  final busqueda = ref.watch(alumnosBusquedaProvider);
  final cursoId  = ref.watch(alumnosCursoFiltroProvider);
  final page     = ref.watch(alumnosPageProvider);
  final size     = ref.watch(alumnosPageSizeProvider);
  final repo     = ref.watch(alumnoRepositoryProvider);
  
  return repo.findAll(
    busqueda: busqueda.isEmpty ? null : busqueda,
    cursoId: cursoId,
    page: page,
    size: size,
  );
});

/// Obtiene el detalle de un alumno por ID.
final studentDetailProvider = FutureProvider.family<AlumnoModel, int>((ref, id) async {
  final repo = ref.watch(alumnoRepositoryProvider);
  return repo.findAlumnoById(id);
});

/// Obtiene alumnos por curso.
final alumnosByCursoProvider = FutureProvider.family<List<AlumnoModel>, int>((ref, cursoId) async {
  final repo = ref.watch(alumnoRepositoryProvider);
  return repo.findByCurso(cursoId);
});

/// Obtiene TODOS los alumnos sin páginación (para dropdowns y pasar lista).
final alumnosTodosProvider = FutureProvider<List<AlumnoModel>>((ref) async {
  final repo = ref.watch(alumnoRepositoryProvider);
  final result = await repo.findAll(page: 0, size: 500);
  return result.content;
});

/// Obtiene los alumnos sin curso asignado (para selector de matriculación).
final alumnosSinMatricularProvider = FutureProvider.autoDispose<List<AlumnoModel>>((ref) async {
  final repo = ref.watch(alumnoRepositoryProvider);
  return repo.getAlumnosSinMatricular();
});

// ─────────────────────────────────────────────────────────────────────────────
// Notifier para operaciones CRUD
// ─────────────────────────────────────────────────────────────────────────────

/// Estado del CRUD de alumnos.
class AlumnosCrudNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  AlumnoRepository get _repo => ref.read(alumnoRepositoryProvider);

  /// Crea un alumno y refresca la lista.
  Future<bool> crear(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _repo.create(data);
      // Invalidar el caché de la lista para que se recargue del backend
      ref.invalidate(alumnosListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Actualiza un alumno y refresca la lista.
  Future<bool> actualizar(int id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      if (!data.containsKey('cursoId')) {
        final actual = (await _repo.findAlumnoById(id)).toJson();
        data['cursoId'] = actual['cursoId'];
      }
      await _repo.update(id, data);
      ref.invalidate(alumnosListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Cambia el estado de un alumno.
  Future<bool> cambiarEstado(int id, String nuevoEstado) async {
    state = const AsyncValue.loading();
    try {
      await _repo.cambiarEstado(id, nuevoEstado);
      ref.invalidate(alumnosListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Elimina un alumno y refresca.
  Future<bool> eliminar(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repo.delete(id);
      ref.invalidate(alumnosListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Matricula un alumno en un curso.
  Future<bool> matricularEnCurso(int alumnoId, int cursoId, {List<int>? materiaIds}) async {
    state = const AsyncValue.loading();
    try {
      // Obtenemos los datos actuales para no perder nada (el update del repo pide Map)
      final actual = await _repo.findAlumnoById(alumnoId);
      final data = actual.toJson();
      data['cursoId'] = cursoId;
      if (materiaIds != null) {
        data['materiaIds'] = materiaIds;
      }
      
      await _repo.update(alumnoId, data);
      ref.invalidate(alumnosListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Desmatricula un alumno de su curso actual (pone cursoId en null).
  Future<bool> desmatricular(int alumnoId) async {
    state = const AsyncValue.loading();
    try {
      final actual = await _repo.findAlumnoById(alumnoId);
      final data = actual.toJson();
      data['cursoId'] = null;
      
      await _repo.update(alumnoId, data);
      ref.invalidate(alumnosListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Provider del notifier CRUD de alumnos.
final alumnosCrudProvider =
    AutoDisposeNotifierProvider<AlumnosCrudNotifier, AsyncValue<void>>(
  AlumnosCrudNotifier.new,
);




