// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'materia_plantilla_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MateriaPlantillaModel _$MateriaPlantillaModelFromJson(
    Map<String, dynamic> json) {
  return _MateriaPlantillaModel.fromJson(json);
}

/// @nodoc
mixin _$MateriaPlantillaModel {
  int get id => throw _privateConstructorUsedError;
  String get codigo => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String? get descripcion => throw _privateConstructorUsedError;
  String get tipo => throw _privateConstructorUsedError;
  int get horasTotales => throw _privateConstructorUsedError;

  /// Serializes this MateriaPlantillaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MateriaPlantillaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MateriaPlantillaModelCopyWith<MateriaPlantillaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MateriaPlantillaModelCopyWith<$Res> {
  factory $MateriaPlantillaModelCopyWith(MateriaPlantillaModel value,
          $Res Function(MateriaPlantillaModel) then) =
      _$MateriaPlantillaModelCopyWithImpl<$Res, MateriaPlantillaModel>;
  @useResult
  $Res call(
      {int id,
      String codigo,
      String nombre,
      String? descripcion,
      String tipo,
      int horasTotales});
}

/// @nodoc
class _$MateriaPlantillaModelCopyWithImpl<$Res,
        $Val extends MateriaPlantillaModel>
    implements $MateriaPlantillaModelCopyWith<$Res> {
  _$MateriaPlantillaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MateriaPlantillaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigo = null,
    Object? nombre = null,
    Object? descripcion = freezed,
    Object? tipo = null,
    Object? horasTotales = null,
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
      descripcion: freezed == descripcion
          ? _value.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String?,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      horasTotales: null == horasTotales
          ? _value.horasTotales
          : horasTotales // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MateriaPlantillaModelImplCopyWith<$Res>
    implements $MateriaPlantillaModelCopyWith<$Res> {
  factory _$$MateriaPlantillaModelImplCopyWith(
          _$MateriaPlantillaModelImpl value,
          $Res Function(_$MateriaPlantillaModelImpl) then) =
      __$$MateriaPlantillaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String codigo,
      String nombre,
      String? descripcion,
      String tipo,
      int horasTotales});
}

/// @nodoc
class __$$MateriaPlantillaModelImplCopyWithImpl<$Res>
    extends _$MateriaPlantillaModelCopyWithImpl<$Res,
        _$MateriaPlantillaModelImpl>
    implements _$$MateriaPlantillaModelImplCopyWith<$Res> {
  __$$MateriaPlantillaModelImplCopyWithImpl(_$MateriaPlantillaModelImpl _value,
      $Res Function(_$MateriaPlantillaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MateriaPlantillaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigo = null,
    Object? nombre = null,
    Object? descripcion = freezed,
    Object? tipo = null,
    Object? horasTotales = null,
  }) {
    return _then(_$MateriaPlantillaModelImpl(
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
      descripcion: freezed == descripcion
          ? _value.descripcion
          : descripcion // ignore: cast_nullable_to_non_nullable
              as String?,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      horasTotales: null == horasTotales
          ? _value.horasTotales
          : horasTotales // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MateriaPlantillaModelImpl implements _MateriaPlantillaModel {
  const _$MateriaPlantillaModelImpl(
      {required this.id,
      required this.codigo,
      required this.nombre,
      required this.descripcion,
      required this.tipo,
      required this.horasTotales});

  factory _$MateriaPlantillaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MateriaPlantillaModelImplFromJson(json);

  @override
  final int id;
  @override
  final String codigo;
  @override
  final String nombre;
  @override
  final String? descripcion;
  @override
  final String tipo;
  @override
  final int horasTotales;

  @override
  String toString() {
    return 'MateriaPlantillaModel(id: $id, codigo: $codigo, nombre: $nombre, descripcion: $descripcion, tipo: $tipo, horasTotales: $horasTotales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MateriaPlantillaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.codigo, codigo) || other.codigo == codigo) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.horasTotales, horasTotales) ||
                other.horasTotales == horasTotales));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, codigo, nombre, descripcion, tipo, horasTotales);

  /// Create a copy of MateriaPlantillaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MateriaPlantillaModelImplCopyWith<_$MateriaPlantillaModelImpl>
      get copyWith => __$$MateriaPlantillaModelImplCopyWithImpl<
          _$MateriaPlantillaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MateriaPlantillaModelImplToJson(
      this,
    );
  }
}

abstract class _MateriaPlantillaModel implements MateriaPlantillaModel {
  const factory _MateriaPlantillaModel(
      {required final int id,
      required final String codigo,
      required final String nombre,
      required final String? descripcion,
      required final String tipo,
      required final int horasTotales}) = _$MateriaPlantillaModelImpl;

  factory _MateriaPlantillaModel.fromJson(Map<String, dynamic> json) =
      _$MateriaPlantillaModelImpl.fromJson;

  @override
  int get id;
  @override
  String get codigo;
  @override
  String get nombre;
  @override
  String? get descripcion;
  @override
  String get tipo;
  @override
  int get horasTotales;

  /// Create a copy of MateriaPlantillaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MateriaPlantillaModelImplCopyWith<_$MateriaPlantillaModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
