import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/gaula_toast.dart';
import '../../application/providers/config_provider.dart';

class AdminUsuariosScreen extends ConsumerStatefulWidget {
  const AdminUsuariosScreen({super.key});

  @override
  ConsumerState<AdminUsuariosScreen> createState() => _AdminUsuariosScreenState();
}

class _AdminUsuariosScreenState extends ConsumerState<AdminUsuariosScreen> {
  List<dynamic> _usuarios = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedRole;
  String? _selectedStatus;
  
  // Pagination State
  final int _rowsPerPage = 10;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    setState(() => _isLoading = true);
    try {
      final res = await ref.read(dioClientProvider).get('admin/usuarios');
      if (mounted) {
        setState(() {
          _usuarios = res.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final l10n = AppLocalizations.of(context);
        GaulaToast.show(context,
          title: l10n.adminUsuariosErrorRedTitulo,
          message: l10n.adminUsuariosErrorRedMsg,
          type: GaulaToastType.error
        );
      }
    }
  }

  List<dynamic> get _filteredUsuarios {
    return _usuarios.where((u) {
      final matchesSearch = _searchQuery.isEmpty || 
          '${u['nombre']} ${u['apellidos']} ${u['username']} ${u['email']}'.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRole = _selectedRole == null || u['rol'] == _selectedRole;
      final matchesStatus = _selectedStatus == null || u['estado'] == _selectedStatus;
      
      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  List<dynamic> get _pagedUsuarios {
    final filtered = _filteredUsuarios;
    final start = _currentPage * _rowsPerPage;
    if (start >= filtered.length) return [];
    final end = (start + _rowsPerPage) > filtered.length ? filtered.length : (start + _rowsPerPage);
    return filtered.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rolesAsync = ref.watch(rolesListProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, isDark),
            _buildAdvancedToolbar(isDark, rolesAsync),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _buildDataTable(context, isDark),
            ),
            _buildPaginationFooter(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Padding(
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 32, isMobile ? 16 : 24, isMobile ? 16 : 32, 16),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.05),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                    IconButton(
                      onPressed: _fetchUsuarios,
                      icon: const Icon(Icons.sync_rounded,
                          color: AppColors.primary, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context).adminUsuariosTitulo,
                    style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textDark,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1)),
              ],
            )
          : Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).adminUsuariosTitulo,
                      style: TextStyle(
                          color: isDark ? Colors.white : AppColors.textDark,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context).adminUsuariosMonitorTiempoReal,
                          style: TextStyle(
                              color:
                                  AppColors.textSecondary.withValues(alpha: 0.8),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                _buildQuickStat(isDark, AppLocalizations.of(context).adminUsuariosTotal, '${_usuarios.length}',
                    Icons.people_rounded, AppColors.primary),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _fetchUsuarios,
                  icon: const Icon(Icons.sync_rounded, color: AppColors.primary),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuickStat(bool isDark, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
              Text(value, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedToolbar(bool isDark, AsyncValue<List<String>> rolesAsync) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 16),
      child: isMobile
          ? Column(
              children: [
                _buildSearchInput(isDark),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: rolesAsync.when(
                        data: (roles) => _buildDropdownFilter(
                          isDark: isDark,
                          value: _selectedRole,
                          hint: l10n.adminUsuariosRol,
                          items: roles,
                          onChanged: (v) =>
                              setState(() { _selectedRole = v; _currentPage = 0; }),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (_, __) => const SizedBox(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDropdownFilter(
                        isDark: isDark,
                        value: _selectedStatus,
                        hint: l10n.adminUsuariosEstado,
                        items: ['ACTIVO', 'INACTIVO'],
                        onChanged: (v) =>
                            setState(() { _selectedStatus = v; _currentPage = 0; }),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 3, child: _buildSearchInput(isDark)),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: rolesAsync.when(
                    data: (roles) => _buildDropdownFilter(
                      isDark: isDark,
                      value: _selectedRole,
                      hint: l10n.filtrarPorRol,
                      items: roles,
                      onChanged: (v) =>
                          setState(() { _selectedRole = v; _currentPage = 0; }),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const SizedBox(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildDropdownFilter(
                    isDark: isDark,
                    value: _selectedStatus,
                    hint: l10n.adminUsuariosEstado,
                    items: ['ACTIVO', 'INACTIVO'],
                    onChanged: (v) =>
                        setState(() { _selectedStatus = v; _currentPage = 0; }),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchInput(bool isDark) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: TextField(
        onChanged: (v) => setState(() { _searchQuery = v; _currentPage = 0; }),
        style: TextStyle(
            color: isDark ? Colors.white : AppColors.textDark, fontSize: 14),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).adminUsuariosBuscarDetalle,
          hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildDropdownFilter({
    required bool isDark,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          isExpanded: true,
          dropdownColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
          style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 13, fontWeight: FontWeight.bold),
          items: [
            DropdownMenuItem<String>(value: null, child: Text(AppLocalizations.of(context).adminUsuariosTodosFiltro(hint))),
            ...items.map((e) => DropdownMenuItem(value: e, child: Text(e))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, bool isDark) {
    final filtered = _filteredUsuarios;
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_rounded, size: 64, color: AppColors.textMuted.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context).adminUsuariosSinResultados, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard.withValues(alpha: 0.3) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 48,
              headingRowHeight: 64,
              dataRowMinHeight: 72,
              dataRowMaxHeight: 72,
              headingRowColor: WidgetStateProperty.all(isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey[50]),
              columns: [
                _buildDataColumn(AppLocalizations.of(context).adminUsuariosColUsuario),
                _buildDataColumn(AppLocalizations.of(context).adminUsuariosColEmail),
                _buildDataColumn(AppLocalizations.of(context).adminUsuariosColRol),
                _buildDataColumn(AppLocalizations.of(context).adminUsuariosColEstado),
                _buildDataColumn(AppLocalizations.of(context).adminUsuariosColUltimaActividad),
                _buildDataColumn(AppLocalizations.of(context).adminUsuariosColIpSesion),
                _buildDataColumn(AppLocalizations.of(context).adminUsuariosColAcciones),
              ],
              rows: _pagedUsuarios.map((u) => _buildRow(u, isDark)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1)),
    );
  }

  DataRow _buildRow(dynamic u, bool isDark) {
    final lastConn = u['ultimaConexion'] != null 
        ? DateFormat('dd/MM HH:mm').format(DateTime.parse(u['ultimaConexion']))
        : 'S/R';
    final rol = u['rol'] ?? 'User';
    final estado = u['estado'] ?? 'ACTIVO';
    final jwt = u['ultimoJwt'];

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              _DynamicAvatar(rol: rol, nombre: u['nombre'] ?? 'U'),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${u['nombre']} ${u['apellidos']}', style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('@${u['username']}', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(u['email'] ?? 'N/A', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
        DataCell(_DynamicRolBadge(rol: rol)),
        DataCell(_CompactStatusBadge(estado: estado)),
        DataCell(Text(lastConn, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
        DataCell(Text(u['ipConexion'] ?? '0.0.0.0', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontFamily: 'monospace'))),
        DataCell(
          Row(
            children: [
              _ActionButton(
                  icon: Icons.vpn_key_rounded,
                  color: AppColors.primary,
                  tooltip: AppLocalizations.of(context).adminUsuariosMenuResetear,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: jwt));
                    final l10n = AppLocalizations.of(context);
                    GaulaToast.show(context, title: l10n.adminUsuariosToastCopiado, message: l10n.adminUsuariosToastTokenCopiado, type: GaulaToastType.success);
                  },
                ),
              _UserActionsMenu(u: u, isDark: isDark, onRefresh: _fetchUsuarios),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationFooter(bool isDark) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final filteredCount = _filteredUsuarios.length;
    final totalPages = (filteredCount / _rowsPerPage).ceil();
    if (filteredCount == 0) return const SizedBox(height: 24);

    return Padding(
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 32, 16, isMobile ? 16 : 32, 24),
      child: isMobile
          ? Column(
              children: [
                _PaginationControl(
                  currentPage: _currentPage,
                  totalPages: totalPages,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context).adminUsuariosMostrando(
                    _currentPage * _rowsPerPage + 1,
                    (_currentPage + 1) * _rowsPerPage > filteredCount ? filteredCount : (_currentPage + 1) * _rowsPerPage,
                    filteredCount,
                  ),
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          : Row(
              children: [
                Text(
                  AppLocalizations.of(context).adminUsuariosMostrandoRegistros(
                    _currentPage * _rowsPerPage + 1,
                    (_currentPage + 1) * _rowsPerPage > filteredCount ? filteredCount : (_currentPage + 1) * _rowsPerPage,
                    filteredCount,
                  ),
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                _PaginationControl(
                  currentPage: _currentPage,
                  totalPages: totalPages,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  isDark: isDark,
                ),
              ],
            ),
    );
  }
}

class _DynamicAvatar extends StatelessWidget {
  final String rol;
  final String nombre;
  const _DynamicAvatar({required this.rol, required this.nombre});

  @override
  Widget build(BuildContext context) {
    final color = _getColorForRol(rol);
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(nombre[0].toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }
}

class _DynamicRolBadge extends StatelessWidget {
  final String rol;
  const _DynamicRolBadge({required this.rol});

  @override
  Widget build(BuildContext context) {
    final color = _getColorForRol(rol);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(rol.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
    );
  }
}

class _CompactStatusBadge extends StatelessWidget {
  final String estado;
  const _CompactStatusBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final active = estado == 'ACTIVO';
    final color = active ? Colors.greenAccent : Colors.redAccent;
    final l10n = AppLocalizations.of(context);
    final label = active ? l10n.estadoActivo : l10n.estadoInactivo;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.color, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}

class _UserActionsMenu extends ConsumerWidget {
  final dynamic u;
  final bool isDark;
  final VoidCallback onRefresh;
  const _UserActionsMenu({required this.u, required this.isDark, required this.onRefresh});

  // PopupMenuItem<String> _buildMenuItem(String label, IconData icon, bool isDark, {Color? color}) {
  //   return PopupMenuItem(
  //     value: label,
  //     child: Row(
  //       children: [
  //         Icon(icon, size: 18, color: color ?? (isDark ? Colors.white70 : AppColors.textDark)),
  //         const SizedBox(width: 12),
  //         Text(label, style: TextStyle(color: color ?? (isDark ? Colors.white70 : AppColors.textDark), fontSize: 13)),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _handleAction(String val, dynamic u, BuildContext context, WidgetRef ref) async {
    final dio = ref.read(dioClientProvider);
    final id = u['id'];
    final rol = u['rol'];
    final l10n = AppLocalizations.of(context);

    if (val == 'reset') {
      try {
        await dio.patch('admin/usuarios/$id/reset-password', queryParameters: {'rol': rol});
        if (context.mounted) {
          GaulaToast.show(context, title: l10n.adminUsuariosToastContrasenaReseteada, message: l10n.adminUsuariosToastContrasenaMsg(u['username']), type: GaulaToastType.success);
        }
      } catch (e) {
        if (context.mounted) {
          GaulaToast.show(context, title: l10n.adminUsuariosToastError, message: l10n.adminUsuariosToastNoResetear, type: GaulaToastType.error);
        }
      }
    } else if (val == 'toggle') {
      final nuevoEstado = u['estado'] == 'ACTIVO' ? 'INACTIVO' : 'ACTIVO';
      try {
        await dio.patch('admin/usuarios/$id/estado', queryParameters: {'nuevoEstado': nuevoEstado, 'rol': rol});
        onRefresh();
        if (context.mounted) {
          GaulaToast.show(context, title: l10n.adminUsuariosToastEstadoActualizado, message: l10n.adminUsuariosToastEstadoMsg(u['username'], nuevoEstado), type: GaulaToastType.success);
        }
      } catch (e) {
        if (context.mounted) {
          GaulaToast.show(context, title: l10n.adminUsuariosToastError, message: l10n.adminUsuariosToastNoEstado, type: GaulaToastType.error);
        }
      }
    } else if (val == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          final l10nCtx = AppLocalizations.of(ctx);
          return AlertDialog(
            title: Text(l10nCtx.adminUsuariosDialogEliminarTitulo),
            content: Text(l10nCtx.adminUsuariosDialogEliminarMsg('${u["nombre"]} ${u["apellidos"]}', u['username'])),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10nCtx.adminUsuariosDialogCancelar)),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                child: Text(l10nCtx.adminUsuariosDialogEliminar),
              ),
            ],
          );
        },
      );
      if (confirm == true) {
        try {
          await dio.delete('admin/usuarios/$id', queryParameters: {'rol': rol});
          onRefresh();
          if (context.mounted) {
            GaulaToast.show(context, title: l10n.adminUsuariosToastEliminado, message: l10n.adminUsuariosToastEliminadoMsg, type: GaulaToastType.success);
          }
        } catch (e) {
          if (context.mounted) {
            GaulaToast.show(context, title: l10n.adminUsuariosToastError, message: l10n.adminUsuariosToastNoEliminar, type: GaulaToastType.error);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textSecondary),
      padding: EdgeInsets.zero,
      color: isDark ? AppColors.backgroundDarkCard : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight),
      ),
      onSelected: (val) => _handleAction(val, u, context, ref),
      itemBuilder: (context) {
        final l10n = AppLocalizations.of(context);
        return [
          // _buildMenuItem(l10n.adminUsuariosMenuVerPerfil, Icons.visibility_rounded, isDark),
          // _buildMenuItem(l10n.adminUsuariosMenuEditar, Icons.edit_rounded, isDark),
          PopupMenuItem(
            value: 'reset',
            child: Row(children: [
              Icon(Icons.lock_reset_rounded, size: 18, color: isDark ? Colors.white70 : AppColors.textDark),
              const SizedBox(width: 12),
              Text(l10n.adminUsuariosMenuResetear, style: TextStyle(color: isDark ? Colors.white70 : AppColors.textDark, fontSize: 13)),
            ]),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'toggle',
            child: Row(children: [
              Icon(Icons.block_rounded, size: 18, color: u['estado'] == 'ACTIVO' ? Colors.redAccent : Colors.greenAccent),
              const SizedBox(width: 12),
              Text(
                u['estado'] == 'ACTIVO' ? l10n.adminUsuariosMenuDesactivar : l10n.adminUsuariosMenuActivar,
                style: TextStyle(color: u['estado'] == 'ACTIVO' ? Colors.redAccent : Colors.greenAccent, fontSize: 13),
              ),
            ]),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(children: [
              const Icon(Icons.delete_forever_rounded, size: 18, color: Colors.red),
              const SizedBox(width: 12),
              Text(l10n.adminUsuariosMenuEliminar, style: const TextStyle(color: Colors.red, fontSize: 13)),
            ]),
          ),
        ];
      },
    );
  }
}

class _PaginationControl extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final bool isDark;

  const _PaginationControl({required this.currentPage, required this.totalPages, required this.onPageChanged, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PageBtn(icon: Icons.first_page_rounded, onTap: currentPage > 0 ? () => onPageChanged(0) : null),
        _PageBtn(icon: Icons.chevron_left_rounded, onTap: currentPage > 0 ? () => onPageChanged(currentPage - 1) : null),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Text('${currentPage + 1} / $totalPages', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 12)),
        ),
        const SizedBox(width: 12),
        _PageBtn(icon: Icons.chevron_right_rounded, onTap: currentPage < totalPages - 1 ? () => onPageChanged(currentPage + 1) : null),
        _PageBtn(icon: Icons.last_page_rounded, onTap: currentPage < totalPages - 1 ? () => onPageChanged(totalPages - 1) : null),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _PageBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      color: onTap == null ? AppColors.textMuted : AppColors.primary,
      style: IconButton.styleFrom(
        backgroundColor: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

Color _getColorForRol(String rol) {
  switch (rol.toLowerCase()) {
    case 'admin': return Colors.purpleAccent;
    case 'teacher':
    case 'docente': return Colors.blueAccent;
    case 'student':
    case 'alumno': return Colors.orangeAccent;
    case 'tutor': return Colors.tealAccent;
    default: return Colors.blueGrey;
  }
}





