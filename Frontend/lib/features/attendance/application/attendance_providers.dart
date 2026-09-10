import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/attendance_repository.dart';
import '../infrastructure/api_attendance_repository.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../domain/entities/class_attendance.dart';
import 'attendance_schedule_notifier.dart';
import 'attendance_session_notifier.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return ApiAttendanceRepository(dio, ref);
});

final attendanceScheduleNotifierProvider = StateNotifierProvider.autoDispose<AttendanceScheduleNotifier, AttendanceScheduleState>((ref) {
  return AttendanceScheduleNotifier(ref);
});

final attendanceSessionNotifierProvider = StateNotifierProvider.autoDispose.family<AttendanceSessionNotifier, AttendanceSessionState, String>((ref, sessionId) {
  return AttendanceSessionNotifier(ref, sessionId);
});

final studentAttendanceSummaryProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, alumnoId) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.getResumenAlumno(alumnoId);
});

final globalAttendanceHistoryProvider = FutureProvider.autoDispose<List<ClassAttendance>>((ref) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.getGlobalHistory();
});

final sessionDetailProvider = FutureProvider.autoDispose.family<List<dynamic>, ({String sessionId, String fecha})>((ref, arg) async {
  final dio = ref.watch(dioClientProvider);
  final response = await dio.get(ApiConstants.asistenciaSesionFecha(arg.sessionId, arg.fecha));
  return response.data as List<dynamic>;
});

final studentAttendanceRecordsProvider = FutureProvider.autoDispose.family<List<dynamic>, int>((ref, alumnoId) async {
  final dio = ref.watch(dioClientProvider);
  final res = await dio.get(ApiConstants.asistenciaAlumno(alumnoId.toString()));
  return res.data as List<dynamic>;
});

/// Elimina un registro de asistencia (tutor del curso o admin).
Future<void> eliminarAsistenciaRecord(WidgetRef ref, int asistenciaId, int alumnoId) async {
  final dio = ref.read(dioClientProvider);
  await dio.delete(ApiConstants.eliminarAsistencia(asistenciaId));
  ref.invalidate(studentAttendanceRecordsProvider(alumnoId));
  ref.invalidate(studentAttendanceSummaryProvider(alumnoId));
}

/// Justifica un registro de asistencia (tutor del curso o admin).
Future<void> justificarAsistenciaRecord(WidgetRef ref, int asistenciaId, int alumnoId, {String observaciones = ''}) async {
  final dio = ref.read(dioClientProvider);
  await dio.put(ApiConstants.justificarAsistencia(asistenciaId), queryParameters: {'observaciones': observaciones});
  ref.invalidate(studentAttendanceRecordsProvider(alumnoId));
  ref.invalidate(studentAttendanceSummaryProvider(alumnoId));
}

