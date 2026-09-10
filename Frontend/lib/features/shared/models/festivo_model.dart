import 'package:freezed_annotation/freezed_annotation.dart';

part 'festivo_model.freezed.dart';
part 'festivo_model.g.dart';

/// Modelo de festivo público.
/// Mapea el JSON del endpoint GET /api/festivos.
/// Los datos vienen filtrados por la provincia configurada en el backend.
@freezed
class FestivoModel with _$FestivoModel {
  const factory FestivoModel({
    /// Fecha del festivo en formato ISO: "2025-12-25"
    required String date,

    /// Fecha como objeto DateTime (calculado en frontend).
    /// No viene del JSON, se calcula en fromJson.
    required String localName,    // "Navidad" (en el idioma local)
    required String name,         // "Christmas Day" (en inglés)

    /// Lista de CCAA donde aplica. Null = festivo nacional.
    /// Ej: ["ES-CT"] para Cataluña.
    List<String>? counties,

    /// True si es festivo nacional (aplica a toda España).
    @Default(true) bool isNational,
  }) = _FestivoModel;

  factory FestivoModel.fromJson(Map<String, dynamic> json) =>
      _$FestivoModelFromJson(json);
}

extension FestivoModelX on FestivoModel {
  /// Convierte la cadena de fecha a DateTime.
  DateTime get dateTime => DateTime.parse(date);

  /// Nombre para mostrar en la UI (preferir localName si existe).
  String get nombreMostrar =>
      localName.isNotEmpty ? localName : name;

  /// True si el festivo es autonómico (solo aplica a ciertas CCAA).
  bool get esAutonomico => counties != null && counties!.isNotEmpty;
}
