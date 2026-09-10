// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profesor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfesorModel _$ProfesorModelFromJson(Map<String, dynamic> json) {
  return _ProfesorModel.fromJson(json);
}

/// @nodoc
mixin _$ProfesorModel {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String get apellidos => throw _privateConstructorUsedError;
  String get nombreCompleto => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get estado => throw _privateConstructorUsedError;
  String get rol => throw _privateConstructorUsedError;
  String get avatar => throw _privateConstructorUsedError;
  String? get fotoUrl => throw _privateConstructorUsedError;
  String? get especialidades => throw _privateConstructorUsedError;
  SustitutoInfo? get sustituto => throw _privateConstructorUsedError;
  List<int> get cursosTutorIds => throw _privateConstructorUsedError;
  List<String> get cursosTutorCodigos => throw _privateConstructorUsedError;

  /// Serializes this ProfesorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfesorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfesorModelCopyWith<ProfesorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfesorModelCopyWith<$Res> {
  factory $ProfesorModelCopyWith(
          ProfesorModel value, $Res Function(ProfesorModel) then) =
      _$ProfesorModelCopyWithImpl<$Res, ProfesorModel>;
  @useResult
  $Res call(
      {int id,
      String nombre,
      String apellidos,
      String nombreCompleto,
      String username,
      String email,
      String estado,
      String rol,
      String avatar,
      String? fotoUrl,
      String? especialidades,
      SustitutoInfo? sustituto,
      List<int> cursosTutorIds,
      List<String> cursosTutorCodigos});

  $SustitutoInfoCopyWith<$Res>? get sustituto;
}

