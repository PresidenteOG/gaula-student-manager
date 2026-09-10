import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/reglamento_model.dart';

class ReglamentoRepository {
  final Dio _dio;
  ReglamentoRepository(this._dio);

  Future<ReglamentoModel> getActive() async {
    final res = await _dio.get(ApiConstants.reclamentoActivo);
    return ReglamentoModel.fromJson(res.data);
  }

  Future<List<ReglamentoModel>> getHistory() async {
    final res = await _dio.get(ApiConstants.reglamentoHistorial);
    return (res.data as List).map((e) => ReglamentoModel.fromJson(e)).toList();
  }

  Future<ReglamentoModel> save(String nombreVersion, String contenido, bool activo) async {
    final res = await _dio.post('reglamento', data: {
      'nombreVersion': nombreVersion,
      'contenido': contenido,
      'activo': activo,
    });
    return ReglamentoModel.fromJson(res.data);
  }

  Future<ReglamentoModel> activate(int id) async {
    final res = await _dio.patch(ApiConstants.reglamentoActivar(id));
    return ReglamentoModel.fromJson(res.data);
  }
}

final reglamentoRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioClientProvider);
  return ReglamentoRepository(dio);
});

final reglamentoActivoProvider = FutureProvider<ReglamentoModel>((ref) {
  return ref.watch(reglamentoRepositoryProvider).getActive();
});


