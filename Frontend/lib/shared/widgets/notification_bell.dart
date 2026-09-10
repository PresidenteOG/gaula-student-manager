import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../features/admin/application/providers/notification_provider.dart';
import '../../l10n/app_localizations.dart';

class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notificationsAsync = ref.watch(notificationProvider);
    final headerBg = isDark ? AppColors.backgroundDarkCard : Colors.white;
    final borderColor = isDark ? AppColors.border : const Color(0xFFE5E7EB);
    final btnBg = isDark ? AppColors.backgroundDarkSurface : const Color(0xFFF9FAFB);

    return PopupMenuButton(
      offset: const Offset(0, 50),
      color: headerBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: borderColor)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: btnBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)),
            child: Icon(Icons.notifications_outlined, color: isDark ? AppColors.textSecondary : const Color(0xFF6B7280), size: 22),
          ),
          notificationsAsync.when(
            data: (list) {
              final unread = list.where((n) => !n.isRead).length;
              if (unread == 0) return const SizedBox.shrink();
              return Positioned(
                top: -4, right: -4,
                child: Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(color: const Color(0xFFEA580C), shape: BoxShape.circle, border: Border.all(color: headerBg, width: 2)),
                  child: Center(child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900))),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: SizedBox(
            width: 320,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).notificacionesTitulo, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w900, fontSize: 18)),
                      TextButton(
                        onPressed: () => ref.read(notificationProvider.notifier).markAllAsRead(),
                        child: Text(AppLocalizations.of(context).marcarTodas, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                SizedBox(
                  height: 350,
                  child: notificationsAsync.when(
                    data: (notifications) {
                      if (notifications.isEmpty) {
                        return Center(child: Text(AppLocalizations.of(context).noHayNotificaciones, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)));
                      }
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final n = notifications[index];
                          return _NotificationTile(
                            icon: n.icon,
                            color: n.color,
                            title: n.title,
                            desc: n.description,
                            time: _formatTime(n.timestamp),
                            isDark: isDark,
                            isNew: !n.isRead,
                            onTap: () {
                              ref.read(notificationProvider.notifier).markAsRead(n.id);
                              if (n.route != null) context.pushNamed(n.route!);
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('${AppLocalizations.of(context).errorGenerico}: $e')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'hace ${diff.inHours}h';
    return DateFormat('dd/MM').format(dt);
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  final String time;
  final bool isDark;
  final bool isNew;
  final VoidCallback onTap;

  const _NotificationTile({required this.icon, required this.color, required this.title, required this.desc, required this.time, required this.isDark, required this.isNew, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isNew ? color.withValues(alpha: 0.05) : Colors.transparent,
          border: Border(bottom: BorderSide(color: isDark ? AppColors.border : const Color(0xFFF3F4F6))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(desc, style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontSize: 11, height: 1.4)),
                  const SizedBox(height: 6),
                  Text(time, style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            if (isNew)
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
          ],
        ),
      ),
    );
  }
}

