import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/language_selector.dart';
import '../../../features/auth/application/providers/auth_provider.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/providers/photo_provider.dart';
import '../../admin/application/providers/config_provider.dart';
import '../../../shared/widgets/gaula_profile_image.dart';


class StudentShell extends ConsumerStatefulWidget {
  final Widget child;
  const StudentShell({super.key, required this.child});

  @override
  ConsumerState<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends ConsumerState<StudentShell> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const curve = Curves.easeInOutQuart;
    const duration = Duration(milliseconds: 400);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: isMobile ? Drawer(child: _StudentSidebarContent(isMobile: true)) : null,
      body: Stack(
        children: [
          // Main Content
          AnimatedPadding(
            duration: duration,
            curve: curve,
            padding: EdgeInsets.only(
              left: isMobile ? 0 : (_isExpanded ? 288 : 80),
              top: isMobile ? 84 : 96,
            ),
            child: Container(
              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              child: widget.child,
            ),
          ),

          if (!isMobile)
            Positioned(
              top: 0, left: 0, bottom: 0,
              child: AnimatedContainer(
                duration: duration,
                curve: curve,
                width: _isExpanded ? 288 : 80,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(4, 0),
                    )
                  ],
                ),
                child: _StudentSidebarContent(isExpanded: _isExpanded),
              ),
            ),

          // Header (Offset by Sidebar)
          Positioned(
            top: 0, 
            left: isMobile ? 0 : (_isExpanded ? 288 : 80), 
            right: 0,
            child: AnimatedContainer(
              duration: duration,
              curve: curve,
              child: _AppHeader(
                onToggleSidebar: () => setState(() => _isExpanded = !_isExpanded),
                isMobile: isMobile,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class _AppHeader extends ConsumerWidget {
  final VoidCallback onToggleSidebar;
  final bool isMobile;
  const _AppHeader({required this.onToggleSidebar, required this.isMobile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final l10n = AppLocalizations.of(context);
    final headerBg = isDark ? AppColors.backgroundDarkCard.withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.95);
    final borderColor = isDark ? AppColors.border : const Color(0xFFE5E7EB);
    final btnBg = isDark ? AppColors.backgroundDarkSurface : const Color(0xFFF9FAFB);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final textSecColor = isDark ? AppColors.textSecondary : const Color(0xFF6B7280);

    final headerHeight = isMobile ? 84.0 : 96.0;

    return Container(
      height: headerHeight,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
      decoration: BoxDecoration(
        color: headerBg,
        border: Border(bottom: BorderSide(color: borderColor)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hamburger toggle
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isMobile ? () => Scaffold.of(context).openDrawer() : onToggleSidebar,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: btnBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)),
                child: Center(child: Icon(Icons.menu, color: textSecColor, size: 20)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  usuario?.nombre ?? l10n.rolAlumno,
                  style: TextStyle(color: textColor, fontSize: isMobile ? 18 : 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (!isMobile)
                  Text(
                    l10n.shellStudentSubtitulo,
                    style: TextStyle(color: textSecColor, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                  ),
              ],
            ),
          ),

          // Language Selector — solo en desktop
          if (!isMobile) ...[
            const LanguageSelector(),
            const SizedBox(width: 12),
          ],

          // Theme toggle
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final currentMode = ref.read(themeModeProvider);
                final newMode = currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                ref.read(themeModeProvider.notifier).setTheme(newMode);
                ref.read(authNotifierProvider.notifier).updateTheme(newMode);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: btnBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)),
                child: Center(child: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: isDark ? textSecColor : const Color(0xFFEAB308), size: 20)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _NotificationBell(),
        ],
      ),
    );
  }
}

class _NotificationBell extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? AppColors.backgroundDarkCard : Colors.white;
    final borderColor = isDark ? AppColors.border : const Color(0xFFE5E7EB);
    final btnBg = isDark ? AppColors.backgroundDarkSurface : const Color(0xFFF9FAFB);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);

    return PopupMenuButton<String>(
      color: headerBg,
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor)),
      itemBuilder: (context) => [
        PopupMenuItem(child: Text(AppLocalizations.of(context).sinNotificaciones, style: TextStyle(color: textColor, fontSize: 13))),
      ],
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: btnBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)),
            child: Center(child: Icon(Icons.notifications_outlined, color: isDark ? AppColors.textSecondary : const Color(0xFF6B7280), size: 22)),
          ),
        ],
      ),
    );
  }
}

