import 'package:flutter_test/flutter_test.dart';
import 'package:gaula_frontend/features/shared/models/horario_model.dart';

void main() {
  group('HorarioSesionModel — Serialización JSON', () {
    final tJson = {
      'id': 1,
      'diaSemana': 'MONDAY',
      'diaEspanol': 'Lunes',
      'horaInicio': '08:00',
      'horaFin': '09:30',
      'aula': 'Aula 101',
      'materiaId': 5,
      'materiaNombre': 'Matemáticas',
      'materiaCodigo': 'MAT',
      'profesorId': 2,
      'profesorNombre': 'Ismael Fernández',
      'profesorAvatar': null,
      'sustitutoId': null,
      'sustitutoNombre': null,
      'sustitutoAvatar': null,
      'cursoId': 3,
      'codigoGrupo': '1A',
      'colorCiclo': '#4A90E2',
    };

    test('fromJson() deserializa todos los campos correctamente', () {
      final sesion = HorarioSesionModel.fromJson(tJson);

      expect(sesion.id, 1);
      expect(sesion.diaSemana, 'MONDAY');
      expect(sesion.diaEspanol, 'Lunes');
      expect(sesion.horaInicio, '08:00');
      expect(sesion.horaFin, '09:30');
      expect(sesion.aula, 'Aula 101');
      expect(sesion.materiaId, 5);
      expect(sesion.materiaNombre, 'Matemáticas');
      expect(sesion.profesorId, 2);
      expect(sesion.profesorNombre, 'Ismael Fernández');
      expect(sesion.sustitutoId, isNull);
      expect(sesion.cursoId, 3);
      expect(sesion.codigoGrupo, '1A');
    });

    test('toJson() serializa correctamente', () {
      final sesion = HorarioSesionModel.fromJson(tJson);
      final json = sesion.toJson();

      expect(json['id'], 1);
      expect(json['diaSemana'], 'MONDAY');
      expect(json['horaInicio'], '08:00');
      expect(json['materiaNombre'], 'Matemáticas');
    });
  });

  group('HorarioSesionModel — Extensión de lógica de negocio', () {
    const tSesion = HorarioSesionModel(
      id: 1,
      diaSemana: 'MONDAY',
      diaEspanol: 'Lunes',
      horaInicio: '08:00',
      horaFin: '09:30',
    );

    test('duracionMinutos calcula correctamente 90 minutos', () {
      expect(tSesion.duracionMinutos, 90);
    });

    test('duracionMinutos calcula correctamente 60 minutos', () {
      const sesion60 = HorarioSesionModel(
        id: 2,
        diaSemana: 'TUESDAY',
        diaEspanol: 'Martes',
        horaInicio: '10:00',
        horaFin: '11:00',
      );
      expect(sesion60.duracionMinutos, 60);
    });

    test('duracionMinutos con horas que cruzan la hora: 08:45 → 10:15 = 90min', () {
      const sesion = HorarioSesionModel(
        id: 3,
        diaSemana: 'WEDNESDAY',
        diaEspanol: 'Miércoles',
        horaInicio: '08:45',
        horaFin: '10:15',
      );
      expect(sesion.duracionMinutos, 90);
    });

    test('haySubstituto es false cuando sustitutoId es null', () {
      expect(tSesion.haySubstituto, isFalse);
    });

    test('haySubstituto es true cuando sustitutoId está asignado', () {
      final conSustituto = tSesion.copyWith(
        sustitutoId: 99,
        sustitutoNombre: 'Carlos López',
      );
      expect(conSustituto.haySubstituto, isTrue);
    });

    test('docenteEfectivo devuelve sustitutoNombre si hay sustituto', () {
      final conSustituto = tSesion.copyWith(
        profesorNombre: 'Ismael Fernández',
        sustitutoId: 99,
        sustitutoNombre: 'Carlos López',
      );
      expect(conSustituto.docenteEfectivo, 'Carlos López');
    });

    test('docenteEfectivo devuelve profesorNombre si no hay sustituto', () {
      final sinSustituto = tSesion.copyWith(
        profesorNombre: 'Ismael Fernández',
      );
      expect(sinSustituto.docenteEfectivo, 'Ismael Fernández');
    });

    test('docenteEfectivo devuelve "Sin asignar" si no hay ni profesor ni sustituto', () {
      expect(tSesion.docenteEfectivo, 'Sin asignar');
    });

    test('Freezed — igualdad por valor', () {
      const s1 = HorarioSesionModel(id: 1, diaSemana: 'MONDAY', diaEspanol: 'Lunes', horaInicio: '08:00', horaFin: '09:30');
      const s2 = HorarioSesionModel(id: 1, diaSemana: 'MONDAY', diaEspanol: 'Lunes', horaInicio: '08:00', horaFin: '09:30');

      expect(s1, equals(s2));
    });
  });
}
