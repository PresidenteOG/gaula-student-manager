import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/api_constants.dart';
import '../../auth/application/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/attendance_student.dart';
import '../domain/entities/schedule_session.dart';
import '../domain/value_objects/attendance_status.dart';
import '../domain/entities/class_attendance.dart';
import '../domain/repositories/attendance_repository.dart';

class ApiAttendanceRepository implements AttendanceRepository {
  final Dio _dio;
  final Ref _ref;

  ApiAttendanceRepository(this._dio, this._ref);

  /// Extrae el ID numérico de un sessionId, que puede ser "123" o "extra_123".
  static String _realSessionId(String sessionId) {
    if (sessionId.startsWith('extra_')) {
      return sessionId.replaceFirst('extra_', '');
    }
    return sessionId;
  }

  @override
  Future<ScheduleSession?> getSession(String sessionId) async {
    try {
      final response = await _dio.get(ApiConstants.obtenerSesion(sessionId));
      final dynamic json = response.data;
      return ScheduleSession(
        id: json['id'].toString(),
        time: '${json['horaInicio']} - ${json['horaFin']}',
        subject: json['materiaNombre'] ?? 'Materia',
        course: json['codigoGrupo'] ?? 'Curso',
        room: json['aula'] ?? 'Aula',
        date: DateTime.now(),
        isPending: true,
      );
    } catch (e) {
      // Sin datos reales, devolvemos lista vacía (no mocks)
      return null;
    }
  }

  @override
  Future<List<ScheduleSession>> getTodaySchedule() async {
    final usuario = _ref.read(usuarioActualProvider);
    if (usuario == null) return [];

    try {
      final response = await _dio.get(
        ApiConstants.sesionesPendientesHoy(usuario.id),
        queryParameters: {
          'filtroHoras': '',
          'quitarHechos': false
        }
      );
      final List data = response.data;
      return data.map((json) => ScheduleSession(
        id: json['sesionId'].toString(),
        time: '${json['hora']}',
        subject: json['materia'] ?? 'Materia',
        course: json['curso'] ?? 'Curso',
        room: json['aula'] ?? 'Aula',
        date: DateTime.now(),
        isPending: json['pendiente'] ?? true,
      )).toList();
    } catch (e) {
      // Sin datos reales, devolvemos lista vacía (no mocks)
      return [];
    }
  }

