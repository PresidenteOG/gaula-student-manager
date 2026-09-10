import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:responsive_framework/responsive_framework.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'admin_auditoria_screen.dart';
import 'admin_reglamento_screen.dart';

class AdminConfiguracionPage extends ConsumerStatefulWidget {
  const AdminConfiguracionPage({super.key});

  @override
  ConsumerState<AdminConfiguracionPage> createState() => _AdminConfiguracionPageState();
}

class _AdminConfiguracionPageState extends ConsumerState<AdminConfiguracionPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.adminConfigTitle,
                          style: TextStyle(
                              color: textColor,
                              fontSize: isMobile ? 32 : 40,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1)),
                      const SizedBox(height: 8),
                      Container(height: 4, width: 60, color: AppColors.primary),
                      const SizedBox(height: 16),
                      Text(
                          l10n.adminConfigSubtitle,
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: isMobile ? 14 : 16)),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 32 : 48),

                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : 2,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                    mainAxisExtent: isMobile ? 280 : 320,
                  ),
                  children: [
                    _ConfigCard(
                      title: l10n.adminConfigSecurityTitle,
                      icon: Icons.shield_outlined,
                      color: Colors.blueAccent,
                      description: l10n.adminConfigSecurityDesc,
                      children: [
                        _ConfigTile(label: l10n.adminConfigSecurityChangePassword, icon: Icons.lock_outline, onTap: () {}),
                        _ConfigTile(label: l10n.adminConfigSecurityActiveSessions, icon: Icons.devices_outlined, onTap: () {}),
                        _ConfigTile(label: l10n.adminConfigSecurity2FA, icon: Icons.verified_user_outlined, isComingSoonLabel: l10n.adminConfigComingSoon, isComingSoon: true),
                      ],
                    ),

                    _ConfigCard(
                      title: l10n.adminConfigReglamentoTitle,
                      icon: Icons.gavel_outlined,
                      color: Colors.orangeAccent,
                      description: l10n.adminConfigReglamentoDesc,
                      children: [
                        _ConfigTile(label: l10n.adminConfigReglamentoEdit, icon: Icons.edit_note_rounded, onTap: () => _openReglamentoEditor(context)),
                        _ConfigTile(label: l10n.adminConfigReglamentoHistory, icon: Icons.history_rounded, onTap: () {}),
                        _ConfigTile(label: l10n.adminConfigReglamentoPublish, icon: Icons.publish_rounded, onTap: () {}),
                      ],
                    ),

                    _ConfigCard(
                      title: l10n.adminConfigAuditoriaTitle,
                      icon: Icons.assignment_outlined,
                      color: Colors.tealAccent,
                      description: l10n.adminConfigAuditoriaDesc,
                      children: [
                        _ConfigTile(label: l10n.adminConfigAuditoriaViewLog, icon: Icons.list_alt_rounded, onTap: () => _openAuditoria(context)),
                        _ConfigTile(label: l10n.adminConfigAuditoriaExport, icon: Icons.file_download_outlined, onTap: () {}),
                        _ConfigTile(label: l10n.adminConfigAuditoriaAlerts, icon: Icons.notification_important_outlined, onTap: () {}),
                      ],
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

  void _openReglamentoEditor(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminReglamentoScreen()));
  }

  void _openAuditoria(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminAuditoriaScreen()));
  }

}

class _ConfigCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _ConfigCard({required this.title, required this.description, required this.icon, required this.color, required this.children});

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

class _ConfigTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isComingSoon;
  final String? isComingSoonLabel;

  const _ConfigTile({required this.label, required this.icon, this.onTap, this.isComingSoon = false, this.isComingSoonLabel});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.textSecondary, size: 18),
      title: Text(label, style: TextStyle(color: isDark ? Colors.white70 : AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: isComingSoon
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              color: Colors.blue.withValues(alpha: 0.1),
              child: Text(isComingSoonLabel ?? '', style: const TextStyle(color: Colors.blue, fontSize: 8, fontWeight: FontWeight.bold)),
            )
          : Icon(Icons.chevron_right, color: isDark ? Colors.white24 : Colors.black12, size: 16),
    );
  }
}

