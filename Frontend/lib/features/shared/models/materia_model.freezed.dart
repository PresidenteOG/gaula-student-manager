// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'materia_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MateriaModel _$MateriaModelFromJson(Map<String, dynamic> json) {
  return _MateriaModel.fromJson(json);
}

/// @nodoc
mixin _$MateriaModel {
  int get id => throw _privateConstructorUsedError;
  String get codigo => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  int? get horasSemanales => throw _privateConstructorUsedError;
  int get horasTotales => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this MateriaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MateriaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MateriaModelCopyWith<MateriaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MateriaModelCopyWith<$Res> {
  factory $MateriaModelCopyWith(
          MateriaModel value, $Res Function(MateriaModel) then) =
      _$MateriaModelCopyWithImpl<$Res, MateriaModel>;
  @useResult
  $Res call(
      {int id,
      String codigo,
      String nombre,
      int? horasSemanales,
      int horasTotales,
      String? color});
}

/// @nodoc
class _$MateriaModelCopyWithImpl<$Res, $Val extends MateriaModel>
    implements $MateriaModelCopyWith<$Res> {
  _$MateriaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MateriaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigo = null,
    Object? nombre = null,
    Object? horasSemanales = freezed,
    Object? horasTotales = null,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      codigo: null == codigo
          ? _value.codigo
          : codigo // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      horasSemanales: freezed == horasSemanales
          ? _value.horasSemanales
          : horasSemanales // ignore: cast_nullable_to_non_nullable
              as int?,
      horasTotales: null == horasTotales
          ? _value.horasTotales
          : horasTotales // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MateriaModelImplCopyWith<$Res>
    implements $MateriaModelCopyWith<$Res> {
  factory _$$MateriaModelImplCopyWith(
          _$MateriaModelImpl value, $Res Function(_$MateriaModelImpl) then) =
      __$$MateriaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String codigo,
      String nombre,
      int? horasSemanales,
      int horasTotales,
      String? color});
}

/// @nodoc
class __$$MateriaModelImplCopyWithImpl<$Res>
    extends _$MateriaModelCopyWithImpl<$Res, _$MateriaModelImpl>
    implements _$$MateriaModelImplCopyWith<$Res> {
  __$$MateriaModelImplCopyWithImpl(
      _$MateriaModelImpl _value, $Res Function(_$MateriaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MateriaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigo = null,
    Object? nombre = null,
    Object? horasSemanales = freezed,
    Object? horasTotales = null,
    Object? color = freezed,
  }) {
    return _then(_$MateriaModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      codigo: null == codigo
          ? _value.codigo
          : codigo // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      horasSemanales: freezed == horasSemanales
          ? _value.horasSemanales
          : horasSemanales // ignore: cast_nullable_to_non_nullable
              as int?,
      horasTotales: null == horasTotales
          ? _value.horasTotales
          : horasTotales // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MateriaModelImpl implements _MateriaModel {
  const _$MateriaModelImpl(
      {required this.id,
      required this.codigo,
      required this.nombre,
      this.horasSemanales,
      required this.horasTotales,
      this.color});

  factory _$MateriaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MateriaModelImplFromJson(json);

  @override
  final int id;
  @override
  final String codigo;
  @override
  final String nombre;
  @override
  final int? horasSemanales;
  @override
  final int horasTotales;
  @override
  final String? color;

  @override
  String toString() {
    return 'MateriaModel(id: $id, codigo: $codigo, nombre: $nombre, horasSemanales: $horasSemanales, horasTotales: $horasTotales, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MateriaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.codigo, codigo) || other.codigo == codigo) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.horasSemanales, horasSemanales) ||
                other.horasSemanales == horasSemanales) &&
            (identical(other.horasTotales, horasTotales) ||
                other.horasTotales == horasTotales) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, codigo, nombre, horasSemanales, horasTotales, color);

  /// Create a copy of MateriaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MateriaModelImplCopyWith<_$MateriaModelImpl> get copyWith =>
      __$$MateriaModelImplCopyWithImpl<_$MateriaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MateriaModelImplToJson(
      this,
    );
  }
}

abstract class _MateriaModel implements MateriaModel {
  const factory _MateriaModel(
      {required final int id,
      required final String codigo,
      required final String nombre,
      final int? horasSemanales,
      required final int horasTotales,
      final String? color}) = _$MateriaModelImpl;

  factory _MateriaModel.fromJson(Map<String, dynamic> json) =
      _$MateriaModelImpl.fromJson;

  @override
  int get id;
  @override
  String get codigo;
  @override
  String get nombre;
  @override
  int? get horasSemanales;
  @override
  int get horasTotales;
  @override
  String? get color;

  /// Create a copy of MateriaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MateriaModelImplCopyWith<_$MateriaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
