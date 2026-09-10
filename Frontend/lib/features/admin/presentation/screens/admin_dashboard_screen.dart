import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../../shared/widgets/gaula_toast.dart';
import '../../application/providers/admin_dashboard_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});
  
  static final attendanceFilterProvider = StateProvider<String>((ref) => '7D');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final fechaStr = DateFormat('EEEE, d \'de\' MMMM', AppLocalizations.of(context).localeName).format(now);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : AppColors.textDark;
    final dashboardAsync = ref.watch(adminDashboardProvider);

    final isMobile = GaulaResponsive.isM(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text(l10n.adminDashErrorMetricas(err.toString()), style: const TextStyle(color: Colors.red))),
        data: (dashboardData) {
          final stats = [
            {'label': l10n.navAlumnos, 'value': dashboardData['totalAlumnos']?.toString() ?? '0', 'icon': Icons.people_outline, 'color': const Color(0xFF60A5FA), 'trend': '+2%', 'trendLabel': '+2%'},
            {'label': l10n.adminDashDocentes, 'value': dashboardData['totalProfesores']?.toString() ?? '0', 'icon': Icons.school_outlined, 'color': const Color(0xFF34D399), 'trend': 'Estable', 'trendLabel': l10n.adminDashTrendEstable},
            {'label': l10n.navIncidencias, 'value': dashboardData['incidenciasAbiertas']?.toString() ?? '0', 'icon': Icons.error_outline, 'color': const Color(0xFFF87171), 'trend': '-5%', 'trendLabel': '-5%'},
            {'label': l10n.navAsistencia, 'value': dashboardData['asistenciaPromedio']?.toString() ?? '0%', 'icon': Icons.analytics_outlined, 'color': const Color(0xFF8B5CF6), 'trend': '+0.5%', 'trendLabel': '+0.5%'},
          ];

          return SingleChildScrollView(
            padding: isMobile
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                : const EdgeInsets.all(40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header & Welcome Banner ---
                    FadeInDown(
                      child: _WelcomeBanner(fechaStr: fechaStr, isDark: isDark),
                    ),
                    const SizedBox(height: 40),

                    // --- Dashboard Section Title ---
                    FadeInLeft(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.adminDashResumenEjecutivo.toUpperCase(), 
                              style: TextStyle(
                                color: textColor, 
                                fontSize: 28, 
                                fontWeight: FontWeight.w900, 
                                letterSpacing: -1,
                                height: 1.1
                              )
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 4, width: 60,
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.adminDashMetricasTiempoReal, 
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w500)
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- Stats Grid ---
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: isMobile ? 200 : 400,
                            crossAxisSpacing: isMobile ? 12 : 32,
                            mainAxisSpacing: isMobile ? 12 : 32,
                            mainAxisExtent: isMobile ? 130 : 180,
                          ),
                          itemCount: stats.length,
                          itemBuilder: (context, index) {
                            final e = stats[index];
                            return FadeInUp(
                              delay: Duration(milliseconds: 50 * index),
                              child: _StatCard(
                                label: e['label'] as String,
                                value: e['value'] as String,
                                icon: e['icon'] as IconData,
                                color: e['color'] as Color,
                                trend: e['trend'] as String,
                                trendLabel: e['trendLabel'] as String,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 48),

                    // --- Main Content Area ---
                    isMobile 
                      ? Column(
                          children: [
                            _MainChartSection(isDark: isDark),
                            const SizedBox(height: 24),
                            _RecentIncidentsSection(isDark: isDark),
                            const SizedBox(height: 24),
                            _IncidenciasChartSection(isDark: isDark),
                            const SizedBox(height: 24),
                            _QuickManagementCard(isDark: isDark),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Charts & Detailed Stats
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 400),
                                    child: _MainChartSection(isDark: isDark),
                                  ),
                                  const SizedBox(height: 24),
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 450),
                                    child: _IncidenciasChartSection(isDark: isDark),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            // Right: Global Activity & Notifications
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  FadeInRight(
                                    delay: const Duration(milliseconds: 200),
                                    child: _RecentIncidentsSection(isDark: isDark),
                                  ),
                                  const SizedBox(height: 24),
                                  FadeInRight(
                                    delay: const Duration(milliseconds: 300),
                                    child: _QuickManagementCard(isDark: isDark),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickManagementCard extends StatelessWidget {
  final bool isDark;
  const _QuickManagementCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
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
            children: [
              Icon(Icons.flash_on, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  AppLocalizations.of(context).adminDashAccionesRapidas,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _QuickButton(
            icon: Icons.person_add_outlined,
            label: AppLocalizations.of(context).adminDashMatricularAlumno,
            color: const Color(0xFF60A5FA),
            onTap: () => context.go(AppRoutes.adminAlumnos),
          ),
          const SizedBox(height: 12),
          _QuickButton(
            icon: Icons.calendar_today_outlined,
            label: AppLocalizations.of(context).adminDashGestionarFestivos,
            color: const Color(0xFFFBBF24),
            onTap: () => context.go(AppRoutes.adminHorario),
          ),
          const SizedBox(height: 12),
          _QuickButton(
            icon: Icons.security_outlined,
            label: AppLocalizations.of(context).adminDashRevisarPermisos,
            color: const Color(0xFF34D399),
            onTap: () => context.go(AppRoutes.adminProgramConfig),
          ),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  final String fechaStr;
  final bool isDark;
  const _WelcomeBanner({required this.fechaStr, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isMobile = GaulaResponsive.isM(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.primary.withValues(alpha: 0.8), AppColors.primary.withValues(alpha: 0.4)]
              : [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isMobile ? 20 : 32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: Stack(
        children: [
          if (!isMobile)
            Positioned(
              right: -20, top: -20,
              child: Icon(Icons.auto_awesome_motion, size: 200, color: Colors.white.withValues(alpha: 0.1)),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.adminDashBienvenido,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 20 : 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Divider(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05), height: 1),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.white.withValues(alpha: 0.8), size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fechaStr.toUpperCase(),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: isMobile ? 11 : 14, fontWeight: FontWeight.w600, letterSpacing: 1),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 16 : 24),
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.adminAuditoria),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: isMobile ? 12 : 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(AppLocalizations.of(context).verReporteMensual, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final String trendLabel;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color, required this.trend, required this.trendLabel});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isPositive = trend.startsWith('+');
    final isNeutral = trend == 'Estable';
    
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24), 
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 6 : 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: isMobile ? 14 : 18),
              ),
              _TrendBadge(trend: trendLabel, isPositive: isPositive, isNeutral: isNeutral),
            ],
          ),
          SizedBox(height: isMobile ? 8 : 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value, 
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textDark, 
                fontSize: isMobile ? 22 : 32, 
                fontWeight: FontWeight.w900, 
                letterSpacing: -1,
                height: 1,
              )
            ),
          ),
          SizedBox(height: isMobile ? 4 : 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label.toUpperCase(), 
              style: TextStyle(
                color: AppColors.textSecondary, 
                fontSize: isMobile ? 9 : 10, 
                fontWeight: FontWeight.w900, 
                letterSpacing: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final String trend;
  final bool isPositive;
  final bool isNeutral;

  const _TrendBadge({required this.trend, required this.isPositive, required this.isNeutral});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isNeutral ? Colors.blue.withValues(alpha: 0.1) : (isPositive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isNeutral ? Icons.remove_rounded : (isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded), 
            color: isNeutral ? Colors.blue : (isPositive ? Colors.green : Colors.red), 
            size: 10
          ),
          const SizedBox(width: 4),
          Text(
            trend,
            style: TextStyle(
              color: isNeutral ? Colors.blue : (isPositive ? Colors.green : Colors.red), 
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainChartSection extends ConsumerWidget {
  final bool isDark;
  const _MainChartSection({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(AdminDashboardScreen.attendanceFilterProvider);
    
    // Simular datos según el filtro
    final List<FlSpot> spots = switch (selectedFilter) {
      '1M'  => [const FlSpot(0, 80), const FlSpot(1, 82), const FlSpot(2, 85), const FlSpot(3, 83), const FlSpot(4, 88), const FlSpot(5, 90), const FlSpot(6, 87)],
      '3M'  => [const FlSpot(0, 75), const FlSpot(1, 78), const FlSpot(2, 82), const FlSpot(3, 80), const FlSpot(4, 85), const FlSpot(5, 83), const FlSpot(6, 86)],
      'YTD' => [const FlSpot(0, 70), const FlSpot(1, 75), const FlSpot(2, 80), const FlSpot(3, 78), const FlSpot(4, 82), const FlSpot(5, 85), const FlSpot(6, 88)],
      _     => [const FlSpot(0, 85), const FlSpot(1, 90), const FlSpot(2, 88), const FlSpot(3, 92), const FlSpot(4, 95), const FlSpot(5, 80), const FlSpot(6, 85)],
    };

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).adminDashAsistenciaGlobal, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(AppLocalizations.of(context).adminDashAsistenciaSubtitulo, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 16),
                    _ChartFilterToggle(),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context).adminDashAsistenciaGlobal, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(AppLocalizations.of(context).adminDashAsistenciaSubtitulo, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    _ChartFilterToggle(),
                  ],
                ),
          const SizedBox(height: 40),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        if (value % 20 != 0) return const SizedBox.shrink();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 12,
                          child: Text(
                            '${value.toInt()}%',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const days = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 12,
                            child: Text(
                              days[value.toInt()], 
                              style: const TextStyle(
                                color: AppColors.textSecondary, 
                                fontSize: 11, 
                                fontWeight: FontWeight.bold
                              )
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [AppColors.primary.withValues(alpha: 0.2), AppColors.primary.withValues(alpha: 0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartFilterToggle extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ChartFilterToggle> createState() => _ChartFilterToggleState();
}

class _ChartFilterToggleState extends ConsumerState<_ChartFilterToggle> {
  int selectedIndex = 0;
  final filters = ['7D', '1M', '3M', 'YTD'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(filters.length, (index) => GestureDetector(
          onTap: () {
            setState(() => selectedIndex = index);
            ref.read(AdminDashboardScreen.attendanceFilterProvider.notifier).state = filters[index];
            GaulaToast.show(
              context, 
              title: AppLocalizations.of(context).adminDashFiltroAplicado, 
              message: AppLocalizations.of(context).adminDashMostrandoDatos(filters[index]), 
              type: GaulaToastType.info
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selectedIndex == index ? (isDark ? Colors.white10 : Colors.white) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: selectedIndex == index && !isDark ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : null,
            ),
            child: Text(
              filters[index],
              style: TextStyle(
                color: ref.watch(AdminDashboardScreen.attendanceFilterProvider) == filters[index] ? (isDark ? Colors.white : AppColors.primary) : AppColors.textSecondary,
                fontSize: 13, // Increased font size for filter labels
                fontWeight: FontWeight.w900, // Thicker font
              ),
            ),
          ),
        )),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: isDark ? Colors.white24 : Colors.black12, size: 16),
          ],
        ),
      ),
    );
  }
}

class _IncidenciasChartSection extends StatelessWidget {
  final bool isDark;
  const _IncidenciasChartSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).adminDashIncidenciasPorCurso, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          SizedBox(
            height: 300,
            child: Consumer(
              builder: (context, ref, _) {
                final dashboardAsync = ref.watch(adminDashboardProvider);
                return dashboardAsync.when(
                  data: (data) {
                    final chartData = (data['incidenciasPorCurso'] as List? ?? []);
                    if (chartData.isEmpty) {
                      return Center(child: Text(AppLocalizations.of(context).adminDashSinIncidencias, style: TextStyle(color: AppColors.textSecondary)));
                    }
                    return BarChart(
                      BarChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) {
                                if (val.toInt() < 0 || val.toInt() >= chartData.length) return const SizedBox.shrink();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(chartData[val.toInt()]['name'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: chartData.asMap().entries.map((e) {
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: (e.value['count'] as num).toDouble(),
                                color: AppColors.primary,
                                width: 20,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => Center(child: Text(AppLocalizations.of(context).adminDashErrorGrafico)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentIncidentsSection extends ConsumerWidget {
  final bool isDark;
  const _RecentIncidentsSection({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(adminDashboardProvider);
    
    return dashboardAsync.maybeWhen(
      data: (data) {
        final recentAlerts = (data['recentAlerts'] as List? ?? []);
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDarkCard : Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).adminDashAlertasRecientes, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              if (recentAlerts.isEmpty)
                Center(child: Text(AppLocalizations.of(context).sinAlertasRecientes, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)))
              else
                ...recentAlerts.map((alert) => _IncidentMiniItem(
                  title: alert['title'] ?? 'Incidencia',
                  student: alert['student'] ?? 'Alumno',
                  time: _formatTimeStr(alert['time'] as String?),
                  isDark: isDark,
                )),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  String _formatTimeStr(String? timeStr) {
    if (timeStr == null) return 'N/A';
    try {
      final dt = DateTime.parse(timeStr);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
      return DateFormat('dd/MM HH:mm').format(dt);
    } catch (_) {
      return timeStr;
    }
  }
}

class _IncidentMiniItem extends StatelessWidget {
  final String title;
  final String student;
  final String time;
  final bool isDark;
  const _IncidentMiniItem({required this.title, required this.student, required this.time, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(width: 4, height: 32, decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13)),
                Text('$student • $time', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





