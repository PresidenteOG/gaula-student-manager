// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GAULA — Classroom Management';

  @override
  String get loading => 'Loading...';

  @override
  String get errorGenerico => 'Error';

  @override
  String get reintentar => 'Retry';

  @override
  String get guardar => 'Save';

  @override
  String get cancelar => 'Cancel';

  @override
  String get cerrar => 'Close';

  @override
  String get volver => 'Back';

  @override
  String get confirmar => 'Confirm';

  @override
  String get buscar => 'Search';

  @override
  String get buscarPlaceholder => 'Search...';

  @override
  String get sinDatos => 'No data available.';

  @override
  String get aceptar => 'Accept';

  @override
  String get eliminar => 'Delete';

  @override
  String get justificar => 'Justify';

  @override
  String get editar => 'Edit';

  @override
  String get crear => 'Create';

  @override
  String get agregar => 'Add';

  @override
  String get ver => 'View';

  @override
  String get exportar => 'Export';

  @override
  String get importar => 'Import';

  @override
  String get actualizar => 'Update';

  @override
  String pagina(int actual, int total) {
    return 'Page $actual of $total';
  }

  @override
  String get navInicio => 'Home';

  @override
  String get navAsistencia => 'Attendance';

  @override
  String get navCalendario => 'Calendar';

  @override
  String get navAlumnos => 'Students';

  @override
  String get navProfesores => 'Teachers';

  @override
  String get navCursos => 'Courses';

  @override
  String get navIncidencias => 'Incidents';

  @override
  String get navReglamento => 'Rules';

  @override
  String get navCerrarSesion => 'Log out';

  @override
  String get navResumen => 'Summary';

  @override
  String get navPlanesEstudios => 'Study Plans';

  @override
  String get navConfiguracion => 'Settings';

  @override
  String get navCopiaSeguridad => 'Backup';

  @override
  String get navMiHorario => 'My Schedule';

  @override
  String get navNormasCentro => 'School Rules';

  @override
  String get navHistorialClases => 'Class History';

  @override
  String get navMiPerfil => 'My Profile';

  @override
  String get navAjustes => 'Settings';

  @override
  String get navMiAsistencia => 'My Attendance';

  @override
  String get navHistorial => 'History';

  @override
  String get navMiFicha => 'My Record';

  @override
  String get navMisIncidencias => 'My Incidents';

  @override
  String get navPasarLista => 'Take Attendance';

  @override
  String get rolAdministrador => 'ADMINISTRATOR';

  @override
  String get rolProfesor => 'TEACHER';

  @override
  String get rolAlumno => 'STUDENT';

  @override
  String get shellAdminTitulo => 'Admin Panel';

  @override
  String get shellAdminSubtitulo => 'GAULA Central Management';

  @override
  String get shellAdminTituloMovil => 'GAULA Admin';

  @override
  String get shellTeacherTitulo => 'Teacher Portal';

  @override
  String get shellTeacherSubtitulo => 'GAULA Educational Management';

  @override
  String get shellTeacherTituloMovil => 'GAULA Teacher';

  @override
  String get shellStudentSubtitulo => 'Student Panel';

  @override
  String saludoHola(String nombre) {
    return 'Hello, $nombre';
  }

  @override
  String get sinNotificaciones => 'No notifications';

  @override
  String get loginTitulo => 'Sign in';

  @override
  String get loginUsuario => 'Username';

  @override
  String get loginContrasena => 'Password';

  @override
  String get loginBoton => 'Enter';

  @override
  String get loginErrorCredenciales => 'Incorrect username or password.';

  @override
  String get loginErrorConexion => 'Connection error. Is the server running?';

  @override
  String get dashClasesHoy => 'Classes today';

  @override
  String get dashAlumnosTotales => 'Total students';

  @override
  String get dashIncidenciasHoy => 'Incidents today';

  @override
  String get dashAsistenciaMedia => 'Average attendance';

  @override
  String get dashAsistenciaTotal => 'Total attendance';

  @override
  String get dashAusencias => 'Absences';

  @override
  String get dashRetrasos => 'Late arrivals';

  @override
  String get dashHorasFaltadas => 'Hours missed';

  @override
  String get dashClasesTotales => 'Total classes';

  @override
  String get seccionListasPendientes => 'Pending Lists';

  @override
  String get todoAlDia => 'All caught up 🎉';

  @override
  String get seccionProximasClases => 'Upcoming Classes';

  @override
  String get sinClasesHoy => 'No classes today';

  @override
  String get sinClasesProximas => 'No upcoming classes right now';

  @override
  String get accesRapido => 'Quick Access';

  @override
  String get irAPasarLista => 'Go to Attendance';

  @override
  String proximaClaseLabel(String materia) {
    return 'Next: $materia';
  }

  @override
  String aulaHoraLabel(String aula, String horaInicio, String horaFin) {
    return 'Room: $aula • $horaInicio - $horaFin';
  }

  @override
  String get errorCargarProximaClase => 'Error loading next class';

  @override
  String get misClasesHoy => 'My Classes Today';

  @override
  String get horarioCompleto => 'Full Schedule';

  @override
  String get cargandoHorario => 'Loading schedule...';

  @override
  String get errorCargandoHorario => 'Error loading schedule';

  @override
  String get sinClasesHoyAlumno => 'No classes scheduled for today';

  @override
  String get saludoEstudiante => 'Student';

  @override
  String get saludoProfesor => 'Teacher';

  @override
  String get historialTitulo => 'Class History';

  @override
  String get historialSubtitulo => 'Complete record of all your class sessions';

  @override
  String get historialVacio => 'No class history yet';

  @override
  String get historialVacioDesc =>
      'Your attendance history will appear here as the teacher takes attendance';

  @override
  String get fechaHoy => 'Today';

  @override
  String get asistenciaTitulo => 'My Attendance';

  @override
  String get asistenciaMaterias => 'Subjects';

  @override
  String get asistenciaRegistro => 'History';

  @override
  String get asistenciaAusente => 'Absent';

  @override
  String get asistenciaRetraso => 'Late';

  @override
  String get asistenciaJustificado => 'Excused';

  @override
  String get asistenciaPresente => 'Present';

  @override
  String get asistenciaSinFaltas => 'No absences or delays recorded.';

  @override
  String get asistenciaPasarLista => 'Take Attendance';

  @override
  String get estadoPresente => 'PRESENT';

  @override
  String get estadoAusente => 'ABSENT';

  @override
  String get estadoRetraso => 'LATE';

  @override
  String get estadoJustificado => 'EXCUSED';

  @override
  String get estadoActivo => 'ACTIVE';

  @override
  String get estadoInactivo => 'INACTIVE';

  @override
  String get estadoMatriculado => 'ENROLLED';

  @override
  String get estadoAbierto => 'OPEN';

  @override
  String get estadoEnProceso => 'IN PROGRESS';

  @override
  String get estadoCerrado => 'CLOSED';

  @override
  String get calendarioTitulo => 'Public Holiday Calendar';

  @override
  String get calendarioSubtitulo =>
      'Non-teaching days and academic holidays synced';

  @override
  String get calendarioProximosDias => 'UPCOMING DAYS';

  @override
  String get calendarioConfigurarRegion => 'CONFIGURE REGION';

  @override
  String get calendarioSincronizar => 'Sync Holidays';

  @override
  String get calendarioSinFestivos => 'No holidays registered for this period.';

  @override
  String get calendarioNacional => 'National';

  @override
  String get calendarioAutonomico => 'Regional';

  @override
  String get seleccionarCurso => 'Select Course';

  @override
  String get seleccionarCursoDesc =>
      'Select a course to see today\'s available subjects.';

  @override
  String get seleccionarMateriaDesc =>
      'Select the subject to see its sessions.';

  @override
  String get seleccionarSesionDesc =>
      'Select the exact session to take attendance.';

  @override
  String get sinSesionesHoy => 'No sessions scheduled for today.';

  @override
  String get sinMaterias => 'No subjects in this course.';

  @override
  String get sinCursos => 'No courses found.';

  @override
  String get volverMisClases => 'Back to my classes';

  @override
  String get modoUnoEnUno => 'One by One';

  @override
  String get modoClasico => 'Classic';

  @override
  String get perfilFoto => 'Profile photo';

  @override
  String get perfilCambiarFoto => 'Change photo';

  @override
  String get errorServidor => 'Server error. Please try again later.';

  @override
  String get mantenimiento =>
      'The server is under maintenance. Please try again in a few minutes.';

  @override
  String get alumnosTitulo => 'Students';

  @override
  String get alumnoNuevo => 'New Student';

  @override
  String get alumnoEditar => 'Edit Student';

  @override
  String get alumnoRegistrado => 'Student registered successfully';

  @override
  String get alumnoActualizado => 'Student updated successfully';

  @override
  String get alumnoEliminado => 'Student deleted successfully';

  @override
  String get errorRegistrarAlumno => 'Error registering student';

  @override
  String get alumnoNombre => 'First name';

  @override
  String get alumnoApellidos => 'Last name';

  @override
  String get alumnoEmail => 'Email';

  @override
  String get alumnoDni => 'ID number';

  @override
  String get alumnoUsuario => 'Username';

  @override
  String get alumnoContrasena => 'Password';

  @override
  String get alumnoCurso => 'Course';

  @override
  String get alumnoSinCurso => 'Unassigned';

  @override
  String get alumnoSinMatricular => 'Not enrolled';

  @override
  String get profesoresTitulo => 'Teachers';

  @override
  String get profesorNuevo => 'New Teacher';

  @override
  String get profesorEditar => 'Edit Teacher';

  @override
  String get profesorRegistrado => 'Teacher registered successfully';

  @override
  String get profesorActualizado => 'Teacher updated successfully';

  @override
  String get profesorEliminado => 'Teacher deleted successfully';

  @override
  String get cursosTitulo => 'Courses';

  @override
  String get cursoNuevo => 'Create New Course';

  @override
  String get cursoEliminar => 'Delete Course';

  @override
  String get cursoEliminadoOk => 'Course deleted successfully';

  @override
  String get cursoEliminadoError =>
      'Error deleting course. Check if it has active dependencies.';

  @override
  String get cursoConAlumnos =>
      'Cannot delete a course that has enrolled students.';

  @override
  String cursoConfirmarEliminar(String codigo) {
    return 'Are you sure you want to delete course $codigo? This will also delete associated subjects and schedule.';
  }

  @override
  String matriculacionTitulo(int count) {
    return 'Student Enrollment ($count)';
  }

  @override
  String get buscarAlumnos => 'Search students by name...';

  @override
  String get incidenciasTitulo => 'Incidents';

  @override
  String get incidenciasAbiertaDesc => 'New incident pending review';

  @override
  String get incidenciasCerradaDesc => 'Incident resolved and archived';

  @override
  String get incidenciasCursoGrupo => 'COURSE/GROUP';

  @override
  String get incidenciasDescripcionHechos => 'DESCRIPTION OF EVENTS';

  @override
  String get incidenciasAlumnoLabel => 'STUDENT';

  @override
  String get incidenciasProfesorResponsable => 'RESPONSIBLE TEACHER';

  @override
  String get incidenciasEsValida => 'IS VALID';

  @override
  String get incidenciasEnProcesoDesc =>
      'Disciplinary measures are being taken';

  @override
  String get incidenciasSistemaLimpio =>
      'The system is clean for the selected filters';

  @override
  String get incidenciaNueva => 'New Incident';

  @override
  String get horarioTitulo => 'Schedule';

  @override
  String get planEstudiosTitulo => 'Study Plans';

  @override
  String get alumnosTituloTeacher => 'My Students';

  @override
  String get fichaAlumnoTitulo => 'Student Record';

  @override
  String get ajustesTitulo => 'Settings';

  @override
  String get idioma => 'Language';

  @override
  String get tema => 'Theme';

  @override
  String get temaClaroOscuro => 'Light / Dark';

  @override
  String get sinAlumnos => 'No students in this course';

  @override
  String get sinProfesores => 'No teachers registered';

  @override
  String get sinIncidencias => 'No incidents recorded';

  @override
  String get confirmarEliminar => 'Confirm deletion';

  @override
  String get accionNoDeshacer => 'This action cannot be undone.';

  @override
  String get errorConexion => 'Connection error';

  @override
  String get reintentarBoton => 'Retry';

  @override
  String get horarioAlumno => 'Student Schedule';

  @override
  String get horarioMio => 'My School Schedule';

  @override
  String get horarioProfesor => 'Teacher Schedule';

  @override
  String get horarioAlumnoSubtitulo => 'Viewing student weekly plan.';

  @override
  String get horarioAlumnoSubtituloPropio => 'View your full weekly plan.';

  @override
  String get horarioProfesorSubtitulo => 'Manage weekly sessions and events.';

  @override
  String get horarioDescanso => 'BREAK';

  @override
  String get horarioEventosAsignacion => 'Event & Exam Assignment';

  @override
  String get horarioTipoEvento => 'Event Type';

  @override
  String get horarioFecha => 'Date';

  @override
  String get horarioDescripcionLabel => 'Description';

  @override
  String get horarioFechaPlaceholder => 'Select Date';

  @override
  String get horarioDescPlaceholder => 'E.g. Final Exam DAW';

  @override
  String get horarioEventoAniadido => 'Event added successfully';

  @override
  String get horarioSinClases => 'No classes scheduled.';

  @override
  String horarioErrorCargar(Object error) {
    return 'Error loading schedule: $error';
  }

  @override
  String horarioAsignarEvento(String fecha) {
    return 'Assign Event: $fecha';
  }

  @override
  String horarioEventosDia(String fecha) {
    return 'Events: $fecha';
  }

  @override
  String get horarioSinEventos => 'No events assigned.';

  @override
  String get horarioDescripcionEvento => 'Event Description';

  @override
  String get horarioAulaDefault => 'Room 101';

  @override
  String get fichaVolverAlumnos => 'Back to students';

  @override
  String get fichaSinGrupo => 'No group';

  @override
  String get fichaTelefono => 'Phone';

  @override
  String get fichaNoEspecificado => 'Not specified';

  @override
  String get fichaDireccion => 'Address';

  @override
  String get fichaSinDireccion => 'No address';

  @override
  String get fichaEstadisticasAsistencia => 'Attendance Statistics';

  @override
  String get fichaDesgloseModulo => 'Breakdown by Module';

  @override
  String get fichaSinDatosModulo => 'No module data recorded.';

  @override
  String get fichaAsistencia => 'Attendance';

  @override
  String get fichaFaltas => 'Absences';

  @override
  String get fichaRetrasos => 'Delays';

  @override
  String get fichaJustificadas => 'Excused';

  @override
  String get fichaTotalClases => 'Total Classes';

  @override
  String get fichaHorasFaltadas => 'Hours Missed';

  @override
  String get fichaRiesgo => 'RISK';

  @override
  String get fichaLimiteExcedido => 'LIMIT EXCEEDED';

  @override
  String fichaFaltasDetalle(String total, int max) {
    return 'Absences: $total / $max max.';
  }

  @override
  String fichaAsistencias(int presentes, int total) {
    return '$presentes/$total attended';
  }

  @override
  String get fichaVerHorario => 'View Full Schedule';

  @override
  String get fichaCrearIncidencia => 'Create Incident';

  @override
  String fichaHorarioDe(String nombre) {
    return 'Schedule of $nombre';
  }

  @override
  String get fichaRegistroAsistencia => 'Attendance Record';

  @override
  String fichaFaltasDe(String nombre) {
    return 'Absences of $nombre';
  }

  @override
  String fichaRetrasosDe(String nombre) {
    return 'Delays of $nombre';
  }

  @override
  String fichaJustificadasDe(String nombre) {
    return 'Excused absences of $nombre';
  }

  @override
  String fichaErrorHistorial(Object error) {
    return 'Error loading history: $error';
  }

  @override
  String get fichaSinRegistros => 'No records of this type.';

  @override
  String fichaRegistradoPor(String nombre) {
    return 'Recorded by: $nombre';
  }

  @override
  String get fichaSinFecha => 'No date';

  @override
  String get alumnosTituloDesc =>
      'Centralised management of academic records and attendance';

  @override
  String get matricularAlumno => 'Enrol Student';

  @override
  String get todosCursos => 'All Courses';

  @override
  String get sinAlumnosEncontrados => 'No students found';

  @override
  String get confirmarBaja => 'Confirm Deactivation';

  @override
  String get activarAlumno => 'Activate Student';

  @override
  String get darDeBaja => 'Deactivate';

  @override
  String get reporteAsistenciaLabel => 'Attendance Report';

  @override
  String get editarExpediente => 'Edit Record';

  @override
  String get profesoresTituloDesc =>
      'Comprehensive management of teaching staff and administration';

  @override
  String get registrarNuevoProfesor => 'Register New';

  @override
  String get buscarProfesoresHint => 'Search teachers...';

  @override
  String get buscarProfesoresDetalle =>
      'Search by name, speciality or department...';

  @override
  String get filtrarPorCurso => 'Filter by course...';

  @override
  String get filtrarPorRol => 'Filter by role...';

  @override
  String get todosRoles => 'All Roles';

  @override
  String get docenteLabel => 'Teacher';

  @override
  String get cuerpoDocenteLabel => 'TEACHING STAFF';

  @override
  String get directivaAdminLabel => 'MANAGEMENT / ADMIN';

  @override
  String get horarioSemanalReal => 'REAL WEEKLY SCHEDULE';

  @override
  String get filtrarCursoMateria => 'Filter by course or subject...';

  @override
  String get sinClasesHorarioProfesor =>
      'No classes assigned in the weekly schedule';

  @override
  String get sinProfesoresEncontrados =>
      'No teachers found with the applied filters';

  @override
  String get gestionar => 'Manage';

  @override
  String get sesionLabel => 'SESSION';

  @override
  String get incidenciasTituloDesc =>
      'Disciplinary control, coexistence and early alerts';

  @override
  String get registrarIncidencia => 'Register Incident';

  @override
  String get actualizarEstado => 'Update Status';

  @override
  String get eliminarRegistro => 'Delete Record';

  @override
  String get incidenciaEliminadaDesc =>
      'This action is permanent and the incident information cannot be recovered.';

  @override
  String get planEstudiosTituloDesc => 'Curricular management and study plans';

  @override
  String get cursosTituloDesc => 'Group management and student enrolment';

  @override
  String get authPwdOlvidasteTitulo => 'Forgot your password?';

  @override
  String get authPwdOlvidasteDesc =>
      'Enter your email address and we will send you a recovery code.';

  @override
  String get authPwdCorreoHint => 'Email address';

  @override
  String get authPwdEnviarCodigo => 'SEND CODE';

  @override
  String get authPwdVolverLogin => 'Back to Login';

  @override
  String authPwdError(Object error) {
    return 'Error: $error';
  }

  @override
  String get authPwdNoCoinciden => 'Passwords do not match';

  @override
  String get authPwdActualizadaOk => '✅ Password updated successfully';

  @override
  String get authPwdRestablecerTitulo => 'Reset Password';

  @override
  String get authPwdRestablecerDesc =>
      'Enter the code you received and your new password.';

  @override
  String get authPwdCodigoHint => 'CODE';

  @override
  String get authPwdNuevaContrasena => 'New Password';

  @override
  String get authPwdConfirmarContrasena => 'Confirm Password';

  @override
  String get authPwdActualizar => 'UPDATE PASSWORD';

  @override
  String get authMantTitulo => 'Server Under Maintenance';

  @override
  String get authMantDesc =>
      'We are making improvements to the system.\nPlease try again in a few minutes.';

  @override
  String get authMantReintentar => 'RETRY CONNECTION';

  @override
  String get authDevAutocompletar => 'Autocomplete login (devs only)';

  @override
  String get authPwdOlvidasteLink => 'Forgot your password?';

  @override
  String get horarioEventoExamen => 'Exam';

  @override
  String get horarioEventoEvaluacion => 'Evaluation';

  @override
  String get horarioEventoPresentacion => 'Presentation';

  @override
  String get horarioEventoReunion => 'Meeting';

  @override
  String get horarioEventoFestivo => 'Holiday';

  @override
  String get horarioFechaLabel => 'Date';

  @override
  String get diaLunes => 'Monday';

  @override
  String get diaMartes => 'Tuesday';

  @override
  String get diaMiercoles => 'Wednesday';

  @override
  String get diaJueves => 'Thursday';

  @override
  String get diaViernes => 'Friday';

  @override
  String get userProfileGuardado => 'Changes saved successfully';

  @override
  String get userProfileMisDatos => 'My Data';

  @override
  String get userProfileSubtitulo =>
      'Manage your personal and professional information.';

  @override
  String get userProfileFotoActualizada => 'Photo updated successfully';

  @override
  String get userProfileInfoPersonal => 'Personal Information';

  @override
  String get userProfileNombreCompleto => 'Full Name';

  @override
  String get userProfileDniNie => 'DNI/NIE';

  @override
  String get userProfileFechaNacimiento => 'Date of Birth';

  @override
  String get userProfileInfoContacto => 'Contact Information';

  @override
  String get userProfileTelefono => 'Phone';

  @override
  String get userProfileDireccion => 'Address';

  @override
  String get userProfileSeguridad => 'Security';

  @override
  String get userProfileSeguridadDesc =>
      'Protect your account by updating your password regularly.';

  @override
  String get userProfileCambiarPassword => 'Change Password';

  @override
  String studentAsisError(Object error) {
    return 'Error: $error';
  }

  @override
  String get studentAsisDesconocido => 'Unknown';

  @override
  String studentAsisFaltas(Object max, Object total) {
    return 'Absences: $total / $max max';
  }

  @override
  String studentAsisClasesAbrev(Object clases, Object horas) {
    return '$clases/$horas cl.';
  }

  @override
  String studentAsisClases(Object clases, Object horas) {
    return '$clases/$horas classes';
  }

  @override
  String get studentAsisProgresoClases => 'Class Progress';

  @override
  String get studentFichaDatosDesc =>
      'Personal and academic data of your enrollment';

  @override
  String get studentFichaRolAlumno => 'STUDENT';

  @override
  String get studentFichaDatosPersonales => 'Personal Data';

  @override
  String get studentFichaDniNie => 'DNI / NIE';

  @override
  String get studentFichaTelefono => 'Phone';

  @override
  String get studentFichaDireccion => 'Address';

  @override
  String get studentFichaFechaNacimiento => 'Date of Birth';

  @override
  String get studentFichaDatosAcademicos => 'Academic Data';

  @override
  String get studentFichaGrupo => 'Group';

  @override
  String get studentFichaEstadoMatricula => 'Enrollment Status';

  @override
  String get studentFichaMateriasMatriculadas => 'Enrolled Subjects';

  @override
  String studentFichaModulos(Object count) {
    return '$count modules';
  }

  @override
  String get studentFichaMatriculado => 'ENROLLED';

  @override
  String get studentFichaAlumno => 'Student';

  @override
  String get studentFichaOfflineDesc => 'Offline. Showing basic profile data.';

  @override
  String get teacherAlumnosAnterior => 'Previous';

  @override
  String get teacherAlumnosSiguiente => 'Next';

  @override
  String get teacherAlumnosSinGrupo => 'No group';

  @override
  String get teacherAlumnosAsistencia => 'Attendance';

  @override
  String get teacherAlumnosFaltas => 'Absences';

  @override
  String get teacherSettingsSubtitulo =>
      'Customize your experience on the GAULA platform';

  @override
  String get teacherSettingsPerfilUsuario => 'User Profile';

  @override
  String get teacherSettingsPerfilDesc => 'Manage your personal information';

  @override
  String get teacherSettingsVerPerfil => 'View Profile';

  @override
  String get teacherSettingsEditarPerfil => 'Edit Profile';

  @override
  String get teacherSettingsSeguridad => 'Security';

  @override
  String get teacherSettingsSeguridadDesc => 'Protect your system access';

  @override
  String get teacherSettingsCambiarPass => 'Change Password';

  @override
  String get teacherSettingsSesionesActivas => 'Active Sessions';

  @override
  String get teacherSettingsSeguridadProximamente =>
      'Security functionality coming soon';

  @override
  String get teacherSettingsNotificaciones => 'Notifications';

  @override
  String get teacherSettingsNotificacionesDesc =>
      'Configure alerts and notifications';

  @override
  String get teacherSettingsAlertasAsistencia => 'Attendance Alerts';

  @override
  String get teacherSettingsMensajesAlumnos => 'Student Messages';

  @override
  String get teacherSettingsPreferencias => 'Preferences';

  @override
  String get teacherSettingsPreferenciasDesc => 'Display settings';

  @override
  String get teacherSettingsSoporte => 'Support & Help';

  @override
  String get teacherSettingsSoporteDesc => 'Support resources';

  @override
  String get teacherSettingsNormasCentro => 'School Rules';

  @override
  String get teacherSettingsContactarSoporte => 'Contact Support';

  @override
  String get teacherSettingsContactandoSoporte =>
      'Contacting technical support...';

  @override
  String get teacherSettingsVersion => 'GAULA • Developed by VicePresi';

  @override
  String get teacherSettingsCopyright => '© 2026 Educational Management System';

  @override
  String get teacherSettingsNotifPush => 'Push Notifications';

  @override
  String get teacherSettingsNotifEmail => 'Email Notifications';

  @override
  String adminDashErrorMetricas(String error) {
    return 'Error loading metrics: $error';
  }

  @override
  String get adminDashDocentes => 'Teachers';

  @override
  String get adminDashTrendEstable => 'Stable';

  @override
  String get adminUsuariosErrorRedTitulo => 'Network error';

  @override
  String get adminUsuariosErrorRedMsg => 'Could not connect to the server';

  @override
  String get adminUsuariosTitulo => 'User Management';

  @override
  String get adminUsuariosMonitorTiempoReal => 'REAL-TIME MONITOR';

  @override
  String get adminUsuariosTotal => 'Total';

  @override
  String get adminUsuariosRol => 'Role...';

  @override
  String get adminUsuariosEstado => 'Status...';

  @override
  String get attendanceScheduleMyClasses => 'My Classes';

  @override
  String get attendanceScheduleOtherClass =>
      'Take Attendance for Another Class';

  @override
  String get attendanceScheduleTodaySchedule => 'Today\'s Schedule';

  @override
  String attendanceSchedulePendingClasses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pending classes',
      one: 'pending class',
    );
    return 'You have $count $_temp0 to take attendance';
  }

  @override
  String get attendanceScheduleNoClassesToday =>
      'No classes scheduled for today.';

  @override
  String get attendanceScheduleHistory => 'History';

  @override
  String get attendanceScheduleSearchByDate => 'Search by date...';

  @override
  String get attendanceScheduleNoHistory => 'No attendance history.';

  @override
  String get attendanceScheduleTakeAttendance => 'Take Attendance';

  @override
  String get attendanceScheduleCompleted => 'Completed';

  @override
  String get attendanceScheduleSelectCourse => 'Select Course';

  @override
  String get attendanceScheduleSelectCourseHint =>
      'Select a course to see its subjects available today.';

  @override
  String get attendanceScheduleSearchCourse => 'Search by name or code...';

  @override
  String attendanceScheduleErrorLoadingYears(String error) {
    return 'Error loading years: $error';
  }

  @override
  String get attendanceScheduleNoCourses => 'No courses found.';

  @override
  String get attendanceScheduleSelectSubjectHint =>
      'Select the subject to see its sessions.';

  @override
  String get attendanceScheduleNoSubjects => 'No subjects in this course.';

  @override
  String get attendanceScheduleSubjectFallback => 'Subject';

  @override
  String get attendanceScheduleSelectSessionHint =>
      'Select the exact session to take attendance.';

  @override
  String get attendanceScheduleNoSessionsToday => 'No sessions for today.';

  @override
  String get attendanceScheduleSessionsFallback => 'Sessions';

  @override
  String get attendanceScheduleAulaFallback => 'Classroom';

  @override
  String get attendanceDetailRegisteredBy => 'REGISTERED BY:';

  @override
  String get attendanceDetailSystemAuto => 'SYSTEM / AUTOMATIC';

  @override
  String get attendanceDetailPresent => 'PRESENT';

  @override
  String get attendanceDetailAbsent => 'ABSENT';

  @override
  String get attendanceDetailAttendance => 'ATTENDANCE';

  @override
  String get attendanceDetailStudentList => 'PENALTY LIST';

  @override
  String get attendanceDetailNoRecords =>
      'No attendance records for this session.';

  @override
  String get attendanceDetailStudentFallback => 'Student';

  @override
  String get attendanceDetailStatusPresente => 'PRESENT';

  @override
  String get attendanceDetailStatusAusente => 'ABSENT';

  @override
  String get attendanceDetailStatusRetraso => 'LATE';

  @override
  String get attendanceDetailStatusJustificado => 'EXCUSED';

  @override
  String get attendanceDetailStatusPendiente => 'PENDING';

  @override
  String get adminAuditoriaTitle => 'Audit Log';

  @override
  String get adminAuditoriaSubtitle =>
      'Full traceability of administrative actions';

  @override
  String get adminAuditoriaEmpty => 'NO ACTIVITY RECORDS';

  @override
  String get adminConfigTitle => 'CONFIGURATION';

  @override
  String get adminConfigSubtitle => 'Manage global parameters and maintenance';

  @override
  String get adminConfigSecurityTitle => 'Security & Access';

  @override
  String get adminConfigSecurityDesc => 'Credentials and sessions control';

  @override
  String get adminConfigSecurityChangePassword => 'Change Password';

  @override
  String get adminConfigSecurityActiveSessions => 'Active Sessions';

  @override
  String get adminConfigSecurity2FA => 'Two-Factor (2FA)';

  @override
  String get adminConfigReglamentoTitle => 'School Rules';

  @override
  String get adminConfigReglamentoDesc => 'School regulations and coexistence';

  @override
  String get adminConfigReglamentoEdit => 'Edit Rules';

  @override
  String get adminConfigReglamentoHistory => 'Version History';

  @override
  String get adminConfigReglamentoPublish => 'Publish Changes';

  @override
  String get adminConfigAuditoriaTitle => 'Change Audit';

  @override
  String get adminConfigAuditoriaDesc => 'Administrative activity log';

  @override
  String get adminConfigAuditoriaViewLog => 'View Activity Log';

  @override
  String get adminConfigAuditoriaExport => 'Export Report';

  @override
  String get adminConfigAuditoriaAlerts => 'Audit Alerts';

  @override
  String get adminConfigComingSoon => 'COMING SOON';

  @override
  String get adminPermTitle => 'RBAC Matrix';

  @override
  String get adminPermSubtitle => 'Granular security and access control';

  @override
  String get adminPermSyncButton => 'SYNC POLICIES';

  @override
  String get adminPermColRolPerfil => 'ROLE / PROFILE';

  @override
  String get adminPermPermGestionAcademica => 'Academic Management';

  @override
  String get adminPermPermPasarLista => 'Take Attendance';

  @override
  String get adminPermPermVerHistorial => 'View History';

  @override
  String get adminPermPermCrearIncidencias => 'Create Incidents';

  @override
  String get adminPermPermBorrarRegistros => 'Delete Records';

  @override
  String get adminPermPermConfigurarSistema => 'Configure System';

  @override
  String get adminPermPermEditarPerfiles => 'Edit Profiles';

  @override
  String get adminPermPermExportarDatos => 'Export Data';

  @override
  String get adminPermToastSyncTitle => 'Matrix Synchronized';

  @override
  String get adminPermToastSyncMessage =>
      'Global permissions have been updated.';

  @override
  String get adminPermToastErrorTitle => 'Error';

  @override
  String get adminPermToastErrorMessage => 'Could not save the configuration.';

  @override
  String adminPermErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get adminRolesTitle => 'Role Management';

  @override
  String get adminRolesSubtitle => 'Profile and system hierarchy configuration';

  @override
  String get adminRolesSaveButton => 'SAVE CHANGES';

  @override
  String get adminRolesBadgeSystem => 'SYSTEM';

  @override
  String get adminRolesNewProfileTitle => 'New Profile';

  @override
  String get adminRolesNewProfileDesc =>
      'Define a new role for user management.';

  @override
  String get adminRolesFieldLabel => 'ROLE NAME';

  @override
  String get adminRolesAddButton => 'ADD ROLE';

  @override
  String get adminRolesInfoBox =>
      'Assign permissions in the Matrix after creating the role.';

  @override
  String get adminRolesToastSuccessTitle => 'Success';

  @override
  String get adminRolesToastSuccessMessage => 'Role list updated successfully.';

  @override
  String get adminRolesToastErrorTitle => 'Error';

  @override
  String get adminRolesToastErrorMessage => 'Could not save the configuration.';

  @override
  String adminRolesErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get adminAnioTitulo => 'Academic Years';

  @override
  String get adminAnioSubtitulo => 'Manage the school\'s academic periods.';

  @override
  String get adminAnioNuevo => 'New Year';

  @override
  String get adminAnioActivo => 'ACTIVE';

  @override
  String adminAnioCursos(int n) {
    return '$n courses';
  }

  @override
  String adminAnioMiembros(int n) {
    return '$n members';
  }

  @override
  String get adminAnioDesactivar => 'Deactivate';

  @override
  String get adminAnioActivar => 'Activate';

  @override
  String get adminAnioEliminar => 'Delete';

  @override
  String get adminAnioTooltipDesactivar => 'Deactivate';

  @override
  String get adminAnioTooltipActivar => 'Activate';

  @override
  String get adminAnioTooltipEditar => 'Edit';

  @override
  String get adminAnioTooltipEliminar => 'Delete';

  @override
  String get adminAnioTooltipNoEliminarActivo =>
      'Cannot delete the active year';

  @override
  String get adminAnioTooltipNoEliminarAlumnos =>
      'Cannot delete (has students)';

  @override
  String adminAnioErrorCargar(Object e) {
    return 'Error loading data: $e';
  }

  @override
  String get adminAnioReintentar => 'Retry';

  @override
  String get adminAnioVacio => 'No academic years registered.';

  @override
  String get adminAnioCrearPrimero => 'Create the first';

  @override
  String get adminAnioDialogNuevo => 'New Academic Year';

  @override
  String get adminAnioDialogEditar => 'Edit Academic Year';

  @override
  String get adminAnioNombrePeriodo => 'Period name';

  @override
  String get adminAnioNombreHint => 'E.g. 2025-2026';

  @override
  String get adminAnioNombreObligatorio => 'Required field';

  @override
  String get adminAnioFechaInicio => 'Start date';

  @override
  String get adminAnioFechaFin => 'End date';

  @override
  String get adminAnioSeleccionar => 'Select';

  @override
  String get adminAnioDescripcion => 'Description (optional)';

  @override
  String get adminAnioDescripcionHint => 'Brief period description';

  @override
  String get adminAnioCancelar => 'Cancel';

  @override
  String get adminAnioGuardarCambios => 'Save Changes';

  @override
  String get adminAnioCrearAnio => 'Create Year';

  @override
  String get adminAnioDesactivarTitulo => 'Deactivate Academic Year';

  @override
  String adminAnioDesactivarMensaje(String nombre) {
    return 'Are you sure you want to deactivate \"$nombre\"? It will switch to historical mode.';
  }

  @override
  String get adminAnioActivarTitulo => 'Activate Academic Year';

  @override
  String adminAnioActivarMensaje(String nombre) {
    return 'Are you sure you want to activate \"$nombre\"? The currently active year will switch to historical mode.';
  }

  @override
  String get adminAnioEliminarTitulo => 'Delete Academic Year';

  @override
  String adminAnioEliminarMensaje(String nombre) {
    return 'Delete \"$nombre\" permanently? This action cannot be undone.';
  }

  @override
  String get adminAnioSnackDesactivado => 'Year deactivated';

  @override
  String get adminAnioSnackActivado => 'Year activated';

  @override
  String get adminAnioSnackEliminado => 'Year deleted';

  @override
  String get adminAnioSnackGuardado => 'Year saved successfully';

  @override
  String get adminAnioSnackErrorGuardar => 'Error saving';

  @override
  String get adminAnioSnackNoEliminarActivo => 'Cannot delete the active year.';

  @override
  String adminAnioDuplicado(String nombre) {
    return 'An academic year with the name \"$nombre\" already exists.';
  }

  @override
  String get adminAnioSeleccionarFechas => 'Select the start and end dates.';

  @override
  String get adminAnioErrorConexion => 'Connection error';

  @override
  String get adminHorarioTitulo => 'Calendar';

  @override
  String get adminHorarioTituloDesktop => 'Events Calendar';

  @override
  String get adminHorarioSubtitulo => 'Academic planning and school reminders';

  @override
  String get adminHorarioNuevoEvento => 'NEW EVENT';

  @override
  String get adminHorarioEventosDia => 'Day Events';

  @override
  String get adminHorarioSinEventos => 'No events for today';

  @override
  String get adminHorarioProgramarEvento => 'Schedule Holiday';

  @override
  String get adminHorarioTituloEvento => 'Holiday Title';

  @override
  String get adminHorarioTipo => 'Type';

  @override
  String get adminHorarioCancelar => 'CANCEL';

  @override
  String get adminHorarioGuardar => 'SAVE';

  @override
  String get adminHorarioEliminadoTitulo => 'Deleted';

  @override
  String get adminHorarioEliminadoMensaje => 'The event has been deleted.';

  @override
  String get adminHorarioErrorTitulo => 'Error';

  @override
  String get adminReglamentoTitulo => 'Rules';

  @override
  String get adminReglamentoSubtitulo =>
      'Version management and legal validity';

  @override
  String get adminReglamentoHistorialTitulo => 'Regulatory History';

  @override
  String get adminReglamentoHistorialSubtitulo =>
      'Version management and legal validity';

  @override
  String get adminReglamentoHistorialBtn => 'History';

  @override
  String get adminReglamentoNuevaVersion => 'NEW VERSION';

  @override
  String get adminReglamentoPublicar => 'PUBLISH CHANGES';

  @override
  String get adminReglamentoVersionHint => 'Version Name...';

  @override
  String get adminReglamentoVersionActivaLabel => 'ACTIVE VERSION';

  @override
  String get adminReglamentoActivoBadge => 'ACTIVE';

  @override
  String get adminReglamentoEditorPlaceholder =>
      'Start drafting the school regulations...';

  @override
  String get adminReglamentoNuevaBorrador => 'New draft version';

  @override
  String adminReglamentoModificandoVersion(String fecha) {
    return 'Modifying version from $fecha';
  }

  @override
  String get adminReglamentoErrorTitulo => 'Error';

  @override
  String get adminReglamentoExitoTitulo => 'Success';

  @override
  String get adminReglamentoVersionRequerida => 'Version name required';

  @override
  String get adminReglamentoGuardadoOk => 'Rules saved and synchronized';

  @override
  String adminReglamentoFalloGuardar(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get adminReglamentoErrorCargar => 'Error loading history';

  @override
  String get adminHistorialTitulo => 'History';

  @override
  String get adminHistorialSubtitulo => 'Global records audit';

  @override
  String get adminHistorialTituloDesktop => 'Attendance History';

  @override
  String get adminHistorialSubtituloDesktop =>
      'Global audit of class records and absenteeism';

  @override
  String get adminHistorialBuscarHint => 'Search subject or teacher...';

  @override
  String get adminHistorialCualquierFecha => 'Any date';

  @override
  String get adminHistorialCursoLabel => 'COURSE';

  @override
  String get adminHistorialGrupoHint => 'Group';

  @override
  String get adminHistorialTodos => 'All';

  @override
  String get adminHistorialTodosGrupos => 'All groups';

  @override
  String get adminHistorialSinRegistros => 'NO RECORDS TO SHOW';

  @override
  String get adminHistorialSinDocente => 'No teacher';

  @override
  String adminHistorialAlumnos(int attended, int total) {
    return '$attended/$total STUDENTS';
  }

  @override
  String get adminProgramConfigTitulo => 'Program Configuration';

  @override
  String get adminProgramConfigSubtitulo =>
      'Institutional policies, user roles and global center parameter management';

  @override
  String get adminProgramConfigRolesTitulo => 'Roles and Permissions Matrix';

  @override
  String get adminProgramConfigRolesDesc =>
      'Granular control over each profile\'s capabilities';

  @override
  String get adminProgramConfigMatrizPermisos => 'Permissions Matrix';

  @override
  String get adminProgramConfigMatrizPermisosDesc =>
      'Privilege map for each system role';

  @override
  String get adminProgramConfigGestionRoles => 'Role Management';

  @override
  String get adminProgramConfigGestionRolesDesc =>
      'Add, edit or delete user labels';

  @override
  String get adminProgramConfigCalendarioTitulo => 'Institutional Calendar';

  @override
  String get adminProgramConfigCalendarioDesc =>
      'Configuration of holidays and regional events';

  @override
  String get adminProgramConfigFestivos => 'Holiday Calendar';

  @override
  String get adminProgramConfigFestivosDesc =>
      'Manage non-school days and bridges';

  @override
  String get adminProgramConfigEventosCentro => 'School Events';

  @override
  String get adminProgramConfigEventosCentroDesc =>
      'Graduations, faculty meetings and school festivities';

  @override
  String get adminProgramConfigReglamentoTitulo => 'Rules of Conduct';

  @override
  String get adminProgramConfigReglamentoDesc =>
      'School behavior rules and guidelines';

  @override
  String get adminProgramConfigVerEditarReglamento => 'View / Edit Rules';

  @override
  String get adminProgramConfigVerEditarReglamentoDesc =>
      'Detailed management of rules, rights and duties';

  @override
  String get adminProgramConfigMantenimientoTitulo => 'System Maintenance';

  @override
  String get adminProgramConfigMantenimientoDesc =>
      'Technical parameters and activity logs';

  @override
  String get adminProgramConfigAuditoria => 'Change Audit';

  @override
  String get adminProgramConfigAuditoriaDesc =>
      'View administrative changes history';

  @override
  String get adminProgramConfigLimpieza => 'Cleanup of Temporaries';

  @override
  String get adminProgramConfigLimpiezaDesc =>
      'Purge unreferenced uploaded files';

  @override
  String get adminProgramConfigUsuarios => 'User Management';

  @override
  String get adminProgramConfigUsuariosDesc =>
      'IP, sessions and account activity control';

  @override
  String get adminProgramConfigEnDesarrolloTitulo =>
      'Functionality in Development';

  @override
  String get adminProgramConfigEnDesarrolloDesc =>
      'This feature will be available in the next GAULA system update.';

  @override
  String get adminProgramConfigEntendido => 'UNDERSTOOD';

  @override
  String get adminProgramConfigEnDesarrolloBadge => 'IN DEVELOPMENT';

  @override
  String get addAlumnoEditTitle => 'Edit Student';

  @override
  String get addAlumnoAddTitle => 'Add New Student';

  @override
  String get addAlumnoEditSubtitle => 'Modify the student\'s data';

  @override
  String get addAlumnoAddSubtitle => 'Complete the information for enrollment';

  @override
  String get addAlumnoSectionPersonal => 'PERSONAL INFORMATION';

  @override
  String get addAlumnoFieldNombre => 'First Name *';

  @override
  String get addAlumnoHintNombre => 'E.g.: John';

  @override
  String get addAlumnoFieldApellidos => 'Last Name *';

  @override
  String get addAlumnoHintApellidos => 'E.g.: García López';

  @override
  String get addAlumnoFieldDni => 'DNI/NIE';

  @override
  String get addAlumnoSectionContacto => 'CONTACT & ENROLLMENT';

  @override
  String get addAlumnoFieldEmail => 'Email *';

  @override
  String get addAlumnoHintEmail => 'student@gaula.edu';

  @override
  String get addAlumnoFieldUsuario => 'Username (Optional)';

  @override
  String get addAlumnoHintUsuario => 'john.doe';

  @override
  String get addAlumnoFieldPassword => 'Password *';

  @override
  String get addAlumnoHintPassword => 'Min. 6 chars.';

  @override
  String get addAlumnoFieldTelefono => 'Phone';

  @override
  String get addAlumnoHintTelefono => '+34 600...';

  @override
  String get addAlumnoFieldDireccion => 'Address';

  @override
  String get addAlumnoHintDireccion => 'Main Street, 123, Barcelona';

  @override
  String get addAlumnoSectionMaterias => 'SUBJECTS (ENROLLMENT)';

  @override
  String get addAlumnoButtonGuardar => 'Save Changes';

  @override
  String get addAlumnoButtonRegistrar => 'Register Student';

  @override
  String get addAlumnoButtonCancelar => 'Cancel';

  @override
  String get addAlumnoFieldFechaNacimiento => 'Date of Birth';

  @override
  String get addAlumnoSeleccionarFecha => 'Select...';

  @override
  String get addAlumnoSuccessRegistrado => 'Student registered successfully';

  @override
  String get addAlumnoErrorRegistrar => 'Error registering student';

  @override
  String get addAlumnoCampoObligatorio => 'Required field';

  @override
  String get addIncidenciaTitulo => 'New Incident';

  @override
  String get addIncidenciaFieldTitulo => 'Title';

  @override
  String get addIncidenciaHintTitulo => 'E.g.: Disruptive behavior';

  @override
  String get addIncidenciaFieldAlumno => 'Student';

  @override
  String get addIncidenciaSelectAlumno => 'Select student';

  @override
  String get addIncidenciaErrorAlumnos => 'Error loading students';

  @override
  String get addIncidenciaFieldProfesor => 'Reporting teacher';

  @override
  String get addIncidenciaSelectProfesor => 'Select teacher';

  @override
  String get addIncidenciaErrorProfesores => 'Error loading teachers';

  @override
  String get addIncidenciaFieldGravedad => 'Severity';

  @override
  String get addIncidenciaHintGravedad => 'Severity level';

  @override
  String get addIncidenciaFieldDescripcion => 'Detailed description';

  @override
  String get addIncidenciaHintDescripcion => 'Details of what happened...';

  @override
  String get addIncidenciaButtonCrear => 'Create Incident';

  @override
  String get addIncidenciaButtonCancelar => 'Cancel';

  @override
  String get addIncidenciaValidacionSeleccion =>
      'Please select student and teacher';

  @override
  String get addIncidenciaSuccessCreada => 'Incident created successfully';

  @override
  String get addIncidenciaErrorCrear => 'Error creating incident';

  @override
  String get addIncidenciaCampoObligatorio => 'Required field';

  @override
  String get addIncidenciaBuscar => 'Search...';

  @override
  String get addIncidenciaNoResultados => 'No results found';

  @override
  String get addProfesorEditTitle => 'Edit Teacher';

  @override
  String get addProfesorAddTitle => 'Add Teacher';

  @override
  String get addProfesorEditSubtitle => 'Modify accesses';

  @override
  String get addProfesorAddSubtitle =>
      'Create a new administrative or teaching user';

  @override
  String get addProfesorFieldNombre => 'First Name *';

  @override
  String get addProfesorHintNombre => 'E.g.: Roberto';

  @override
  String get addProfesorFieldApellidos => 'Last Name *';

  @override
  String get addProfesorHintApellidos => 'E.g.: Sánchez Domínguez';

  @override
  String get addProfesorFieldEmail => 'Email *';

  @override
  String get addProfesorHintEmail => 'example@gaula.edu';

  @override
  String get addProfesorFieldEspecialidades => 'Specialties';

  @override
  String get addProfesorHintEspecialidades =>
      'E.g.: Computer Science, Programming';

  @override
  String get addProfesorFieldRol => 'User Role *';

  @override
  String get addProfesorRolDocente => 'Teacher';

  @override
  String get addProfesorRolAdmin => 'Administrator';

  @override
  String get addProfesorButtonGuardar => 'Save Changes';

  @override
  String get addProfesorButtonRegistrar => 'Register Teacher';

  @override
  String get addProfesorButtonCancelar => 'Cancel';

  @override
  String get addProfesorSuccessActualizado => 'Data updated';

  @override
  String get addProfesorSuccessRegistrado => 'Teacher registered';

  @override
  String get addProfesorCampoObligatorio => 'Required field';

  @override
  String get addProfesorEmailInvalido => 'Invalid email format';

  @override
  String adminCursoHorarioTitulo(String codigoGrupo) {
    return 'Weekly Schedule: $codigoGrupo';
  }

  @override
  String get adminCursoHorarioGeneradoTitle => 'Generated';

  @override
  String get adminCursoHorarioGeneradoMsg => 'Schedule generated automatically';

  @override
  String get adminCursoHorarioErrorTitle => 'Error';

  @override
  String get adminCursoHorarioButtonGenerar => 'Generate Automatically';

  @override
  String get adminCursoHorarioButtonAsignar => 'Assign Module';

  @override
  String get adminCursoHorarioRecreo => 'BREAK';

  @override
  String adminCursoHorarioErrorCargar(String error) {
    return 'Error loading schedule: $error';
  }

  @override
  String get adminCursoHorarioDesconocido => 'Unknown';

  @override
  String get adminCursoHorarioEliminadoTitle => 'Deleted';

  @override
  String get adminCursoHorarioEliminadoMsg => 'Session deleted successfully';

  @override
  String get adminCursoHorarioErrorAsignar => 'Error assigning';

  @override
  String get adminCursoHorarioAsignadoTitle => 'Assigned';

  @override
  String get adminCursoHorarioAsignadoMsg => 'Session assigned successfully';

  @override
  String adminCursoHorarioElegirColor(String nombre) {
    return 'Choose Color: $nombre';
  }

  @override
  String get adminCursoHorarioNoProfesores => 'No teachers available';

  @override
  String get adminCursoHorarioDia => 'Day';

  @override
  String get adminCursoHorarioHoraInicio => 'Start Time';

  @override
  String get adminCursoHorarioModuloMateria => 'Module / Subject';

  @override
  String get adminCursoHorarioSeleccionarModulo => 'Select module';

  @override
  String get adminCursoHorarioNoMaterias => 'No subjects in the course';

  @override
  String get adminCursoHorarioProfesorAsignado => 'Assigned Teacher';

  @override
  String get adminCursoHorarioBuscarProfesor => 'Search teacher...';

  @override
  String adminCursoHorarioSoloLibres(String hora) {
    return 'Only free at $hora';
  }

  @override
  String get adminCursoHorarioErrorProfesores => 'Error loading teachers';

  @override
  String get adminCursoHorarioLibre => 'Free';

  @override
  String get adminCursoHorarioOcupado => 'Occupied';

  @override
  String get adminCursoHorarioCancelar => 'Cancel';

  @override
  String get adminCursoHorarioAsignarButton => 'Assign';

  @override
  String adminPlanEstudiosConfirmarEliminarMateria(String nombre) {
    return 'Are you sure you want to delete the subject \"$nombre\"? This action cannot be undone.';
  }

  @override
  String get adminPlanEstudiosErrorEliminarMateria => 'Error deleting subject.';

  @override
  String get adminPlanEstudiosConfirmarEliminarPlantilla =>
      'Are you sure you want to delete this template? This action cannot be undone.';

  @override
  String adminPlanEstudiosMateriaCount(int count) {
    return '$count subjects';
  }

  @override
  String get adminPlanEstudiosModulosYProyectos => 'Modules and Projects';

  @override
  String adminPlanEstudiosTipoCodigoLabel(String tipo, String codigo) {
    return '$tipo — Code: $codigo';
  }

  @override
  String get adminPlanEstudiosEditarPlan => 'Edit Study Plan';

  @override
  String get adminPlanEstudiosCrearPlan => 'Create Study Plan';

  @override
  String get adminPlanEstudiosNombreCurso => 'Course Name';

  @override
  String get adminPlanEstudiosNombreCursoHint =>
      'e.g. Cross-platform Application Development';

  @override
  String get adminPlanEstudiosCodigo => 'Code';

  @override
  String get adminPlanEstudiosaCodigoHint => 'e.g. DAM';

  @override
  String get adminPlanEstudiosDescripcion => 'Description (optional)';

  @override
  String get adminPlanEstudiosDescripcionHint => 'Brief course description';

  @override
  String get adminPlanEstudiosColorPlantilla => 'Template Color';

  @override
  String get adminPlanEstudiosSeleccionarColor => 'Select a color';

  @override
  String get adminPlanEstudiosAniadirMateria => 'Add subject';

  @override
  String get adminPlanEstudiosEditarMateria => 'Edit subject';

  @override
  String get adminPlanEstudiosNombreMateria => 'Name';

  @override
  String get adminPlanEstudiosNombreMateriaHint => 'e.g. Programming';

  @override
  String get adminPlanEstudiosTipoMateria => 'Subject Type';

  @override
  String get adminPlanEstudiosHoras => 'Hours';

  @override
  String get adminPlanEstudiosMateriasAniadidas => 'Added subjects:';

  @override
  String adminAlumnosConfirmarDesactivar(String nombre) {
    return 'Are you sure you want to deactivate $nombre\'s record?';
  }

  @override
  String adminAlumnosConfirmarActivar(String nombre) {
    return 'Are you sure you want to activate $nombre\'s record?';
  }

  @override
  String get adminPlanEstudiosTipoProyecto => 'Project';

  @override
  String get adminPlanEstudiosTipoAsignatura => 'Subject';

  @override
  String get adminPlanEstudiosTipoModulo => 'Module';

  @override
  String get adminProfesoresRolLabel => 'Role';

  @override
  String get adminProfesoresDesconocido => 'Unknown';

  @override
  String adminProfesoresCursoLabel(String cursoId) {
    return 'Course: $cursoId';
  }

  @override
  String get procesandoExportacion => 'PROCESSING EXPORT...';

  @override
  String get estaImaTardar => 'THIS MAY TAKE A FEW SECONDS';

  @override
  String get adminCursosNoEliminarConAlumnos =>
      'Cannot delete a course with enrolled students.';

  @override
  String get adminCursoEliminadoOk => 'Course deleted successfully.';

  @override
  String get adminCursoEliminadoError => 'Error deleting the course.';

  @override
  String get adminCursosVolverCursos => 'Back to Courses';

  @override
  String get adminCursosCompletaInfo => 'Complete the course information';

  @override
  String get adminCursosPlantillaCurso => 'Course Template';

  @override
  String get adminCursosSeleccionaPlantilla => 'Select a template';

  @override
  String get adminCursosValidarPlantilla => 'Select a course template';

  @override
  String get adminCursosTurnoOpcional => 'Shift (optional)';

  @override
  String get adminCursosEtapa => 'Stage';

  @override
  String get adminCursosDesdoblamiento => 'Split';

  @override
  String get adminCursosCodigoGrupo => 'Group Code';

  @override
  String get adminCursosAnioAcademico => 'Academic Year';

  @override
  String get adminCursosSinAnios => 'No academic years available';

  @override
  String get adminCursosValidarAnio => 'Select an academic year';

  @override
  String get adminCursosValidarTutor =>
      'You must assign a tutor to the course.';

  @override
  String get adminCursosValidarMateria =>
      'You must select at least one subject for the course.';

  @override
  String get adminCursosValidarCodigoGrupoVacio =>
      'The group code is required and must not match any other code for the same year.';

  @override
  String get adminCursosProfesorTutor => 'Tutor Teacher';

  @override
  String adminCursosMatriculacion(int count) {
    return 'Enrollment: $count student(s)';
  }

  @override
  String get adminCursosMaterias => 'Subjects';

  @override
  String get adminCursosSinMaterias => 'No subjects assigned to this course.';

  @override
  String get adminCursosBuscarAnio => 'Search year...';

  @override
  String get adminCursosOrdenHint => 'A-Z (Optional)';

  @override
  String get adminCursosCodigoHint => 'E.g.: DAM1M';

  @override
  String get adminCursosTutorAsignado => 'Assigned tutor';

  @override
  String get adminCursosBuscarProfesor => 'Search teacher by name...';

  @override
  String get adminCursosSeleccionaAsignaturas =>
      'Select the subjects to be taught';

  @override
  String get adminCursosVistaPrevia => 'Course Preview';

  @override
  String get adminCursosPlantillaOficial => 'Official Template';

  @override
  String get adminCursosInstanciados => 'Instantiated Courses';

  @override
  String get adminCursosVisualizacion => 'Active groups view';

  @override
  String get adminCursosAniadirNuevo => 'Add New Course';

  @override
  String get adminCursosNoRegistrados =>
      'No courses registered for this template';

  @override
  String get adminCursosEliminarTooltip => 'Delete course';

  @override
  String get adminCursosGestionarHorario => 'Manage Schedule';

  @override
  String get adminCursosGestionarAlumnos => 'Manage Students';

  @override
  String get adminCursosPlanificacion => 'Academic Planning';

  @override
  String get adminCursosProgresoModulo => 'Module Progress';

  @override
  String get adminCursosTemporalidad => 'Temporality';

  @override
  String get adminCursosEditarFechas => 'Edit Dates';

  @override
  String get adminCursosVolverDetalles => 'Back to details';

  @override
  String get adminCursosVolverGrupos => 'Back to groups';

  @override
  String get adminCursosSinTutor => 'No tutor';

  @override
  String get adminCursosAlumnosMatriculados => 'Enrolled Students';

  @override
  String get adminCursosAniadirAlumno => 'Add Student';

  @override
  String get adminCursosSinAlumnos => 'No students enrolled in this course.';

  @override
  String get adminCursosQuitarAlumno => 'Remove Student';

  @override
  String get adminDashResumenEjecutivo => 'Executive Summary';

  @override
  String get adminDashMetricasTiempoReal => 'Main school metrics in real time';

  @override
  String get adminDashAccionesRapidas => 'Quick Actions';

  @override
  String get adminDashMatricularAlumno => 'Enroll Student';

  @override
  String get adminDashGestionarFestivos => 'Manage Holidays';

  @override
  String get adminDashRevisarPermisos => 'Review Permissions';

  @override
  String get adminDashBienvenido => 'Welcome back, Administrator!';

  @override
  String get adminDashVerReporteMensual => 'View monthly report';

  @override
  String get adminDashAsistenciaGlobal => 'Global Attendance';

  @override
  String get adminDashAsistenciaSubtitulo =>
      'Average performance of the last 7 days';

  @override
  String get adminDashIncidenciasPorCurso => 'Incidents by Course (Top 5)';

  @override
  String get adminDashSinIncidencias => 'No incidents registered';

  @override
  String get adminDashErrorGrafico => 'Error loading chart';

  @override
  String get adminDashAlertasRecientes => 'Recent Alerts';

  @override
  String get adminDashSinAlertas => 'No recent alerts';

  @override
  String get adminDashFiltroAplicado => 'Filter applied';

  @override
  String adminDashMostrandoDatos(String periodo) {
    return 'Showing data for $periodo';
  }

  @override
  String get adminDashSeleccionarEtapa =>
      'Select the current stage of this incident';

  @override
  String get adminAuditoriaTitulo => 'System Audit';

  @override
  String get adminAuditoriaSubtitulo => 'Activity log and critical changes';

  @override
  String get adminAuditoriaFiltrarPor => 'Filter by action';

  @override
  String get adminAuditoriaBuscar => 'Search in the log...';

  @override
  String get adminAuditoriaSinRegistros => 'No audit records.';

  @override
  String get adminAuditoriaUsuario => 'User';

  @override
  String get adminAuditoriaAccion => 'Action';

  @override
  String get adminAuditoriaFecha => 'Date';

  @override
  String get adminAuditoriaDetalle => 'Detail';

  @override
  String get adminAuditoriaTodos => 'ALL';

  @override
  String get adminAuditoriaExportar => 'Export';

  @override
  String get adminUsuariosSubtitulo => 'Manage system accesses';

  @override
  String get adminUsuariosBuscar => 'Search user...';

  @override
  String get adminUsuariosNuevo => 'New User';

  @override
  String get adminUsuariosEmail => 'Email';

  @override
  String get adminUsuariosSinUsuarios => 'No registered users.';

  @override
  String get adminUsuariosEliminarTitulo => 'Delete User';

  @override
  String get adminUsuariosEliminarDesc =>
      'Are you sure you want to delete this user? This action cannot be undone.';

  @override
  String get adminUsuariosActivar => 'Activate';

  @override
  String get adminUsuariosDesactivar => 'Deactivate';

  @override
  String get adminUsuariosEditar => 'Edit';

  @override
  String get adminUsuariosActivadoMsg => 'User activated successfully.';

  @override
  String get adminUsuariosDesactivadoMsg => 'User deactivated successfully.';

  @override
  String get adminUsuariosEliminadoMsg => 'User deleted successfully.';

  @override
  String get adminUsuariosErrorMsg => 'Error processing the request.';

  @override
  String get adminConfigTitulo => 'System Configuration';

  @override
  String get adminConfigSubtitulo => 'Manage the school\'s general settings';

  @override
  String get adminConfigGuardar => 'Save Changes';

  @override
  String get adminConfigCambiosGuardados => 'Changes saved successfully.';

  @override
  String get adminConfigErrorGuardar => 'Error saving changes.';

  @override
  String get adminConfigNombreCentro => 'School Name';

  @override
  String get adminConfigDireccion => 'Address';

  @override
  String get adminConfigTelefono => 'Phone';

  @override
  String get adminConfigEmail => 'Contact Email';

  @override
  String get adminConfigCursoActivo => 'Active Academic Year';

  @override
  String get adminHorarioSinSesiones => 'No sessions configured.';

  @override
  String get adminHorarioNuevaSesion => 'New Session';

  @override
  String get adminHorarioEliminarSesion => 'Delete Session';

  @override
  String get adminHorarioEliminarSesionDesc =>
      'Delete this session from the schedule?';

  @override
  String get adminHorarioSesionCreada => 'Session created successfully.';

  @override
  String get adminHorarioSesionEliminada => 'Session deleted successfully.';

  @override
  String get adminRolesTitulo => 'Role Management';

  @override
  String get adminRolesSubtitulo => 'Define permissions and accesses by role';

  @override
  String get adminRolesSinRoles => 'No roles defined.';

  @override
  String get adminRolesGuardado => 'Role updated successfully.';

  @override
  String get adminRolesError => 'Error updating the role.';

  @override
  String get adminReglamentoGuardado => 'Rules saved successfully.';

  @override
  String get adminReglamentoNuevoArticulo => 'New Article';

  @override
  String get adminReglamentoEliminar => 'Delete Article';

  @override
  String get adminReglamentoEliminarDesc =>
      'Delete this article from the rules?';

  @override
  String get adminProgConfigTitulo => 'Program Configuration';

  @override
  String get adminProgConfigSubtitulo =>
      'Manage modules and academic configuration';

  @override
  String get adminProgConfigGuardado => 'Configuration saved successfully.';

  @override
  String get adminProgConfigError => 'Error saving the configuration.';

  @override
  String get adminPermissionsTitulo => 'Permission Management';

  @override
  String get adminPermissionsSubtitulo =>
      'Control access to system functionalities';

  @override
  String get adminPermissionsGuardado => 'Permissions updated successfully.';

  @override
  String get adminPermissionsError => 'Error updating permissions.';

  @override
  String get adminUsuariosBuscarDetalle =>
      'Search by name, last name, username...';

  @override
  String get adminUsuariosColUsuario => 'USER / IDENTIFICATION';

  @override
  String get adminUsuariosColEmail => 'EMAIL';

  @override
  String get adminUsuariosColRol => 'ROLE';

  @override
  String get adminUsuariosColEstado => 'STATUS';

  @override
  String get adminUsuariosColUltimaActividad => 'LAST ACTIVITY';

  @override
  String get adminUsuariosColIpSesion => 'SESSION IP';

  @override
  String get adminUsuariosColAcciones => 'ACTIONS';

  @override
  String get adminUsuariosSinResultados => 'No results for the current filter';

  @override
  String adminUsuariosMostrando(int from, int to, int total) {
    return 'Showing $from - $to of $total';
  }

  @override
  String adminUsuariosMostrandoRegistros(int from, int to, int total) {
    return 'Showing $from - $to of $total records';
  }

  @override
  String get adminUsuariosMenuVerPerfil => 'View Full Profile';

  @override
  String get adminUsuariosMenuEditar => 'Edit User';

  @override
  String get adminUsuariosMenuResetear => 'Reset Password';

  @override
  String get adminUsuariosMenuDesactivar => 'Deactivate Account';

  @override
  String get adminUsuariosMenuActivar => 'Activate Account';

  @override
  String get adminUsuariosMenuEliminar => 'Delete User';

  @override
  String get adminUsuariosToastCopiado => 'Copied';

  @override
  String get adminUsuariosToastTokenCopiado => 'Session token copied.';

  @override
  String get adminUsuariosToastContrasenaReseteada => 'Password Reset';

  @override
  String adminUsuariosToastContrasenaMsg(String username) {
    return 'The password for $username is now: gaula123';
  }

  @override
  String get adminUsuariosToastError => 'Error';

  @override
  String get adminUsuariosToastNoResetear => 'Could not reset the password.';

  @override
  String get adminUsuariosToastEstadoActualizado => 'Status Updated';

  @override
  String adminUsuariosToastEstadoMsg(String username, String estado) {
    return 'User $username is now $estado';
  }

  @override
  String get adminUsuariosToastNoEstado => 'Could not change the status.';

  @override
  String get adminUsuariosToastEliminado => 'User Deleted';

  @override
  String get adminUsuariosToastEliminadoMsg =>
      'The record has been deleted from the system.';

  @override
  String get adminUsuariosToastNoEliminar => 'Could not delete the user.';

  @override
  String get adminUsuariosDialogEliminarTitulo => 'Delete User?';

  @override
  String adminUsuariosDialogEliminarMsg(String nombre, String username) {
    return 'This action will permanently delete $nombre (@$username). This action cannot be undone.';
  }

  @override
  String get adminUsuariosDialogCancelar => 'CANCEL';

  @override
  String get adminUsuariosDialogEliminar => 'DELETE';

  @override
  String adminUsuariosTodosFiltro(String hint) {
    return 'All ($hint)';
  }

  @override
  String get crearIncidenciaCompletaCampos => 'Please complete all fields';

  @override
  String get crearIncidenciaSeleccionaAlumno => 'Please select a student';

  @override
  String get crearIncidenciaExito => '✅ Incident created successfully';

  @override
  String get crearIncidenciaError => 'Error creating incident';

  @override
  String get crearIncidenciaSubtituloAlumno => 'Report a problem or incident';

  @override
  String get crearIncidenciaSubtituloProfesor => 'Register a student incident';

  @override
  String get crearIncidenciaAlumnoLabel => 'Student *';

  @override
  String get crearIncidenciaTituloLabel => 'Title *';

  @override
  String get crearIncidenciaTituloHint => 'Brief description of the problem';

  @override
  String get crearIncidenciaDescripcionLabel => 'Description *';

  @override
  String get crearIncidenciaDescripcionHint =>
      'Describe the problem in detail...';

  @override
  String get crearIncidenciaGravedadLabel => 'Severity';

  @override
  String get crearIncidenciaBoton => 'Create Incident';

  @override
  String get crearIncidenciaBuscarAlumno => 'Type to search...';

  @override
  String get crearIncidenciaSinGrupo => 'No group';

  @override
  String get crearIncidenciaErrorAlumnos => 'Error loading students';

  @override
  String get verReporteMensual => 'View monthly report';

  @override
  String get sinAlertasRecientes => 'No recent alerts';

  @override
  String get buscarPorNombre => 'Search by name...';

  @override
  String get asignarMaterias => 'Assign Subjects';

  @override
  String get cursoSinMaterias => 'This course has no assigned subjects';

  @override
  String get marcarTodos => 'Check all';

  @override
  String get desmarcarTodos => 'Uncheck all';

  @override
  String get atras => 'Back';

  @override
  String get matricular => 'Enroll';

  @override
  String get anadirCursoModalidad => 'Add course to this modality';

  @override
  String get etapaActualIncidencia =>
      'Select the current stage of this incident';

  @override
  String get buscarPorTituloDesc => 'Search by title or description...';

  @override
  String get topAlumnosIncidencias => 'Top Students with Incidents';

  @override
  String get noHayIncidencias => 'No incidents registered';

  @override
  String get resolucionIncidencia => 'Incident Resolution';

  @override
  String get esInvalida => 'IS INVALID';

  @override
  String get esValida => 'IS VALID';

  @override
  String get fechaPlaceholder => 'Date...';

  @override
  String get materia => 'Subject';

  @override
  String get seleccionarMateria => 'Select subject';

  @override
  String docenteConNombreLabel(String nombre) {
    return 'Teacher: $nombre';
  }

  @override
  String get siguienteLabel => 'Next';

  @override
  String get cambiarPasswordTitulo => 'Change Password';

  @override
  String get cambiarPasswordDesc => 'Enter your current and new password';

  @override
  String get dialogContrasenyaActual => 'Current Password';

  @override
  String get dialogNovaContrasenya => 'New Password';

  @override
  String get dialogConfirmarNovaContrasenya => 'Confirm New Password';

  @override
  String get notificacionesTitulo => 'Notifications';

  @override
  String get marcarTodas => 'Mark all as read';

  @override
  String get noHayNotificaciones => 'No notifications';

  @override
  String get reglamentoCentro => 'SCHOOL REGULATIONS';

  @override
  String get normativaVigente => 'CURRENT REGULATIONS';

  @override
  String get versionActualizada => 'Updated Version';

  @override
  String paginaNoEncontrada(String uri) {
    return 'Page not found: $uri';
  }

  @override
  String get irAlInicio => 'Go to home';

  @override
  String get tabTotes => 'ALL';

  @override
  String get tabObert => 'OPEN';

  @override
  String get tabEnProces => 'IN PROGRESS';

  @override
  String get tabTancat => 'CLOSED';

  @override
  String get filtreCurs => 'Course';

  @override
  String get filtreAlumne => 'Student';

  @override
  String get filtreProfessor => 'Teacher';

  @override
  String get filtrarPorAlumno => 'Filter by student...';

  @override
  String get filtrarPorProfesor => 'Filter by teacher...';

  @override
  String get todosAlumnos => 'All Students';

  @override
  String get todosProfesores => 'All Teachers';

  @override
  String get todos => 'All';

  @override
  String get incidenciaPendiente => 'PENDING';

  @override
  String get resValida => 'VALID';

  @override
  String get resInvalida => 'INVALID';

  @override
  String get incidenciasEsInvalida => 'IS INVALID';

  @override
  String get incidenciaConfirmacioText =>
      'After the investigation carried out, is it confirmed that the incident is real and warrants sanction?';

  @override
  String get topAlumnesIncidencies => 'Top Students with Incidents';

  @override
  String get alertesTotals => 'TOTAL ALERTS';

  @override
  String get incidenciaSeveridadLeve => 'Minor';

  @override
  String get incidenciaSeveridadGrave => 'Serious';

  @override
  String get incidenciaSeveridadMuyGrave => 'Very Serious';

  @override
  String get adminCursosCalendario => 'School Calendar';

  @override
  String get adminCursosVerOtrosAnios => 'View other years';

  @override
  String get adminCursosAniadirCurso => 'Add Course';

  @override
  String get adminCursosTurnoPartido => 'Split (S)';

  @override
  String get adminCursosTurnoManana => 'Morning (M)';

  @override
  String get adminCursosTurnoTarde => 'Afternoon (A)';

  @override
  String get adminCursosTurnoNocturno => 'Evening (E)';

  @override
  String get statPresentes => 'Pres.';

  @override
  String get statAusentes => 'Abs.';

  @override
  String get statRetrasos => 'Late';

  @override
  String get diaSabado => 'Saturday';

  @override
  String get diaDomingo => 'Sunday';

  @override
  String asistenciaAlumnoIndex(int index, int total) {
    return 'Student $index of $total';
  }

  @override
  String get asistenciaHoraLabel => 'Time';

  @override
  String get asistenciaCursoLabel => 'Course';
}
