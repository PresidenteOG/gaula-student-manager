// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curso_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CursoModel _$CursoModelFromJson(Map<String, dynamic> json) {
  return _CursoModel.fromJson(json);
}

/// @nodoc
mixin _$CursoModel {
  int get id => throw _privateConstructorUsedError;

  /// Código del grupo clase. Ej: "1DAM-M"
  String get codigoGrupo => throw _privateConstructorUsedError;

  /// Código del ciclo. Ej: "DAM"
  String get codigoCiclo => throw _privateConstructorUsedError;

  /// Nombre del ciclo. Ej: "Desarrollo de Aplicaciones Multiplataforma"
  String get nombreCiclo => throw _privateConstructorUsedError;

  /// Color del ciclo.
  String get colorCiclo => throw _privateConstructorUsedError;
  int? get anioEscolarId => throw _privateConstructorUsedError;
  String? get turno => throw _privateConstructorUsedError;
  String? get desdoblamiento => throw _privateConstructorUsedError;
  int? get etapaCurso => throw _privateConstructorUsedError;
  int? get tutorId => throw _privateConstructorUsedError;
  String? get tutorNombre => throw _privateConstructorUsedError;
  String? get tutorAvatar => throw _privateConstructorUsedError;
  int? get totalAlumnos => throw _privateConstructorUsedError;
  int? get totalMaterias => throw _privateConstructorUsedError;
  List<MateriaModel> get materias => throw _privateConstructorUsedError;

  /// Serializes this CursoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CursoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CursoModelCopyWith<CursoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CursoModelCopyWith<$Res> {
  factory $CursoModelCopyWith(
          CursoModel value, $Res Function(CursoModel) then) =
      _$CursoModelCopyWithImpl<$Res, CursoModel>;
  @useResult
  $Res call(
      {int id,
      String codigoGrupo,
      String codigoCiclo,
      String nombreCiclo,
      String colorCiclo,
      int? anioEscolarId,
      String? turno,
      String? desdoblamiento,
      int? etapaCurso,
      int? tutorId,
      String? tutorNombre,
      String? tutorAvatar,
      int? totalAlumnos,
      int? totalMaterias,
      List<MateriaModel> materias});
}

/// @nodoc
class _$CursoModelCopyWithImpl<$Res, $Val extends CursoModel>
    implements $CursoModelCopyWith<$Res> {
  _$CursoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CursoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigoGrupo = null,
    Object? codigoCiclo = null,
    Object? nombreCiclo = null,
    Object? colorCiclo = null,
    Object? anioEscolarId = freezed,
    Object? turno = freezed,
    Object? desdoblamiento = freezed,
    Object? etapaCurso = freezed,
    Object? tutorId = freezed,
    Object? tutorNombre = freezed,
    Object? tutorAvatar = freezed,
    Object? totalAlumnos = freezed,
    Object? totalMaterias = freezed,
    Object? materias = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      codigoGrupo: null == codigoGrupo
          ? _value.codigoGrupo
          : codigoGrupo // ignore: cast_nullable_to_non_nullable
              as String,
      codigoCiclo: null == codigoCiclo
          ? _value.codigoCiclo
          : codigoCiclo // ignore: cast_nullable_to_non_nullable
              as String,
      nombreCiclo: null == nombreCiclo
          ? _value.nombreCiclo
          : nombreCiclo // ignore: cast_nullable_to_non_nullable
              as String,
      colorCiclo: null == colorCiclo
          ? _value.colorCiclo
          : colorCiclo // ignore: cast_nullable_to_non_nullable
              as String,
      anioEscolarId: freezed == anioEscolarId
          ? _value.anioEscolarId
          : anioEscolarId // ignore: cast_nullable_to_non_nullable
              as int?,
      turno: freezed == turno
          ? _value.turno
          : turno // ignore: cast_nullable_to_non_nullable
              as String?,
      desdoblamiento: freezed == desdoblamiento
          ? _value.desdoblamiento
          : desdoblamiento // ignore: cast_nullable_to_non_nullable
              as String?,
      etapaCurso: freezed == etapaCurso
          ? _value.etapaCurso
          : etapaCurso // ignore: cast_nullable_to_non_nullable
              as int?,
      tutorId: freezed == tutorId
          ? _value.tutorId
          : tutorId // ignore: cast_nullable_to_non_nullable
              as int?,
      tutorNombre: freezed == tutorNombre
          ? _value.tutorNombre
          : tutorNombre // ignore: cast_nullable_to_non_nullable
              as String?,
      tutorAvatar: freezed == tutorAvatar
          ? _value.tutorAvatar
          : tutorAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAlumnos: freezed == totalAlumnos
          ? _value.totalAlumnos
          : totalAlumnos // ignore: cast_nullable_to_non_nullable
              as int?,
      totalMaterias: freezed == totalMaterias
          ? _value.totalMaterias
          : totalMaterias // ignore: cast_nullable_to_non_nullable
              as int?,
      materias: null == materias
          ? _value.materias
          : materias // ignore: cast_nullable_to_non_nullable
              as List<MateriaModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CursoModelImplCopyWith<$Res>
    implements $CursoModelCopyWith<$Res> {
  factory _$$CursoModelImplCopyWith(
          _$CursoModelImpl value, $Res Function(_$CursoModelImpl) then) =
      __$$CursoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String codigoGrupo,
      String codigoCiclo,
      String nombreCiclo,
      String colorCiclo,
      int? anioEscolarId,
      String? turno,
      String? desdoblamiento,
      int? etapaCurso,
      int? tutorId,
      String? tutorNombre,
      String? tutorAvatar,
      int? totalAlumnos,
      int? totalMaterias,
      List<MateriaModel> materias});
}

