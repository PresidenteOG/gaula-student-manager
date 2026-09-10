import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../l10n/app_localizations.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';

class CambiarPasswordDialog extends ConsumerStatefulWidget {
  const CambiarPasswordDialog({super.key});

  @override
  ConsumerState<CambiarPasswordDialog> createState() => _CambiarPasswordDialogState();
}

class _CambiarPasswordDialogState extends ConsumerState<CambiarPasswordDialog> {
  final _actualCtrl  = TextEditingController();
  final _nuevaCtrl   = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  bool _showActual = false;
  bool _showNueva  = false;
  String? _error;

  @override
  void dispose() {
    _actualCtrl.dispose();
    _nuevaCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _error = null; });

    if (_actualCtrl.text.isEmpty || _nuevaCtrl.text.isEmpty || _confirmCtrl.text.isEmpty) {
      setState(() => _error = 'Completa todos los campos');
      return;
    }
    if (_nuevaCtrl.text.length < 6) {
      setState(() => _error = 'La nueva contraseña debe tener al menos 6 caracteres');
      return;
    }
    if (_nuevaCtrl.text != _confirmCtrl.text) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }

    setState(() => _loading = true);

    try {
      final dio = ref.read(dioClientProvider);
      await dio.post(ApiConstants.changePassword, data: {
        'passwordActual': _actualCtrl.text,
        'nuevaPassword':  _nuevaCtrl.text,
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).authPwdActualizadaOk), backgroundColor: Colors.green),
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['mensaje'] ?? e.response?.data?['error'] ?? 'Contraseña actual incorrecta';
      setState(() { _error = msg; _loading = false; });
    } catch (e) {
      setState(() { _error = 'Error inesperado. Inténtalo de nuevo.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Dialog(
      backgroundColor: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.lock_reset, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context).cambiarPasswordTitulo, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(AppLocalizations.of(context).cambiarPasswordDesc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),

              _PasswordField(label: AppLocalizations.of(context).dialogContrasenyaActual, ctrl: _actualCtrl, show: _showActual,
                onToggle: () => setState(() => _showActual = !_showActual), isDark: isDark),
              const SizedBox(height: 16),
              _PasswordField(label: AppLocalizations.of(context).dialogNovaContrasenya, ctrl: _nuevaCtrl, show: _showNueva,
                onToggle: () => setState(() => _showNueva = !_showNueva), isDark: isDark),
              const SizedBox(height: 16),
              _PasswordField(label: AppLocalizations.of(context).dialogConfirmarNovaContrasenya, ctrl: _confirmCtrl, show: _showNueva,
                onToggle: () => setState(() => _showNueva = !_showNueva), isDark: isDark),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red.withValues(alpha: 0.3))),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13))),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _loading ? null : () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context).cancelar, style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(AppLocalizations.of(context).actualizar, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool show;
  final VoidCallback onToggle;
  final bool isDark;

  const _PasswordField({required this.label, required this.ctrl, required this.show, required this.onToggle, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final fillColor = isDark ? AppColors.backgroundDarkSurface : const Color(0xFFF3F4F6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: !show,
          style: TextStyle(color: isDark ? Colors.white : AppColors.textDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            suffixIcon: IconButton(
              icon: Icon(show ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary, size: 20),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

// Convenience function to show dialog
void showCambiarPasswordDialog(BuildContext context) {
  showDialog(context: context, builder: (_) => const CambiarPasswordDialog());
}

