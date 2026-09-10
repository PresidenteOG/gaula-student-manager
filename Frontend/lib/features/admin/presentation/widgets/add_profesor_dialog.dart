import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/providers/profesores_provider.dart';
import '../../domain/entities/profesor_model.dart';

class AddProfesorDialog extends ConsumerStatefulWidget {
  final ProfesorModel? profesor;
  const AddProfesorDialog({this.profesor, super.key});

  @override
  ConsumerState<AddProfesorDialog> createState() => _AddProfesorDialogState();
}

class _AddProfesorDialogState extends ConsumerState<AddProfesorDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _apellidosCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _especialidadesCtrl;

  String _selectedRol = 'TEACHER';

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.profesor?.nombre ?? '');
    _apellidosCtrl =
        TextEditingController(text: widget.profesor?.apellidos ?? '');
    _emailCtrl = TextEditingController(text: widget.profesor?.email ?? '');
    _usernameCtrl =
        TextEditingController(text: widget.profesor?.username ?? '');
    _especialidadesCtrl =
        TextEditingController(text: widget.profesor?.especialidades ?? '');

    if (widget.profesor != null) {
      _selectedRol =
          widget.profesor!.rol.toUpperCase() == 'ADMIN' ? 'ADMIN' : 'TEACHER';
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidosCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _especialidadesCtrl.dispose();
    super.dispose();
  }

  String _sanitize(String text) {
    return text
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'[^a-z0-9._-]'), '');
  }

  String _generarUsername() {
    if (_usernameCtrl.text.isNotEmpty) {
      return _sanitize(_usernameCtrl.text.toLowerCase());
    }
    if (_nombreCtrl.text.isEmpty) return 'profesor';
    final n = _sanitize(_nombreCtrl.text.split(' ')[0].toLowerCase());
    final a = _apellidosCtrl.text.split(' ')[0].toLowerCase();
    return '$n.${_sanitize(a)}';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);

    final data = {
      'nombre': _nombreCtrl.text,
      'apellidos': _apellidosCtrl.text,
      'username':
          _usernameCtrl.text.isEmpty ? _generarUsername() : _usernameCtrl.text,
      'email': _emailCtrl.text,
      'especialidades': _especialidadesCtrl.text,
      'rol': _selectedRol,
      'password': 'gaula123',
    };

    final success = widget.profesor != null
        ? await ref
            .read(profesoresCrudProvider.notifier)
            .actualizar(widget.profesor!.id, data)
        : await ref.read(profesoresCrudProvider.notifier).crear(data);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(widget.profesor != null
                ? l10n.addProfesorSuccessActualizado
                : l10n.addProfesorSuccessRegistrado),
            backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isSaving = ref.watch(profesoresCrudProvider).isLoading;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Dialog(
      backgroundColor: bg,
      insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 40, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 640,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: FadeInUp(
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: isDark ? AppColors.border : AppColors.borderLight),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20)
                    ],
            ),
            padding: EdgeInsets.all(isMobile ? 20 : 32),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                widget.profesor != null
                                    ? l10n.addProfesorEditTitle
                                    : l10n.addProfesorAddTitle,
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                widget.profesor != null
                                    ? l10n.addProfesorEditSubtitle
                                    : l10n.addProfesorAddSubtitle,
                                style: TextStyle(
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : AppColors.textMuted,
                                    fontSize: 14)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: AppColors.textSecondary),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _FormField(
                        controller: _nombreCtrl,
                        label: l10n.addProfesorFieldNombre,
                        hint: l10n.addProfesorHintNombre,
                        isDark: isDark,
                        textColor: textColor),
                    const SizedBox(height: 16),
                    _FormField(
                        controller: _apellidosCtrl,
                        label: l10n.addProfesorFieldApellidos,
                        hint: l10n.addProfesorHintApellidos,
                        isDark: isDark,
                        textColor: textColor),
                    const SizedBox(height: 16),
                    _FormField(
                        controller: _emailCtrl,
                        label: l10n.addProfesorFieldEmail,
                        hint: l10n.addProfesorHintEmail,
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                        textColor: textColor),
                    const SizedBox(height: 16),
                    _FormField(
                        controller: _especialidadesCtrl,
                        label: l10n.addProfesorFieldEspecialidades,
                        hint: l10n.addProfesorHintEspecialidades,
                        isDark: isDark,
                        textColor: textColor),
                    const SizedBox(height: 24),
                    // Text(l10n.addProfesorFieldRol,
                    //     style: TextStyle(
                    //         color: textColor,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 14)),
                    // const SizedBox(height: 8),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   decoration: BoxDecoration(
                    //     color: isDark
                    //         ? AppColors.backgroundDarkSurface
                    //         : AppColors.backgroundLightSurface,
                    //     borderRadius: BorderRadius.circular(12),
                    //     border: Border.all(
                    //         color: isDark
                    //             ? AppColors.border
                    //             : AppColors.borderLight),
                    //   ),
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton<String>(
                    //       value: _selectedRol,
                    //       dropdownColor: isDark
                    //           ? AppColors.backgroundDarkCard
                    //           : Colors.white,
                    //       icon: const Icon(Icons.keyboard_arrow_down,
                    //           color: AppColors.textSecondary),
                    //       isExpanded: true,
                    //       style: TextStyle(color: textColor, fontSize: 16),
                    //       items: [
                    //         DropdownMenuItem(
                    //             value: 'TEACHER',
                    //             child: Text(l10n.addProfesorRolDocente,
                    //                 style: TextStyle(color: textColor))),
                    //         DropdownMenuItem(
                    //             value: 'ADMIN',
                    //             child: Text(l10n.addProfesorRolAdmin,
                    //                 style: TextStyle(color: textColor))),
                    //       ],
                    //       onChanged: (val) {
                    //         if (val != null) {
                    //           setState(() => _selectedRol = val);
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 48),
                    isMobile
                        ? Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isSaving ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  child: isSaving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white))
                                      : Text(widget.profesor != null
                                          ? l10n.addProfesorButtonGuardar
                                          : l10n.addProfesorButtonRegistrar),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: textColor,
                                    side: BorderSide(
                                        color: isDark
                                            ? AppColors.border
                                            : AppColors.borderLight),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(l10n.addProfesorButtonCancelar),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: textColor,
                                    side: BorderSide(
                                        color: isDark
                                            ? AppColors.border
                                            : AppColors.borderLight),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(l10n.addProfesorButtonCancelar),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isSaving ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  child: isSaving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white))
                                      : Text(widget.profesor != null
                                          ? l10n.addProfesorButtonGuardar
                                          : l10n.addProfesorButtonRegistrar),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool isDark;
  final Color textColor;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.isDark,
    required this.textColor,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: isDark
                ? AppColors.backgroundDarkSurface
                : AppColors.backgroundLightSurface,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: isDark ? AppColors.border : AppColors.borderLight)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: isDark ? AppColors.border : AppColors.borderLight)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (val) {
            if (label.contains('*') && (val == null || val.isEmpty)) {
              return l10n.addProfesorCampoObligatorio;
            }
            if (label.contains('Email') && val != null && val.isNotEmpty) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(val)) {
                return l10n.addProfesorEmailInvalido;
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}

