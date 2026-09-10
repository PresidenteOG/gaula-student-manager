import 'package:flutter_test/flutter_test.dart';
import 'package:gaula_frontend/features/shared/models/curso_model.dart';

void main() {
  group('CursoModel', () {
    final tCurso = CursoModel(
      id: 1,
      codigoGrupo: '1A',
      codigoCiclo: 'DAM',
      nombreCiclo: 'Desarrollo de Aplicaciones Multiplataforma',
      colorCiclo: '#FF0000',
      tutorNombre: 'Tutor Test',
      materias: [],
    );

    test('debería tener las propiedades correctas', () {
      expect(tCurso.id, 1);
      expect(tCurso.codigoGrupo, '1A');
      expect(tCurso.codigoCiclo, 'DAM');
      expect(tCurso.nombreCiclo, 'Desarrollo de Aplicaciones Multiplataforma');
      expect(tCurso.colorCiclo, '#FF0000');
      expect(tCurso.tutorNombre, 'Tutor Test');
      expect(tCurso.materias, isEmpty);
    });

    test('debería serializar correctamente a JSON', () {
      final json = tCurso.toJson();
      expect(json['id'], 1);
      expect(json['codigoGrupo'], '1A');
      expect(json['codigoCiclo'], 'DAM');
      expect(json['tutorNombre'], 'Tutor Test');
    });
  });
}

