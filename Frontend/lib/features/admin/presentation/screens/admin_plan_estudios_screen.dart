import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../domain/entities/curso_plantilla_model.dart';
import '../../domain/entities/materia_plantilla_model.dart';

import '../../application/providers/curso_plantilla_provider.dart';


class AdminPlanEstudiosScreen extends ConsumerStatefulWidget {
  const AdminPlanEstudiosScreen({super.key});

  @override
  ConsumerState<AdminPlanEstudiosScreen> createState() => _AdminPlanEstudiosScreenState();
}

class _AdminPlanEstudiosScreenState extends ConsumerState<AdminPlanEstudiosScreen> {
  CursoPlantillaModel? _selectedTemplate;
  bool _showCreateForm = false;
  CursoPlantillaModel? _editingTemplate;
  int? _deleteId;

  // Form state
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _colorHex = '#34d399'; // Estado para el color
  List<MateriaPlantillaModel> _formSubjects = [];
  final _sNameCtrl = TextEditingController();
  final _sCodeCtrl = TextEditingController();
  final _sHoursCtrl = TextEditingController();
  String _sTipo = 'MODULO';
  int _sEditandoId = 0;

  void _openCreate() {
    _editingTemplate = null;
    _nameCtrl.clear(); _codeCtrl.clear(); _descCtrl.clear();
    _colorHex = '#34d399'; _formSubjects = [];
    _sNameCtrl.clear(); _sCodeCtrl.clear(); _sHoursCtrl.clear(); _sEditandoId = 0;
    setState(() => _showCreateForm = true);
  }

  void _openEdit(CursoPlantillaModel t) {
    _editingTemplate = t;
    _nameCtrl.text = t.nombre;
    _codeCtrl.text = t.codigo;
    _descCtrl.text = t.descripcion ?? '';
    _colorHex = t.color;
    /* _subjectType = t.subjectType; */_formSubjects = List.from(t.materias);
    _sNameCtrl.clear(); _sCodeCtrl.clear(); _sHoursCtrl.clear(); _sEditandoId = 0;
    setState(() { _showCreateForm = true; _selectedTemplate = null; });
  }

  void _addSubject() {
    final name = _sNameCtrl.text.trim();
    final code = _sCodeCtrl.text.trim();
    final hours = int.tryParse(_sHoursCtrl.text.trim()) ?? 0;
    final identifier = _sEditandoId == 0 ? obtenerPrimerIdDisponible() : _sEditandoId;
    if (name.isNotEmpty && code.isNotEmpty && hours > 0) {
      setState(() {
        _formSubjects = [..._formSubjects, MateriaPlantillaModel(id: identifier, nombre: name, codigo: code, descripcion: '', horasTotales: hours, tipo: _sTipo)];
        _sNameCtrl.clear(); _sCodeCtrl.clear(); _sHoursCtrl.clear(); _sEditandoId = 0;
      });
    }
  }

  //ISMA-nota; el id obtenido es solo para el formulario, luego se le asigna un ID real
  //nota 2, usar ids negativos para ficticios, y positivos para reales, asi se conserva la edicion
  int obtenerPrimerIdDisponible() {
    // 1. Extraemos todos los IDs actuales en un Set para búsquedas ultra rápidas
    final idsOcupados = _formSubjects
        .map((materia) => materia.id)
        .whereType<int>() // Por si acaso el id puede ser null
        .toSet();

    // 2. Buscamos el primer número entero (empezando en -1) que no esté en el Set
    int nuevoId = -1;
    while (idsOcupados.contains(nuevoId)) {
      nuevoId--;
    }

    return nuevoId;
  }

  void _saveForm() {
    if (_nameCtrl.text.trim().isEmpty || _codeCtrl.text.trim().isEmpty || _formSubjects.isEmpty) return;

    final data = {
      'nombre': _nameCtrl.text.trim(),
      'codigo': _codeCtrl.text.trim(),
      'descripcion': _descCtrl.text.trim(),
      'color': _colorHex,
      'materias': _formSubjects,
    };

    if (_editingTemplate != null) {
      ref.read(cursoPlantillasCrudProvider.notifier).actualizar(_editingTemplate!.id, data);
    } else {
      ref.read(cursoPlantillasCrudProvider.notifier).crear(data);
    }

    setState(() { _showCreateForm = false; _editingTemplate = null; });
  }

