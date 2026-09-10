/// A historical attendance record shown in the sidebar history panel.
class ClassAttendance {
  final String id;
  final String sessionId;
  final String date;    // Human-readable, e.g. "28 Abr 2026"
  final String hour;
  final String subject;
  final String course;
  final int attended;
  final int absent;
  final int late;
  final int total;
  final String? profesor;

  const ClassAttendance({
    required this.id,
    required this.sessionId,
    required this.date,
    required this.hour,
    required this.subject,
    required this.course,
    required this.attended,
    required this.absent,
    required this.late,
    required this.total,
    this.profesor,
  });

  /// Attendance percentage [0.0 – 1.0] los retrasos cuentan como que atendieron la clase
  double get attendanceRatio => total > 0 ? (total - absent) / total : 0.0;
}