/// @nodoc
class __$$CursoModelImplCopyWithImpl<$Res>
    extends _$CursoModelCopyWithImpl<$Res, _$CursoModelImpl>
    implements _$$CursoModelImplCopyWith<$Res> {
  __$$CursoModelImplCopyWithImpl(
      _$CursoModelImpl _value, $Res Function(_$CursoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CursoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? codigoGrupo = null,
    Object? codigoCiclo = null,
    Object? nombreCiclo = null,
    Object? colorCiclo = null,
    Object? anioEscolarId = freezed,
    Object? turno = freezed,
    Object? desdoblamiento = freezed,
    Object? etapaCurso = freezed,
    Object? tutorId = freezed,
    Object? tutorNombre = freezed,
    Object? tutorAvatar = freezed,
    Object? totalAlumnos = freezed,
    Object? totalMaterias = freezed,
    Object? materias = null,
  }) {
    return _then(_$CursoModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      codigoGrupo: null == codigoGrupo
          ? _value.codigoGrupo
          : codigoGrupo // ignore: cast_nullable_to_non_nullable
              as String,
      codigoCiclo: null == codigoCiclo
          ? _value.codigoCiclo
          : codigoCiclo // ignore: cast_nullable_to_non_nullable
              as String,
      nombreCiclo: null == nombreCiclo
          ? _value.nombreCiclo
          : nombreCiclo // ignore: cast_nullable_to_non_nullable
              as String,
      colorCiclo: null == colorCiclo
          ? _value.colorCiclo
          : colorCiclo // ignore: cast_nullable_to_non_nullable
              as String,
      anioEscolarId: freezed == anioEscolarId
          ? _value.anioEscolarId
          : anioEscolarId // ignore: cast_nullable_to_non_nullable
              as int?,
      turno: freezed == turno
          ? _value.turno
          : turno // ignore: cast_nullable_to_non_nullable
              as String?,
      desdoblamiento: freezed == desdoblamiento
          ? _value.desdoblamiento
          : desdoblamiento // ignore: cast_nullable_to_non_nullable
              as String?,
      etapaCurso: freezed == etapaCurso
          ? _value.etapaCurso
          : etapaCurso // ignore: cast_nullable_to_non_nullable
              as int?,
      tutorId: freezed == tutorId
          ? _value.tutorId
          : tutorId // ignore: cast_nullable_to_non_nullable
              as int?,
      tutorNombre: freezed == tutorNombre
          ? _value.tutorNombre
          : tutorNombre // ignore: cast_nullable_to_non_nullable
              as String?,
      tutorAvatar: freezed == tutorAvatar
          ? _value.tutorAvatar
          : tutorAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAlumnos: freezed == totalAlumnos
          ? _value.totalAlumnos
          : totalAlumnos // ignore: cast_nullable_to_non_nullable
              as int?,
      totalMaterias: freezed == totalMaterias
          ? _value.totalMaterias
          : totalMaterias // ignore: cast_nullable_to_non_nullable
              as int?,
      materias: null == materias
          ? _value._materias
          : materias // ignore: cast_nullable_to_non_nullable
              as List<MateriaModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CursoModelImpl implements _CursoModel {
  const _$CursoModelImpl(
      {required this.id,
      required this.codigoGrupo,
      required this.codigoCiclo,
      required this.nombreCiclo,
      required this.colorCiclo,
      this.anioEscolarId,
      this.turno,
      this.desdoblamiento,
      this.etapaCurso,
      this.tutorId,
      this.tutorNombre,
      this.tutorAvatar,
      this.totalAlumnos,
      this.totalMaterias,
      final List<MateriaModel> materias = const []})
      : _materias = materias;

  factory _$CursoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CursoModelImplFromJson(json);

  @override
  final int id;

  /// Código del grupo clase. Ej: "1DAM-M"
  @override
  final String codigoGrupo;

  /// Código del ciclo. Ej: "DAM"
  @override
  final String codigoCiclo;

  /// Nombre del ciclo. Ej: "Desarrollo de Aplicaciones Multiplataforma"
  @override
  final String nombreCiclo;

  /// Color del ciclo.
  @override
  final String colorCiclo;
  @override
  final int? anioEscolarId;
  @override
  final String? turno;
  @override
  final String? desdoblamiento;
  @override
  final int? etapaCurso;
  @override
  final int? tutorId;
  @override
  final String? tutorNombre;
  @override
  final String? tutorAvatar;
  @override
  final int? totalAlumnos;
  @override
  final int? totalMaterias;
  final List<MateriaModel> _materias;
  @override
  @JsonKey()
  List<MateriaModel> get materias {
    if (_materias is EqualUnmodifiableListView) return _materias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_materias);
  }

  @override
  String toString() {
    return 'CursoModel(id: $id, codigoGrupo: $codigoGrupo, codigoCiclo: $codigoCiclo, nombreCiclo: $nombreCiclo, colorCiclo: $colorCiclo, anioEscolarId: $anioEscolarId, turno: $turno, desdoblamiento: $desdoblamiento, etapaCurso: $etapaCurso, tutorId: $tutorId, tutorNombre: $tutorNombre, tutorAvatar: $tutorAvatar, totalAlumnos: $totalAlumnos, totalMaterias: $totalMaterias, materias: $materias)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CursoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.codigoGrupo, codigoGrupo) ||
                other.codigoGrupo == codigoGrupo) &&
            (identical(other.codigoCiclo, codigoCiclo) ||
                other.codigoCiclo == codigoCiclo) &&
            (identical(other.nombreCiclo, nombreCiclo) ||
                other.nombreCiclo == nombreCiclo) &&
            (identical(other.colorCiclo, colorCiclo) ||
                other.colorCiclo == colorCiclo) &&
            (identical(other.anioEscolarId, anioEscolarId) ||
                other.anioEscolarId == anioEscolarId) &&
            (identical(other.turno, turno) || other.turno == turno) &&
            (identical(other.desdoblamiento, desdoblamiento) ||
                other.desdoblamiento == desdoblamiento) &&
            (identical(other.etapaCurso, etapaCurso) ||
                other.etapaCurso == etapaCurso) &&
            (identical(other.tutorId, tutorId) || other.tutorId == tutorId) &&
            (identical(other.tutorNombre, tutorNombre) ||
                other.tutorNombre == tutorNombre) &&
            (identical(other.tutorAvatar, tutorAvatar) ||
                other.tutorAvatar == tutorAvatar) &&
            (identical(other.totalAlumnos, totalAlumnos) ||
                other.totalAlumnos == totalAlumnos) &&
            (identical(other.totalMaterias, totalMaterias) ||
                other.totalMaterias == totalMaterias) &&
            const DeepCollectionEquality().equals(other._materias, _materias));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      codigoGrupo,
      codigoCiclo,
      nombreCiclo,
      colorCiclo,
      anioEscolarId,
      turno,
      desdoblamiento,
      etapaCurso,
      tutorId,
      tutorNombre,
      tutorAvatar,
      totalAlumnos,
      totalMaterias,
      const DeepCollectionEquality().hash(_materias));

  /// Create a copy of CursoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CursoModelImplCopyWith<_$CursoModelImpl> get copyWith =>
      __$$CursoModelImplCopyWithImpl<_$CursoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CursoModelImplToJson(
      this,
    );
  }
}

