import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/schedule_session.dart';
import '../domain/entities/class_attendance.dart';
import 'attendance_providers.dart';
import '../../auth/application/providers/auth_provider.dart';

class AttendanceScheduleState {
  final List<ScheduleSession> schedule;
  final List<ClassAttendance> history;
  final String dateFilter;
  final bool isLoading;
  final String? errorMessage;

  const AttendanceScheduleState({
    this.schedule = const [],
    this.history = const [],
    this.dateFilter = '',
    this.isLoading = true,
    this.errorMessage,
  });

  int get pendingCount => schedule.where((s) => s.isPending).length;

  List<ClassAttendance> get filteredHistory {
    if (dateFilter.isEmpty) return history;
    final q = dateFilter.toLowerCase();
    return history.where((h) => h.date.toLowerCase().contains(q)).toList();
  }

  AttendanceScheduleState copyWith({
    List<ScheduleSession>? schedule,
    List<ClassAttendance>? history,
    String? dateFilter,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AttendanceScheduleState(
      schedule:     schedule     ?? this.schedule,
      history:      history      ?? this.history,
      dateFilter:   dateFilter   ?? this.dateFilter,
      isLoading:    isLoading    ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AttendanceScheduleNotifier extends StateNotifier<AttendanceScheduleState> {
  final Ref _ref;

  AttendanceScheduleNotifier(this._ref) : super(const AttendanceScheduleState()) {
    _load();
  }

  void setDateFilter(String value) {
    state = state.copyWith(dateFilter: value);
  }

  void markCompleted(String sessionId) {
    final updated = state.schedule.map((s) {
      return s.id == sessionId ? s.copyWith(isPending: false) : s;
    }).toList();
    state = state.copyWith(schedule: updated);
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(attendanceRepositoryProvider);
      final usuario = _ref.read(usuarioActualProvider);
      final isAdmin = usuario?.esAdmin ?? false;

      final sched = await repo.getTodaySchedule();
      final history = isAdmin ? await repo.getGlobalHistory() : await repo.getHistory();
      
      state = state.copyWith(
        schedule: sched,
        history: history,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Error: $e');
    }
  }
}
