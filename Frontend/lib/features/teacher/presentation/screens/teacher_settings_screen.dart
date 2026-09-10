import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../features/auth/application/providers/auth_provider.dart';

class TeacherSettingsScreen extends ConsumerWidget {
  const TeacherSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.ajustesTitulo,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1),
                      ),
                      const SizedBox(height: 8),
                      Container(height: 4, width: 80, color: AppColors.primary),
                      const SizedBox(height: 16),
                      Text(
                        l10n.teacherSettingsSubtitulo,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : 2,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                    mainAxisExtent: 280,
                  ),
                  children: [
                    // PERFIL
                    _SettingsCard(
                      title: l10n.teacherSettingsPerfilUsuario,
                      icon: Icons.person_outline_rounded,
                      color: AppColors.primary,
                      description: l10n.teacherSettingsPerfilDesc,
                      children: [
                        _SettingsTile(
                          label: l10n.teacherSettingsVerPerfil,
                          icon: Icons.visibility_outlined,
                          onTap: () => context.pushNamed('teacher-perfil'),
                        ),
                        _SettingsTile(
                          label: l10n.teacherSettingsEditarPerfil,
                          icon: Icons.edit_rounded,
                          onTap: () => context.pushNamed('teacher-perfil'),
                        ),
                      ],
                    ),

                    // SEGURIDAD
                    _SettingsCard(
                      title: l10n.teacherSettingsSeguridad,
                      icon: Icons.shield_outlined,
                      color: Colors.blueAccent,
                      description: l10n.teacherSettingsSeguridadDesc,
                      children: [
                        _SettingsTile(
                          label: l10n.teacherSettingsCambiarPass,
                          icon: Icons.lock_outline,
                          onTap: () => context.pushNamed('teacher-perfil'),
                        ),
                      ],
                    ),

                    // NOTIFICACIONES
                    _SettingsCard(
                      title: l10n.teacherSettingsNotificaciones,
                      icon: Icons.notifications_none_rounded,
                      color: Colors.orangeAccent,
                      description: l10n.teacherSettingsNotificacionesDesc,
                      children: [
                        _SettingsTile(
                          label: l10n.teacherSettingsAlertasAsistencia,
                          icon: Icons.check_circle_outline,
                          onTap: () {
                            _showToggleDialog(context, l10n.teacherSettingsAlertasAsistencia);
                          },
                        ),
                        _SettingsTile(
                          label: l10n.teacherSettingsMensajesAlumnos,
                          icon: Icons.chat_bubble_outline,
                          onTap: () {
                            _showToggleDialog(context, l10n.teacherSettingsMensajesAlumnos);
                          },
                        ),
                      ],
                    ),

                    // PREFERENCIAS
                    _SettingsCard(
                      title: l10n.teacherSettingsPreferencias,
                      icon: Icons.tune_rounded,
                      color: Colors.tealAccent,
                      description: l10n.teacherSettingsPreferenciasDesc,
                      children: [
                        _SettingsTile(
                          label: l10n.tema,
                          icon: Icons.brightness_6_outlined,
                          onTap: () {
                            final currentMode = ref.read(themeModeProvider);
                            final newMode = currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                            ref.read(themeModeProvider.notifier).setTheme(newMode);
                            ref.read(authNotifierProvider.notifier).updateTheme(newMode);
                          },
                        ),
                      ],
                    ),

                    // SOPORTE Y AYUDA
                    _SettingsCard(
                      title: l10n.teacherSettingsSoporte,
                      icon: Icons.help_outline_rounded,
                      color: Colors.purpleAccent,
                      description: l10n.teacherSettingsSoporteDesc,
                      children: [
                        _SettingsTile(
                          label: l10n.teacherSettingsNormasCentro,
                          icon: Icons.gavel_rounded,
                          onTap: () => context.pushNamed('teacher-normas'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Center(
                  child: Column(
                    children: [
                      Text(
                        l10n.teacherSettingsVersion,
                        style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5), fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.teacherSettingsCopyright,
                        style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.3), fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showToggleDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => _SettingsToggleDialog(title: title),
    );
  }
}

final teacherPushNotifProvider = StateProvider<bool>((ref) => true);
final teacherEmailNotifProvider = StateProvider<bool>((ref) => false);

class _SettingsToggleDialog extends ConsumerWidget {
  final String title;
  const _SettingsToggleDialog({required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final push = ref.watch(teacherPushNotifProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text(l10n.teacherSettingsNotifPush, style: TextStyle(fontSize: 14, color: textColor)),
            value: push,
            onChanged: (v) => ref.read(teacherPushNotifProvider.notifier).state = v,
          ),
          // SwitchListTile(
          //   title: Text(l10n.teacherSettingsNotifEmail, style: TextStyle(fontSize: 14, color: textColor)),
          //   value: email,
          //   onChanged: (v) => ref.read(teacherEmailNotifProvider.notifier).state = v,
          // ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.aceptar)),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _SettingsCard({required this.title, required this.description, required this.icon, required this.color, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05), height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _SettingsTile({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.textSecondary, size: 18),
      title: Text(label, style: TextStyle(color: isDark ? Colors.white70 : AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white24 : Colors.black12, size: 16),
    );
  }
}




