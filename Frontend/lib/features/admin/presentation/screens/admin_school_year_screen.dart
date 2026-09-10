import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../router/app_router.dart';
import '../../domain/entities/anio_escolar_model.dart';
import '../../application/providers/anio_escolar_provider.dart';
import '../../../auth/application/providers/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class AdminSchoolYearScreen extends ConsumerWidget {
  const AdminSchoolYearScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final listState = ref.watch(anioEscolarListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(isMobile ? 16 : 32, isMobile ? 16 : 32, isMobile ? 16 : 32, 0),
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: textColor, size: 24),
                                  onPressed: () =>
                                      context.go(AppRoutes.adminCursos),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.adminAnioTitulo,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _showDialog(context, ref, null, []),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.add_rounded, size: 20),
                                label: Text(l10n.adminAnioNuevo),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: textColor, size: 28),
                                  onPressed: () =>
                                      context.go(AppRoutes.adminCursos),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.adminAnioTitulo,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.adminAnioSubtitulo,
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColors.textSecondary
                                            : AppColors.textMuted,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _showDialog(context, ref, null, []),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              icon: const Icon(Icons.add_rounded),
                              label: Text(l10n.adminAnioNuevo),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // ── List ─────────────────────────────────────────────────────
              Expanded(
                child: listState.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            color: AppColors.textSecondary, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          l10n.adminAnioErrorCargar(e),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.6)
                                  : AppColors.textDark.withValues(alpha: 0.6),
                              fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: () =>
                              ref.invalidate(anioEscolarListProvider),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                          ),
                          icon: Icon(Icons.refresh, color: textColor),
                          label: Text(l10n.adminAnioReintentar,
                              style: TextStyle(color: textColor)),
                        ),
                      ],
                    ),
                  ),
                  data: (years) {
                    if (years.isEmpty) {
                      return _EmptyState(
                          onAdd: () => _showDialog(context, ref, null, years));
                    }

                    // Grouping years by name to remove duplicates
                    final Map<String, List<AnioEscolarModel>> groupedByName =
                        {};
                    for (final y in years) {
                      groupedByName.putIfAbsent(y.nombre, () => []).add(y);
                    }

                    final List<AnioEscolarModel> groupedYears = [];
                    groupedByName.forEach((name, list) {
                      final first = list.first;
                      bool anyActive = list.any((y) => y.activo);
                      int sumGrupos = 0;
                      int sumAlumnos = 0;

                      for (final y in list) {
                        sumGrupos += y.totalGrupos;
                        sumAlumnos += y.totalAlumnos;
                      }

                      groupedYears.add(first.copyWith(
                        activo: anyActive,
                        totalGrupos: sumGrupos,
                        totalAlumnos: sumAlumnos,
                      ));
                    });

                    // Sort: active first, then by name desc
                    groupedYears.sort((a, b) {
                      if (a.activo != b.activo) {
                        return a.activo ? -1 : 1;
                      }
                      return b.nombre.compareTo(a.nombre);
                    });

                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 32, 0, isMobile ? 16 : 32, 32),
                      itemCount: groupedYears.length,
                      itemBuilder: (context, i) => FadeInUp(
                        delay: Duration(milliseconds: 60 * i),
                        child: _YearCard(
                          year: groupedYears[i],
                          allInactive: !groupedYears.any((y) => y.activo),
                          onEdit: () =>
                              _showDialog(context, ref, groupedYears[i], years),
                          onToggleActive: () => _confirmToggleActive(
                              context, ref, groupedYears[i]),
                          onDelete: () =>
                              _confirmDelete(context, ref, groupedYears[i]),
                        ),
                      ),
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

  // ── Dialog: Create / Edit ─────────────────────────────────────────────────

  void _showDialog(BuildContext context, WidgetRef ref,
      AnioEscolarModel? existing, List<AnioEscolarModel> allYears) {
    showDialog(
      context: context,
      builder: (context) =>
          _YearFormDialog(ref: ref, existing: existing, allYears: allYears),
    );
  }

  // ── Confirm: Activate ─────────────────────────────────────────────────────

  void _confirmToggleActive(
      BuildContext context, WidgetRef ref, AnioEscolarModel year) {
    final l10n = AppLocalizations.of(context);
    if (year.activo) {
      showDialog(
        context: context,
        builder: (_) => _ConfirmDialog(
          title: l10n.adminAnioDesactivarTitulo,
          message: l10n.adminAnioDesactivarMensaje(year.nombre),
          confirmLabel: l10n.adminAnioDesactivar,
          confirmColor: AppColors.primary,
          onConfirm: () async {
            try {
              await ref
                  .read(anioEscolarCrudProvider.notifier)
                  .desactivar(year.id);
              if (context.mounted) {
                _showSnack(context, '✅ ${l10n.adminAnioSnackDesactivado}', true);
              }
            } catch (e) {
              final msg = _parseError(e, l10n);
              if (context.mounted) _showSnack(context, '❌ $msg', false);
            }
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => _ConfirmDialog(
          title: l10n.adminAnioActivarTitulo,
          message: l10n.adminAnioActivarMensaje(year.nombre),
          confirmLabel: l10n.adminAnioActivar,
          confirmColor: AppColors.primary,
          onConfirm: () async {
            try {
              await ref.read(anioEscolarCrudProvider.notifier).activar(year.id);
              if (context.mounted) _showSnack(context, '✅ ${l10n.adminAnioSnackActivado}', true);
            } catch (e) {
              final msg = _parseError(e, l10n);
              if (context.mounted) _showSnack(context, '❌ $msg', false);
            }
          },
        ),
      );
    }
  }

  // ── Confirm: Delete ───────────────────────────────────────────────────────

  void _confirmDelete(
      BuildContext context, WidgetRef ref, AnioEscolarModel year) {
    final l10n = AppLocalizations.of(context);
    if (year.activo) {
      _showSnack(context, '⚠️ ${l10n.adminAnioSnackNoEliminarActivo}', false);
      return;
    }
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: l10n.adminAnioEliminarTitulo,
        message: l10n.adminAnioEliminarMensaje(year.nombre),
        confirmLabel: l10n.adminAnioEliminar,
        confirmColor: Colors.redAccent,
        onConfirm: () async {
          try {
            await ref.read(anioEscolarCrudProvider.notifier).eliminar(year.id);
            if (context.mounted) _showSnack(context, '✅ ${l10n.adminAnioSnackEliminado}', true);
          } catch (e) {
            final msg = _parseError(e, l10n);
            if (context.mounted) _showSnack(context, '❌ $msg', false);
          }
        },
      ),
    );
  }

  void _showSnack(BuildContext context, String msg, bool ok) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: ok ? AppColors.primary : Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  String _parseError(dynamic e, AppLocalizations l10n) {
    if (e is DioException) {
      if (e.response?.data is Map) {
        return e.response?.data['mensaje'] ??
            e.response?.data['error'] ??
            e.message;
      }
      return e.message ?? l10n.adminAnioErrorConexion;
    }
    return e.toString();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Year Card
// ─────────────────────────────────────────────────────────────────────────────

class _YearCard extends StatelessWidget {
  const _YearCard({
    required this.year,
    required this.allInactive,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
  });

  final AnioEscolarModel year;
  final bool allInactive;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final activeColor = year.activo
        ? AppColors.primary
        : (isDark ? AppColors.border : AppColors.borderLight);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: year.activo ? AppColors.primary : activeColor,
            width: year.activo ? 2 : 1),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
              ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: year.activo
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.backgroundDarkSurface
                                : AppColors.backgroundLightSurface),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: year.activo ? Colors.white : AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            year.nombre,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (year.activo)
                            Text(
                              l10n.adminAnioActivo,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.date_range, color: AppColors.textSecondary, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${_fmt(year.fechaInicio, AppLocalizations.of(context).localeName)} - ${_fmt(year.fechaFin, AppLocalizations.of(context).localeName)}',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.class_rounded,
                            color: AppColors.primary, size: 14),
                        const SizedBox(width: 4),
                        Text('${year.totalGrupos}',
                            style: TextStyle(
                                color: textColor.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        const Icon(Icons.people_rounded,
                            color: Colors.greenAccent, size: 14),
                        const SizedBox(width: 4),
                        Text('${year.totalAlumnos}',
                            style: TextStyle(
                                color: textColor.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Consumer(builder: (context, ref, child) {
                      final esAdmin =
                          ref.watch(usuarioActualProvider)?.esAdmin ?? false;
                      if (!esAdmin) return const SizedBox.shrink();
                      return Row(
                        children: [
                          _ActionButton(
                            icon: year.activo
                                ? Icons.power_settings_new_rounded
                                : Icons.play_arrow_rounded,
                            tooltip: year.activo ? l10n.adminAnioTooltipDesactivar : l10n.adminAnioTooltipActivar,
                            color: year.activo ? Colors.greenAccent : Colors.grey,
                            onTap: onToggleActive,
                          ),
                          const SizedBox(width: 8),
                          _ActionButton(
                            icon: Icons.edit_rounded,
                            tooltip: l10n.adminAnioTooltipEditar,
                            color: AppColors.primary,
                            onTap: onEdit,
                          ),
                          const SizedBox(width: 8),
                          _ActionButton(
                            icon: Icons.delete_outline_rounded,
                            tooltip: l10n.adminAnioTooltipEliminar,
                            color: Colors.redAccent,
                            onTap: (year.activo || year.totalAlumnos > 0)
                                ? null
                                : onDelete,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                // Icon Box
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: year.activo
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.backgroundDarkSurface
                            : AppColors.backgroundLightSurface),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: year.activo ? Colors.white : AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 24),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            year.nombre,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (year.activo) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                l10n.adminAnioActivo,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.date_range,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.textMuted,
                              size: 14),
                          const SizedBox(width: 6),
                          Text(
                            '${_fmt(year.fechaInicio, AppLocalizations.of(context).localeName)}  →  ${_fmt(year.fechaFin, AppLocalizations.of(context).localeName)}',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Icon(Icons.class_rounded,
                              color: AppColors.primary, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            l10n.adminAnioCursos(year.totalGrupos),
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Icon(Icons.people_rounded,
                              color: Colors.greenAccent, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            l10n.adminAnioMiembros(year.totalAlumnos),
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (year.descripcion != null &&
                          year.descripcion!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          year.descripcion!,
                          style: TextStyle(
                              color: textColor.withValues(alpha: 0.4),
                              fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Actions
                Consumer(builder: (context, ref, child) {
                  final esAdmin =
                      ref.watch(usuarioActualProvider)?.esAdmin ?? false;
                  if (!esAdmin) return const SizedBox.shrink();
                  return Row(
                    children: [
                      if (year.activo)
                        _ActionButton(
                          icon: Icons.power_settings_new_rounded,
                          tooltip: l10n.adminAnioTooltipDesactivar,
                          color: Colors.greenAccent,
                          onTap: onToggleActive,
                        ),
                      if (!year.activo && allInactive)
                        _ActionButton(
                          icon: Icons.power_settings_new_rounded,
                          tooltip: l10n.adminAnioTooltipActivar,
                          color: Colors.grey,
                          onTap: onToggleActive,
                        ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        icon: Icons.edit_rounded,
                        tooltip: l10n.adminAnioTooltipEditar,
                        color: AppColors.primary,
                        onTap: onEdit,
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        icon: Icons.delete_outline_rounded,
                        tooltip: year.activo
                            ? l10n.adminAnioTooltipNoEliminarActivo
                            : (year.totalAlumnos > 0
                                ? l10n.adminAnioTooltipNoEliminarAlumnos
                                : l10n.adminAnioTooltipEliminar),
                        color: (year.activo || year.totalAlumnos > 0)
                            ? Colors.grey
                            : Colors.redAccent,
                        onTap: (year.activo || year.totalAlumnos > 0)
                            ? null
                            : onDelete,
                      ),
                    ],
                  );
                }),
              ],
            ),
    );
  }

  String _fmt(String iso, [String locale = 'es_ES']) {
    try {
      final d = DateTime.parse(iso);
      return DateFormat('dd MMM yyyy', locale).format(d);
    } catch (_) {
      return iso;
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Icon(icon, color: onTap == null ? Colors.grey : color, size: 20),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Create / Edit Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _YearFormDialog extends StatefulWidget {
  const _YearFormDialog(
      {required this.ref, this.existing, required this.allYears});
  final WidgetRef ref;
  final AnioEscolarModel? existing;
  final List<AnioEscolarModel> allYears;

  @override
  State<_YearFormDialog> createState() => _YearFormDialogState();
}

class _YearFormDialogState extends State<_YearFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _descripcion;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nombre = TextEditingController(text: e?.nombre ?? '');
    _descripcion = TextEditingController(text: e?.descripcion ?? '');
    if (e != null) {
      _fechaInicio = DateTime.tryParse(e.fechaInicio);
      _fechaFin = DateTime.tryParse(e.fechaFin);
    }
  }

  @override
  void dispose() {
    _nombre.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initial = isStart
        ? (_fechaInicio ?? DateTime.now())
        : (_fechaFin ?? DateTime.now().add(const Duration(days: 30)));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (ctx, child) => Theme(
        data: isDark
            ? ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(primary: AppColors.primary),
              )
            : ThemeData.light().copyWith(
                colorScheme:
                    const ColorScheme.light(primary: AppColors.primary),
              ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    final nombreVal = _nombre.text.trim();

    // Duplicate check
    if (!_isEditing) {
      final alreadyExists = widget.allYears
          .any((y) => y.nombre.toLowerCase() == nombreVal.toLowerCase());
      if (alreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('❌ ${l10n.adminAnioDuplicado(nombreVal)}'),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
    }

    if (_fechaInicio == null || _fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.adminAnioSeleccionarFechas)));
      return;
    }

    setState(() => _saving = true);

    final data = {
      'denominacion': _nombre.text.trim(),
      'nombre': _nombre.text.trim(),
      'fechaInicio': DateFormat('yyyy-MM-dd').format(_fechaInicio!),
      'fechaFin': DateFormat('yyyy-MM-dd').format(_fechaFin!),
      'descripcion': _descripcion.text.trim(),
      'activo': true,
    };

    bool ok;
    final notifier = widget.ref.read(anioEscolarCrudProvider.notifier);
    if (_isEditing) {
      ok = await notifier.actualizar(widget.existing!.id, data);
    } else {
      ok = await notifier.crear(data);
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? '✅ ${l10n.adminAnioSnackGuardado}'
            : '❌ ${l10n.adminAnioSnackErrorGuardar}'),
        backgroundColor: ok ? AppColors.primary : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fmt = DateFormat('dd/MM/yyyy', AppLocalizations.of(context).localeName);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Dialog(
      backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 40, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  _isEditing ? l10n.adminAnioDialogEditar : l10n.adminAnioDialogNuevo,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),

                // Nombre
                _FormLabel(l10n.adminAnioNombrePeriodo),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nombre,
                  style: TextStyle(color: textColor),
                  decoration: _inputDec(l10n.adminAnioNombreHint),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.adminAnioNombreObligatorio
                      : null,
                ),
                const SizedBox(height: 20),

                // Dates
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FormLabel(l10n.adminAnioFechaInicio),
                          const SizedBox(height: 8),
                          _DateTile(
                            label: _fechaInicio != null
                                ? fmt.format(_fechaInicio!)
                                : l10n.adminAnioSeleccionar,
                            onTap: () => _pickDate(true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FormLabel(l10n.adminAnioFechaFin),
                          const SizedBox(height: 8),
                          _DateTile(
                            label: _fechaFin != null
                                ? fmt.format(_fechaFin!)
                                : l10n.adminAnioSeleccionar,
                            onTap: () => _pickDate(false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Descripción
                _FormLabel(l10n.adminAnioDescripcion),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descripcion,
                  style: TextStyle(color: textColor),
                  decoration: _inputDec(l10n.adminAnioDescripcionHint),
                  maxLines: 2,
                ),
                const SizedBox(height: 32),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _saving ? null : () => Navigator.of(context).pop(),
                      child: Text(l10n.adminAnioCancelar,
                          style: const TextStyle(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(_isEditing ? l10n.adminAnioGuardarCambios : l10n.adminAnioCrearAnio),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDec(String hint) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: (isDark ? Colors.white : AppColors.textDark)
              .withValues(alpha: 0.3)),
      filled: true,
      fillColor: isDark
          ? AppColors.backgroundDarkSurface
          : AppColors.backgroundLightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Confirm Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _ConfirmDialog extends StatefulWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.confirmColor,
    required this.onConfirm,
  });
  final String title;
  final String message;
  final String confirmLabel;
  final Color confirmColor;
  final Future<void> Function() onConfirm;

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Dialog(
      backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 40, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(widget.message,
                  style: TextStyle(
                      color: textColor.withValues(alpha: 0.65), height: 1.5)),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _loading ? null : () => Navigator.of(context).pop(),
                    child: Text(l10n.adminAnioCancelar,
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() => _loading = true);
                            await widget.onConfirm();
                            if (context.mounted) Navigator.of(context).pop();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.confirmColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text(widget.confirmLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small helpers
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined,
              color: textColor.withValues(alpha: 0.2), size: 80),
          const SizedBox(height: 20),
          Text(
            l10n.adminAnioVacio,
            style: TextStyle(
                color: textColor.withValues(alpha: 0.5), fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add),
            label: Text(l10n.adminAnioCrearPrimero),
          ),
        ],
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: TextStyle(
          color: isDark ? AppColors.textSecondary : AppColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.backgroundDarkSurface
              : AppColors.backgroundLightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isDark ? AppColors.border : AppColors.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: label == l10n.adminAnioSeleccionar
                      ? textColor.withValues(alpha: 0.3)
                      : textColor,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.calendar_today_rounded,
                color: AppColors.primary, size: 16),
          ],
        ),
      ),
    );
  }
}