  @override
  Future<List<AttendanceStudent>> getStudentsForSession(String sessionId, {DateTime? date}) async {
    final realId = _realSessionId(sessionId);
    try {
      // 1. Load ALL students enrolled in this class's subject
      final studentsResponse = await _dio.get(ApiConstants.alumnosBySesion(realId));
      final List studentsData = studentsResponse.data;

      // 2. Load any existing attendance records for this date
      Map<String, String> existingStatus = {};
      Map<String, String> existingId = {};
      try {
        if (date != null) {
          final fecha = DateFormat('yyyy-MM-dd').format(date);
          final attendanceResponse = await _dio.get(ApiConstants.asistenciaSesionFecha(realId, fecha));
          final List attendanceData = attendanceResponse.data;
          for (final entry in attendanceData) {
            final alumnoId = entry['alumnoId']?.toString() ?? '';
            final estado = entry['estado']?.toString() ?? '';
            final attendId = entry['id']?.toString() ?? '';
            if (alumnoId.isNotEmpty && estado.isNotEmpty) {
              existingStatus[alumnoId] = estado;
              existingId[alumnoId] = attendId;
            }
          }
        }
      } catch (_) {
        // No existing records — start fresh (all pending)
      }

      // 3. Merge: enrolled students + their attendance status if recorded
      return studentsData.map((alumno) {
        final id = alumno['id']?.toString() ?? '';
        final statusStr = existingStatus[id];
        final status = statusStr != null
            ? AttendanceStatus.values.firstWhere(
                (e) => e.name.toUpperCase() == statusStr.toUpperCase(),
                orElse: () => AttendanceStatus.presente,
              )
            : null;
        return AttendanceStudent(
          id: id,
          name: alumno['nombreCompleto'] ?? '${alumno['nombre'] ?? ''} ${alumno['apellidos'] ?? ''}',
          avatar: alumno['avatar'] ?? '',
          status: status,
          attendanceId: existingId[id],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching students for session $sessionId: $e');
      return [];
    }
  }

  @override
  Future<List<ClassAttendance>> getHistory({String? dateFilter}) async {
    final usuario = _ref.read(usuarioActualProvider);
    if (usuario == null) return [];
    
    try {
      final response = await _dio.get(ApiConstants.historialClasesProfesor(usuario.id));
      final List data = response.data;
      return data.map((json) => ClassAttendance(
        id: json['id']?.toString() ?? '',
        sessionId: json['sesionId']?.toString() ?? '',
        date: json['fecha']?.toString() ?? '',
        hour: '${json['horaInicio']?.toString() ?? '??:??'} - ${json['horaFin']?.toString() ?? '??:??'}',
        subject: json['materiaNombre'] ?? 'Materia',
        course: json['codigoGrupo'] ?? 'Curso',
        profesor: json['profesor'],
        attended: (json['presentes'] as num?)?.toInt() ?? 0,
        absent: (json['ausentes'] as num?)?.toInt() ?? 0,
        late: (json['retrasos'] as num?)?.toInt() ?? 0,
        total: (json['total'] as num?)?.toInt() ?? (json['totalAlumnos'] as num?)?.toInt() ?? 0,
      )).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ClassAttendance>> getGlobalHistory() async {
    try {
      final response = await _dio.get(ApiConstants.clasesHistorialGlobal);
      final List data = response.data;
      return data.map((json) => ClassAttendance(
        id: json['id']?.toString() ?? '',
        sessionId: json['sesionId']?.toString() ?? '',
        date: json['fecha']?.toString() ?? '',
        hour: '${json['horaInicio']?.toString() ?? '??:??'} - ${json['horaFin']?.toString() ?? '??:??'}',
        subject: json['materiaNombre'] ?? 'Materia',
        course: json['codigoGrupo'] ?? 'Curso',
        profesor: json['profesor'],
        attended: (json['presentes'] as num?)?.toInt() ?? 0,
        absent: (json['ausentes'] as num?)?.toInt() ?? 0,
        late: (json['retrasos'] as num?)?.toInt() ?? 0,
        total: (json['totalAlumnos'] as num?)?.toInt() ?? 0,
      )).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> saveAttendance({
    required String sessionId,
    required List<AttendanceStudent> students,
    DateTime? date,
  }) async {
    final realId = _realSessionId(sessionId);
    try {
      final registros = students.map((s) => {
        'alumnoId': int.parse(s.id),
        'estado': s.status?.name.toUpperCase() ?? 'FALTA',
        'observaciones': ''
      }).toList();
      final data = {
        'horarioId': realId,
        'faltas': registros
      };

      await _dio.post(ApiConstants.clases, data: data,
        queryParameters: date != null ? {
          'fecha': DateFormat('yyyy-MM-dd').format(date)
        } : {});
      return true;
    } catch (e) {
      debugPrint('Error saving attendance: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getResumenAlumno(int alumnoId) async {
    try {
      final res = await _dio.get(ApiConstants.asistenciaResumenAlumno(alumnoId));
      final data = res.data as Map<String, dynamic>;
      
      return {
        'asistenciaTotal':       data['porcentajeAsistencia'] ?? 100,
        'faltasSinJustificar':   data['ausentes']    ?? 0,
        'faltasJustificadas':    data['justificados'] ?? 0,
        'retrasos':              data['retrasos']    ?? 0,
        'totalClases':           data['totalClases'] ?? 0,
        'presentes':             data['presentes']   ?? 0,
        'horasFaltadas':         data['horasFaltadas'] ?? 0,
        'modulos':               data['modulos'] ?? [],
        'maxPctFaltasPermitido': data['maxPctFaltasPermitido'] ?? 20.0,
        'modalidad':             data['modalidad'] ?? 'PRESENCIAL',
      };
    } catch (e) {
      return {
        'asistenciaTotal':     100,
        'faltasSinJustificar': 0,
        'faltasJustificadas':  0,
        'retrasos':            0,
        'totalClases':         0,
        'presentes':           0,
        'horasFaltadas':       0,
        'modulos':             [],
      };
    }
  }
}
