import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/application/providers/auth_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/admin/presentation/screens/admin_shell.dart';
import '../features/admin/presentation/screens/admin_alumnos_screen.dart';
import '../features/admin/presentation/screens/admin_profesores_screen.dart';
import '../features/admin/presentation/screens/admin_cursos_screen.dart';
import '../features/admin/presentation/screens/admin_school_year_screen.dart';
import '../features/admin/presentation/screens/admin_plan_estudios_screen.dart';
import '../features/admin/presentation/screens/admin_incidencias_screen.dart';
import '../features/admin/presentation/screens/admin_program_config_screen.dart';
import '../features/admin/presentation/screens/admin_permissions_screen.dart';
import '../features/admin/presentation/screens/admin_roles_screen.dart';
import '../features/admin/presentation/screens/admin_attendance_history_screen.dart';
import '../features/admin/presentation/screens/admin_configuracion_page.dart';
import '../features/admin/presentation/screens/admin_horario_screen.dart';
import '../features/admin/presentation/screens/admin_reglamento_screen.dart';
import '../features/admin/presentation/screens/admin_auditoria_screen.dart';
import '../features/admin/presentation/screens/admin_usuarios_screen.dart';
import '../features/teacher/presentation/screens/teacher_shell.dart';
import '../features/student/presentation/student_shell.dart';
import '../features/shared/presentation/festivos_screen.dart';
import '../features/attendance/presentation/attendance_schedule_page.dart';
import '../features/shared/presentation/horario_screen.dart';
import '../features/teacher/presentation/screens/teacher_overview_screen.dart';
import '../features/attendance/presentation/attendance_session_page.dart';
import '../features/teacher/presentation/screens/teacher_alumnos_screen.dart';
import '../features/shared/presentation/student_detail_screen.dart';
import '../features/shared/presentation/user_profile_screen.dart';
import '../features/student/presentation/student_overview_screen.dart';
import '../features/student/presentation/student_asistencia_screen.dart';
import '../features/teacher/presentation/screens/teacher_historial_screen.dart';
import '../features/student/presentation/student_ficha_screen.dart';
import '../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../features/teacher/presentation/screens/teacher_settings_screen.dart';
import '../shared/presentation/reglamento_viewer_screen.dart';
import '../features/auth/presentation/screens/maintenance_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Nombres de rutas — constantes para evitar strings mágicos
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppRoutes {
  static const String login          = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword  = '/reset-password';
  static const String adminDashboard = '/admin';
  static const String adminAlumnos   = '/admin/alumnos';
  static const String adminProfesores= '/admin/profesores';
  static const String adminCursos    = '/admin/cursos';
  static const String adminFestivos  = '/admin/festivos';
  static const String adminHorario   = '/admin/horario';
  static const String adminAsistencia= '/admin/asistencia';
  static const String adminAsistenciaClase = '/admin/asistencia/:claseId';
  static const String adminIncidencias='/admin/incidencias';
  static const String adminSchoolYear= '/admin/school-year';
  static const String adminPlanEstudios= '/admin/plan-estudios';
  static const String adminProgramConfig = '/admin/programa';
  static const String adminSettings  = '/admin/configuracion';
  static const String teacherHome    = '/profesor';
  static const String teacherAsistenciaSchedule = '/profesor/asistencia';
  static const String teacherAsistencia = '/profesor/asistencia/:sessionId';
  static const String teacherHorario = '/profesor/horario';
  static const String teacherAlumnos = '/profesor/alumnos';
  static const String teacherStudentDetail = '/profesor/alumnos/:studentId';
  static const String adminStudentDetail   = '/admin/alumnos/:studentId';
  static const String teacherFestivos= '/profesor/festivos';
  static const String teacherCursos      = '/profesor/cursos';
  static const String teacherIncidencias = '/profesor/incidencias';
  static const String teacherHistorial   = '/profesor/historial';
  static const String teacherSettings    = '/profesor/configuracion';
  static const String studentHome    = '/alumno';
  static const String adminProfile   = '/admin/perfil';
  static const String teacherProfile = '/profesor/perfil';
  static const String studentProfile = '/alumno/perfil';
  static const String studentFicha   = '/alumno/ficha';
  static const String studentHorario = '/alumno/horario';
  static const String studentAsistencia = '/alumno/asistencia';
  static const String studentIncidencias = '/alumno/incidencias';
  static const String studentFestivos = '/alumno/festivos';
  static const String studentSettings = '/alumno/configuracion';
  static const String adminNormas    = '/admin/normas';
  static const String adminAuditoria = '/admin/auditoria';
  static const String adminUsuarios  = '/admin/usuarios';
  static const String adminPermissions = '/admin/permissions';
  static const String adminRoles     = '/admin/roles';
  static const String teacherNormas  = '/profesor/normas';
  static const String studentNormas  = '/alumno/normas';
  static const String maintenance    = '/mantenimiento';
}

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(Ref ref) {
    ref.listen(authNotifierProvider, (_, __) => notifyListeners());
  }
}