/// @nodoc
class _$ProfesorModelCopyWithImpl<$Res, $Val extends ProfesorModel>
    implements $ProfesorModelCopyWith<$Res> {
  _$ProfesorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfesorModel
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
    Object? rol = null,
    Object? avatar = null,
    Object? fotoUrl = freezed,
    Object? especialidades = freezed,
    Object? sustituto = freezed,
    Object? cursosTutorIds = null,
    Object? cursosTutorCodigos = null,
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
      rol: null == rol
          ? _value.rol
          : rol // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      fotoUrl: freezed == fotoUrl
          ? _value.fotoUrl
          : fotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      especialidades: freezed == especialidades
          ? _value.especialidades
          : especialidades // ignore: cast_nullable_to_non_nullable
              as String?,
      sustituto: freezed == sustituto
          ? _value.sustituto
          : sustituto // ignore: cast_nullable_to_non_nullable
              as SustitutoInfo?,
      cursosTutorIds: null == cursosTutorIds
          ? _value.cursosTutorIds
          : cursosTutorIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      cursosTutorCodigos: null == cursosTutorCodigos
          ? _value.cursosTutorCodigos
          : cursosTutorCodigos // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of ProfesorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SustitutoInfoCopyWith<$Res>? get sustituto {
    if (_value.sustituto == null) {
      return null;
    }

    return $SustitutoInfoCopyWith<$Res>(_value.sustituto!, (value) {
      return _then(_value.copyWith(sustituto: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfesorModelImplCopyWith<$Res>
    implements $ProfesorModelCopyWith<$Res> {
  factory _$$ProfesorModelImplCopyWith(
          _$ProfesorModelImpl value, $Res Function(_$ProfesorModelImpl) then) =
      __$$ProfesorModelImplCopyWithImpl<$Res>;
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
      String rol,
      String avatar,
      String? fotoUrl,
      String? especialidades,
      SustitutoInfo? sustituto,
      List<int> cursosTutorIds,
      List<String> cursosTutorCodigos});

  @override
  $SustitutoInfoCopyWith<$Res>? get sustituto;
}

/// @nodoc
class __$$ProfesorModelImplCopyWithImpl<$Res>
    extends _$ProfesorModelCopyWithImpl<$Res, _$ProfesorModelImpl>
    implements _$$ProfesorModelImplCopyWith<$Res> {
  __$$ProfesorModelImplCopyWithImpl(
      _$ProfesorModelImpl _value, $Res Function(_$ProfesorModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfesorModel
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
    Object? rol = null,
    Object? avatar = null,
    Object? fotoUrl = freezed,
    Object? especialidades = freezed,
    Object? sustituto = freezed,
    Object? cursosTutorIds = null,
    Object? cursosTutorCodigos = null,
  }) {
    return _then(_$ProfesorModelImpl(
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
      rol: null == rol
          ? _value.rol
          : rol // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      fotoUrl: freezed == fotoUrl
          ? _value.fotoUrl
          : fotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      especialidades: freezed == especialidades
          ? _value.especialidades
          : especialidades // ignore: cast_nullable_to_non_nullable
              as String?,
      sustituto: freezed == sustituto
          ? _value.sustituto
          : sustituto // ignore: cast_nullable_to_non_nullable
              as SustitutoInfo?,
      cursosTutorIds: null == cursosTutorIds
          ? _value._cursosTutorIds
          : cursosTutorIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      cursosTutorCodigos: null == cursosTutorCodigos
          ? _value._cursosTutorCodigos
          : cursosTutorCodigos // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfesorModelImpl implements _ProfesorModel {
  const _$ProfesorModelImpl(
      {required this.id,
      required this.nombre,
      required this.apellidos,
      required this.nombreCompleto,
      required this.username,
      required this.email,
      required this.estado,
      required this.rol,
      required this.avatar,
      this.fotoUrl,
      this.especialidades,
      this.sustituto,
      final List<int> cursosTutorIds = const [],
      final List<String> cursosTutorCodigos = const []})
      : _cursosTutorIds = cursosTutorIds,
        _cursosTutorCodigos = cursosTutorCodigos;

  factory _$ProfesorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfesorModelImplFromJson(json);

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
  final String rol;
  @override
  final String avatar;
  @override
  final String? fotoUrl;
  @override
  final String? especialidades;
  @override
  final SustitutoInfo? sustituto;
  final List<int> _cursosTutorIds;
  @override
  @JsonKey()
  List<int> get cursosTutorIds {
    if (_cursosTutorIds is EqualUnmodifiableListView) return _cursosTutorIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cursosTutorIds);
  }

  final List<String> _cursosTutorCodigos;
  @override
  @JsonKey()
  List<String> get cursosTutorCodigos {
    if (_cursosTutorCodigos is EqualUnmodifiableListView)
      return _cursosTutorCodigos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cursosTutorCodigos);
  }

  @override
  String toString() {
    return 'ProfesorModel(id: $id, nombre: $nombre, apellidos: $apellidos, nombreCompleto: $nombreCompleto, username: $username, email: $email, estado: $estado, rol: $rol, avatar: $avatar, fotoUrl: $fotoUrl, especialidades: $especialidades, sustituto: $sustituto, cursosTutorIds: $cursosTutorIds, cursosTutorCodigos: $cursosTutorCodigos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfesorModelImpl &&
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
            (identical(other.rol, rol) || other.rol == rol) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl) &&
            (identical(other.especialidades, especialidades) ||
                other.especialidades == especialidades) &&
            (identical(other.sustituto, sustituto) ||
                other.sustituto == sustituto) &&
            const DeepCollectionEquality()
                .equals(other._cursosTutorIds, _cursosTutorIds) &&
            const DeepCollectionEquality()
                .equals(other._cursosTutorCodigos, _cursosTutorCodigos));
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
      rol,
      avatar,
      fotoUrl,
      especialidades,
      sustituto,
      const DeepCollectionEquality().hash(_cursosTutorIds),
      const DeepCollectionEquality().hash(_cursosTutorCodigos));

  /// Create a copy of ProfesorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfesorModelImplCopyWith<_$ProfesorModelImpl> get copyWith =>
      __$$ProfesorModelImplCopyWithImpl<_$ProfesorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfesorModelImplToJson(
      this,
    );
  }
}

abstract class _ProfesorModel implements ProfesorModel {
  const factory _ProfesorModel(
      {required final int id,
      required final String nombre,
      required final String apellidos,
      required final String nombreCompleto,
      required final String username,
      required final String email,
      required final String estado,
      required final String rol,
      required final String avatar,
      final String? fotoUrl,
      final String? especialidades,
      final SustitutoInfo? sustituto,
      final List<int> cursosTutorIds,
      final List<String> cursosTutorCodigos}) = _$ProfesorModelImpl;

  factory _ProfesorModel.fromJson(Map<String, dynamic> json) =
      _$ProfesorModelImpl.fromJson;

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
  String get rol;
  @override
  String get avatar;
  @override
  String? get fotoUrl;
  @override
  String? get especialidades;
  @override
  SustitutoInfo? get sustituto;
  @override
  List<int> get cursosTutorIds;
  @override
  List<String> get cursosTutorCodigos;

  /// Create a copy of ProfesorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfesorModelImplCopyWith<_$ProfesorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SustitutoInfo _$SustitutoInfoFromJson(Map<String, dynamic> json) {
  return _SustitutoInfo.fromJson(json);
}

/// @nodoc
mixin _$SustitutoInfo {
  int get id => throw _privateConstructorUsedError;
  String get nombreCompleto => throw _privateConstructorUsedError;
  String get avatar => throw _privateConstructorUsedError;

  /// Serializes this SustitutoInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SustitutoInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SustitutoInfoCopyWith<SustitutoInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SustitutoInfoCopyWith<$Res> {
  factory $SustitutoInfoCopyWith(
          SustitutoInfo value, $Res Function(SustitutoInfo) then) =
      _$SustitutoInfoCopyWithImpl<$Res, SustitutoInfo>;
  @useResult
  $Res call({int id, String nombreCompleto, String avatar});
}

/// @nodoc
class _$SustitutoInfoCopyWithImpl<$Res, $Val extends SustitutoInfo>
    implements $SustitutoInfoCopyWith<$Res> {
  _$SustitutoInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SustitutoInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreCompleto = null,
    Object? avatar = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombreCompleto: null == nombreCompleto
          ? _value.nombreCompleto
          : nombreCompleto // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SustitutoInfoImplCopyWith<$Res>
    implements $SustitutoInfoCopyWith<$Res> {
  factory _$$SustitutoInfoImplCopyWith(
          _$SustitutoInfoImpl value, $Res Function(_$SustitutoInfoImpl) then) =
      __$$SustitutoInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nombreCompleto, String avatar});
}

