// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'13a5919e90eedfefaaf7fb20f4a1cd61277aa01d';

/// Provider principal de autenticación.
/// Gestiona el ciclo de vida de la sesión JWT.
///
/// FLUJO DE ARRANQUE:
///   1. build() se ejecuta al crear el provider
///   2. Comprueba SecureStorage (isLoggedIn)
///   3. Si hay sesión → estado Authenticated (lee datos del storage)
///   4. Si no → estado Unauthenticated (ir al login)
///
/// NOTA: Los archivos .freezed.dart y .g.dart se generan ejecutando:
///   dart run build_runner build --delete-conflicting-outputs
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, AuthState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