  void _confirmDelete(int id) => setState(() => _deleteId = id);

  void _doDelete() {
    if (_deleteId == null) return;
    ref.read(cursoPlantillasCrudProvider.notifier).eliminar(_deleteId!);
    setState(() {
      _deleteId = null; _selectedTemplate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final plantillasAsync = ref.watch(cursoPlantillasListProvider);
    final crudState = ref.watch(cursoPlantillasCrudProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      child: isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.planEstudiosTitulo,
                                    style: TextStyle(
                                        color: isDark ? Colors.white : AppColors.textDark,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1)),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _openCreate,
                                    icon: const Icon(Icons.add),
                                    label: Text(l10n.agregar),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.planEstudiosTitulo,
                                          style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : AppColors.textDark,
                                              fontSize: 40,
                                              fontWeight: FontWeight.w900)),
                                      Text(
                                          l10n.planEstudiosTituloDesc,
                                          style: TextStyle(
                                              color: isDark
                                                  ? AppColors.textSecondary
                                                  : AppColors.textMuted,
                                              fontSize: 16),
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: _openCreate,
                                  icon: const Icon(Icons.add),
                                  label: Text(l10n.agregar),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 40),
                    
                    plantillasAsync.when(
                      data: (templates) => GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 320,
                          mainAxisExtent: 280,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                        ),
                        itemCount: templates.length,
                        itemBuilder: (context, index) {
                          final t = templates[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 80 * index),
                            child: _TemplateCard(
                              template: t,
                              onTap: () => setState(() => _selectedTemplate = t),
                              onEdit: () => _openEdit(t),
                              onDelete: () => _confirmDelete(t.id),
                            ),
                          );
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, __) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (crudState.isLoading) 
             const Center(child: CircularProgressIndicator(color: AppColors.primary)),

