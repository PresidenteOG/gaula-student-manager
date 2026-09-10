// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'horario_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HorarioSesionModel _$HorarioSesionModelFromJson(Map<String, dynamic> json) {
  return _HorarioSesionModel.fromJson(json);
}

/// @nodoc
mixin _$HorarioSesionModel {
  int get id => throw _privateConstructorUsedError;
  String get diaSemana => throw _privateConstructorUsedError; // "MONDAY"
  String get diaEspanol => throw _privateConstructorUsedError; // "Lunes"
  String get horaInicio => throw _privateConstructorUsedError; // "08:00"
  String get horaFin => throw _privateConstructorUsedError; // "09:30"
  String? get aula => throw _privateConstructorUsedError; // Materia
  int? get materiaId => throw _privateConstructorUsedError;
  String? get materiaNombre => throw _privateConstructorUsedError;
  String? get materiaCodigo => throw _privateConstructorUsedError; // Profesor
  int? get profesorId => throw _privateConstructorUsedError;
  String? get profesorNombre => throw _privateConstructorUsedError;
  String? get profesorAvatar =>
      throw _privateConstructorUsedError; // Sustituto (si el profesor está de baja)
  int? get sustitutoId => throw _privateConstructorUsedError;
  String? get sustitutoNombre => throw _privateConstructorUsedError;
  String? get sustitutoAvatar =>
      throw _privateConstructorUsedError; // Grupo y ciclo
  int? get cursoId => throw _privateConstructorUsedError;
  String? get codigoGrupo => throw _privateConstructorUsedError;
  String? get colorCiclo => throw _privateConstructorUsedError;

  /// Serializes this HorarioSesionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HorarioSesionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HorarioSesionModelCopyWith<HorarioSesionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HorarioSesionModelCopyWith<$Res> {
  factory $HorarioSesionModelCopyWith(
          HorarioSesionModel value, $Res Function(HorarioSesionModel) then) =
      _$HorarioSesionModelCopyWithImpl<$Res, HorarioSesionModel>;
  @useResult
  $Res call(
      {int id,
      String diaSemana,
      String diaEspanol,
      String horaInicio,
      String horaFin,
      String? aula,
      int? materiaId,
      String? materiaNombre,
      String? materiaCodigo,
      int? profesorId,
      String? profesorNombre,
      String? profesorAvatar,
      int? sustitutoId,
      String? sustitutoNombre,
      String? sustitutoAvatar,
      int? cursoId,
      String? codigoGrupo,
      String? colorCiclo});
}

