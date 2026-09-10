import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:dio/dio.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/application/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';

// ── Providers ──────────────────────────────────────────────────────────────

final alumnoAsistenciaResumenProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, alumnoId) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final res = await dio.get(
      ApiConstants.asistenciaResumenAlumno(alumnoId),
      options: Options(sendTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)),
    );
    return res.data as Map<String, dynamic>;
  } on DioException catch (e) {
    if (e.response?.statusCode == 500 || e.response?.statusCode == 404) {
      return {
        'alumnoId': alumnoId,
        'porcentajeAsistencia': 100.0,
        'totalClases': 0,
        'presentes': 0,
        'ausentes': 0,
        'retrasos': 0,
        'justificados': 0,
        'horasFaltadas': 0.0,
        'modulos': <dynamic>[],
        '_error': 'HTTP ${e.response?.statusCode}',
      };
    }
    rethrow;
  }
});

final alumnoAsistenciaHistorialProvider =
    FutureProvider.autoDispose.family<List<dynamic>, int>((ref, alumnoId) async {
  final dio = ref.watch(dioClientProvider);
  final res = await dio.get(ApiConstants.asistenciaAlumno(alumnoId.toString()));
  return res.data as List<dynamic>;
});

// ── Colors ─────────────────────────────────────────────────────────────────

const _kAusenteColor    = Color(0xFFEF4444);
const _kRetrasoColor    = Color(0xFFFBBF24);
const _kRetrasoColorText= Color.fromARGB(255, 208, 135, 0);
const _kJustColor       = Color(0xFF60A5FA);
const _kPresenteColor   = Color(0xFF22C55E);

// ── Screen ─────────────────────────────────────────────────────────────────

class StudentAsistenciaScreen extends ConsumerStatefulWidget {
  const StudentAsistenciaScreen({super.key});
  @override
  ConsumerState<StudentAsistenciaScreen> createState() => _State();
}

class _State extends ConsumerState<StudentAsistenciaScreen> {
  bool _showMaterias = true; // tab state

  // Registro filters
  String? _filtroFecha;
  String? _filtroMateria;
  String? _filtroTipo;

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context);
    final usuario  = ref.watch(usuarioActualProvider);
    final alumnoId = usuario?.id;
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final bg       = isDark ? AppColors.backgroundDarkCard : Colors.white;
    final txt      = isDark ? Colors.white : AppColors.textDark;
    final sub      = isDark ? AppColors.textSecondary : AppColors.textMuted;

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 32,
          vertical: isMobile ? 16 : 32,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(l10n.asistenciaTitulo,
                    style: TextStyle(
                      color: txt,
                      fontSize: isMobile ? 26 : 40,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: isMobile ? 16 : 32),

                if (alumnoId == null)
                  Center(child: Text(l10n.loading, style: TextStyle(color: sub)))
                else ...[
                  ref.watch(alumnoAsistenciaResumenProvider(alumnoId)).when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text(l10n.studentAsisError(e.toString()), style: const TextStyle(color: Colors.red)),
                    data: (resumen) {
                      final breakdown = List<Map<String, dynamic>>.from(
                          (resumen['modulos'] as List? ?? []).map((e) => Map<String, dynamic>.from(e)));
                      return ref.watch(alumnoAsistenciaHistorialProvider(alumnoId)).when(
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox(),
                        data: (historial) => Column(
                          children: [
                            // ── Legend + Tabs ──
                            _LegendTabBar(
                              showMaterias: _showMaterias,
                              onTab: (v) => setState(() => _showMaterias = v),
                              isDark: isDark, bg: bg, txt: txt, isMobile: isMobile,
                            ),
                            SizedBox(height: isMobile ? 12 : 20),

                            // ── Content ──
                            if (_showMaterias)
                              _MateriasTab(breakdown: breakdown, isDark: isDark, bg: bg, txt: txt, sub: sub, isMobile: isMobile)
                            else
                              _RegistroTab(
                                historial: historial,
                                isDark: isDark, bg: bg, txt: txt, sub: sub,
                                filtroFecha: _filtroFecha,
                                filtroMateria: _filtroMateria,
                                filtroTipo: _filtroTipo,
                                onFechaChange: (v) => setState(() => _filtroFecha = v),
                                onMateriaChange: (v) => setState(() => _filtroMateria = v),
                                onTipoChange: (v) => setState(() => _filtroTipo = v),
                                isMobile: isMobile,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Legend + Tab bar ───────────────────────────────────────────────────────

class _LegendTabBar extends StatelessWidget {
  final bool showMaterias;
  final ValueChanged<bool> onTab;
  final bool isDark;
  final bool isMobile;
  final Color bg, txt;
  const _LegendTabBar({required this.showMaterias, required this.onTab,
      required this.isDark, required this.bg, required this.txt, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabs = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TabBtn(label: l10n.asistenciaMaterias, active: showMaterias,  onTap: () => onTab(true)),
        const SizedBox(width: 8),
        _TabBtn(label: l10n.asistenciaRegistro, active: !showMaterias, onTap: () => onTab(false)),
      ],
    );
    final legend = Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _dot(_kAusenteColor,  l10n.asistenciaAusente,     txt),
        _dot(_kRetrasoColor,  l10n.asistenciaRetraso,     txt),
        _dot(_kJustColor,     l10n.asistenciaJustificado, txt),
        if (showMaterias)
          _dot(_kPresenteColor, l10n.asistenciaPresente,    txt),
      ],
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                legend,
                const SizedBox(height: 12),
                tabs,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [legend, tabs],
            ),
    );
  }

  Widget _dot(Color c, String label, Color txtColor) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 12, height: 12, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
    const SizedBox(width: 6),
    Text(label, style: TextStyle(color: txtColor, fontSize: 13)),
  ]);
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
      ),
      child: Text(label, style: TextStyle(
        color: active ? Colors.white : AppColors.textSecondary,
        fontWeight: FontWeight.bold, fontSize: 14,
      )),
    ),
  );
}