          if (_selectedTemplate != null)
            _Modal(
              onClose: () => setState(() => _selectedTemplate = null),
              child: _DetailModal(
                template: _selectedTemplate!, 
                onClose: () => setState(() => _selectedTemplate = null),
                onEditMateria: (s) {
                  final t = _selectedTemplate!;
                  setState(() => _selectedTemplate = null);
                  _openEdit(t);
                  // Optionally, load the subject 's' into the form fields
                  // but _openEdit already loads all subjects.
                },
                onDeleteMateria: (id) async {
                  final t = _selectedTemplate!;
                  final m = t.materias.firstWhere((m) => m.id == id);
                  
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  final textColor = isDark ? Colors.white : AppColors.textDark;
                  // ignore: use_build_context_synchronously
                  final l10n = AppLocalizations.of(context);
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
                      title: Text(l10n.eliminar, style: TextStyle(color: textColor)),
                      content: Text(l10n.adminPlanEstudiosConfirmarEliminarMateria(m.nombre), style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l10n.cancelar, style: TextStyle(color: textColor.withValues(alpha: 0.7))),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.eliminar, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirm != true) return;

                  final updatedMaterias = t.materias.where((mat) => mat.id != id).toList();
                  final success = await ref.read(cursoPlantillasCrudProvider.notifier).actualizar(
                    t.id, 
                    {...t.toJson(), 'materias': updatedMaterias.map((mat) => mat.toJson()).toList()}
                  );
                  if (success) {
                    setState(() {
                      _selectedTemplate = t.copyWith(materias: updatedMaterias);
                    });
                  } else {
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.adminPlanEstudiosErrorEliminarMateria), backgroundColor: Colors.red),
                    );
                  }
                },
              ),
            ),
          if (_showCreateForm)
            _Modal(
              onClose: () => setState(() { _showCreateForm = false; _editingTemplate = null; }),
              child: _CreateModal(
                isEditing: _editingTemplate != null,
                nameCtrl: _nameCtrl,
                codeCtrl: _codeCtrl,
                descCtrl: _descCtrl,
                courseColor: hexToColor(_colorHex),
                onColorChanged: (color) => setState(() => _colorHex = '#${color.toARGB32().toRadixString(16).substring(2)}'),
                subjects: _formSubjects,
                sNameCtrl: _sNameCtrl,
                sCodeCtrl: _sCodeCtrl,
                sHoursCtrl: _sHoursCtrl,
                sTipo: _sTipo,
                sEditandoId: _sEditandoId,
                onSTipoChanged: (v) => setState(() => _sTipo = v!),
                onSEditandoChanged: (v) => setState(() => _sEditandoId = v!),
                onAddSubject: _addSubject,
                onRemoveSubject: (id) => setState(() => _formSubjects = _formSubjects.where((s) => s.id != id).toList()),
                onEditSubject: (s) {
                  setState(() {
                    _sNameCtrl.text = s.nombre;
                    _sCodeCtrl.text = s.codigo;
                    _sHoursCtrl.text = s.horasTotales.toString();
                    _sTipo = s.tipo;
                    _sEditandoId = s.id;
                    _formSubjects = _formSubjects.where((sub) => sub.id != s.id).toList();
                  });
                },
                onCancel: () => setState(() { _showCreateForm = false; _editingTemplate = null; }),
                onSave: _saveForm,
              ),
            ),
          if (_deleteId != null)
            _Modal(
              onClose: () => setState(() => _deleteId = null),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: isDark ? AppColors.backgroundDarkCard : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight)),
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.eliminar, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(l10n.adminPlanEstudiosConfirmarEliminarPlantilla, style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: () => setState(() => _deleteId = null), style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(l10n.cancelar, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark)))),
                        const SizedBox(width: 12),
                        Expanded(child: ElevatedButton(onPressed: _doDelete, style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(l10n.eliminar, style: const TextStyle(fontWeight: FontWeight.bold)))),
                      ],
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

class _Modal extends StatelessWidget {
  final Widget child;
  final VoidCallback onClose;
  const _Modal({required this.child, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: child),
          ),
        ),
      ),
    );
  }
}

class _TemplateCard extends StatefulWidget {
  final CursoPlantillaModel template;
  final VoidCallback onTap, onEdit, onDelete;
  const _TemplateCard({required this.template, required this.onTap, required this.onEdit, required this.onDelete});

  @override
  State<_TemplateCard> createState() => _TemplateCardState();
}

class _TemplateCardState extends State<_TemplateCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.template;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          transform: _hovered ? Matrix4.diagonal3Values(1.03, 1.03, 1.0) : Matrix4.identity(),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDarkCard : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: hexToColor(t.color).withValues(alpha: 0.3), width: 2),
            boxShadow: _hovered ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)] : null,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: hexToColor(t.color), borderRadius: BorderRadius.circular(20)),
                    child: Center(child: Text(t.codigo, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900))),
                  ),
                  const SizedBox(height: 16),
                  Text(t.nombre, style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  const Divider(color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer(builder: (context, ref, _) {
                          final l = AppLocalizations.of(context);
                          return Text(l.adminPlanEstudiosMateriaCount(t.materias.length), style: TextStyle(color: isDark ? AppColors.textSecondary : AppColors.textMuted, fontSize: 12));
                        }),
                      // Text('${t.totalHours}h', style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              if (_hovered)
                Consumer(
                  builder: (context, ref, child) {
                    final esAdmin = ref.watch(usuarioActualProvider)?.esAdmin ?? false;
                    if (!esAdmin) return const SizedBox.shrink();
                    return Positioned(
                      top: 0, right: 0,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: widget.onEdit,
                            child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.edit, color: Colors.white, size: 16)),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: widget.onDelete,
                            child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.delete, color: Colors.white, size: 16)),
                          ),
                        ],
                      ),
                    );
                  }
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

