import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/crear_incidencia_dialog.dart';
import '../../admin/application/providers/alumnos_provider.dart';
import '../../attendance/application/attendance_providers.dart';
import '../../shared/presentation/horario_screen.dart';
import '../../../shared/widgets/gaula_profile_image.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../admin/application/providers/config_provider.dart';
import '../../auth/application/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';



class StudentDetailScreen extends ConsumerWidget {
  final int studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final asyncStudent = ref.watch(studentDetailProvider(studentId));
    final asyncResumen = ref.watch(studentAttendanceSummaryProvider(studentId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: asyncStudent.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, st) => Center(child: Text(l10n.errorGenerico, style: const TextStyle(color: Colors.red))),
        data: (alumno) => SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
                    label: Text(l10n.fichaVolverAlumnos, style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: 24),

                  // Main Card
                  FadeInUp(
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
                      ),
                      child: Column(
                        children: [
                          // Profile Header
                          GaulaProfileImage(
                            fotoUrl: alumno.avatar,
                            nombre: '${alumno.nombre} ${alumno.apellidos}',
                            radius: 64,
                            textStyle: const TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 24),
                          Text('${alumno.nombre} ${alumno.apellidos}',
                            style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${alumno.codigoGrupo ?? l10n.fichaSinGrupo}${alumno.nombreCurso != null ? ' • ${alumno.nombreCurso}' : ''}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),

                          // Contact Grid
                          Row(
                            children: [
                              Expanded(child: _InfoCard(label: 'Email', value: alumno.email, icon: Icons.mail_outline)),
                              const SizedBox(width: 24),
                              Expanded(child: _InfoCard(label: l10n.fichaTelefono, value: alumno.telefono ?? l10n.fichaNoEspecificado, icon: Icons.phone_outlined)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: _InfoCard(label: 'DNI', value: alumno.dni ?? 'N/A', icon: Icons.badge_outlined)),
                              const SizedBox(width: 24),
                              Expanded(child: _InfoCard(label: l10n.fichaDireccion, value: alumno.direccion ?? l10n.fichaSinDireccion, icon: Icons.location_on_outlined)),
                            ],
                          ),
                          const SizedBox(height: 48),

                          // Stats Grid
                          Align(alignment: Alignment.centerLeft, child: Text(l10n.fichaEstadisticasAsistencia, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold))),
                          const SizedBox(height: 16),
                          asyncResumen.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => Text(l10n.errorGenerico, style: const TextStyle(color: Colors.red)),
                            data: (resumen) => Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _StatBox(label: l10n.fichaAsistencia, value: '${resumen['asistenciaTotal'] ?? 100}%', color: Colors.greenAccent, onTap: () => _showRecordsModal(context, studentId, 'TODO', alumno.nombre, alumno.cursoId))),
                                    const SizedBox(width: 16),
                                    Expanded(child: _StatBox(label: l10n.fichaFaltas, value: '${(resumen['faltasSinJustificar'] ?? 0)}', color: Colors.redAccent, onTap: () => _showRecordsModal(context, studentId, 'AUSENTE', alumno.nombre, alumno.cursoId))),
                                    const SizedBox(width: 16),
                                    Expanded(child: _StatBox(label: l10n.fichaRetrasos, value: '${resumen['retrasos'] ?? 0}', color: Colors.orangeAccent, onTap: () => _showRecordsModal(context, studentId, 'RETRASO', alumno.nombre, alumno.cursoId))),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(child: _StatBox(label: l10n.fichaJustificadas, value: '${resumen['faltasJustificadas'] ?? 0}', color: Colors.blueAccent, onTap: () => _showRecordsModal(context, studentId, 'JUSTIFICADO', alumno.nombre, alumno.cursoId))),
                                    const SizedBox(width: 16),
                                    Expanded(child: _StatBox(label: l10n.fichaTotalClases, value: '${resumen['totalClases'] ?? 0}', color: AppColors.textSecondary)),
                                    const SizedBox(width: 16),
                                    Expanded(child: _StatBox(label: l10n.fichaHorasFaltadas, value: '${resumen['horasFaltadas'] ?? 0}h', color: Colors.orange)),
                                  ],
                                ),
                                const SizedBox(height: 48),
                                Align(alignment: Alignment.centerLeft, child: Text(l10n.fichaDesgloseModulo, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5))),
                                const SizedBox(height: 24),
                                if ((resumen['modulos'] as List? ?? []).isEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(32),
                                    decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50, borderRadius: BorderRadius.circular(20)),
                                    child: Center(child: Text(l10n.fichaSinDatosModulo, style: const TextStyle(color: AppColors.textSecondary))),
                                  )
                                else
                                    ...((resumen['modulos'] as List).map((m) {
                                      final totalClases = (m['totalClases'] as num?)?.toInt() ?? 0;
                                      final presentes = (m['presentes'] as num?)?.toInt() ?? 0;
                                      final totalFaltas = (m['totalFaltas'] as num?)?.toDouble() ?? 0.0;
                                      final maxFaltas = (m['maxFaltas'] as num?)?.toInt() ?? 0;
                                      
                                      // El progreso es relativo al LÍMITE de faltas (habitualmente 20%)
                                      final riskPercent = maxFaltas > 0 ? (totalFaltas / maxFaltas) : 0.0;
                                      // Color según cercaní­a al lí­mite
                                      final riskColor = riskPercent >= 1.0 ? Colors.red : (riskPercent > 0.7 ? Colors.redAccent : (riskPercent > 0.4 ? Colors.orangeAccent : Colors.greenAccent));

                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 20),
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: isDark ? AppColors.backgroundDarkSurface.withValues(alpha: 0.5) : Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(color: riskPercent > 0.9 ? Colors.red.withValues(alpha: 0.3) : (isDark ? AppColors.border : AppColors.borderLight)),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(m['materiaNombre'] ?? 'Módulo', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
                                                      Text('${m['materiaCodigo'] ?? ""} • $presentes/$totalClases asistidas', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text('${(riskPercent * 100).toInt()}%', style: TextStyle(color: riskColor, fontWeight: FontWeight.w900, fontSize: 24)),
                                                    Builder(builder: (context) => Text(AppLocalizations.of(context).fichaRiesgo, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: LinearProgressIndicator(
                                                      value: riskPercent.clamp(0.0, 1.0),
                                                      minHeight: 14,
                                                      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
                                                      valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Builder(
                                              builder: (context) {
                                                final l10n = AppLocalizations.of(context);
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        l10n.fichaFaltasDetalle(totalFaltas.toStringAsFixed(1), maxFaltas),
                                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Flexible(
                                                      child: Text(
                                                        riskPercent >= 1.0 ? l10n.fichaLimiteExcedido : l10n.fichaAsistencias(presentes, totalClases),
                                                        style: TextStyle(color: riskColor.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.bold),
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.end,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    })),
                              ],
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Horario Button
                          OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (dialogCtx) => Dialog(
                                  backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  child: Container(
                                    width: (MediaQuery.of(dialogCtx).size.width - 48).clamp(300.0, 1000.0),
                                    height: (MediaQuery.of(dialogCtx).size.height - 96).clamp(400.0, 800.0),
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(child: Text(l10n.fichaHorarioDe(alumno.nombre), style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                                            IconButton(icon: Icon(Icons.close, color: textColor), onPressed: () => Navigator.pop(dialogCtx)),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Expanded(child: HorarioScreen(isStudent: true, studentId: studentId, hideHeader: true)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.calendar_today_outlined),
                            label: Text(l10n.fichaVerHorario),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 16),

                          if (ref.watch(permissionsMatrixProvider).maybeWhen(
                              data: (m) {
                                final role = ref.read(usuarioActualProvider)?.esDocente == true ? 'Docente' : 'Alumno';
                                return (m[role] ?? []).contains('Crear Incidencias');
                              },
                              orElse: () => false))
                            ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => CrearIncidenciaDialog(
                                    userRole: ref.read(usuarioActualProvider)?.esDocente == true ? 'profesor' : 'alumno',
                                    preSelectedStudent: {
                                      'id': studentId.toString(),
                                      'name': '${alumno.nombre} ${alumno.apellidos}',
                                      'course': alumno.codigoGrupo,
                                    },
                                  ),
                                );
                              },
                              icon: const Icon(Icons.description_outlined),
                              label: Text(l10n.fichaCrearIncidencia),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _InfoCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? AppColors.backgroundDarkSurface.withValues(alpha: 0.3) : Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;
  const _StatBox({required this.label, required this.value, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: TextStyle(color: color, fontSize: 36, fontWeight: FontWeight.bold)),
                if (onTap != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.touch_app, color: color.withValues(alpha: 0.5), size: 20),
                ],
              ],
            ),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold)),
            if (onTap != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 2,
                width: 20,
                color: color.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}

void _showRecordsModal(BuildContext context, int studentId, String estadoFilter, String studentName, int? cursoId) {
  showDialog(
    context: context,
    builder: (context) => _AttendanceRecordsModal(studentId: studentId, estadoFilter: estadoFilter, studentName: studentName, cursoId: cursoId),
  );
}

class _AttendanceRecordsModal extends ConsumerWidget {
  final int studentId;
  final String estadoFilter;
  final String studentName;
  final int? cursoId;
  const _AttendanceRecordsModal({required this.studentId, required this.estadoFilter, required this.studentName, this.cursoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncRecords = ref.watch(studentAttendanceRecordsProvider(studentId));
    final usuario = ref.watch(usuarioActualProvider);

    // Tutor gate: admin, or teacher who tutors this student's course
    final puedeEditar = usuario != null && (
      usuario.esAdmin ||
      (usuario.esProfesor && cursoId != null && usuario.cursosTutorIds.contains(cursoId))
    );

    String title = l10n.fichaRegistroAsistencia;
    if (estadoFilter == 'AUSENTE') title = l10n.fichaFaltasDe(studentName);
    if (estadoFilter == 'RETRASO') title = l10n.fichaRetrasosDe(studentName);
    if (estadoFilter == 'JUSTIFICADO') title = l10n.fichaJustificadasDe(studentName);

    return Dialog(
      backgroundColor: AppColors.backgroundDarkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: (MediaQuery.of(context).size.width - 48).clamp(300.0, 600.0),
        height: (MediaQuery.of(context).size.height - 96).clamp(400.0, 600.0),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                ),
                IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(color: AppColors.border),
            Expanded(
              child: asyncRecords.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(l10n.fichaErrorHistorial(e), style: const TextStyle(color: Colors.red))),
                data: (records) {
                  final filtered = estadoFilter == 'TODO' ? records : records.where((r) => r['estado'] == estadoFilter).toList();
                  if (filtered.isEmpty) return Center(child: Text(l10n.fichaSinRegistros, style: const TextStyle(color: AppColors.textSecondary)));

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final r = filtered[index];
                      final asistenciaId = r['id'] as int?;
                      final fechaStr = r['fecha'] as String?;
                      final horaInStr = r['horaInicio'] as String?;
                      final horaFinStr = r['horaFin'] as String?;
                      final materia = r['materiaNombre'] as String? ?? 'Materia';
                      final profe = r['profesorNombre'] as String? ?? 'Profesor';
                      final estado = r['estado'] as String? ?? '';

                      String dateDisplay = l10n.fichaSinFecha;
                      if (fechaStr != null) {
                        try {
                          final parsed = DateTime.parse(fechaStr);
                          dateDisplay = DateFormat('dd/MM/yyyy').format(parsed);
                        } catch (_) {}
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDarkSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(materia, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(width: 8),
                                Text('$dateDisplay ($horaInStr - $horaFinStr)', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, color: AppColors.textSecondary, size: 16),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(l10n.fichaRegistradoPor(profe), style: const TextStyle(color: AppColors.textSecondary, fontSize: 14), overflow: TextOverflow.ellipsis),
                                ),
                                if (puedeEditar && asistenciaId != null) ...[
                                  const Spacer(),
                                  // Justify button — only if AUSENTE or RETRASO
                                  if (estado == 'AUSENTE' || estado == 'RETRASO')
                                    IconButton(
                                      icon: const Icon(Icons.check_circle_outline, color: Colors.blueAccent, size: 20),
                                      tooltip: l10n.justificar,
                                      onPressed: () async {
                                        try {
                                          await justificarAsistenciaRecord(ref, asistenciaId, studentId);
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                                          }
                                        }
                                      },
                                    ),
                                  // Delete button
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                    tooltip: l10n.eliminar,
                                    onPressed: () async {
                                      try {
                                        await eliminarAsistenciaRecord(ref, asistenciaId, studentId);
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

