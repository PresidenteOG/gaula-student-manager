import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/api_constants.dart';

import '../../../core/constants/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/providers/auth_provider.dart';
import '../../auth/infrastructure/repositories/auth_repository.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/widgets/cambiar_password_dialog.dart';
import '../../../l10n/app_localizations.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _dniCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  /// Errores field-level devueltos por el backend (campo → mensaje).
  final Map<String, String> _serverErrors = {};

  bool _loading = true;
  bool _saving = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  /// Carga los datos reales del perfil desde el backend (GET /api/profile).
  Future<void> _cargarPerfil() async {
    try {
      final data = await ref.read(authNotifierProvider.notifier).fetchProfile();
      if (!mounted) return;
      setState(() {
        _nameCtrl.text = (data['nombre'] ?? '').toString();
        _apellidosCtrl.text = (data['apellidos'] ?? '').toString();
        _dniCtrl.text = (data['dni'] ?? '').toString();
        _birthCtrl.text = _isoADisplay((data['fechaNacimiento'] ?? '').toString());
        _emailCtrl.text = (data['email'] ?? '').toString();
        _phoneCtrl.text = (data['telefono'] ?? '').toString();
        _addressCtrl.text = (data['direccion'] ?? '').toString();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e is AuthException ? e.mensaje : 'No se pudo cargar el perfil';
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _apellidosCtrl.dispose();
    _dniCtrl.dispose();
    _birthCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  // ── Conversión de fecha dd/MM/yyyy ↔ ISO yyyy-MM-dd ───────────────────────
  String _isoADisplay(String iso) {
    if (iso.isEmpty) return '';
    final p = iso.split('T').first.split('-'); // tolera "1985-06-15" o ISO datetime
    if (p.length != 3) return '';
    return '${p[2]}/${p[1]}/${p[0]}';
  }

  String? _displayAIso(String display) {
    final d = display.trim();
    if (d.isEmpty) return null;
    final p = d.split('/');
    if (p.length != 3) return null;
    final dia = p[0].padLeft(2, '0');
    final mes = p[1].padLeft(2, '0');
    final anio = p[2];
    if (anio.length != 4) return null;
    return '$anio-$mes-$dia';
  }

  Future<void> _saveChanges() async {
    final l10n = AppLocalizations.of(context);

    // Validación total client-side antes de cualquier petición.
    setState(() => _serverErrors.clear());
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final payload = <String, dynamic>{
        'nombre': _nameCtrl.text.trim(),
        'apellidos': _apellidosCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'dni': _dniCtrl.text.trim(),
        'telefono': _phoneCtrl.text.trim(),
        'direccion': _addressCtrl.text.trim(),
        'fechaNacimiento': _displayAIso(_birthCtrl.text),
      };

      await ref.read(authNotifierProvider.notifier).updatePerfil(payload);

      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('✅ ${l10n.userProfileGuardado}'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } on ValidationException catch (e) {
      // Errores field-level: mapear al formulario y re-validar para mostrarlos.
      if (!mounted) return;
      setState(() {
        _saving = false;
        _serverErrors
          ..clear()
          ..addAll(e.errores);
      });
      _formKey.currentState!.validate();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      final msg = e is AuthException ? e.mensaje : 'Error al guardar el perfil';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ $msg'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  // ── Validadores (validación total) ────────────────────────────────────────
  String? _vRequerido(String? v, String campo) =>
      (v == null || v.trim().isEmpty) ? '$campo es obligatorio' : null;

  String? _vEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'El email es obligatorio';
    final re = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    return re.hasMatch(v.trim()) ? null : 'Email con formato inválido';
  }

  String? _vDni(String? v) {
    if (v == null || v.trim().isEmpty) return null; // opcional
    final re = RegExp(r'^[0-9XYZ][0-9]{7}[A-Za-z]$');
    return re.hasMatch(v.trim()) ? null : 'DNI/NIE inválido (ej: 12345678A)';
  }

  String? _vTelefono(String? v) {
    if (v == null || v.trim().isEmpty) return null; // opcional
    final re = RegExp(r'^[+]?[0-9 ]{6,20}$');
    return re.hasMatch(v.trim()) ? null : 'Teléfono inválido';
  }

  String? _vFecha(String? v) {
    if (v == null || v.trim().isEmpty) return null; // opcional
    final iso = _displayAIso(v);
    if (iso == null) return 'Usa el formato dd/MM/yyyy';
    final fecha = DateTime.tryParse(iso);
    if (fecha == null) return 'Fecha inválida';
    if (!fecha.isBefore(DateTime.now())) return 'Debe ser una fecha pasada';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    if (_loadError != null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('⚠️ $_loadError', style: const TextStyle(color: Colors.red, fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () { setState(() { _loading = true; _loadError = null; }); _cargarPerfil(); },
                child: Text(l10n.reintentar),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Form(
              key: _formKey,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.userProfileMisDatos, style: TextStyle(color: textColor, fontSize: 36, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(l10n.userProfileSubtitulo, style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontSize: 14), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _saving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(l10n.guardar, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Profile Pic Block
                FadeInUp(
                  child: _ProfileSection(
                    child: Column(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final user = ref.watch(usuarioActualProvider);
                            final avatar = user?.avatar ?? '';
                            final isEmoji = avatar.length < 10 && !avatar.contains('.');

                            return CircleAvatar(
                              radius: 64,
                              backgroundColor: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface,
                              backgroundImage: isEmoji ? null : NetworkImage('${ApiConstants.uploadsBaseUrl}$avatar'),
                              child: isEmoji 
                                ? Text(avatar.isEmpty ? '👤' : avatar, style: const TextStyle(fontSize: 48))
                                : null,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
                            if (image != null) {
                              final bytes = await image.readAsBytes();
                              await ref.read(authNotifierProvider.notifier).updateAvatar(bytes, image.name);
                              
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('✅ ${l10n.userProfileFotoActualizada}')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(l10n.perfilCambiarFoto),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Personal Info Block
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: _DataSection(
                    title: l10n.userProfileInfoPersonal,
                    icon: Icons.person_outline,
                    iconColor: AppColors.primary,
                    child: Column(
                      children: [
                        _InputField(
                          label: l10n.alumnoNombre,
                          controller: _nameCtrl,
                          validator: (v) => _vRequerido(v, l10n.alumnoNombre),
                          errorText: _serverErrors['nombre'],
                        ),
                        const SizedBox(height: 16),
                        _InputField(
                          label: l10n.alumnoApellidos,
                          controller: _apellidosCtrl,
                          validator: (v) => _vRequerido(v, l10n.alumnoApellidos),
                          errorText: _serverErrors['apellidos'],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _InputField(
                                label: l10n.userProfileDniNie,
                                controller: _dniCtrl,
                                validator: _vDni,
                                errorText: _serverErrors['dni'],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _InputField(
                                label: l10n.userProfileFechaNacimiento,
                                controller: _birthCtrl,
                                keyboardType: TextInputType.datetime,
                                validator: _vFecha,
                                errorText: _serverErrors['fechaNacimiento'],
                                suffixIcon: Icon(Icons.calendar_today, color: isDark ? AppColors.textSecondary : AppColors.textMuted, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Contact Info Block
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _DataSection(
                    title: l10n.userProfileInfoContacto,
                    icon: Icons.mail_outline,
                    iconColor: AppColors.accent,
                    child: Column(
                      children: [
                        _InputField(
                          label: l10n.alumnoEmail,
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          validator: _vEmail,
                          errorText: _serverErrors['email'],
                        ),
                        const SizedBox(height: 16),
                        _InputField(
                          label: l10n.userProfileTelefono,
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          validator: _vTelefono,
                          errorText: _serverErrors['telefono'],
                        ),
                        const SizedBox(height: 16),
                        _InputField(
                          label: l10n.userProfileDireccion,
                          controller: _addressCtrl,
                          errorText: _serverErrors['direccion'],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Security Section
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: _DataSection(
                    title: l10n.userProfileSeguridad,
                    icon: Icons.security,
                    iconColor: AppColors.accent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.userProfileSeguridadDesc,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            showCambiarPasswordDialog(context);
                          },
                          icon: const Icon(Icons.lock_reset),
                          label: Text(l10n.userProfileCambiarPassword),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final Widget child;
  const _ProfileSection({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: child,
    );
  }
}

class _DataSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  const _DataSection({required this.title, required this.icon, required this.iconColor, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Text(title, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  /// Error field-level proveniente del backend (tiene prioridad sobre el validator).
  final String? errorText;

  const _InputField({
    required this.label,
    required this.controller,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor, fontSize: 16),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // El error del backend tiene prioridad; si no, se usa el validator client-side.
          validator: (v) {
            if (errorText != null && errorText!.isNotEmpty) return errorText;
            return validator?.call(v);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

