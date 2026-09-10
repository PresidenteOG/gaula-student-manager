// Constantes de endpoints de la API GAULA.
// URLs base provienen de [AppEnv] — inyectadas en tiempo de compilación
// mediante `--dart-define-from-file`. No existe ninguna URL hardcodeada aquí.
// Para cambiar el entorno modifica env/*.json y pasa
// `--dart-define-from-file=env/prod.json` al build. No toques este archivo.
import 'app_env.dart';

class ApiConstants {
  ApiConstants._(); // Constructor privado — clase de utilidades puras

  // ── URLs base (delegadas al lector de entorno) ────────────────────────────

  /// URL base de la API REST. Proviene de AppEnv.apiBaseUrl (compile-time).
  static String get baseUrl       => AppEnv.apiBaseUrl;

  /// URL base del servidor de uploads. Proviene de AppEnv.uploadsBaseUrl.
  static String get uploadsBaseUrl => AppEnv.uploadsBaseUrl;

  // ── Timeouts de red (delegados al lector de entorno) ─────────────────────

  static Duration get connectTimeout => AppEnv.connectTimeout;
  static Duration get receiveTimeout => AppEnv.receiveTimeout;
  static Duration get sendTimeout    => AppEnv.sendTimeout;

  // ── Endpoints de autenticación ────────────────────────────────────────────

  static const String login          = 'auth/login';
  static const String logout         = 'auth/logout';
  static const String forgotPassword = 'auth/forgot-password';
  static const String resetPassword  = 'auth/reset-password';
  static const String changePassword = 'auth/change-password';

  // ── Endpoints de perfil y archivos ────────────────────────────────────────

  static const String profile       = 'profile';
  static const String profileAvatar = 'profile/avatar';
  static const String profileTheme  = 'profile/theme';

  // ── Endpoints de festivos ─────────────────────────────────────────────────

  static const String festivos                = 'festivos';
  static const String festivosTodos           = 'festivos/todos';
  static const String festivosProvincias      = 'festivos/provincias';
  static const String festivosProvincia       = 'festivos/provincia';
  static const String festivosProvinciaActual = 'festivos/provincia-actual';

  // ── Endpoints de alumnos ──────────────────────────────────────────────────

  static const String alumnos = 'alumnos';
  static String alumnoById(int id)           => 'alumnos/$id';
  static String alumnosByCurso(int cursoId)  => 'alumnos/curso/$cursoId';
  static String alumnoEstado(int id)         => 'alumnos/$id/estado';
  static String alumnoMaterias(int id)       => 'alumnos/$id/materias';
  static String alumnoPassword(int id)       => 'alumnos/$id/password';
  static const String alumnosSinMatricular   =  'alumnos/sin-matricular';

  // ── Endpoints de profesores ───────────────────────────────────────────────

  static const String profesores = 'profesores';
  static String profesorById(int id)           => 'profesores/$id';
  static String profesorEstado(int id)         => 'profesores/$id/estado';
  static String profesorSustituto(int id)      => 'profesores/$id/sustituto';
  static String profesorPassword(int id)       => 'profesores/$id/password';

  // ── Endpoints de cursos ───────────────────────────────────────────────────

  static const String cursos = 'cursos';
  static String cursoById(int id)                          => 'cursos/$id';
  static String cursosByEscolar(int cursoEscolarId)        => 'cursos/escolar/$cursoEscolarId';
  static String cursoMaterias(int cursoId)                 => 'cursos/$cursoId/materias';
  static String cursoTutor(int cursoId, int profesorId)    => 'cursos/$cursoId/tutor/$profesorId';

  // ── Endpoints de horario ───────────────────────────────────────────────────

  static const String horarios                         = 'horarios';
  static String horarioById(int id)                    => 'horarios/$id';
  static String hideHorario(int id)                    => 'horarios/$id/hide';
  static String sesionesProfesor(int profesorId)       => 'horarios/profesor/$profesorId';
  static String horarioAlumno(int alumnoId)            => 'horarios/alumno/$alumnoId';
  static String alumnosBySesion(String sesionId)       => 'horarios/$sesionId/alumnos';
  static String horarioCurso(int cursoId)              => 'horarios/curso/$cursoId';
  static String proximaSesionProfesor(int profesorId)  => 'horarios/proxima-clase/$profesorId';
  static String obtenerSesion(String sesionId)         => 'horarios/$sesionId';

  // ── Endpoints de asistencia ───────────────────────────────────────────────

  static String asistenciaAlumno(String alumnoId)      => 'asistencia/alumno/$alumnoId';
  static String asistenciaResumenAlumno(int alumnoId)  => 'asistencia/resumen/$alumnoId';
  static String asistenciaSesionFecha(String sessionId, String fecha) => 'asistencia/sesion/$sessionId/$fecha';
  static String eliminarAsistencia(int id)             => 'asistencia/$id';
  static String justificarAsistencia(int id)           => 'asistencia/$id/justificar';

  // ── Endpoints de clases ─────────────────────────────────────

  static const String clases = 'clases';
  //static String actualizarAsistencia(String claseId)    => 'clases/$claseId';
  static const String clasesHistorialGlobal             =  'clases/historial/global';
  static String historialClasesProfesor(int profesorId) => 'clases/historial/profesor/$profesorId';
  static String sesionesPendientesHoy(int profesorId)   => 'clases/pendientes/$profesorId';

  // ── Endpoints de administración ───────────────────────────────────────────

  static const String adminAniosEscolares    = 'admin/anios-escolares';
  static const String adminConfiguracion     = 'admin/configuracion';
  static const String adminDashboard         = 'admin/dashboard';
  static String adminCursoEscolarById(int id)  => 'admin/anios-escolares/$id';
  static String adminActivarEscolar(int id)    => 'admin/anios-escolares/$id/activar';
  static String adminDesactivarEscolar(int id) => 'admin/anios-escolares/$id/desactivar';
  static String adminConfigByKey(String clave) => 'admin/configuracion/$clave';
  static String adminGenerarHorario(int cursoId) => 'admin/cursos/$cursoId/generar-horario';
  static String adminMateriaColor(int materiaId) => 'admin/materias/$materiaId/color';

  // ── Endpoints de plantilla de cursos ─────────────────────────────────────

  static const String cursoPlantillas = 'curso-plantillas';
  static String cursoPlantillaById(int id)           => 'curso-plantillas/$id';
  static String cursoPlantillaMaterias(int cursoId)  => 'curso-plantillas/$cursoId/materias';
  static String cursoPlantillaMateriaById(int id)    => 'curso-plantillas/materias/$id';

  // ── Endpoints de incidencias ─────────────────────────────────────────────────

  static const String incidencias = 'incidencias';
  static String incidenciaById(int id)            => 'incidencias/$id';
  static String incidenciasByAlumno(int alumnoId) => 'incidencias/alumno/$alumnoId';
  static String incidenciaEstado(int id)          => 'incidencias/$id/estado';

  // ── Endpoints de notificaciones ──────────────────────────────────────────────
  static const String notificaciones           = 'notificaciones';
  static String notifMarkAsRead(int id)        =>'notificaciones/$id/read';
  static const String notifMarkAllAsRead       = 'notificaciones/read-all';

  // ── Endpoints del reglamento ─────────────────────────────────────────────────
  static const String reclamentoActivo         = 'reglamento/activo';
  static String reglamentoActivar(int id)      =>'reglamento/$id/activar';
  static const String reglamentoHistorial      = 'reglamento/historial';
}