String _tipoLabel(String tipo, AppLocalizations l10n) {
  switch (tipo) {
    case 'PROYECTO': return l10n.adminPlanEstudiosTipoProyecto;
    case 'ASIGNATURA': return l10n.adminPlanEstudiosTipoAsignatura;
    case 'MODULO': return l10n.adminPlanEstudiosTipoModulo;
    default: return tipo;
  }
}

// ── Detail Modal Content ────────────────────────────────────────────────────
class _DetailModal extends StatelessWidget {
  final CursoPlantillaModel template;
  final VoidCallback onClose;
  final Function(MateriaPlantillaModel) onEditMateria;
  final Function(int) onDeleteMateria;

  const _DetailModal({
    required this.template, 
    required this.onClose,
    required this.onEditMateria,
    required this.onDeleteMateria,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      constraints: const BoxConstraints(maxWidth: 800),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 64, height: 64, decoration: BoxDecoration(color: hexToColor(template.color), borderRadius: BorderRadius.circular(16)), child: Center(child: Text(template.codigo, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)))),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(template.nombre, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(template.descripcion ?? '', style: const TextStyle(color: AppColors.textSecondary)),
              ])),
              IconButton(icon: const Icon(Icons.close, color: AppColors.textSecondary), onPressed: onClose),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.adminPlanEstudiosModulosYProyectos, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...template.materias.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight)
            ),
            child: Row(
              children: [
                Container(width: 48, height: 48, decoration: BoxDecoration(color: hexToColor(template.color), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(s.codigo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.nombre, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                  Text(l10n.adminPlanEstudiosTipoCodigoLabel(_tipoLabel(s.tipo, l10n), s.codigo), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ])),
                Row(children: [
                  const Icon(Icons.access_time, color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 4),
                  Text('${s.horasTotales}h', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => onEditMateria(s),
                    child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.edit, color: Colors.white, size: 14)),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onDeleteMateria(s.id),
                    child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.delete_outline, color: Colors.white, size: 14)),
                  ),
                ]),
              ],
            ),
          )),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: onClose, style: OutlinedButton.styleFrom(side: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(l10n.cerrar, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)))),
        ],
      ),
    );
  }
}

// ── Create/Edit Modal ────────────────────────────────────────────────────────
class _CreateModal extends StatelessWidget {
  final bool isEditing;
  final TextEditingController nameCtrl, codeCtrl, descCtrl, sNameCtrl, sCodeCtrl, sHoursCtrl;
  final Color courseColor;
  final ValueChanged<Color> onColorChanged;
  final List<MateriaPlantillaModel> subjects;
  final VoidCallback onAddSubject, onCancel, onSave;
  final ValueChanged<int> onRemoveSubject;
  final Function(MateriaPlantillaModel) onEditSubject;
  final String sTipo;
  final int sEditandoId;
  final ValueChanged<String?> onSTipoChanged;
  final ValueChanged<int?> onSEditandoChanged;

  const _CreateModal({
    required this.isEditing,
    required this.nameCtrl,
    required this.codeCtrl,
    required this.descCtrl,
    required this.courseColor,
    required this.onColorChanged,
    required this.subjects,
    required this.sNameCtrl,
    required this.sCodeCtrl,
    required this.sHoursCtrl,
    required this.sTipo,
    required this.sEditandoId,
    required this.onSTipoChanged,
    required this.onSEditandoChanged,
    required this.onAddSubject,
    required this.onRemoveSubject,
    required this.onEditSubject,
    required this.onCancel,
    required this.onSave
  });

