import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/providers/alumnos_provider.dart';

import '../../domain/entities/alumno_model.dart';

class AddAlumnoDialog extends ConsumerStatefulWidget {
  final AlumnoModel? alumno;
  const AddAlumnoDialog({this.alumno, super.key});

  @override
  ConsumerState<AddAlumnoDialog> createState() => _AddAlumnoDialogState();
}

class _AddAlumnoDialogState extends ConsumerState<AddAlumnoDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _apellidosCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _dniCtrl;
  late final TextEditingController _telefonoCtrl;
  late final TextEditingController _direccionCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _passwordCtrl;

  DateTime? _fechaNacimiento;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.alumno?.nombre ?? '');
    _apellidosCtrl =
        TextEditingController(text: widget.alumno?.apellidos ?? '');
    _emailCtrl = TextEditingController(text: widget.alumno?.email ?? '');
    _dniCtrl = TextEditingController(text: widget.alumno?.dni ?? '');
    _telefonoCtrl = TextEditingController(text: widget.alumno?.telefono ?? '');
    _direccionCtrl =
        TextEditingController(text: widget.alumno?.direccion ?? '');
    _usernameCtrl = TextEditingController(text: widget.alumno?.username ?? '');
    _passwordCtrl = TextEditingController(text: 'alumno');
    if (widget.alumno?.fechaNacimiento != null) {
      _fechaNacimiento = DateTime.tryParse(widget.alumno!.fechaNacimiento!);
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidosCtrl.dispose();
    _emailCtrl.dispose();
    _dniCtrl.dispose();
    _telefonoCtrl.dispose();
    _direccionCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
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
      'dni': _dniCtrl.text,
      'telefono': _telefonoCtrl.text,
      'direccion': _direccionCtrl.text,
      'fechaNacimiento': _fechaNacimiento?.toIso8601String().split('T')[0],
      'password': _passwordCtrl.text.isEmpty ? 'alumno' : _passwordCtrl.text,
    };

    final success = widget.alumno != null
        ? await ref
            .read(alumnosCrudProvider.notifier)
            .actualizar(widget.alumno!.id, data)
        : await ref.read(alumnosCrudProvider.notifier).crear(data);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.addAlumnoSuccessRegistrado),
            backgroundColor: Colors.green),
      );
    } else if (mounted) {
      final errorState = ref.read(alumnosCrudProvider);
      String errorMessage = l10n.addAlumnoErrorRegistrar;
      if (errorState.hasError) {
        final err = errorState.error;
        if (err is DioException && err.response?.data is Map) {
          final responseData = err.response!.data as Map;
          if (responseData['errores'] != null) {
            errorMessage = (responseData['errores'] as Map).values.join('\n');
          } else if (responseData['mensaje'] != null) {
            errorMessage = responseData['mensaje'].toString();
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ $errorMessage'), backgroundColor: Colors.red),
      );
    }
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
    if (_nombreCtrl.text.isEmpty) return 'alumno';
    final n = _sanitize(_nombreCtrl.text.split(' ')[0].toLowerCase());
    final a = _apellidosCtrl.text.split(' ')[0].toLowerCase();
    return '$n.${_sanitize(a)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final isSaving = ref.watch(alumnosCrudProvider).isLoading;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Dialog(
      backgroundColor: bg,
      insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 40, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 700,
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
                                widget.alumno != null
                                    ? l10n.addAlumnoEditTitle
                                    : l10n.addAlumnoAddTitle,
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                widget.alumno != null
                                    ? l10n.addAlumnoEditSubtitle
                                    : l10n.addAlumnoAddSubtitle,
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

                    Text(l10n.addAlumnoSectionPersonal,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 1)),
                    const SizedBox(height: 16),

                    isMobile
                        ? Column(
                            children: [
                              _FormField(
                                  controller: _nombreCtrl,
                                  label: l10n.addAlumnoFieldNombre,
                                  hint: l10n.addAlumnoHintNombre,
                                  isDark: isDark,
                                  textColor: textColor),
                              const SizedBox(height: 16),
                              _FormField(
                                  controller: _apellidosCtrl,
                                  label: l10n.addAlumnoFieldApellidos,
                                  hint: l10n.addAlumnoHintApellidos,
                                  isDark: isDark,
                                  textColor: textColor),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                  child: _FormField(
                                      controller: _nombreCtrl,
                                      label: l10n.addAlumnoFieldNombre,
                                      hint: l10n.addAlumnoHintNombre,
                                      isDark: isDark,
                                      textColor: textColor)),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: _FormField(
                                      controller: _apellidosCtrl,
                                      label: l10n.addAlumnoFieldApellidos,
                                      hint: l10n.addAlumnoHintApellidos,
                                      isDark: isDark,
                                      textColor: textColor)),
                            ],
                          ),
                    const SizedBox(height: 16),

                    isMobile
                        ? Column(
                            children: [
                              _FormField(
                                  controller: _dniCtrl,
                                  label: l10n.addAlumnoFieldDni,
                                  hint: '12345678A',
                                  isDark: isDark,
                                  textColor: textColor),
                              const SizedBox(height: 16),
                              _buildBirthDatePicker(isDark, textColor, l10n),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                  child: _FormField(
                                      controller: _dniCtrl,
                                      label: l10n.addAlumnoFieldDni,
                                      hint: '12345678A',
                                      isDark: isDark,
                                      textColor: textColor)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildBirthDatePicker(isDark, textColor, l10n),
                              ),
                            ],
                          ),
                    const SizedBox(height: 32),

                    Text(l10n.addAlumnoSectionContacto,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 1)),
                    const SizedBox(height: 16),

                    isMobile
                        ? Column(
                            children: [
                              _FormField(
                                  controller: _emailCtrl,
                                  label: l10n.addAlumnoFieldEmail,
                                  hint: l10n.addAlumnoHintEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  isDark: isDark,
                                  textColor: textColor),
                              const SizedBox(height: 16),
                              _FormField(
                                  controller: _usernameCtrl,
                                  label: l10n.addAlumnoFieldUsuario,
                                  hint: l10n.addAlumnoHintUsuario,
                                  isDark: isDark,
                                  textColor: textColor),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                  child: _FormField(
                                      controller: _emailCtrl,
                                      label: l10n.addAlumnoFieldEmail,
                                      hint: l10n.addAlumnoHintEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      isDark: isDark,
                                      textColor: textColor)),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: _FormField(
                                      controller: _usernameCtrl,
                                      label: l10n.addAlumnoFieldUsuario,
                                      hint: l10n.addAlumnoHintUsuario,
                                      isDark: isDark,
                                      textColor: textColor)),
                            ],
                          ),
                    const SizedBox(height: 16),

                    isMobile
                        ? Column(
                            children: [
                              _FormField(
                                  controller: _passwordCtrl,
                                  label: l10n.addAlumnoFieldPassword,
                                  hint: l10n.addAlumnoHintPassword,
                                  isPassword: true,
                                  isDark: isDark,
                                  textColor: textColor),
                              const SizedBox(height: 16),
                              _FormField(
                                controller: _telefonoCtrl,
                                label: l10n.addAlumnoFieldTelefono,
                                hint: l10n.addAlumnoHintTelefono,
                                isDark: isDark,
                                textColor: textColor),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                  child: _FormField(
                                      controller: _passwordCtrl,
                                      label: l10n.addAlumnoFieldPassword,
                                      hint: l10n.addAlumnoHintPassword,
                                      isPassword: true,
                                      isDark: isDark,
                                      textColor: textColor)),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: _FormField(
                                      controller: _telefonoCtrl,
                                      label: l10n.addAlumnoFieldTelefono,
                                      hint: l10n.addAlumnoHintTelefono,
                                      isDark: isDark,
                                      textColor: textColor)),
                            ],
                          ),
                    const SizedBox(height: 16),
                    _FormField(
                        controller: _direccionCtrl,
                        label: l10n.addAlumnoFieldDireccion,
                        hint: l10n.addAlumnoHintDireccion,
                        isDark: isDark,
                        textColor: textColor),

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
                                      : Text(widget.alumno != null
                                          ? l10n.addAlumnoButtonGuardar
                                          : l10n.addAlumnoButtonRegistrar),
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
                                  child: Text(l10n.addAlumnoButtonCancelar),
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
                                  child: Text(l10n.addAlumnoButtonCancelar),
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
                                      : Text(widget.alumno != null
                                          ? l10n.addAlumnoButtonGuardar
                                          : l10n.addAlumnoButtonRegistrar),
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

  Widget _buildBirthDatePicker(bool isDark, Color textColor, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.addAlumnoFieldFechaNacimiento,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(2005),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                      primary: AppColors.primary,
                      onPrimary: Colors.white,
                      surface: AppColors.backgroundDarkCard,
                      onSurface: Colors.white),
                ),
                child: child!,
              ),
            );
            if (picked != null) {
              setState(() => _fechaNacimiento = picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.backgroundDarkSurface
                  : AppColors.backgroundLightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isDark ? AppColors.border : AppColors.borderLight),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 16,
                    color: _fechaNacimiento == null
                        ? AppColors.textSecondary
                        : AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  _fechaNacimiento == null
                      ? l10n.addAlumnoSeleccionarFecha
                      : '${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}',
                  style: TextStyle(
                      color: _fechaNacimiento == null
                          ? AppColors.textSecondary
                          : textColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isDark;
  final Color textColor;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.isDark,
    required this.textColor,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
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
          obscureText: isPassword,
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
              return l10n.addAlumnoCampoObligatorio;
            }
            return null;
          },
        ),
      ],
    );
  }
}

