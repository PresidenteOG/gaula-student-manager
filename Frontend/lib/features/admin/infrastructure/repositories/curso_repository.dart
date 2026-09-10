import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../shared/models/curso_model.dart';

final cursoRepositoryProvider = Provider<CursoRepository>((ref) {
  return CursoRepository(ref.watch(dioClientProvider));
});

/// Repositorio de Cursos y Materias.
class CursoRepository {
  final Dio _dio;
  CursoRepository(this._dio);

  /// Lista todos los cursos.
  Future<List<CursoModel>> findAll() async {
    final response = await _dio.get(ApiConstants.cursos);
    return (response.data as List)
        .map((json) => CursoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Lista los cursos de un año escolar especí­fico.
  Future<List<CursoModel>> findByAnio(int anioEscolarId) async {
    final response = await _dio.get(ApiConstants.cursosByEscolar(anioEscolarId));
    return (response.data as List)
        .map((json) => CursoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Crea un nuevo curso.
  Future<CursoModel> create(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.cursos, data: data);
    return CursoModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Actualiza un curso.
  Future<CursoModel> update(int id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.cursoById(id), data: data);
    return CursoModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Asigna un tutor al curso.
  Future<CursoModel> asignarTutor(int cursoId, int profesorId) async {
    final response = await _dio.patch(
      ApiConstants.cursoTutor(cursoId, profesorId),
    );
    return CursoModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Enlaza materias a un curso.
  Future<CursoModel> actualizarMaterias(int cursoId, List<int> materiaIds) async {
    final response = await _dio.put(
      ApiConstants.cursoMaterias(cursoId),
      data: materiaIds,
    );
    return CursoModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Elimina un curso.
  Future<void> delete(int id) async {
    await _dio.delete(ApiConstants.cursoById(id));
  }

  /// Obtiene las materias de un curso.
  Future<List<dynamic>> findMateriasByCurso(int cursoId) async {
    final response = await _dio.get(ApiConstants.cursoMaterias(cursoId));
    return response.data as List;
  }

  /// Obtiene las clases (sesiones de horario) de una materia por su ID.
  Future<List<dynamic>> findClasesByMateria(int materiaId) async {
    final response = await _dio.get('horarios/materia/$materiaId');
    return response.data as List;
  }

  /// Genera automáticamente el horario para un curso (requiere ADMIN).
  Future<void> generarHorario(int cursoId) async {
    await _dio.post(ApiConstants.adminGenerarHorario(cursoId));
  }

  /// Actualiza el color de una materia (requiere ADMIN).
  Future<void> updateMateriaColor(int materiaId, String hexColor) async {
    await _dio.patch(
      ApiConstants.adminMateriaColor(materiaId),
      queryParameters: {'color': hexColor},
    );
  }
}

