import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/providers/config_provider.dart';
import '../../../../shared/widgets/gaula_toast.dart';

class AdminPermissionsScreen extends ConsumerStatefulWidget {
  const AdminPermissionsScreen({super.key});

  @override
  ConsumerState<AdminPermissionsScreen> createState() => _AdminPermissionsScreenState();
}

class _AdminPermissionsScreenState extends ConsumerState<AdminPermissionsScreen> {
  Map<String, List<String>>? _matrix;

  List<String> _allPermissions(AppLocalizations l10n) => [
    l10n.adminPermPermGestionAcademica,
    l10n.adminPermPermPasarLista,
    l10n.adminPermPermVerHistorial,
    l10n.adminPermPermCrearIncidencias,
    l10n.adminPermPermBorrarRegistros,
    l10n.adminPermPermConfigurarSistema,
    l10n.adminPermPermEditarPerfiles,
    l10n.adminPermPermExportarDatos,
  ];

  @override
  Widget build(BuildContext context) {
    final matrixAsync = ref.watch(permissionsMatrixProvider);
    final rolesAsync = ref.watch(rolesListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;
    final allPermissions = _allPermissions(l10n);

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
                        Text(l10n.adminPermTitle, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: isMobile ? 22 : 32, fontWeight: FontWeight.bold, letterSpacing: -1)),
                        Text(l10n.adminPermSubtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: isMobile ? 13 : 16)),
                      ],
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _matrix == null ? null : _saveChanges,
                      icon: const Icon(Icons.sync_lock_rounded),
                      label: Text(l10n.adminPermSyncButton),
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
                    onPressed: _matrix == null ? null : _saveChanges,
                    icon: const Icon(Icons.sync_lock_rounded),
                    label: Text(l10n.adminPermSyncButton),
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
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDarkCard : Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight, width: 2),
                    boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 20))],
                  ),
                  child: matrixAsync.when(
                    data: (matrix) {
                      _matrix ??= Map.from(matrix.map((key, value) => MapEntry(key, List<String>.from(value))));
                      return rolesAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text(l10n.adminPermErrorPrefix(e.toString()), style: TextStyle(color: isDark ? Colors.white : AppColors.textDark))),
                        data: (roles) {
                          if (isMobile) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: ListView.builder(
                                itemCount: roles.length,
                                itemBuilder: (context, index) {
                                  final role = roles[index];
                                  final isAdmin = role == 'Admin';
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 36, height: 36,
                                                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                                                  child: Center(child: Text(role[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(role, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                          Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: allPermissions.map((p) {
                                                final hasPerm = _matrix![role]?.contains(p) ?? false;
                                                final checked = isAdmin || hasPerm;
                                                return FilterChip(
                                                  label: Text(p, style: TextStyle(fontSize: 12, color: checked ? Colors.white : (isDark ? Colors.white70 : AppColors.textDark))),
                                                  selected: checked,
                                                  onSelected: isAdmin ? null : (val) {
                                                    setState(() {
                                                      if (val) {
                                                        _matrix![role] ??= [];
                                                        _matrix![role]!.add(p);
                                                      } else {
                                                        _matrix![role]!.remove(p);
                                                      }
                                                    });
                                                  },
                                                  selectedColor: AppColors.primary,
                                                  backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                                                  checkmarkColor: Colors.white,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: DataTable(
                                  columnSpacing: 60,
                                  headingRowHeight: 80,
                                  dataRowMaxHeight: 80,
                                  headingRowColor: WidgetStateProperty.all(isDark ? Colors.white.withValues(alpha: 0.02) : AppColors.primary.withValues(alpha: 0.05)),
                                  columns: [
                                    DataColumn(label: Text(l10n.adminPermColRolPerfil, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2))),
                                    ...allPermissions.map((p) => DataColumn(label: Text(p.toUpperCase(), style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)))),
                                  ],
                                  rows: roles.map((role) {
                                    final isAdmin = role == 'Admin';
                                    return DataRow(
                                      cells: [
                                        DataCell(Row(
                                          children: [
                                            Container(
                                              width: 36, height: 36,
                                              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                                              child: Center(child: Text(role[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                                            ),
                                            const SizedBox(width: 16),
                                            Text(role, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
                                          ],
                                        )),
                                        ...allPermissions.map((p) {
                                          final hasPerm = _matrix![role]?.contains(p) ?? false;
                                          return DataCell(
                                            Checkbox(
                                              value: isAdmin || hasPerm,
                                              onChanged: isAdmin ? null : (val) {
                                                setState(() {
                                                  if (val == true) {
                                                    _matrix![role] ??= [];
                                                    _matrix![role]!.add(p);
                                                  } else {
                                                    _matrix![role]!.remove(p);
                                                  }
                                                });
                                              },
                                              activeColor: AppColors.primary,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                            ),
                                          );
                                        }),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text(l10n.adminPermErrorPrefix(e.toString()), style: TextStyle(color: isDark ? Colors.white : AppColors.textDark))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    final l10n = AppLocalizations.of(context);
    final ok = await ref.read(systemConfigProvider.notifier).saveConfig('permissions_matrix', _matrix);
    if (!mounted) return;
    if (ok) {
      ref.invalidate(permissionsMatrixProvider);
      GaulaToast.show(context, title: l10n.adminPermToastSyncTitle, message: l10n.adminPermToastSyncMessage, type: GaulaToastType.success);
    } else {
      GaulaToast.show(context, title: l10n.adminPermToastErrorTitle, message: l10n.adminPermToastErrorMessage, type: GaulaToastType.error);
    }
  }
}





