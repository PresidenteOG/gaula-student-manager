import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../core/constants/app_colors.dart';
import '../../features/admin/infrastructure/repositories/reglamento_repository.dart';
import '../../l10n/app_localizations.dart';

class ReglamentoViewerScreen extends ConsumerStatefulWidget {
  const ReglamentoViewerScreen({super.key});

  @override
  ConsumerState<ReglamentoViewerScreen> createState() => _ReglamentoViewerScreenState();
}

class _ReglamentoViewerScreenState extends ConsumerState<ReglamentoViewerScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final reglamentoAsync = ref.watch(reglamentoActivoProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).reglamentoCentro, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: reglamentoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('${AppLocalizations.of(context).errorGenerico}: $e')),
        data: (reglamento) {
          final content = reglamento.contenido;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Container(
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 30, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.gavel_rounded, color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).normativaVigente, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2)),
                              Text(reglamento.nombreVersion, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          const Spacer(),
                          Text(AppLocalizations.of(context).versionActualizada, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 32),
                      _buildContent(content, textColor),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildContent(String content, Color textColor) {
    try {
      final doc = quill.Document.fromJson(jsonDecode(content));
      return quill.QuillEditor.basic(
        controller: quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
          readOnly: true,
        ),
        config: const quill.QuillEditorConfig(
          autoFocus: false,
          expands: false,
          padding: EdgeInsets.zero,
          scrollable: false,
        ),
      );
    } catch (e) {
      return SelectableText(
        content,
        style: TextStyle(color: textColor, fontSize: 16, height: 1.8),
      );
    }
  }
}


