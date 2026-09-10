import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/paginated_response.dart';
import '../../domain/entities/profesor_model.dart';

final profesorRepositoryProvider = Provider<ProfesorRepository>((ref) {
  return ProfesorRepository(ref.watch(dioClientProvider));
});

/// Repositorio de Profesores.
class ProfesorRepository {
  final Dio _dio;
  ProfesorRepository(this._dio);

  /// Lista todos los profesores con paginación, opcionalmente filtrados por búsqueda o rol.
  Future<PaginatedResponse<ProfesorModel>> findAll({
    String? busqueda,
    String? rol,
    int? cursoId,
    int page = 0,
    int size = 10,
  }) async {
    final response = await _dio.get(
      ApiConstants.profesores,
      queryParameters: {
        if (busqueda != null) 'busqueda': busqueda,
        if (rol != null) 'rol': rol,
        if (cursoId != null) 'cursoId': cursoId,
        'page': page,
        'size': size,
      },
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => ProfesorModel.fromJson(json),
    );
  }

  /// Obtiene un profesor por ID.
  Future<ProfesorModel> findById(int id) async {
    final response = await _dio.get(ApiConstants.profesorById(id));
    return ProfesorModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Crea un nuevo profesor.
  Future<ProfesorModel> create(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.profesores, data: data);
    return ProfesorModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Actualiza datos del profesor.
  Future<ProfesorModel> update(int id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.profesorById(id), data: data);
    return ProfesorModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Cambia el estado del profesor (ACTIVO / INACTIVO / DE_BAJA).
  Future<ProfesorModel> cambiarEstado(int id, String estado) async {
    final response = await _dio.patch(
      ApiConstants.profesorEstado(id),
      queryParameters: {'estado': estado},
    );
    return ProfesorModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Asigna o elimina el sustituto de un profesor de baja.
  /// Pasa sustitutoId = null para eliminar la sustitución.
  Future<ProfesorModel> asignarSustituto(int profesorId, int? sustitutoId) async {
    final response = await _dio.patch(
      ApiConstants.profesorSustituto(profesorId),
      queryParameters: sustitutoId != null ? {'sustitutoId': sustitutoId} : null,
    );
    return ProfesorModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Elimina un profesor.
  Future<void> delete(int id) async {
    await _dio.delete(ApiConstants.profesorById(id));
  }
}

