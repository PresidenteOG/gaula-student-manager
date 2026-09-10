import 'package:flutter_test/flutter_test.dart';
import 'package:gaula_frontend/features/auth/domain/entities/login_response.dart';

void main() {
  final tJsonAdmin = {
    'id': 1,
    'token': 'eyJhbGciOiJIUzUxMiJ9.test.signature',
    'tipo': 'Bearer',
    'username': 'rsanchez',
    'nombre': 'Roberto Sánchez',
    'roles': ['ROLE_ADMIN'],
    'avatar': '👨‍💼',
    'theme': 'dark',
    'cursosTutorIds': [],
  };

  final tJsonTeacher = {
    'id': 5,
    'token': 'eyJhbGciOiJIUzUxMiJ9.teacher.signature',
    'tipo': 'Bearer',
    'username': 'ifernandez',
    'nombre': 'Ismael Fernández',
    'roles': ['ROLE_TEACHER'],
    'avatar': '👨‍🏫',
    'theme': 'light',
    'cursosTutorIds': [1, 2, 3],
  };

  final tJsonStudent = {
    'id': 99,
    'token': 'eyJhbGciOiJIUzUxMiJ9.student.signature',
    'tipo': 'Bearer',
    'username': 'clopez',
    'nombre': 'Carmen López',
    'roles': ['ROLE_STUDENT'],
    'avatar': '👩‍🎓',
    'theme': 'light',
    'cursosTutorIds': [],
  };

  group('LoginResponse — Serialización JSON', () {
    test('fromJson() deserializa admin correctamente', () {
      final resp = LoginResponse.fromJson(tJsonAdmin);

      expect(resp.id, 1);
      expect(resp.token, 'eyJhbGciOiJIUzUxMiJ9.test.signature');
      expect(resp.tipo, 'Bearer');
      expect(resp.username, 'rsanchez');
      expect(resp.nombre, 'Roberto Sánchez');
      expect(resp.roles, ['ROLE_ADMIN']);
      expect(resp.theme, 'dark');
      expect(resp.cursosTutorIds, isEmpty);
    });

    test('fromJson() deserializa profesor con cursos tutor', () {
      final resp = LoginResponse.fromJson(tJsonTeacher);

      expect(resp.roles, ['ROLE_TEACHER']);
      expect(resp.cursosTutorIds, containsAll([1, 2, 3]));
    });

    test('toJson() incluye todos los campos', () {
      final resp = LoginResponse.fromJson(tJsonAdmin);
      final json = resp.toJson();

      expect(json['id'], 1);
      expect(json['username'], 'rsanchez');
      expect(json['roles'], contains('ROLE_ADMIN'));
    });
  });

  group('LoginResponse — Lógica de roles', () {
    test('esAdmin es true para ROLE_ADMIN', () {
      final resp = LoginResponse.fromJson(tJsonAdmin);
      expect(resp.esAdmin, isTrue);
      expect(resp.esDocente, isFalse);
      expect(resp.esAlumno, isFalse);
    });

    test('esDocente y esProfesor son true para ROLE_TEACHER', () {
      final resp = LoginResponse.fromJson(tJsonTeacher);
      expect(resp.esDocente, isTrue);
      expect(resp.esProfesor, isTrue);
      expect(resp.esAdmin, isFalse);
      expect(resp.esAlumno, isFalse);
    });

    test('esAlumno es true para ROLE_STUDENT', () {
      final resp = LoginResponse.fromJson(tJsonStudent);
      expect(resp.esAlumno, isTrue);
      expect(resp.esAdmin, isFalse);
      expect(resp.esDocente, isFalse);
    });

    test('rolPrincipal devuelve el primer rol', () {
      final resp = LoginResponse.fromJson(tJsonAdmin);
      expect(resp.rolPrincipal, 'ROLE_ADMIN');
    });

    test('rolPrincipal devuelve vacío cuando no hay roles', () {
      final respSinRoles = LoginResponse.fromJson({
        ...tJsonAdmin,
        'roles': <String>[],
      });
      expect(respSinRoles.rolPrincipal, '');
    });

    test('theme por defecto es "light"', () {
      final respSinTheme = LoginResponse.fromJson({
        ...tJsonAdmin,
        'theme': null,
      });
      expect(respSinTheme.theme, 'light');
    });

    test('Freezed — igualdad por valor', () {
      final r1 = LoginResponse.fromJson(tJsonAdmin);
      final r2 = LoginResponse.fromJson(tJsonAdmin);
      expect(r1, equals(r2));
    });
  });
}
