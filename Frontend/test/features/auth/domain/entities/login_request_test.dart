import 'package:flutter_test/flutter_test.dart';
import 'package:gaula_frontend/features/auth/domain/entities/login_request.dart';

void main() {
  group('LoginRequest — Serialización JSON', () {
    test('fromJson() deserializa correctamente', () {
      final json = {'username': 'ifernandez', 'password': 'admin123'};
      final req = LoginRequest.fromJson(json);

      expect(req.username, 'ifernandez');
      expect(req.password, 'admin123');
    });

    test('toJson() serializa correctamente', () {
      const req = LoginRequest(username: 'rsanchez', password: 'pass456');
      final json = req.toJson();

      expect(json['username'], 'rsanchez');
      expect(json['password'], 'pass456');
      expect(json.length, 2);
    });

    test('Freezed — igualdad por valor', () {
      const r1 = LoginRequest(username: 'admin', password: '123');
      const r2 = LoginRequest(username: 'admin', password: '123');
      expect(r1, equals(r2));
    });

    test('Freezed — copyWith modifica solo el campo deseado', () {
      const original = LoginRequest(username: 'admin', password: '123');
      final copia = original.copyWith(password: 'nuevo_pass');
      expect(copia.username, 'admin');
      expect(copia.password, 'nuevo_pass');
    });
  });
}
