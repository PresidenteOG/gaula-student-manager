import '../value_objects/attendance_status.dart';

/// A student as seen from the Attendance domain context.
/// Intentionally minimal — only the data needed to take attendance.
class AttendanceStudent {
  final String id;
  final String name;
  final String avatar; // emoji or image URL
  final AttendanceStatus? status; // null = not yet recorded
  final String? attendanceId;

  const AttendanceStudent({
    required this.id,
    required this.name,
    required this.avatar,
    this.status,
    this.attendanceId,
  });

  /// Returns a new instance with an updated status (immutable pattern).
  AttendanceStudent copyWith({AttendanceStatus? status}) {
    return AttendanceStudent(
      id: id,
      name: name,
      avatar: avatar,
      status: status ?? this.status,
      attendanceId: attendanceId,
    );
  }

  /// Business Rule: this student has been marked if status is non-null.
  bool get isMarked => status != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceStudent && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
