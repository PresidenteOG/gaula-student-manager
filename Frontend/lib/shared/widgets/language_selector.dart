import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../theme/app_theme.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  static const _languages = [
    ('ES', 'Español', '🇪🇸'),
    ('EN', 'English', '🇺🇸'),
    ('CA', 'Català',  '🏴󠁥󠁳󠁣󠁴󠁿'),
  ];

  String _localeToCode(Locale locale) {
    if (locale.languageCode == 'en') return 'EN';
    if (locale.languageCode == 'ca') return 'CA';
    return 'ES';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final currentCode = _localeToCode(locale);
    final current = _languages.firstWhere(
      (l) => l.$1 == currentCode,
      orElse: () => _languages[0],
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnBg = isDark ? AppColors.backgroundDarkSurface : const Color(0xFFF9FAFB);
    final borderColor = isDark ? AppColors.border : const Color(0xFFE5E7EB);
    final textSecColor = isDark ? AppColors.textSecondary : const Color(0xFF6B7280);

    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        offset: const Offset(0, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor),
        ),
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        onSelected: (code) => ref.read(localeProvider.notifier).setLocaleFromCode(code),
        itemBuilder: (context) => _languages
            .map((l) => _buildItem(l.$1, l.$2, l.$3, l.$1 == currentCode))
            .toList(),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: btnBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Text(current.$3, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                current.$1,
                style: TextStyle(
                  color: textSecColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: textSecColor.withValues(alpha: 0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildItem(String code, String label, String flag, bool active) {
    return PopupMenuItem(
      value: code,
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: active ? FontWeight.w800 : FontWeight.w500,
              color: active ? AppColors.primary : null,
            ),
          ),
          const Spacer(),
          if (active) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
        ],
      ),
    );
  }
}
