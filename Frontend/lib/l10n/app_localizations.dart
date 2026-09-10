import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es')
  ];

  /// Título de la aplicación
  ///
  /// In es, this message translates to:
  /// **'GAULA — Gestor de Clases'**
  String get appTitle;

  /// Estado de carga genérico
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// Error genérico
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get errorGenerico;

  /// No description provided for @reintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get reintentar;

  /// Botón guardar
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get guardar;

  /// Botón cancelar
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// Botón cerrar
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get cerrar;

  /// Botón volver
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get volver;

  /// Botón confirmar
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirmar;

  /// Acción de búsqueda
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get buscar;

  /// Placeholder de búsqueda
  ///
  /// In es, this message translates to:
  /// **'Buscar...'**
  String get buscarPlaceholder;

  /// Estado vacío genérico
  ///
  /// In es, this message translates to:
  /// **'Sin datos disponibles.'**
  String get sinDatos;

  /// Botón aceptar
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get aceptar;

  /// Botón eliminar
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get eliminar;

  /// Botón justificar falta
  ///
  /// In es, this message translates to:
  /// **'Justificar'**
  String get justificar;

  /// Botón editar
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editar;

  /// Botón crear
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get crear;

  /// Botón agregar
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get agregar;

  /// Botón ver
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get ver;

  /// Botón exportar
  ///
  /// In es, this message translates to:
  /// **'Exportar'**
  String get exportar;

  /// Botón importar
  ///
  /// In es, this message translates to:
  /// **'Importar'**
  String get importar;

  /// Botón actualizar/refrescar
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get actualizar;

  /// Paginación
  ///
  /// In es, this message translates to:
  /// **'Página {actual} de {total}'**
  String pagina(int actual, int total);

  /// Navegación: Inicio
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navInicio;

  /// Navegación: Asistencia
  ///
  /// In es, this message translates to:
  /// **'Asistencia'**
  String get navAsistencia;

  /// Navegación: Calendario
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get navCalendario;

  /// Navegación: Alumnos
  ///
  /// In es, this message translates to:
  /// **'Alumnos'**
  String get navAlumnos;

  /// Navegación: Profesores
  ///
  /// In es, this message translates to:
  /// **'Profesores'**
  String get navProfesores;

  /// Navegación: Cursos
  ///
  /// In es, this message translates to:
  /// **'Cursos'**
  String get navCursos;

  /// Navegación: Incidencias
  ///
  /// In es, this message translates to:
  /// **'Incidencias'**
  String get navIncidencias;

  /// Navegación: Reglamento
  ///
  /// In es, this message translates to:
  /// **'Reglamento'**
  String get navReglamento;

  /// Navegación: Cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get navCerrarSesion;

  /// Navegación: Resumen/Dashboard
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get navResumen;

  /// Navegación: Planes de Estudios
  ///
  /// In es, this message translates to:
  /// **'Planes de Estudios'**
  String get navPlanesEstudios;

  /// Navegación: Configuración
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get navConfiguracion;

  /// Navegación: Copia de Seguridad
  ///
  /// In es, this message translates to:
  /// **'Copia Seguridad'**
  String get navCopiaSeguridad;

  /// Navegación: Mi Horario
  ///
  /// In es, this message translates to:
  /// **'Mi Horario'**
  String get navMiHorario;

  /// Navegación: Normas del Centro
  ///
  /// In es, this message translates to:
  /// **'Normas del Centro'**
  String get navNormasCentro;

  /// Navegación: Historial de Clases
  ///
  /// In es, this message translates to:
  /// **'Historial Clases'**
  String get navHistorialClases;

  /// Navegación: Mi Perfil
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get navMiPerfil;

  /// Navegación: Ajustes
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get navAjustes;

  /// Navegación: Mi Asistencia (alumno)
  ///
  /// In es, this message translates to:
  /// **'Mi Asistencia'**
  String get navMiAsistencia;

  /// Navegación: Historial
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get navHistorial;

  /// Navegación: Mi Ficha
  ///
  /// In es, this message translates to:
  /// **'Mi Ficha'**
  String get navMiFicha;

  /// Navegación: Mis Incidencias
  ///
  /// In es, this message translates to:
  /// **'Mis Incidencias'**
  String get navMisIncidencias;

  /// Navegación: Pasar Lista
  ///
  /// In es, this message translates to:
  /// **'Pasar Lista'**
  String get navPasarLista;

  /// Rol: Administrador
  ///
  /// In es, this message translates to:
  /// **'ADMINISTRADOR'**
  String get rolAdministrador;

  /// Rol: Profesor
  ///
  /// In es, this message translates to:
  /// **'PROFESOR'**
  String get rolProfesor;

  /// Rol: Alumno
  ///
  /// In es, this message translates to:
  /// **'ALUMNO'**
  String get rolAlumno;

  /// Título del shell admin
  ///
  /// In es, this message translates to:
  /// **'Panel Administrativo'**
  String get shellAdminTitulo;

  /// Subtítulo del shell admin
  ///
  /// In es, this message translates to:
  /// **'Gestión Central GAULA'**
  String get shellAdminSubtitulo;

  /// Título del shell admin en móvil
  ///
  /// In es, this message translates to:
  /// **'GAULA Admin'**
  String get shellAdminTituloMovil;

  /// Título del shell docente
  ///
  /// In es, this message translates to:
  /// **'Portal Docente'**
  String get shellTeacherTitulo;

  /// Subtítulo del shell docente
  ///
  /// In es, this message translates to:
  /// **'Gestión Educativa GAULA'**
  String get shellTeacherSubtitulo;

  /// Título del shell docente en móvil
  ///
  /// In es, this message translates to:
  /// **'GAULA Docente'**
  String get shellTeacherTituloMovil;

  /// Subtítulo del shell alumno
  ///
  /// In es, this message translates to:
  /// **'Panel de Alumno'**
  String get shellStudentSubtitulo;

  /// Saludo de bienvenida con nombre
  ///
  /// In es, this message translates to:
  /// **'Hola, {nombre}'**
  String saludoHola(String nombre);

  /// Estado vacío notificaciones
  ///
  /// In es, this message translates to:
  /// **'No hay notificaciones'**
  String get sinNotificaciones;

  /// Título pantalla login
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get loginTitulo;

  /// Campo usuario en login
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get loginUsuario;

  /// Campo contraseña en login
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get loginContrasena;

  /// Botón de login
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get loginBoton;

  /// Error de credenciales en login
  ///
  /// In es, this message translates to:
  /// **'Usuario o contraseña incorrectos.'**
  String get loginErrorCredenciales;

  /// Error de conexión en login
  ///
  /// In es, this message translates to:
  /// **'Error de conexión. ¿Está el servidor arrancado?'**
  String get loginErrorConexion;

  /// Stat: Clases de hoy
  ///
  /// In es, this message translates to:
  /// **'Clases hoy'**
  String get dashClasesHoy;

  /// Stat: Alumnos totales
  ///
  /// In es, this message translates to:
  /// **'Alumnos totales'**
  String get dashAlumnosTotales;

  /// Stat: Incidencias de hoy
  ///
  /// In es, this message translates to:
  /// **'Incidencias hoy'**
  String get dashIncidenciasHoy;

  /// Stat: Asistencia media
  ///
  /// In es, this message translates to:
  /// **'Asistencia media'**
  String get dashAsistenciaMedia;

  /// Stat: Asistencia total del alumno
  ///
  /// In es, this message translates to:
  /// **'Asistencia total'**
  String get dashAsistenciaTotal;

  /// Stat: Ausencias
  ///
  /// In es, this message translates to:
  /// **'Ausencias'**
  String get dashAusencias;

  /// Stat: Retrasos
  ///
  /// In es, this message translates to:
  /// **'Retrasos'**
  String get dashRetrasos;

  /// Stat: Horas Faltadas
  ///
  /// In es, this message translates to:
  /// **'Horas Faltadas'**
  String get dashHorasFaltadas;

  /// Stat: Clases Totales
  ///
  /// In es, this message translates to:
  /// **'Clases Totales'**
  String get dashClasesTotales;

  /// Sección: Listas pendientes de pasar
  ///
  /// In es, this message translates to:
  /// **'Listas Pendientes'**
  String get seccionListasPendientes;

  /// Estado: no hay listas pendientes
  ///
  /// In es, this message translates to:
  /// **'Todo al día 🎉'**
  String get todoAlDia;

  /// Sección: Próximas clases del día
  ///
  /// In es, this message translates to:
  /// **'Próximas Clases'**
  String get seccionProximasClases;

  /// Estado vacío: sin clases hoy (profesor)
  ///
  /// In es, this message translates to:
  /// **'No tienes clases hoy'**
  String get sinClasesHoy;

  /// Estado vacío: sin clases próximas
  ///
  /// In es, this message translates to:
  /// **'No tienes clases próximas ahora'**
  String get sinClasesProximas;

  /// Banner de acceso rápido al pase de lista
  ///
  /// In es, this message translates to:
  /// **'Acceso Rápido'**
  String get accesRapido;

  /// Botón del banner: ir a pasar lista
  ///
  /// In es, this message translates to:
  /// **'Ir a Pasar Lista'**
  String get irAPasarLista;

  /// Etiqueta próxima clase en banner
  ///
  /// In es, this message translates to:
  /// **'Próxima: {materia}'**
  String proximaClaseLabel(String materia);

  /// Etiqueta aula y horario
  ///
  /// In es, this message translates to:
  /// **'Aula: {aula} • {horaInicio} - {horaFin}'**
  String aulaHoraLabel(String aula, String horaInicio, String horaFin);

  /// Error cargando próxima clase
  ///
  /// In es, this message translates to:
  /// **'Error al cargar próxima clase'**
  String get errorCargarProximaClase;

  /// Sección: Mis Clases de Hoy (alumno)
  ///
  /// In es, this message translates to:
  /// **'Mis Clases de Hoy'**
  String get misClasesHoy;

  /// Enlace/botón al horario completo
  ///
  /// In es, this message translates to:
  /// **'Horario Completo'**
  String get horarioCompleto;

  /// Estado de carga del horario
  ///
  /// In es, this message translates to:
  /// **'Cargando horario...'**
  String get cargandoHorario;

  /// Error al cargar horario
  ///
  /// In es, this message translates to:
  /// **'Error cargando horario'**
  String get errorCargandoHorario;

  /// Estado vacío: sin clases hoy (alumno)
  ///
  /// In es, this message translates to:
  /// **'No tienes clases programadas para hoy'**
  String get sinClasesHoyAlumno;

  /// Fallback nombre estudiante en saludo
  ///
  /// In es, this message translates to:
  /// **'Estudiante'**
  String get saludoEstudiante;

  /// Fallback nombre profesor en saludo
  ///
  /// In es, this message translates to:
  /// **'Profesor'**
  String get saludoProfesor;

  /// Título pantalla historial de clases alumno
  ///
  /// In es, this message translates to:
  /// **'Historial de Clases'**
  String get historialTitulo;

  /// Subtítulo pantalla historial
  ///
  /// In es, this message translates to:
  /// **'Registro completo de todas tus sesiones de clase'**
  String get historialSubtitulo;

  /// Estado vacío historial
  ///
  /// In es, this message translates to:
  /// **'No hay historial de clases todavía'**
  String get historialVacio;

  /// Descripción estado vacío historial
  ///
  /// In es, this message translates to:
  /// **'Tu historial de asistencia aparecerá aquí conforme el profesor pase lista'**
  String get historialVacioDesc;

  /// Etiqueta 'Hoy' en clases
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get fechaHoy;

  /// Título pantalla asistencia alumno
  ///
  /// In es, this message translates to:
  /// **'Mi Asistencia'**
  String get asistenciaTitulo;

  /// Pestaña materias en asistencia
  ///
  /// In es, this message translates to:
  /// **'Materias'**
  String get asistenciaMaterias;

  /// Pestaña registro en asistencia
  ///
  /// In es, this message translates to:
  /// **'Registro'**
  String get asistenciaRegistro;

  /// Estado: ausente
  ///
  /// In es, this message translates to:
  /// **'Ausente'**
  String get asistenciaAusente;

  /// Estado: retraso
  ///
  /// In es, this message translates to:
  /// **'Retraso'**
  String get asistenciaRetraso;

  /// Estado: justificado
  ///
  /// In es, this message translates to:
  /// **'Justificado'**
  String get asistenciaJustificado;

  /// Estado: presente
  ///
  /// In es, this message translates to:
  /// **'Presente'**
  String get asistenciaPresente;

  /// Estado vacío en registro asistencia
  ///
  /// In es, this message translates to:
  /// **'Sin registros de faltas/retrasos.'**
  String get asistenciaSinFaltas;

  /// Acción pasar lista
  ///
  /// In es, this message translates to:
  /// **'Pasar Lista'**
  String get asistenciaPasarLista;

  /// Estado asistencia: Presente
  ///
  /// In es, this message translates to:
  /// **'PRESENTE'**
  String get estadoPresente;

  /// Estado asistencia: Ausente
  ///
  /// In es, this message translates to:
  /// **'AUSENTE'**
  String get estadoAusente;

  /// Estado asistencia: Retraso
  ///
  /// In es, this message translates to:
  /// **'RETRASO'**
  String get estadoRetraso;

  /// Estado asistencia: Justificado
  ///
  /// In es, this message translates to:
  /// **'JUSTIFICADO'**
  String get estadoJustificado;

  /// Estado: Activo
  ///
  /// In es, this message translates to:
  /// **'ACTIVO'**
  String get estadoActivo;

  /// Estado: Inactivo
  ///
  /// In es, this message translates to:
  /// **'INACTIVO'**
  String get estadoInactivo;

  /// Estado matrícula: Matriculado
  ///
  /// In es, this message translates to:
  /// **'MATRICULADO'**
  String get estadoMatriculado;

  /// Estado incidencia: Abierto
  ///
  /// In es, this message translates to:
  /// **'ABIERTO'**
  String get estadoAbierto;

  /// Estado incidencia: En proceso
  ///
  /// In es, this message translates to:
  /// **'EN PROCESO'**
  String get estadoEnProceso;

  /// Estado incidencia: Cerrado
  ///
  /// In es, this message translates to:
  /// **'CERRADO'**
  String get estadoCerrado;

  /// Título pantalla festivos
  ///
  /// In es, this message translates to:
  /// **'Calendario de Festivos'**
  String get calendarioTitulo;

  /// Subtítulo pantalla festivos
  ///
  /// In es, this message translates to:
  /// **'Días no lectivos y festividades académicas sincronizadas'**
  String get calendarioSubtitulo;

  /// Sección próximos festivos
  ///
  /// In es, this message translates to:
  /// **'PRÓXIMOS DÍAS'**
  String get calendarioProximosDias;

  /// Botón configurar región festivos
  ///
  /// In es, this message translates to:
  /// **'CONFIGURAR REGIÓN'**
  String get calendarioConfigurarRegion;

  /// Botón sincronizar festivos
  ///
  /// In es, this message translates to:
  /// **'Sincronizar Festivos'**
  String get calendarioSincronizar;

  /// Estado vacío festivos
  ///
  /// In es, this message translates to:
  /// **'No hay festivos registrados para este período.'**
  String get calendarioSinFestivos;

  /// Chip: festivo nacional
  ///
  /// In es, this message translates to:
  /// **'Nacional'**
  String get calendarioNacional;

  /// Chip: festivo autonómico
  ///
  /// In es, this message translates to:
  /// **'Autonómico'**
  String get calendarioAutonomico;

  /// Título diálogo selección de curso
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Curso'**
  String get seleccionarCurso;

  /// Descripción diálogo selección de curso
  ///
  /// In es, this message translates to:
  /// **'Selecciona un curso para ver sus materias disponibles hoy.'**
  String get seleccionarCursoDesc;

  /// Descripción diálogo selección de materia
  ///
  /// In es, this message translates to:
  /// **'Selecciona la materia para ver sus sesiones.'**
  String get seleccionarMateriaDesc;

  /// Descripción diálogo selección de sesión
  ///
  /// In es, this message translates to:
  /// **'Selecciona la sesión exacta para pasar lista.'**
  String get seleccionarSesionDesc;

  /// Estado vacío sesiones de hoy
  ///
  /// In es, this message translates to:
  /// **'No hay sesiones para hoy.'**
  String get sinSesionesHoy;

  /// Estado vacío materias
  ///
  /// In es, this message translates to:
  /// **'No hay materias en este curso.'**
  String get sinMaterias;

  /// Estado vacío cursos
  ///
  /// In es, this message translates to:
  /// **'No se encontraron cursos.'**
  String get sinCursos;

  /// Botón volver al listado de clases
  ///
  /// In es, this message translates to:
  /// **'Volver a mis clases'**
  String get volverMisClases;

  /// Modo asistencia uno en uno
  ///
  /// In es, this message translates to:
  /// **'Uno en Uno'**
  String get modoUnoEnUno;

  /// Modo asistencia clásico (grid)
  ///
  /// In es, this message translates to:
  /// **'Clásico'**
  String get modoClasico;

  /// Etiqueta foto de perfil
  ///
  /// In es, this message translates to:
  /// **'Foto de perfil'**
  String get perfilFoto;

  /// Acción cambiar foto de perfil
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto'**
  String get perfilCambiarFoto;

  /// Error genérico del servidor
  ///
  /// In es, this message translates to:
  /// **'Error del servidor. Inténtalo de nuevo más tarde.'**
  String get errorServidor;

  /// Mensaje de modo mantenimiento
  ///
  /// In es, this message translates to:
  /// **'El servidor está en mantenimiento. Vuelve en unos minutos.'**
  String get mantenimiento;

  /// Título pantalla alumnos
  ///
  /// In es, this message translates to:
  /// **'Alumnos'**
  String get alumnosTitulo;

  /// Botón nuevo alumno
  ///
  /// In es, this message translates to:
  /// **'Nuevo Alumno'**
  String get alumnoNuevo;

  /// Título diálogo editar alumno
  ///
  /// In es, this message translates to:
  /// **'Editar Alumno'**
  String get alumnoEditar;

  /// Mensaje éxito registro alumno
  ///
  /// In es, this message translates to:
  /// **'Alumno registrado correctamente'**
  String get alumnoRegistrado;

  /// Mensaje éxito actualización alumno
  ///
  /// In es, this message translates to:
  /// **'Alumno actualizado correctamente'**
  String get alumnoActualizado;

  /// Mensaje éxito eliminación alumno
  ///
  /// In es, this message translates to:
  /// **'Alumno eliminado correctamente'**
  String get alumnoEliminado;

  /// Error al registrar alumno
  ///
  /// In es, this message translates to:
  /// **'Error al registrar alumno'**
  String get errorRegistrarAlumno;

  /// Campo nombre alumno
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get alumnoNombre;

  /// Campo apellidos alumno
  ///
  /// In es, this message translates to:
  /// **'Apellidos'**
  String get alumnoApellidos;

  /// Campo email alumno
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get alumnoEmail;

  /// Campo DNI alumno
  ///
  /// In es, this message translates to:
  /// **'DNI'**
  String get alumnoDni;

  /// Campo usuario alumno
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get alumnoUsuario;

  /// Campo contraseña alumno
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get alumnoContrasena;

  /// Campo curso del alumno
  ///
  /// In es, this message translates to:
  /// **'Curso'**
  String get alumnoCurso;

  /// Alumno sin curso asignado
  ///
  /// In es, this message translates to:
  /// **'Sin asignar'**
  String get alumnoSinCurso;

  /// Alumnos sin matricular en ningún curso
  ///
  /// In es, this message translates to:
  /// **'Sin matricular'**
  String get alumnoSinMatricular;

  /// Título pantalla profesores
  ///
  /// In es, this message translates to:
  /// **'Profesores'**
  String get profesoresTitulo;

  /// Botón nuevo profesor
  ///
  /// In es, this message translates to:
  /// **'Nuevo Profesor'**
  String get profesorNuevo;

  /// Título diálogo editar profesor
  ///
  /// In es, this message translates to:
  /// **'Editar Profesor'**
  String get profesorEditar;

  /// Mensaje éxito registro profesor
  ///
  /// In es, this message translates to:
  /// **'Profesor registrado correctamente'**
  String get profesorRegistrado;

  /// Mensaje éxito actualización profesor
  ///
  /// In es, this message translates to:
  /// **'Profesor actualizado correctamente'**
  String get profesorActualizado;

  /// Mensaje éxito eliminación profesor
  ///
  /// In es, this message translates to:
  /// **'Profesor eliminado correctamente'**
  String get profesorEliminado;

  /// Título pantalla cursos
  ///
  /// In es, this message translates to:
  /// **'Cursos'**
  String get cursosTitulo;

  /// Botón crear nuevo curso
  ///
  /// In es, this message translates to:
  /// **'Crear Nuevo Curso'**
  String get cursoNuevo;

  /// Botón eliminar curso
  ///
  /// In es, this message translates to:
  /// **'Eliminar Curso'**
  String get cursoEliminar;

  /// Mensaje éxito eliminación curso
  ///
  /// In es, this message translates to:
  /// **'Curso eliminado correctamente'**
  String get cursoEliminadoOk;

  /// Error al eliminar curso con dependencias
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar curso. Compruebe si tiene dependencias activas.'**
  String get cursoEliminadoError;

  /// Error: curso con alumnos no se puede eliminar
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar un curso que tiene alumnos matriculados.'**
  String get cursoConAlumnos;

  /// Confirmación eliminación curso
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar el curso {codigo}? Esta acción eliminará también las materias y el horario asociado.'**
  String cursoConfirmarEliminar(String codigo);

  /// Título sección matriculación con conteo
  ///
  /// In es, this message translates to:
  /// **'Matriculación de Alumnos ({count})'**
  String matriculacionTitulo(int count);

  /// Placeholder búsqueda alumnos en matriculación
  ///
  /// In es, this message translates to:
  /// **'Buscar alumnos por nombre...'**
  String get buscarAlumnos;

  /// Título pantalla incidencias
  ///
  /// In es, this message translates to:
  /// **'Incidencias'**
  String get incidenciasTitulo;

  /// Desc estado abierta
  ///
  /// In es, this message translates to:
  /// **'Nueva incidencia pendiente de revisión'**
  String get incidenciasAbiertaDesc;

  /// Desc estado cerrada
  ///
  /// In es, this message translates to:
  /// **'Incidencia resuelta y archivada'**
  String get incidenciasCerradaDesc;

  /// Etiqueta curso/grupo en detalle incidencia
  ///
  /// In es, this message translates to:
  /// **'CURSO/GRUPO'**
  String get incidenciasCursoGrupo;

  /// Sección detalle incidencia: descripción
  ///
  /// In es, this message translates to:
  /// **'DESCRIPCIÓN DE LOS HECHOS'**
  String get incidenciasDescripcionHechos;

  /// Etiqueta alumno en detalle incidencia
  ///
  /// In es, this message translates to:
  /// **'ALUMNO'**
  String get incidenciasAlumnoLabel;

  /// Etiqueta profesor en detalle incidencia
  ///
  /// In es, this message translates to:
  /// **'PROFESOR RESPONSABLE'**
  String get incidenciasProfesorResponsable;

  /// Botón resolución válida en incidencia
  ///
  /// In es, this message translates to:
  /// **'ES VÁLIDA'**
  String get incidenciasEsValida;

  /// Descripción estado en proceso
  ///
  /// In es, this message translates to:
  /// **'Se están tomando medidas disciplinarias'**
  String get incidenciasEnProcesoDesc;

  /// Mensaje cuando no hay incidencias
  ///
  /// In es, this message translates to:
  /// **'El sistema está limpio para los filtros seleccionados'**
  String get incidenciasSistemaLimpio;

  /// Botón nueva incidencia
  ///
  /// In es, this message translates to:
  /// **'Nueva Incidencia'**
  String get incidenciaNueva;

  /// Título pantalla horario
  ///
  /// In es, this message translates to:
  /// **'Horario'**
  String get horarioTitulo;

  /// Título pantalla planes de estudios
  ///
  /// In es, this message translates to:
  /// **'Planes de Estudios'**
  String get planEstudiosTitulo;

  /// Título pantalla alumnos del profesor
  ///
  /// In es, this message translates to:
  /// **'Mis Alumnos'**
  String get alumnosTituloTeacher;

  /// Título pantalla ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Ficha del Alumno'**
  String get fichaAlumnoTitulo;

  /// Título pantalla ajustes
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get ajustesTitulo;

  /// Etiqueta idioma
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// Etiqueta tema visual
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get tema;

  /// Opciones de tema
  ///
  /// In es, this message translates to:
  /// **'Claro / Oscuro'**
  String get temaClaroOscuro;

  /// Estado vacío: sin alumnos
  ///
  /// In es, this message translates to:
  /// **'No hay alumnos en este curso'**
  String get sinAlumnos;

  /// Estado vacío: sin profesores
  ///
  /// In es, this message translates to:
  /// **'No hay profesores registrados'**
  String get sinProfesores;

  /// Estado vacío: sin incidencias
  ///
  /// In es, this message translates to:
  /// **'No hay incidencias registradas'**
  String get sinIncidencias;

  /// Título diálogo confirmar eliminación
  ///
  /// In es, this message translates to:
  /// **'Confirmar eliminación'**
  String get confirmarEliminar;

  /// Advertencia acción irreversible
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer.'**
  String get accionNoDeshacer;

  /// Error genérico de conexión
  ///
  /// In es, this message translates to:
  /// **'Error de conexión'**
  String get errorConexion;

  /// Botón reintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get reintentarBoton;

  /// Título horario de alumno específico
  ///
  /// In es, this message translates to:
  /// **'Horario del Alumno'**
  String get horarioAlumno;

  /// Título horario propio del alumno
  ///
  /// In es, this message translates to:
  /// **'Mi Horario Escolar'**
  String get horarioMio;

  /// Título horario del profesor
  ///
  /// In es, this message translates to:
  /// **'Horario del Profesor'**
  String get horarioProfesor;

  /// Subtítulo horario de alumno externo
  ///
  /// In es, this message translates to:
  /// **'Visualizando planificación semanal del alumno.'**
  String get horarioAlumnoSubtitulo;

  /// Subtítulo horario propio del alumno
  ///
  /// In es, this message translates to:
  /// **'Visualiza tu planificación semanal completa.'**
  String get horarioAlumnoSubtituloPropio;

  /// Subtítulo horario del profesor
  ///
  /// In es, this message translates to:
  /// **'Gestiona sesiones semanales y eventos.'**
  String get horarioProfesorSubtitulo;

  /// Etiqueta bloque de descanso en horario
  ///
  /// In es, this message translates to:
  /// **'DESCANSO'**
  String get horarioDescanso;

  /// Título sección asignación de eventos
  ///
  /// In es, this message translates to:
  /// **'Asignación de Eventos y Exámenes'**
  String get horarioEventosAsignacion;

  /// Label tipo de evento en formulario
  ///
  /// In es, this message translates to:
  /// **'Tipo de Evento'**
  String get horarioTipoEvento;

  /// Label fecha en formulario de evento
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get horarioFecha;

  /// Label descripción en formulario de evento
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get horarioDescripcionLabel;

  /// Placeholder selector de fecha
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Fecha'**
  String get horarioFechaPlaceholder;

  /// Placeholder descripción evento
  ///
  /// In es, this message translates to:
  /// **'Ej. Examen Final DAW'**
  String get horarioDescPlaceholder;

  /// Snackbar evento añadido
  ///
  /// In es, this message translates to:
  /// **'Evento añadido correctamente'**
  String get horarioEventoAniadido;

  /// Estado vacío horario sin clases
  ///
  /// In es, this message translates to:
  /// **'No hay clases programadas.'**
  String get horarioSinClases;

  /// Error cargando horario
  ///
  /// In es, this message translates to:
  /// **'Error al cargar horario: {error}'**
  String horarioErrorCargar(Object error);

  /// Título diálogo asignar evento
  ///
  /// In es, this message translates to:
  /// **'Asignar Evento: {fecha}'**
  String horarioAsignarEvento(String fecha);

  /// Título panel eventos del día
  ///
  /// In es, this message translates to:
  /// **'Eventos: {fecha}'**
  String horarioEventosDia(String fecha);

  /// Estado vacío panel de eventos del día
  ///
  /// In es, this message translates to:
  /// **'No hay eventos asignados.'**
  String get horarioSinEventos;

  /// Hint campo descripción en diálogo evento
  ///
  /// In es, this message translates to:
  /// **'Descripción del Evento'**
  String get horarioDescripcionEvento;

  /// Nombre de aula por defecto en celda horario
  ///
  /// In es, this message translates to:
  /// **'Aula 101'**
  String get horarioAulaDefault;

  /// Botón volver a la lista de alumnos
  ///
  /// In es, this message translates to:
  /// **'Volver a alumnos'**
  String get fichaVolverAlumnos;

  /// Alumno sin grupo asignado
  ///
  /// In es, this message translates to:
  /// **'Sin grupo'**
  String get fichaSinGrupo;

  /// Campo teléfono en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get fichaTelefono;

  /// Valor no especificado en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'No especificado'**
  String get fichaNoEspecificado;

  /// Campo dirección en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get fichaDireccion;

  /// Alumno sin dirección
  ///
  /// In es, this message translates to:
  /// **'Sin dirección'**
  String get fichaSinDireccion;

  /// Título sección estadísticas en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Estadísticas de Asistencia'**
  String get fichaEstadisticasAsistencia;

  /// Título sección desglose por módulo
  ///
  /// In es, this message translates to:
  /// **'Desglose por Módulo'**
  String get fichaDesgloseModulo;

  /// Estado vacío desglose por módulo
  ///
  /// In es, this message translates to:
  /// **'No hay datos por módulo registrados.'**
  String get fichaSinDatosModulo;

  /// Stat: asistencia en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Asistencia'**
  String get fichaAsistencia;

  /// Stat: faltas en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Faltas'**
  String get fichaFaltas;

  /// Stat: retrasos en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Retrasos'**
  String get fichaRetrasos;

  /// Stat: faltas justificadas en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Justificadas'**
  String get fichaJustificadas;

  /// Stat: total clases en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Total Clases'**
  String get fichaTotalClases;

  /// Stat: horas faltadas en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Horas Faltadas'**
  String get fichaHorasFaltadas;

  /// Etiqueta riesgo en módulo
  ///
  /// In es, this message translates to:
  /// **'RIESGO'**
  String get fichaRiesgo;

  /// Etiqueta límite excedido en módulo
  ///
  /// In es, this message translates to:
  /// **'LÍMITE EXCEDIDO'**
  String get fichaLimiteExcedido;

  /// Detalle faltas en módulo
  ///
  /// In es, this message translates to:
  /// **'Faltas: {total} / {max} máx.'**
  String fichaFaltasDetalle(String total, int max);

  /// Presentes/total en módulo
  ///
  /// In es, this message translates to:
  /// **'{presentes}/{total} asistidas'**
  String fichaAsistencias(int presentes, int total);

  /// Botón ver horario completo del alumno
  ///
  /// In es, this message translates to:
  /// **'Ver Horario Completo'**
  String get fichaVerHorario;

  /// Botón crear incidencia en ficha alumno
  ///
  /// In es, this message translates to:
  /// **'Crear Incidencia'**
  String get fichaCrearIncidencia;

  /// Título diálogo horario del alumno
  ///
  /// In es, this message translates to:
  /// **'Horario de {nombre}'**
  String fichaHorarioDe(String nombre);

  /// Título modal registro asistencia
  ///
  /// In es, this message translates to:
  /// **'Registro de Asistencia'**
  String get fichaRegistroAsistencia;

  /// Título modal faltas del alumno
  ///
  /// In es, this message translates to:
  /// **'Faltas de {nombre}'**
  String fichaFaltasDe(String nombre);

  /// Título modal retrasos del alumno
  ///
  /// In es, this message translates to:
  /// **'Retrasos de {nombre}'**
  String fichaRetrasosDe(String nombre);

  /// Título modal faltas justificadas del alumno
  ///
  /// In es, this message translates to:
  /// **'Faltas Justificadas de {nombre}'**
  String fichaJustificadasDe(String nombre);

  /// Error cargando historial asistencia
  ///
  /// In es, this message translates to:
  /// **'Error al cargar historial: {error}'**
  String fichaErrorHistorial(Object error);

  /// Estado vacío registros de asistencia
  ///
  /// In es, this message translates to:
  /// **'No hay registros de este tipo.'**
  String get fichaSinRegistros;

  /// Profesor que registró la asistencia
  ///
  /// In es, this message translates to:
  /// **'Registrado por: {nombre}'**
  String fichaRegistradoPor(String nombre);

  /// Registro sin fecha disponible
  ///
  /// In es, this message translates to:
  /// **'Sin fecha'**
  String get fichaSinFecha;

  /// Subtítulo pantalla alumnos admin
  ///
  /// In es, this message translates to:
  /// **'Gestión centralizada del expediente académico y asistencia'**
  String get alumnosTituloDesc;

  /// Botón matricular alumno
  ///
  /// In es, this message translates to:
  /// **'Matricular Alumno'**
  String get matricularAlumno;

  /// Opción todos los cursos en filtro
  ///
  /// In es, this message translates to:
  /// **'Todos los Cursos'**
  String get todosCursos;

  /// Estado vacío lista alumnos
  ///
  /// In es, this message translates to:
  /// **'No se encontraron alumnos registrados'**
  String get sinAlumnosEncontrados;

  /// Título diálogo confirmar baja alumno
  ///
  /// In es, this message translates to:
  /// **'Confirmar Baja'**
  String get confirmarBaja;

  /// Título diálogo activar alumno
  ///
  /// In es, this message translates to:
  /// **'Activar Alumno'**
  String get activarAlumno;

  /// Acción dar de baja a alumno
  ///
  /// In es, this message translates to:
  /// **'Dar de Baja'**
  String get darDeBaja;

  /// Tooltip botón reporte asistencia
  ///
  /// In es, this message translates to:
  /// **'Reporte de Asistencia'**
  String get reporteAsistenciaLabel;

  /// Tooltip botón editar expediente alumno
  ///
  /// In es, this message translates to:
  /// **'Editar Expediente'**
  String get editarExpediente;

  /// Subtítulo pantalla profesores
  ///
  /// In es, this message translates to:
  /// **'Gestión integral del claustro y personal administrativo'**
  String get profesoresTituloDesc;

  /// Botón registrar nuevo profesor
  ///
  /// In es, this message translates to:
  /// **'Registrar Nuevo'**
  String get registrarNuevoProfesor;

  /// Placeholder búsqueda profesores móvil
  ///
  /// In es, this message translates to:
  /// **'Buscar profesores...'**
  String get buscarProfesoresHint;

  /// Placeholder búsqueda profesores desktop
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre, especialidad o departamento...'**
  String get buscarProfesoresDetalle;

  /// Hint filtro por curso
  ///
  /// In es, this message translates to:
  /// **'Filtrar por curso...'**
  String get filtrarPorCurso;

  /// Hint filtro por rol
  ///
  /// In es, this message translates to:
  /// **'Filtrar por rol...'**
  String get filtrarPorRol;

  /// Opción todos los roles en filtro
  ///
  /// In es, this message translates to:
  /// **'Todos los Roles'**
  String get todosRoles;

  /// Etiqueta rol docente
  ///
  /// In es, this message translates to:
  /// **'Docente'**
  String get docenteLabel;

  /// Etiqueta cuerpo docente en tarjeta profesor
  ///
  /// In es, this message translates to:
  /// **'CUERPO DOCENTE'**
  String get cuerpoDocenteLabel;

  /// Etiqueta directiva/admin en tarjeta profesor
  ///
  /// In es, this message translates to:
  /// **'DIRECTIVA / ADM.'**
  String get directivaAdminLabel;

  /// Título diálogo horario semanal profesor
  ///
  /// In es, this message translates to:
  /// **'HORARIO SEMANAL REAL'**
  String get horarioSemanalReal;

  /// Placeholder filtro horario por curso/materia
  ///
  /// In es, this message translates to:
  /// **'Filtrar por curso o materia...'**
  String get filtrarCursoMateria;

  /// Estado vacío horario semanal profesor
  ///
  /// In es, this message translates to:
  /// **'No hay clases asignadas en el horario semanal'**
  String get sinClasesHorarioProfesor;

  /// Estado vacío lista profesores filtrada
  ///
  /// In es, this message translates to:
  /// **'No se encontraron profesores con los filtros aplicados'**
  String get sinProfesoresEncontrados;

  /// Botón gestionar en tarjeta profesor
  ///
  /// In es, this message translates to:
  /// **'Gestionar'**
  String get gestionar;

  /// Etiqueta sesión en columna de horario
  ///
  /// In es, this message translates to:
  /// **'SESIÓN'**
  String get sesionLabel;

  /// Subtítulo pantalla incidencias
  ///
  /// In es, this message translates to:
  /// **'Control disciplinario, convivencia y alertas tempranas'**
  String get incidenciasTituloDesc;

  /// Botón registrar nueva incidencia
  ///
  /// In es, this message translates to:
  /// **'Registrar Incidencia'**
  String get registrarIncidencia;

  /// Título diálogo actualizar estado incidencia
  ///
  /// In es, this message translates to:
  /// **'Actualizar Estado'**
  String get actualizarEstado;

  /// Título diálogo eliminar registro incidencia
  ///
  /// In es, this message translates to:
  /// **'Eliminar Registro'**
  String get eliminarRegistro;

  /// Descripción confirmación eliminar incidencia
  ///
  /// In es, this message translates to:
  /// **'Esta acción es permanente y no se podrá recuperar la información de esta incidencia.'**
  String get incidenciaEliminadaDesc;

  /// Subtítulo pantalla planes de estudios
  ///
  /// In es, this message translates to:
  /// **'Gestión curricular y planes de estudios del centro'**
  String get planEstudiosTituloDesc;

  /// Subtítulo pantalla cursos
  ///
  /// In es, this message translates to:
  /// **'Gestión de grupos y matriculación de alumnos'**
  String get cursosTituloDesc;

  /// No description provided for @authPwdOlvidasteTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get authPwdOlvidasteTitulo;

  /// No description provided for @authPwdOlvidasteDesc.
  ///
  /// In es, this message translates to:
  /// **'Introduce tu correo electrónico y te enviaremos un código de recuperación.'**
  String get authPwdOlvidasteDesc;

  /// No description provided for @authPwdCorreoHint.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get authPwdCorreoHint;

  /// No description provided for @authPwdEnviarCodigo.
  ///
  /// In es, this message translates to:
  /// **'ENVIAR CÓDIGO'**
  String get authPwdEnviarCodigo;

  /// No description provided for @authPwdVolverLogin.
  ///
  /// In es, this message translates to:
  /// **'Volver al Login'**
  String get authPwdVolverLogin;

  /// No description provided for @authPwdError.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String authPwdError(Object error);

  /// No description provided for @authPwdNoCoinciden.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get authPwdNoCoinciden;

  /// No description provided for @authPwdActualizadaOk.
  ///
  /// In es, this message translates to:
  /// **'✅ Contraseña actualizada correctamente'**
  String get authPwdActualizadaOk;

  /// No description provided for @authPwdRestablecerTitulo.
  ///
  /// In es, this message translates to:
  /// **'Restablecer Contraseña'**
  String get authPwdRestablecerTitulo;

  /// No description provided for @authPwdRestablecerDesc.
  ///
  /// In es, this message translates to:
  /// **'Introduce el código que has recibido y tu nueva contraseña.'**
  String get authPwdRestablecerDesc;

  /// No description provided for @authPwdCodigoHint.
  ///
  /// In es, this message translates to:
  /// **'CÓDIGO'**
  String get authPwdCodigoHint;

  /// No description provided for @authPwdNuevaContrasena.
  ///
  /// In es, this message translates to:
  /// **'Nueva Contraseña'**
  String get authPwdNuevaContrasena;

  /// No description provided for @authPwdConfirmarContrasena.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Contraseña'**
  String get authPwdConfirmarContrasena;

  /// No description provided for @authPwdActualizar.
  ///
  /// In es, this message translates to:
  /// **'ACTUALIZAR CONTRASEÑA'**
  String get authPwdActualizar;

  /// No description provided for @authMantTitulo.
  ///
  /// In es, this message translates to:
  /// **'Servidor en Mantenimiento'**
  String get authMantTitulo;

  /// No description provided for @authMantDesc.
  ///
  /// In es, this message translates to:
  /// **'Estamos realizando mejoras en el sistema para brindarte un mejor servicio.\nPor favor, inténtalo de nuevo en unos minutos.'**
  String get authMantDesc;

  /// No description provided for @authMantReintentar.
  ///
  /// In es, this message translates to:
  /// **'REINTENTAR CONEXIÓN'**
  String get authMantReintentar;

  /// No description provided for @authDevAutocompletar.
  ///
  /// In es, this message translates to:
  /// **'Autocompletar login (sólo devs)'**
  String get authDevAutocompletar;

  /// No description provided for @authPwdOlvidasteLink.
  ///
  /// In es, this message translates to:
  /// **'¿Has olvidado tu contraseña?'**
  String get authPwdOlvidasteLink;

  /// No description provided for @horarioEventoExamen.
  ///
  /// In es, this message translates to:
  /// **'Examen'**
  String get horarioEventoExamen;

  /// No description provided for @horarioEventoEvaluacion.
  ///
  /// In es, this message translates to:
  /// **'Evaluación'**
  String get horarioEventoEvaluacion;

  /// No description provided for @horarioEventoPresentacion.
  ///
  /// In es, this message translates to:
  /// **'Presentación'**
  String get horarioEventoPresentacion;

  /// No description provided for @horarioEventoReunion.
  ///
  /// In es, this message translates to:
  /// **'Reunión'**
  String get horarioEventoReunion;

  /// No description provided for @horarioEventoFestivo.
  ///
  /// In es, this message translates to:
  /// **'Festivo'**
  String get horarioEventoFestivo;

  /// No description provided for @horarioFechaLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get horarioFechaLabel;

  /// No description provided for @diaLunes.
  ///
  /// In es, this message translates to:
  /// **'Lunes'**
  String get diaLunes;

  /// No description provided for @diaMartes.
  ///
  /// In es, this message translates to:
  /// **'Martes'**
  String get diaMartes;

  /// No description provided for @diaMiercoles.
  ///
  /// In es, this message translates to:
  /// **'Miércoles'**
  String get diaMiercoles;

  /// No description provided for @diaJueves.
  ///
  /// In es, this message translates to:
  /// **'Jueves'**
  String get diaJueves;

  /// No description provided for @diaViernes.
  ///
  /// In es, this message translates to:
  /// **'Viernes'**
  String get diaViernes;

  /// No description provided for @userProfileGuardado.
  ///
  /// In es, this message translates to:
  /// **'Cambios guardados correctamente'**
  String get userProfileGuardado;

  /// No description provided for @userProfileMisDatos.
  ///
  /// In es, this message translates to:
  /// **'Mis Datos'**
  String get userProfileMisDatos;

  /// No description provided for @userProfileSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Gestiona tu información personal y profesional.'**
  String get userProfileSubtitulo;

  /// No description provided for @userProfileFotoActualizada.
  ///
  /// In es, this message translates to:
  /// **'Foto actualizada correctamente'**
  String get userProfileFotoActualizada;

  /// No description provided for @userProfileInfoPersonal.
  ///
  /// In es, this message translates to:
  /// **'Información Personal'**
  String get userProfileInfoPersonal;

  /// No description provided for @userProfileNombreCompleto.
  ///
  /// In es, this message translates to:
  /// **'Nombre Completo'**
  String get userProfileNombreCompleto;

  /// No description provided for @userProfileDniNie.
  ///
  /// In es, this message translates to:
  /// **'DNI/NIE'**
  String get userProfileDniNie;

  /// No description provided for @userProfileFechaNacimiento.
  ///
  /// In es, this message translates to:
  /// **'Fecha Nacimiento'**
  String get userProfileFechaNacimiento;

  /// No description provided for @userProfileInfoContacto.
  ///
  /// In es, this message translates to:
  /// **'Información de Contacto'**
  String get userProfileInfoContacto;

  /// No description provided for @userProfileTelefono.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get userProfileTelefono;

  /// No description provided for @userProfileDireccion.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get userProfileDireccion;

  /// No description provided for @userProfileSeguridad.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get userProfileSeguridad;

  /// No description provided for @userProfileSeguridadDesc.
  ///
  /// In es, this message translates to:
  /// **'Protege tu cuenta actualizando tu contraseña regularmente.'**
  String get userProfileSeguridadDesc;

  /// No description provided for @userProfileCambiarPassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar Contraseña'**
  String get userProfileCambiarPassword;

  /// No description provided for @studentAsisError.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String studentAsisError(Object error);

  /// No description provided for @studentAsisDesconocido.
  ///
  /// In es, this message translates to:
  /// **'Desconocido'**
  String get studentAsisDesconocido;

  /// No description provided for @studentAsisFaltas.
  ///
  /// In es, this message translates to:
  /// **'Faltas: {total} / {max} máx'**
  String studentAsisFaltas(Object max, Object total);

  /// No description provided for @studentAsisClasesAbrev.
  ///
  /// In es, this message translates to:
  /// **'{clases}/{horas} cl.'**
  String studentAsisClasesAbrev(Object clases, Object horas);

  /// No description provided for @studentAsisClases.
  ///
  /// In es, this message translates to:
  /// **'{clases}/{horas} clases'**
  String studentAsisClases(Object clases, Object horas);

  /// No description provided for @studentAsisProgresoClases.
  ///
  /// In es, this message translates to:
  /// **'Progreso de Clases'**
  String get studentAsisProgresoClases;

  /// No description provided for @studentFichaDatosDesc.
  ///
  /// In es, this message translates to:
  /// **'Datos personales y académicos de tu matrícula'**
  String get studentFichaDatosDesc;

  /// No description provided for @studentFichaRolAlumno.
  ///
  /// In es, this message translates to:
  /// **'ALUMNO'**
  String get studentFichaRolAlumno;

  /// No description provided for @studentFichaDatosPersonales.
  ///
  /// In es, this message translates to:
  /// **'Datos Personales'**
  String get studentFichaDatosPersonales;

  /// No description provided for @studentFichaDniNie.
  ///
  /// In es, this message translates to:
  /// **'DNI / NIE'**
  String get studentFichaDniNie;

  /// No description provided for @studentFichaTelefono.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get studentFichaTelefono;

  /// No description provided for @studentFichaDireccion.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get studentFichaDireccion;

  /// No description provided for @studentFichaFechaNacimiento.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Nacimiento'**
  String get studentFichaFechaNacimiento;

  /// No description provided for @studentFichaDatosAcademicos.
  ///
  /// In es, this message translates to:
  /// **'Datos Académicos'**
  String get studentFichaDatosAcademicos;

  /// No description provided for @studentFichaGrupo.
  ///
  /// In es, this message translates to:
  /// **'Grupo'**
  String get studentFichaGrupo;

  /// No description provided for @studentFichaEstadoMatricula.
  ///
  /// In es, this message translates to:
  /// **'Estado de Matrícula'**
  String get studentFichaEstadoMatricula;

  /// No description provided for @studentFichaMateriasMatriculadas.
  ///
  /// In es, this message translates to:
  /// **'Materias Matriculadas'**
  String get studentFichaMateriasMatriculadas;

  /// No description provided for @studentFichaModulos.
  ///
  /// In es, this message translates to:
  /// **'{count} módulos'**
  String studentFichaModulos(Object count);

  /// No description provided for @studentFichaMatriculado.
  ///
  /// In es, this message translates to:
  /// **'MATRICULADO'**
  String get studentFichaMatriculado;

  /// No description provided for @studentFichaAlumno.
  ///
  /// In es, this message translates to:
  /// **'Alumno'**
  String get studentFichaAlumno;

  /// No description provided for @studentFichaOfflineDesc.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Mostrando los datos básicos de tu perfil.'**
  String get studentFichaOfflineDesc;

  /// No description provided for @teacherAlumnosAnterior.
  ///
  /// In es, this message translates to:
  /// **'Anterior'**
  String get teacherAlumnosAnterior;

  /// No description provided for @teacherAlumnosSiguiente.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get teacherAlumnosSiguiente;

  /// No description provided for @teacherAlumnosSinGrupo.
  ///
  /// In es, this message translates to:
  /// **'Sin grupo'**
  String get teacherAlumnosSinGrupo;

  /// No description provided for @teacherAlumnosAsistencia.
  ///
  /// In es, this message translates to:
  /// **'Asistencia'**
  String get teacherAlumnosAsistencia;

  /// No description provided for @teacherAlumnosFaltas.
  ///
  /// In es, this message translates to:
  /// **'Faltas'**
  String get teacherAlumnosFaltas;

  /// No description provided for @teacherSettingsSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Personaliza tu experiencia en la plataforma GAULA'**
  String get teacherSettingsSubtitulo;

  /// No description provided for @teacherSettingsPerfilUsuario.
  ///
  /// In es, this message translates to:
  /// **'Perfil de Usuario'**
  String get teacherSettingsPerfilUsuario;

  /// No description provided for @teacherSettingsPerfilDesc.
  ///
  /// In es, this message translates to:
  /// **'Gestiona tu información personal'**
  String get teacherSettingsPerfilDesc;

  /// No description provided for @teacherSettingsVerPerfil.
  ///
  /// In es, this message translates to:
  /// **'Ver Perfil'**
  String get teacherSettingsVerPerfil;

  /// No description provided for @teacherSettingsEditarPerfil.
  ///
  /// In es, this message translates to:
  /// **'Editar Perfil'**
  String get teacherSettingsEditarPerfil;

  /// No description provided for @teacherSettingsSeguridad.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get teacherSettingsSeguridad;

  /// No description provided for @teacherSettingsSeguridadDesc.
  ///
  /// In es, this message translates to:
  /// **'Protege tu acceso al sistema'**
  String get teacherSettingsSeguridadDesc;

  /// No description provided for @teacherSettingsCambiarPass.
  ///
  /// In es, this message translates to:
  /// **'Cambiar Contraseña'**
  String get teacherSettingsCambiarPass;

  /// No description provided for @teacherSettingsSesionesActivas.
  ///
  /// In es, this message translates to:
  /// **'Sesiones Activas'**
  String get teacherSettingsSesionesActivas;

  /// No description provided for @teacherSettingsSeguridadProximamente.
  ///
  /// In es, this message translates to:
  /// **'Funcionalidad de seguridad próximamente'**
  String get teacherSettingsSeguridadProximamente;

  /// No description provided for @teacherSettingsNotificaciones.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get teacherSettingsNotificaciones;

  /// No description provided for @teacherSettingsNotificacionesDesc.
  ///
  /// In es, this message translates to:
  /// **'Configura las alertas y avisos'**
  String get teacherSettingsNotificacionesDesc;

  /// No description provided for @teacherSettingsAlertasAsistencia.
  ///
  /// In es, this message translates to:
  /// **'Alertas de Asistencia'**
  String get teacherSettingsAlertasAsistencia;

  /// No description provided for @teacherSettingsMensajesAlumnos.
  ///
  /// In es, this message translates to:
  /// **'Mensajes de Alumnos'**
  String get teacherSettingsMensajesAlumnos;

  /// No description provided for @teacherSettingsPreferencias.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get teacherSettingsPreferencias;

  /// No description provided for @teacherSettingsPreferenciasDesc.
  ///
  /// In es, this message translates to:
  /// **'Ajustes de visualización'**
  String get teacherSettingsPreferenciasDesc;

  /// No description provided for @teacherSettingsSoporte.
  ///
  /// In es, this message translates to:
  /// **'Soporte y Ayuda'**
  String get teacherSettingsSoporte;

  /// No description provided for @teacherSettingsSoporteDesc.
  ///
  /// In es, this message translates to:
  /// **'Recursos de asistencia'**
  String get teacherSettingsSoporteDesc;

  /// No description provided for @teacherSettingsNormasCentro.
  ///
  /// In es, this message translates to:
  /// **'Normas del Centro'**
  String get teacherSettingsNormasCentro;

  /// No description provided for @teacherSettingsContactarSoporte.
  ///
  /// In es, this message translates to:
  /// **'Contactar Soporte'**
  String get teacherSettingsContactarSoporte;

  /// No description provided for @teacherSettingsContactandoSoporte.
  ///
  /// In es, this message translates to:
  /// **'Contactando con soporte técnico...'**
  String get teacherSettingsContactandoSoporte;

  /// No description provided for @teacherSettingsVersion.
  ///
  /// In es, this message translates to:
  /// **'GAULA • Desarrollado por VicePresi'**
  String get teacherSettingsVersion;

  /// No description provided for @teacherSettingsCopyright.
  ///
  /// In es, this message translates to:
  /// **'© 2026 Sistema de Gestión Educativa'**
  String get teacherSettingsCopyright;

  /// No description provided for @teacherSettingsNotifPush.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones Push'**
  String get teacherSettingsNotifPush;

  /// No description provided for @teacherSettingsNotifEmail.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones por Email'**
  String get teacherSettingsNotifEmail;

  /// No description provided for @adminDashErrorMetricas.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar métricas: {error}'**
  String adminDashErrorMetricas(String error);

  /// No description provided for @adminDashDocentes.
  ///
  /// In es, this message translates to:
  /// **'Docentes'**
  String get adminDashDocentes;

  /// No description provided for @adminDashTrendEstable.
  ///
  /// In es, this message translates to:
  /// **'Estable'**
  String get adminDashTrendEstable;

  /// No description provided for @adminUsuariosErrorRedTitulo.
  ///
  /// In es, this message translates to:
  /// **'Error de red'**
  String get adminUsuariosErrorRedTitulo;

  /// No description provided for @adminUsuariosErrorRedMsg.
  ///
  /// In es, this message translates to:
  /// **'No se pudo conectar con el servidor'**
  String get adminUsuariosErrorRedMsg;

  /// No description provided for @adminUsuariosTitulo.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Usuarios'**
  String get adminUsuariosTitulo;

  /// No description provided for @adminUsuariosMonitorTiempoReal.
  ///
  /// In es, this message translates to:
  /// **'MONITOR EN TIEMPO REAL'**
  String get adminUsuariosMonitorTiempoReal;

  /// No description provided for @adminUsuariosTotal.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get adminUsuariosTotal;

  /// No description provided for @adminUsuariosRol.
  ///
  /// In es, this message translates to:
  /// **'Rol...'**
  String get adminUsuariosRol;

  /// No description provided for @adminUsuariosEstado.
  ///
  /// In es, this message translates to:
  /// **'Estado...'**
  String get adminUsuariosEstado;

  /// No description provided for @attendanceScheduleMyClasses.
  ///
  /// In es, this message translates to:
  /// **'Mis Clases'**
  String get attendanceScheduleMyClasses;

  /// No description provided for @attendanceScheduleOtherClass.
  ///
  /// In es, this message translates to:
  /// **'Pasar Lista de Otra Clase'**
  String get attendanceScheduleOtherClass;

  /// No description provided for @attendanceScheduleTodaySchedule.
  ///
  /// In es, this message translates to:
  /// **'Horario de Hoy'**
  String get attendanceScheduleTodaySchedule;

  /// No description provided for @attendanceSchedulePendingClasses.
  ///
  /// In es, this message translates to:
  /// **'Tienes {count} {count, plural, =1{clase pendiente} other{clases pendientes}} de pasar lista'**
  String attendanceSchedulePendingClasses(int count);

  /// No description provided for @attendanceScheduleNoClassesToday.
  ///
  /// In es, this message translates to:
  /// **'No hay clases programadas para hoy.'**
  String get attendanceScheduleNoClassesToday;

  /// No description provided for @attendanceScheduleHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get attendanceScheduleHistory;

  /// No description provided for @attendanceScheduleSearchByDate.
  ///
  /// In es, this message translates to:
  /// **'Buscar por fecha...'**
  String get attendanceScheduleSearchByDate;

  /// No description provided for @attendanceScheduleNoHistory.
  ///
  /// In es, this message translates to:
  /// **'No hay historial de asistencia.'**
  String get attendanceScheduleNoHistory;

  /// No description provided for @attendanceScheduleTakeAttendance.
  ///
  /// In es, this message translates to:
  /// **'Pasar Lista'**
  String get attendanceScheduleTakeAttendance;

  /// No description provided for @attendanceScheduleCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get attendanceScheduleCompleted;

  /// No description provided for @attendanceScheduleSelectCourse.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Curso'**
  String get attendanceScheduleSelectCourse;

  /// No description provided for @attendanceScheduleSelectCourseHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un curso para ver sus materias disponibles hoy.'**
  String get attendanceScheduleSelectCourseHint;

  /// No description provided for @attendanceScheduleSearchCourse.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre o código...'**
  String get attendanceScheduleSearchCourse;

  /// No description provided for @attendanceScheduleErrorLoadingYears.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar años: {error}'**
  String attendanceScheduleErrorLoadingYears(String error);

  /// No description provided for @attendanceScheduleNoCourses.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron cursos.'**
  String get attendanceScheduleNoCourses;

  /// No description provided for @attendanceScheduleSelectSubjectHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la materia para ver sus sesiones.'**
  String get attendanceScheduleSelectSubjectHint;

  /// No description provided for @attendanceScheduleNoSubjects.
  ///
  /// In es, this message translates to:
  /// **'No hay materias en este curso.'**
  String get attendanceScheduleNoSubjects;

  /// No description provided for @attendanceScheduleSubjectFallback.
  ///
  /// In es, this message translates to:
  /// **'Materia'**
  String get attendanceScheduleSubjectFallback;

  /// No description provided for @attendanceScheduleSelectSessionHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la sesión exacta para pasar lista.'**
  String get attendanceScheduleSelectSessionHint;

  /// No description provided for @attendanceScheduleNoSessionsToday.
  ///
  /// In es, this message translates to:
  /// **'No hay sesiones para hoy.'**
  String get attendanceScheduleNoSessionsToday;

  /// No description provided for @attendanceScheduleSessionsFallback.
  ///
  /// In es, this message translates to:
  /// **'Sesiones'**
  String get attendanceScheduleSessionsFallback;

  /// No description provided for @attendanceScheduleAulaFallback.
  ///
  /// In es, this message translates to:
  /// **'Aula'**
  String get attendanceScheduleAulaFallback;

  /// No description provided for @attendanceDetailRegisteredBy.
  ///
  /// In es, this message translates to:
  /// **'REGISTRADO POR:'**
  String get attendanceDetailRegisteredBy;

  /// No description provided for @attendanceDetailSystemAuto.
  ///
  /// In es, this message translates to:
  /// **'SISTEMA / AUTOMÁTICO'**
  String get attendanceDetailSystemAuto;

  /// No description provided for @attendanceDetailPresent.
  ///
  /// In es, this message translates to:
  /// **'PRESENTES'**
  String get attendanceDetailPresent;

  /// No description provided for @attendanceDetailAbsent.
  ///
  /// In es, this message translates to:
  /// **'AUSENTES'**
  String get attendanceDetailAbsent;

  /// No description provided for @attendanceDetailAttendance.
  ///
  /// In es, this message translates to:
  /// **'ASISTENCIA'**
  String get attendanceDetailAttendance;

  /// No description provided for @attendanceDetailStudentList.
  ///
  /// In es, this message translates to:
  /// **'LISTADO DE FALTAS'**
  String get attendanceDetailStudentList;

  /// No description provided for @attendanceDetailNoRecords.
  ///
  /// In es, this message translates to:
  /// **'No hay registros de asistencia para esta sesión.'**
  String get attendanceDetailNoRecords;

  /// No description provided for @attendanceDetailStudentFallback.
  ///
  /// In es, this message translates to:
  /// **'Alumno'**
  String get attendanceDetailStudentFallback;

  /// No description provided for @attendanceDetailStatusPresente.
  ///
  /// In es, this message translates to:
  /// **'PRESENTE'**
  String get attendanceDetailStatusPresente;

  /// No description provided for @attendanceDetailStatusAusente.
  ///
  /// In es, this message translates to:
  /// **'AUSENTE'**
  String get attendanceDetailStatusAusente;

  /// No description provided for @attendanceDetailStatusRetraso.
  ///
  /// In es, this message translates to:
  /// **'RETRASO'**
  String get attendanceDetailStatusRetraso;

  /// No description provided for @attendanceDetailStatusJustificado.
  ///
  /// In es, this message translates to:
  /// **'JUSTIFICADO'**
  String get attendanceDetailStatusJustificado;

  /// No description provided for @attendanceDetailStatusPendiente.
  ///
  /// In es, this message translates to:
  /// **'PENDIENTE'**
  String get attendanceDetailStatusPendiente;

  /// No description provided for @adminAuditoriaTitle.
  ///
  /// In es, this message translates to:
  /// **'Registro de Auditoría'**
  String get adminAuditoriaTitle;

  /// No description provided for @adminAuditoriaSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Trazabilidad completa de acciones administrativas'**
  String get adminAuditoriaSubtitle;

  /// No description provided for @adminAuditoriaEmpty.
  ///
  /// In es, this message translates to:
  /// **'SIN REGISTROS DE ACTIVIDAD'**
  String get adminAuditoriaEmpty;

  /// No description provided for @adminConfigTitle.
  ///
  /// In es, this message translates to:
  /// **'CONFIGURACIÓN'**
  String get adminConfigTitle;

  /// No description provided for @adminConfigSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Gestiona los parámetros globales y mantenimiento'**
  String get adminConfigSubtitle;

  /// No description provided for @adminConfigSecurityTitle.
  ///
  /// In es, this message translates to:
  /// **'Seguridad y Acceso'**
  String get adminConfigSecurityTitle;

  /// No description provided for @adminConfigSecurityDesc.
  ///
  /// In es, this message translates to:
  /// **'Control de credenciales y sesiones'**
  String get adminConfigSecurityDesc;

  /// No description provided for @adminConfigSecurityChangePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar Contraseña'**
  String get adminConfigSecurityChangePassword;

  /// No description provided for @adminConfigSecurityActiveSessions.
  ///
  /// In es, this message translates to:
  /// **'Sesiones Activas'**
  String get adminConfigSecurityActiveSessions;

  /// No description provided for @adminConfigSecurity2FA.
  ///
  /// In es, this message translates to:
  /// **'Doble Factor (2FA)'**
  String get adminConfigSecurity2FA;

  /// No description provided for @adminConfigReglamentoTitle.
  ///
  /// In es, this message translates to:
  /// **'Reglamento del Centro'**
  String get adminConfigReglamentoTitle;

  /// No description provided for @adminConfigReglamentoDesc.
  ///
  /// In es, this message translates to:
  /// **'Normativa y convivencia escolar'**
  String get adminConfigReglamentoDesc;

  /// No description provided for @adminConfigReglamentoEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar Reglamento'**
  String get adminConfigReglamentoEdit;

  /// No description provided for @adminConfigReglamentoHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de Versiones'**
  String get adminConfigReglamentoHistory;

  /// No description provided for @adminConfigReglamentoPublish.
  ///
  /// In es, this message translates to:
  /// **'Publicar Cambios'**
  String get adminConfigReglamentoPublish;

  /// No description provided for @adminConfigAuditoriaTitle.
  ///
  /// In es, this message translates to:
  /// **'Auditoría de Cambios'**
  String get adminConfigAuditoriaTitle;

  /// No description provided for @adminConfigAuditoriaDesc.
  ///
  /// In es, this message translates to:
  /// **'Registro de actividad administrativa'**
  String get adminConfigAuditoriaDesc;

  /// No description provided for @adminConfigAuditoriaViewLog.
  ///
  /// In es, this message translates to:
  /// **'Ver Log de Actividad'**
  String get adminConfigAuditoriaViewLog;

  /// No description provided for @adminConfigAuditoriaExport.
  ///
  /// In es, this message translates to:
  /// **'Exportar Reporte'**
  String get adminConfigAuditoriaExport;

  /// No description provided for @adminConfigAuditoriaAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas de Auditoría'**
  String get adminConfigAuditoriaAlerts;

  /// No description provided for @adminConfigComingSoon.
  ///
  /// In es, this message translates to:
  /// **'PRONTO'**
  String get adminConfigComingSoon;

  /// No description provided for @adminPermTitle.
  ///
  /// In es, this message translates to:
  /// **'Matriz RBAC'**
  String get adminPermTitle;

  /// No description provided for @adminPermSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Control granular de seguridad y accesos'**
  String get adminPermSubtitle;

  /// No description provided for @adminPermSyncButton.
  ///
  /// In es, this message translates to:
  /// **'SINCRONIZAR POLÍTICAS'**
  String get adminPermSyncButton;

  /// No description provided for @adminPermColRolPerfil.
  ///
  /// In es, this message translates to:
  /// **'ROL / PERFIL'**
  String get adminPermColRolPerfil;

  /// No description provided for @adminPermPermGestionAcademica.
  ///
  /// In es, this message translates to:
  /// **'Gestión Académica'**
  String get adminPermPermGestionAcademica;

  /// No description provided for @adminPermPermPasarLista.
  ///
  /// In es, this message translates to:
  /// **'Pasar Lista'**
  String get adminPermPermPasarLista;

  /// No description provided for @adminPermPermVerHistorial.
  ///
  /// In es, this message translates to:
  /// **'Ver Historial'**
  String get adminPermPermVerHistorial;

  /// No description provided for @adminPermPermCrearIncidencias.
  ///
  /// In es, this message translates to:
  /// **'Crear Incidencias'**
  String get adminPermPermCrearIncidencias;

  /// No description provided for @adminPermPermBorrarRegistros.
  ///
  /// In es, this message translates to:
  /// **'Borrar Registros'**
  String get adminPermPermBorrarRegistros;

  /// No description provided for @adminPermPermConfigurarSistema.
  ///
  /// In es, this message translates to:
  /// **'Configurar Sistema'**
  String get adminPermPermConfigurarSistema;

  /// No description provided for @adminPermPermEditarPerfiles.
  ///
  /// In es, this message translates to:
  /// **'Editar Perfiles'**
  String get adminPermPermEditarPerfiles;

  /// No description provided for @adminPermPermExportarDatos.
  ///
  /// In es, this message translates to:
  /// **'Exportar Datos'**
  String get adminPermPermExportarDatos;

  /// No description provided for @adminPermToastSyncTitle.
  ///
  /// In es, this message translates to:
  /// **'Matriz Sincronizada'**
  String get adminPermToastSyncTitle;

  /// No description provided for @adminPermToastSyncMessage.
  ///
  /// In es, this message translates to:
  /// **'Los permisos globales han sido actualizados.'**
  String get adminPermToastSyncMessage;

  /// No description provided for @adminPermToastErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get adminPermToastErrorTitle;

  /// No description provided for @adminPermToastErrorMessage.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar la configuración.'**
  String get adminPermToastErrorMessage;

  /// No description provided for @adminPermErrorPrefix.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String adminPermErrorPrefix(String error);

  /// No description provided for @adminRolesTitle.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Roles'**
  String get adminRolesTitle;

  /// No description provided for @adminRolesSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración de perfiles y jerarquías de sistema'**
  String get adminRolesSubtitle;

  /// No description provided for @adminRolesSaveButton.
  ///
  /// In es, this message translates to:
  /// **'GUARDAR CAMBIOS'**
  String get adminRolesSaveButton;

  /// No description provided for @adminRolesBadgeSystem.
  ///
  /// In es, this message translates to:
  /// **'SISTEMA'**
  String get adminRolesBadgeSystem;

  /// No description provided for @adminRolesNewProfileTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Perfil'**
  String get adminRolesNewProfileTitle;

  /// No description provided for @adminRolesNewProfileDesc.
  ///
  /// In es, this message translates to:
  /// **'Define un nuevo rol para la gestión de usuarios.'**
  String get adminRolesNewProfileDesc;

  /// No description provided for @adminRolesFieldLabel.
  ///
  /// In es, this message translates to:
  /// **'NOMBRE DEL ROL'**
  String get adminRolesFieldLabel;

  /// No description provided for @adminRolesAddButton.
  ///
  /// In es, this message translates to:
  /// **'AÑADIR ROL'**
  String get adminRolesAddButton;

  /// No description provided for @adminRolesInfoBox.
  ///
  /// In es, this message translates to:
  /// **'Asigna permisos en la Matriz después de crear el rol.'**
  String get adminRolesInfoBox;

  /// No description provided for @adminRolesToastSuccessTitle.
  ///
  /// In es, this message translates to:
  /// **'Éxito'**
  String get adminRolesToastSuccessTitle;

  /// No description provided for @adminRolesToastSuccessMessage.
  ///
  /// In es, this message translates to:
  /// **'Lista de roles actualizada correctamente.'**
  String get adminRolesToastSuccessMessage;

  /// No description provided for @adminRolesToastErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get adminRolesToastErrorTitle;

  /// No description provided for @adminRolesToastErrorMessage.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar la configuración.'**
  String get adminRolesToastErrorMessage;

  /// No description provided for @adminRolesErrorPrefix.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String adminRolesErrorPrefix(String error);

  /// No description provided for @adminAnioTitulo.
  ///
  /// In es, this message translates to:
  /// **'Años Académicos'**
  String get adminAnioTitulo;

  /// No description provided for @adminAnioSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Gestiona los periodos escolares del centro.'**
  String get adminAnioSubtitulo;

  /// No description provided for @adminAnioNuevo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Año'**
  String get adminAnioNuevo;

  /// No description provided for @adminAnioActivo.
  ///
  /// In es, this message translates to:
  /// **'ACTIVO'**
  String get adminAnioActivo;

  /// No description provided for @adminAnioCursos.
  ///
  /// In es, this message translates to:
  /// **'{n} cursos'**
  String adminAnioCursos(int n);

  /// No description provided for @adminAnioMiembros.
  ///
  /// In es, this message translates to:
  /// **'{n} miembros'**
  String adminAnioMiembros(int n);

  /// No description provided for @adminAnioDesactivar.
  ///
  /// In es, this message translates to:
  /// **'Desactivar'**
  String get adminAnioDesactivar;

  /// No description provided for @adminAnioActivar.
  ///
  /// In es, this message translates to:
  /// **'Activar'**
  String get adminAnioActivar;

  /// No description provided for @adminAnioEliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get adminAnioEliminar;

  /// No description provided for @adminAnioTooltipDesactivar.
  ///
  /// In es, this message translates to:
  /// **'Desactivar'**
  String get adminAnioTooltipDesactivar;

  /// No description provided for @adminAnioTooltipActivar.
  ///
  /// In es, this message translates to:
  /// **'Activar'**
  String get adminAnioTooltipActivar;

  /// No description provided for @adminAnioTooltipEditar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get adminAnioTooltipEditar;

  /// No description provided for @adminAnioTooltipEliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get adminAnioTooltipEliminar;

  /// No description provided for @adminAnioTooltipNoEliminarActivo.
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar el año activo'**
  String get adminAnioTooltipNoEliminarActivo;

  /// No description provided for @adminAnioTooltipNoEliminarAlumnos.
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar (tiene alumnos)'**
  String get adminAnioTooltipNoEliminarAlumnos;

  /// No description provided for @adminAnioErrorCargar.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar los datos: {e}'**
  String adminAnioErrorCargar(Object e);

  /// No description provided for @adminAnioReintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get adminAnioReintentar;

  /// No description provided for @adminAnioVacio.
  ///
  /// In es, this message translates to:
  /// **'No hay años académicos registrados.'**
  String get adminAnioVacio;

  /// No description provided for @adminAnioCrearPrimero.
  ///
  /// In es, this message translates to:
  /// **'Crear el primero'**
  String get adminAnioCrearPrimero;

  /// No description provided for @adminAnioDialogNuevo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Año Académico'**
  String get adminAnioDialogNuevo;

  /// No description provided for @adminAnioDialogEditar.
  ///
  /// In es, this message translates to:
  /// **'Editar Año Académico'**
  String get adminAnioDialogEditar;

  /// No description provided for @adminAnioNombrePeriodo.
  ///
  /// In es, this message translates to:
  /// **'Nombre del período'**
  String get adminAnioNombrePeriodo;

  /// No description provided for @adminAnioNombreHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. 2025-2026'**
  String get adminAnioNombreHint;

  /// No description provided for @adminAnioNombreObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Campo obligatorio'**
  String get adminAnioNombreObligatorio;

  /// No description provided for @adminAnioFechaInicio.
  ///
  /// In es, this message translates to:
  /// **'Fecha de inicio'**
  String get adminAnioFechaInicio;

  /// No description provided for @adminAnioFechaFin.
  ///
  /// In es, this message translates to:
  /// **'Fecha de fin'**
  String get adminAnioFechaFin;

  /// No description provided for @adminAnioSeleccionar.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar'**
  String get adminAnioSeleccionar;

  /// No description provided for @adminAnioDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get adminAnioDescripcion;

  /// No description provided for @adminAnioDescripcionHint.
  ///
  /// In es, this message translates to:
  /// **'Breve descripción del período'**
  String get adminAnioDescripcionHint;

  /// No description provided for @adminAnioCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get adminAnioCancelar;

  /// No description provided for @adminAnioGuardarCambios.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get adminAnioGuardarCambios;

  /// No description provided for @adminAnioCrearAnio.
  ///
  /// In es, this message translates to:
  /// **'Crear Año'**
  String get adminAnioCrearAnio;

  /// No description provided for @adminAnioDesactivarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Desactivar Año Académico'**
  String get adminAnioDesactivarTitulo;

  /// No description provided for @adminAnioDesactivarMensaje.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres desactivar \"{nombre}\"? Éste pasará a modo histórico.'**
  String adminAnioDesactivarMensaje(String nombre);

  /// No description provided for @adminAnioActivarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Activar Año Académico'**
  String get adminAnioActivarTitulo;

  /// No description provided for @adminAnioActivarMensaje.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres activar \"{nombre}\"? El año activo actualmente pasará a modo histórico.'**
  String adminAnioActivarMensaje(String nombre);

  /// No description provided for @adminAnioEliminarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Año Académico'**
  String get adminAnioEliminarTitulo;

  /// No description provided for @adminAnioEliminarMensaje.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar \"{nombre}\" permanentemente? Esta acción no se puede deshacer.'**
  String adminAnioEliminarMensaje(String nombre);

  /// No description provided for @adminAnioSnackDesactivado.
  ///
  /// In es, this message translates to:
  /// **'Año desactivado'**
  String get adminAnioSnackDesactivado;

  /// No description provided for @adminAnioSnackActivado.
  ///
  /// In es, this message translates to:
  /// **'Año activado'**
  String get adminAnioSnackActivado;

  /// No description provided for @adminAnioSnackEliminado.
  ///
  /// In es, this message translates to:
  /// **'Año eliminado'**
  String get adminAnioSnackEliminado;

  /// No description provided for @adminAnioSnackGuardado.
  ///
  /// In es, this message translates to:
  /// **'Año guardado correctamente'**
  String get adminAnioSnackGuardado;

  /// No description provided for @adminAnioSnackErrorGuardar.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar'**
  String get adminAnioSnackErrorGuardar;

  /// No description provided for @adminAnioSnackNoEliminarActivo.
  ///
  /// In es, this message translates to:
  /// **'No puedes eliminar el año activo.'**
  String get adminAnioSnackNoEliminarActivo;

  /// No description provided for @adminAnioDuplicado.
  ///
  /// In es, this message translates to:
  /// **'Ya existe un año académico con el nombre \"{nombre}\".'**
  String adminAnioDuplicado(String nombre);

  /// No description provided for @adminAnioSeleccionarFechas.
  ///
  /// In es, this message translates to:
  /// **'Selecciona las fechas de inicio y fin.'**
  String get adminAnioSeleccionarFechas;

  /// No description provided for @adminAnioErrorConexion.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión'**
  String get adminAnioErrorConexion;

  /// No description provided for @adminHorarioTitulo.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get adminHorarioTitulo;

  /// No description provided for @adminHorarioTituloDesktop.
  ///
  /// In es, this message translates to:
  /// **'Calendario de Eventos'**
  String get adminHorarioTituloDesktop;

  /// No description provided for @adminHorarioSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Planificación académica y recordatorios del centro'**
  String get adminHorarioSubtitulo;

  /// No description provided for @adminHorarioNuevoEvento.
  ///
  /// In es, this message translates to:
  /// **'NUEVO EVENTO'**
  String get adminHorarioNuevoEvento;

  /// No description provided for @adminHorarioEventosDia.
  ///
  /// In es, this message translates to:
  /// **'Eventos del Día'**
  String get adminHorarioEventosDia;

  /// No description provided for @adminHorarioSinEventos.
  ///
  /// In es, this message translates to:
  /// **'No hay eventos para hoy'**
  String get adminHorarioSinEventos;

  /// No description provided for @adminHorarioProgramarEvento.
  ///
  /// In es, this message translates to:
  /// **'Programar Festivo'**
  String get adminHorarioProgramarEvento;

  /// No description provided for @adminHorarioTituloEvento.
  ///
  /// In es, this message translates to:
  /// **'Título del día festivo'**
  String get adminHorarioTituloEvento;

  /// No description provided for @adminHorarioTipo.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get adminHorarioTipo;

  /// No description provided for @adminHorarioCancelar.
  ///
  /// In es, this message translates to:
  /// **'CANCELAR'**
  String get adminHorarioCancelar;

  /// No description provided for @adminHorarioGuardar.
  ///
  /// In es, this message translates to:
  /// **'GUARDAR'**
  String get adminHorarioGuardar;

  /// No description provided for @adminHorarioEliminadoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminado'**
  String get adminHorarioEliminadoTitulo;

  /// No description provided for @adminHorarioEliminadoMensaje.
  ///
  /// In es, this message translates to:
  /// **'El evento ha sido borrado.'**
  String get adminHorarioEliminadoMensaje;

  /// No description provided for @adminHorarioErrorTitulo.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get adminHorarioErrorTitulo;

  /// No description provided for @adminReglamentoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Reglamento'**
  String get adminReglamentoTitulo;

  /// No description provided for @adminReglamentoSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Gestión de versiones y vigencia legal'**
  String get adminReglamentoSubtitulo;

  /// No description provided for @adminReglamentoHistorialTitulo.
  ///
  /// In es, this message translates to:
  /// **'Historial Normativo'**
  String get adminReglamentoHistorialTitulo;

  /// No description provided for @adminReglamentoHistorialSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Gestión de versiones y vigencia legal'**
  String get adminReglamentoHistorialSubtitulo;

  /// No description provided for @adminReglamentoHistorialBtn.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get adminReglamentoHistorialBtn;

  /// No description provided for @adminReglamentoNuevaVersion.
  ///
  /// In es, this message translates to:
  /// **'NUEVA VERSIÓN'**
  String get adminReglamentoNuevaVersion;

  /// No description provided for @adminReglamentoPublicar.
  ///
  /// In es, this message translates to:
  /// **'PUBLICAR CAMBIOS'**
  String get adminReglamentoPublicar;

  /// No description provided for @adminReglamentoVersionHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la Versión...'**
  String get adminReglamentoVersionHint;

  /// No description provided for @adminReglamentoVersionActivaLabel.
  ///
  /// In es, this message translates to:
  /// **'VERSIÓN ACTIVA'**
  String get adminReglamentoVersionActivaLabel;

  /// No description provided for @adminReglamentoActivoBadge.
  ///
  /// In es, this message translates to:
  /// **'ACTIVO'**
  String get adminReglamentoActivoBadge;

  /// No description provided for @adminReglamentoEditorPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Comienza a redactar la normativa del centro...'**
  String get adminReglamentoEditorPlaceholder;

  /// No description provided for @adminReglamentoNuevaBorrador.
  ///
  /// In es, this message translates to:
  /// **'Nueva versión en borrador'**
  String get adminReglamentoNuevaBorrador;

  /// No description provided for @adminReglamentoModificandoVersion.
  ///
  /// In es, this message translates to:
  /// **'Modificando versión del {fecha}'**
  String adminReglamentoModificandoVersion(String fecha);

  /// No description provided for @adminReglamentoErrorTitulo.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get adminReglamentoErrorTitulo;

  /// No description provided for @adminReglamentoExitoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Éxito'**
  String get adminReglamentoExitoTitulo;

  /// No description provided for @adminReglamentoVersionRequerida.
  ///
  /// In es, this message translates to:
  /// **'Nombre de versión requerido'**
  String get adminReglamentoVersionRequerida;

  /// No description provided for @adminReglamentoGuardadoOk.
  ///
  /// In es, this message translates to:
  /// **'Reglamento guardado y sincronizado'**
  String get adminReglamentoGuardadoOk;

  /// No description provided for @adminReglamentoFalloGuardar.
  ///
  /// In es, this message translates to:
  /// **'Fallo al guardar: {error}'**
  String adminReglamentoFalloGuardar(String error);

  /// No description provided for @adminReglamentoErrorCargar.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar historial'**
  String get adminReglamentoErrorCargar;

  /// No description provided for @adminHistorialTitulo.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get adminHistorialTitulo;

  /// No description provided for @adminHistorialSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Auditoría global de registros'**
  String get adminHistorialSubtitulo;

  /// No description provided for @adminHistorialTituloDesktop.
  ///
  /// In es, this message translates to:
  /// **'Historial de Asistencia'**
  String get adminHistorialTituloDesktop;

  /// No description provided for @adminHistorialSubtituloDesktop.
  ///
  /// In es, this message translates to:
  /// **'Auditoría global de registros de clase y ausentismo'**
  String get adminHistorialSubtituloDesktop;

  /// No description provided for @adminHistorialBuscarHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar materia o profesor...'**
  String get adminHistorialBuscarHint;

  /// No description provided for @adminHistorialCualquierFecha.
  ///
  /// In es, this message translates to:
  /// **'Cualquier fecha'**
  String get adminHistorialCualquierFecha;

  /// No description provided for @adminHistorialCursoLabel.
  ///
  /// In es, this message translates to:
  /// **'CURSO'**
  String get adminHistorialCursoLabel;

  /// No description provided for @adminHistorialGrupoHint.
  ///
  /// In es, this message translates to:
  /// **'Grupo'**
  String get adminHistorialGrupoHint;

  /// No description provided for @adminHistorialTodos.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get adminHistorialTodos;

  /// No description provided for @adminHistorialTodosGrupos.
  ///
  /// In es, this message translates to:
  /// **'Todos los grupos'**
  String get adminHistorialTodosGrupos;

  /// No description provided for @adminHistorialSinRegistros.
  ///
  /// In es, this message translates to:
  /// **'SIN REGISTROS QUE MOSTRAR'**
  String get adminHistorialSinRegistros;

  /// No description provided for @adminHistorialSinDocente.
  ///
  /// In es, this message translates to:
  /// **'Sin docente'**
  String get adminHistorialSinDocente;

  /// No description provided for @adminHistorialAlumnos.
  ///
  /// In es, this message translates to:
  /// **'{attended}/{total} ALUMNOS'**
  String adminHistorialAlumnos(int attended, int total);

  /// No description provided for @adminProgramConfigTitulo.
  ///
  /// In es, this message translates to:
  /// **'Configuración del Programa'**
  String get adminProgramConfigTitulo;

  /// No description provided for @adminProgramConfigSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Gestión de políticas institucionales, roles de usuario y parámetros globales del centro'**
  String get adminProgramConfigSubtitulo;

  /// No description provided for @adminProgramConfigRolesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Roles y Matriz de Permisos'**
  String get adminProgramConfigRolesTitulo;

  /// No description provided for @adminProgramConfigRolesDesc.
  ///
  /// In es, this message translates to:
  /// **'Control granular sobre las capacidades de cada perfil'**
  String get adminProgramConfigRolesDesc;

  /// No description provided for @adminProgramConfigMatrizPermisos.
  ///
  /// In es, this message translates to:
  /// **'Matriz de Permisos'**
  String get adminProgramConfigMatrizPermisos;

  /// No description provided for @adminProgramConfigMatrizPermisosDesc.
  ///
  /// In es, this message translates to:
  /// **'Mapa de privilegios por cada rol del sistema'**
  String get adminProgramConfigMatrizPermisosDesc;

  /// No description provided for @adminProgramConfigGestionRoles.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Roles'**
  String get adminProgramConfigGestionRoles;

  /// No description provided for @adminProgramConfigGestionRolesDesc.
  ///
  /// In es, this message translates to:
  /// **'Añadir, editar o eliminar etiquetas de usuario'**
  String get adminProgramConfigGestionRolesDesc;

  /// No description provided for @adminProgramConfigCalendarioTitulo.
  ///
  /// In es, this message translates to:
  /// **'Calendario Institucional'**
  String get adminProgramConfigCalendarioTitulo;

  /// No description provided for @adminProgramConfigCalendarioDesc.
  ///
  /// In es, this message translates to:
  /// **'Configuración de festivos y eventos regionales'**
  String get adminProgramConfigCalendarioDesc;

  /// No description provided for @adminProgramConfigFestivos.
  ///
  /// In es, this message translates to:
  /// **'Calendario de Festivos'**
  String get adminProgramConfigFestivos;

  /// No description provided for @adminProgramConfigFestivosDesc.
  ///
  /// In es, this message translates to:
  /// **'Gestionar días no lectivos y puentes'**
  String get adminProgramConfigFestivosDesc;

  /// No description provided for @adminProgramConfigEventosCentro.
  ///
  /// In es, this message translates to:
  /// **'Eventos del Centro'**
  String get adminProgramConfigEventosCentro;

  /// No description provided for @adminProgramConfigEventosCentroDesc.
  ///
  /// In es, this message translates to:
  /// **'Graduaciones, claustros y festividades propias'**
  String get adminProgramConfigEventosCentroDesc;

  /// No description provided for @adminProgramConfigReglamentoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Reglamento de Convivencia'**
  String get adminProgramConfigReglamentoTitulo;

  /// No description provided for @adminProgramConfigReglamentoDesc.
  ///
  /// In es, this message translates to:
  /// **'Normas y pautas de comportamiento del centro'**
  String get adminProgramConfigReglamentoDesc;

  /// No description provided for @adminProgramConfigVerEditarReglamento.
  ///
  /// In es, this message translates to:
  /// **'Ver / Editar Reglamento'**
  String get adminProgramConfigVerEditarReglamento;

  /// No description provided for @adminProgramConfigVerEditarReglamentoDesc.
  ///
  /// In es, this message translates to:
  /// **'Gestión detallada de normas, derechos y deberes'**
  String get adminProgramConfigVerEditarReglamentoDesc;

  /// No description provided for @adminProgramConfigMantenimientoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento del Sistema'**
  String get adminProgramConfigMantenimientoTitulo;

  /// No description provided for @adminProgramConfigMantenimientoDesc.
  ///
  /// In es, this message translates to:
  /// **'Parámetros técnicos y logs de actividad'**
  String get adminProgramConfigMantenimientoDesc;

  /// No description provided for @adminProgramConfigAuditoria.
  ///
  /// In es, this message translates to:
  /// **'Auditoría de Cambios'**
  String get adminProgramConfigAuditoria;

  /// No description provided for @adminProgramConfigAuditoriaDesc.
  ///
  /// In es, this message translates to:
  /// **'Ver historial de modificaciones administrativas'**
  String get adminProgramConfigAuditoriaDesc;

  /// No description provided for @adminProgramConfigLimpieza.
  ///
  /// In es, this message translates to:
  /// **'Limpieza de Temporales'**
  String get adminProgramConfigLimpieza;

  /// No description provided for @adminProgramConfigLimpiezaDesc.
  ///
  /// In es, this message translates to:
  /// **'Purgar archivos de subida no referenciados'**
  String get adminProgramConfigLimpiezaDesc;

  /// No description provided for @adminProgramConfigUsuarios.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Usuarios'**
  String get adminProgramConfigUsuarios;

  /// No description provided for @adminProgramConfigUsuariosDesc.
  ///
  /// In es, this message translates to:
  /// **'Control de IPs, sesiones y actividad de cuentas'**
  String get adminProgramConfigUsuariosDesc;

  /// No description provided for @adminProgramConfigEnDesarrolloTitulo.
  ///
  /// In es, this message translates to:
  /// **'Funcionalidad en Desarrollo'**
  String get adminProgramConfigEnDesarrolloTitulo;

  /// No description provided for @adminProgramConfigEnDesarrolloDesc.
  ///
  /// In es, this message translates to:
  /// **'Esta característica estará disponible en la próxima actualización del sistema GAULA.'**
  String get adminProgramConfigEnDesarrolloDesc;

  /// No description provided for @adminProgramConfigEntendido.
  ///
  /// In es, this message translates to:
  /// **'ENTENDIDO'**
  String get adminProgramConfigEntendido;

  /// No description provided for @adminProgramConfigEnDesarrolloBadge.
  ///
  /// In es, this message translates to:
  /// **'EN DESARROLLO'**
  String get adminProgramConfigEnDesarrolloBadge;

  /// No description provided for @addAlumnoEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Alumno'**
  String get addAlumnoEditTitle;

  /// No description provided for @addAlumnoAddTitle.
  ///
  /// In es, this message translates to:
  /// **'Añadir Nuevo Alumno'**
  String get addAlumnoAddTitle;

  /// No description provided for @addAlumnoEditSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Modifica los datos del alumno'**
  String get addAlumnoEditSubtitle;

  /// No description provided for @addAlumnoAddSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Completa la información para la matrícula'**
  String get addAlumnoAddSubtitle;

  /// No description provided for @addAlumnoSectionPersonal.
  ///
  /// In es, this message translates to:
  /// **'INFORMACIÓN PERSONAL'**
  String get addAlumnoSectionPersonal;

  /// No description provided for @addAlumnoFieldNombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre *'**
  String get addAlumnoFieldNombre;

  /// No description provided for @addAlumnoHintNombre.
  ///
  /// In es, this message translates to:
  /// **'Ej: Juan'**
  String get addAlumnoHintNombre;

  /// No description provided for @addAlumnoFieldApellidos.
  ///
  /// In es, this message translates to:
  /// **'Apellidos *'**
  String get addAlumnoFieldApellidos;

  /// No description provided for @addAlumnoHintApellidos.
  ///
  /// In es, this message translates to:
  /// **'Ej: García López'**
  String get addAlumnoHintApellidos;

  /// No description provided for @addAlumnoFieldDni.
  ///
  /// In es, this message translates to:
  /// **'DNI/NIE'**
  String get addAlumnoFieldDni;

  /// No description provided for @addAlumnoSectionContacto.
  ///
  /// In es, this message translates to:
  /// **'CONTACTO Y MATRÍCULA'**
  String get addAlumnoSectionContacto;

  /// No description provided for @addAlumnoFieldEmail.
  ///
  /// In es, this message translates to:
  /// **'Email *'**
  String get addAlumnoFieldEmail;

  /// No description provided for @addAlumnoHintEmail.
  ///
  /// In es, this message translates to:
  /// **'alumno@gaula.edu'**
  String get addAlumnoHintEmail;

  /// No description provided for @addAlumnoFieldUsuario.
  ///
  /// In es, this message translates to:
  /// **'Usuario (Opcional)'**
  String get addAlumnoFieldUsuario;

  /// No description provided for @addAlumnoHintUsuario.
  ///
  /// In es, this message translates to:
  /// **'juan.garcia'**
  String get addAlumnoHintUsuario;

  /// No description provided for @addAlumnoFieldPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña *'**
  String get addAlumnoFieldPassword;

  /// No description provided for @addAlumnoHintPassword.
  ///
  /// In es, this message translates to:
  /// **'Mín. 6 carac.'**
  String get addAlumnoHintPassword;

  /// No description provided for @addAlumnoFieldTelefono.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get addAlumnoFieldTelefono;

  /// No description provided for @addAlumnoHintTelefono.
  ///
  /// In es, this message translates to:
  /// **'+34 600...'**
  String get addAlumnoHintTelefono;

  /// No description provided for @addAlumnoFieldDireccion.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get addAlumnoFieldDireccion;

  /// No description provided for @addAlumnoHintDireccion.
  ///
  /// In es, this message translates to:
  /// **'Calle Principal, 123, Madrid'**
  String get addAlumnoHintDireccion;

  /// No description provided for @addAlumnoSectionMaterias.
  ///
  /// In es, this message translates to:
  /// **'MATERIAS (MATRÍCULA)'**
  String get addAlumnoSectionMaterias;

  /// No description provided for @addAlumnoButtonGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get addAlumnoButtonGuardar;

  /// No description provided for @addAlumnoButtonRegistrar.
  ///
  /// In es, this message translates to:
  /// **'Registrar Alumno'**
  String get addAlumnoButtonRegistrar;

  /// No description provided for @addAlumnoButtonCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get addAlumnoButtonCancelar;

  /// No description provided for @addAlumnoFieldFechaNacimiento.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Nacimiento'**
  String get addAlumnoFieldFechaNacimiento;

  /// No description provided for @addAlumnoSeleccionarFecha.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar...'**
  String get addAlumnoSeleccionarFecha;

  /// No description provided for @addAlumnoSuccessRegistrado.
  ///
  /// In es, this message translates to:
  /// **'Alumno registrado correctamente'**
  String get addAlumnoSuccessRegistrado;

  /// No description provided for @addAlumnoErrorRegistrar.
  ///
  /// In es, this message translates to:
  /// **'Error al registrar alumno'**
  String get addAlumnoErrorRegistrar;

  /// No description provided for @addAlumnoCampoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Campo obligatorio'**
  String get addAlumnoCampoObligatorio;

  /// No description provided for @addIncidenciaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Nueva Incidencia'**
  String get addIncidenciaTitulo;

  /// No description provided for @addIncidenciaFieldTitulo.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get addIncidenciaFieldTitulo;

  /// No description provided for @addIncidenciaHintTitulo.
  ///
  /// In es, this message translates to:
  /// **'Ej: Comportamiento disruptivo'**
  String get addIncidenciaHintTitulo;

  /// No description provided for @addIncidenciaFieldAlumno.
  ///
  /// In es, this message translates to:
  /// **'Alumno'**
  String get addIncidenciaFieldAlumno;

  /// No description provided for @addIncidenciaSelectAlumno.
  ///
  /// In es, this message translates to:
  /// **'Seleccione alumno'**
  String get addIncidenciaSelectAlumno;

  /// No description provided for @addIncidenciaErrorAlumnos.
  ///
  /// In es, this message translates to:
  /// **'Error cargando alumnos'**
  String get addIncidenciaErrorAlumnos;

  /// No description provided for @addIncidenciaFieldProfesor.
  ///
  /// In es, this message translates to:
  /// **'Profesor que reporta'**
  String get addIncidenciaFieldProfesor;

  /// No description provided for @addIncidenciaSelectProfesor.
  ///
  /// In es, this message translates to:
  /// **'Seleccione profesor'**
  String get addIncidenciaSelectProfesor;

  /// No description provided for @addIncidenciaErrorProfesores.
  ///
  /// In es, this message translates to:
  /// **'Error cargando profesores'**
  String get addIncidenciaErrorProfesores;

  /// No description provided for @addIncidenciaFieldGravedad.
  ///
  /// In es, this message translates to:
  /// **'Gravedad'**
  String get addIncidenciaFieldGravedad;

  /// No description provided for @addIncidenciaHintGravedad.
  ///
  /// In es, this message translates to:
  /// **'Nivel de gravedad'**
  String get addIncidenciaHintGravedad;

  /// No description provided for @addIncidenciaFieldDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Descripción detallada'**
  String get addIncidenciaFieldDescripcion;

  /// No description provided for @addIncidenciaHintDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Detalles de lo sucedido...'**
  String get addIncidenciaHintDescripcion;

  /// No description provided for @addIncidenciaButtonCrear.
  ///
  /// In es, this message translates to:
  /// **'Crear Incidencia'**
  String get addIncidenciaButtonCrear;

  /// No description provided for @addIncidenciaButtonCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get addIncidenciaButtonCancelar;

  /// No description provided for @addIncidenciaValidacionSeleccion.
  ///
  /// In es, this message translates to:
  /// **'Por favor seleccione alumno y profesor'**
  String get addIncidenciaValidacionSeleccion;

  /// No description provided for @addIncidenciaSuccessCreada.
  ///
  /// In es, this message translates to:
  /// **'Incidencia creada correctamente'**
  String get addIncidenciaSuccessCreada;

  /// No description provided for @addIncidenciaErrorCrear.
  ///
  /// In es, this message translates to:
  /// **'Error al crear incidencia'**
  String get addIncidenciaErrorCrear;

  /// No description provided for @addIncidenciaCampoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Campo obligatorio'**
  String get addIncidenciaCampoObligatorio;

  /// No description provided for @addIncidenciaBuscar.
  ///
  /// In es, this message translates to:
  /// **'Buscar...'**
  String get addIncidenciaBuscar;

  /// No description provided for @addIncidenciaNoResultados.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron resultados'**
  String get addIncidenciaNoResultados;

  /// No description provided for @addProfesorEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Profesor'**
  String get addProfesorEditTitle;

  /// No description provided for @addProfesorAddTitle.
  ///
  /// In es, this message translates to:
  /// **'Añadir Profesor'**
  String get addProfesorAddTitle;

  /// No description provided for @addProfesorEditSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Modifica los accesos'**
  String get addProfesorEditSubtitle;

  /// No description provided for @addProfesorAddSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Crea un nuevo usuario administrativo o docente'**
  String get addProfesorAddSubtitle;

  /// No description provided for @addProfesorFieldNombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre *'**
  String get addProfesorFieldNombre;

  /// No description provided for @addProfesorHintNombre.
  ///
  /// In es, this message translates to:
  /// **'Ej: Roberto'**
  String get addProfesorHintNombre;

  /// No description provided for @addProfesorFieldApellidos.
  ///
  /// In es, this message translates to:
  /// **'Apellidos *'**
  String get addProfesorFieldApellidos;

  /// No description provided for @addProfesorHintApellidos.
  ///
  /// In es, this message translates to:
  /// **'Ej: Sánchez Domínguez'**
  String get addProfesorHintApellidos;

  /// No description provided for @addProfesorFieldEmail.
  ///
  /// In es, this message translates to:
  /// **'Email *'**
  String get addProfesorFieldEmail;

  /// No description provided for @addProfesorHintEmail.
  ///
  /// In es, this message translates to:
  /// **'ejemplo@gaula.edu'**
  String get addProfesorHintEmail;

  /// No description provided for @addProfesorFieldEspecialidades.
  ///
  /// In es, this message translates to:
  /// **'Especialidades'**
  String get addProfesorFieldEspecialidades;

  /// No description provided for @addProfesorHintEspecialidades.
  ///
  /// In es, this message translates to:
  /// **'Ej: Informática, Programación'**
  String get addProfesorHintEspecialidades;

  /// No description provided for @addProfesorFieldRol.
  ///
  /// In es, this message translates to:
  /// **'Rol de Usuario *'**
  String get addProfesorFieldRol;

  /// No description provided for @addProfesorRolDocente.
  ///
  /// In es, this message translates to:
  /// **'Profesor / Docente'**
  String get addProfesorRolDocente;

  /// No description provided for @addProfesorRolAdmin.
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get addProfesorRolAdmin;

  /// No description provided for @addProfesorButtonGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get addProfesorButtonGuardar;

  /// No description provided for @addProfesorButtonRegistrar.
  ///
  /// In es, this message translates to:
  /// **'Registrar Profesor'**
  String get addProfesorButtonRegistrar;

  /// No description provided for @addProfesorButtonCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get addProfesorButtonCancelar;

  /// No description provided for @addProfesorSuccessActualizado.
  ///
  /// In es, this message translates to:
  /// **'Datos actualizados'**
  String get addProfesorSuccessActualizado;

  /// No description provided for @addProfesorSuccessRegistrado.
  ///
  /// In es, this message translates to:
  /// **'Profesor registrado'**
  String get addProfesorSuccessRegistrado;

  /// No description provided for @addProfesorCampoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'Campo obligatorio'**
  String get addProfesorCampoObligatorio;

  /// No description provided for @addProfesorEmailInvalido.
  ///
  /// In es, this message translates to:
  /// **'Formato de email inválido'**
  String get addProfesorEmailInvalido;

  /// No description provided for @adminCursoHorarioTitulo.
  ///
  /// In es, this message translates to:
  /// **'Horario Semanal: {codigoGrupo}'**
  String adminCursoHorarioTitulo(String codigoGrupo);

  /// No description provided for @adminCursoHorarioGeneradoTitle.
  ///
  /// In es, this message translates to:
  /// **'Generado'**
  String get adminCursoHorarioGeneradoTitle;

  /// No description provided for @adminCursoHorarioGeneradoMsg.
  ///
  /// In es, this message translates to:
  /// **'Horario generado automáticamente'**
  String get adminCursoHorarioGeneradoMsg;

  /// No description provided for @adminCursoHorarioErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get adminCursoHorarioErrorTitle;

  /// No description provided for @adminCursoHorarioButtonGenerar.
  ///
  /// In es, this message translates to:
  /// **'Generar Automáticamente'**
  String get adminCursoHorarioButtonGenerar;

  /// No description provided for @adminCursoHorarioButtonAsignar.
  ///
  /// In es, this message translates to:
  /// **'Asignar Módulo'**
  String get adminCursoHorarioButtonAsignar;

  /// No description provided for @adminCursoHorarioRecreo.
  ///
  /// In es, this message translates to:
  /// **'RECREO'**
  String get adminCursoHorarioRecreo;

  /// No description provided for @adminCursoHorarioErrorCargar.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar horario: {error}'**
  String adminCursoHorarioErrorCargar(String error);

  /// No description provided for @adminCursoHorarioDesconocido.
  ///
  /// In es, this message translates to:
  /// **'Desconocido'**
  String get adminCursoHorarioDesconocido;

  /// No description provided for @adminCursoHorarioEliminadoTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminado'**
  String get adminCursoHorarioEliminadoTitle;

  /// No description provided for @adminCursoHorarioEliminadoMsg.
  ///
  /// In es, this message translates to:
  /// **'Sesión eliminada correctamente'**
  String get adminCursoHorarioEliminadoMsg;

  /// No description provided for @adminCursoHorarioErrorAsignar.
  ///
  /// In es, this message translates to:
  /// **'Error al asignar'**
  String get adminCursoHorarioErrorAsignar;

  /// No description provided for @adminCursoHorarioAsignadoTitle.
  ///
  /// In es, this message translates to:
  /// **'Asignado'**
  String get adminCursoHorarioAsignadoTitle;

  /// No description provided for @adminCursoHorarioAsignadoMsg.
  ///
  /// In es, this message translates to:
  /// **'Sesión asignada correctamente'**
  String get adminCursoHorarioAsignadoMsg;

  /// No description provided for @adminCursoHorarioElegirColor.
  ///
  /// In es, this message translates to:
  /// **'Elegir Color: {nombre}'**
  String adminCursoHorarioElegirColor(String nombre);

  /// No description provided for @adminCursoHorarioNoProfesores.
  ///
  /// In es, this message translates to:
  /// **'No hay profesores disponibles'**
  String get adminCursoHorarioNoProfesores;

  /// No description provided for @adminCursoHorarioDia.
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get adminCursoHorarioDia;

  /// No description provided for @adminCursoHorarioHoraInicio.
  ///
  /// In es, this message translates to:
  /// **'Hora Inicio'**
  String get adminCursoHorarioHoraInicio;

  /// No description provided for @adminCursoHorarioModuloMateria.
  ///
  /// In es, this message translates to:
  /// **'Módulo / Materia'**
  String get adminCursoHorarioModuloMateria;

  /// No description provided for @adminCursoHorarioSeleccionarModulo.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar módulo'**
  String get adminCursoHorarioSeleccionarModulo;

  /// No description provided for @adminCursoHorarioNoMaterias.
  ///
  /// In es, this message translates to:
  /// **'No hay materias en el curso'**
  String get adminCursoHorarioNoMaterias;

  /// No description provided for @adminCursoHorarioProfesorAsignado.
  ///
  /// In es, this message translates to:
  /// **'Profesor Asignado'**
  String get adminCursoHorarioProfesorAsignado;

  /// No description provided for @adminCursoHorarioBuscarProfesor.
  ///
  /// In es, this message translates to:
  /// **'Buscar profesor...'**
  String get adminCursoHorarioBuscarProfesor;

  /// No description provided for @adminCursoHorarioSoloLibres.
  ///
  /// In es, this message translates to:
  /// **'Solo libres a las {hora}'**
  String adminCursoHorarioSoloLibres(String hora);

  /// No description provided for @adminCursoHorarioErrorProfesores.
  ///
  /// In es, this message translates to:
  /// **'Error cargando profesores'**
  String get adminCursoHorarioErrorProfesores;

  /// No description provided for @adminCursoHorarioLibre.
  ///
  /// In es, this message translates to:
  /// **'Libre'**
  String get adminCursoHorarioLibre;

  /// No description provided for @adminCursoHorarioOcupado.
  ///
  /// In es, this message translates to:
  /// **'Ocupado'**
  String get adminCursoHorarioOcupado;

  /// No description provided for @adminCursoHorarioCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get adminCursoHorarioCancelar;

  /// No description provided for @adminCursoHorarioAsignarButton.
  ///
  /// In es, this message translates to:
  /// **'Asignar'**
  String get adminCursoHorarioAsignarButton;

  /// No description provided for @adminPlanEstudiosConfirmarEliminarMateria.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar la materia \"{nombre}\"? Esta acción no se puede deshacer.'**
  String adminPlanEstudiosConfirmarEliminarMateria(String nombre);

  /// No description provided for @adminPlanEstudiosErrorEliminarMateria.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar materia.'**
  String get adminPlanEstudiosErrorEliminarMateria;

  /// No description provided for @adminPlanEstudiosConfirmarEliminarPlantilla.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar esta plantilla? Esta acción no se puede deshacer.'**
  String get adminPlanEstudiosConfirmarEliminarPlantilla;

  /// No description provided for @adminPlanEstudiosMateriaCount.
  ///
  /// In es, this message translates to:
  /// **'{count} materias'**
  String adminPlanEstudiosMateriaCount(int count);

  /// No description provided for @adminPlanEstudiosModulosYProyectos.
  ///
  /// In es, this message translates to:
  /// **'Módulos y Proyectos'**
  String get adminPlanEstudiosModulosYProyectos;

  /// No description provided for @adminPlanEstudiosTipoCodigoLabel.
  ///
  /// In es, this message translates to:
  /// **'{tipo} — Código: {codigo}'**
  String adminPlanEstudiosTipoCodigoLabel(String tipo, String codigo);

  /// No description provided for @adminPlanEstudiosEditarPlan.
  ///
  /// In es, this message translates to:
  /// **'Editar Plan de Estudios'**
  String get adminPlanEstudiosEditarPlan;

  /// No description provided for @adminPlanEstudiosCrearPlan.
  ///
  /// In es, this message translates to:
  /// **'Crear Plan de Estudios'**
  String get adminPlanEstudiosCrearPlan;

  /// No description provided for @adminPlanEstudiosNombreCurso.
  ///
  /// In es, this message translates to:
  /// **'Nombre del Curso'**
  String get adminPlanEstudiosNombreCurso;

  /// No description provided for @adminPlanEstudiosNombreCursoHint.
  ///
  /// In es, this message translates to:
  /// **'ej. Desarrollo de Aplicaciones Multiplataforma'**
  String get adminPlanEstudiosNombreCursoHint;

  /// No description provided for @adminPlanEstudiosCodigo.
  ///
  /// In es, this message translates to:
  /// **'Código'**
  String get adminPlanEstudiosCodigo;

  /// No description provided for @adminPlanEstudiosaCodigoHint.
  ///
  /// In es, this message translates to:
  /// **'ej. DAM'**
  String get adminPlanEstudiosaCodigoHint;

  /// No description provided for @adminPlanEstudiosDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get adminPlanEstudiosDescripcion;

  /// No description provided for @adminPlanEstudiosDescripcionHint.
  ///
  /// In es, this message translates to:
  /// **'Breve descripción del curso'**
  String get adminPlanEstudiosDescripcionHint;

  /// No description provided for @adminPlanEstudiosColorPlantilla.
  ///
  /// In es, this message translates to:
  /// **'Color de la Plantilla'**
  String get adminPlanEstudiosColorPlantilla;

  /// No description provided for @adminPlanEstudiosSeleccionarColor.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un color'**
  String get adminPlanEstudiosSeleccionarColor;

  /// No description provided for @adminPlanEstudiosAniadirMateria.
  ///
  /// In es, this message translates to:
  /// **'Añadir materia'**
  String get adminPlanEstudiosAniadirMateria;

  /// No description provided for @adminPlanEstudiosEditarMateria.
  ///
  /// In es, this message translates to:
  /// **'Editar materia'**
  String get adminPlanEstudiosEditarMateria;

  /// No description provided for @adminPlanEstudiosNombreMateria.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get adminPlanEstudiosNombreMateria;

  /// No description provided for @adminPlanEstudiosNombreMateriaHint.
  ///
  /// In es, this message translates to:
  /// **'ej. Programación'**
  String get adminPlanEstudiosNombreMateriaHint;

  /// No description provided for @adminPlanEstudiosTipoMateria.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Materia'**
  String get adminPlanEstudiosTipoMateria;

  /// No description provided for @adminPlanEstudiosHoras.
  ///
  /// In es, this message translates to:
  /// **'Horas'**
  String get adminPlanEstudiosHoras;

  /// No description provided for @adminPlanEstudiosMateriasAniadidas.
  ///
  /// In es, this message translates to:
  /// **'Materias añadidas:'**
  String get adminPlanEstudiosMateriasAniadidas;

  /// No description provided for @adminAlumnosConfirmarDesactivar.
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de que desea desactivar el expediente de {nombre}?'**
  String adminAlumnosConfirmarDesactivar(String nombre);

  /// No description provided for @adminAlumnosConfirmarActivar.
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de que desea activar el expediente de {nombre}?'**
  String adminAlumnosConfirmarActivar(String nombre);

  /// No description provided for @adminPlanEstudiosTipoProyecto.
  ///
  /// In es, this message translates to:
  /// **'Proyecto'**
  String get adminPlanEstudiosTipoProyecto;

  /// No description provided for @adminPlanEstudiosTipoAsignatura.
  ///
  /// In es, this message translates to:
  /// **'Asignatura'**
  String get adminPlanEstudiosTipoAsignatura;

  /// No description provided for @adminPlanEstudiosTipoModulo.
  ///
  /// In es, this message translates to:
  /// **'Módulo'**
  String get adminPlanEstudiosTipoModulo;

  /// No description provided for @adminProfesoresRolLabel.
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get adminProfesoresRolLabel;

  /// No description provided for @adminProfesoresDesconocido.
  ///
  /// In es, this message translates to:
  /// **'Desconocido'**
  String get adminProfesoresDesconocido;

  /// No description provided for @adminProfesoresCursoLabel.
  ///
  /// In es, this message translates to:
  /// **'Curso: {cursoId}'**
  String adminProfesoresCursoLabel(String cursoId);

  /// Overlay carga backup
  ///
  /// In es, this message translates to:
  /// **'PROCESANDO EXPORTACIÓN...'**
  String get procesandoExportacion;

  /// Overlay carga backup subtexto
  ///
  /// In es, this message translates to:
  /// **'ESTO PUEDE TARDAR UNOS SEGUNDOS'**
  String get estaImaTardar;

  /// No description provided for @adminCursosNoEliminarConAlumnos.
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar un curso con alumnos matriculados.'**
  String get adminCursosNoEliminarConAlumnos;

  /// No description provided for @adminCursoEliminadoOk.
  ///
  /// In es, this message translates to:
  /// **'Curso eliminado correctamente.'**
  String get adminCursoEliminadoOk;

  /// No description provided for @adminCursoEliminadoError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar el curso.'**
  String get adminCursoEliminadoError;

  /// No description provided for @adminCursosVolverCursos.
  ///
  /// In es, this message translates to:
  /// **'Volver a Cursos'**
  String get adminCursosVolverCursos;

  /// No description provided for @adminCursosCompletaInfo.
  ///
  /// In es, this message translates to:
  /// **'Completa la información del curso'**
  String get adminCursosCompletaInfo;

  /// No description provided for @adminCursosPlantillaCurso.
  ///
  /// In es, this message translates to:
  /// **'Plan de Estudios'**
  String get adminCursosPlantillaCurso;

  /// No description provided for @adminCursosSeleccionaPlantilla.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un plan'**
  String get adminCursosSeleccionaPlantilla;

  /// No description provided for @adminCursosValidarPlantilla.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un plan de estudios'**
  String get adminCursosValidarPlantilla;

  /// No description provided for @adminCursosTurnoOpcional.
  ///
  /// In es, this message translates to:
  /// **'Turno (opcional)'**
  String get adminCursosTurnoOpcional;

  /// No description provided for @adminCursosEtapa.
  ///
  /// In es, this message translates to:
  /// **'Etapa'**
  String get adminCursosEtapa;

  /// No description provided for @adminCursosDesdoblamiento.
  ///
  /// In es, this message translates to:
  /// **'Desdoblamiento'**
  String get adminCursosDesdoblamiento;

  /// No description provided for @adminCursosCodigoGrupo.
  ///
  /// In es, this message translates to:
  /// **'Código de Grupo'**
  String get adminCursosCodigoGrupo;

  /// No description provided for @adminCursosAnioAcademico.
  ///
  /// In es, this message translates to:
  /// **'Año Académico'**
  String get adminCursosAnioAcademico;

  /// No description provided for @adminCursosSinAnios.
  ///
  /// In es, this message translates to:
  /// **'No hay años académicos disponibles'**
  String get adminCursosSinAnios;

  /// No description provided for @adminCursosValidarAnio.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un año académico'**
  String get adminCursosValidarAnio;

  /// No description provided for @adminCursosValidarTutor.
  ///
  /// In es, this message translates to:
  /// **'Debes asignar un tutor al curso.'**
  String get adminCursosValidarTutor;

  /// No description provided for @adminCursosValidarMateria.
  ///
  /// In es, this message translates to:
  /// **'Debes seleccionar al menos una materia para el curso.'**
  String get adminCursosValidarMateria;

  /// No description provided for @adminCursosValidarCodigoGrupoVacio.
  ///
  /// In es, this message translates to:
  /// **'El código de grupo es obligatorio y no debe coincidir con ningún otro código del mismo año.'**
  String get adminCursosValidarCodigoGrupoVacio;

  /// No description provided for @adminCursosProfesorTutor.
  ///
  /// In es, this message translates to:
  /// **'Profesor Tutor'**
  String get adminCursosProfesorTutor;

  /// No description provided for @adminCursosMatriculacion.
  ///
  /// In es, this message translates to:
  /// **'Matriculación: {count} alumno(s)'**
  String adminCursosMatriculacion(int count);

  /// No description provided for @adminCursosMaterias.
  ///
  /// In es, this message translates to:
  /// **'Materias'**
  String get adminCursosMaterias;

  /// No description provided for @adminCursosSinMaterias.
  ///
  /// In es, this message translates to:
  /// **'No hay materias asignadas a este curso.'**
  String get adminCursosSinMaterias;

  /// No description provided for @adminCursosBuscarAnio.
  ///
  /// In es, this message translates to:
  /// **'Buscar año...'**
  String get adminCursosBuscarAnio;

  /// No description provided for @adminCursosOrdenHint.
  ///
  /// In es, this message translates to:
  /// **'A-Z (Opcional)'**
  String get adminCursosOrdenHint;

  /// No description provided for @adminCursosCodigoHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: DAM1M'**
  String get adminCursosCodigoHint;

  /// No description provided for @adminCursosTutorAsignado.
  ///
  /// In es, this message translates to:
  /// **'Tutor asignado'**
  String get adminCursosTutorAsignado;

  /// No description provided for @adminCursosBuscarProfesor.
  ///
  /// In es, this message translates to:
  /// **'Buscar profesor por nombre...'**
  String get adminCursosBuscarProfesor;

  /// No description provided for @adminCursosSeleccionaAsignaturas.
  ///
  /// In es, this message translates to:
  /// **'Selecciona las asignaturas que se impartirán'**
  String get adminCursosSeleccionaAsignaturas;

  /// No description provided for @adminCursosVistaPrevia.
  ///
  /// In es, this message translates to:
  /// **'Vista Previa del Curso'**
  String get adminCursosVistaPrevia;

  /// No description provided for @adminCursosPlantillaOficial.
  ///
  /// In es, this message translates to:
  /// **'Plantilla Oficial'**
  String get adminCursosPlantillaOficial;

  /// No description provided for @adminCursosInstanciados.
  ///
  /// In es, this message translates to:
  /// **'Cursos Instanciados'**
  String get adminCursosInstanciados;

  /// No description provided for @adminCursosVisualizacion.
  ///
  /// In es, this message translates to:
  /// **'Visualización de grupos activos'**
  String get adminCursosVisualizacion;

  /// No description provided for @adminCursosAniadirNuevo.
  ///
  /// In es, this message translates to:
  /// **'Añadir Nuevo Curso'**
  String get adminCursosAniadirNuevo;

  /// No description provided for @adminCursosNoRegistrados.
  ///
  /// In es, this message translates to:
  /// **'No hay cursos registrados para esta plantilla'**
  String get adminCursosNoRegistrados;

  /// No description provided for @adminCursosEliminarTooltip.
  ///
  /// In es, this message translates to:
  /// **'Eliminar curso'**
  String get adminCursosEliminarTooltip;

  /// No description provided for @adminCursosGestionarHorario.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Horario'**
  String get adminCursosGestionarHorario;

  /// No description provided for @adminCursosGestionarAlumnos.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Alumnos'**
  String get adminCursosGestionarAlumnos;

  /// No description provided for @adminCursosPlanificacion.
  ///
  /// In es, this message translates to:
  /// **'Planificación Académica'**
  String get adminCursosPlanificacion;

  /// No description provided for @adminCursosProgresoModulo.
  ///
  /// In es, this message translates to:
  /// **'Progreso del Módulo'**
  String get adminCursosProgresoModulo;

  /// No description provided for @adminCursosTemporalidad.
  ///
  /// In es, this message translates to:
  /// **'Temporalidad'**
  String get adminCursosTemporalidad;

  /// No description provided for @adminCursosEditarFechas.
  ///
  /// In es, this message translates to:
  /// **'Editar Fechas'**
  String get adminCursosEditarFechas;

  /// No description provided for @adminCursosVolverDetalles.
  ///
  /// In es, this message translates to:
  /// **'Volver a detalles'**
  String get adminCursosVolverDetalles;

  /// No description provided for @adminCursosVolverGrupos.
  ///
  /// In es, this message translates to:
  /// **'Volver a grupos'**
  String get adminCursosVolverGrupos;

  /// No description provided for @adminCursosSinTutor.
  ///
  /// In es, this message translates to:
  /// **'Sin tutor'**
  String get adminCursosSinTutor;

  /// No description provided for @adminCursosAlumnosMatriculados.
  ///
  /// In es, this message translates to:
  /// **'Alumnos Matriculados'**
  String get adminCursosAlumnosMatriculados;

  /// No description provided for @adminCursosAniadirAlumno.
  ///
  /// In es, this message translates to:
  /// **'Añadir Alumno'**
  String get adminCursosAniadirAlumno;

  /// No description provided for @adminCursosSinAlumnos.
  ///
  /// In es, this message translates to:
  /// **'No hay alumnos matriculados en este curso.'**
  String get adminCursosSinAlumnos;

  /// No description provided for @adminCursosQuitarAlumno.
  ///
  /// In es, this message translates to:
  /// **'Quitar Alumno'**
  String get adminCursosQuitarAlumno;

  /// No description provided for @adminDashResumenEjecutivo.
  ///
  /// In es, this message translates to:
  /// **'Resumen Ejecutivo'**
  String get adminDashResumenEjecutivo;

  /// No description provided for @adminDashMetricasTiempoReal.
  ///
  /// In es, this message translates to:
  /// **'Métricas principales del centro en tiempo real'**
  String get adminDashMetricasTiempoReal;

  /// No description provided for @adminDashAccionesRapidas.
  ///
  /// In es, this message translates to:
  /// **'Acciones Rápidas'**
  String get adminDashAccionesRapidas;

  /// No description provided for @adminDashMatricularAlumno.
  ///
  /// In es, this message translates to:
  /// **'Matricular Alumno'**
  String get adminDashMatricularAlumno;

  /// No description provided for @adminDashGestionarFestivos.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Festivos'**
  String get adminDashGestionarFestivos;

  /// No description provided for @adminDashRevisarPermisos.
  ///
  /// In es, this message translates to:
  /// **'Revisar Permisos'**
  String get adminDashRevisarPermisos;

  /// No description provided for @adminDashBienvenido.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido de nuevo, Administrador!'**
  String get adminDashBienvenido;

  /// No description provided for @adminDashVerReporteMensual.
  ///
  /// In es, this message translates to:
  /// **'Ver reporte mensual'**
  String get adminDashVerReporteMensual;

  /// No description provided for @adminDashAsistenciaGlobal.
  ///
  /// In es, this message translates to:
  /// **'Asistencia Global'**
  String get adminDashAsistenciaGlobal;

  /// No description provided for @adminDashAsistenciaSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento promedio de los últimos 7 días'**
  String get adminDashAsistenciaSubtitulo;

  /// No description provided for @adminDashIncidenciasPorCurso.
  ///
  /// In es, this message translates to:
  /// **'Incidencias por Curso (Top 5)'**
  String get adminDashIncidenciasPorCurso;

  /// No description provided for @adminDashSinIncidencias.
  ///
  /// In es, this message translates to:
  /// **'Sin incidencias registradas'**
  String get adminDashSinIncidencias;

  /// No description provided for @adminDashErrorGrafico.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar gráfico'**
  String get adminDashErrorGrafico;

  /// No description provided for @adminDashAlertasRecientes.
  ///
  /// In es, this message translates to:
  /// **'Alertas Recientes'**
  String get adminDashAlertasRecientes;

  /// No description provided for @adminDashSinAlertas.
  ///
  /// In es, this message translates to:
  /// **'Sin alertas recientes'**
  String get adminDashSinAlertas;

  /// No description provided for @adminDashFiltroAplicado.
  ///
  /// In es, this message translates to:
  /// **'Filtro aplicado'**
  String get adminDashFiltroAplicado;

  /// No description provided for @adminDashMostrandoDatos.
  ///
  /// In es, this message translates to:
  /// **'Mostrando datos de {periodo}'**
  String adminDashMostrandoDatos(String periodo);

  /// No description provided for @adminDashSeleccionarEtapa.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la etapa actual de esta incidencia'**
  String get adminDashSeleccionarEtapa;

  /// No description provided for @adminAuditoriaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Auditoría del Sistema'**
  String get adminAuditoriaTitulo;

  /// No description provided for @adminAuditoriaSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Registro de actividad y cambios críticos'**
  String get adminAuditoriaSubtitulo;

  /// No description provided for @adminAuditoriaFiltrarPor.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por acción'**
  String get adminAuditoriaFiltrarPor;

  /// No description provided for @adminAuditoriaBuscar.
  ///
  /// In es, this message translates to:
  /// **'Buscar en el registro...'**
  String get adminAuditoriaBuscar;

  /// No description provided for @adminAuditoriaSinRegistros.
  ///
  /// In es, this message translates to:
  /// **'No hay registros de auditoría.'**
  String get adminAuditoriaSinRegistros;

  /// No description provided for @adminAuditoriaUsuario.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get adminAuditoriaUsuario;

  /// No description provided for @adminAuditoriaAccion.
  ///
  /// In es, this message translates to:
  /// **'Acción'**
  String get adminAuditoriaAccion;

  /// No description provided for @adminAuditoriaFecha.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get adminAuditoriaFecha;

  /// No description provided for @adminAuditoriaDetalle.
  ///
  /// In es, this message translates to:
  /// **'Detalle'**
  String get adminAuditoriaDetalle;

  /// No description provided for @adminAuditoriaTodos.
  ///
  /// In es, this message translates to:
  /// **'TODOS'**
  String get adminAuditoriaTodos;

  /// No description provided for @adminAuditoriaExportar.
  ///
  /// In es, this message translates to:
  /// **'Exportar'**
  String get adminAuditoriaExportar;

  /// No description provided for @adminUsuariosSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Administra los accesos al sistema'**
  String get adminUsuariosSubtitulo;

  /// No description provided for @adminUsuariosBuscar.
  ///
  /// In es, this message translates to:
  /// **'Buscar usuario...'**
  String get adminUsuariosBuscar;

  /// No description provided for @adminUsuariosNuevo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Usuario'**
  String get adminUsuariosNuevo;

  /// No description provided for @adminUsuariosEmail.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get adminUsuariosEmail;

  /// No description provided for @adminUsuariosSinUsuarios.
  ///
  /// In es, this message translates to:
  /// **'No hay usuarios registrados.'**
  String get adminUsuariosSinUsuarios;

  /// No description provided for @adminUsuariosEliminarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Usuario'**
  String get adminUsuariosEliminarTitulo;

  /// No description provided for @adminUsuariosEliminarDesc.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar este usuario? Esta acción no se puede deshacer.'**
  String get adminUsuariosEliminarDesc;

  /// No description provided for @adminUsuariosActivar.
  ///
  /// In es, this message translates to:
  /// **'Activar'**
  String get adminUsuariosActivar;

  /// No description provided for @adminUsuariosDesactivar.
  ///
  /// In es, this message translates to:
  /// **'Desactivar'**
  String get adminUsuariosDesactivar;

  /// No description provided for @adminUsuariosEditar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get adminUsuariosEditar;

  /// No description provided for @adminUsuariosActivadoMsg.
  ///
  /// In es, this message translates to:
  /// **'Usuario activado correctamente.'**
  String get adminUsuariosActivadoMsg;

  /// No description provided for @adminUsuariosDesactivadoMsg.
  ///
  /// In es, this message translates to:
  /// **'Usuario desactivado correctamente.'**
  String get adminUsuariosDesactivadoMsg;

  /// No description provided for @adminUsuariosEliminadoMsg.
  ///
  /// In es, this message translates to:
  /// **'Usuario eliminado correctamente.'**
  String get adminUsuariosEliminadoMsg;

  /// No description provided for @adminUsuariosErrorMsg.
  ///
  /// In es, this message translates to:
  /// **'Error al procesar la solicitud.'**
  String get adminUsuariosErrorMsg;

  /// No description provided for @adminConfigTitulo.
  ///
  /// In es, this message translates to:
  /// **'Configuración del Sistema'**
  String get adminConfigTitulo;

  /// No description provided for @adminConfigSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Gestiona los ajustes generales del centro'**
  String get adminConfigSubtitulo;

  /// No description provided for @adminConfigGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get adminConfigGuardar;

  /// No description provided for @adminConfigCambiosGuardados.
  ///
  /// In es, this message translates to:
  /// **'Cambios guardados correctamente.'**
  String get adminConfigCambiosGuardados;

  /// No description provided for @adminConfigErrorGuardar.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar los cambios.'**
  String get adminConfigErrorGuardar;

  /// No description provided for @adminConfigNombreCentro.
  ///
  /// In es, this message translates to:
  /// **'Nombre del Centro'**
  String get adminConfigNombreCentro;

  /// No description provided for @adminConfigDireccion.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get adminConfigDireccion;

  /// No description provided for @adminConfigTelefono.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get adminConfigTelefono;

  /// No description provided for @adminConfigEmail.
  ///
  /// In es, this message translates to:
  /// **'Email de Contacto'**
  String get adminConfigEmail;

  /// No description provided for @adminConfigCursoActivo.
  ///
  /// In es, this message translates to:
  /// **'Año Académico Activo'**
  String get adminConfigCursoActivo;

  /// No description provided for @adminHorarioSinSesiones.
  ///
  /// In es, this message translates to:
  /// **'No hay sesiones configuradas.'**
  String get adminHorarioSinSesiones;

  /// No description provided for @adminHorarioNuevaSesion.
  ///
  /// In es, this message translates to:
  /// **'Nueva Sesión'**
  String get adminHorarioNuevaSesion;

  /// No description provided for @adminHorarioEliminarSesion.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Sesión'**
  String get adminHorarioEliminarSesion;

  /// No description provided for @adminHorarioEliminarSesionDesc.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar esta sesión del horario?'**
  String get adminHorarioEliminarSesionDesc;

  /// No description provided for @adminHorarioSesionCreada.
  ///
  /// In es, this message translates to:
  /// **'Sesión creada correctamente.'**
  String get adminHorarioSesionCreada;

  /// No description provided for @adminHorarioSesionEliminada.
  ///
  /// In es, this message translates to:
  /// **'Sesión eliminada correctamente.'**
  String get adminHorarioSesionEliminada;

  /// No description provided for @adminRolesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Roles'**
  String get adminRolesTitulo;

  /// No description provided for @adminRolesSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Define permisos y accesos por rol'**
  String get adminRolesSubtitulo;

  /// No description provided for @adminRolesSinRoles.
  ///
  /// In es, this message translates to:
  /// **'No hay roles definidos.'**
  String get adminRolesSinRoles;

  /// No description provided for @adminRolesGuardado.
  ///
  /// In es, this message translates to:
  /// **'Rol actualizado correctamente.'**
  String get adminRolesGuardado;

  /// No description provided for @adminRolesError.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar el rol.'**
  String get adminRolesError;

  /// No description provided for @adminReglamentoGuardado.
  ///
  /// In es, this message translates to:
  /// **'Reglamento guardado correctamente.'**
  String get adminReglamentoGuardado;

  /// No description provided for @adminReglamentoNuevoArticulo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Artículo'**
  String get adminReglamentoNuevoArticulo;

  /// No description provided for @adminReglamentoEliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Artículo'**
  String get adminReglamentoEliminar;

  /// No description provided for @adminReglamentoEliminarDesc.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar este artículo del reglamento?'**
  String get adminReglamentoEliminarDesc;

  /// No description provided for @adminProgConfigTitulo.
  ///
  /// In es, this message translates to:
  /// **'Configuración del Programa'**
  String get adminProgConfigTitulo;

  /// No description provided for @adminProgConfigSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Gestiona los módulos y configuración académica'**
  String get adminProgConfigSubtitulo;

  /// No description provided for @adminProgConfigGuardado.
  ///
  /// In es, this message translates to:
  /// **'Configuración guardada correctamente.'**
  String get adminProgConfigGuardado;

  /// No description provided for @adminProgConfigError.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar la configuración.'**
  String get adminProgConfigError;

  /// No description provided for @adminPermissionsTitulo.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Permisos'**
  String get adminPermissionsTitulo;

  /// No description provided for @adminPermissionsSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Controla el acceso a funcionalidades del sistema'**
  String get adminPermissionsSubtitulo;

  /// No description provided for @adminPermissionsGuardado.
  ///
  /// In es, this message translates to:
  /// **'Permisos actualizados correctamente.'**
  String get adminPermissionsGuardado;

  /// No description provided for @adminPermissionsError.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar los permisos.'**
  String get adminPermissionsError;

  /// No description provided for @adminUsuariosBuscarDetalle.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre, apellidos, usuario...'**
  String get adminUsuariosBuscarDetalle;

  /// No description provided for @adminUsuariosColUsuario.
  ///
  /// In es, this message translates to:
  /// **'USUARIO / IDENTIFICACIÓN'**
  String get adminUsuariosColUsuario;

  /// No description provided for @adminUsuariosColEmail.
  ///
  /// In es, this message translates to:
  /// **'EMAIL'**
  String get adminUsuariosColEmail;

  /// No description provided for @adminUsuariosColRol.
  ///
  /// In es, this message translates to:
  /// **'ROL'**
  String get adminUsuariosColRol;

  /// No description provided for @adminUsuariosColEstado.
  ///
  /// In es, this message translates to:
  /// **'ESTADO'**
  String get adminUsuariosColEstado;

  /// No description provided for @adminUsuariosColUltimaActividad.
  ///
  /// In es, this message translates to:
  /// **'ÚLTIMA ACTIVIDAD'**
  String get adminUsuariosColUltimaActividad;

  /// No description provided for @adminUsuariosColIpSesion.
  ///
  /// In es, this message translates to:
  /// **'IP SESIÓN'**
  String get adminUsuariosColIpSesion;

  /// No description provided for @adminUsuariosColAcciones.
  ///
  /// In es, this message translates to:
  /// **'ACCIONES'**
  String get adminUsuariosColAcciones;

  /// No description provided for @adminUsuariosSinResultados.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados para el filtro actual'**
  String get adminUsuariosSinResultados;

  /// No description provided for @adminUsuariosMostrando.
  ///
  /// In es, this message translates to:
  /// **'Mostrando {from} - {to} de {total}'**
  String adminUsuariosMostrando(int from, int to, int total);

  /// No description provided for @adminUsuariosMostrandoRegistros.
  ///
  /// In es, this message translates to:
  /// **'Mostrando {from} - {to} de {total} registros'**
  String adminUsuariosMostrandoRegistros(int from, int to, int total);

  /// No description provided for @adminUsuariosMenuVerPerfil.
  ///
  /// In es, this message translates to:
  /// **'Ver Perfil Completo'**
  String get adminUsuariosMenuVerPerfil;

  /// No description provided for @adminUsuariosMenuEditar.
  ///
  /// In es, this message translates to:
  /// **'Editar Usuario'**
  String get adminUsuariosMenuEditar;

  /// No description provided for @adminUsuariosMenuResetear.
  ///
  /// In es, this message translates to:
  /// **'Resetear Contraseña'**
  String get adminUsuariosMenuResetear;

  /// No description provided for @adminUsuariosMenuDesactivar.
  ///
  /// In es, this message translates to:
  /// **'Desactivar Cuenta'**
  String get adminUsuariosMenuDesactivar;

  /// No description provided for @adminUsuariosMenuActivar.
  ///
  /// In es, this message translates to:
  /// **'Activar Cuenta'**
  String get adminUsuariosMenuActivar;

  /// No description provided for @adminUsuariosMenuEliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Usuario'**
  String get adminUsuariosMenuEliminar;

  /// No description provided for @adminUsuariosToastCopiado.
  ///
  /// In es, this message translates to:
  /// **'Copiado'**
  String get adminUsuariosToastCopiado;

  /// No description provided for @adminUsuariosToastTokenCopiado.
  ///
  /// In es, this message translates to:
  /// **'Token de sesión copiado.'**
  String get adminUsuariosToastTokenCopiado;

  /// No description provided for @adminUsuariosToastContrasenaReseteada.
  ///
  /// In es, this message translates to:
  /// **'Contraseña Reseteada'**
  String get adminUsuariosToastContrasenaReseteada;

  /// No description provided for @adminUsuariosToastContrasenaMsg.
  ///
  /// In es, this message translates to:
  /// **'La contraseña para {username} es ahora: gaula123'**
  String adminUsuariosToastContrasenaMsg(String username);

  /// No description provided for @adminUsuariosToastError.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get adminUsuariosToastError;

  /// No description provided for @adminUsuariosToastNoResetear.
  ///
  /// In es, this message translates to:
  /// **'No se pudo resetear la contraseña.'**
  String get adminUsuariosToastNoResetear;

  /// No description provided for @adminUsuariosToastEstadoActualizado.
  ///
  /// In es, this message translates to:
  /// **'Estado Actualizado'**
  String get adminUsuariosToastEstadoActualizado;

  /// No description provided for @adminUsuariosToastEstadoMsg.
  ///
  /// In es, this message translates to:
  /// **'Usuario {username} está ahora {estado}'**
  String adminUsuariosToastEstadoMsg(String username, String estado);

  /// No description provided for @adminUsuariosToastNoEstado.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cambiar el estado.'**
  String get adminUsuariosToastNoEstado;

  /// No description provided for @adminUsuariosToastEliminado.
  ///
  /// In es, this message translates to:
  /// **'Usuario Eliminado'**
  String get adminUsuariosToastEliminado;

  /// No description provided for @adminUsuariosToastEliminadoMsg.
  ///
  /// In es, this message translates to:
  /// **'El registro ha sido borrado del sistema.'**
  String get adminUsuariosToastEliminadoMsg;

  /// No description provided for @adminUsuariosToastNoEliminar.
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar el usuario.'**
  String get adminUsuariosToastNoEliminar;

  /// No description provided for @adminUsuariosDialogEliminarTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar Usuario?'**
  String get adminUsuariosDialogEliminarTitulo;

  /// No description provided for @adminUsuariosDialogEliminarMsg.
  ///
  /// In es, this message translates to:
  /// **'Esta acción eliminará permanentemente a {nombre} (@{username}). Esta acción no se puede deshacer.'**
  String adminUsuariosDialogEliminarMsg(String nombre, String username);

  /// No description provided for @adminUsuariosDialogCancelar.
  ///
  /// In es, this message translates to:
  /// **'CANCELAR'**
  String get adminUsuariosDialogCancelar;

  /// No description provided for @adminUsuariosDialogEliminar.
  ///
  /// In es, this message translates to:
  /// **'ELIMINAR'**
  String get adminUsuariosDialogEliminar;

  /// No description provided for @adminUsuariosTodosFiltro.
  ///
  /// In es, this message translates to:
  /// **'Todos ({hint})'**
  String adminUsuariosTodosFiltro(String hint);

  /// No description provided for @crearIncidenciaCompletaCampos.
  ///
  /// In es, this message translates to:
  /// **'Por favor completa todos los campos'**
  String get crearIncidenciaCompletaCampos;

  /// No description provided for @crearIncidenciaSeleccionaAlumno.
  ///
  /// In es, this message translates to:
  /// **'Por favor selecciona un alumno'**
  String get crearIncidenciaSeleccionaAlumno;

  /// No description provided for @crearIncidenciaExito.
  ///
  /// In es, this message translates to:
  /// **'✅ Incidencia creada correctamente'**
  String get crearIncidenciaExito;

  /// No description provided for @crearIncidenciaError.
  ///
  /// In es, this message translates to:
  /// **'Error al crear incidencia'**
  String get crearIncidenciaError;

  /// No description provided for @crearIncidenciaSubtituloAlumno.
  ///
  /// In es, this message translates to:
  /// **'Reporta un problema o incidencia'**
  String get crearIncidenciaSubtituloAlumno;

  /// No description provided for @crearIncidenciaSubtituloProfesor.
  ///
  /// In es, this message translates to:
  /// **'Registra una incidencia de un alumno'**
  String get crearIncidenciaSubtituloProfesor;

  /// No description provided for @crearIncidenciaAlumnoLabel.
  ///
  /// In es, this message translates to:
  /// **'Alumno *'**
  String get crearIncidenciaAlumnoLabel;

  /// No description provided for @crearIncidenciaTituloLabel.
  ///
  /// In es, this message translates to:
  /// **'Título *'**
  String get crearIncidenciaTituloLabel;

  /// No description provided for @crearIncidenciaTituloHint.
  ///
  /// In es, this message translates to:
  /// **'Breve descripción del problema'**
  String get crearIncidenciaTituloHint;

  /// No description provided for @crearIncidenciaDescripcionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción *'**
  String get crearIncidenciaDescripcionLabel;

  /// No description provided for @crearIncidenciaDescripcionHint.
  ///
  /// In es, this message translates to:
  /// **'Describe el problema en detalle...'**
  String get crearIncidenciaDescripcionHint;

  /// No description provided for @crearIncidenciaGravedadLabel.
  ///
  /// In es, this message translates to:
  /// **'Gravedad'**
  String get crearIncidenciaGravedadLabel;

  /// No description provided for @crearIncidenciaBoton.
  ///
  /// In es, this message translates to:
  /// **'Crear Incidencia'**
  String get crearIncidenciaBoton;

  /// No description provided for @crearIncidenciaBuscarAlumno.
  ///
  /// In es, this message translates to:
  /// **'Escribe para buscar...'**
  String get crearIncidenciaBuscarAlumno;

  /// No description provided for @crearIncidenciaSinGrupo.
  ///
  /// In es, this message translates to:
  /// **'Sin grupo'**
  String get crearIncidenciaSinGrupo;

  /// No description provided for @crearIncidenciaErrorAlumnos.
  ///
  /// In es, this message translates to:
  /// **'Error cargando alumnos'**
  String get crearIncidenciaErrorAlumnos;

  /// No description provided for @verReporteMensual.
  ///
  /// In es, this message translates to:
  /// **'Ver reporte mensual'**
  String get verReporteMensual;

  /// No description provided for @sinAlertasRecientes.
  ///
  /// In es, this message translates to:
  /// **'Sin alertas recientes'**
  String get sinAlertasRecientes;

  /// No description provided for @buscarPorNombre.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre...'**
  String get buscarPorNombre;

  /// No description provided for @asignarMaterias.
  ///
  /// In es, this message translates to:
  /// **'Asignar Materias'**
  String get asignarMaterias;

  /// No description provided for @cursoSinMaterias.
  ///
  /// In es, this message translates to:
  /// **'Este curso no tiene materias asignadas'**
  String get cursoSinMaterias;

  /// No description provided for @marcarTodos.
  ///
  /// In es, this message translates to:
  /// **'Marcar todos'**
  String get marcarTodos;

  /// No description provided for @desmarcarTodos.
  ///
  /// In es, this message translates to:
  /// **'Desmarcar todos'**
  String get desmarcarTodos;

  /// No description provided for @atras.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get atras;

  /// No description provided for @matricular.
  ///
  /// In es, this message translates to:
  /// **'Matricular'**
  String get matricular;

  /// No description provided for @anadirCursoModalidad.
  ///
  /// In es, this message translates to:
  /// **'Añadir curso a esta modalidad'**
  String get anadirCursoModalidad;

  /// No description provided for @etapaActualIncidencia.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la etapa actual de esta incidencia'**
  String get etapaActualIncidencia;

  /// No description provided for @buscarPorTituloDesc.
  ///
  /// In es, this message translates to:
  /// **'Buscar por título o descripción...'**
  String get buscarPorTituloDesc;

  /// No description provided for @topAlumnosIncidencias.
  ///
  /// In es, this message translates to:
  /// **'Top Alumnos con Incidencias'**
  String get topAlumnosIncidencias;

  /// No description provided for @noHayIncidencias.
  ///
  /// In es, this message translates to:
  /// **'No hay incidencias registradas'**
  String get noHayIncidencias;

  /// No description provided for @resolucionIncidencia.
  ///
  /// In es, this message translates to:
  /// **'Resolución de Incidencia'**
  String get resolucionIncidencia;

  /// No description provided for @esInvalida.
  ///
  /// In es, this message translates to:
  /// **'ES INVÁLIDA'**
  String get esInvalida;

  /// No description provided for @esValida.
  ///
  /// In es, this message translates to:
  /// **'ES VÁLIDA'**
  String get esValida;

  /// No description provided for @fechaPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Fecha...'**
  String get fechaPlaceholder;

  /// No description provided for @materia.
  ///
  /// In es, this message translates to:
  /// **'Materia'**
  String get materia;

  /// No description provided for @seleccionarMateria.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar materia'**
  String get seleccionarMateria;

  /// No description provided for @docenteConNombreLabel.
  ///
  /// In es, this message translates to:
  /// **'Docente: {nombre}'**
  String docenteConNombreLabel(String nombre);

  /// No description provided for @siguienteLabel.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get siguienteLabel;

  /// No description provided for @cambiarPasswordTitulo.
  ///
  /// In es, this message translates to:
  /// **'Cambiar Contraseña'**
  String get cambiarPasswordTitulo;

  /// No description provided for @cambiarPasswordDesc.
  ///
  /// In es, this message translates to:
  /// **'Introduce tu contraseña actual y la nueva'**
  String get cambiarPasswordDesc;

  /// No description provided for @dialogContrasenyaActual.
  ///
  /// In es, this message translates to:
  /// **'Contraseña Actual'**
  String get dialogContrasenyaActual;

  /// No description provided for @dialogNovaContrasenya.
  ///
  /// In es, this message translates to:
  /// **'Nueva Contraseña'**
  String get dialogNovaContrasenya;

  /// No description provided for @dialogConfirmarNovaContrasenya.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Nueva Contraseña'**
  String get dialogConfirmarNovaContrasenya;

  /// No description provided for @notificacionesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificacionesTitulo;

  /// No description provided for @marcarTodas.
  ///
  /// In es, this message translates to:
  /// **'Marcar todas'**
  String get marcarTodas;

  /// No description provided for @noHayNotificaciones.
  ///
  /// In es, this message translates to:
  /// **'No hay notificaciones'**
  String get noHayNotificaciones;

  /// No description provided for @reglamentoCentro.
  ///
  /// In es, this message translates to:
  /// **'REGLAMENTO DEL CENTRO'**
  String get reglamentoCentro;

  /// No description provided for @normativaVigente.
  ///
  /// In es, this message translates to:
  /// **'NORMATIVA VIGENTE'**
  String get normativaVigente;

  /// No description provided for @versionActualizada.
  ///
  /// In es, this message translates to:
  /// **'Versión Actualizada'**
  String get versionActualizada;

  /// No description provided for @paginaNoEncontrada.
  ///
  /// In es, this message translates to:
  /// **'Página no encontrada: {uri}'**
  String paginaNoEncontrada(String uri);

  /// No description provided for @irAlInicio.
  ///
  /// In es, this message translates to:
  /// **'Ir al inicio'**
  String get irAlInicio;

  /// Filter tab: all
  ///
  /// In es, this message translates to:
  /// **'TODAS'**
  String get tabTotes;

  /// Filter tab: open
  ///
  /// In es, this message translates to:
  /// **'ABIERTO'**
  String get tabObert;

  /// Filter tab: in progress
  ///
  /// In es, this message translates to:
  /// **'EN PROCESO'**
  String get tabEnProces;

  /// Filter tab: closed
  ///
  /// In es, this message translates to:
  /// **'CERRADO'**
  String get tabTancat;

  /// Filter label: course
  ///
  /// In es, this message translates to:
  /// **'Curso'**
  String get filtreCurs;

  /// Filter label: student
  ///
  /// In es, this message translates to:
  /// **'Alumno'**
  String get filtreAlumne;

  /// Filter label: teacher
  ///
  /// In es, this message translates to:
  /// **'Profesor'**
  String get filtreProfessor;

  /// Filter by student hint
  ///
  /// In es, this message translates to:
  /// **'Filtrar por alumno...'**
  String get filtrarPorAlumno;

  /// Filter by teacher hint
  ///
  /// In es, this message translates to:
  /// **'Filtrar por profesor...'**
  String get filtrarPorProfesor;

  /// All students option
  ///
  /// In es, this message translates to:
  /// **'Todos los Alumnos'**
  String get todosAlumnos;

  /// All teachers option
  ///
  /// In es, this message translates to:
  /// **'Todos los Profesores'**
  String get todosProfesores;

  /// All (short)
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get todos;

  /// Pending course code fallback
  ///
  /// In es, this message translates to:
  /// **'PENDIENTE'**
  String get incidenciaPendiente;

  /// Resolution badge: valid
  ///
  /// In es, this message translates to:
  /// **'VÁLIDA'**
  String get resValida;

  /// Resolution badge: invalid
  ///
  /// In es, this message translates to:
  /// **'INVÁLIDA'**
  String get resInvalida;

  /// Is invalid button label
  ///
  /// In es, this message translates to:
  /// **'ES INVÁLIDA'**
  String get incidenciasEsInvalida;

  /// Resolution confirmation dialog body
  ///
  /// In es, this message translates to:
  /// **'Tras la investigación realizada, ¿se confirma que la incidencia es verídica y amerita sanción?'**
  String get incidenciaConfirmacioText;

  /// Course summary header
  ///
  /// In es, this message translates to:
  /// **'Top Alumnos con Incidencias'**
  String get topAlumnesIncidencies;

  /// Total alerts count suffix
  ///
  /// In es, this message translates to:
  /// **'ALERTAS TOTALES'**
  String get alertesTotals;

  /// No description provided for @incidenciaSeveridadLeve.
  ///
  /// In es, this message translates to:
  /// **'Leve'**
  String get incidenciaSeveridadLeve;

  /// No description provided for @incidenciaSeveridadGrave.
  ///
  /// In es, this message translates to:
  /// **'Grave'**
  String get incidenciaSeveridadGrave;

  /// No description provided for @incidenciaSeveridadMuyGrave.
  ///
  /// In es, this message translates to:
  /// **'Muy Grave'**
  String get incidenciaSeveridadMuyGrave;

  /// No description provided for @adminCursosCalendario.
  ///
  /// In es, this message translates to:
  /// **'Calendario Escolar'**
  String get adminCursosCalendario;

  /// No description provided for @adminCursosVerOtrosAnios.
  ///
  /// In es, this message translates to:
  /// **'Ver otros años'**
  String get adminCursosVerOtrosAnios;

  /// No description provided for @adminCursosAniadirCurso.
  ///
  /// In es, this message translates to:
  /// **'Añadir Curso'**
  String get adminCursosAniadirCurso;

  /// No description provided for @adminCursosTurnoPartido.
  ///
  /// In es, this message translates to:
  /// **'Partido (P)'**
  String get adminCursosTurnoPartido;

  /// No description provided for @adminCursosTurnoManana.
  ///
  /// In es, this message translates to:
  /// **'Mañana (M)'**
  String get adminCursosTurnoManana;

  /// No description provided for @adminCursosTurnoTarde.
  ///
  /// In es, this message translates to:
  /// **'Tarde (T)'**
  String get adminCursosTurnoTarde;

  /// No description provided for @adminCursosTurnoNocturno.
  ///
  /// In es, this message translates to:
  /// **'Nocturno (N)'**
  String get adminCursosTurnoNocturno;

  /// No description provided for @statPresentes.
  ///
  /// In es, this message translates to:
  /// **'Pres.'**
  String get statPresentes;

  /// No description provided for @statAusentes.
  ///
  /// In es, this message translates to:
  /// **'Aus.'**
  String get statAusentes;

  /// No description provided for @statRetrasos.
  ///
  /// In es, this message translates to:
  /// **'Retr.'**
  String get statRetrasos;

  /// No description provided for @diaSabado.
  ///
  /// In es, this message translates to:
  /// **'Sábado'**
  String get diaSabado;

  /// No description provided for @diaDomingo.
  ///
  /// In es, this message translates to:
  /// **'Domingo'**
  String get diaDomingo;

  /// No description provided for @asistenciaAlumnoIndex.
  ///
  /// In es, this message translates to:
  /// **'Alumno {index} de {total}'**
  String asistenciaAlumnoIndex(int index, int total);

  /// No description provided for @asistenciaHoraLabel.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get asistenciaHoraLabel;

  /// No description provided for @asistenciaCursoLabel.
  ///
  /// In es, this message translates to:
  /// **'Curso'**
  String get asistenciaCursoLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
