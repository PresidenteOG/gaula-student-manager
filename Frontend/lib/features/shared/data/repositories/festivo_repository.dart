import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/festivo_model.dart';

final festivoRepositoryProvider = Provider<FestivoRepository>((ref) {
  return FestivoRepository(ref.watch(dioClientProvider));
});

/// Repositorio de Festivos.
/// Se comunica con los endpoints del FestivoController del backend.
class FestivoRepository {
  final Dio _dio;
  FestivoRepository(this._dio);

  /// Obtiene los festivos filtrados por la provincia configurada.
  /// Este es el endpoint que usan Teacher y Student.
  Future<List<FestivoModel>> getFestivos(int anio) async {
    final response = await _dio.get(
      ApiConstants.festivos,
      queryParameters: {'anio': anio},
    );
    return (response.data as List)
        .map((json) => FestivoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Obtiene TODOS los festivos sin filtrar por provincia (solo Admin).
  Future<List<FestivoModel>> getFestivosCompletos(int anio) async {
    final response = await _dio.get(
      ApiConstants.festivosTodos,
      queryParameters: {'anio': anio},
    );
    return (response.data as List)
        .map((json) => FestivoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Obtiene la lista de CCAA disponibles con su código ISO.
  /// Usada por el selector de provincia del Administrador.
  Future<List<Map<String, String>>> getProvincias() async {
    final response = await _dio.get(ApiConstants.festivosProvincias);
    return (response.data as List)
        .map((json) => Map<String, String>.from(json as Map))
        .toList();
  }

  /// Obtiene la provincia actualmente configurada.
  Future<Map<String, String>> getProvinciaActual() async {
    final response = await _dio.get(ApiConstants.festivosProvinciaActual);
    return Map<String, String>.from(response.data as Map);
  }

  /// Cambia la provincia de festivos (solo Admin).
  /// El código ISO debe tener formato "ES-CT", "ES-MD", etc.
  Future<void> cambiarProvincia(String codigoISO) async {
    await _dio.put('${ApiConstants.festivosProvincia}/$codigoISO');
  }

  /// Sincroniza los festivos con la API externa (Nager.Date) para un año dado.
  Future<void> sincronizarFestivos(int anio) async {
    await _dio.post('${ApiConstants.festivos}/sync/$anio');
  }
}
