// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return _LoginResponse.fromJson(json);
}

/// @nodoc
mixin _$LoginResponse {
  /// ID único del usuario en la base de datos (clave primaria).
  int get id => throw _privateConstructorUsedError;

  /// Token JWT firmado con HS512 para incluir en peticiones futuras.
  String get token => throw _privateConstructorUsedError;

  /// Tipo de token, siempre "Bearer".
  String get tipo => throw _privateConstructorUsedError;

  /// Username del usuario autenticado.
  String get username => throw _privateConstructorUsedError;

  /// Nombre completo: "Isabel Fernández Ruiz"
  String get nombre => throw _privateConstructorUsedError;

  /// Roles de Spring Security: ["ROLE_ADMIN"], ["ROLE_TEACHER"], ["ROLE_STUDENT"]
  List<String> get roles => throw _privateConstructorUsedError;

  /// Emoji o URL de avatar para la cabecera de navegación.
  String get avatar => throw _privateConstructorUsedError;

  /// Preferencia de tema: "light" o "dark".
  String get theme => throw _privateConstructorUsedError;

  /// IDs de los cursos de los que este profesor es tutor.
  /// Vacío para alumnos y admins.
  List<int> get cursosTutorIds => throw _privateConstructorUsedError;

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
          LoginResponse value, $Res Function(LoginResponse) then) =
      _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
  @useResult
  $Res call(
      {int id,
      String token,
      String tipo,
      String username,
      String nombre,
      List<String> roles,
      String avatar,
      String theme,
      List<int> cursosTutorIds});
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? token = null,
    Object? tipo = null,
    Object? username = null,
    Object? nombre = null,
    Object? roles = null,
    Object? avatar = null,
    Object? theme = null,
    Object? cursosTutorIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      cursosTutorIds: null == cursosTutorIds
          ? _value.cursosTutorIds
          : cursosTutorIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginResponseImplCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$LoginResponseImplCopyWith(
          _$LoginResponseImpl value, $Res Function(_$LoginResponseImpl) then) =
      __$$LoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String token,
      String tipo,
      String username,
      String nombre,
      List<String> roles,
      String avatar,
      String theme,
      List<int> cursosTutorIds});
}

/// @nodoc
class __$$LoginResponseImplCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseImpl>
    implements _$$LoginResponseImplCopyWith<$Res> {
  __$$LoginResponseImplCopyWithImpl(
      _$LoginResponseImpl _value, $Res Function(_$LoginResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? token = null,
    Object? tipo = null,
    Object? username = null,
    Object? nombre = null,
    Object? roles = null,
    Object? avatar = null,
    Object? theme = null,
    Object? cursosTutorIds = null,
  }) {
    return _then(_$LoginResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      tipo: null == tipo
          ? _value.tipo
          : tipo // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      cursosTutorIds: null == cursosTutorIds
          ? _value._cursosTutorIds
          : cursosTutorIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseImpl extends _LoginResponse {
  const _$LoginResponseImpl(
      {required this.id,
      required this.token,
      required this.tipo,
      required this.username,
      required this.nombre,
      required final List<String> roles,
      required this.avatar,
      this.theme = 'light',
      final List<int> cursosTutorIds = const []})
      : _roles = roles,
        _cursosTutorIds = cursosTutorIds,
        super._();

  factory _$LoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseImplFromJson(json);

  /// ID único del usuario en la base de datos (clave primaria).
  @override
  final int id;

  /// Token JWT firmado con HS512 para incluir en peticiones futuras.
  @override
  final String token;

  /// Tipo de token, siempre "Bearer".
  @override
  final String tipo;

  /// Username del usuario autenticado.
  @override
  final String username;

  /// Nombre completo: "Isabel Fernández Ruiz"
  @override
  final String nombre;

  /// Roles de Spring Security: ["ROLE_ADMIN"], ["ROLE_TEACHER"], ["ROLE_STUDENT"]
  final List<String> _roles;

  /// Roles de Spring Security: ["ROLE_ADMIN"], ["ROLE_TEACHER"], ["ROLE_STUDENT"]
  @override
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  /// Emoji o URL de avatar para la cabecera de navegación.
  @override
  final String avatar;

  /// Preferencia de tema: "light" o "dark".
  @override
  @JsonKey()
  final String theme;

  /// IDs de los cursos de los que este profesor es tutor.
  /// Vacío para alumnos y admins.
  final List<int> _cursosTutorIds;

  /// IDs de los cursos de los que este profesor es tutor.
  /// Vacío para alumnos y admins.
  @override
  @JsonKey()
  List<int> get cursosTutorIds {
    if (_cursosTutorIds is EqualUnmodifiableListView) return _cursosTutorIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cursosTutorIds);
  }

  @override
  String toString() {
    return 'LoginResponse(id: $id, token: $token, tipo: $tipo, username: $username, nombre: $nombre, roles: $roles, avatar: $avatar, theme: $theme, cursosTutorIds: $cursosTutorIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            const DeepCollectionEquality()
                .equals(other._cursosTutorIds, _cursosTutorIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      token,
      tipo,
      username,
      nombre,
      const DeepCollectionEquality().hash(_roles),
      avatar,
      theme,
      const DeepCollectionEquality().hash(_cursosTutorIds));

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      __$$LoginResponseImplCopyWithImpl<_$LoginResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseImplToJson(
      this,
    );
  }
}

abstract class _LoginResponse extends LoginResponse {
  const factory _LoginResponse(
      {required final int id,
      required final String token,
      required final String tipo,
      required final String username,
      required final String nombre,
      required final List<String> roles,
      required final String avatar,
      final String theme,
      final List<int> cursosTutorIds}) = _$LoginResponseImpl;
  const _LoginResponse._() : super._();

  factory _LoginResponse.fromJson(Map<String, dynamic> json) =
      _$LoginResponseImpl.fromJson;

  /// ID único del usuario en la base de datos (clave primaria).
  @override
  int get id;

  /// Token JWT firmado con HS512 para incluir en peticiones futuras.
  @override
  String get token;

  /// Tipo de token, siempre "Bearer".
  @override
  String get tipo;

  /// Username del usuario autenticado.
  @override
  String get username;

  /// Nombre completo: "Isabel Fernández Ruiz"
  @override
  String get nombre;

  /// Roles de Spring Security: ["ROLE_ADMIN"], ["ROLE_TEACHER"], ["ROLE_STUDENT"]
  @override
  List<String> get roles;

  /// Emoji o URL de avatar para la cabecera de navegación.
  @override
  String get avatar;

  /// Preferencia de tema: "light" o "dark".
  @override
  String get theme;

  /// IDs de los cursos de los que este profesor es tutor.
  /// Vacío para alumnos y admins.
  @override
  List<int> get cursosTutorIds;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
