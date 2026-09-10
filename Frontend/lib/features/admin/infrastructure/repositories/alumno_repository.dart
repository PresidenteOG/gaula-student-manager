import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/paginated_response.dart';
import '../../domain/entities/alumno_model.dart';

/// Provider del repositorio de alumnos.
final alumnoRepositoryProvider = Provider<AlumnoRepository>((ref) {
  return AlumnoRepository(ref.watch(dioClientProvider));
});

/// Repositorio de Alumnos.
/// Centraliza todas las llamadas HTTP al endpoint /api/alumnos.
class AlumnoRepository {
  final Dio _dio;
  AlumnoRepository(this._dio);

  /// Obtiene la lista completa de alumnos con paginación.
  /// Si [busqueda] no es null, filtra por nombre/apellidos.
  Future<PaginatedResponse<AlumnoModel>> findAll({
    String? busqueda,
    int? cursoId,
    int page = 0,
    int size = 10,
  }) async {
    final response = await _dio.get(
      ApiConstants.alumnos,
      queryParameters: {
        if (busqueda != null) 'busqueda': busqueda,
        if (cursoId != null) 'cursoId': cursoId,
        'page': page,
        'size': size,
      },
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => AlumnoModel.fromJson(json),
    );
  }

  /// Obtiene los alumnos de un curso especí­fico.
  Future<List<AlumnoModel>> findByCurso(int cursoId) async {
    final response = await _dio.get(ApiConstants.alumnosByCurso(cursoId));
    return (response.data as List)
        .map((json) => AlumnoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Obtiene un alumno por su ID.
  Future<AlumnoModel> findAlumnoById(int id) async {
    final response = await _dio.get(ApiConstants.alumnoById(id));
    return AlumnoModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Crea un nuevo alumno.
  Future<AlumnoModel> create(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.alumnos, data: data);
    return AlumnoModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Actualiza los datos de un alumno.
  Future<AlumnoModel> update(int id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.alumnoById(id), data: data);
    return AlumnoModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Cambia el estado de un alumno (ACTIVO / INACTIVO / DE_BAJA).
  Future<AlumnoModel> cambiarEstado(int id, String estado) async {
    final response = await _dio.patch(
      ApiConstants.alumnoEstado(id),
      queryParameters: {'estado': estado},
    );
    return AlumnoModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Actualiza las materias matriculadas de un alumno.
  Future<AlumnoModel> actualizarMaterias(int id, List<int> materiaIds) async {
    final response = await _dio.put(
      ApiConstants.alumnoMaterias(id),
      data: materiaIds,
    );
    return AlumnoModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Obtiene los alumnos sin curso asignado (para selector de matriculación).
  Future<List<AlumnoModel>> getAlumnosSinMatricular() async {
    final response = await _dio.get(ApiConstants.alumnosSinMatricular);
    return (response.data as List)
        .map((json) => AlumnoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Elimina un alumno.
  Future<void> delete(int id) async {
    await _dio.delete(ApiConstants.alumnoById(id));
  }
}

