# GAULA Flutter Testing Architecture

Esta carpeta sigue exactamente la misma estructura de la carpeta lib/ (Domain-Driven Design).

## Convenciones
1. Los tests de lib/features/admin/domain/entities/alumno_model.dart deben ir en 	est/features/admin/domain/entities/alumno_model_test.dart.
2. Usar **Unit Tests** para la lógica pura en domain/ y pplication/.
3. Usar **Widget Tests** para probar componentes de la UI en presentation/widgets/.
4. Usar **Integration Tests** (con integration_test) si necesitas simular un flujo completo en dispositivo real.
