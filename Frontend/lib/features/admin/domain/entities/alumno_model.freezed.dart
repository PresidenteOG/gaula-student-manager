// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alumno_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AlumnoModel _$AlumnoModelFromJson(Map<String, dynamic> json) {
  return _AlumnoModel.fromJson(json);
}

/// @nodoc
mixin _$AlumnoModel {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String get apellidos => throw _privateConstructorUsedError;
  String get nombreCompleto => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get estado => throw _privateConstructorUsedError;
  String get avatar => throw _privateConstructorUsedError;
  String? get fotoUrl => throw _privateConstructorUsedError;
  String? get dni => throw _privateConstructorUsedError;
  String? get telefono => throw _privateConstructorUsedError;
  String? get direccion => throw _privateConstructorUsedError;
  String? get fechaNacimiento => throw _privateConstructorUsedError;
  int? get cursoId => throw _privateConstructorUsedError;
  String? get codigoGrupo => throw _privateConstructorUsedError;
  String? get nombreCurso => throw _privateConstructorUsedError;
  List<int> get materiaIds => throw _privateConstructorUsedError;
  List<String> get nombresMaterias => throw _privateConstructorUsedError;

  /// Serializes this AlumnoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlumnoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlumnoModelCopyWith<AlumnoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlumnoModelCopyWith<$Res> {
  factory $AlumnoModelCopyWith(
          AlumnoModel value, $Res Function(AlumnoModel) then) =
      _$AlumnoModelCopyWithImpl<$Res, AlumnoModel>;
  @useResult
  $Res call(
      {int id,
      String nombre,
      String apellidos,
      String nombreCompleto,
      String username,
      String email,
      String estado,
      String avatar,
      String? fotoUrl,
      String? dni,
      String? telefono,
      String? direccion,
      String? fechaNacimiento,
      int? cursoId,
      String? codigoGrupo,
      String? nombreCurso,
      List<int> materiaIds,
      List<String> nombresMaterias});
}

/// @nodoc
class _$AlumnoModelCopyWithImpl<$Res, $Val extends AlumnoModel>
    implements $AlumnoModelCopyWith<$Res> {
  _$AlumnoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlumnoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? apellidos = null,
    Object? nombreCompleto = null,
    Object? username = null,
    Object? email = null,
    Object? estado = null,
    Object? avatar = null,
    Object? fotoUrl = freezed,
    Object? dni = freezed,
    Object? telefono = freezed,
    Object? direccion = freezed,
    Object? fechaNacimiento = freezed,
    Object? cursoId = freezed,
    Object? codigoGrupo = freezed,
    Object? nombreCurso = freezed,
    Object? materiaIds = null,
    Object? nombresMaterias = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      apellidos: null == apellidos
          ? _value.apellidos
          : apellidos // ignore: cast_nullable_to_non_nullable
              as String,
      nombreCompleto: null == nombreCompleto
          ? _value.nombreCompleto
          : nombreCompleto // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      fotoUrl: freezed == fotoUrl
          ? _value.fotoUrl
          : fotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dni: freezed == dni
          ? _value.dni
          : dni // ignore: cast_nullable_to_non_nullable
              as String?,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      direccion: freezed == direccion
          ? _value.direccion
          : direccion // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaNacimiento: freezed == fechaNacimiento
          ? _value.fechaNacimiento
          : fechaNacimiento // ignore: cast_nullable_to_non_nullable
              as String?,
      cursoId: freezed == cursoId
          ? _value.cursoId
          : cursoId // ignore: cast_nullable_to_non_nullable
              as int?,
      codigoGrupo: freezed == codigoGrupo
          ? _value.codigoGrupo
          : codigoGrupo // ignore: cast_nullable_to_non_nullable
              as String?,
      nombreCurso: freezed == nombreCurso
          ? _value.nombreCurso
          : nombreCurso // ignore: cast_nullable_to_non_nullable
              as String?,
      materiaIds: null == materiaIds
          ? _value.materiaIds
          : materiaIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      nombresMaterias: null == nombresMaterias
          ? _value.nombresMaterias
          : nombresMaterias // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlumnoModelImplCopyWith<$Res>
    implements $AlumnoModelCopyWith<$Res> {
  factory _$$AlumnoModelImplCopyWith(
          _$AlumnoModelImpl value, $Res Function(_$AlumnoModelImpl) then) =
      __$$AlumnoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String nombre,
      String apellidos,
      String nombreCompleto,
      String username,
      String email,
      String estado,
      String avatar,
      String? fotoUrl,
      String? dni,
      String? telefono,
      String? direccion,
      String? fechaNacimiento,
      int? cursoId,
      String? codigoGrupo,
      String? nombreCurso,
      List<int> materiaIds,
      List<String> nombresMaterias});
}

