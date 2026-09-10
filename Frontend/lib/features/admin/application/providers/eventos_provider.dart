import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/evento_model.dart';
import '../../../../core/network/dio_client.dart';

class EventosNotifier extends StateNotifier<AsyncValue<List<EventoModel>>> {
  final Ref ref;

  EventosNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchEventos();
  }

  Future<void> fetchEventos({int? cursoId}) async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.get(
        'eventos',
        queryParameters: cursoId != null ? {'cursoId': cursoId} : null,
      );
      final List<dynamic> data = response.data;
      final list = data.map((e) => EventoModel.fromJson(e)).toList();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addEvento({
    required String titulo,
    required String descripcion,
    required String fecha,
    required String tipo,
    int? cursoId,
  }) async {
    try {
      final dio = ref.read(dioClientProvider);
      await dio.post('eventos', data: {
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': fecha,
        'tipo': tipo,
        'cursoId': cursoId,
      });
      await fetchEventos(cursoId: cursoId);
    } catch (e) {
      // Re-throw for UI to handle or handle here
      rethrow;
    }
  }

  Future<void> deleteEvento(int id, {int? cursoId}) async {
    try {
      final dio = ref.read(dioClientProvider);
      await dio.delete('eventos/$id');
      await fetchEventos(cursoId: cursoId);
    } catch (e) {
      rethrow;
    }
  }
}

final eventosProvider = StateNotifierProvider<EventosNotifier, AsyncValue<List<EventoModel>>>((ref) {
  return EventosNotifier(ref);
});