class _StudentSidebarContent extends ConsumerWidget {
  final bool isMobile;
  final bool isExpanded;
  const _StudentSidebarContent({this.isMobile = false, this.isExpanded = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    final rutaActual = GoRouterState.of(context).matchedLocation;

    final l10n = AppLocalizations.of(context);
    final items = [
      (Icons.home_outlined,        l10n.navInicio,        AppRoutes.studentHome),
      (Icons.check_box_outlined,   l10n.navMiAsistencia,  AppRoutes.studentAsistencia),
      (Icons.calendar_today,       l10n.navMiHorario,     AppRoutes.studentHorario),
      (Icons.badge_outlined,       l10n.navMiFicha,       AppRoutes.studentFicha),
      if (ref.watch(permissionsMatrixProvider).maybeWhen(
          data: (m) => (m['Alumno'] ?? []).contains('Crear Incidencias'),
          orElse: () => false))
        (Icons.warning_amber_rounded, l10n.navMisIncidencias, AppRoutes.studentIncidencias),
      (Icons.gavel_outlined,       l10n.navNormasCentro,  AppRoutes.studentNormas),
      (Icons.settings_outlined,    l10n.navAjustes,       AppRoutes.studentSettings),
    ];


    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.sidebarDark : AppColors.sidebarLight,
        border: Border(right: BorderSide(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // SIDEBAR LOGO
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(gradient: AppColors.logoGradient, borderRadius: BorderRadius.circular(10)),
                    child: const Center(child: Text('G', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900))),
                  ),
                  const SizedBox(width: 12),
                  Text('GAULA', style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
                ],
              ),
            )
          else
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(gradient: AppColors.logoGradient, borderRadius: BorderRadius.circular(10)),
              child: const Center(child: Text('G', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900))),
            ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                final activo = rutaActual == item.$3;
                return _SidebarItem(icon: item.$1, label: item.$2, isActive: activo, isExpanded: isExpanded, onTap: () {
                  if (isMobile) Navigator.pop(context);
                  context.go(item.$3);
                });
              },
            ),
          ),
          const Divider(color: AppColors.sidebarBorder),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _UserMiniCard(
              isExpanded: isExpanded,
              usuario: usuario,
              role: l10n.rolAlumno,
              onLogout: () async {
                await ref.read(authNotifierProvider.notifier).logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onTap;
  const _SidebarItem({required this.icon, required this.label, required this.isActive, required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeTextColor = isDark ? Colors.white : AppColors.primaryDark;

    final item = Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: isExpanded ? 16 : 0),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: isExpanded
                  ? Row(
                      children: [
                        Icon(icon, color: isActive ? AppColors.primary : AppColors.textSecondary, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isActive ? activeTextColor : AppColors.textSecondary,
                              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Icon(icon, color: isActive ? AppColors.primary : AppColors.textSecondary, size: 24),
                    ),
            ),
            if (isActive)
              Positioned(
                left: 0, top: 12, bottom: 12,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 1)],
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (!isExpanded) {
      return Tooltip(
        message: label,
        preferBelow: false,
        verticalOffset: 0,
        margin: const EdgeInsets.only(left: 70),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        textStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        child: item,
      );
    }

    return item;
  }
}

class _UserMiniCard extends StatelessWidget {
  final bool isExpanded;
  final dynamic usuario;
  final String role;
  final VoidCallback onLogout;

  const _UserMiniCard({required this.isExpanded, required this.usuario, required this.role, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return PopupMenuButton<int>(
      color: isDark ? AppColors.sidebarDark : AppColors.backgroundLightCard,
      offset: const Offset(0, -60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.sidebarBorder)),
      onSelected: (val) {
        if (val == 0) onLogout();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              const Icon(Icons.logout, color: Colors.redAccent, size: 18),
              const SizedBox(width: 12),
              Text(AppLocalizations.of(context).navCerrarSesion, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: isExpanded
            ? Row(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final photo = ref.watch(userPhotoProvider);
                      return GaulaProfileImage(
                        fotoUrl: usuario?.avatar,
                        bytes: photo,
                        nombre: usuario?.nombre ?? 'U',
                        radius: 20,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(usuario?.nombre ?? 'Usuario', style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w900, fontSize: 14), overflow: TextOverflow.ellipsis),
                        Text(role, style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5, height: 1)),
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_up, color: AppColors.textSecondary, size: 18),
                ],
              )
            : Consumer(
                builder: (context, ref, child) {
                  final photo = ref.watch(userPhotoProvider);
                  return Center(
                    child: GaulaProfileImage(
                      fotoUrl: usuario?.avatar,
                      bytes: photo,
                      nombre: usuario?.nombre ?? 'U',
                      radius: 20,
                    ),
                  );
                },
              ),
      ),
    );
  }

}




