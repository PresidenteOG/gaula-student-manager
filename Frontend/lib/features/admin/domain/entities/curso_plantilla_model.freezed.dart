// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curso_plantilla_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CursoPlantillaModel _$CursoPlantillaModelFromJson(Map<String, dynamic> json) {
  return _CursoPlantillaModel.fromJson(json);
}

/// @nodoc
mixin _$CursoPlantillaModel {
  int get id => throw _privateConstructorUsedError;

  /// Código del grupo clase. Ej: "1DAM-M"
  String get codigo => throw _privateConstructorUsedError;

  /// Nombre del ciclo. Ej: "Desarrollo de Aplicaciones Multiplataforma"
  String get nombre => throw _privateConstructorUsedError;

  /// Descripción del ciclo.
  String? get descripcion => throw _privateConstructorUsedError;

  /// Color del ciclo.
  String get color => throw _privateConstructorUsedError;
  List<MateriaPlantillaModel> get materias =>
      throw _privateConstructorUsedError;

  /// Serializes this CursoPlantillaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CursoPlantillaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CursoPlantillaModelCopyWith<CursoPlantillaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CursoPlantillaModelCopyWith<$Res> {
  factory $CursoPlantillaModelCopyWith(
          CursoPlantillaModel value, $Res Function(CursoPlantillaModel) then) =
      _$CursoPlantillaModelCopyWithImpl<$Res, CursoPlantillaModel>;
  @useResult
  $Res call(
      {int id,
      String codigo,
      String nombre,
      String? descripcion,
      String color,
      List<MateriaPlantillaModel> materias});
}

/// @nodoc
class _$CursoPlantillaModelCopyWithImpl<$Res, $Val extends CursoPlantillaModel>
    implements $CursoPlantillaModelCopyWith<$Res> {
  _$CursoPlantillaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CursoPlantillaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigo = null,
    Object? nombre = null,
    Object? descripcion = freezed,
    Object? color = null,
    Object? materias = null,
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
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      materias: null == materias
          ? _value.materias
          : materias // ignore: cast_nullable_to_non_nullable
              as List<MateriaPlantillaModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CursoPlantillaModelImplCopyWith<$Res>
    implements $CursoPlantillaModelCopyWith<$Res> {
  factory _$$CursoPlantillaModelImplCopyWith(_$CursoPlantillaModelImpl value,
          $Res Function(_$CursoPlantillaModelImpl) then) =
      __$$CursoPlantillaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String codigo,
      String nombre,
      String? descripcion,
      String color,
      List<MateriaPlantillaModel> materias});
}

/// @nodoc
class __$$CursoPlantillaModelImplCopyWithImpl<$Res>
    extends _$CursoPlantillaModelCopyWithImpl<$Res, _$CursoPlantillaModelImpl>
    implements _$$CursoPlantillaModelImplCopyWith<$Res> {
  __$$CursoPlantillaModelImplCopyWithImpl(_$CursoPlantillaModelImpl _value,
      $Res Function(_$CursoPlantillaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CursoPlantillaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigo = null,
    Object? nombre = null,
    Object? descripcion = freezed,
    Object? color = null,
    Object? materias = null,
  }) {
    return _then(_$CursoPlantillaModelImpl(
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
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      materias: null == materias
          ? _value._materias
          : materias // ignore: cast_nullable_to_non_nullable
              as List<MateriaPlantillaModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CursoPlantillaModelImpl implements _CursoPlantillaModel {
  const _$CursoPlantillaModelImpl(
      {required this.id,
      required this.codigo,
      required this.nombre,
      required this.descripcion,
      required this.color,
      final List<MateriaPlantillaModel> materias = const []})
      : _materias = materias;

  factory _$CursoPlantillaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CursoPlantillaModelImplFromJson(json);

  @override
  final int id;

  /// Código del grupo clase. Ej: "1DAM-M"
  @override
  final String codigo;

  /// Nombre del ciclo. Ej: "Desarrollo de Aplicaciones Multiplataforma"
  @override
  final String nombre;

  /// Descripción del ciclo.
  @override
  final String? descripcion;

  /// Color del ciclo.
  @override
  final String color;
  final List<MateriaPlantillaModel> _materias;
  @override
  @JsonKey()
  List<MateriaPlantillaModel> get materias {
    if (_materias is EqualUnmodifiableListView) return _materias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_materias);
  }

  @override
  String toString() {
    return 'CursoPlantillaModel(id: $id, codigo: $codigo, nombre: $nombre, descripcion: $descripcion, color: $color, materias: $materias)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CursoPlantillaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.codigo, codigo) || other.codigo == codigo) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._materias, _materias));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, codigo, nombre, descripcion,
      color, const DeepCollectionEquality().hash(_materias));

  /// Create a copy of CursoPlantillaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CursoPlantillaModelImplCopyWith<_$CursoPlantillaModelImpl> get copyWith =>
      __$$CursoPlantillaModelImplCopyWithImpl<_$CursoPlantillaModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CursoPlantillaModelImplToJson(
      this,
    );
  }
}

abstract class _CursoPlantillaModel implements CursoPlantillaModel {
  const factory _CursoPlantillaModel(
      {required final int id,
      required final String codigo,
      required final String nombre,
      required final String? descripcion,
      required final String color,
      final List<MateriaPlantillaModel> materias}) = _$CursoPlantillaModelImpl;

  factory _CursoPlantillaModel.fromJson(Map<String, dynamic> json) =
      _$CursoPlantillaModelImpl.fromJson;

  @override
  int get id;

  /// Código del grupo clase. Ej: "1DAM-M"
  @override
  String get codigo;

  /// Nombre del ciclo. Ej: "Desarrollo de Aplicaciones Multiplataforma"
  @override
  String get nombre;

  /// Descripción del ciclo.
  @override
  String? get descripcion;

  /// Color del ciclo.
  @override
  String get color;
  @override
  List<MateriaPlantillaModel> get materias;

  /// Create a copy of CursoPlantillaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CursoPlantillaModelImplCopyWith<_$CursoPlantillaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
