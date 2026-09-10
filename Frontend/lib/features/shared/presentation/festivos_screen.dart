import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../shared/models/festivo_model.dart';
import '../../shared/providers/festivos_provider.dart';

class FestivosScreen extends ConsumerStatefulWidget {
  const FestivosScreen({super.key});

  @override
  ConsumerState<FestivosScreen> createState() => _FestivosScreenState();
}

class _FestivosScreenState extends ConsumerState<FestivosScreen> {
  DateTime _diaSeleccionado = DateTime.now();
  DateTime _mesFocused = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final festivosAsync = ref.watch(festivosListProvider);
    final anio = ref.watch(festivosAnioProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const int anioMin = 2024;
    const int anioMax = 2027;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.calendarioTitulo,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: isDark ? Colors.white : AppColors.textDark,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -2,
                            ),
                          ),
                          Text(
                            l10n.calendarioSubtitulo,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.chevron_left, color: anio > anioMin ? AppColors.primary : AppColors.textSecondary),
                                onPressed: anio > anioMin ? () => ref.read(festivosAnioProvider.notifier).state = anio - 1 : null,
                              ),
                              Text(
                                '$anio',
                                style: TextStyle(
                                  color: isDark ? Colors.white : AppColors.textDark,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.chevron_right, color: anio < anioMax ? AppColors.primary : AppColors.textSecondary),
                                onPressed: anio < anioMax ? () => ref.read(festivosAnioProvider.notifier).state = anio + 1 : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _ConfigRegionButton(label: l10n.calendarioConfigurarRegion, onTap: _mostrarConfiguracionProvincia),
                  ],
                ),
              ),

              Expanded(
                child: festivosAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, _) => Center(child: Text(l10n.errorGenerico, style: const TextStyle(color: Colors.red))),
                  data: (festivos) => festivos.isEmpty
                      ? Center(
                          child: Text(
                            l10n.calendarioSinFestivos,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          ),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final esEstrecho = constraints.maxWidth < 900;
                            final calendario = FadeInLeft(
                              child: _CalendarioGlass(
                                festivos: festivos,
                                diaSeleccionado: _diaSeleccionado,
                                mesFocused: _mesFocused,
                                onDiaSelected: (d) {
                                  setState(() => _diaSeleccionado = d);
                                  _showDayDetail(d, festivos, l10n);
                                },
                                onPageChanged: (m) => setState(() => _mesFocused = m),
                              ),
                            );
                            final lista = FadeInRight(
                              child: _ListaProximos(festivos: festivos, l10n: l10n),
                            );

                            // Estrecho (móvil/tablet): apilar en vertical para evitar
                            // que calendario y lista queden comprimidos lado a lado.
                            if (esEstrecho) {
                              return SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    calendario,
                                    const SizedBox(height: 24),
                                    lista,
                                  ],
                                ),
                              );
                            }

                            // Ancho (desktop): lado a lado.
                            return SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 2, child: calendario),
                                  const SizedBox(width: 40),
                                  Expanded(flex: 1, child: lista),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showDayDetail(DateTime dia, List<FestivoModel> festivos, AppLocalizations l10n) {
    final matches = festivos.where((f) {
      try {
        return isSameDay(f.dateTime, dia);
      } catch (_) {
        return false;
      }
    }).toList();
    if (matches.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => _FestivoDetailDialog(festivos: matches, fecha: dia, l10n: l10n),
    );
  }

  Future<void> _mostrarConfiguracionProvincia() async {
    final provincias = await ref.read(provinciasListProvider.future);
    final actual = await ref.read(provinciaActualProvider.future);
    if (!mounted) return;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => _ProvinciaConfigDialog(
        provincias: provincias,
        actual: actual,
        isDark: isDark,
        l10n: l10n,
      ),
    );
  }
}

class _CalendarioGlass extends StatelessWidget {
  final List<FestivoModel> festivos;
  final DateTime diaSeleccionado;
  final DateTime mesFocused;
  final ValueChanged<DateTime> onDiaSelected;
  final ValueChanged<DateTime> onPageChanged;

  const _CalendarioGlass({
    required this.festivos,
    required this.diaSeleccionado,
    required this.mesFocused,
    required this.onDiaSelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 40, offset: const Offset(0, 20))],
      ),
      child: TableCalendar(
        firstDay: DateTime(2024),
        lastDay: DateTime(2027),
        focusedDay: mesFocused,
        selectedDayPredicate: (d) => isSameDay(d, diaSeleccionado),
        eventLoader: (d) => festivos.where((f) => isSameDay(f.dateTime, d)).toList(),
        onDaySelected: (selected, focused) => onDiaSelected(selected),
        onPageChanged: onPageChanged,
        locale: AppLocalizations.of(context).localeName,
        startingDayOfWeek: StartingDayOfWeek.monday,
        // Custom builder to visually distinguish national vs regional
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return const SizedBox.shrink();
            final festList = events.cast<FestivoModel>();
            final hasNacional = festList.any((f) => !f.esAutonomico);
            final hasAutonomico = festList.any((f) => f.esAutonomico);
            return Positioned(
              bottom: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasNacional)
                    Container(
                      width: 8, height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                    ),
                  if (hasAutonomico)
                    Container(
                      width: 8, height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: const BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
                    ),
                ],
              ),
            );
          },
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -1),
          leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary, size: 28),
          rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 28),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 16),
          weekendTextStyle: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
          selectedDecoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary),
          ),
          markerDecoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
          markersMaxCount: 2,
          markerSize: 8,
          outsideDaysVisible: false,
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
          weekendStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        rowHeight: 80,
      ),
    );
  }
}

