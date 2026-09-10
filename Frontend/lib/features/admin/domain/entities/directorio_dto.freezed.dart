// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'directorio_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DirectorioDto _$DirectorioDtoFromJson(Map<String, dynamic> json) {
  return _DirectorioDto.fromJson(json);
}

/// @nodoc
mixin _$DirectorioDto {
  String get nombre => throw _privateConstructorUsedError;
  String get ruta => throw _privateConstructorUsedError;
  bool get esDirectorio => throw _privateConstructorUsedError;

  /// Serializes this DirectorioDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DirectorioDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DirectorioDtoCopyWith<DirectorioDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DirectorioDtoCopyWith<$Res> {
  factory $DirectorioDtoCopyWith(
          DirectorioDto value, $Res Function(DirectorioDto) then) =
      _$DirectorioDtoCopyWithImpl<$Res, DirectorioDto>;
  @useResult
  $Res call({String nombre, String ruta, bool esDirectorio});
}

/// @nodoc
class _$DirectorioDtoCopyWithImpl<$Res, $Val extends DirectorioDto>
    implements $DirectorioDtoCopyWith<$Res> {
  _$DirectorioDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DirectorioDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombre = null,
    Object? ruta = null,
    Object? esDirectorio = null,
  }) {
    return _then(_value.copyWith(
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      ruta: null == ruta
          ? _value.ruta
          : ruta // ignore: cast_nullable_to_non_nullable
              as String,
      esDirectorio: null == esDirectorio
          ? _value.esDirectorio
          : esDirectorio // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DirectorioDtoImplCopyWith<$Res>
    implements $DirectorioDtoCopyWith<$Res> {
  factory _$$DirectorioDtoImplCopyWith(
          _$DirectorioDtoImpl value, $Res Function(_$DirectorioDtoImpl) then) =
      __$$DirectorioDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nombre, String ruta, bool esDirectorio});
}

/// @nodoc
class __$$DirectorioDtoImplCopyWithImpl<$Res>
    extends _$DirectorioDtoCopyWithImpl<$Res, _$DirectorioDtoImpl>
    implements _$$DirectorioDtoImplCopyWith<$Res> {
  __$$DirectorioDtoImplCopyWithImpl(
      _$DirectorioDtoImpl _value, $Res Function(_$DirectorioDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DirectorioDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombre = null,
    Object? ruta = null,
    Object? esDirectorio = null,
  }) {
    return _then(_$DirectorioDtoImpl(
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      ruta: null == ruta
          ? _value.ruta
          : ruta // ignore: cast_nullable_to_non_nullable
              as String,
      esDirectorio: null == esDirectorio
          ? _value.esDirectorio
          : esDirectorio // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DirectorioDtoImpl implements _DirectorioDto {
  const _$DirectorioDtoImpl(
      {required this.nombre, required this.ruta, required this.esDirectorio});

  factory _$DirectorioDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DirectorioDtoImplFromJson(json);

  @override
  final String nombre;
  @override
  final String ruta;
  @override
  final bool esDirectorio;

  @override
  String toString() {
    return 'DirectorioDto(nombre: $nombre, ruta: $ruta, esDirectorio: $esDirectorio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DirectorioDtoImpl &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.ruta, ruta) || other.ruta == ruta) &&
            (identical(other.esDirectorio, esDirectorio) ||
                other.esDirectorio == esDirectorio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nombre, ruta, esDirectorio);

  /// Create a copy of DirectorioDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DirectorioDtoImplCopyWith<_$DirectorioDtoImpl> get copyWith =>
      __$$DirectorioDtoImplCopyWithImpl<_$DirectorioDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DirectorioDtoImplToJson(
      this,
    );
  }
}

abstract class _DirectorioDto implements DirectorioDto {
  const factory _DirectorioDto(
      {required final String nombre,
      required final String ruta,
      required final bool esDirectorio}) = _$DirectorioDtoImpl;

  factory _DirectorioDto.fromJson(Map<String, dynamic> json) =
      _$DirectorioDtoImpl.fromJson;

  @override
  String get nombre;
  @override
  String get ruta;
  @override
  bool get esDirectorio;

  /// Create a copy of DirectorioDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DirectorioDtoImplCopyWith<_$DirectorioDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
