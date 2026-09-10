import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/horario_model.dart';

final horarioRepositoryProvider = Provider<HorarioRepository>((ref) {
  return HorarioRepository(ref.watch(dioClientProvider));
});

/// Repositorio de Sesiones de horario.
/// Se comunica con los endpoints del HorarioController.
class HorarioRepository {
  final Dio _dio;
  HorarioRepository(this._dio);

  /// Obtiene el horario completo de un curso estructurado independientemente.
  Future<List<HorarioSesionModel>> getHorarioCurso(int cursoId) async {
    try {
      final response = await _dio.get(ApiConstants.horarioCurso(cursoId));
      return (response.data as List)
          .map((json) => HorarioSesionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Mock Data Fallback
      return [
        HorarioSesionModel(id: 1, diaSemana: 'MONDAY', diaEspanol: 'Lunes', horaInicio: '08:30', horaFin: '10:30', materiaNombre: 'Programación Multimedia', codigoGrupo: '2º DAM M', aula: 'Aula 2.1', colorCiclo: '#60A5FA', profesorNombre: 'Profesor García'),
        HorarioSesionModel(id: 3, diaSemana: 'TUESDAY', diaEspanol: 'Martes', horaInicio: '15:30', horaFin: '17:30', materiaNombre: 'Desarrollo Web', codigoGrupo: '1º DAW T', aula: 'Aula 1.2', colorCiclo: '#F472B6', profesorNombre: 'Profesor García'),
      ];
    }
  }

  /// Obtiene el horario completo de un profesor estructurado independientemente.
  Future<List<HorarioSesionModel>> getSesionesProfesor(int profesorId) async {
    try {
      final response = await _dio.get(ApiConstants.sesionesProfesor(profesorId));
      return (response.data as List)
          .map((json) => HorarioSesionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Mock Data Fallback
      return [
        HorarioSesionModel(id: 1, diaSemana: 'MONDAY', diaEspanol: 'Lunes', horaInicio: '08:30', horaFin: '10:30', materiaNombre: 'Programación Multimedia', codigoGrupo: '2º DAM M', aula: 'Aula 2.1', colorCiclo: '#60A5FA', profesorNombre: 'Profesor García'),
        HorarioSesionModel(id: 2, diaSemana: 'MONDAY', diaEspanol: 'Lunes', horaInicio: '10:30', horaFin: '12:30', materiaNombre: 'Sistemas de Gestión', codigoGrupo: '2º DAM M', aula: 'Aula 2.1', colorCiclo: '#34D399', profesorNombre: 'Profesor García'),
        HorarioSesionModel(id: 3, diaSemana: 'TUESDAY', diaEspanol: 'Martes', horaInicio: '15:30', horaFin: '17:30', materiaNombre: 'Desarrollo Web', codigoGrupo: '1º DAW T', aula: 'Aula 1.2', colorCiclo: '#F472B6', profesorNombre: 'Profesor García'),
      ];
    }
  }

  /// Obtiene el horario completo de un alumno.
  Future<List<HorarioSesionModel>> getHorarioAlumno(int alumnoId) async {
    try {
      final response = await _dio.get(ApiConstants.horarioAlumno(alumnoId));
      return (response.data as List)
          .map((json) => HorarioSesionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [
        HorarioSesionModel(id: 1, diaSemana: 'MONDAY', diaEspanol: 'Lunes', horaInicio: '08:30', horaFin: '10:30', materiaNombre: 'Bases de Datos', codigoGrupo: '1º DAW', aula: 'Aula 1.1', colorCiclo: '#FBBF24', profesorNombre: 'Profesora Martínez'),
      ];
    }
  }

  /// Crea una nueva sesión en el horario (requiere ADMIN).
  Future<HorarioSesionModel> create(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.horarios, data: data);
    return HorarioSesionModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Elimina una sesión del horario (requiere ADMIN).
  Future<void> hide(int id) async {
    await _dio.patch(ApiConstants.hideHorario(id));
  }
}