class _ListaProximos extends StatelessWidget {
  final List<FestivoModel> festivos;
  final AppLocalizations l10n;
  const _ListaProximos({required this.festivos, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final proximos = (List<FestivoModel>.from(festivos)..sort((a, b) => a.dateTime.compareTo(b.dateTime)))
        .where((f) => f.dateTime.isAfter(DateTime.now().subtract(const Duration(days: 1))))
        .take(5)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.calendarioProximosDias,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 24),
        if (proximos.isEmpty)
          Text(l10n.calendarioSinFestivos, style: const TextStyle(color: AppColors.textSecondary))
        else
          ...proximos.map((f) => _FestivoSmallCard(f: f, l10n: l10n)),
      ],
    );
  }
}

class _FestivoSmallCard extends StatelessWidget {
  final FestivoModel f;
  final AppLocalizations l10n;
  const _FestivoSmallCard({required this.f, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipColor = f.esAutonomico ? Colors.orangeAccent : Colors.redAccent;
    final chipLabel = f.esAutonomico ? l10n.calendarioAutonomico : l10n.calendarioNacional;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: chipColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${f.dateTime.day}',
                style: TextStyle(color: chipColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.nombreMostrar,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        DateFormat('EEEE, d MMM', AppLocalizations.of(context).localeName).format(f.dateTime),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: chipColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        chipLabel,
                        style: TextStyle(color: chipColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FestivoDetailDialog extends StatelessWidget {
  final List<FestivoModel> festivos;
  final DateTime fecha;
  final AppLocalizations l10n;
  const _FestivoDetailDialog({required this.festivos, required this.fecha, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: (MediaQuery.of(context).size.width - 48).clamp(280.0, 400.0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 40,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('d MMMM yyyy', AppLocalizations.of(context).localeName).format(fecha),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Detalles de Festivos',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: festivos.map((f) {
                  final isAutonomico = f.esAutonomico;
                  final chipColor = isAutonomico ? Colors.orangeAccent : Colors.redAccent;
                  final chipLabel = isAutonomico ? l10n.calendarioAutonomico : l10n.calendarioNacional;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDarkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: chipColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: chipColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.celebration_rounded, color: chipColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.nombreMostrar,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? Colors.white : AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: chipColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  chipLabel.toUpperCase(),
                                  style: TextStyle(color: chipColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfigRegionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const _ConfigRegionButton({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.primary, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.sync_rounded, size: 22, color: Colors.white),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}

class _ProvinciaConfigDialog extends ConsumerStatefulWidget {
  final List<dynamic> provincias;
  final dynamic actual;
  final bool isDark;
  final AppLocalizations l10n;
  const _ProvinciaConfigDialog({required this.provincias, required this.actual, required this.isDark, required this.l10n});

  @override
  ConsumerState<_ProvinciaConfigDialog> createState() => _ProvinciaConfigDialogState();
}

class _ProvinciaConfigDialogState extends ConsumerState<_ProvinciaConfigDialog> {
  late List<dynamic> filtered;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    filtered = widget.provincias;
  }

  Future<void> _sync() async {
    setState(() => _isSyncing = true);
    final anio = ref.read(festivosAnioProvider);
    final success = await ref.read(provinciaNotifierProvider.notifier).sincronizar(anio);
    if (!mounted) return;
    setState(() => _isSyncing = false);
    
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Festivos sincronizados con éxito', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al sincronizar festivos', style: TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : AppColors.textDark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: (MediaQuery.of(context).size.width - 48).clamp(280.0, 480.0),
        height: (MediaQuery.of(context).size.height - 96).clamp(400.0, 650.0),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.backgroundDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: widget.isDark ? AppColors.border : AppColors.borderLight, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 40, offset: const Offset(0, 15))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.backgroundDarkSurface : Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Configuración de Festivos',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: textColor),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isSyncing ? null : _sync,
                    icon: _isSyncing 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.cloud_sync_rounded, color: Colors.white),
                    label: Text(
                      _isSyncing ? 'Sincronizando con Nager.Date...' : 'Sincronizar Festivos (Nager.Date)',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      disabledBackgroundColor: Colors.indigoAccent.withValues(alpha: 0.5),
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    onChanged: (q) => setState(() => filtered = widget.provincias
                        .where((p) => (p['nombre'] ?? '').toString().toLowerCase().contains(q.toLowerCase()))
                        .toList()),
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: '${widget.l10n.buscar} región...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: widget.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: widget.isDark ? AppColors.border : AppColors.borderLight)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: widget.isDark ? AppColors.border : AppColors.borderLight)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final p = filtered[index];
                  final active = p['codigo'] != null && widget.actual != null && p['codigo'] == widget.actual['codigo'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: active ? AppColors.primary : Colors.transparent),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      leading: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : (widget.isDark ? Colors.white10 : Colors.grey.shade200),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(active ? Icons.star_rounded : Icons.location_on_rounded, 
                          color: active ? Colors.white : AppColors.textSecondary, size: 20),
                      ),
                      title: Text(
                        p['nombre'] ?? '',
                        style: TextStyle(
                          color: active ? AppColors.primary : textColor,
                          fontWeight: active ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      trailing: active ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                      onTap: () async {
                        Navigator.pop(context);
                        if (p['codigo'] != null) {
                          await ref.read(provinciaNotifierProvider.notifier).cambiarProvincia(p['codigo']!);
                        }
                      },
                    ),
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