/// @nodoc
class __$$AlumnoModelImplCopyWithImpl<$Res>
    extends _$AlumnoModelCopyWithImpl<$Res, _$AlumnoModelImpl>
    implements _$$AlumnoModelImplCopyWith<$Res> {
  __$$AlumnoModelImplCopyWithImpl(
      _$AlumnoModelImpl _value, $Res Function(_$AlumnoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlumnoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? apellidos = null,
    Object? nombreCompleto = null,
    Object? username = null,
    Object? email = null,
    Object? estado = null,
    Object? avatar = null,
    Object? fotoUrl = freezed,
    Object? dni = freezed,
    Object? telefono = freezed,
    Object? direccion = freezed,
    Object? fechaNacimiento = freezed,
    Object? cursoId = freezed,
    Object? codigoGrupo = freezed,
    Object? nombreCurso = freezed,
    Object? materiaIds = null,
    Object? nombresMaterias = null,
  }) {
    return _then(_$AlumnoModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      apellidos: null == apellidos
          ? _value.apellidos
          : apellidos // ignore: cast_nullable_to_non_nullable
              as String,
      nombreCompleto: null == nombreCompleto
          ? _value.nombreCompleto
          : nombreCompleto // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      fotoUrl: freezed == fotoUrl
          ? _value.fotoUrl
          : fotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dni: freezed == dni
          ? _value.dni
          : dni // ignore: cast_nullable_to_non_nullable
              as String?,
      telefono: freezed == telefono
          ? _value.telefono
          : telefono // ignore: cast_nullable_to_non_nullable
              as String?,
      direccion: freezed == direccion
          ? _value.direccion
          : direccion // ignore: cast_nullable_to_non_nullable
              as String?,
      fechaNacimiento: freezed == fechaNacimiento
          ? _value.fechaNacimiento
          : fechaNacimiento // ignore: cast_nullable_to_non_nullable
              as String?,
      cursoId: freezed == cursoId
          ? _value.cursoId
          : cursoId // ignore: cast_nullable_to_non_nullable
              as int?,
      codigoGrupo: freezed == codigoGrupo
          ? _value.codigoGrupo
          : codigoGrupo // ignore: cast_nullable_to_non_nullable
              as String?,
      nombreCurso: freezed == nombreCurso
          ? _value.nombreCurso
          : nombreCurso // ignore: cast_nullable_to_non_nullable
              as String?,
      materiaIds: null == materiaIds
          ? _value._materiaIds
          : materiaIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      nombresMaterias: null == nombresMaterias
          ? _value._nombresMaterias
          : nombresMaterias // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlumnoModelImpl implements _AlumnoModel {
  const _$AlumnoModelImpl(
      {required this.id,
      required this.nombre,
      required this.apellidos,
      required this.nombreCompleto,
      required this.username,
      required this.email,
      required this.estado,
      required this.avatar,
      this.fotoUrl,
      this.dni,
      this.telefono,
      this.direccion,
      this.fechaNacimiento,
      this.cursoId,
      this.codigoGrupo,
      this.nombreCurso,
      final List<int> materiaIds = const [],
      final List<String> nombresMaterias = const []})
      : _materiaIds = materiaIds,
        _nombresMaterias = nombresMaterias;

  factory _$AlumnoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlumnoModelImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;
  @override
  final String apellidos;
  @override
  final String nombreCompleto;
  @override
  final String username;
  @override
  final String email;
  @override
  final String estado;
  @override
  final String avatar;
  @override
  final String? fotoUrl;
  @override
  final String? dni;
  @override
  final String? telefono;
  @override
  final String? direccion;
  @override
  final String? fechaNacimiento;
  @override
  final int? cursoId;
  @override
  final String? codigoGrupo;
  @override
  final String? nombreCurso;
  final List<int> _materiaIds;
  @override
  @JsonKey()
  List<int> get materiaIds {
    if (_materiaIds is EqualUnmodifiableListView) return _materiaIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_materiaIds);
  }

  final List<String> _nombresMaterias;
  @override
  @JsonKey()
  List<String> get nombresMaterias {
    if (_nombresMaterias is EqualUnmodifiableListView) return _nombresMaterias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nombresMaterias);
  }

  @override
  String toString() {
    return 'AlumnoModel(id: $id, nombre: $nombre, apellidos: $apellidos, nombreCompleto: $nombreCompleto, username: $username, email: $email, estado: $estado, avatar: $avatar, fotoUrl: $fotoUrl, dni: $dni, telefono: $telefono, direccion: $direccion, fechaNacimiento: $fechaNacimiento, cursoId: $cursoId, codigoGrupo: $codigoGrupo, nombreCurso: $nombreCurso, materiaIds: $materiaIds, nombresMaterias: $nombresMaterias)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlumnoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.apellidos, apellidos) ||
                other.apellidos == apellidos) &&
            (identical(other.nombreCompleto, nombreCompleto) ||
                other.nombreCompleto == nombreCompleto) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl) &&
            (identical(other.dni, dni) || other.dni == dni) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.direccion, direccion) ||
                other.direccion == direccion) &&
            (identical(other.fechaNacimiento, fechaNacimiento) ||
                other.fechaNacimiento == fechaNacimiento) &&
            (identical(other.cursoId, cursoId) || other.cursoId == cursoId) &&
            (identical(other.codigoGrupo, codigoGrupo) ||
                other.codigoGrupo == codigoGrupo) &&
            (identical(other.nombreCurso, nombreCurso) ||
                other.nombreCurso == nombreCurso) &&
            const DeepCollectionEquality()
                .equals(other._materiaIds, _materiaIds) &&
            const DeepCollectionEquality()
                .equals(other._nombresMaterias, _nombresMaterias));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nombre,
      apellidos,
      nombreCompleto,
      username,
      email,
      estado,
      avatar,
      fotoUrl,
      dni,
      telefono,
      direccion,
      fechaNacimiento,
      cursoId,
      codigoGrupo,
      nombreCurso,
      const DeepCollectionEquality().hash(_materiaIds),
      const DeepCollectionEquality().hash(_nombresMaterias));

  /// Create a copy of AlumnoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlumnoModelImplCopyWith<_$AlumnoModelImpl> get copyWith =>
      __$$AlumnoModelImplCopyWithImpl<_$AlumnoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlumnoModelImplToJson(
      this,
    );
  }
}

