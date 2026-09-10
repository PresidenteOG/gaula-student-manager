import 'package:flutter/foundation.dart';

@immutable
class IncidenciaModel {
  final int id;
  final int alumnoId;
  final String alumnoNombre;
  final int? cursoId;
  final String? cursoCodigo;
  final int profesorId;
  final String profesorNombre;
  final String titulo;
  final String descripcion;
  final String gravedad;
  final String estado;
  final String? resolucion;
  final String fechaIncidencia;

  const IncidenciaModel({
    required this.id,
    required this.alumnoId,
    required this.alumnoNombre,
    this.cursoId,
    this.cursoCodigo,
    required this.profesorId,
    required this.profesorNombre,
    required this.titulo,
    required this.descripcion,
    required this.gravedad,
    required this.estado,
    this.resolucion,
    required this.fechaIncidencia,
  });

  factory IncidenciaModel.fromJson(Map<String, dynamic> json) {
    return IncidenciaModel(
      id: json['id'] as int,
      alumnoId: json['alumnoId'] as int,
      alumnoNombre: json['alumnoNombre'] as String,
      cursoId: json['cursoId'] as int?,
      cursoCodigo: json['cursoCodigo'] as String?,
      profesorId: json['profesorId'] as int,
      profesorNombre: json['profesorNombre'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      gravedad: json['gravedad'] as String,
      estado: json['estado'] as String,
      resolucion: json['resolucion'] as String?,
      fechaIncidencia: json['fechaIncidencia'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'alumnoId': alumnoId,
    'alumnoNombre': alumnoNombre,
    'cursoId': cursoId,
    'cursoCodigo': cursoCodigo,
    'profesorId': profesorId,
    'profesorNombre': profesorNombre,
    'titulo': titulo,
    'descripcion': descripcion,
    'gravedad': gravedad,
    'estado': estado,
    'fechaIncidencia': fechaIncidencia,
  };

  IncidenciaModel copyWith({
    int? id,
    int? alumnoId,
    String? alumnoNombre,
    int? cursoId,
    String? cursoCodigo,
    int? profesorId,
    String? profesorNombre,
    String? titulo,
    String? descripcion,
    String? gravedad,
    String? estado,
    String? Function()? resolucion,
    String? fechaIncidencia,
  }) {
    return IncidenciaModel(
      id: id ?? this.id,
      alumnoId: alumnoId ?? this.alumnoId,
      alumnoNombre: alumnoNombre ?? this.alumnoNombre,
      cursoId: cursoId ?? this.cursoId,
      cursoCodigo: cursoCodigo ?? this.cursoCodigo,
      profesorId: profesorId ?? this.profesorId,
      profesorNombre: profesorNombre ?? this.profesorNombre,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      gravedad: gravedad ?? this.gravedad,
      estado: estado ?? this.estado,
      resolucion: resolucion != null ? resolucion() : this.resolucion,
      fechaIncidencia: fechaIncidencia ?? this.fechaIncidencia,
    );
  }
}