/// @nodoc
class __$$SustitutoInfoImplCopyWithImpl<$Res>
    extends _$SustitutoInfoCopyWithImpl<$Res, _$SustitutoInfoImpl>
    implements _$$SustitutoInfoImplCopyWith<$Res> {
  __$$SustitutoInfoImplCopyWithImpl(
      _$SustitutoInfoImpl _value, $Res Function(_$SustitutoInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SustitutoInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreCompleto = null,
    Object? avatar = null,
  }) {
    return _then(_$SustitutoInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nombreCompleto: null == nombreCompleto
          ? _value.nombreCompleto
          : nombreCompleto // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SustitutoInfoImpl implements _SustitutoInfo {
  const _$SustitutoInfoImpl(
      {required this.id, required this.nombreCompleto, required this.avatar});

  factory _$SustitutoInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SustitutoInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String nombreCompleto;
  @override
  final String avatar;

  @override
  String toString() {
    return 'SustitutoInfo(id: $id, nombreCompleto: $nombreCompleto, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SustitutoInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombreCompleto, nombreCompleto) ||
                other.nombreCompleto == nombreCompleto) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nombreCompleto, avatar);

  /// Create a copy of SustitutoInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SustitutoInfoImplCopyWith<_$SustitutoInfoImpl> get copyWith =>
      __$$SustitutoInfoImplCopyWithImpl<_$SustitutoInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SustitutoInfoImplToJson(
      this,
    );
  }
}

abstract class _SustitutoInfo implements SustitutoInfo {
  const factory _SustitutoInfo(
      {required final int id,
      required final String nombreCompleto,
      required final String avatar}) = _$SustitutoInfoImpl;

  factory _SustitutoInfo.fromJson(Map<String, dynamic> json) =
      _$SustitutoInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get nombreCompleto;
  @override
  String get avatar;

  /// Create a copy of SustitutoInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SustitutoInfoImplCopyWith<_$SustitutoInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
