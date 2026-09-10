import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/attendance_student.dart';
import '../domain/entities/schedule_session.dart';
import '../domain/value_objects/attendance_status.dart';
import 'attendance_providers.dart';

class AttendanceSessionState {
  final ScheduleSession? session;
  final List<AttendanceStudent> students;
  final int currentIndex;
  final bool isOneByOne;
  final bool isSaving;
  final bool isLoading;
  final String? errorMessage;

  const AttendanceSessionState({
    this.session,
    this.students = const [],
    this.currentIndex = 0,
    this.isOneByOne = false,
    this.isSaving = false,
    this.isLoading = true,
    this.errorMessage,
  });

  bool get canSave => students.isNotEmpty && students.every((s) => s.isMarked) && !isSaving;
  int get markedCount => students.where((s) => s.isMarked).length;
  double get progressRatio => students.isEmpty ? 0.0 : markedCount / students.length;
  AttendanceStudent? get currentStudent => students.isNotEmpty && currentIndex < students.length ? students[currentIndex] : null;

  AttendanceSessionState copyWith({
    ScheduleSession? session,
    List<AttendanceStudent>? students,
    int? currentIndex,
    bool? isOneByOne,
    bool? isSaving,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AttendanceSessionState(
      session:       session       ?? this.session,
      students:      students      ?? this.students,
      currentIndex:  currentIndex  ?? this.currentIndex,
      isOneByOne:    isOneByOne    ?? this.isOneByOne,
      isSaving:      isSaving      ?? this.isSaving,
      isLoading:     isLoading     ?? this.isLoading,
      errorMessage:  errorMessage  ?? this.errorMessage,
    );
  }
}

class AttendanceSessionNotifier extends StateNotifier<AttendanceSessionState> {
  final Ref _ref;
  final String sessionId;

  AttendanceSessionNotifier(this._ref, this.sessionId) : super(const AttendanceSessionState()) {
    if (sessionId.isEmpty || sessionId == 'null' || sessionId.startsWith('null|')) {
      state = state.copyWith(isLoading: false, errorMessage: 'ID de sesión no válido');
      return;
    }
    _loadSession();
  }

  DateTime? get _sessionDate {
    if (!sessionId.contains('|')) return null;
    try {
      return DateTime.parse(sessionId.split('|')[1]);
    } catch (_) {
      return null;
    }
  }

  String get _realId => sessionId.split('|')[0];

  void setMode({required bool isOneByOne}) {
    state = state.copyWith(isOneByOne: isOneByOne);
  }

  void setCurrentIndex(int index) {
    if (index < 0 || index >= state.students.length) return;
    state = state.copyWith(currentIndex: index);
  }

  void recordStatus(String studentId, AttendanceStatus status, String? attendId) {
    final updated = state.students.map((s) {
      return s.id == studentId ? s.copyWith(status: status) : s;
    }).toList();

    state = state.copyWith(students: updated);

    if (state.isOneByOne && state.currentIndex < state.students.length - 1) {
      Future.delayed(const Duration(milliseconds: 280), () {
        if (mounted) {
          state = state.copyWith(currentIndex: state.currentIndex + 1);
        }
      });
    }
  }

  Future<bool> saveAttendance() async {
    if (!state.canSave) return false;
    state = state.copyWith(isSaving: true);

    try {
      final repo = _ref.read(attendanceRepositoryProvider);
      final ok = await repo.saveAttendance(
        sessionId: _realId,
        students: state.students,
        date: _sessionDate,
      );
      if (ok) {
        _ref.read(attendanceScheduleNotifierProvider.notifier).markCompleted(_realId);
      }
      return ok;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error al guardar: $e');
      return false;
    } finally {
      if (mounted) state = state.copyWith(isSaving: false);
    }
  }

  Future<void> _loadSession() async {
    try {
      final repo     = _ref.read(attendanceRepositoryProvider);
      final date     = _sessionDate ?? DateTime.now();//si no estas corrigiendo, la estas pasando para hoy SI O SI

      // Buscamos la sesión en el horario de hoy
      ScheduleSession session = await repo.getSession(_realId) ?? ScheduleSession(
        id: _realId,
        time: 'Sesión',
        subject: 'Clase del Historial',
        course: '',
        room: '',
        date: date,
        isPending: true,
      );

      final raw = await repo.getStudentsForSession(_realId, date: date);
      final students = raw
          .map((s) => s.status == null
              ? s.copyWith(status: AttendanceStatus.presente)
              : s)
          .toList();
      state = state.copyWith(
        session: session.copyWith(date: date),
        students: students,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Error: $e');
    }
  }
}
