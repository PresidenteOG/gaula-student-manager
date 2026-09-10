import 'package:flutter_test/flutter_test.dart';
import 'package:gaula_frontend/features/shared/models/festivo_model.dart';

void main() {
  group('FestivoModel — Serialización JSON', () {
    test('fromJson() deserializa un festivo nacional correctamente', () {
      final json = {
        'date': '2026-01-01',
        'localName': 'Año Nuevo',
        'name': "New Year's Day",
        'counties': null,
        'isNational': true,
      };

      final festivo = FestivoModel.fromJson(json);

      expect(festivo.date, '2026-01-01');
      expect(festivo.localName, 'Año Nuevo');
      expect(festivo.name, "New Year's Day");
      expect(festivo.counties, isNull);
      expect(festivo.isNational, true);
    });

    test('fromJson() deserializa un festivo autonómico correctamente', () {
      final json = {
        'date': '2026-06-24',
        'localName': 'Sant Joan',
        'name': 'St. John the Baptist Day',
        'counties': ['ES-CT', 'ES-IB', 'ES-VC'],
        'isNational': false,
      };

      final festivo = FestivoModel.fromJson(json);

      expect(festivo.counties, containsAll(['ES-CT', 'ES-IB', 'ES-VC']));
      expect(festivo.isNational, false);
    });

    test('toJson() serializa correctamente a Map', () {
      const festivo = FestivoModel(
        date: '2026-12-25',
        localName: 'Navidad',
        name: 'Christmas Day',
        counties: null,
        isNational: true,
      );

      final json = festivo.toJson();

      expect(json['date'], '2026-12-25');
      expect(json['localName'], 'Navidad');
      expect(json['isNational'], true);
    });
  });

  group('FestivoModel — Extensión de lógica de negocio', () {
    test('dateTime convierte la fecha string a DateTime', () {
      const festivo = FestivoModel(
        date: '2026-12-25',
        localName: 'Navidad',
        name: 'Christmas Day',
      );

      expect(festivo.dateTime, equals(DateTime(2026, 12, 25)));
    });

    test('nombreMostrar devuelve localName si existe', () {
      const festivo = FestivoModel(
        date: '2026-12-25',
        localName: 'Navidad',
        name: 'Christmas Day',
      );

      expect(festivo.nombreMostrar, 'Navidad');
    });

    test('nombreMostrar devuelve name si localName está vacío', () {
      const festivo = FestivoModel(
        date: '2026-12-25',
        localName: '',
        name: 'Christmas Day',
      );

      expect(festivo.nombreMostrar, 'Christmas Day');
    });

    test('esAutonomico es true cuando counties no es null ni vacío', () {
      const festivo = FestivoModel(
        date: '2026-06-24',
        localName: 'Sant Joan',
        name: 'St. John',
        counties: ['ES-CT'],
        isNational: false,
      );

      expect(festivo.esAutonomico, isTrue);
    });

    test('esAutonomico es false cuando counties es null', () {
      const festivo = FestivoModel(
        date: '2026-01-01',
        localName: 'Año Nuevo',
        name: "New Year's Day",
        isNational: true,
      );

      expect(festivo.esAutonomico, isFalse);
    });

    test('Festivos Freezed — igualdad por valor', () {
      const f1 = FestivoModel(date: '2026-01-01', localName: 'Año Nuevo', name: "New Year's Day");
      const f2 = FestivoModel(date: '2026-01-01', localName: 'Año Nuevo', name: "New Year's Day");

      expect(f1, equals(f2));
    });

    test('Festivos Freezed — copyWith modifica solo el campo deseado', () {
      const original = FestivoModel(
        date: '2026-01-01',
        localName: 'Año Nuevo',
        name: "New Year's Day",
        isNational: true,
      );

      final copia = original.copyWith(localName: 'Cap d\'Any');

      expect(copia.localName, "Cap d'Any");
      expect(copia.date, original.date);
      expect(copia.isNational, original.isNational);
    });
  });
}
