import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/providers/auth_provider.dart';
import '../data/repositories/horario_repository.dart';
import '../models/horario_model.dart';

/// Sesiones del curso especificado.
final cursoHorarioProvider = FutureProvider.family<List<HorarioSesionModel>, int>((ref, cursoId) async {
  final repo = ref.watch(horarioRepositoryProvider);
  return repo.getHorarioCurso(cursoId);
});

/// Sesiones de un profesor TODOS los días. (en este se especifica el ID de profesor)
final sesionesDeProfesorProvider = FutureProvider.family<List<HorarioSesionModel>, int>((ref, profesorId) async {
  final repo = ref.watch(horarioRepositoryProvider);
  return repo.getSesionesProfesor(profesorId);
});

/// Horario completo del profesor (basado en el ID de la sesión actual).
final horarioProfesorProvider = FutureProvider<List<HorarioSesionModel>>((ref) async {
  // Capturar estados reactivos
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.maybeWhen(
    authenticated: (user) => user.id,
    orElse: () => 1,
  );

  final repo = ref.watch(horarioRepositoryProvider);
  return repo.getSesionesProfesor(userId);
});

/// Horario completo del alumno (basado en el ID de la sesión actual).
final horarioAlumnoProvider = FutureProvider<List<HorarioSesionModel>>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.maybeWhen(
    authenticated: (user) => user.id,
    orElse: () => null,
  );
  if (userId == null) return [];

  final repo = ref.watch(horarioRepositoryProvider);
  return repo.getHorarioAlumno(userId);
});

/// Horario de un alumno específico por ID (usado por Admin/Profesores).
final studentHorarioProvider = FutureProvider.family<List<HorarioSesionModel>, int>((ref, studentId) async {
  final repo = ref.watch(horarioRepositoryProvider);
  return repo.getHorarioAlumno(studentId);
});

/// Notifier para operaciones CRUD sobre horarios.
class HorarioCrudNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  HorarioRepository get _repo => ref.read(horarioRepositoryProvider);

  Future<bool> crearSesion(Map<String, dynamic> data, int cursoId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.create(data);
      ref.invalidate(cursoHorarioProvider(cursoId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> desactivarSesion(int id, int cursoId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.hide(id);
      ref.invalidate(cursoHorarioProvider(cursoId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final horarioCrudProvider = AutoDisposeNotifierProvider<HorarioCrudNotifier, AsyncValue<void>>(
  HorarioCrudNotifier.new,
);
