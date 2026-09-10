// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'festivo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FestivoModel _$FestivoModelFromJson(Map<String, dynamic> json) {
  return _FestivoModel.fromJson(json);
}

/// @nodoc
mixin _$FestivoModel {
  /// Fecha del festivo en formato ISO: "2025-12-25"
  String get date => throw _privateConstructorUsedError;

  /// Fecha como objeto DateTime (calculado en frontend).
  /// No viene del JSON, se calcula en fromJson.
  String get localName =>
      throw _privateConstructorUsedError; // "Navidad" (en el idioma local)
  String get name =>
      throw _privateConstructorUsedError; // "Christmas Day" (en inglés)
  /// Lista de CCAA donde aplica. Null = festivo nacional.
  /// Ej: ["ES-CT"] para Cataluña.
  List<String>? get counties => throw _privateConstructorUsedError;

  /// True si es festivo nacional (aplica a toda España).
  bool get isNational => throw _privateConstructorUsedError;

  /// Serializes this FestivoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FestivoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FestivoModelCopyWith<FestivoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FestivoModelCopyWith<$Res> {
  factory $FestivoModelCopyWith(
          FestivoModel value, $Res Function(FestivoModel) then) =
      _$FestivoModelCopyWithImpl<$Res, FestivoModel>;
  @useResult
  $Res call(
      {String date,
      String localName,
      String name,
      List<String>? counties,
      bool isNational});
}

/// @nodoc
class _$FestivoModelCopyWithImpl<$Res, $Val extends FestivoModel>
    implements $FestivoModelCopyWith<$Res> {
  _$FestivoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FestivoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? localName = null,
    Object? name = null,
    Object? counties = freezed,
    Object? isNational = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      localName: null == localName
          ? _value.localName
          : localName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      counties: freezed == counties
          ? _value.counties
          : counties // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isNational: null == isNational
          ? _value.isNational
          : isNational // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FestivoModelImplCopyWith<$Res>
    implements $FestivoModelCopyWith<$Res> {
  factory _$$FestivoModelImplCopyWith(
          _$FestivoModelImpl value, $Res Function(_$FestivoModelImpl) then) =
      __$$FestivoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      String localName,
      String name,
      List<String>? counties,
      bool isNational});
}

/// @nodoc
class __$$FestivoModelImplCopyWithImpl<$Res>
    extends _$FestivoModelCopyWithImpl<$Res, _$FestivoModelImpl>
    implements _$$FestivoModelImplCopyWith<$Res> {
  __$$FestivoModelImplCopyWithImpl(
      _$FestivoModelImpl _value, $Res Function(_$FestivoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FestivoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? localName = null,
    Object? name = null,
    Object? counties = freezed,
    Object? isNational = null,
  }) {
    return _then(_$FestivoModelImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      localName: null == localName
          ? _value.localName
          : localName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      counties: freezed == counties
          ? _value._counties
          : counties // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isNational: null == isNational
          ? _value.isNational
          : isNational // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FestivoModelImpl implements _FestivoModel {
  const _$FestivoModelImpl(
      {required this.date,
      required this.localName,
      required this.name,
      final List<String>? counties,
      this.isNational = true})
      : _counties = counties;

  factory _$FestivoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FestivoModelImplFromJson(json);

  /// Fecha del festivo en formato ISO: "2025-12-25"
  @override
  final String date;

  /// Fecha como objeto DateTime (calculado en frontend).
  /// No viene del JSON, se calcula en fromJson.
  @override
  final String localName;
// "Navidad" (en el idioma local)
  @override
  final String name;
// "Christmas Day" (en inglés)
  /// Lista de CCAA donde aplica. Null = festivo nacional.
  /// Ej: ["ES-CT"] para Cataluña.
  final List<String>? _counties;
// "Christmas Day" (en inglés)
  /// Lista de CCAA donde aplica. Null = festivo nacional.
  /// Ej: ["ES-CT"] para Cataluña.
  @override
  List<String>? get counties {
    final value = _counties;
    if (value == null) return null;
    if (_counties is EqualUnmodifiableListView) return _counties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// True si es festivo nacional (aplica a toda España).
  @override
  @JsonKey()
  final bool isNational;

  @override
  String toString() {
    return 'FestivoModel(date: $date, localName: $localName, name: $name, counties: $counties, isNational: $isNational)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FestivoModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.localName, localName) ||
                other.localName == localName) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._counties, _counties) &&
            (identical(other.isNational, isNational) ||
                other.isNational == isNational));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, localName, name,
      const DeepCollectionEquality().hash(_counties), isNational);

  /// Create a copy of FestivoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FestivoModelImplCopyWith<_$FestivoModelImpl> get copyWith =>
      __$$FestivoModelImplCopyWithImpl<_$FestivoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FestivoModelImplToJson(
      this,
    );
  }
}

abstract class _FestivoModel implements FestivoModel {
  const factory _FestivoModel(
      {required final String date,
      required final String localName,
      required final String name,
      final List<String>? counties,
      final bool isNational}) = _$FestivoModelImpl;

  factory _FestivoModel.fromJson(Map<String, dynamic> json) =
      _$FestivoModelImpl.fromJson;

  /// Fecha del festivo en formato ISO: "2025-12-25"
  @override
  String get date;

  /// Fecha como objeto DateTime (calculado en frontend).
  /// No viene del JSON, se calcula en fromJson.
  @override
  String get localName; // "Navidad" (en el idioma local)
  @override
  String get name; // "Christmas Day" (en inglés)
  /// Lista de CCAA donde aplica. Null = festivo nacional.
  /// Ej: ["ES-CT"] para Cataluña.
  @override
  List<String>? get counties;

  /// True si es festivo nacional (aplica a toda España).
  @override
  bool get isNational;

  /// Create a copy of FestivoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FestivoModelImplCopyWith<_$FestivoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
