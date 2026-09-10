import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/evento_model.dart';
import '../../../../core/network/dio_client.dart';

class FestivosNotifier extends StateNotifier<AsyncValue<List<EventoModel>>> {
  final Ref ref;

  FestivosNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchFestivos();
  }

  Future<void> fetchFestivos() async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.get('eventos');
      final List<dynamic> data = response.data;
      final list = data
          .map((e) => EventoModel.fromJson(e))
          .where((e) => e.tipo == 'FESTIVO')
          .toList();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addFestivo({
    required String titulo,
    required String fecha,
  }) async {
    try {
      final dio = ref.read(dioClientProvider);
      await dio.post('eventos', data: {
        'titulo': titulo,
        'descripcion': titulo,
        'fecha': fecha,
        'tipo': 'FESTIVO',
      });
      await fetchFestivos();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFestivo(int id) async {
    try {
      final dio = ref.read(dioClientProvider);
      await dio.delete('eventos/$id');
      await fetchFestivos();
    } catch (e) {
      rethrow;
    }
  }
}

final festivosProvider = StateNotifierProvider<FestivosNotifier, AsyncValue<List<EventoModel>>>((ref) {
  return FestivosNotifier(ref);
});



