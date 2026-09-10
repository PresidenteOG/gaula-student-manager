// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evento_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventoModel _$EventoModelFromJson(Map<String, dynamic> json) {
  return _EventoModel.fromJson(json);
}

/// @nodoc
mixin _$EventoModel {
  int get id => throw _privateConstructorUsedError;
  String get titulo => throw _privateConstructorUsedError;
  String get descripcion => throw _privateConstructorUsedError;
  String get fecha =>
      throw _privateConstructorUsedError; // ISO 8601 (yyyy-MM-dd)
  String get tipo =>
      throw _privateConstructorUsedError; // EXAMEN, FESTIVO, EVENTO
  int? get cursoId => throw _privateConstructorUsedError;

  /// Serializes this EventoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventoModelCopyWith<EventoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventoModelCopyWith<$Res> {
  factory $EventoModelCopyWith(
          EventoModel value, $Res Function(EventoModel) then) =
      _$EventoModelCopyWithImpl<$Res, EventoModel>;
  @useResult
  $Res call(
      {int id,
      String titulo,
      String descripcion,
      String fecha,
      String tipo,
      int? cursoId});
}

/// @nodoc
class _$EventoModelCopyWithImpl<$Res, $Val extends EventoModel>
    implements $EventoModelCopyWith<$Res> {
  _$EventoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titulo = null,
    Object? descripcion = null,
    Object? fecha = null,
    Object? tipo = null,
    Object? cursoId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      descripcion: null == descripcion
          ? _value.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String,
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      cursoId: freezed == cursoId
          ? _value.cursoId
          : cursoId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventoModelImplCopyWith<$Res>
    implements $EventoModelCopyWith<$Res> {
  factory _$$EventoModelImplCopyWith(
          _$EventoModelImpl value, $Res Function(_$EventoModelImpl) then) =
      __$$EventoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String titulo,
      String descripcion,
      String fecha,
      String tipo,
      int? cursoId});
}

/// @nodoc
class __$$EventoModelImplCopyWithImpl<$Res>
    extends _$EventoModelCopyWithImpl<$Res, _$EventoModelImpl>
    implements _$$EventoModelImplCopyWith<$Res> {
  __$$EventoModelImplCopyWithImpl(
      _$EventoModelImpl _value, $Res Function(_$EventoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titulo = null,
    Object? descripcion = null,
    Object? fecha = null,
    Object? tipo = null,
    Object? cursoId = freezed,
  }) {
    return _then(_$EventoModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      titulo: null == titulo
          ? _value.titulo
          : titulo // ignore: cast_nullable_to_non_nullable
              as String,
      descripcion: null == descripcion
          ? _value.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String,
      fecha: null == fecha
          ? _value.fecha
          : fecha // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      cursoId: freezed == cursoId
          ? _value.cursoId
          : cursoId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventoModelImpl implements _EventoModel {
  const _$EventoModelImpl(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.fecha,
      required this.tipo,
      this.cursoId});

  factory _$EventoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventoModelImplFromJson(json);

  @override
  final int id;
  @override
  final String titulo;
  @override
  final String descripcion;
  @override
  final String fecha;
// ISO 8601 (yyyy-MM-dd)
  @override
  final String tipo;
// EXAMEN, FESTIVO, EVENTO
  @override
  final int? cursoId;

  @override
  String toString() {
    return 'EventoModel(id: $id, titulo: $titulo, descripcion: $descripcion, fecha: $fecha, tipo: $tipo, cursoId: $cursoId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.titulo, titulo) || other.titulo == titulo) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.cursoId, cursoId) || other.cursoId == cursoId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, titulo, descripcion, fecha, tipo, cursoId);

  /// Create a copy of EventoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventoModelImplCopyWith<_$EventoModelImpl> get copyWith =>
      __$$EventoModelImplCopyWithImpl<_$EventoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventoModelImplToJson(
      this,
    );
  }
}

abstract class _EventoModel implements EventoModel {
  const factory _EventoModel(
      {required final int id,
      required final String titulo,
      required final String descripcion,
      required final String fecha,
      required final String tipo,
      final int? cursoId}) = _$EventoModelImpl;

  factory _EventoModel.fromJson(Map<String, dynamic> json) =
      _$EventoModelImpl.fromJson;

  @override
  int get id;
  @override
  String get titulo;
  @override
  String get descripcion;
  @override
  String get fecha; // ISO 8601 (yyyy-MM-dd)
  @override
  String get tipo; // EXAMEN, FESTIVO, EVENTO
  @override
  int? get cursoId;

  /// Create a copy of EventoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventoModelImplCopyWith<_$EventoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
