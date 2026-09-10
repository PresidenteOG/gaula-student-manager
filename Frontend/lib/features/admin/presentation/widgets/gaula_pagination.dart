import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class GaulaPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final bool isLoading;

  const GaulaPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 0) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ANTERIOR
          _PageButton(
            label: 'ANTERIOR',
            icon: Icons.chevron_left_rounded,
            onTap: currentPage > 0 && !isLoading
                ? () => onPageChanged(currentPage - 1)
                : null,
            isDisabled: currentPage <= 0 || isLoading,
            isStart: true,
          ),
          const SizedBox(width: 24),

          // Page Numbers
          ..._buildPageNumbers(isDark, textColor),

          const SizedBox(width: 24),
          // SIGUIENTE
          _PageButton(
            label: 'SIGUIENTE',
            icon: Icons.chevron_right_rounded,
            onTap: currentPage < totalPages - 1 && !isLoading
                ? () => onPageChanged(currentPage + 1)
                : null,
            isDisabled: currentPage >= totalPages - 1 || isLoading,
            isStart: false,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(bool isDark, Color textColor) {
    List<Widget> children = [];
    
    // Always show first page
    children.add(_buildPageNode(0, isDark, textColor));

    if (currentPage > 2) {
      children.add(const _Ellipsis());
    }

    // Show pages around current
    for (int i = 1; i < totalPages - 1; i++) {
      if (i >= currentPage - 1 && i <= currentPage + 1) {
        children.add(_buildPageNode(i, isDark, textColor));
      }
    }

    if (currentPage < totalPages - 3) {
      children.add(const _Ellipsis());
    }

    // Always show last page if more than 1 page
    if (totalPages > 1) {
      children.add(_buildPageNode(totalPages - 1, isDark, textColor));
    }

    return children;
  }

  Widget _buildPageNode(int index, bool isDark, Color textColor) {
    final isSelected = index == currentPage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: isSelected || isLoading ? null : () => onPageChanged(index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: isSelected ? Colors.white : (isSelected ? Colors.white : textColor),
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text('...', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
    );
  }
}

class _PageButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;
  final bool isStart;

  const _PageButton({
    required this.label, 
    required this.icon, 
    this.onTap, 
    this.isDisabled = false,
    required this.isStart,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.black12,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isStart) Icon(icon, size: 18, color: isDisabled ? AppColors.textSecondary.withValues(alpha: 0.3) : AppColors.primary),
            if (isStart) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDisabled ? AppColors.textSecondary.withValues(alpha: 0.3) : (isDark ? Colors.white : AppColors.textDark),
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
            if (!isStart) const SizedBox(width: 8),
            if (!isStart) Icon(icon, size: 18, color: isDisabled ? AppColors.textSecondary.withValues(alpha: 0.3) : AppColors.primary),
          ],
        ),
      ),
    );
  }
}