/// @nodoc
class _$HorarioSesionModelCopyWithImpl<$Res, $Val extends HorarioSesionModel>
    implements $HorarioSesionModelCopyWith<$Res> {
  _$HorarioSesionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HorarioSesionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? diaSemana = null,
    Object? diaEspanol = null,
    Object? horaInicio = null,
    Object? horaFin = null,
    Object? aula = freezed,
    Object? materiaId = freezed,
    Object? materiaNombre = freezed,
    Object? materiaCodigo = freezed,
    Object? profesorId = freezed,
    Object? profesorNombre = freezed,
    Object? profesorAvatar = freezed,
    Object? sustitutoId = freezed,
    Object? sustitutoNombre = freezed,
    Object? sustitutoAvatar = freezed,
    Object? cursoId = freezed,
    Object? codigoGrupo = freezed,
    Object? colorCiclo = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      diaSemana: null == diaSemana
          ? _value.diaSemana
          : diaSemana // ignore: cast_nullable_to_non_nullable
              as String,
      diaEspanol: null == diaEspanol
          ? _value.diaEspanol
          : diaEspanol // ignore: cast_nullable_to_non_nullable
              as String,
      horaInicio: null == horaInicio
          ? _value.horaInicio
          : horaInicio // ignore: cast_nullable_to_non_nullable
              as String,
      horaFin: null == horaFin
          ? _value.horaFin
          : horaFin // ignore: cast_nullable_to_non_nullable
              as String,
      aula: freezed == aula
          ? _value.aula
          : aula // ignore: cast_nullable_to_non_nullable
              as String?,
      materiaId: freezed == materiaId
          ? _value.materiaId
          : materiaId // ignore: cast_nullable_to_non_nullable
              as int?,
      materiaNombre: freezed == materiaNombre
          ? _value.materiaNombre
          : materiaNombre // ignore: cast_nullable_to_non_nullable
              as String?,
      materiaCodigo: freezed == materiaCodigo
          ? _value.materiaCodigo
          : materiaCodigo // ignore: cast_nullable_to_non_nullable
              as String?,
      profesorId: freezed == profesorId
          ? _value.profesorId
          : profesorId // ignore: cast_nullable_to_non_nullable
              as int?,
      profesorNombre: freezed == profesorNombre
          ? _value.profesorNombre
          : profesorNombre // ignore: cast_nullable_to_non_nullable
              as String?,
      profesorAvatar: freezed == profesorAvatar
          ? _value.profesorAvatar
          : profesorAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      sustitutoId: freezed == sustitutoId
          ? _value.sustitutoId
          : sustitutoId // ignore: cast_nullable_to_non_nullable
              as int?,
      sustitutoNombre: freezed == sustitutoNombre
          ? _value.sustitutoNombre
          : sustitutoNombre // ignore: cast_nullable_to_non_nullable
              as String?,
      sustitutoAvatar: freezed == sustitutoAvatar
          ? _value.sustitutoAvatar
          : sustitutoAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      cursoId: freezed == cursoId
          ? _value.cursoId
          : cursoId // ignore: cast_nullable_to_non_nullable
              as int?,
      codigoGrupo: freezed == codigoGrupo
          ? _value.codigoGrupo
          : codigoGrupo // ignore: cast_nullable_to_non_nullable
              as String?,
      colorCiclo: freezed == colorCiclo
          ? _value.colorCiclo
          : colorCiclo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HorarioSesionModelImplCopyWith<$Res>
    implements $HorarioSesionModelCopyWith<$Res> {
  factory _$$HorarioSesionModelImplCopyWith(_$HorarioSesionModelImpl value,
          $Res Function(_$HorarioSesionModelImpl) then) =
      __$$HorarioSesionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String diaSemana,
      String diaEspanol,
      String horaInicio,
      String horaFin,
      String? aula,
      int? materiaId,
      String? materiaNombre,
      String? materiaCodigo,
      int? profesorId,
      String? profesorNombre,
      String? profesorAvatar,
      int? sustitutoId,
      String? sustitutoNombre,
      String? sustitutoAvatar,
      int? cursoId,
      String? codigoGrupo,
      String? colorCiclo});
}

