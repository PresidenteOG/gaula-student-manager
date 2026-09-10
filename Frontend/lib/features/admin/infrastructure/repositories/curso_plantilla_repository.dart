import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/curso_plantilla_model.dart';

final cursoPlantillaRepositoryProvider = Provider<CursoPlantillaRepository>((ref) {
  return CursoPlantillaRepository(ref.watch(dioClientProvider));
});

/// Repositorio de Cursos y Materias.
class CursoPlantillaRepository {
  final Dio _dio;
  CursoPlantillaRepository(this._dio);

  /// Lista todos los cursos.
  Future<List<CursoPlantillaModel>> findAll() async {
    final response = await _dio.get(ApiConstants.cursoPlantillas);
    return (response.data as List)
        .map((json) => CursoPlantillaModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Crea un nuevo curso.
  Future<CursoPlantillaModel> create(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.cursoPlantillas, data: data);
    return CursoPlantillaModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Actualiza un curso.
  Future<CursoPlantillaModel> update(int id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.cursoPlantillaById(id), data: data);
    return CursoPlantillaModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Enlaza materias a un curso.
  Future<CursoPlantillaModel> actualizarMaterias(int cursoId, List<int> materiaIds) async {
    final response = await _dio.put(
      ApiConstants.cursoPlantillaMaterias(cursoId),
      data: materiaIds,
    );
    return CursoPlantillaModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Elimina un curso.
  Future<void> delete(int id) async {
    await _dio.delete(ApiConstants.cursoPlantillaById(id));
  }
}

