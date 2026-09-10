import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class GaulaSearchableDropdown<T> extends StatefulWidget {
  final T? initialValue;
  final List<T> items;
  final String label;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final String hint;

  const GaulaSearchableDropdown({
    super.key,
    required this.initialValue,
    required this.items,
    required this.label,
    required this.itemLabel,
    required this.onChanged,
    this.hint = 'Buscar...',
  });

  @override
  State<GaulaSearchableDropdown<T>> createState() => _GaulaSearchableDropdownState<T>();
}

class _GaulaSearchableDropdownState<T> extends State<GaulaSearchableDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () => _showSearchDialog(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.initialValue != null ? widget.itemLabel(widget.initialValue as T) : widget.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _SearchDialog<T>(
        items: widget.items,
        itemLabel: widget.itemLabel,
        onSelected: widget.onChanged,
        hint: widget.hint,
      ),
    );
  }
}

class _SearchDialog<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?) onSelected;
  final String hint;

  const _SearchDialog({
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    required this.hint,
  });

  @override
  State<_SearchDialog<T>> createState() => _SearchDialogState<T>();
}

class _SearchDialogState<T> extends State<_SearchDialog<T>> {
  final _searchCtrl = TextEditingController();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _filter(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => widget.itemLabel(item).toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchCtrl,
              onChanged: _filter,
              style: TextStyle(color: isDark ? Colors.white : AppColors.textDark),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: isDark ? AppColors.backgroundDarkSurface : Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    title: Text(
                      widget.itemLabel(item),
                      style: TextStyle(color: isDark ? Colors.white : AppColors.textDark),
                    ),
                    onTap: () {
                      widget.onSelected(item);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    hoverColor: AppColors.primary.withValues(alpha: 0.1),
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
