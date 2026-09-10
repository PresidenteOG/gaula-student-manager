import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';

final eventosProvider = FutureProvider.family<List<dynamic>, int?>((ref, cursoId) async {
  final dio = ref.watch(dioClientProvider);
  final response = await dio.get('eventos', queryParameters: cursoId != null ? {'cursoId': cursoId} : null);
  return response.data as List<dynamic>;
});
