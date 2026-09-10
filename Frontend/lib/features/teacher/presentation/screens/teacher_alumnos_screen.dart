import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_constants.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../admin/application/providers/alumnos_provider.dart';
import '../../../admin/domain/entities/alumno_model.dart';
import '../../../attendance/application/attendance_providers.dart';

class TeacherAlumnosScreen extends ConsumerStatefulWidget {
  const TeacherAlumnosScreen({super.key});

  @override
  ConsumerState<TeacherAlumnosScreen> createState() => _TeacherAlumnosScreenState();
}

class _TeacherAlumnosScreenState extends ConsumerState<TeacherAlumnosScreen> {
  final _searchCtrl = TextEditingController();
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              // Sticky Header
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDark.withValues(alpha: 0.8) : Colors.white,
                  border: const Border(bottom: BorderSide(color: Colors.transparent)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            l10n.alumnosTitulo,
                            style: TextStyle(color: textColor, fontSize: MediaQuery.of(context).size.width < 600 ? 22 : 36, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Search Bar
                    TextField(
                      controller: _searchCtrl,
                      style: TextStyle(color: textColor, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: l10n.buscarPlaceholder,
                        hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 24),
                        filled: true,
                        fillColor: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade100,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      ),
                      onChanged: (v) => setState(() { _currentPage = 1; }),
                    ),
                  ],
                ),
              ),

              // Alumnos List
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(alumnosListProvider);

                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    }
                    if (state.hasError) {
                      return Center(child: Text('${l10n.errorGenerico}: ${state.error}', style: const TextStyle(color: Colors.redAccent)));
                    }

                    final pagRes = state.value;
                    if (pagRes == null) return const SizedBox.shrink();
                    final filteredAlumnos = pagRes.content.where((a) {
                      final query = _searchCtrl.text.toLowerCase();
                      final fullName = '${a.nombre} ${a.apellidos}'.toLowerCase();
                      return query.isEmpty || fullName.contains(query);
                    }).toList();

                    if (filteredAlumnos.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.people_outline, color: AppColors.textSecondary, size: 64),
                            const SizedBox(height: 16),
                            Text(
                              l10n.sinAlumnos,
                              style: TextStyle(
                                color: isDark ? Colors.white.withValues(alpha: 0.5) : AppColors.textDark.withValues(alpha: 0.5),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Paginación
                    final int totalPages = (filteredAlumnos.length / _itemsPerPage).ceil();
                    final int startIndex = (_currentPage - 1) * _itemsPerPage;
                    final int endIndex = startIndex + _itemsPerPage;
                    final pagedAlumnos = filteredAlumnos.sublist(
                      startIndex,
                      endIndex > filteredAlumnos.length ? filteredAlumnos.length : endIndex,
                    );

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            itemCount: pagedAlumnos.length,
                            itemBuilder: (context, index) {
                              final alumno = pagedAlumnos[index];
                              return FadeInUp(
                                delay: Duration(milliseconds: 50 * index),
                                child: _StudentCard(alumno: alumno),
                              );
                            },
                          ),
                        ),
                        // Pagination Controls
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: OutlinedButton(
                                  onPressed: _currentPage > 1
                                      ? () => setState(() => _currentPage--)
                                      : null,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isDark ? Colors.white : AppColors.textDark,
                                    side: BorderSide(color: _currentPage > 1 ? AppColors.border : AppColors.border.withValues(alpha: 0.3)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(
                                    l10n.teacherAlumnosAnterior,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: Text(
                                  l10n.pagina(_currentPage, totalPages),
                                  style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: OutlinedButton(
                                  onPressed: _currentPage < totalPages
                                      ? () => setState(() => _currentPage++)
                                      : null,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isDark ? Colors.white : AppColors.textDark,
                                    side: BorderSide(color: _currentPage < totalPages ? AppColors.border : AppColors.border.withValues(alpha: 0.3)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(
                                    l10n.teacherAlumnosSiguiente,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentCard extends ConsumerWidget {
  final AlumnoModel alumno;

  const _StudentCard({required this.alumno});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(studentAttendanceSummaryProvider(alumno.id));

    return statsAsync.when(
      loading: () => _buildCard(context, attendance: '--', absences: '--', delays: '--'),
      error: (_, __) => _buildCard(context, attendance: 'Err', absences: '!', delays: '!'),
      data: (stats) => _buildCard(
        context,
        attendance: '${stats['asistenciaTotal']}%',
        absences: '${stats['faltasSinJustificar']}',
        delays: '${stats['retrasos']}'
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String attendance, required String absences, required String delays}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    return InkWell(
      onTap: () => context.pushNamed('teacher-student-detail', pathParameters: {'studentId': alumno.id.toString()}),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56, height: 56,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildAvatar(alumno.avatar),
            ),
            const SizedBox(width: 20),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${alumno.nombre} ${alumno.apellidos}',
                    style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alumno.codigoGrupo ?? AppLocalizations.of(context).teacherAlumnosSinGrupo,
                    style: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Stats
            LayoutBuilder(builder: (context, constraints) {
              final showInline = constraints.maxWidth > 350;
              if (!showInline) return const SizedBox.shrink();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatItem(label: AppLocalizations.of(context).teacherAlumnosAsistencia, value: attendance, color: Colors.greenAccent),
                  const SizedBox(width: 12),
                  _StatItem(label: AppLocalizations.of(context).teacherAlumnosFaltas, value: absences, color: Colors.redAccent),
                  const SizedBox(width: 12),
                  _StatItem(label: AppLocalizations.of(context).dashRetrasos, value: delays, color: const Color(0xFFFFA50F)),
                ],
              );
            }),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String avatar) {
    final bool isEmoji = avatar.length < 10 && !avatar.contains('.');
    if (isEmoji) {
      return Center(child: Text(avatar, style: const TextStyle(fontSize: 28)));
    }
    return Image.network(
      '${ApiConstants.uploadsBaseUrl}$avatar',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 32),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ],
    );
  }
}



