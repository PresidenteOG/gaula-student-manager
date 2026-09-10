import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/gaula_toast.dart';
import '../../application/providers/festivos_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminHorarioScreen extends ConsumerStatefulWidget {
  const AdminHorarioScreen({super.key});

  @override
  ConsumerState<AdminHorarioScreen> createState() => _AdminHorarioScreenState();
}

class _AdminHorarioScreenState extends ConsumerState<AdminHorarioScreen> {
  DateTime _diaSeleccionado = DateTime.now();
  DateTime _mesFocused = DateTime.now();

  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Premium
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.adminHorarioTitulo,
                              style: TextStyle(
                                  color: isDark ? Colors.white : AppColors.textDark,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1)),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: _AddEventButton(
                                onTap: () => _showAddDialog(_diaSeleccionado)),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.adminHorarioTituloDesktop,
                                  style: TextStyle(
                                      color: isDark ? Colors.white : AppColors.textDark,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1.5)),
                              Text(l10n.adminHorarioSubtitulo,
                                  style: TextStyle(
                                      color: AppColors.textSecondary, fontSize: 16)),
                            ],
                          ),
                          _AddEventButton(
                              onTap: () => _showAddDialog(_diaSeleccionado)),
                        ],
                      ),
                SizedBox(height: isMobile ? 24 : 40),

                isMobile
                    ? Column(
                        children: [
                          FadeInDown(
                            child: _CalendarPanel(
                              diaSeleccionado: _diaSeleccionado,
                              mesFocused: _mesFocused,
                              eventLoader: _getEventsForDay,
                              onDaySelected: (selected, focused) => setState(() {
                                _diaSeleccionado = selected;
                                _mesFocused = focused;
                              }),
                            ),
                          ),
                          const SizedBox(height: 24),
                          FadeInUp(
                            child: _DayEventsPanel(
                              fecha: _diaSeleccionado,
                              eventos: _getEventsForDay(_diaSeleccionado),
                              onDelete: _removeEvent,
                              isMobile: true,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Altura natural = 70px por fila de calendario (6 filas) + header + padding
                          const double panelH = 620.0;
                          return SizedBox(
                            height: panelH,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: FadeInLeft(
                                    child: _CalendarPanel(
                                      diaSeleccionado: _diaSeleccionado,
                                      mesFocused: _mesFocused,
                                      eventLoader: _getEventsForDay,
                                      onDaySelected: (selected, focused) =>
                                          setState(() {
                                        _diaSeleccionado = selected;
                                        _mesFocused = focused;
                                      }),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Expanded(
                                  flex: 2,
                                  child: FadeInRight(
                                    child: _DayEventsPanel(
                                      fecha: _diaSeleccionado,
                                      eventos: _getEventsForDay(_diaSeleccionado),
                                      onDelete: _removeEvent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final ds = DateFormat('yyyy-MM-dd').format(day);
    return ref.read(festivosProvider).maybeWhen(
      data: (list) => list.where((e) => e.fecha == ds).toList(),
      orElse: () => [],
    );
  }

  Future<void> _removeEvent(int id) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(festivosProvider.notifier).deleteFestivo(id);
      if (!mounted) return;
      GaulaToast.show(context, title: l10n.adminHorarioEliminadoTitulo, message: l10n.adminHorarioEliminadoMensaje, type: GaulaToastType.success);
    } catch (e) {
      if (!mounted) return;
      GaulaToast.show(context, title: l10n.adminHorarioErrorTitulo, message: e.toString(), type: GaulaToastType.error);
    }
  }

  void _showAddDialog(DateTime date) {
    bool added = false;
    showDialog(
      context: context,
      builder: (context) => _AddEventDialog(
        initialDate: date,
        onSave: (titulo, fecha) async {
          if (!added) {
            added = true;
            await ref.read(festivosProvider.notifier).addFestivo(titulo: titulo, fecha: fecha);
          }
          if (!context.mounted) return;
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _CalendarPanel extends StatelessWidget {
  final DateTime diaSeleccionado;
  final DateTime mesFocused;
  final List<dynamic> Function(DateTime) eventLoader;
  final OnDaySelected onDaySelected;

  const _CalendarPanel({
    required this.diaSeleccionado,
    required this.mesFocused,
    required this.eventLoader,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final calLocale = AppLocalizations.of(context).localeName;
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
      ),
      child: TableCalendar(
        firstDay: DateTime(2024),
        lastDay: DateTime(2027),
        focusedDay: mesFocused,
        selectedDayPredicate: (d) => isSameDay(d, diaSeleccionado),
        eventLoader: eventLoader,
        onDaySelected: onDaySelected,
        locale: calLocale,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final ds = DateFormat('yyyy-MM-dd').format(day);
            bool isFestive = false;
            List<dynamic> events = eventLoader(day);

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
          defaultTextStyle: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w600),
          weekendTextStyle: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          selectedDecoration: const BoxDecoration(color: AppColors.primaryDark, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
          markerDecoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        rowHeight: isMobile ? 48 : 70,
      ),
    );
  }
}

class _DayEventsPanel extends StatelessWidget {
  final DateTime fecha;
  final List<dynamic> eventos;
  final Function(int) onDelete;
  final bool isMobile;

  const _DayEventsPanel(
      {required this.fecha,
      required this.eventos,
      required this.onDelete,
      this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Lista de eventos. En móvil el panel vive dentro de un SingleChildScrollView,
    // así que la lista usa shrinkWrap + sin scroll propio (delega al padre) y el
    // contenedor no fija altura: evita el recorte a 400px y el conflicto de gestos
    // con el TableCalendar. En desktop el panel está dentro de un Expanded de un
    // Row (altura acotada), por lo que la lista usa Expanded y scroll interno.
    final Widget listaEventos;
    if (eventos.isEmpty) {
      final vacio = Center(child: Text(l10n.adminHorarioSinEventos, style: TextStyle(color: AppColors.textSecondary)));
      listaEventos = isMobile
          ? Padding(padding: const EdgeInsets.symmetric(vertical: 24), child: vacio)
          : Expanded(child: vacio);
    } else {
      final lista = ListView.builder(
        shrinkWrap: isMobile,
        physics: isMobile ? const NeverScrollableScrollPhysics() : null,
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          final e = eventos[index];
          return _EventTile(evento: e, onDelete: () => onDelete(e.id));
        },
      );
      listaEventos = isMobile ? lista : Expanded(child: lista);
    }

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
      ),
      child: Column(
        mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormat('EEEE, d MMMM', l10n.localeName).format(fecha).toUpperCase(), style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(l10n.adminHorarioEventosDia, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          listaEventos,
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final dynamic evento;
  final VoidCallback onDelete;
  const _EventTile({required this.evento, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color c = AppColors.primary;
    if (evento.tipo == 'EXAMEN') c = Colors.redAccent;
    if (evento.tipo == 'FESTIVO') c = Colors.orangeAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 40, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(evento.titulo, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold)),
                Text(evento.tipo, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20)),
        ],
      ),
    );
  }
}

class _AddEventButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddEventButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add_rounded),
      label: Text(l10n.adminHorarioNuevoEvento),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _AddEventDialog extends StatefulWidget {
  final DateTime initialDate;
  final Function(String titulo, String fecha) onSave;
  const _AddEventDialog({required this.initialDate, required this.onSave});

  @override
  State<_AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<_AddEventDialog> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return AlertDialog(
      backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 40, vertical: 24),
      title: Text(l10n.adminHorarioProgramarEvento,
          style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold)),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _ctrl,
              style: TextStyle(color: isDark ? Colors.white : AppColors.textDark),
              decoration: InputDecoration(
                labelText: l10n.adminHorarioTituloEvento,
                labelStyle: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted),
                filled: true,
                fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.adminHorarioCancelar,
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () => widget.onSave(_ctrl.text, DateFormat('yyyy-MM-dd').format(widget.initialDate)),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: Text(l10n.adminHorarioGuardar),
        ),
      ],
    );
  }
}





