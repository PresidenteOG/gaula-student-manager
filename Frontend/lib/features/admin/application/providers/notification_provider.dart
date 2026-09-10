import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/notification_model.dart';

class NotificationNotifier extends StateNotifier<AsyncValue<List<GaulaNotification>>> {
  final Ref _ref;

  NotificationNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final dio = _ref.read(dioClientProvider);
      final res = await dio.get(ApiConstants.notificaciones);
      final List<dynamic> data = res.data;
      final list = data.map((e) => GaulaNotification.fromJson(e)).toList();
      state = AsyncValue.data(list);
    } on DioException catch (e) {
      // 401 = auth not ready yet (token loading from SecureStorage). Show empty silently.
      if (e.response?.statusCode == 401) {
        state = const AsyncValue.data([]);
      } else {
        state = AsyncValue.error(e, e.stackTrace);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      final dio = _ref.read(dioClientProvider);
      await dio.patch(ApiConstants.notifMarkAsRead(id));
      
      if (state.hasValue) {
        state = AsyncValue.data(
          state.value!.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList()
        );
      }
    } catch (e) {
      // Log error but maintain UI state
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final dio = _ref.read(dioClientProvider);
      await dio.patch(ApiConstants.notifMarkAllAsRead);
      
      if (state.hasValue) {
        state = AsyncValue.data(
          state.value!.map((n) => n.copyWith(isRead: true)).toList()
        );
      }
    } catch (e) {
      // Log error
    }
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, AsyncValue<List<GaulaNotification>>>((ref) {
  return NotificationNotifier(ref);
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationProvider).asData?.value ?? [];
  return notifications.where((n) => !n.isRead).length;
});

extension on GaulaNotification {
  GaulaNotification copyWith({bool? isRead}) {
    return GaulaNotification(
      id: id,
      title: title,
      description: description,
      timestamp: timestamp,
      type: type,
      isRead: isRead ?? this.isRead,
      route: route,
      routeParams: routeParams,
    );
  }
}




