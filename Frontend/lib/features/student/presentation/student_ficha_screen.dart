import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/application/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/locale_utils.dart';

// Provider para obtener los datos completos del alumno desde API
final alumnoFichaProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, alumnoId) async {
  final dio = ref.watch(dioClientProvider);
  final response = await dio.get(ApiConstants.alumnoById(alumnoId));
  return (response.data as Map<String, dynamic>);
});

class StudentFichaScreen extends ConsumerWidget {
  const StudentFichaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final usuario = ref.watch(usuarioActualProvider);
    final alumnoId = usuario?.id;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.fichaAlumnoTitulo, style: TextStyle(color: textColor, fontSize: 40, fontWeight: FontWeight.bold)),
                      Text(l10n.studentFichaDatosDesc, style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                if (alumnoId == null)
                  const Center(child: CircularProgressIndicator(color: AppColors.primary))
                else
                  ref.watch(alumnoFichaProvider(alumnoId)).when(
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    error: (err, _) => _FichaOffline(usuario: usuario),
                    data: (alumno) => _FichaCard(alumno: alumno, usuario: usuario),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FichaCard extends StatelessWidget {
  final Map<String, dynamic> alumno;
  final dynamic usuario;
  const _FichaCard({required this.alumno, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return FadeInUp(
      child: Column(
        children: [
          // Avatar y nombre
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDarkCard : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
              boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Row(
              children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Image.network(
                      '${ApiConstants.uploadsBaseUrl}${alumno['avatar'] ?? usuario?.avatar}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Text('🎓', style: const TextStyle(fontSize: 44)),
                    )
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${alumno['nombre'] ?? ''} ${alumno['apellidos'] ?? ''}',
                        style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _Badge(label: localizeEstado(alumno['estado'] ?? 'ACTIVO', l10n), color: _estadoColor(alumno['estado'] ?? 'ACTIVO')),
                          const SizedBox(width: 8),
                          _Badge(label: l10n.studentFichaRolAlumno, color: AppColors.primary),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('@${alumno['username'] ?? usuario?.username ?? ''}',
                        style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Datos personales
          _SeccionCard(
            titulo: l10n.studentFichaDatosPersonales,
            icon: Icons.person_outline,
            campos: [
              {'label': l10n.studentFichaDniNie, 'value': alumno['dni'] ?? '—'},
              {'label': l10n.alumnoEmail, 'value': alumno['email'] ?? '—'},
              {'label': l10n.studentFichaTelefono, 'value': alumno['telefono'] ?? '—'},
              {'label': l10n.studentFichaDireccion, 'value': alumno['direccion'] ?? '—'},
              {'label': l10n.studentFichaFechaNacimiento, 'value': alumno['fechaNacimiento'] ?? '—'},
            ],
          ),
          const SizedBox(height: 20),

          // Datos académicos
          _SeccionCard(
            titulo: l10n.studentFichaDatosAcademicos,
            icon: Icons.school_outlined,
            campos: [
              {'label': l10n.alumnoCurso, 'value': alumno['nombreCurso'] ?? alumno['cursoId']?.toString() ?? '—'},
              {'label': l10n.studentFichaGrupo, 'value': alumno['codigoGrupo'] ?? '—'},
              {'label': l10n.studentFichaEstadoMatricula, 'value': alumno['estado'] ?? '—'},
            ],
          ),
          const SizedBox(height: 20),

          // Materias Matriculadas
          _MateriasList(materias: alumno['nombresMaterias'] ?? []),
        ],
      ),
    );
  }

  Color _estadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'ACTIVO': return const Color(0xFF34D399);
      case 'INACTIVO': return const Color(0xFFFBBF24);
      case 'DE_BAJA': return const Color(0xFFEF4444);
      default: return AppColors.textSecondary;
    }
  }
}

class _MateriasList extends StatelessWidget {
  final List<dynamic> materias;
  const _MateriasList({required this.materias});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.list_alt_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.studentFichaMateriasMatriculadas, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold))),
              Text(l10n.studentFichaModulos(materias.length), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          if (materias.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text(l10n.sinDatos, style: const TextStyle(color: AppColors.textSecondary))),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: materias.length,
              separatorBuilder: (_, __) => Divider(color: isDark ? AppColors.border : AppColors.borderLight, height: 24),
              itemBuilder: (context, i) {
                final m = materias[i];
                return Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Center(child: Icon(Icons.auto_stories_outlined, color: AppColors.primary, size: 20)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.toString(), style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF34D399).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(l10n.studentFichaMatriculado, style: const TextStyle(color: Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _FichaOffline extends StatelessWidget {
  final dynamic usuario;
  const _FichaOffline({required this.usuario});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
          boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text(usuario?.avatar ?? '🎓', style: const TextStyle(fontSize: 44))),
            ),
            const SizedBox(height: 16),
            Text(usuario?.nombre ?? l10n.studentFichaAlumno, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
            Text('@${usuario?.username ?? ''}', style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted)),
            const SizedBox(height: 24),
            Text(l10n.studentFichaOfflineDesc,
              style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _SeccionCard extends StatelessWidget {
  final String titulo;
  final IconData icon;
  final List<Map<String, String>> campos;
  const _SeccionCard({required this.titulo, required this.icon, required this.campos});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(child: Text(titulo, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 20),
          ...campos.map((campo) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(campo['label']!, style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 3,
                  child: Text(campo['value']!, style: TextStyle(color: textColor, fontSize: 14), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }
}

