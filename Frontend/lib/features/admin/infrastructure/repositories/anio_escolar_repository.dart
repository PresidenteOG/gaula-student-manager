import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/anio_escolar_model.dart';

final anioEscolarRepositoryProvider = Provider<AnioEscolarRepository>((ref) {
  return AnioEscolarRepository(ref.watch(dioClientProvider));
});

class AnioEscolarRepository {
  final Dio _dio;
  AnioEscolarRepository(this._dio);

  /// GET /admin/anios-escolares
  Future<List<AnioEscolarModel>> findAll() async {
    final response = await _dio.get(ApiConstants.adminAniosEscolares);
    return (response.data as List)
        .map((json) => AnioEscolarModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// POST /admin/anios-escolares
  Future<AnioEscolarModel> create(Map<String, dynamic> data) async {
    final response =
        await _dio.post(ApiConstants.adminAniosEscolares, data: data);
    return AnioEscolarModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// PUT /admin/anios-escolares/{id}
  Future<AnioEscolarModel> update(int id, Map<String, dynamic> data) async {
    final response =
        await _dio.put(ApiConstants.adminCursoEscolarById(id), data: data);
    return AnioEscolarModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// PATCH /admin/anios-escolares/{id}/activar
  Future<AnioEscolarModel> activar(int id) async {
    final response =
        await _dio.patch(ApiConstants.adminActivarEscolar(id));
    return AnioEscolarModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// PATCH /admin/anios-escolares/{id}/desactivar
  Future<AnioEscolarModel> desactivar(int id) async {
    final response =
        await _dio.patch(ApiConstants.adminDesactivarEscolar(id));
    return AnioEscolarModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// DELETE /admin/anios-escolares/{id}
  Future<void> delete(int id) async {
    await _dio.delete(ApiConstants.adminCursoEscolarById(id));
  }
}