abstract class _AlumnoModel implements AlumnoModel {
  const factory _AlumnoModel(
      {required final int id,
      required final String nombre,
      required final String apellidos,
      required final String nombreCompleto,
      required final String username,
      required final String email,
      required final String estado,
      required final String avatar,
      final String? fotoUrl,
      final String? dni,
      final String? telefono,
      final String? direccion,
      final String? fechaNacimiento,
      final int? cursoId,
      final String? codigoGrupo,
      final String? nombreCurso,
      final List<int> materiaIds,
      final List<String> nombresMaterias}) = _$AlumnoModelImpl;

  factory _AlumnoModel.fromJson(Map<String, dynamic> json) =
      _$AlumnoModelImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;
  @override
  String get apellidos;
  @override
  String get nombreCompleto;
  @override
  String get username;
  @override
  String get email;
  @override
  String get estado;
  @override
  String get avatar;
  @override
  String? get fotoUrl;
  @override
  String? get dni;
  @override
  String? get telefono;
  @override
  String? get direccion;
  @override
  String? get fechaNacimiento;
  @override
  int? get cursoId;
  @override
  String? get codigoGrupo;
  @override
  String? get nombreCurso;
  @override
  List<int> get materiaIds;
  @override
  List<String> get nombresMaterias;

  /// Create a copy of AlumnoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlumnoModelImplCopyWith<_$AlumnoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