// ── Materias Tab ───────────────────────────────────────────────────────────

class _MateriasTab extends StatelessWidget {
  final List<Map<String, dynamic>> breakdown;
  final bool isDark;
  final bool isMobile;
  final Color bg, txt, sub;
  const _MateriasTab({required this.breakdown, required this.isDark,
      required this.bg, required this.txt, required this.sub, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (breakdown.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(48),
        child: Text(l10n.sinDatos,
            style: TextStyle(color: sub), textAlign: TextAlign.center),
      ));
    }
    return Column(children: breakdown.map((b) => _MateriaCard(
      data: b, isDark: isDark, bg: bg, txt: txt, sub: sub, isMobile: isMobile,
    )).toList());
  }
}

class _MateriaCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isDark;
  final bool isMobile;
  final Color bg, txt, sub;
  const _MateriaCard({required this.data, required this.isDark,
      required this.bg, required this.txt, required this.sub, this.isMobile = false});

  Color _parseColor(String? hex) {
    if (hex == null || !hex.startsWith('#')) return AppColors.primary;
    try { return Color(int.parse(hex.replaceFirst('#', '0xFF'))); } catch (_) { return AppColors.primary; }
  }

  @override
  Widget build(BuildContext context) {
    final l10n          = AppLocalizations.of(context);
    final nombre       = data['materiaNombre'] as String? ?? l10n.studentAsisDesconocido;
    final codigo       = data['materiaCodigo'] as String? ?? '??';
    final clasesReales = (data['totalClases']  as num?)?.toInt()  ?? 0;
    final presentes    = (data['presentes']    as num?)?.toInt()  ?? 0;
    final ausentes     = (data['ausentes']     as num?)?.toInt()  ?? 0;
    final retrasos     = (data['retrasos']     as num?)?.toInt()  ?? 0;
    final just         = (data['justificados'] as num?)?.toInt()  ?? 0;
    final maxFaltas    = (data['maxFaltas']    as num?)?.toInt()  ?? 0;
    final totalFaltas  = (data['totalFaltas']  as num?)?.toInt()  ?? 0;
    final horasTot     = (data['horasTotales'] as num?)?.toInt()  ?? clasesReales;
    final pct          = (data['porcentajeFaltas'] as num?)?.toDouble() ?? 0.0;
    final mColor       = _parseColor(data['materiaColor'] as String?);

    // Progress bar fractions
    final denom = horasTot > 0 ? horasTot.toDouble() : 1.0;
    final fAus  = ausentes  / denom;
    final fRet  = retrasos  / denom;
    final fJust = just      / denom;
    final fPres = presentes / denom;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Code badge — Colors.white text inside colored container = CORRECT
        Container(
          width: isMobile ? 56 : 72, height: isMobile ? 56 : 72,
          decoration: BoxDecoration(color: mColor, borderRadius: BorderRadius.circular(14)),
          alignment: Alignment.center,
          child: Text(codigo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        SizedBox(width: isMobile ? 12 : 20),

        // Content
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (isMobile) ...[
            Text(nombre,
                style: TextStyle(color: txt, fontWeight: FontWeight.bold, fontSize: 20),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [
              Flexible(child: Text(l10n.studentAsisFaltas(maxFaltas, totalFaltas),
                  style: TextStyle(color: txt, fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.clip)),
              const SizedBox(width: 8),
              Text('${pct.toStringAsFixed(2)}%', style: TextStyle(color: sub, fontSize: 12)),
              const Spacer(),
              Text(l10n.studentAsisClasesAbrev(clasesReales, horasTot), style: TextStyle(color: sub, fontSize: 11)),
            ]),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(nombre,
                    style: TextStyle(color: txt, fontWeight: FontWeight.bold, fontSize: 24)),
                const SizedBox(width: 12),
                Text(l10n.studentAsisFaltas(maxFaltas, totalFaltas),
                    style: TextStyle(color: txt, fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(width: 12),
                Text('${pct.toStringAsFixed(2)}%', style: TextStyle(color: sub, fontSize: 14)),
                const Spacer(),
                Text(l10n.studentAsisClases(clasesReales, horasTot), style: TextStyle(color: sub, fontSize: 13)),
              ],
            ),
          const SizedBox(height: 8),
          Text(l10n.studentAsisProgresoClases, style: TextStyle(color: sub, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          // Colored stacked progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container( // Contenedor base (fondo gris)
              height: 12,
              width: double.infinity,
              color: isDark ? Colors.white12 : Colors.grey.shade200,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;

                  return Row(
                    children: [
                      // Ausentes
                      Container(width: totalWidth * fAus, color: _kAusenteColor),
                      // Retrasos
                      Container(width: totalWidth * fRet, color: _kRetrasoColor),
                      // Justificados
                      Container(width: totalWidth * fJust, color: _kJustColor),
                      // Presentes
                      Container(width: totalWidth * fPres, color: _kPresenteColor),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 20, runSpacing: 6, children: [
            _Stat(_kAusenteColor,  '${l10n.asistenciaAusente}: $ausentes (${_pct(ausentes, horasTot)}%)'),
            _Stat(_kRetrasoColor,  '${l10n.asistenciaRetraso}: $retrasos (${_pct((retrasos.toDouble() / 2.0).floor(), horasTot)}%)'),
            _Stat(_kJustColor,     '${l10n.asistenciaJustificado}: $just (${_pct(just, horasTot)}%)'),
            _Stat(_kPresenteColor, '${l10n.asistenciaPresente}: $presentes (${_pct(presentes, horasTot)}%)'),
          ]),
        ])),
      ]),
    );
  }

  String _pct(int val, int total) =>
      total > 0 ? (val / total * 100).toStringAsFixed(2) : '0.00';
}

