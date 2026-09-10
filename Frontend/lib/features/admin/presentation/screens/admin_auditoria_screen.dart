import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../l10n/app_localizations.dart';

final auditoriaProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.read(dioClientProvider);
  final res = await dio.get('admin/auditoria');
  return res.data;
});

class AdminAuditoriaScreen extends ConsumerWidget {
  const AdminAuditoriaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isMobile = MediaQuery.of(context).size.width < 700;
    final auditoriaAsync = ref.watch(auditoriaProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.adminAuditoriaTitle, style: TextStyle(color: textColor, fontSize: isMobile ? 22 : 32, fontWeight: FontWeight.bold, letterSpacing: -1)),
                        Text(l10n.adminAuditoriaSubtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => ref.invalidate(auditoriaProvider),
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            Expanded(
              child: auditoriaAsync.when(
                data: (logs) {
                  if (logs.isEmpty) return _buildEmptyState(l10n);
                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
                      boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 20))],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: logs.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return FadeInRight(
                          delay: Duration(milliseconds: 50 * index),
                          child: _AuditTile(log: log),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: isDark ? Colors.white : AppColors.textDark))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off_rounded, size: 80, color: AppColors.textMuted.withValues(alpha: 0.2)),
          const SizedBox(height: 24),
          Text(l10n.adminAuditoriaEmpty, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
        ],
      ),
    );
  }
}

class _AuditTile extends StatelessWidget {
  final dynamic log;
  const _AuditTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final date = DateTime.parse(log['fecha']);
    final typeColor = _getTypeColor(log['tipo'] ?? 'INFO');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
            child: Icon(_getIconForType(log['tipo'] ?? 'INFO'), color: typeColor, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        log['usuario']?.toUpperCase() ?? 'SISTEMA',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle)),
                    const SizedBox(width: 12),
                    Text(DateFormat('dd MMM yyyy, HH:mm').format(date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${log['accion']} → ${log['objetivo']}',
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          _ActionBadge(type: log['tipo'] ?? 'INFO'),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'DANGER': return Colors.redAccent;
      case 'WARN': return Colors.orangeAccent;
      case 'SUCCESS': return Colors.greenAccent;
      case 'INFO': return Colors.blueAccent;
      default: return AppColors.primary;
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toUpperCase()) {
      case 'DANGER': return Icons.gpp_maybe_rounded;
      case 'WARN': return Icons.report_problem_rounded;
      case 'SUCCESS': return Icons.check_circle_rounded;
      case 'INFO': return Icons.info_rounded;
      default: return Icons.bolt_rounded;
    }
  }
}

class _ActionBadge extends StatelessWidget {
  final String type;
  const _ActionBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Text(type.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'DANGER': return Colors.redAccent;
      case 'WARN': return Colors.orangeAccent;
      case 'SUCCESS': return Colors.greenAccent;
      default: return Colors.blueAccent;
    }
  }
}

