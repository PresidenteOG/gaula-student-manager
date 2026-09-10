import 'package:flutter_test/flutter_test.dart';
import 'package:gaula_frontend/features/auth/domain/entities/login_response.dart';

/// Tests unitarios para la entidad LoginResponse (capa de dominio).
/// Cubre: deserialización, helpers de rol, y comportamiento de campos opcionales.
void main() {
  // ─── Fixture JSON simulando la respuesta del backend POST /api/auth/login ───
  const tJson = {
    'id': 42,
    'token': 'eyJhbGciOiJIUzUxMiJ9.test',
    'tipo': 'Bearer',
    'username': 'rsanchez',
    'nombre': 'Rosa Sánchez Mora',
    'roles': ['ROLE_TEACHER'],
    'avatar': '👩‍🏫',
    'theme': 'dark',
    'cursosTutorIds': [3, 7],
  };

  group('LoginResponse — Serialización JSON', () {
    test('fromJson() deserializa todos los campos correctamente', () {
      final resp = LoginResponse.fromJson(tJson);

      expect(resp.id, 42);
      expect(resp.token, 'eyJhbGciOiJIUzUxMiJ9.test');
      expect(resp.tipo, 'Bearer');
      expect(resp.username, 'rsanchez');
      expect(resp.nombre, 'Rosa Sánchez Mora');
      expect(resp.roles, contains('ROLE_TEACHER'));
      expect(resp.theme, 'dark');
      expect(resp.cursosTutorIds, containsAll([3, 7]));
    });

    test('toJson() serializa sin perder campos clave', () {
      final resp = LoginResponse.fromJson(tJson);
      final json = resp.toJson();

      expect(json['id'], 42);
      expect(json['token'], isNotEmpty);
      expect(json['roles'], contains('ROLE_TEACHER'));
    });

    test('copyWith modifica solo el campo indicado', () {
      final resp = LoginResponse.fromJson(tJson);
      final copia = resp.copyWith(theme: 'light');

      expect(copia.theme, 'light');
      expect(copia.username, resp.username);
      expect(copia.id, resp.id);
    });

    test('igualdad estructural por valor (Freezed)', () {
      final r1 = LoginResponse.fromJson(tJson);
      final r2 = LoginResponse.fromJson(tJson);
      expect(r1, equals(r2));
    });
  });

  group('LoginResponse — Valores por defecto', () {
    test('theme por defecto es "light" si no viene en el JSON', () {
      final resp = LoginResponse.fromJson({...tJson, 'theme': null});
      expect(resp.theme, 'light');
    });

    test('cursosTutorIds por defecto es lista vacía', () {
      final jsonSinCursos = {...tJson};
      jsonSinCursos.remove('cursosTutorIds');
      final resp = LoginResponse.fromJson(jsonSinCursos);
      expect(resp.cursosTutorIds, isEmpty);
    });
  });

  group('LoginResponse — Helpers de Rol', () {
    test('esDocente es true para ROLE_TEACHER', () {
      final resp = LoginResponse.fromJson(tJson);
      expect(resp.esDocente, isTrue);
      expect(resp.esAdmin, isFalse);
      expect(resp.esAlumno, isFalse);
    });

    test('esAdmin es true para ROLE_ADMIN', () {
      final resp = LoginResponse.fromJson({...tJson, 'roles': ['ROLE_ADMIN']});
      expect(resp.esAdmin, isTrue);
      expect(resp.esDocente, isFalse);
    });

    test('esAlumno es true para ROLE_STUDENT', () {
      final resp = LoginResponse.fromJson({...tJson, 'roles': ['ROLE_STUDENT']});
      expect(resp.esAlumno, isTrue);
      expect(resp.esDocente, isFalse);
    });

    test('rolPrincipal devuelve el primer rol de la lista', () {
      final resp = LoginResponse.fromJson({...tJson, 'roles': ['ROLE_ADMIN', 'ROLE_TEACHER']});
      expect(resp.rolPrincipal, 'ROLE_ADMIN');
    });

    test('rolPrincipal devuelve string vacío si la lista está vacía', () {
      final resp = LoginResponse.fromJson({...tJson, 'roles': <String>[]});
      expect(resp.rolPrincipal, '');
    });

    test('esProfesor es alias de esDocente', () {
      final resp = LoginResponse.fromJson(tJson);
      expect(resp.esProfesor, equals(resp.esDocente));
    });
  });
}
