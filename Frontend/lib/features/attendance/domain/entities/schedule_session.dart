/// A scheduled class session the teacher must take attendance for.
class ScheduleSession {
  final String id;
  final String time;     // e.g. "09:00 - 10:30"
  final String subject;
  final String course;
  final String room;
  final DateTime date;
  final bool isPending;   // teacher has NOT saved attendance yet

  const ScheduleSession({
    required this.id,
    required this.time,
    required this.subject,
    required this.course,
    required this.room,
    required this.date,
    required this.isPending,
  });

  ScheduleSession copyWith({
    String? id,
    String? time,
    String? subject,
    String? course,
    String? room,
    DateTime? date,
    bool? isPending,
  }) {
    return ScheduleSession(
      id:          id          ?? this.id,
      time:        time        ?? this.time,
      subject:     subject     ?? this.subject,
      course:      course      ?? this.course,
      room:        room        ?? this.room,
      date:        date        ?? this.date,
      isPending:   isPending   ?? this.isPending,
    );
  }
}
