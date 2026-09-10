import 'package:flutter_test/flutter_test.dart';
import 'package:gaula_frontend/features/admin/domain/entities/alumno_model.dart';

void main() {
  final tJson = {
    'id': 1,
    'nombre': 'Carmen',
    'apellidos': 'López García',
    'nombreCompleto': 'Carmen López García',
    'username': 'clopez',
    'email': 'clopez@gaula.es',
    'estado': 'ACTIVO',
    'avatar': '👩‍🎓',
    'fotoUrl': null,
    'dni': '12345678A',
    'telefono': '600123456',
    'direccion': 'Calle Mayor 1',
    'fechaNacimiento': '2005-03-15',
    'cursoId': 2,
    'codigoGrupo': '1A',
    'nombreCurso': 'Primero A',
    'materiaIds': [1, 3, 5],
    'nombresMaterias': ['Matemáticas', 'Lengua', 'Historia'],
  };

  group('AlumnoModel — Serialización JSON', () {
    test('fromJson() deserializa todos los campos correctamente', () {
      final alumno = AlumnoModel.fromJson(tJson);

      expect(alumno.id, 1);
      expect(alumno.nombre, 'Carmen');
      expect(alumno.apellidos, 'López García');
      expect(alumno.nombreCompleto, 'Carmen López García');
      expect(alumno.username, 'clopez');
      expect(alumno.email, 'clopez@gaula.es');
      expect(alumno.estado, 'ACTIVO');
      expect(alumno.cursoId, 2);
      expect(alumno.codigoGrupo, '1A');
      expect(alumno.materiaIds, containsAll([1, 3, 5]));
      expect(alumno.nombresMaterias, containsAll(['Matemáticas', 'Lengua', 'Historia']));
    });

    test('fromJson() usa listas vacías por defecto si no vienen materias', () {
      final jsonSinMaterias = {
        'id': 2, 'nombre': 'Test', 'apellidos': 'Test', 'nombreCompleto': 'Test Test',
        'username': 'test', 'email': 'test@test.es', 'estado': 'ACTIVO', 'avatar': '?',
      };
      final alumno = AlumnoModel.fromJson(jsonSinMaterias);

      expect(alumno.materiaIds, isEmpty);
      expect(alumno.nombresMaterias, isEmpty);
    });

    test('toJson() serializa correctamente', () {
      final alumno = AlumnoModel.fromJson(tJson);
      final json = alumno.toJson();

      expect(json['id'], 1);
      expect(json['nombreCompleto'], 'Carmen López García');
      expect(json['estado'], 'ACTIVO');
    });
  });

  group('AlumnoModel — Extensión de estado', () {
    test('esActivo es true cuando estado es ACTIVO', () {
      final alumno = AlumnoModel.fromJson(tJson);
      expect(alumno.esActivo, isTrue);
      expect(alumno.esInactivo, isFalse);
      expect(alumno.esDeBaja, isFalse);
    });

    test('esInactivo es true cuando estado es INACTIVO', () {
      final alumno = AlumnoModel.fromJson({...tJson, 'estado': 'INACTIVO'});
      expect(alumno.esActivo, isFalse);
      expect(alumno.esInactivo, isTrue);
    });

    test('esDeBaja es true cuando estado es DE_BAJA', () {
      final alumno = AlumnoModel.fromJson({...tJson, 'estado': 'DE_BAJA'});
      expect(alumno.esDeBaja, isTrue);
    });

    test('estado es case-insensitive', () {
      final alumno = AlumnoModel.fromJson({...tJson, 'estado': 'activo'});
      expect(alumno.esActivo, isTrue);
    });
  });

  group('AlumnoModel — Extensión de iniciales', () {
    test('iniciales devuelve las dos primeras letras del nombreCompleto', () {
      final alumno = AlumnoModel.fromJson(tJson);
      expect(alumno.iniciales, 'CL');
    });

    test('iniciales con nombre compuesto devuelve iniciales del primero y segundo', () {
      final alumno = AlumnoModel.fromJson({...tJson, 'nombreCompleto': 'Juan Carlos Pérez'});
      expect(alumno.iniciales, 'JC');
    });

    test('iniciales con un solo nombre devuelve la primera letra', () {
      final alumno = AlumnoModel.fromJson({...tJson, 'nombreCompleto': 'Madonna'});
      expect(alumno.iniciales, 'M');
    });

    test('iniciales devuelve ? si nombreCompleto está vacío', () {
      final alumno = AlumnoModel.fromJson({...tJson, 'nombreCompleto': ''});
      expect(alumno.iniciales, '?');
    });

    test('iniciales siempre devuelve mayúsculas', () {
      final alumno = AlumnoModel.fromJson({...tJson, 'nombreCompleto': 'ana martínez'});
      expect(alumno.iniciales, 'AM');
    });
  });

  group('AlumnoModel — Freezed', () {
    test('igualdad por valor', () {
      final a1 = AlumnoModel.fromJson(tJson);
      final a2 = AlumnoModel.fromJson(tJson);
      expect(a1, equals(a2));
    });

    test('copyWith modifica solo el campo deseado', () {
      final original = AlumnoModel.fromJson(tJson);
      final modificado = original.copyWith(estado: 'INACTIVO');
      expect(modificado.estado, 'INACTIVO');
      expect(modificado.id, original.id);
      expect(modificado.nombre, original.nombre);
    });
  });
}
