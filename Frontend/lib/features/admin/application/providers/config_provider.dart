import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/auth/application/providers/auth_provider.dart';


class SystemConfigNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref _ref;
  SystemConfigNotifier(this._ref) : super(const AsyncValue.loading());

  Future<void> loadConfig(String key) async {
    // Avoid synchronous state update during build/init if called from initState
    Future.microtask(() => state = const AsyncValue.loading());
    try {
      final dio = _ref.read(dioClientProvider);
      final res = await dio.get('admin/configuracion/$key');
      final valor = res.data['valor'] as String;
      
      if (valor.isEmpty) {
        state = AsyncValue.data({key: null});
        return;
      }

      try {
        final decoded = jsonDecode(valor);
        state = AsyncValue.data({key: decoded});
      } catch (e) {
        state = AsyncValue.data({key: valor});
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> saveConfig(String key, dynamic value, {String? description}) async {
    try {
      final dio = _ref.read(dioClientProvider);
      final valorStr = value is String ? value : jsonEncode(value);
      
      await dio.put('admin/configuracion/$key', data: {
        'valor': valorStr,
        'descripcion': description ?? 'Configuración del sistema: $key',
      });
      
      state = AsyncValue.data({key: value});
      return true;
    } catch (e) {
      return false;
    }
  }
}

final systemConfigProvider = StateNotifierProvider<SystemConfigNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return SystemConfigNotifier(ref);
});

// Specific providers for roles and permissions
final rolesListProvider = FutureProvider<List<String>>((ref) async {
  final dio = ref.read(dioClientProvider);
  try {
    final res = await dio.get('admin/configuracion/roles_list');
    final valor = res.data['valor'] as String;
    if (valor.isEmpty) {
      return ['Admin', 'Docente', 'Alumno', 'Tutor'];
    }
    return List<String>.from(jsonDecode(valor));
  } catch (e) {
    return ['Admin', 'Docente', 'Alumno', 'Tutor'];
  }
});

final permissionsMatrixProvider = FutureProvider<Map<String, List<String>>>((ref) async {
  final dio = ref.read(dioClientProvider);
  try {
    final res = await dio.get('admin/configuracion/permissions_matrix');
    final valor = res.data['valor'] as String;
    if (valor.isEmpty) {
      return {
        'Admin': ['Crear Materia', 'Borrar Instancia', 'Ver Historial', 'Pasar Lista', 'Editar Perfil'],
        'Docente': ['Ver Historial', 'Pasar Lista', 'Editar Perfil'],
        'Alumno': ['Ver Historial', 'Editar Perfil'],
      };
    }
    final Map<String, dynamic> decoded = jsonDecode(valor);
    return decoded.map((key, value) => MapEntry(key, List<String>.from(value)));
  } catch (e) {
    return {
      'Admin': ['Crear Materia', 'Borrar Instancia', 'Ver Historial', 'Pasar Lista', 'Editar Perfil'],
      'Docente': ['Ver Historial', 'Pasar Lista', 'Editar Perfil'],
      'Alumno': ['Ver Historial', 'Editar Perfil'],
    };
  }
});

/// Checks if the current user's role has a specific permission.
final canDoProvider = Provider.family<bool, String>((ref, permission) {
  final usuario = ref.watch(usuarioActualProvider);
  if (usuario == null) return false;
  if (usuario.esAdmin) return true; // Admin has all permissions

  final matrixAsync = ref.watch(permissionsMatrixProvider);
  return matrixAsync.maybeWhen(
    data: (matrix) {
      final roleKey = usuario.esDocente ? 'Docente' : 'Alumno';
      final perms = matrix[roleKey] ?? [];
      return perms.contains(permission);
    },
    orElse: () => false,
  );
});






