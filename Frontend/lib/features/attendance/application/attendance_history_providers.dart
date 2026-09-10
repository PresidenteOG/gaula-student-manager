import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/class_attendance.dart';
import '../application/attendance_providers.dart';

/// Filtro de búsqueda para el historial de asistencia.
final attendanceHistorySearchProvider = StateProvider<String>((ref) => '');

/// Filtro de curso para el historial de asistencia.
final attendanceHistoryCourseProvider = StateProvider<String?>((ref) => null);

/// Filtro de rango de fecha para el historial de asistencia.
final attendanceHistoryDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);

/// Página actual del historial.
final attendanceHistoryPageProvider = StateProvider<int>((ref) => 0);

/// Tamaño de página.
final attendanceHistoryPageSizeProvider = StateProvider<int>((ref) => 10);

/// Provider de historial filtrado y paginado.
final filteredAttendanceHistoryProvider = Provider<AsyncValue<List<ClassAttendance>>>((ref) {
  final historyAsync = ref.watch(globalAttendanceHistoryProvider);
  final searchQuery = ref.watch(attendanceHistorySearchProvider).toLowerCase();
  final selectedCourse = ref.watch(attendanceHistoryCourseProvider);
  final dateRange = ref.watch(attendanceHistoryDateRangeProvider);

  return historyAsync.whenData((records) {
    return records.where((r) {
      final matchesSearch = r.subject.toLowerCase().contains(searchQuery) ||
          (r.profesor?.toLowerCase().contains(searchQuery) ?? false);
      final matchesCourse = selectedCourse == null || r.course == selectedCourse;
      
      bool matchesDate = true;
      if (dateRange != null) {
        try {
          DateTime recordDate;
          if (r.date.contains('/')) {
            final parts = r.date.split('/');
            recordDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          } else if (r.date.contains('-')) {
            recordDate = DateTime.parse(r.date);
          } else {
            // Default parse
            recordDate = DateTime.parse(r.date);
          }
          
          // Normalizar a medianoche para comparar solo fechas
          final start = DateTime(dateRange.start.year, dateRange.start.month, dateRange.start.day);
          final end = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day, 23, 59, 59);
          final current = DateTime(recordDate.year, recordDate.month, recordDate.day);
          
          matchesDate = current.isAtSameMomentAs(start) || current.isAtSameMomentAs(end) || 
                        (current.isAfter(start) && current.isBefore(end));
        } catch (_) {}
      }
      return matchesSearch && matchesCourse && matchesDate;
    }).toList();
  });
});

/// Provider final que aplica la paginación sobre los resultados filtrados.
final paginatedAttendanceHistoryProvider = Provider<AsyncValue<List<ClassAttendance>>>((ref) {
  final filteredAsync = ref.watch(filteredAttendanceHistoryProvider);
  final page = ref.watch(attendanceHistoryPageProvider);
  final pageSize = ref.watch(attendanceHistoryPageSizeProvider);

  return filteredAsync.whenData((records) {
    final start = page * pageSize;
    if (start >= records.length) return [];
    final end = (start + pageSize).clamp(0, records.length);
    return records.sublist(start, end);
  });
});

/// Total de páginas del historial filtrado.
final attendanceHistoryTotalPagesProvider = Provider<int>((ref) {
  final filteredAsync = ref.watch(filteredAttendanceHistoryProvider);
  final pageSize = ref.watch(attendanceHistoryPageSizeProvider);
  
  return filteredAsync.maybeWhen(
    data: (records) => (records.length / pageSize).ceil(),
    orElse: () => 0,
  );
});
