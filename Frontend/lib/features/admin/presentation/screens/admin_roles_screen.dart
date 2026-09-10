import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/providers/config_provider.dart';
import '../../../../shared/widgets/gaula_toast.dart';

class AdminRolesScreen extends ConsumerStatefulWidget {
  const AdminRolesScreen({super.key});

  @override
  ConsumerState<AdminRolesScreen> createState() => _AdminRolesScreenState();
}

class _AdminRolesScreenState extends ConsumerState<AdminRolesScreen> {
  final _ctrl = TextEditingController();
  List<String>? _roles;

  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(rolesListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FadeInUp(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.adminRolesTitle, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: isMobile ? 22 : 32, fontWeight: FontWeight.bold, letterSpacing: -1)),
                        Text(l10n.adminRolesSubtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: isMobile ? 12 : 16)),
                      ],
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _roles == null ? null : _saveChanges,
                      icon: const Icon(Icons.save_rounded),
                      label: Text(l10n.adminRolesSaveButton),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ],
              ),
              if (isMobile) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _roles == null ? null : _saveChanges,
                    icon: const Icon(Icons.save_rounded),
                    label: Text(l10n.adminRolesSaveButton),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
              SizedBox(height: isMobile ? 24 : 40),

              Expanded(
                child: isMobile
                    ? _buildMobileLayout(context, rolesAsync, isDark, l10n)
                    : _buildDesktopLayout(context, rolesAsync, isDark, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AsyncValue<List<String>> rolesAsync, bool isDark, AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildRolesList(context, rolesAsync, isDark, l10n),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 1,
          child: _buildAddForm(context, isDark, l10n),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AsyncValue<List<String>> rolesAsync, bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 400,
            child: _buildRolesList(context, rolesAsync, isDark, l10n),
          ),
          const SizedBox(height: 24),
          _buildAddForm(context, isDark, l10n),
        ],
      ),
    );
  }

  Widget _buildRolesList(BuildContext context, AsyncValue<List<String>> rolesAsync, bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 20))],
      ),
      child: rolesAsync.when(
        data: (roles) {
          _roles ??= List.from(roles);
          return ListView.separated(
            itemCount: _roles!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final r = _roles![index];
              final isSystem = r == 'Admin' || r == 'Teacher' || r == 'Student';
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                      child: Icon(isSystem ? Icons.verified_user_rounded : Icons.person_add_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(r, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    if (isSystem)
                      _Badge(label: l10n.adminRolesBadgeSystem, color: Colors.blueAccent)
                    else
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        onPressed: () => setState(() => _roles!.remove(r)),
                      ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.adminRolesErrorPrefix(e.toString()), style: TextStyle(color: isDark ? Colors.white : AppColors.textDark))),
      ),
    );
  }

  Widget _buildAddForm(BuildContext context, bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.adminRolesNewProfileTitle, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(l10n.adminRolesNewProfileDesc, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 40),
          TextField(
            controller: _ctrl,
            style: TextStyle(color: isDark ? Colors.white : AppColors.textDark),
            decoration: InputDecoration(
              labelText: l10n.adminRolesFieldLabel,
              labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
              filled: true,
              fillColor: isDark ? AppColors.backgroundDarkSurface : Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(24),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_ctrl.text.isNotEmpty && _roles != null && !_roles!.contains(_ctrl.text)) {
                setState(() => _roles!.add(_ctrl.text));
                _ctrl.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(l10n.adminRolesAddButton),
          ),
          const SizedBox(height: 24),
          _InfoBox(text: l10n.adminRolesInfoBox),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    final l10n = AppLocalizations.of(context);
    final ok = await ref.read(systemConfigProvider.notifier).saveConfig('roles_list', _roles);
    if (!mounted) return;
    if (ok) {
      ref.invalidate(rolesListProvider);
      GaulaToast.show(context, title: l10n.adminRolesToastSuccessTitle, message: l10n.adminRolesToastSuccessMessage, type: GaulaToastType.success);
    } else {
      GaulaToast.show(context, title: l10n.adminRolesToastErrorTitle, message: l10n.adminRolesToastErrorMessage, type: GaulaToastType.error);
    }
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String text;
  const _InfoBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.warning.withValues(alpha: 0.1))),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.warning),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: TextStyle(color: AppColors.warning.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}





