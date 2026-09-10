import 'package:freezed_annotation/freezed_annotation.dart';

part 'directorio_dto.freezed.dart';
part 'directorio_dto.g.dart';

@freezed
class DirectorioDto with _$DirectorioDto {
  const factory DirectorioDto({
    required String nombre,
    required String ruta,
    required bool esDirectorio,
  }) = _DirectorioDto;

  factory DirectorioDto.fromJson(Map<String, dynamic> json) => _$DirectorioDtoFromJson(json);
}
