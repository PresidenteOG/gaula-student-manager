import '../entities/attendance_student.dart';
import '../entities/schedule_session.dart';
import '../entities/class_attendance.dart';

/// Abstract contract for the Attendance data source.
/// The application layer depends ONLY on this interface,
/// never on a concrete implementation (mock or API).
abstract class AttendanceRepository {
  Future<ScheduleSession?> getSession(String sessionId);

  /// Returns today's class schedule for the authenticated teacher.
  Future<List<ScheduleSession>> getTodaySchedule();

  /// Returns a fresh roster or existing one for a given session and date.
  Future<List<AttendanceStudent>> getStudentsForSession(String sessionId, {DateTime? date});

  /// Returns the historical records, optionally filtered by a date substring.
  Future<List<ClassAttendance>> getHistory({String? dateFilter});

  /// Returns global historical records (Admin only).
  Future<List<ClassAttendance>> getGlobalHistory();

  /// Persists the attendance list for a session.
  /// Returns true on success.
  Future<bool> saveAttendance({
    required String sessionId,
    required List<AttendanceStudent> students,
    DateTime? date,
  });

  /// Returns a summary of attendance/hours for a specific student.
  Future<Map<String, dynamic>> getResumenAlumno(int alumnoId);
}