abstract class _CursoModel implements CursoModel {
  const factory _CursoModel(
      {required final int id,
      required final String codigoGrupo,
      required final String codigoCiclo,
      required final String nombreCiclo,
      required final String colorCiclo,
      final int? anioEscolarId,
      final String? turno,
      final String? desdoblamiento,
      final int? etapaCurso,
      final int? tutorId,
      final String? tutorNombre,
      final String? tutorAvatar,
      final int? totalAlumnos,
      final int? totalMaterias,
      final List<MateriaModel> materias}) = _$CursoModelImpl;

  factory _CursoModel.fromJson(Map<String, dynamic> json) =
      _$CursoModelImpl.fromJson;

  @override
  int get id;

  /// Código del grupo clase. Ej: "1DAM-M"
  @override
  String get codigoGrupo;

  /// Código del ciclo. Ej: "DAM"
  @override
  String get codigoCiclo;

  /// Nombre del ciclo. Ej: "Desarrollo de Aplicaciones Multiplataforma"
  @override
  String get nombreCiclo;

  /// Color del ciclo.
  @override
  String get colorCiclo;
  @override
  int? get anioEscolarId;
  @override
  String? get turno;
  @override
  String? get desdoblamiento;
  @override
  int? get etapaCurso;
  @override
  int? get tutorId;
  @override
  String? get tutorNombre;
  @override
  String? get tutorAvatar;
  @override
  int? get totalAlumnos;
  @override
  int? get totalMaterias;
  @override
  List<MateriaModel> get materias;

  /// Create a copy of CursoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CursoModelImplCopyWith<_$CursoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
