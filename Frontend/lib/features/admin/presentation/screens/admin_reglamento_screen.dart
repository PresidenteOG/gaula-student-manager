import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/gaula_toast.dart';
import '../../infrastructure/repositories/reglamento_repository.dart';
import '../../domain/entities/reglamento_model.dart';

final reglamentoListProvider = FutureProvider<List<ReglamentoModel>>((ref) {
  return ref.watch(reglamentoRepositoryProvider).getHistory();
});

class AdminReglamentoScreen extends ConsumerStatefulWidget {
  const AdminReglamentoScreen({super.key});

  @override
  ConsumerState<AdminReglamentoScreen> createState() => _AdminReglamentoScreenState();
}

class _AdminReglamentoScreenState extends ConsumerState<AdminReglamentoScreen> {
  late QuillController _controller;
  final TextEditingController _versionNameController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false;
  ReglamentoModel? _selectedVersion;

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
    _loadActive();
  }

  Future<void> _loadActive() async {
    try {
      final active = await ref.read(reglamentoRepositoryProvider).getActive();
      _selectVersion(active);
    } catch (e) {
      // No hay versión activa
    }
  }

  void _selectVersion(ReglamentoModel v) {
    setState(() {
      _selectedVersion = v;
      _versionNameController.text = v.nombreVersion;
      _isActive = v.activo;
      try {
        final doc = Document.fromJson(jsonDecode(v.contenido));
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _controller = QuillController.basic();
        _controller.document.insert(0, v.contenido);
      }
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_versionNameController.text.isEmpty) {
      GaulaToast.show(context, title: l10n.adminReglamentoErrorTitulo, message: l10n.adminReglamentoVersionRequerida, type: GaulaToastType.error);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final content = jsonEncode(_controller.document.toDelta().toJson());
      await ref.read(reglamentoRepositoryProvider).save(
        _versionNameController.text,
        content,
        _isActive,
      );
      ref.invalidate(reglamentoListProvider);
      ref.invalidate(reglamentoActivoProvider);
      if (mounted) {
        GaulaToast.show(context, title: l10n.adminReglamentoExitoTitulo, message: l10n.adminReglamentoGuardadoOk, type: GaulaToastType.success);
      }
    } catch (e) {
      if (mounted) {
        GaulaToast.show(context, title: l10n.adminReglamentoErrorTitulo, message: l10n.adminReglamentoFalloGuardar(e.toString()), type: GaulaToastType.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _openHistorySheet(BuildContext context, bool isDark, AsyncValue<List<ReglamentoModel>> historyAsync) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        final l10n = AppLocalizations.of(context);
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.adminReglamentoHistorialTitulo, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(l10n.adminReglamentoHistorialSubtitulo, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              Expanded(
                child: historyAsync.when(
                  data: (history) => ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final v = history[index];
                      return _HistoryTile(
                        version: v,
                        isSelected: _selectedVersion?.id == v.id,
                        onTap: () {
                          _selectVersion(v);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  error: (e, _) => Center(child: Text(l10n.adminReglamentoErrorCargar, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark))),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedVersion = null;
                      _versionNameController.clear();
                      _controller = QuillController.basic();
                      _isActive = true;
                    });
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.adminReglamentoNuevaVersion),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final historyAsync = ref.watch(reglamentoListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isMobile
          ? _buildMobileLayout(isDark, historyAsync)
          : Row(
              children: [
                _buildSidebar(isDark, historyAsync),
                Expanded(
                  child: _buildEditorArea(isDark, isMobile: false),
                ),
              ],
            ),
    );
  }

  Widget _buildMobileLayout(bool isDark, AsyncValue<List<ReglamentoModel>> historyAsync) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDarkCard : Colors.white,
            border: Border(bottom: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.adminReglamentoTitulo, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(l10n.adminReglamentoSubtitulo, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _openHistorySheet(context, isDark, historyAsync),
                icon: const Icon(Icons.history_rounded, size: 18),
                label: Text(l10n.adminReglamentoHistorialBtn),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : AppColors.textDark,
                  side: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _buildEditorArea(isDark, isMobile: true)),
      ],
    );
  }

  Widget _buildSidebar(bool isDark, AsyncValue<List<ReglamentoModel>> historyAsync) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        border: Border(right: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.adminReglamentoHistorialTitulo, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1)),
                Text(l10n.adminReglamentoHistorialSubtitulo, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: historyAsync.when(
              data: (history) => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: history.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final v = history[index];
                  return _HistoryTile(
                    version: v,
                    isSelected: _selectedVersion?.id == v.id,
                    onTap: () => _selectVersion(v),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text(l10n.adminReglamentoErrorCargar, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedVersion = null;
                  _versionNameController.clear();
                  _controller = QuillController.basic();
                  _isActive = true;
                });
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.adminReglamentoNuevaVersion),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorArea(bool isDark, {required bool isMobile}) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 48),
      child: Column(
        children: [
          FadeInDown(
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _versionNameController,
                        style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 22, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: l10n.adminReglamentoVersionHint,
                          hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
                          border: InputBorder.none,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.history_rounded, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedVersion != null
                                ? l10n.adminReglamentoModificandoVersion(DateFormat('dd MMMM yyyy').format(_selectedVersion!.fechaCreacion))
                                : l10n.adminReglamentoNuevaBorrador,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _ActiveToggle(value: _isActive, onChanged: (v) => setState(() => _isActive = v)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _save,
                              icon: _isLoading
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.auto_awesome_rounded, size: 16),
                              label: Text(l10n.adminReglamentoPublicar),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _versionNameController,
                              style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 32, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: l10n.adminReglamentoVersionHint,
                                hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
                                border: InputBorder.none,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.history_rounded, size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    _selectedVersion != null
                                      ? l10n.adminReglamentoModificandoVersion(DateFormat('dd MMMM yyyy').format(_selectedVersion!.fechaCreacion))
                                      : l10n.adminReglamentoNuevaBorrador,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      _ActiveToggle(
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                      ),
                      const SizedBox(width: 24),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _save,
                        icon: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.auto_awesome_rounded),
                        label: Text(l10n.adminReglamentoPublicar),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 48),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 40, offset: const Offset(0, 20))],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      border: Border(bottom: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight)),
                    ),
                    child: QuillSimpleToolbar(
                      controller: _controller,
                      config: QuillSimpleToolbarConfig(
                        showUndo: true,
                        showRedo: true,
                        showBoldButton: true,
                        showItalicButton: true,
                        showUnderLineButton: true,
                        showStrikeThrough: true,
                        showColorButton: true,
                        showBackgroundColorButton: true,
                        showListBullets: true,
                        showListNumbers: true,
                        showAlignmentButtons: true,
                        showFontSize: true,
                        showDirection: false,
                        showCodeBlock: false,
                        showLink: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 16 : 32),
                      child: QuillEditor.basic(
                        controller: _controller,
                        config: QuillEditorConfig(
                          placeholder: l10n.adminReglamentoEditorPlaceholder,
                          expands: true,
                          scrollable: true,
                          padding: const EdgeInsets.all(16),
                        ),
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

class _HistoryTile extends StatelessWidget {
  final ReglamentoModel version;
  final bool isSelected;
  final VoidCallback onTap;

  const _HistoryTile({required this.version, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(version.nombreVersion, style: TextStyle(color: isSelected ? AppColors.primary : (isDark ? Colors.white : AppColors.textDark), fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(DateFormat('dd MMM yyyy').format(version.fechaCreacion), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            if (version.activo)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.withValues(alpha: 0.2))),
                child: Text(l10n.adminReglamentoActivoBadge, style: const TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActiveToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ActiveToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: value ? Colors.green.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: value ? Colors.green.withValues(alpha: 0.2) : (isDark ? AppColors.border : AppColors.borderLight)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.adminReglamentoVersionActivaLabel, style: TextStyle(color: value ? Colors.green : AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.green,
          ),
        ],
      ),
    );
  }
}




