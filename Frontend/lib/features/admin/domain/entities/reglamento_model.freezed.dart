// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reglamento_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReglamentoModel _$ReglamentoModelFromJson(Map<String, dynamic> json) {
  return _ReglamentoModel.fromJson(json);
}

/// @nodoc
mixin _$ReglamentoModel {
  int get id => throw _privateConstructorUsedError;
  String get nombreVersion => throw _privateConstructorUsedError;
  String get contenido => throw _privateConstructorUsedError;
  DateTime get fechaCreacion => throw _privateConstructorUsedError;
  String get creadoPor => throw _privateConstructorUsedError;
  bool get activo => throw _privateConstructorUsedError;

  /// Serializes this ReglamentoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReglamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReglamentoModelCopyWith<ReglamentoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReglamentoModelCopyWith<$Res> {
  factory $ReglamentoModelCopyWith(
          ReglamentoModel value, $Res Function(ReglamentoModel) then) =
      _$ReglamentoModelCopyWithImpl<$Res, ReglamentoModel>;
  @useResult
  $Res call(
      {int id,
      String nombreVersion,
      String contenido,
      DateTime fechaCreacion,
      String creadoPor,
      bool activo});
}

/// @nodoc
class _$ReglamentoModelCopyWithImpl<$Res, $Val extends ReglamentoModel>
    implements $ReglamentoModelCopyWith<$Res> {
  _$ReglamentoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReglamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreVersion = null,
    Object? contenido = null,
    Object? fechaCreacion = null,
    Object? creadoPor = null,
    Object? activo = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombreVersion: null == nombreVersion
          ? _value.nombreVersion
          : nombreVersion // ignore: cast_nullable_to_non_nullable
              as String,
      contenido: null == contenido
          ? _value.contenido
          : contenido // ignore: cast_nullable_to_non_nullable
              as String,
      fechaCreacion: null == fechaCreacion
          ? _value.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as DateTime,
      creadoPor: null == creadoPor
          ? _value.creadoPor
          : creadoPor // ignore: cast_nullable_to_non_nullable
              as String,
      activo: null == activo
          ? _value.activo
          : activo // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReglamentoModelImplCopyWith<$Res>
    implements $ReglamentoModelCopyWith<$Res> {
  factory _$$ReglamentoModelImplCopyWith(_$ReglamentoModelImpl value,
          $Res Function(_$ReglamentoModelImpl) then) =
      __$$ReglamentoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nombreVersion,
      String contenido,
      DateTime fechaCreacion,
      String creadoPor,
      bool activo});
}

/// @nodoc
class __$$ReglamentoModelImplCopyWithImpl<$Res>
    extends _$ReglamentoModelCopyWithImpl<$Res, _$ReglamentoModelImpl>
    implements _$$ReglamentoModelImplCopyWith<$Res> {
  __$$ReglamentoModelImplCopyWithImpl(
      _$ReglamentoModelImpl _value, $Res Function(_$ReglamentoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReglamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreVersion = null,
    Object? contenido = null,
    Object? fechaCreacion = null,
    Object? creadoPor = null,
    Object? activo = null,
  }) {
    return _then(_$ReglamentoModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombreVersion: null == nombreVersion
          ? _value.nombreVersion
          : nombreVersion // ignore: cast_nullable_to_non_nullable
              as String,
      contenido: null == contenido
          ? _value.contenido
          : contenido // ignore: cast_nullable_to_non_nullable
              as String,
      fechaCreacion: null == fechaCreacion
          ? _value.fechaCreacion
          : fechaCreacion // ignore: cast_nullable_to_non_nullable
              as DateTime,
      creadoPor: null == creadoPor
          ? _value.creadoPor
          : creadoPor // ignore: cast_nullable_to_non_nullable
              as String,
      activo: null == activo
          ? _value.activo
          : activo // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReglamentoModelImpl implements _ReglamentoModel {
  const _$ReglamentoModelImpl(
      {required this.id,
      required this.nombreVersion,
      required this.contenido,
      required this.fechaCreacion,
      required this.creadoPor,
      required this.activo});

  factory _$ReglamentoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReglamentoModelImplFromJson(json);

  @override
  final int id;
  @override
  final String nombreVersion;
  @override
  final String contenido;
  @override
  final DateTime fechaCreacion;
  @override
  final String creadoPor;
  @override
  final bool activo;

  @override
  String toString() {
    return 'ReglamentoModel(id: $id, nombreVersion: $nombreVersion, contenido: $contenido, fechaCreacion: $fechaCreacion, creadoPor: $creadoPor, activo: $activo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReglamentoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombreVersion, nombreVersion) ||
                other.nombreVersion == nombreVersion) &&
            (identical(other.contenido, contenido) ||
                other.contenido == contenido) &&
            (identical(other.fechaCreacion, fechaCreacion) ||
                other.fechaCreacion == fechaCreacion) &&
            (identical(other.creadoPor, creadoPor) ||
                other.creadoPor == creadoPor) &&
            (identical(other.activo, activo) || other.activo == activo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombreVersion, contenido,
      fechaCreacion, creadoPor, activo);

  /// Create a copy of ReglamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReglamentoModelImplCopyWith<_$ReglamentoModelImpl> get copyWith =>
      __$$ReglamentoModelImplCopyWithImpl<_$ReglamentoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReglamentoModelImplToJson(
      this,
    );
  }
}

abstract class _ReglamentoModel implements ReglamentoModel {
  const factory _ReglamentoModel(
      {required final int id,
      required final String nombreVersion,
      required final String contenido,
      required final DateTime fechaCreacion,
      required final String creadoPor,
      required final bool activo}) = _$ReglamentoModelImpl;

  factory _ReglamentoModel.fromJson(Map<String, dynamic> json) =
      _$ReglamentoModelImpl.fromJson;

  @override
  int get id;
  @override
  String get nombreVersion;
  @override
  String get contenido;
  @override
  DateTime get fechaCreacion;
  @override
  String get creadoPor;
  @override
  bool get activo;

  /// Create a copy of ReglamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReglamentoModelImplCopyWith<_$ReglamentoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
