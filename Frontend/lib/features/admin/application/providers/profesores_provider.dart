import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/profesor_model.dart';
import '../../infrastructure/repositories/profesor_repository.dart';
import '../../../../core/network/paginated_response.dart';

/// Texto de búsqueda de profesores.
final profesoresBusquedaProvider = StateProvider<String>((ref) => '');

/// Filtro de rol activo: null = todos, "TEACHER", "ADMIN".
final profesoresRolFiltroProvider = StateProvider<String?>((ref) => 'TEACHER');

/// Filtro de curso activo: null = todos.
final profesoresCursoFiltroProvider = StateProvider<int?>((ref) => null);

/// Página actual de la lista de profesores.
final profesoresPageProvider = StateProvider<int>((ref) => 0);

/// Tamaño de página para la lista de profesores.
final profesoresPageSizeProvider = StateProvider<int>((ref) => 100);


/// Lista de profesores reactiva a búsqueda, filtro de rol, curso y paginación.
final profesoresListProvider = FutureProvider<PaginatedResponse<ProfesorModel>>((ref) async {
  final busqueda = ref.watch(profesoresBusquedaProvider);
  final rol      = ref.watch(profesoresRolFiltroProvider);
  final cursoId  = ref.watch(profesoresCursoFiltroProvider);
  final page     = ref.watch(profesoresPageProvider);
  final size     = ref.watch(profesoresPageSizeProvider);
  final repo     = ref.watch(profesorRepositoryProvider);
  
  return repo.findAll(
    busqueda: busqueda.isEmpty ? null : busqueda,
    rol:      rol,
    cursoId:  cursoId,
    page:     page,
    size:     size,
  );
});

/// Notifier CRUD de Profesores.
class ProfesoresCrudNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  ProfesorRepository get _repo => ref.read(profesorRepositoryProvider);

  Future<bool> crear(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _repo.create(data);
      ref.invalidate(profesoresListProvider);
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
      ref.invalidate(profesoresListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> cambiarEstado(int id, String nuevoEstado) async {
    state = const AsyncValue.loading();
    try {
      await _repo.cambiarEstado(id, nuevoEstado);
      ref.invalidate(profesoresListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Asigna o elimina un sustituto.
  Future<bool> asignarSustituto(int profesorId, int? sustitutoId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.asignarSustituto(profesorId, sustitutoId);
      ref.invalidate(profesoresListProvider);
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
      ref.invalidate(profesoresListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final profesoresCrudProvider =
    AutoDisposeNotifierProvider<ProfesoresCrudNotifier, AsyncValue<void>>(
  ProfesoresCrudNotifier.new,
);




