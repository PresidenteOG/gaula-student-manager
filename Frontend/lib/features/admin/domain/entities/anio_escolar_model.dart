import 'package:flutter/foundation.dart';

/// Modelo de Año Escolar.
/// Mapea el JSON del endpoint GET /admin/anios-escolares.
@immutable
class AnioEscolarModel {
  const AnioEscolarModel({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.activo,
    this.descripcion,
    this.totalGrupos = 0,
    this.totalAlumnos = 0,
  });

  final int id;
  final String nombre;       // e.g. "2025-2026"
  final String fechaInicio;  // ISO date "2025-09-15"
  final String fechaFin;     // ISO date "2026-06-20"
  final bool activo;
  final String? descripcion;
  final int totalGrupos;
  final int totalAlumnos;

  factory AnioEscolarModel.fromJson(Map<String, dynamic> json) {
    int sumAlumnos = 0;
    if (json['grupos'] != null && json['grupos'] is List) {
      for (final g in json['grupos']) {
        if (g is Map && g['totalAlumnos'] != null) {
          sumAlumnos += (g['totalAlumnos'] as num).toInt();
        }
      }
    }
    return AnioEscolarModel(
      id:          json['id'] as int,
      nombre:      json['denominacion'] as String? ?? json['nombre'] as String? ?? '',
      fechaInicio: json['fechaInicio'] as String? ?? '',
      fechaFin:    json['fechaFin'] as String? ?? '',
      activo:      json['activo'] as bool? ?? false,
      descripcion: json['descripcion'] as String?,
      totalGrupos: json['totalGrupos'] as int? ?? 0,
      totalAlumnos: sumAlumnos,
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre':      nombre,
    'fechaInicio': fechaInicio,
    'fechaFin':    fechaFin,
    'activo':      activo,
    if (descripcion != null) 'descripcion': descripcion,
    'totalGrupos': totalGrupos,
    'totalAlumnos': totalAlumnos,
  };

  AnioEscolarModel copyWith({
    int? id,
    String? nombre,
    String? fechaInicio,
    String? fechaFin,
    bool? activo,
    String? descripcion,
    int? cursoPlantillaId,
    String? codigoCiclo,
    int? totalGrupos,
    int? totalAlumnos,
  }) {
    return AnioEscolarModel(
      id:          id          ?? this.id,
      nombre:      nombre      ?? this.nombre,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin:    fechaFin    ?? this.fechaFin,
      activo:      activo      ?? this.activo,
      descripcion: descripcion ?? this.descripcion,
      totalGrupos:      totalGrupos      ?? this.totalGrupos,
      totalAlumnos:     totalAlumnos     ?? this.totalAlumnos,
    );
  }
}