/// @nodoc
class __$$HorarioSesionModelImplCopyWithImpl<$Res>
    extends _$HorarioSesionModelCopyWithImpl<$Res, _$HorarioSesionModelImpl>
    implements _$$HorarioSesionModelImplCopyWith<$Res> {
  __$$HorarioSesionModelImplCopyWithImpl(_$HorarioSesionModelImpl _value,
      $Res Function(_$HorarioSesionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HorarioSesionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? diaSemana = null,
    Object? diaEspanol = null,
    Object? horaInicio = null,
    Object? horaFin = null,
    Object? aula = freezed,
    Object? materiaId = freezed,
    Object? materiaNombre = freezed,
    Object? materiaCodigo = freezed,
    Object? profesorId = freezed,
    Object? profesorNombre = freezed,
    Object? profesorAvatar = freezed,
    Object? sustitutoId = freezed,
    Object? sustitutoNombre = freezed,
    Object? sustitutoAvatar = freezed,
    Object? cursoId = freezed,
    Object? codigoGrupo = freezed,
    Object? colorCiclo = freezed,
  }) {
    return _then(_$HorarioSesionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      diaSemana: null == diaSemana
          ? _value.diaSemana
          : diaSemana // ignore: cast_nullable_to_non_nullable
              as String,
      diaEspanol: null == diaEspanol
          ? _value.diaEspanol
          : diaEspanol // ignore: cast_nullable_to_non_nullable
              as String,
      horaInicio: null == horaInicio
          ? _value.horaInicio
          : horaInicio // ignore: cast_nullable_to_non_nullable
              as String,
      horaFin: null == horaFin
          ? _value.horaFin
          : horaFin // ignore: cast_nullable_to_non_nullable
              as String,
      aula: freezed == aula
          ? _value.aula
          : aula // ignore: cast_nullable_to_non_nullable
              as String?,
      materiaId: freezed == materiaId
          ? _value.materiaId
          : materiaId // ignore: cast_nullable_to_non_nullable
              as int?,
      materiaNombre: freezed == materiaNombre
          ? _value.materiaNombre
          : materiaNombre // ignore: cast_nullable_to_non_nullable
              as String?,
      materiaCodigo: freezed == materiaCodigo
          ? _value.materiaCodigo
          : materiaCodigo // ignore: cast_nullable_to_non_nullable
              as String?,
      profesorId: freezed == profesorId
          ? _value.profesorId
          : profesorId // ignore: cast_nullable_to_non_nullable
              as int?,
      profesorNombre: freezed == profesorNombre
          ? _value.profesorNombre
          : profesorNombre // ignore: cast_nullable_to_non_nullable
              as String?,
      profesorAvatar: freezed == profesorAvatar
          ? _value.profesorAvatar
          : profesorAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      sustitutoId: freezed == sustitutoId
          ? _value.sustitutoId
          : sustitutoId // ignore: cast_nullable_to_non_nullable
              as int?,
      sustitutoNombre: freezed == sustitutoNombre
          ? _value.sustitutoNombre
          : sustitutoNombre // ignore: cast_nullable_to_non_nullable
              as String?,
      sustitutoAvatar: freezed == sustitutoAvatar
          ? _value.sustitutoAvatar
          : sustitutoAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      cursoId: freezed == cursoId
          ? _value.cursoId
          : cursoId // ignore: cast_nullable_to_non_nullable
              as int?,
      codigoGrupo: freezed == codigoGrupo
          ? _value.codigoGrupo
          : codigoGrupo // ignore: cast_nullable_to_non_nullable
              as String?,
      colorCiclo: freezed == colorCiclo
          ? _value.colorCiclo
          : colorCiclo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HorarioSesionModelImpl implements _HorarioSesionModel {
  const _$HorarioSesionModelImpl(
      {required this.id,
      required this.diaSemana,
      required this.diaEspanol,
      required this.horaInicio,
      required this.horaFin,
      this.aula,
      this.materiaId,
      this.materiaNombre,
      this.materiaCodigo,
      this.profesorId,
      this.profesorNombre,
      this.profesorAvatar,
      this.sustitutoId,
      this.sustitutoNombre,
      this.sustitutoAvatar,
      this.cursoId,
      this.codigoGrupo,
      this.colorCiclo});

  factory _$HorarioSesionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HorarioSesionModelImplFromJson(json);

  @override
  final int id;
  @override
  final String diaSemana;
// "MONDAY"
  @override
  final String diaEspanol;
// "Lunes"
  @override
  final String horaInicio;
// "08:00"
  @override
  final String horaFin;
// "09:30"
  @override
  final String? aula;
// Materia
  @override
  final int? materiaId;
  @override
  final String? materiaNombre;
  @override
  final String? materiaCodigo;
// Profesor
  @override
  final int? profesorId;
  @override
  final String? profesorNombre;
  @override
  final String? profesorAvatar;
// Sustituto (si el profesor está de baja)
  @override
  final int? sustitutoId;
  @override
  final String? sustitutoNombre;
  @override
  final String? sustitutoAvatar;
// Grupo y ciclo
  @override
  final int? cursoId;
  @override
  final String? codigoGrupo;
  @override
  final String? colorCiclo;

  @override
  String toString() {
    return 'HorarioSesionModel(id: $id, diaSemana: $diaSemana, diaEspanol: $diaEspanol, horaInicio: $horaInicio, horaFin: $horaFin, aula: $aula, materiaId: $materiaId, materiaNombre: $materiaNombre, materiaCodigo: $materiaCodigo, profesorId: $profesorId, profesorNombre: $profesorNombre, profesorAvatar: $profesorAvatar, sustitutoId: $sustitutoId, sustitutoNombre: $sustitutoNombre, sustitutoAvatar: $sustitutoAvatar, cursoId: $cursoId, codigoGrupo: $codigoGrupo, colorCiclo: $colorCiclo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HorarioSesionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.diaSemana, diaSemana) ||
                other.diaSemana == diaSemana) &&
            (identical(other.diaEspanol, diaEspanol) ||
                other.diaEspanol == diaEspanol) &&
            (identical(other.horaInicio, horaInicio) ||
                other.horaInicio == horaInicio) &&
            (identical(other.horaFin, horaFin) || other.horaFin == horaFin) &&
            (identical(other.aula, aula) || other.aula == aula) &&
            (identical(other.materiaId, materiaId) ||
                other.materiaId == materiaId) &&
            (identical(other.materiaNombre, materiaNombre) ||
                other.materiaNombre == materiaNombre) &&
            (identical(other.materiaCodigo, materiaCodigo) ||
                other.materiaCodigo == materiaCodigo) &&
            (identical(other.profesorId, profesorId) ||
                other.profesorId == profesorId) &&
            (identical(other.profesorNombre, profesorNombre) ||
                other.profesorNombre == profesorNombre) &&
            (identical(other.profesorAvatar, profesorAvatar) ||
                other.profesorAvatar == profesorAvatar) &&
            (identical(other.sustitutoId, sustitutoId) ||
                other.sustitutoId == sustitutoId) &&
            (identical(other.sustitutoNombre, sustitutoNombre) ||
                other.sustitutoNombre == sustitutoNombre) &&
            (identical(other.sustitutoAvatar, sustitutoAvatar) ||
                other.sustitutoAvatar == sustitutoAvatar) &&
            (identical(other.cursoId, cursoId) || other.cursoId == cursoId) &&
            (identical(other.codigoGrupo, codigoGrupo) ||
                other.codigoGrupo == codigoGrupo) &&
            (identical(other.colorCiclo, colorCiclo) ||
                other.colorCiclo == colorCiclo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      diaSemana,
      diaEspanol,
      horaInicio,
      horaFin,
      aula,
      materiaId,
      materiaNombre,
      materiaCodigo,
      profesorId,
      profesorNombre,
      profesorAvatar,
      sustitutoId,
      sustitutoNombre,
      sustitutoAvatar,
      cursoId,
      codigoGrupo,
      colorCiclo);

  /// Create a copy of HorarioSesionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HorarioSesionModelImplCopyWith<_$HorarioSesionModelImpl> get copyWith =>
      __$$HorarioSesionModelImplCopyWithImpl<_$HorarioSesionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HorarioSesionModelImplToJson(
      this,
    );
  }
}

abstract class _HorarioSesionModel implements HorarioSesionModel {
  const factory _HorarioSesionModel(
      {required final int id,
      required final String diaSemana,
      required final String diaEspanol,
      required final String horaInicio,
      required final String horaFin,
      final String? aula,
      final int? materiaId,
      final String? materiaNombre,
      final String? materiaCodigo,
      final int? profesorId,
      final String? profesorNombre,
      final String? profesorAvatar,
      final int? sustitutoId,
      final String? sustitutoNombre,
      final String? sustitutoAvatar,
      final int? cursoId,
      final String? codigoGrupo,
      final String? colorCiclo}) = _$HorarioSesionModelImpl;

  factory _HorarioSesionModel.fromJson(Map<String, dynamic> json) =
      _$HorarioSesionModelImpl.fromJson;

  @override
  int get id;
  @override
  String get diaSemana; // "MONDAY"
  @override
  String get diaEspanol; // "Lunes"
  @override
  String get horaInicio; // "08:00"
  @override
  String get horaFin; // "09:30"
  @override
  String? get aula; // Materia
  @override
  int? get materiaId;
  @override
  String? get materiaNombre;
  @override
  String? get materiaCodigo; // Profesor
  @override
  int? get profesorId;
  @override
  String? get profesorNombre;
  @override
  String? get profesorAvatar; // Sustituto (si el profesor está de baja)
  @override
  int? get sustitutoId;
  @override
  String? get sustitutoNombre;
  @override
  String? get sustitutoAvatar; // Grupo y ciclo
  @override
  int? get cursoId;
  @override
  String? get codigoGrupo;
  @override
  String? get colorCiclo;

  /// Create a copy of HorarioSesionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HorarioSesionModelImplCopyWith<_$HorarioSesionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
