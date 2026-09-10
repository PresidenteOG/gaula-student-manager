import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/incidencia_model.dart';
import '../../../core/network/paginated_response.dart';
import '../data/repositories/incidencia_repository.dart';

import '../../auth/application/providers/auth_provider.dart';

final incidenciaFiltroAlumnoProvider = StateProvider<int?>((ref) => null);
final incidenciaFiltroProfesorProvider = StateProvider<int?>((ref) => null);
final incidenciaFiltroCursoProvider = StateProvider<int?>((ref) => null);
final incidenciaFiltroStatusProvider = StateProvider<String>((ref) => 'todas');
final incidenciaFiltroResolucionProvider = StateProvider<String>((ref) => 'todas');
final incidenciaPageProvider = StateProvider<int>((ref) => 0);
final incidenciaPageSizeProvider = StateProvider<int>((ref) => 4);

final incidenciaListProvider = FutureProvider<PaginatedResponse<IncidenciaModel>>((ref) async {
  final repo = ref.watch(incidenciaRepositoryProvider);
  final usuario = ref.watch(usuarioActualProvider);

  // Watch filters even for students so the provider invalidates when they change
  final estado = ref.watch(incidenciaFiltroStatusProvider);
  final resolucion = ref.watch(incidenciaFiltroResolucionProvider);
  final alumnoId = ref.watch(incidenciaFiltroAlumnoProvider);
  final profesorId = ref.watch(incidenciaFiltroProfesorProvider);
  final cursoId = ref.watch(incidenciaFiltroCursoProvider);
  final page = ref.watch(incidenciaPageProvider);
  final size = ref.watch(incidenciaPageSizeProvider);

  if (usuario?.esAlumno ?? false) {
    // Students use the /alumno/{id} endpoint — apply filters client-side
    final all = await repo.findByAlumno(usuario!.id);
    var filtered = all.content;

    if (estado != 'todas' && estado.isNotEmpty) {
      filtered = filtered.where((i) => i.estado.toUpperCase() == estado.toUpperCase()).toList();
    }
    if (resolucion != 'todas' && resolucion.isNotEmpty) {
      filtered = filtered.where((i) => i.resolucion?.toUpperCase() == resolucion.toUpperCase()).toList();
    }

    return PaginatedResponse(
      content: filtered,
      totalElements: filtered.length,
      totalPages: 1,
      size: filtered.length,
      number: 0,
      first: true,
      last: true,
    );
  }

  return repo.findAll(
    alumnoId: alumnoId,
    profesorId: profesorId,
    cursoId: cursoId,
    estado: estado,
    resolucion: resolucion,
    page: page,
    size: size,
  );
});


class IncidenciaCrudNotifier extends StateNotifier<AsyncValue<void>> {
  final IncidenciaRepository _repo;
  final Ref _ref;

  IncidenciaCrudNotifier(this._repo, this._ref) : super(const AsyncValue.data(null));

  Future<bool> crear(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _repo.create(data);
      _ref.invalidate(incidenciaListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updateEstado(int id, String estado, {String? resolucion}) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateEstado(id, estado, resolucion: resolucion);
      _ref.invalidate(incidenciaListProvider);
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
      _ref.invalidate(incidenciaListProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final incidenciaCrudProvider = StateNotifierProvider<IncidenciaCrudNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(incidenciaRepositoryProvider);
  return IncidenciaCrudNotifier(repo, ref);
});