final routerNotifierProvider = Provider((ref) => RouterNotifier(ref));

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter configurado como Provider de Riverpod.
/// Se reconstruye automáticamente cuando cambia [authNotifierProvider]
/// (login, logout, o comprobación inicial de sesión).
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true, // Solo activo en debug
    refreshListenable: notifier,

    // ── Redirect global: protege las rutas según el estado de sesión ──
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final estaEnLogin = state.matchedLocation == AppRoutes.login;
      final isRecoveryRoute = state.matchedLocation == AppRoutes.forgotPassword || state.matchedLocation == AppRoutes.resetPassword;

      return authState.when(
        initial: () {
          // Todaví­a verificando sesión: mostrar login como placeholder
          return null;
        },
        loading: () => null,
        unauthenticated: () {
          // Sin sesión: redirigir al login si no está en login ni en recuperación
          if (estaEnLogin || isRecoveryRoute) return null;
          return AppRoutes.login;
        },
        authenticated: (usuario) {
          final isTargetingAdmin = state.matchedLocation.startsWith('/admin');
          final isTargetingTeacher = state.matchedLocation.startsWith('/profesor');
          final isTargetingStudent = state.matchedLocation.startsWith('/alumno');

          if (estaEnLogin) {
            // Autenticado: redirigir al dashboard correcto según el rol
            if (usuario.esAdmin)    return AppRoutes.adminDashboard;
            if (usuario.esDocente) return AppRoutes.teacherHome;
            return AppRoutes.studentHome;
          }

          // --- Protección de Rutas por Rol ---
          
          // 1. Si es Admin, no puede entrar en /profesor ni /alumno
          if (usuario.esAdmin) {
            if (isTargetingTeacher || isTargetingStudent) return AppRoutes.adminDashboard;
          }

          // 2. Si es Profesor, no puede entrar en /admin ni /alumno
          if (usuario.esDocente) {
            if (isTargetingAdmin || isTargetingStudent) return AppRoutes.teacherHome;
          }

          // 3. Si es Alumno, no puede entrar en /admin ni /profesor
          if (usuario.esAlumno) {
            if (isTargetingAdmin || isTargetingTeacher) return AppRoutes.studentHome;
          }

          return null; // Dejar pasar si el rol coincide con la ruta
        },
        error: (mensaje) {
          // Error: dejar en el login para mostrar el mensaje
          return (estaEnLogin || isRecoveryRoute) ? null : AppRoutes.login;
        },
        maintenance: () {
          // Servidor caí­do: redirigir a la pantalla de mantenimiento
          return AppRoutes.maintenance;
        },
      );
    },

    // ── Definición de rutas ──
    routes: [
      // ── Login (público) ──
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.maintenance,
        name: 'maintenance',
        builder: (context, state) => const MaintenanceScreen(),
      ),

      // ── Shell del Administrador (sidebar compartido) ──
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.adminUsuarios,
            name: 'admin-usuarios',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminUsuariosScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminDashboard,
            name: 'admin-dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminDashboardScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminAlumnos,
            name: 'admin-alumnos',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminAlumnosScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminStudentDetail,
            name: 'admin-student-detail',
            pageBuilder: (context, state) {
              final id = state.pathParameters['studentId']!;
              return NoTransitionPage(child: StudentDetailScreen(studentId: int.parse(id)));
            },
          ),
          GoRoute(
            path: AppRoutes.adminProfesores,
            name: 'admin-profesores',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminProfesoresScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminCursos,
            name: 'admin-cursos',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminCursosScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminAsistencia,
            name: 'admin-asistencia',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminAttendanceHistoryScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminAsistenciaClase,
            name: 'admin-asistencia-clase',
            pageBuilder: (context, state) {
              final sessionId = state.pathParameters['sessionId']!;
              return NoTransitionPage(child: AttendanceSessionPage(sessionId: sessionId));
            },
          ),
          GoRoute(
            path: AppRoutes.adminIncidencias,
            name: 'admin-incidencias',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminIncidenciasScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminFestivos,
            name: 'admin-festivos',
            pageBuilder: (context, state) => const NoTransitionPage(child: FestivosScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminHorario,
            name: 'admin-horario',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminHorarioScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminSchoolYear,
            name: 'admin-school-year',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminSchoolYearScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminPlanEstudios,
            name: 'admin-plan-estudios',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminPlanEstudiosScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminProgramConfig,
            name: 'admin-programa',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminProgramConfigScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminPermissions,
            name: 'admin-permissions',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminPermissionsScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminRoles,
            name: 'admin-roles',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminRolesScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminSettings,
            name: 'admin-configuracion',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminConfiguracionPage()),
          ),
          GoRoute(
            path: AppRoutes.adminProfile,
            name: 'admin-perfil',
            pageBuilder: (context, state) => const NoTransitionPage(child: UserProfileScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminNormas,
            name: 'admin-normas',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminReglamentoScreen()),
          ),
          GoRoute(
            path: AppRoutes.adminAuditoria,
            name: 'admin-auditoria',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminAuditoriaScreen()),
          ),
        ],
      ),

      // ── Shell del Profesor ──
      ShellRoute(
        builder: (context, state, child) => TeacherShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.teacherHome,
            name: 'teacher-home',
            pageBuilder: (context, state) => const NoTransitionPage(child: TeacherOverviewScreen()),
          ),
          GoRoute(
            path: AppRoutes.teacherAsistenciaSchedule,
            name: 'teacher-asistencia-schedule',
            pageBuilder: (context, state) => const NoTransitionPage(child: AttendanceSchedulePage(isAdmin: false)),
          ),
          GoRoute(
            path: AppRoutes.teacherAsistencia,
            name: 'teacher-asistencia',
            pageBuilder: (context, state) {
              final sessionId = state.pathParameters['sessionId']!;
              final fecha = state.uri.queryParameters['fecha'];
              final fullId = fecha != null ? '$sessionId|$fecha' : sessionId;
              return NoTransitionPage(child: AttendanceSessionPage(sessionId: fullId));
            },
          ),
          GoRoute(
            path: AppRoutes.teacherHorario,
            name: 'teacher-horario',
            pageBuilder: (context, state) => const NoTransitionPage(child: HorarioScreen(isStudent: false)),
          ),
          GoRoute(
            path: AppRoutes.teacherAlumnos,
            name: 'teacher-alumnos',
            pageBuilder: (context, state) => const NoTransitionPage(child: TeacherAlumnosScreen()),
          ),
          GoRoute(
            path: AppRoutes.teacherStudentDetail,
            name: 'teacher-student-detail',
            pageBuilder: (context, state) {
              final id = state.pathParameters['studentId']!;
              return NoTransitionPage(child: StudentDetailScreen(studentId: int.parse(id)));
            },
          ),
          GoRoute(
            path: AppRoutes.teacherFestivos,
            name: 'teacher-festivos',
            pageBuilder: (context, state) => const NoTransitionPage(child: FestivosScreen()),
          ),
          GoRoute(
            path: AppRoutes.teacherCursos,
            name: 'teacher-cursos',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminCursosScreen()),
          ),
          GoRoute(
            path: AppRoutes.teacherIncidencias,
            name: 'teacher-incidencias',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminIncidenciasScreen()),
          ),
          GoRoute(
            path: AppRoutes.teacherHistorial,
            name: 'teacher-historial',
            pageBuilder: (context, state) => const NoTransitionPage(child: TeacherHistorialScreen()),
          ),
          GoRoute(
            path: AppRoutes.teacherSettings,
            name: 'teacher-configuracion',
            pageBuilder: (context, state) => const NoTransitionPage(child: TeacherSettingsScreen()),
          ),
          GoRoute(
            path: AppRoutes.teacherProfile,
            name: 'teacher-perfil',
            pageBuilder: (context, state) => const NoTransitionPage(child: UserProfileScreen()),
          ),
          GoRoute(
            path: AppRoutes.teacherNormas,
            name: 'teacher-normas',
            pageBuilder: (context, state) => const NoTransitionPage(child: ReglamentoViewerScreen()),
          ),
        ],
      ),

      // ── Shell del Alumno ──
      ShellRoute(
        builder: (context, state, child) => StudentShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.studentHome,
            name: 'student-home',
            builder: (context, state) => const StudentOverviewScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentHorario,
            name: 'student-horario',
            builder: (context, state) => const HorarioScreen(isStudent: true),
          ),
          GoRoute(
            path: AppRoutes.studentFestivos,
            name: 'student-festivos',
            builder: (context, state) => const FestivosScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentAsistencia,
            name: 'student-asistencia',
            pageBuilder: (context, state) => const NoTransitionPage(child: StudentAsistenciaScreen()),
          ),
          GoRoute(
            path: AppRoutes.studentFicha,
            name: 'student-ficha',
            pageBuilder: (context, state) => const NoTransitionPage(child: StudentFichaScreen()),
          ),
          GoRoute(
            path: AppRoutes.studentIncidencias,
            name: 'student-incidencias',
            pageBuilder: (context, state) => const NoTransitionPage(child: AdminIncidenciasScreen()),
          ),
          GoRoute(
            path: AppRoutes.studentSettings,
            name: 'student-configuracion',
            pageBuilder: (context, state) => const NoTransitionPage(child: UserProfileScreen()),
          ),
          GoRoute(
            path: AppRoutes.studentProfile,
            name: 'student-perfil',
            pageBuilder: (context, state) => const NoTransitionPage(child: UserProfileScreen()),
          ),
          GoRoute(
            path: AppRoutes.studentNormas,
            name: 'student-normas',
            pageBuilder: (context, state) => const NoTransitionPage(child: ReglamentoViewerScreen()),
          ),
        ],
      ),
    ],

    // ── Pantalla de error de navegación ──
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context).paginaNoEncontrada(state.uri.toString())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.login),
              child: Text(AppLocalizations.of(context).irAlInicio),
            ),
          ],
        ),
      ),
    ),
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Placeholders de páginas — se implementan en los siguientes archivos
// Evitan errores de importación hasta que se creen las pantallas reales
// ─────────────────────────────────────────────────────────────────────────────

class AdminDashboardPage     extends StatelessWidget { const AdminDashboardPage({super.key}); @override Widget build(BuildContext context) => _PagePlaceholder('Dashboard Admin'); }
class AdminAlumnosPage       extends StatelessWidget { const AdminAlumnosPage({super.key}); @override Widget build(BuildContext context) => _PagePlaceholder('Gestión Alumnos'); }
class AdminProfesoresPage    extends StatelessWidget { const AdminProfesoresPage({super.key}); @override Widget build(BuildContext context) => _PagePlaceholder('Gestión Profesores'); }
class AdminCursosPage        extends StatelessWidget { const AdminCursosPage({super.key}); @override Widget build(BuildContext context) => _PagePlaceholder('Gestión Cursos'); }
class AdminFestivosPage      extends StatelessWidget { const AdminFestivosPage({super.key}); @override Widget build(BuildContext context) => _PagePlaceholder('Festivos'); }

class _PagePlaceholder extends StatelessWidget {
  final String titulo;
  const _PagePlaceholder(this.titulo);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(titulo)),
    body: Center(child: Text(titulo, style: Theme.of(context).textTheme.headlineMedium)),
  );
}