  Widget _field(BuildContext context, String label, TextEditingController ctrl, {String hint = '', TextInputType? keyboardType}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    ],
  );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textDark;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      constraints: const BoxConstraints(maxWidth: 800),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(isEditing ? l10n.adminPlanEstudiosEditarPlan : l10n.adminPlanEstudiosCrearPlan, style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              IconButton(icon: const Icon(Icons.close, color: AppColors.textSecondary), onPressed: onCancel),
            ],
          ),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _field(context, l10n.adminPlanEstudiosNombreCurso, nameCtrl, hint: l10n.adminPlanEstudiosNombreCursoHint)),
            const SizedBox(width: 16),
            Flexible(flex: 0, child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 120, maxWidth: 180), child: _field(context, l10n.adminPlanEstudiosCodigo, codeCtrl, hint: l10n.adminPlanEstudiosaCodigoHint))),
          ]),
          const SizedBox(height: 24),

          Row(children: [
            Expanded(child: _field(context, l10n.adminPlanEstudiosDescripcion, descCtrl, hint: l10n.adminPlanEstudiosDescripcionHint)),
          ]),
          const SizedBox(height: 24),
          Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.adminPlanEstudiosColorPlantilla,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  final l = AppLocalizations.of(context);
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l.adminPlanEstudiosSeleccionarColor),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: courseColor,
                          onColorChanged: onColorChanged,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(l.aceptar),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          color: courseColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '#${courseColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                        style: TextStyle(color: textColor),
                      ),
                      const Spacer(),
                      const Icon(Icons.colorize, color: AppColors.textSecondary, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.border),
          const SizedBox(height: 16),
          Text(l10n.adminPlanEstudiosAniadirMateria, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(flex: 2, child: _field(context, l10n.adminPlanEstudiosNombreMateria, sNameCtrl, hint: l10n.adminPlanEstudiosNombreMateriaHint)),
            const SizedBox(width: 8),
            Flexible(
              child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.adminPlanEstudiosTipoMateria, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(color: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: sTipo,
                        dropdownColor: isDark ? AppColors.backgroundDarkCard : Colors.white,
                        isExpanded: true,
                        style: TextStyle(color: textColor, fontSize: 13),
                        items: [
                          DropdownMenuItem(value: 'PROYECTO', child: Text(l10n.adminPlanEstudiosTipoProyecto)),
                          DropdownMenuItem(value: 'ASIGNATURA', child: Text(l10n.adminPlanEstudiosTipoAsignatura)),
                          DropdownMenuItem(value: 'MODULO', child: Text(l10n.adminPlanEstudiosTipoModulo)),
                        ],
                        onChanged: onSTipoChanged,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(width: 8),
            Flexible(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 80, maxWidth: 120), child: _field(context, l10n.adminPlanEstudiosCodigo, sCodeCtrl, hint: 'M-01'))),
            const SizedBox(width: 8),
            Flexible(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 80, maxWidth: 120), child: _field(context, l10n.adminPlanEstudiosHoras, sHoursCtrl, hint: '240', keyboardType: TextInputType.number))),
            if (sEditandoId != 0)
              const SizedBox(width: 8),
            if (sEditandoId != 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.accent, size: 24), onPressed: () => onSEditandoChanged(0), padding: EdgeInsets.zero),
                ],
              ),
          ]),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddSubject,
              icon: const Icon(Icons.add),
              label: Text(sEditandoId != 0 ? l10n.adminPlanEstudiosEditarMateria : l10n.adminPlanEstudiosAniadirMateria),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: AppColors.accentForeground, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ),
          if (subjects.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l10n.adminPlanEstudiosMateriasAniadidas, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...subjects.map((s) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: isDark ? AppColors.backgroundDarkSurface : AppColors.backgroundLightSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: isDark ? AppColors.border : AppColors.borderLight)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('${s.nombre} (${_tipoLabel(s.tipo, l10n)}) — ${s.codigo} — ${s.horasTotales}h', style: TextStyle(color: textColor, fontSize: 13))),
                  IconButton(icon: const Icon(Icons.edit, color: AppColors.primary, size: 18), onPressed: () => onEditSubject(s), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18), onPressed: () => onRemoveSubject(s.id), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                ],
              ),
            )),
          ],
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: onCancel, style: OutlinedButton.styleFrom(side: BorderSide(color: isDark ? AppColors.border : AppColors.borderLight), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(l10n.cancelar, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(onPressed: onSave, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(isEditing ? l10n.guardar : l10n.crear, style: const TextStyle(fontWeight: FontWeight.bold)))),
          ]),
        ],
      ),
    );
  }
}





