import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/app_router.dart';
import '../../application/providers/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';

enum LoginMode { light, dark }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  LoginMode _currentMode = LoginMode.dark;
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimationBoard;
  late Animation<double> _scaleAnimationChairs;
  late Animation<double> _opacityAnimationForm;
  late Animation<double> _logoAlignment;

  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController(text: 'admin');
  final _passwordCtrl = TextEditingController(text: 'admin123');
  bool _verPassword = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _scaleAnimationBoard = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _scaleAnimationChairs = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _opacityAnimationForm = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    _logoAlignment = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _currentMode = (_currentMode == LoginMode.dark) ? LoginMode.light : LoginMode.dark;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Disparamos la animación de "agrandar y ocultar"
    await _animationController.forward();

    // Llamamos al proceso de login
    await ref.read(authNotifierProvider.notifier).login(
      _usernameCtrl.text,
      _passwordCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final esCargando = authState.maybeWhen(loading: () => true, orElse: () => false);
    final errorMsg = authState.maybeWhen(error: (msg) => msg, orElse: () => null);

    // Si hay un error, revertimos la animación para volver a mostrar el formulario
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        error: (_) => _animationController.reverse(),
        orElse: () {},
      );
    });

    final l10n = AppLocalizations.of(context);
    final isDark = _currentMode == LoginMode.dark;
    final size = MediaQuery.of(context).size;
    final isSmall = size.height < 700;

    // Colores del gradiente premium
    final bgGradient = isDark 
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
        );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Formulario centrado con scroll
                Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Espacio dinámico para el logo superior
                          SizedBox(height: isSmall ? 160 : 200),
                          FadeTransition(
                            opacity: _opacityAnimationForm,
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    _FieldPersonalizado(
                                      controller: _usernameCtrl,
                                      hint: l10n.loginUsuario,
                                      isDark: isDark,
                                    ),
                                    const SizedBox(height: 16),
                                    _FieldPersonalizado(
                                      controller: _passwordCtrl,
                                      hint: l10n.loginContrasena,
                                      isPassword: true,
                                      obscure: !_verPassword,
                                      isDark: isDark,
                                      onToggle: () => setState(() => _verPassword = !_verPassword),
                                    ),
                                    if (errorMsg != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 24),
                                        child: FadeIn(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(errorMsg, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 13)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 40),
                                    Container(
                                      width: double.infinity,
                                      height: 58,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFF97316).withValues(alpha: 0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF97316),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          elevation: 0,
                                        ),
                                        child: Text(l10n.loginBoton, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 0.5)),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    TextButton(
                                      onPressed: () => context.push(AppRoutes.forgotPassword),
                                      child: Text(
                                        l10n.authPwdOlvidasteLink,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isDark ? Colors.blueGrey[300] : Colors.blueGrey[600],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // --- SECCIÓN LOGO (PIZARRA Y SILLAS) ---
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final alignmentMove = _logoAlignment.value * (constraints.maxHeight * 0.3);
                      return SizedBox(
                        height: constraints.maxHeight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: (isSmall ? 25 : 40) + alignmentMove),
                            Flexible(
                              child: GestureDetector(
                                onTap: _toggleMode,
                                child: Transform.scale(
                                  scale: _scaleAnimationBoard.value,
                                  child: _PizarraVisual(mode: _currentMode, isSmall: isSmall),
                                ),
                              ),
                            ),
                            SizedBox(height: isSmall ? 8 : 12),
                            Transform.scale(
                              scale: _scaleAnimationChairs.value,
                              child: _SillasVisual(isSmall: isSmall),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // --- MODO DE CARGA ---
                if (esCargando)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(color: Color(0xFFF97316), strokeWidth: 5),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PizarraVisual extends StatelessWidget {
  final LoginMode mode;
  final bool isSmall;
  const _PizarraVisual({required this.mode, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    final isDark = mode == LoginMode.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: isDark ? Colors.white : const Color(0xFF1B4332),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0xFFD4AF37).withValues(alpha: 0.6) : Colors.orange.withValues(alpha: 0.6),
            blurRadius: 30,
            spreadRadius: 5,
          )
        ],
      ),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 500),
        crossFadeState: isDark ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: Image.asset('assets/images/pizarra_dark.png', width: isSmall ? 220 : 280),
        secondChild: Image.asset('assets/images/pizarra_light.png', width: isSmall ? 220 : 280),
      ),
    );
  }
}

class _SillasVisual extends StatelessWidget {
  final bool isSmall;
  const _SillasVisual({this.isSmall = false});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmall ? 8 : 12),
        child: Image.asset('assets/images/silla.png', width: isSmall ? 55 : 65, height: isSmall ? 55 : 65),
      )),
    );
  }
}

class _FieldPersonalizado extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDark;
  final bool isPassword;
  final bool obscure;
  final VoidCallback? onToggle;

  const _FieldPersonalizado({
    required this.controller,
    required this.hint,
    required this.isDark,
    this.isPassword = false,
    this.obscure = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
        filled: true,
        fillColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
        suffixIcon: isPassword
          ? Padding(
            padding: const EdgeInsets.only(right: 8, left: 8), 
            child: IconButton(icon: Icon(obscure ? Icons.visibility : Icons.visibility_off, color: Colors.grey), onPressed: onToggle)
          ) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),//isDark ? BorderSide.none : BorderSide(color: Colors.grey[300]!)),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
