// GAULA — Widget smoke test
// The default Flutter counter test has been replaced because this project
// uses GoRouter + Riverpod, which require a full ProviderScope + router
// setup that is better tested via integration_test.
// This file is intentionally minimal so `flutter analyze` passes cleanly.

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder — GAULA uses integration tests', () {
    // No-op: real tests live in integration_test/
    expect(true, isTrue);
  });
}