class _Stat extends StatelessWidget {
  final Color color;
  final String label;
  const _Stat(this.color, this.label);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    const SizedBox(width: 6),
    Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
  ]);
}

// ── Registro Tab ───────────────────────────────────────────────────────────

class _RegistroTab extends StatelessWidget {
  final List<dynamic> historial;
  final bool isDark;
  final bool isMobile;
  final Color bg, txt, sub;
  final String? filtroFecha, filtroMateria, filtroTipo;
  final ValueChanged<String?> onFechaChange, onMateriaChange, onTipoChange;

  const _RegistroTab({
    required this.historial, required this.isDark,
    required this.bg, required this.txt, required this.sub,
    this.filtroFecha, this.filtroMateria, this.filtroTipo,
    required this.onFechaChange, required this.onMateriaChange, required this.onTipoChange,
    this.isMobile = false,
  });

  List<dynamic> get _filtered {
    return historial.where((r) {
      final estado = (r['estado'] as String? ?? '').toUpperCase();
      final fecha  = r['fechaRegistro']?.toString() ?? '';

      if (filtroTipo != null && estado != filtroTipo!.toUpperCase()) return false;
      if (filtroMateria != null && filtroMateria!.isNotEmpty &&
          !(r['materiaNombre'] as String? ?? '').toLowerCase().contains(filtroMateria!.toLowerCase())) {
        return false;
      }
      if (filtroFecha != null && filtroFecha!.isNotEmpty &&
          !fecha.contains(filtroFecha!)) {
        return false;
      }
      // Only show non-present records
      return estado != 'PRESENTE';
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = _filtered;
    final materias = historial
        .map((r) => r['materiaNombre'] as String? ?? '')
        .toSet()
        .where((s) => s.isNotEmpty)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Filters — two-line on mobile, one-line on desktop
        if (isMobile) ...[
          Row(children: [
            Expanded(
              child: _FilterBox(
                hint: 'DD / MM / YYYY...',
                isDark: isDark,
                child: TextField(
                  style: TextStyle(color: txt, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Fecha...', border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    isDense: true, contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onFechaChange,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _FilterBox(
                hint: 'Materia',
                isDark: isDark,
                child: DropdownButton<String>(
                  value: filtroMateria,
                  hint: const Text('Materia',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  underline: const SizedBox(),
                  dropdownColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
                  style: TextStyle(color: txt, fontSize: 13),
                  isDense: true,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String>(value: null, child: Text('Todas')),
                    ...materias.map((m) => DropdownMenuItem(value: m, child: Text(m, overflow: TextOverflow.ellipsis))),
                  ],
                  onChanged: onMateriaChange,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _TipoChip(
                label: l10n.asistenciaAusente,
                active: filtroTipo == 'AUSENTE',
                color: _kAusenteColor,
                onTap: () => onTipoChange(filtroTipo == 'AUSENTE' ? null : 'AUSENTE'),
              ),
              _TipoChip(
                label: l10n.asistenciaRetraso,
                active: filtroTipo == 'RETRASO',
                color: _kRetrasoColor,
                onTap: () => onTipoChange(filtroTipo == 'RETRASO' ? null : 'RETRASO'),
              ),
              _TipoChip(
                label: l10n.asistenciaJustificado,
                active: filtroTipo == 'JUSTIFICADO',
                color: _kJustColor,
                onTap: () => onTipoChange(filtroTipo == 'JUSTIFICADO' ? null : 'JUSTIFICADO'),
              ),
            ],
          ),
        ] else
          Row(children: [
            const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: _FilterBox(
                hint: 'DD / MM / YYYY...',
                isDark: isDark,
                child: TextField(
                  style: TextStyle(color: txt, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'DD / MM / YYYY...', border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    isDense: true, contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onFechaChange,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: _FilterBox(
                hint: 'Seleccionar materia',
                isDark: isDark,
                child: DropdownButton<String>(
                  value: filtroMateria,
                  hint: const Text('Seleccionar materia',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  underline: const SizedBox(),
                  dropdownColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
                  style: TextStyle(color: txt, fontSize: 13),
                  isDense: true,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String>(value: null, child: Text('Todas')),
                    ...materias.map((m) => DropdownMenuItem(value: m, child: Text(m))),
                  ],
                  onChanged: onMateriaChange,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _TipoChip(
              label: l10n.asistenciaAusente,
              active: filtroTipo == 'AUSENTE',
              color: _kAusenteColor,
              onTap: () => onTipoChange(filtroTipo == 'AUSENTE' ? null : 'AUSENTE'),
            ),
            const SizedBox(width: 8),
            _TipoChip(
              label: l10n.asistenciaRetraso,
              active: filtroTipo == 'RETRASO',
              color: _kRetrasoColor,
              onTap: () => onTipoChange(filtroTipo == 'RETRASO' ? null : 'RETRASO'),
            ),
            const SizedBox(width: 8),
            _TipoChip(
              label: l10n.asistenciaJustificado,
              active: filtroTipo == 'JUSTIFICADO',
              color: _kJustColor,
              onTap: () => onTipoChange(filtroTipo == 'JUSTIFICADO' ? null : 'JUSTIFICADO'),
            ),
          ]),
        const SizedBox(height: 20),
        // Table header
        if (!isMobile) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(children: [
              _Hdr('Fecha',    flex: 2),
              _Hdr('Materia',  flex: 3),
              _Hdr('Profesor', flex: 2),
              _Hdr('Tipo',     flex: 1),
            ]),
          ),
          const Divider(color: AppColors.border),
        ],
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(child: Text(l10n.asistenciaSinFaltas, style: TextStyle(color: sub))),
          )
        else ...[
          // Limit to 100 items to avoid UI freeze in a Column
          ...rows.take(100).map((r) => _RegistroRow(data: r, isDark: isDark, txt: txt, sub: sub, isMobile: isMobile)),
          if (rows.length > 100)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Mostrando los últimos 100 registros de ${rows.length}.',
                  style: TextStyle(color: sub, fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
            ),
        ],
      ]),
    );
  }
}

class _FilterBox extends StatelessWidget {
  final String hint;
  final bool isDark;
  final Widget child;
  const _FilterBox({required this.hint, required this.isDark, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
    ),
    child: child,
  );
}

class _TipoChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;
  const _TipoChip({required this.label, required this.active, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active ? color : AppColors.border),
      ),
      child: Text(label, style: TextStyle(
        color: active ? color : AppColors.textSecondary,
        fontWeight: FontWeight.w600, fontSize: 13,
      )),
    ),
  );
}

class _Hdr extends StatelessWidget {
  final String text;
  final int flex;
  const _Hdr(this.text, {required this.flex});
  @override
  Widget build(BuildContext context) => Expanded(
    flex: flex,
    child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
  );
}

class _RegistroRow extends StatelessWidget {
  final dynamic data;
  final bool isDark;
  final bool isMobile;
  final Color txt, sub;
  const _RegistroRow({required this.data, required this.isDark, required this.txt, required this.sub, this.isMobile = false});

  Color _color(String e) {
    switch (e) {
      case 'AUSENTE':     return _kAusenteColor;
      case 'RETRASO':     return _kRetrasoColorText;
      case 'JUSTIFICADO': return _kJustColor;
      default:            return _kPresenteColor;
    }
  }

  String _label(String e, AppLocalizations l10n) {
    switch (e) {
      case 'AUSENTE':     return l10n.asistenciaAusente;
      case 'RETRASO':     return l10n.asistenciaRetraso;
      case 'JUSTIFICADO': return l10n.asistenciaJustificado;
      default:            return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context);
    final estado = (data['estado'] as String? ?? '').toUpperCase();
    final fechaStr = data['fechaRegistro']?.toString() ?? '';
    DateTime? fecha;
    try { fecha = DateTime.parse(fechaStr); } catch (_) {}
    final horaStr = data['horaInicio'] as String? ?? '';
    final color   = _color(estado);

    // Colors.white text inside colored badge container = CORRECT
    final tipoBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(_label(estado, l10n),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          textAlign: TextAlign.center),
    );

    final fechaWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(text: TextSpan(children: [
        TextSpan(text: fecha != null ? DateFormat('dd-MM-yyyy').format(fecha) : fechaStr.substring(0, fechaStr.length.clamp(0, 10)),
            style: TextStyle(color: txt, fontWeight: FontWeight.w400, fontSize: 14)),
        if (horaStr.isNotEmpty)
          TextSpan(text: ' $horaStr',
              style: TextStyle(color: sub, fontSize: 12)),
      ])),
    );

    final materiaText = '${data['materiaCodigo'] ?? ''} ${data['materiaNombre'] ?? ''}';
    final profesorText = data['profesorNombre'] as String? ?? '—';

    if (isMobile) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDarkSurface.withValues(alpha: 0.5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
          boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                fechaWidget,
                tipoBadge,
              ],
            ),
            const SizedBox(height: 12),
            Text(materiaText, style: TextStyle(color: txt, fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 4),
            Text(profesorText, style: TextStyle(color: sub, fontSize: 13)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Expanded(flex: 2, child: fechaWidget),
        Expanded(flex: 3, child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            materiaText,
            style: TextStyle(color: txt, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        )),
        Expanded(flex: 2, child: Text(
          profesorText,
          style: TextStyle(color: sub, fontSize: 13),
        )),
        Expanded(flex: 1, child: tipoBadge),
      ]),
    );
  }
}

