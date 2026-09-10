import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/incidencia_model.dart';

class IncidenciaRepository {
  final Dio _dio;
  IncidenciaRepository(this._dio);

  Future<PaginatedResponse<IncidenciaModel>> findAll({int? alumnoId, int? profesorId, int? cursoId, String? estado, String? resolucion, int page = 0, int size = 10}) async {
    final res = await _dio.get(
      ApiConstants.incidencias, 
      queryParameters: {
        if (alumnoId != null) 'alumnoId': alumnoId,
        if (profesorId != null) 'profesorId': profesorId,
        if (cursoId != null) 'cursoId': cursoId,
        if (estado != null && estado != 'todas') 'estado': estado.toUpperCase(),
        if (resolucion != null && resolucion != 'todas') 'resolucion': resolucion.toUpperCase(),
        'page': page,
        'size': size,
      }
    );
    return PaginatedResponse.fromJson(res.data, (json) => IncidenciaModel.fromJson(json));
  }

  Future<PaginatedResponse<IncidenciaModel>> findByAlumno(int alumnoId) async {
    final res = await _dio.get(ApiConstants.incidenciasByAlumno(alumnoId));
    final data = res.data;
    final List list = (data is Map) ? (data['content'] ?? []) : (data as List);
    final content = list.map((e) => IncidenciaModel.fromJson(e)).toList();
    return PaginatedResponse(
      content: content,
      totalElements: content.length,
      totalPages: 1,
      size: content.length,
      number: 0,
      first: true,
      last: true,
    );
  }

  Future<IncidenciaModel> create(Map<String, dynamic> data) async {
    final res = await _dio.post(ApiConstants.incidencias, data: data);
    return IncidenciaModel.fromJson(res.data);
  }

  Future<IncidenciaModel> updateEstado(int id, String estado, {String? resolucion}) async {
    final res = await _dio.patch(
      ApiConstants.incidenciaEstado(id), 
      queryParameters: {
        'estado': estado,
        if (resolucion != null) 'resolucion': resolucion,
      }
    );
    return IncidenciaModel.fromJson(res.data);
  }

  Future<void> delete(int id) async {
    await _dio.delete(ApiConstants.incidenciaById(id));
  }
}

final incidenciaRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioClientProvider);
  return IncidenciaRepository(dio);
});
