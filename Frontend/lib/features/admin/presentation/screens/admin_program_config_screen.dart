import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../router/app_router.dart';
import '../../application/providers/config_provider.dart';

class AdminProgramConfigScreen extends ConsumerStatefulWidget {
  const AdminProgramConfigScreen({super.key});

  @override
  ConsumerState<AdminProgramConfigScreen> createState() =>
      _AdminProgramConfigScreenState();
}

class _AdminProgramConfigScreenState
    extends ConsumerState<AdminProgramConfigScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.adminProgramConfigTitulo,
                          style: TextStyle(
                              color: textColor,
                              fontSize: isMobile ? 32 : 56,
                              fontWeight: FontWeight.bold,
                              letterSpacing: isMobile ? -1 : -2)),
                      Text(
                          l10n.adminProgramConfigSubtitulo,
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: isMobile ? 14 : 18)),
                    ],
                  ),
                ),
                const SizedBox(height: 56),
                isMobile
                    ? Column(
                        children: [
                          FadeInLeft(
                            child: _ConfigCard(
                              title: l10n.adminProgramConfigRolesTitulo,
                              description: l10n.adminProgramConfigRolesDesc,
                              icon: Icons.admin_panel_settings_rounded,
                              iconColor: AppColors.primary,
                              child: Column(
                                children: [
                                  _ActionTile(
                                    label: l10n.adminProgramConfigMatrizPermisos,
                                    description: l10n.adminProgramConfigMatrizPermisosDesc,
                                    onTap: () => _showPermissionsMatrix(context),
                                  ),
                                  const Divider(height: 1),
                                  _ActionTile(
                                    label: l10n.adminProgramConfigGestionRoles,
                                    description: l10n.adminProgramConfigGestionRolesDesc,
                                    onTap: () => _showRolesDialog(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          FadeInLeft(
                            delay: const Duration(milliseconds: 150),
                            child: _ConfigCard(
                              title: l10n.adminProgramConfigCalendarioTitulo,
                              description: l10n.adminProgramConfigCalendarioDesc,
                              icon: Icons.event_available_rounded,
                              iconColor: Colors.amberAccent,
                              child: Column(
                                children: [
                                  _ActionTile(
                                    label: l10n.adminProgramConfigFestivos,
                                    description: l10n.adminProgramConfigFestivosDesc,
                                    onTap: () => context.push(AppRoutes.adminFestivos),
                                  ),
                                  const Divider(height: 1),
                                  _ActionTile(
                                    label: l10n.adminProgramConfigEventosCentro,
                                    description: l10n.adminProgramConfigEventosCentroDesc,
                                    enabled: false,
                                    onTap: () {},
                                    isComingSoon: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          FadeInRight(
                            child: const _NormasEditor(),
                          ),
                          const SizedBox(height: 32),
                          FadeInRight(
                            delay: const Duration(milliseconds: 150),
                            child: _ConfigCard(
                              title: l10n.adminProgramConfigMantenimientoTitulo,
                              description: l10n.adminProgramConfigMantenimientoDesc,
                              icon: Icons.settings_suggest_rounded,
                              iconColor: Colors.cyanAccent,
                              child: Column(
                                children: [
                                  _ActionTile(
                                    label: l10n.adminProgramConfigAuditoria,
                                    description: l10n.adminProgramConfigAuditoriaDesc,
                                    onTap: () => context.push(AppRoutes.adminAuditoria),
                                  ),
                                  const Divider(height: 1),
                                  _ActionTile(
                                    label: l10n.adminProgramConfigLimpieza,
                                    description: l10n.adminProgramConfigLimpiezaDesc,
                                    onTap: () => _showComingSoon(context),
                                    isComingSoon: true,
                                  ),
                                  const Divider(height: 1),
                                  _ActionTile(
                                    label: l10n.adminProgramConfigUsuarios,
                                    description: l10n.adminProgramConfigUsuariosDesc,
                                    onTap: () => context.pushNamed('admin-usuarios'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                FadeInLeft(
                                  child: _ConfigCard(
                                    title: l10n.adminProgramConfigRolesTitulo,
                                    description: l10n.adminProgramConfigRolesDesc,
                                    icon: Icons.admin_panel_settings_rounded,
                                    iconColor: AppColors.primary,
                                    child: Column(
                                      children: [
                                        _ActionTile(
                                          label: l10n.adminProgramConfigMatrizPermisos,
                                          description: l10n.adminProgramConfigMatrizPermisosDesc,
                                          onTap: () => _showPermissionsMatrix(context),
                                        ),
                                        const Divider(height: 1),
                                        _ActionTile(
                                          label: l10n.adminProgramConfigGestionRoles,
                                          description: l10n.adminProgramConfigGestionRolesDesc,
                                          onTap: () => _showRolesDialog(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                FadeInLeft(
                                  delay: const Duration(milliseconds: 150),
                                  child: _ConfigCard(
                                    title: l10n.adminProgramConfigCalendarioTitulo,
                                    description: l10n.adminProgramConfigCalendarioDesc,
                                    icon: Icons.event_available_rounded,
                                    iconColor: Colors.amberAccent,
                                    child: Column(
                                      children: [
                                        _ActionTile(
                                          label: l10n.adminProgramConfigFestivos,
                                          description: l10n.adminProgramConfigFestivosDesc,
                                          onTap: () => context.push(AppRoutes.adminFestivos),
                                        ),
                                        const Divider(height: 1),
                                        _ActionTile(
                                          label: l10n.adminProgramConfigEventosCentro,
                                          description: l10n.adminProgramConfigEventosCentroDesc,
                                          enabled: false,
                                          onTap: () {},
                                          isComingSoon: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                FadeInRight(
                                  child: const _NormasEditor(),
                                ),
                                const SizedBox(height: 32),
                                FadeInRight(
                                  delay: const Duration(milliseconds: 150),
                                  child: _ConfigCard(
                                    title: l10n.adminProgramConfigMantenimientoTitulo,
                                    description: l10n.adminProgramConfigMantenimientoDesc,
                                    icon: Icons.settings_suggest_rounded,
                                    iconColor: Colors.cyanAccent,
                                    child: Column(
                                      children: [
                                        _ActionTile(
                                          label: l10n.adminProgramConfigAuditoria,
                                          description: l10n.adminProgramConfigAuditoriaDesc,
                                          onTap: () => context.push(AppRoutes.adminAuditoria),
                                        ),
                                        const Divider(height: 1),
                                        _ActionTile(
                                          label: l10n.adminProgramConfigLimpieza,
                                          description: l10n.adminProgramConfigLimpiezaDesc,
                                          onTap: () => _showComingSoon(context),
                                          isComingSoon: true,
                                        ),
                                        const Divider(height: 1),
                                        _ActionTile(
                                          label: l10n.adminProgramConfigUsuarios,
                                          description: l10n.adminProgramConfigUsuariosDesc,
                                          onTap: () => context.pushNamed('admin-usuarios'),
                                        ),
                                      ],
                                    ),
                                  ),
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
      ),
    );
  }

  void _showRolesDialog(BuildContext context) {
    context.push(AppRoutes.adminRoles);
  }

  void _showPermissionsMatrix(BuildContext context) {
    context.push(AppRoutes.adminPermissions);
  }

  void _showComingSoon(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.backgroundDarkCard
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.adminProgramConfigEnDesarrolloTitulo,
            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textDark)),
        content: Text(l10n.adminProgramConfigEnDesarrolloDesc,
            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.adminProgramConfigEntendido,
                  style: const TextStyle(fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}

class _ConfigCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _ConfigCard(
      {required this.title,
      required this.description,
      required this.icon,
      required this.iconColor,
      required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
            color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 40,
                    offset: const Offset(0, 20))
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.01)
                  : Colors.grey[50]?.withValues(alpha: 0.5),
              border: Border(
                  bottom: BorderSide(
                      color:
                          isDark ? AppColors.border : AppColors.borderLight)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: iconColor.withValues(alpha: 0.1),
                            blurRadius: 10)
                      ]),
                  child: Icon(icon, color: iconColor, size: 30),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              color: isDark ? Colors.white : AppColors.textDark,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 4),
                      Text(description,
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final String description;
  final VoidCallback onTap;
  final bool enabled;
  final bool isComingSoon;

  const _ActionTile(
      {required this.label,
      required this.description,
      required this.onTap,
      this.enabled = true,
      this.isComingSoon = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: isDark
                      ? AppColors.border
                      : AppColors.borderLight.withValues(alpha: 0.5))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(label,
                            style: TextStyle(
                                color: enabled
                                    ? (isDark ? Colors.white : AppColors.textDark)
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: -0.2)),
                      ),
                      if (isComingSoon) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.2))),
                          child: Text(l10n.adminProgramConfigEnDesarrolloBadge,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(description,
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted.withValues(alpha: 0.4), size: 14),
          ],
        ),
      ),
    );
  }
}

class _NormasEditor extends ConsumerStatefulWidget {
  const _NormasEditor();
  @override
  ConsumerState<_NormasEditor> createState() => _NormasEditorState();
}

class _NormasEditorState extends ConsumerState<_NormasEditor> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNormas();
  }

  Future<void> _loadNormas() async {
    await ref.read(systemConfigProvider.notifier).loadConfig('normas_centro');
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(systemConfigProvider);
    final l10n = AppLocalizations.of(context);

    configAsync.whenData((data) {
      if (data.containsKey('normas_centro') && _ctrl.text.isEmpty) {
        _ctrl.text = data['normas_centro'] ?? '';
      }
    });

    return _ConfigCard(
      title: l10n.adminProgramConfigReglamentoTitulo,
      description: l10n.adminProgramConfigReglamentoDesc,
      icon: Icons.gavel_rounded,
      iconColor: Colors.deepOrangeAccent,
      child: _ActionTile(
        label: l10n.adminProgramConfigVerEditarReglamento,
        description: l10n.adminProgramConfigVerEditarReglamentoDesc,
        onTap: () => context.push(AppRoutes.adminNormas),
      ),
    );
  }
}



