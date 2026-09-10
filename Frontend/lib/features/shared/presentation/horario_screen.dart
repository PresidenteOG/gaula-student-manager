import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../admin/application/providers/festivos_provider.dart';
import '../../admin/domain/entities/evento_model.dart';
import '../models/horario_model.dart';
import '../providers/horario_provider.dart';

class HorarioScreen extends ConsumerStatefulWidget {
  final bool isStudent;
  final int? studentId;
  final int? cursoId; // optional to filter events
  final bool hideHeader; // to hide header in modals

  const HorarioScreen({
    super.key,
    this.isStudent = false,
    this.studentId,
    this.cursoId,
    this.hideHeader = false,
  });

  @override
  ConsumerState<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends ConsumerState<HorarioScreen> {
  DateTime _diaSeleccionado = DateTime.now();
  DateTime _mesFocused = DateTime.now();

  final _descCtrl = TextEditingController();

  List<EventoModel> _eventsForDay(DateTime date) {
    final ds = DateFormat('yyyy-MM-dd').format(date);
    return ref.read(festivosProvider).maybeWhen(
      data: (list) => list.where((e) => e.fecha == ds).toList(),
      orElse: () => [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.hideHeader) ...[
                  FadeInDown(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.studentId != null
                              ? l10n.horarioAlumno
                              : (widget.isStudent ? l10n.horarioMio : l10n.horarioProfesor),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.studentId != null
                              ? l10n.horarioAlumnoSubtitulo
                              : (widget.isStudent ? l10n.horarioAlumnoSubtituloPropio : l10n.horarioProfesorSubtitulo),
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                FadeInUp(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const double minTableWidth = 680.0;
                      final bool needsHScroll = constraints.maxWidth < minTableWidth;
                      return needsHScroll
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: minTableWidth,
                                child: _buildHorarioTable(l10n, isDark),
                              ),
                            )
                          : _buildHorarioTable(l10n, isDark);
                    },
                  ),
                ),
                const SizedBox(height: 48),

                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bool wide = constraints.maxWidth > 680;
                      if (wide) {
                        return SizedBox(
                          height: 560,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildCalendarCard(isDark)),
                              const SizedBox(width: 24),
                              Expanded(flex: 2, child: _buildDayEventsPanel(l10n, isDark)),
                            ],
                          ),
                        );
                      }
                      return Column(
                        children: [
                          _buildCalendarCard(isDark),
                          const SizedBox(height: 16),
                          _buildDayEventsPanel(l10n, isDark),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorarioTable(AppLocalizations l10n, bool isDark) {
    final headers = [l10n.horarioFecha, l10n.diaLunes, l10n.diaMartes, l10n.diaMiercoles, l10n.diaJueves, l10n.diaViernes];

    final asyncHorario = widget.studentId != null
        ? ref.watch(studentHorarioProvider(widget.studentId!))
        : (widget.isStudent ? ref.watch(horarioAlumnoProvider) : ref.watch(horarioProfesorProvider));

    return asyncHorario.when(
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(l10n.horarioErrorCargar(e), style: const TextStyle(color: Colors.red)),
        ),
      ),
      data: (clases) {
        if (clases.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(l10n.horarioSinClases, style: const TextStyle(color: AppColors.textSecondary)),
            ),
          );
        }

        final rows = _generateDynamicRows(clases);

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDarkCard : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade100,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: headers.map((h) => Expanded(
                    flex: h == l10n.horarioFecha ? 2 : 3,
                    child: Text(h, textAlign: TextAlign.center, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
                  )).toList(),
                ),
              ),
              const Divider(height: 1, color: AppColors.border),

              ...rows.map((row) {
                final isBreak = row['isBreak'] == true;
                if (isBreak) {
                  return Container(
                    color: Colors.black.withValues(alpha: 0.2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(row['time'] as String, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                        ),
                        Expanded(
                          flex: 15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.coffee, color: AppColors.textSecondary, size: 18),
                              const SizedBox(width: 8),
                              Text(l10n.horarioDescanso, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final timeStr = row['time'] as String;
                final data = row['data'] as List<String>;
                final colors = row['colors'] as List<Color>;

                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(timeStr, textAlign: TextAlign.center, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 13)),
                            ),
                          ),
                          const VerticalDivider(width: 1, color: AppColors.border),

                          ...List.generate(5, (i) {
                            final text = data[i];
                            final color = colors[i];
                            return Expanded(
                              flex: 3,
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(left: BorderSide(color: AppColors.border, width: 0.5)),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: text.isEmpty
                                    ? const SizedBox.shrink()
                                    : Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: color.withValues(alpha: 0.5)),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.room, color: AppColors.textSecondary, size: 12),
                                                const SizedBox(width: 4),
                                                Text(l10n.horarioAulaDefault, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendarCard(bool isDark) {
    final calTextColor = isDark ? Colors.white : AppColors.textDark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      padding: const EdgeInsets.all(16),
      child: TableCalendar(
        firstDay: DateTime(2025),
        lastDay: DateTime(2027),
        focusedDay: _mesFocused,
        selectedDayPredicate: (d) => isSameDay(d, _diaSeleccionado),
        eventLoader: _eventsForDay,
        onDaySelected: (selected, focused) {
          setState(() {
            _diaSeleccionado = selected;
            _mesFocused = focused;
          });
        },
        locale: AppLocalizations.of(context).localeName,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final ds = DateFormat('yyyy-MM-dd').format(day);
            bool isFestive = false;
            List<EventoModel> events = _eventsForDay(day);

            if (!isFestive) {
              isFestive = events.any((e) => e.fecha == ds && e.tipo == 'FESTIVO');
            }

            if (isFestive) {
              return Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              );
            }
            return null;
          },
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: TextStyle(color: calTextColor, fontWeight: FontWeight.bold),
          weekendTextStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          selectedDecoration: BoxDecoration(color: AppColors.primaryDark, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
          markerDecoration: BoxDecoration(color: AppColors.warning, shape: BoxShape.circle),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(color: calTextColor, fontSize: 18, fontWeight: FontWeight.bold),
          leftChevronIcon: Icon(Icons.chevron_left, color: calTextColor),
          rightChevronIcon: Icon(Icons.chevron_right, color: calTextColor),
        ),
      ),
    );
  }

  Widget _buildDayEventsPanel(AppLocalizations l10n, bool isDark) {
    final dayEvents = _eventsForDay(_diaSeleccionado);
    final textColor = isDark ? Colors.white : AppColors.textDark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  l10n.horarioEventosDia(DateFormat('dd MMM').format(_diaSeleccionado)),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (dayEvents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text(l10n.horarioSinEventos, style: const TextStyle(color: AppColors.textSecondary))),
            )
          else
            ...dayEvents.map((e) {
              Color c = AppColors.primary;
              if (e.tipo == 'EXAMEN') {
                c = Colors.redAccent;
              } else if (e.tipo == 'EVENTO') {
                c = Colors.amber;
              } else if (e.tipo == 'FESTIVO') {
                c = Colors.red;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.descripcion, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                          Text(e.tipo, style: TextStyle(color: c.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _generateDynamicRows(List<HorarioSesionModel> clases) {
    if (clases.isEmpty) return [];

    final Map<String, List<HorarioSesionModel>> grouped = {};
    for (var c in clases) {
      final key = '${c.horaInicio} - ${c.horaFin}';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(c);
    }

    final sortedKeys = grouped.keys.toList()..sort();
    final List<Map<String, dynamic>> result = [];
    final List<String> weekDays = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'];

    for (var timeRange in sortedKeys) {
      final slotSesiones = grouped[timeRange]!;
      final rowData = List<String>.filled(5, '');
      final rowColors = List<Color>.filled(5, Colors.transparent);

      for (var s in slotSesiones) {
        final dayIndex = weekDays.indexOf(s.diaSemana);
        if (dayIndex != -1) {
          rowData[dayIndex] = s.materiaNombre ?? 'Materia';
          rowColors[dayIndex] = _parseHexColor(s.colorCiclo) ?? AppColors.primary.withValues(alpha: 0.2);
        }
      }

      result.add({
        'time': timeRange,
        'data': rowData,
        'colors': rowColors,
      });
    }

    return result;
  }

  Color? _parseHexColor(String? hex) {
    if (hex == null || !hex.startsWith('#')) return null;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }
}



