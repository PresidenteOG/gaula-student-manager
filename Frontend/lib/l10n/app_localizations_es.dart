// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'GAULA — Gestor de Clases';

  @override
  String get loading => 'Cargando...';

  @override
  String get errorGenerico => 'Error';

  @override
  String get reintentar => 'Reintentar';

  @override
  String get guardar => 'Guardar';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get cerrar => 'Cerrar';

  @override
  String get volver => 'Volver';

  @override
  String get confirmar => 'Confirmar';

  @override
  String get buscar => 'Buscar';

  @override
  String get buscarPlaceholder => 'Buscar...';

  @override
  String get sinDatos => 'Sin datos disponibles.';

  @override
  String get aceptar => 'Aceptar';

  @override
  String get eliminar => 'Eliminar';

  @override
  String get justificar => 'Justificar';

  @override
  String get editar => 'Editar';

  @override
  String get crear => 'Crear';

  @override
  String get agregar => 'Agregar';

  @override
  String get ver => 'Ver';

  @override
  String get exportar => 'Exportar';

  @override
  String get importar => 'Importar';

  @override
  String get actualizar => 'Actualizar';

  @override
  String pagina(int actual, int total) {
    return 'Página $actual de $total';
  }

  @override
  String get navInicio => 'Inicio';

  @override
  String get navAsistencia => 'Asistencia';

  @override
  String get navCalendario => 'Calendario';

  @override
  String get navAlumnos => 'Alumnos';

  @override
  String get navProfesores => 'Profesores';

  @override
  String get navCursos => 'Cursos';

  @override
  String get navIncidencias => 'Incidencias';

  @override
  String get navReglamento => 'Reglamento';

  @override
  String get navCerrarSesion => 'Cerrar sesión';

  @override
  String get navResumen => 'Resumen';

  @override
  String get navPlanesEstudios => 'Planes de Estudios';

  @override
  String get navConfiguracion => 'Configuración';

  @override
  String get navCopiaSeguridad => 'Copia Seguridad';

  @override
  String get navMiHorario => 'Mi Horario';

  @override
  String get navNormasCentro => 'Normas del Centro';

  @override
  String get navHistorialClases => 'Historial Clases';

  @override
  String get navMiPerfil => 'Mi Perfil';

  @override
  String get navAjustes => 'Ajustes';

  @override
  String get navMiAsistencia => 'Mi Asistencia';

  @override
  String get navHistorial => 'Historial';

  @override
  String get navMiFicha => 'Mi Ficha';

  @override
  String get navMisIncidencias => 'Mis Incidencias';

  @override
  String get navPasarLista => 'Pasar Lista';

  @override
  String get rolAdministrador => 'ADMINISTRADOR';

  @override
  String get rolProfesor => 'PROFESOR';

  @override
  String get rolAlumno => 'ALUMNO';

  @override
  String get shellAdminTitulo => 'Panel Administrativo';

  @override
  String get shellAdminSubtitulo => 'Gestión Central GAULA';

  @override
  String get shellAdminTituloMovil => 'GAULA Admin';

  @override
  String get shellTeacherTitulo => 'Portal Docente';

  @override
  String get shellTeacherSubtitulo => 'Gestión Educativa GAULA';

  @override
  String get shellTeacherTituloMovil => 'GAULA Docente';

  @override
  String get shellStudentSubtitulo => 'Panel de Alumno';

  @override
  String saludoHola(String nombre) {
    return 'Hola, $nombre';
  }

  @override
  String get sinNotificaciones => 'No hay notificaciones';

  @override
  String get loginTitulo => 'Iniciar sesión';

  @override
  String get loginUsuario => 'Usuario';

  @override
  String get loginContrasena => 'Contraseña';

  @override
  String get loginBoton => 'Entrar';

  @override
  String get loginErrorCredenciales => 'Usuario o contraseña incorrectos.';

  @override
  String get loginErrorConexion =>
      'Error de conexión. ¿Está el servidor arrancado?';

  @override
  String get dashClasesHoy => 'Clases hoy';

  @override
  String get dashAlumnosTotales => 'Alumnos totales';

  @override
  String get dashIncidenciasHoy => 'Incidencias hoy';

  @override
  String get dashAsistenciaMedia => 'Asistencia media';

  @override
  String get dashAsistenciaTotal => 'Asistencia total';

  @override
  String get dashAusencias => 'Ausencias';

  @override
  String get dashRetrasos => 'Retrasos';

  @override
  String get dashHorasFaltadas => 'Horas Faltadas';

  @override
  String get dashClasesTotales => 'Clases Totales';

  @override
  String get seccionListasPendientes => 'Listas Pendientes';

  @override
  String get todoAlDia => 'Todo al día 🎉';

  @override
  String get seccionProximasClases => 'Próximas Clases';

  @override
  String get sinClasesHoy => 'No tienes clases hoy';

  @override
  String get sinClasesProximas => 'No tienes clases próximas ahora';

  @override
  String get accesRapido => 'Acceso Rápido';

  @override
  String get irAPasarLista => 'Ir a Pasar Lista';

  @override
  String proximaClaseLabel(String materia) {
    return 'Próxima: $materia';
  }

  @override
  String aulaHoraLabel(String aula, String horaInicio, String horaFin) {
    return 'Aula: $aula • $horaInicio - $horaFin';
  }

  @override
  String get errorCargarProximaClase => 'Error al cargar próxima clase';

  @override
  String get misClasesHoy => 'Mis Clases de Hoy';

  @override
  String get horarioCompleto => 'Horario Completo';

  @override
  String get cargandoHorario => 'Cargando horario...';

  @override
  String get errorCargandoHorario => 'Error cargando horario';

  @override
  String get sinClasesHoyAlumno => 'No tienes clases programadas para hoy';

  @override
  String get saludoEstudiante => 'Estudiante';

  @override
  String get saludoProfesor => 'Profesor';

  @override
  String get historialTitulo => 'Historial de Clases';

  @override
  String get historialSubtitulo =>
      'Registro completo de todas tus sesiones de clase';

  @override
  String get historialVacio => 'No hay historial de clases todavía';

  @override
  String get historialVacioDesc =>
      'Tu historial de asistencia aparecerá aquí conforme el profesor pase lista';

  @override
  String get fechaHoy => 'Hoy';

  @override
  String get asistenciaTitulo => 'Mi Asistencia';

  @override
  String get asistenciaMaterias => 'Materias';

  @override
  String get asistenciaRegistro => 'Registro';

  @override
  String get asistenciaAusente => 'Ausente';

  @override
  String get asistenciaRetraso => 'Retraso';

  @override
  String get asistenciaJustificado => 'Justificado';

  @override
  String get asistenciaPresente => 'Presente';

  @override
  String get asistenciaSinFaltas => 'Sin registros de faltas/retrasos.';

  @override
  String get asistenciaPasarLista => 'Pasar Lista';

  @override
  String get estadoPresente => 'PRESENTE';

  @override
  String get estadoAusente => 'AUSENTE';

  @override
  String get estadoRetraso => 'RETRASO';

  @override
  String get estadoJustificado => 'JUSTIFICADO';

  @override
  String get estadoActivo => 'ACTIVO';

  @override
  String get estadoInactivo => 'INACTIVO';

  @override
  String get estadoMatriculado => 'MATRICULADO';

  @override
  String get estadoAbierto => 'ABIERTO';

  @override
  String get estadoEnProceso => 'EN PROCESO';

  @override
  String get estadoCerrado => 'CERRADO';

  @override
  String get calendarioTitulo => 'Calendario de Festivos';

  @override
  String get calendarioSubtitulo =>
      'Días no lectivos y festividades académicas sincronizadas';

  @override
  String get calendarioProximosDias => 'PRÓXIMOS DÍAS';

  @override
  String get calendarioConfigurarRegion => 'CONFIGURAR REGIÓN';

  @override
  String get calendarioSincronizar => 'Sincronizar Festivos';

  @override
  String get calendarioSinFestivos =>
      'No hay festivos registrados para este período.';

  @override
  String get calendarioNacional => 'Nacional';

  @override
  String get calendarioAutonomico => 'Autonómico';

  @override
  String get seleccionarCurso => 'Seleccionar Curso';

  @override
  String get seleccionarCursoDesc =>
      'Selecciona un curso para ver sus materias disponibles hoy.';

  @override
  String get seleccionarMateriaDesc =>
      'Selecciona la materia para ver sus sesiones.';

  @override
  String get seleccionarSesionDesc =>
      'Selecciona la sesión exacta para pasar lista.';

  @override
  String get sinSesionesHoy => 'No hay sesiones para hoy.';

  @override
  String get sinMaterias => 'No hay materias en este curso.';

  @override
  String get sinCursos => 'No se encontraron cursos.';

  @override
  String get volverMisClases => 'Volver a mis clases';

  @override
  String get modoUnoEnUno => 'Uno en Uno';

  @override
  String get modoClasico => 'Clásico';

  @override
  String get perfilFoto => 'Foto de perfil';

  @override
  String get perfilCambiarFoto => 'Cambiar foto';

  @override
  String get errorServidor =>
      'Error del servidor. Inténtalo de nuevo más tarde.';

  @override
  String get mantenimiento =>
      'El servidor está en mantenimiento. Vuelve en unos minutos.';

  @override
  String get alumnosTitulo => 'Alumnos';

  @override
  String get alumnoNuevo => 'Nuevo Alumno';

  @override
  String get alumnoEditar => 'Editar Alumno';

  @override
  String get alumnoRegistrado => 'Alumno registrado correctamente';

  @override
  String get alumnoActualizado => 'Alumno actualizado correctamente';

  @override
  String get alumnoEliminado => 'Alumno eliminado correctamente';

  @override
  String get errorRegistrarAlumno => 'Error al registrar alumno';

  @override
  String get alumnoNombre => 'Nombre';

  @override
  String get alumnoApellidos => 'Apellidos';

  @override
  String get alumnoEmail => 'Email';

  @override
  String get alumnoDni => 'DNI';

  @override
  String get alumnoUsuario => 'Usuario';

  @override
  String get alumnoContrasena => 'Contraseña';

  @override
  String get alumnoCurso => 'Curso';

  @override
  String get alumnoSinCurso => 'Sin asignar';

  @override
  String get alumnoSinMatricular => 'Sin matricular';

  @override
  String get profesoresTitulo => 'Profesores';

  @override
  String get profesorNuevo => 'Nuevo Profesor';

  @override
  String get profesorEditar => 'Editar Profesor';

  @override
  String get profesorRegistrado => 'Profesor registrado correctamente';

  @override
  String get profesorActualizado => 'Profesor actualizado correctamente';

  @override
  String get profesorEliminado => 'Profesor eliminado correctamente';

  @override
  String get cursosTitulo => 'Cursos';

  @override
  String get cursoNuevo => 'Crear Nuevo Curso';

  @override
  String get cursoEliminar => 'Eliminar Curso';

  @override
  String get cursoEliminadoOk => 'Curso eliminado correctamente';

  @override
  String get cursoEliminadoError =>
      'Error al eliminar curso. Compruebe si tiene dependencias activas.';

  @override
  String get cursoConAlumnos =>
      'No se puede eliminar un curso que tiene alumnos matriculados.';

  @override
  String cursoConfirmarEliminar(String codigo) {
    return '¿Estás seguro de que deseas eliminar el curso $codigo? Esta acción eliminará también las materias y el horario asociado.';
  }

  @override
  String matriculacionTitulo(int count) {
    return 'Matriculación de Alumnos ($count)';
  }

  @override
  String get buscarAlumnos => 'Buscar alumnos por nombre...';

  @override
  String get incidenciasTitulo => 'Incidencias';

  @override
  String get incidenciasAbiertaDesc => 'Nueva incidencia pendiente de revisión';

  @override
  String get incidenciasCerradaDesc => 'Incidencia resuelta y archivada';

  @override
  String get incidenciasCursoGrupo => 'CURSO/GRUPO';

  @override
  String get incidenciasDescripcionHechos => 'DESCRIPCIÓN DE LOS HECHOS';

  @override
  String get incidenciasAlumnoLabel => 'ALUMNO';

  @override
  String get incidenciasProfesorResponsable => 'PROFESOR RESPONSABLE';

  @override
  String get incidenciasEsValida => 'ES VÁLIDA';

  @override
  String get incidenciasEnProcesoDesc =>
      'Se están tomando medidas disciplinarias';

  @override
  String get incidenciasSistemaLimpio =>
      'El sistema está limpio para los filtros seleccionados';

  @override
  String get incidenciaNueva => 'Nueva Incidencia';

  @override
  String get horarioTitulo => 'Horario';

  @override
  String get planEstudiosTitulo => 'Planes de Estudios';

  @override
  String get alumnosTituloTeacher => 'Mis Alumnos';

  @override
  String get fichaAlumnoTitulo => 'Ficha del Alumno';

  @override
  String get ajustesTitulo => 'Ajustes';

  @override
  String get idioma => 'Idioma';

  @override
  String get tema => 'Tema';

  @override
  String get temaClaroOscuro => 'Claro / Oscuro';

  @override
  String get sinAlumnos => 'No hay alumnos en este curso';

  @override
  String get sinProfesores => 'No hay profesores registrados';

  @override
  String get sinIncidencias => 'No hay incidencias registradas';

  @override
  String get confirmarEliminar => 'Confirmar eliminación';

  @override
  String get accionNoDeshacer => 'Esta acción no se puede deshacer.';

  @override
  String get errorConexion => 'Error de conexión';

  @override
  String get reintentarBoton => 'Reintentar';

  @override
  String get horarioAlumno => 'Horario del Alumno';

  @override
  String get horarioMio => 'Mi Horario Escolar';

  @override
  String get horarioProfesor => 'Horario del Profesor';

  @override
  String get horarioAlumnoSubtitulo =>
      'Visualizando planificación semanal del alumno.';

  @override
  String get horarioAlumnoSubtituloPropio =>
      'Visualiza tu planificación semanal completa.';

  @override
  String get horarioProfesorSubtitulo =>
      'Gestiona sesiones semanales y eventos.';

  @override
  String get horarioDescanso => 'DESCANSO';

  @override
  String get horarioEventosAsignacion => 'Asignación de Eventos y Exámenes';

  @override
  String get horarioTipoEvento => 'Tipo de Evento';

  @override
  String get horarioFecha => 'Fecha';

  @override
  String get horarioDescripcionLabel => 'Descripción';

  @override
  String get horarioFechaPlaceholder => 'Seleccionar Fecha';

  @override
  String get horarioDescPlaceholder => 'Ej. Examen Final DAW';

  @override
  String get horarioEventoAniadido => 'Evento añadido correctamente';

  @override
  String get horarioSinClases => 'No hay clases programadas.';

  @override
  String horarioErrorCargar(Object error) {
    return 'Error al cargar horario: $error';
  }

  @override
  String horarioAsignarEvento(String fecha) {
    return 'Asignar Evento: $fecha';
  }

  @override
  String horarioEventosDia(String fecha) {
    return 'Eventos: $fecha';
  }

  @override
  String get horarioSinEventos => 'No hay eventos asignados.';

  @override
  String get horarioDescripcionEvento => 'Descripción del Evento';

  @override
  String get horarioAulaDefault => 'Aula 101';

  @override
  String get fichaVolverAlumnos => 'Volver a alumnos';

  @override
  String get fichaSinGrupo => 'Sin grupo';

  @override
  String get fichaTelefono => 'Teléfono';

  @override
  String get fichaNoEspecificado => 'No especificado';

  @override
  String get fichaDireccion => 'Dirección';

  @override
  String get fichaSinDireccion => 'Sin dirección';

  @override
  String get fichaEstadisticasAsistencia => 'Estadísticas de Asistencia';

  @override
  String get fichaDesgloseModulo => 'Desglose por Módulo';

  @override
  String get fichaSinDatosModulo => 'No hay datos por módulo registrados.';

  @override
  String get fichaAsistencia => 'Asistencia';

  @override
  String get fichaFaltas => 'Faltas';

  @override
  String get fichaRetrasos => 'Retrasos';

  @override
  String get fichaJustificadas => 'Justificadas';

  @override
  String get fichaTotalClases => 'Total Clases';

  @override
  String get fichaHorasFaltadas => 'Horas Faltadas';

  @override
  String get fichaRiesgo => 'RIESGO';

  @override
  String get fichaLimiteExcedido => 'LÍMITE EXCEDIDO';

  @override
  String fichaFaltasDetalle(String total, int max) {
    return 'Faltas: $total / $max máx.';
  }

  @override
  String fichaAsistencias(int presentes, int total) {
    return '$presentes/$total asistidas';
  }

  @override
  String get fichaVerHorario => 'Ver Horario Completo';

  @override
  String get fichaCrearIncidencia => 'Crear Incidencia';

  @override
  String fichaHorarioDe(String nombre) {
    return 'Horario de $nombre';
  }

  @override
  String get fichaRegistroAsistencia => 'Registro de Asistencia';

  @override
  String fichaFaltasDe(String nombre) {
    return 'Faltas de $nombre';
  }

  @override
  String fichaRetrasosDe(String nombre) {
    return 'Retrasos de $nombre';
  }

  @override
  String fichaJustificadasDe(String nombre) {
    return 'Faltas Justificadas de $nombre';
  }

  @override
  String fichaErrorHistorial(Object error) {
    return 'Error al cargar historial: $error';
  }

  @override
  String get fichaSinRegistros => 'No hay registros de este tipo.';

  @override
  String fichaRegistradoPor(String nombre) {
    return 'Registrado por: $nombre';
  }

  @override
  String get fichaSinFecha => 'Sin fecha';

  @override
  String get alumnosTituloDesc =>
      'Gestión centralizada del expediente académico y asistencia';

  @override
  String get matricularAlumno => 'Matricular Alumno';

  @override
  String get todosCursos => 'Todos los Cursos';

  @override
  String get sinAlumnosEncontrados => 'No se encontraron alumnos registrados';

  @override
  String get confirmarBaja => 'Confirmar Baja';

  @override
  String get activarAlumno => 'Activar Alumno';

  @override
  String get darDeBaja => 'Dar de Baja';

  @override
  String get reporteAsistenciaLabel => 'Reporte de Asistencia';

  @override
  String get editarExpediente => 'Editar Expediente';

  @override
  String get profesoresTituloDesc =>
      'Gestión integral del claustro y personal administrativo';

  @override
  String get registrarNuevoProfesor => 'Registrar Nuevo';

  @override
  String get buscarProfesoresHint => 'Buscar profesores...';

  @override
  String get buscarProfesoresDetalle =>
      'Buscar por nombre, especialidad o departamento...';

  @override
  String get filtrarPorCurso => 'Filtrar por curso...';

  @override
  String get filtrarPorRol => 'Filtrar por rol...';

  @override
  String get todosRoles => 'Todos los Roles';

  @override
  String get docenteLabel => 'Docente';

  @override
  String get cuerpoDocenteLabel => 'CUERPO DOCENTE';

  @override
  String get directivaAdminLabel => 'DIRECTIVA / ADM.';

  @override
  String get horarioSemanalReal => 'HORARIO SEMANAL REAL';

  @override
  String get filtrarCursoMateria => 'Filtrar por curso o materia...';

  @override
  String get sinClasesHorarioProfesor =>
      'No hay clases asignadas en el horario semanal';

  @override
  String get sinProfesoresEncontrados =>
      'No se encontraron profesores con los filtros aplicados';

  @override
  String get gestionar => 'Gestionar';

  @override
  String get sesionLabel => 'SESIÓN';

  @override
  String get incidenciasTituloDesc =>
      'Control disciplinario, convivencia y alertas tempranas';

  @override
  String get registrarIncidencia => 'Registrar Incidencia';

  @override
  String get actualizarEstado => 'Actualizar Estado';

  @override
  String get eliminarRegistro => 'Eliminar Registro';

  @override
  String get incidenciaEliminadaDesc =>
      'Esta acción es permanente y no se podrá recuperar la información de esta incidencia.';

  @override
  String get planEstudiosTituloDesc =>
      'Gestión curricular y planes de estudios del centro';

  @override
  String get cursosTituloDesc => 'Gestión de grupos y matriculación de alumnos';

  @override
  String get authPwdOlvidasteTitulo => '¿Olvidaste tu contraseña?';

  @override
  String get authPwdOlvidasteDesc =>
      'Introduce tu correo electrónico y te enviaremos un código de recuperación.';

  @override
  String get authPwdCorreoHint => 'Correo electrónico';

  @override
  String get authPwdEnviarCodigo => 'ENVIAR CÓDIGO';

  @override
  String get authPwdVolverLogin => 'Volver al Login';

  @override
  String authPwdError(Object error) {
    return 'Error: $error';
  }

  @override
  String get authPwdNoCoinciden => 'Las contraseñas no coinciden';

  @override
  String get authPwdActualizadaOk => '✅ Contraseña actualizada correctamente';

  @override
  String get authPwdRestablecerTitulo => 'Restablecer Contraseña';

  @override
  String get authPwdRestablecerDesc =>
      'Introduce el código que has recibido y tu nueva contraseña.';

  @override
  String get authPwdCodigoHint => 'CÓDIGO';

  @override
  String get authPwdNuevaContrasena => 'Nueva Contraseña';

  @override
  String get authPwdConfirmarContrasena => 'Confirmar Contraseña';

  @override
  String get authPwdActualizar => 'ACTUALIZAR CONTRASEÑA';

  @override
  String get authMantTitulo => 'Servidor en Mantenimiento';

  @override
  String get authMantDesc =>
      'Estamos realizando mejoras en el sistema para brindarte un mejor servicio.\nPor favor, inténtalo de nuevo en unos minutos.';

  @override
  String get authMantReintentar => 'REINTENTAR CONEXIÓN';

  @override
  String get authDevAutocompletar => 'Autocompletar login (sólo devs)';

  @override
  String get authPwdOlvidasteLink => '¿Has olvidado tu contraseña?';

  @override
  String get horarioEventoExamen => 'Examen';

  @override
  String get horarioEventoEvaluacion => 'Evaluación';

  @override
  String get horarioEventoPresentacion => 'Presentación';

  @override
  String get horarioEventoReunion => 'Reunión';

  @override
  String get horarioEventoFestivo => 'Festivo';

  @override
  String get horarioFechaLabel => 'Fecha';

  @override
  String get diaLunes => 'Lunes';

  @override
  String get diaMartes => 'Martes';

  @override
  String get diaMiercoles => 'Miércoles';

  @override
  String get diaJueves => 'Jueves';

  @override
  String get diaViernes => 'Viernes';

  @override
  String get userProfileGuardado => 'Cambios guardados correctamente';

  @override
  String get userProfileMisDatos => 'Mis Datos';

  @override
  String get userProfileSubtitulo =>
      'Gestiona tu información personal y profesional.';

  @override
  String get userProfileFotoActualizada => 'Foto actualizada correctamente';

  @override
  String get userProfileInfoPersonal => 'Información Personal';

  @override
  String get userProfileNombreCompleto => 'Nombre Completo';

  @override
  String get userProfileDniNie => 'DNI/NIE';

  @override
  String get userProfileFechaNacimiento => 'Fecha Nacimiento';

  @override
  String get userProfileInfoContacto => 'Información de Contacto';

  @override
  String get userProfileTelefono => 'Teléfono';

  @override
  String get userProfileDireccion => 'Dirección';

  @override
  String get userProfileSeguridad => 'Seguridad';

  @override
  String get userProfileSeguridadDesc =>
      'Protege tu cuenta actualizando tu contraseña regularmente.';

  @override
  String get userProfileCambiarPassword => 'Cambiar Contraseña';

  @override
  String studentAsisError(Object error) {
    return 'Error: $error';
  }

  @override
  String get studentAsisDesconocido => 'Desconocido';

  @override
  String studentAsisFaltas(Object max, Object total) {
    return 'Faltas: $total / $max máx';
  }

  @override
  String studentAsisClasesAbrev(Object clases, Object horas) {
    return '$clases/$horas cl.';
  }

  @override
  String studentAsisClases(Object clases, Object horas) {
    return '$clases/$horas clases';
  }

  @override
  String get studentAsisProgresoClases => 'Progreso de Clases';

  @override
  String get studentFichaDatosDesc =>
      'Datos personales y académicos de tu matrícula';

  @override
  String get studentFichaRolAlumno => 'ALUMNO';

  @override
  String get studentFichaDatosPersonales => 'Datos Personales';

  @override
  String get studentFichaDniNie => 'DNI / NIE';

  @override
  String get studentFichaTelefono => 'Teléfono';

  @override
  String get studentFichaDireccion => 'Dirección';

  @override
  String get studentFichaFechaNacimiento => 'Fecha de Nacimiento';

  @override
  String get studentFichaDatosAcademicos => 'Datos Académicos';

  @override
  String get studentFichaGrupo => 'Grupo';

  @override
  String get studentFichaEstadoMatricula => 'Estado de Matrícula';

  @override
  String get studentFichaMateriasMatriculadas => 'Materias Matriculadas';

  @override
  String studentFichaModulos(Object count) {
    return '$count módulos';
  }

  @override
  String get studentFichaMatriculado => 'MATRICULADO';

  @override
  String get studentFichaAlumno => 'Alumno';

  @override
  String get studentFichaOfflineDesc =>
      'Sin conexión. Mostrando los datos básicos de tu perfil.';

  @override
  String get teacherAlumnosAnterior => 'Anterior';

  @override
  String get teacherAlumnosSiguiente => 'Siguiente';

  @override
  String get teacherAlumnosSinGrupo => 'Sin grupo';

  @override
  String get teacherAlumnosAsistencia => 'Asistencia';

  @override
  String get teacherAlumnosFaltas => 'Faltas';

  @override
  String get teacherSettingsSubtitulo =>
      'Personaliza tu experiencia en la plataforma GAULA';

  @override
  String get teacherSettingsPerfilUsuario => 'Perfil de Usuario';

  @override
  String get teacherSettingsPerfilDesc => 'Gestiona tu información personal';

  @override
  String get teacherSettingsVerPerfil => 'Ver Perfil';

  @override
  String get teacherSettingsEditarPerfil => 'Editar Perfil';

  @override
  String get teacherSettingsSeguridad => 'Seguridad';

  @override
  String get teacherSettingsSeguridadDesc => 'Protege tu acceso al sistema';

  @override
  String get teacherSettingsCambiarPass => 'Cambiar Contraseña';

  @override
  String get teacherSettingsSesionesActivas => 'Sesiones Activas';

  @override
  String get teacherSettingsSeguridadProximamente =>
      'Funcionalidad de seguridad próximamente';

  @override
  String get teacherSettingsNotificaciones => 'Notificaciones';

  @override
  String get teacherSettingsNotificacionesDesc =>
      'Configura las alertas y avisos';

  @override
  String get teacherSettingsAlertasAsistencia => 'Alertas de Asistencia';

  @override
  String get teacherSettingsMensajesAlumnos => 'Mensajes de Alumnos';

  @override
  String get teacherSettingsPreferencias => 'Preferencias';

  @override
  String get teacherSettingsPreferenciasDesc => 'Ajustes de visualización';

  @override
  String get teacherSettingsSoporte => 'Soporte y Ayuda';

  @override
  String get teacherSettingsSoporteDesc => 'Recursos de asistencia';

  @override
  String get teacherSettingsNormasCentro => 'Normas del Centro';

  @override
  String get teacherSettingsContactarSoporte => 'Contactar Soporte';

  @override
  String get teacherSettingsContactandoSoporte =>
      'Contactando con soporte técnico...';

  @override
  String get teacherSettingsVersion => 'GAULA • Desarrollado por VicePresi';

  @override
  String get teacherSettingsCopyright => '© 2026 Sistema de Gestión Educativa';

  @override
  String get teacherSettingsNotifPush => 'Notificaciones Push';

  @override
  String get teacherSettingsNotifEmail => 'Notificaciones por Email';

  @override
  String adminDashErrorMetricas(String error) {
    return 'Error al cargar métricas: $error';
  }

  @override
  String get adminDashDocentes => 'Docentes';

  @override
  String get adminDashTrendEstable => 'Estable';

  @override
  String get adminUsuariosErrorRedTitulo => 'Error de red';

  @override
  String get adminUsuariosErrorRedMsg => 'No se pudo conectar con el servidor';

  @override
  String get adminUsuariosTitulo => 'Gestión de Usuarios';

  @override
  String get adminUsuariosMonitorTiempoReal => 'MONITOR EN TIEMPO REAL';

  @override
  String get adminUsuariosTotal => 'Total';

  @override
  String get adminUsuariosRol => 'Rol...';

  @override
  String get adminUsuariosEstado => 'Estado...';

  @override
  String get attendanceScheduleMyClasses => 'Mis Clases';

  @override
  String get attendanceScheduleOtherClass => 'Pasar Lista de Otra Clase';

  @override
  String get attendanceScheduleTodaySchedule => 'Horario de Hoy';

  @override
  String attendanceSchedulePendingClasses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'clases pendientes',
      one: 'clase pendiente',
    );
    return 'Tienes $count $_temp0 de pasar lista';
  }

  @override
  String get attendanceScheduleNoClassesToday =>
      'No hay clases programadas para hoy.';

  @override
  String get attendanceScheduleHistory => 'Historial';

  @override
  String get attendanceScheduleSearchByDate => 'Buscar por fecha...';

  @override
  String get attendanceScheduleNoHistory => 'No hay historial de asistencia.';

  @override
  String get attendanceScheduleTakeAttendance => 'Pasar Lista';

  @override
  String get attendanceScheduleCompleted => 'Completado';

  @override
  String get attendanceScheduleSelectCourse => 'Seleccionar Curso';

  @override
  String get attendanceScheduleSelectCourseHint =>
      'Selecciona un curso para ver sus materias disponibles hoy.';

  @override
  String get attendanceScheduleSearchCourse => 'Buscar por nombre o código...';

  @override
  String attendanceScheduleErrorLoadingYears(String error) {
    return 'Error al cargar años: $error';
  }

  @override
  String get attendanceScheduleNoCourses => 'No se encontraron cursos.';

  @override
  String get attendanceScheduleSelectSubjectHint =>
      'Selecciona la materia para ver sus sesiones.';

  @override
  String get attendanceScheduleNoSubjects => 'No hay materias en este curso.';

  @override
  String get attendanceScheduleSubjectFallback => 'Materia';

  @override
  String get attendanceScheduleSelectSessionHint =>
      'Selecciona la sesión exacta para pasar lista.';

  @override
  String get attendanceScheduleNoSessionsToday => 'No hay sesiones para hoy.';

  @override
  String get attendanceScheduleSessionsFallback => 'Sesiones';

  @override
  String get attendanceScheduleAulaFallback => 'Aula';

  @override
  String get attendanceDetailRegisteredBy => 'REGISTRADO POR:';

  @override
  String get attendanceDetailSystemAuto => 'SISTEMA / AUTOMÁTICO';

  @override
  String get attendanceDetailPresent => 'PRESENTES';

  @override
  String get attendanceDetailAbsent => 'AUSENTES';

  @override
  String get attendanceDetailAttendance => 'ASISTENCIA';

  @override
  String get attendanceDetailStudentList => 'LISTADO DE FALTAS';

  @override
  String get attendanceDetailNoRecords =>
      'No hay registros de asistencia para esta sesión.';

  @override
  String get attendanceDetailStudentFallback => 'Alumno';

  @override
  String get attendanceDetailStatusPresente => 'PRESENTE';

  @override
  String get attendanceDetailStatusAusente => 'AUSENTE';

  @override
  String get attendanceDetailStatusRetraso => 'RETRASO';

  @override
  String get attendanceDetailStatusJustificado => 'JUSTIFICADO';

  @override
  String get attendanceDetailStatusPendiente => 'PENDIENTE';

  @override
  String get adminAuditoriaTitle => 'Registro de Auditoría';

  @override
  String get adminAuditoriaSubtitle =>
      'Trazabilidad completa de acciones administrativas';

  @override
  String get adminAuditoriaEmpty => 'SIN REGISTROS DE ACTIVIDAD';

  @override
  String get adminConfigTitle => 'CONFIGURACIÓN';

  @override
  String get adminConfigSubtitle =>
      'Gestiona los parámetros globales y mantenimiento';

  @override
  String get adminConfigSecurityTitle => 'Seguridad y Acceso';

  @override
  String get adminConfigSecurityDesc => 'Control de credenciales y sesiones';

  @override
  String get adminConfigSecurityChangePassword => 'Cambiar Contraseña';

  @override
  String get adminConfigSecurityActiveSessions => 'Sesiones Activas';

  @override
  String get adminConfigSecurity2FA => 'Doble Factor (2FA)';

  @override
  String get adminConfigReglamentoTitle => 'Reglamento del Centro';

  @override
  String get adminConfigReglamentoDesc => 'Normativa y convivencia escolar';

  @override
  String get adminConfigReglamentoEdit => 'Editar Reglamento';

  @override
  String get adminConfigReglamentoHistory => 'Historial de Versiones';

  @override
  String get adminConfigReglamentoPublish => 'Publicar Cambios';

  @override
  String get adminConfigAuditoriaTitle => 'Auditoría de Cambios';

  @override
  String get adminConfigAuditoriaDesc => 'Registro de actividad administrativa';

  @override
  String get adminConfigAuditoriaViewLog => 'Ver Log de Actividad';

  @override
  String get adminConfigAuditoriaExport => 'Exportar Reporte';

  @override
  String get adminConfigAuditoriaAlerts => 'Alertas de Auditoría';

  @override
  String get adminConfigComingSoon => 'PRONTO';

  @override
  String get adminPermTitle => 'Matriz RBAC';

  @override
  String get adminPermSubtitle => 'Control granular de seguridad y accesos';

  @override
  String get adminPermSyncButton => 'SINCRONIZAR POLÍTICAS';

  @override
  String get adminPermColRolPerfil => 'ROL / PERFIL';

  @override
  String get adminPermPermGestionAcademica => 'Gestión Académica';

  @override
  String get adminPermPermPasarLista => 'Pasar Lista';

  @override
  String get adminPermPermVerHistorial => 'Ver Historial';

  @override
  String get adminPermPermCrearIncidencias => 'Crear Incidencias';

  @override
  String get adminPermPermBorrarRegistros => 'Borrar Registros';

  @override
  String get adminPermPermConfigurarSistema => 'Configurar Sistema';

  @override
  String get adminPermPermEditarPerfiles => 'Editar Perfiles';

  @override
  String get adminPermPermExportarDatos => 'Exportar Datos';

  @override
  String get adminPermToastSyncTitle => 'Matriz Sincronizada';

  @override
  String get adminPermToastSyncMessage =>
      'Los permisos globales han sido actualizados.';

  @override
  String get adminPermToastErrorTitle => 'Error';

  @override
  String get adminPermToastErrorMessage =>
      'No se pudo guardar la configuración.';

  @override
  String adminPermErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get adminRolesTitle => 'Gestión de Roles';

  @override
  String get adminRolesSubtitle =>
      'Configuración de perfiles y jerarquías de sistema';

  @override
  String get adminRolesSaveButton => 'GUARDAR CAMBIOS';

  @override
  String get adminRolesBadgeSystem => 'SISTEMA';

  @override
  String get adminRolesNewProfileTitle => 'Nuevo Perfil';

  @override
  String get adminRolesNewProfileDesc =>
      'Define un nuevo rol para la gestión de usuarios.';

  @override
  String get adminRolesFieldLabel => 'NOMBRE DEL ROL';

  @override
  String get adminRolesAddButton => 'AÑADIR ROL';

  @override
  String get adminRolesInfoBox =>
      'Asigna permisos en la Matriz después de crear el rol.';

  @override
  String get adminRolesToastSuccessTitle => 'Éxito';

  @override
  String get adminRolesToastSuccessMessage =>
      'Lista de roles actualizada correctamente.';

  @override
  String get adminRolesToastErrorTitle => 'Error';

  @override
  String get adminRolesToastErrorMessage =>
      'No se pudo guardar la configuración.';

  @override
  String adminRolesErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get adminAnioTitulo => 'Años Académicos';

  @override
  String get adminAnioSubtitulo =>
      'Gestiona los periodos escolares del centro.';

  @override
  String get adminAnioNuevo => 'Nuevo Año';

  @override
  String get adminAnioActivo => 'ACTIVO';

  @override
  String adminAnioCursos(int n) {
    return '$n cursos';
  }

  @override
  String adminAnioMiembros(int n) {
    return '$n miembros';
  }

  @override
  String get adminAnioDesactivar => 'Desactivar';

  @override
  String get adminAnioActivar => 'Activar';

  @override
  String get adminAnioEliminar => 'Eliminar';

  @override
  String get adminAnioTooltipDesactivar => 'Desactivar';

  @override
  String get adminAnioTooltipActivar => 'Activar';

  @override
  String get adminAnioTooltipEditar => 'Editar';

  @override
  String get adminAnioTooltipEliminar => 'Eliminar';

  @override
  String get adminAnioTooltipNoEliminarActivo =>
      'No se puede eliminar el año activo';

  @override
  String get adminAnioTooltipNoEliminarAlumnos =>
      'No se puede eliminar (tiene alumnos)';

  @override
  String adminAnioErrorCargar(Object e) {
    return 'Error al cargar los datos: $e';
  }

  @override
  String get adminAnioReintentar => 'Reintentar';

  @override
  String get adminAnioVacio => 'No hay años académicos registrados.';

  @override
  String get adminAnioCrearPrimero => 'Crear el primero';

  @override
  String get adminAnioDialogNuevo => 'Nuevo Año Académico';

  @override
  String get adminAnioDialogEditar => 'Editar Año Académico';

  @override
  String get adminAnioNombrePeriodo => 'Nombre del período';

  @override
  String get adminAnioNombreHint => 'Ej. 2025-2026';

  @override
  String get adminAnioNombreObligatorio => 'Campo obligatorio';

  @override
  String get adminAnioFechaInicio => 'Fecha de inicio';

  @override
  String get adminAnioFechaFin => 'Fecha de fin';

  @override
  String get adminAnioSeleccionar => 'Seleccionar';

  @override
  String get adminAnioDescripcion => 'Descripción (opcional)';

  @override
  String get adminAnioDescripcionHint => 'Breve descripción del período';

  @override
  String get adminAnioCancelar => 'Cancelar';

  @override
  String get adminAnioGuardarCambios => 'Guardar Cambios';

  @override
  String get adminAnioCrearAnio => 'Crear Año';

  @override
  String get adminAnioDesactivarTitulo => 'Desactivar Año Académico';

  @override
  String adminAnioDesactivarMensaje(String nombre) {
    return '¿Seguro que quieres desactivar \"$nombre\"? Éste pasará a modo histórico.';
  }

  @override
  String get adminAnioActivarTitulo => 'Activar Año Académico';

  @override
  String adminAnioActivarMensaje(String nombre) {
    return '¿Seguro que quieres activar \"$nombre\"? El año activo actualmente pasará a modo histórico.';
  }

  @override
  String get adminAnioEliminarTitulo => 'Eliminar Año Académico';

  @override
  String adminAnioEliminarMensaje(String nombre) {
    return '¿Eliminar \"$nombre\" permanentemente? Esta acción no se puede deshacer.';
  }

  @override
  String get adminAnioSnackDesactivado => 'Año desactivado';

  @override
  String get adminAnioSnackActivado => 'Año activado';

  @override
  String get adminAnioSnackEliminado => 'Año eliminado';

  @override
  String get adminAnioSnackGuardado => 'Año guardado correctamente';

  @override
  String get adminAnioSnackErrorGuardar => 'Error al guardar';

  @override
  String get adminAnioSnackNoEliminarActivo =>
      'No puedes eliminar el año activo.';

  @override
  String adminAnioDuplicado(String nombre) {
    return 'Ya existe un año académico con el nombre \"$nombre\".';
  }

  @override
  String get adminAnioSeleccionarFechas =>
      'Selecciona las fechas de inicio y fin.';

  @override
  String get adminAnioErrorConexion => 'Error de conexión';

  @override
  String get adminHorarioTitulo => 'Calendario';

  @override
  String get adminHorarioTituloDesktop => 'Calendario de Eventos';

  @override
  String get adminHorarioSubtitulo =>
      'Planificación académica y recordatorios del centro';

  @override
  String get adminHorarioNuevoEvento => 'NUEVO EVENTO';

  @override
  String get adminHorarioEventosDia => 'Eventos del Día';

  @override
  String get adminHorarioSinEventos => 'No hay eventos para hoy';

  @override
  String get adminHorarioProgramarEvento => 'Programar Festivo';

  @override
  String get adminHorarioTituloEvento => 'Título del día festivo';

  @override
  String get adminHorarioTipo => 'Tipo';

  @override
  String get adminHorarioCancelar => 'CANCELAR';

  @override
  String get adminHorarioGuardar => 'GUARDAR';

  @override
  String get adminHorarioEliminadoTitulo => 'Eliminado';

  @override
  String get adminHorarioEliminadoMensaje => 'El evento ha sido borrado.';

  @override
  String get adminHorarioErrorTitulo => 'Error';

  @override
  String get adminReglamentoTitulo => 'Reglamento';

  @override
  String get adminReglamentoSubtitulo =>
      'Gestión de versiones y vigencia legal';

  @override
  String get adminReglamentoHistorialTitulo => 'Historial Normativo';

  @override
  String get adminReglamentoHistorialSubtitulo =>
      'Gestión de versiones y vigencia legal';

  @override
  String get adminReglamentoHistorialBtn => 'Historial';

  @override
  String get adminReglamentoNuevaVersion => 'NUEVA VERSIÓN';

  @override
  String get adminReglamentoPublicar => 'PUBLICAR CAMBIOS';

  @override
  String get adminReglamentoVersionHint => 'Nombre de la Versión...';

  @override
  String get adminReglamentoVersionActivaLabel => 'VERSIÓN ACTIVA';

  @override
  String get adminReglamentoActivoBadge => 'ACTIVO';

  @override
  String get adminReglamentoEditorPlaceholder =>
      'Comienza a redactar la normativa del centro...';

  @override
  String get adminReglamentoNuevaBorrador => 'Nueva versión en borrador';

  @override
  String adminReglamentoModificandoVersion(String fecha) {
    return 'Modificando versión del $fecha';
  }

  @override
  String get adminReglamentoErrorTitulo => 'Error';

  @override
  String get adminReglamentoExitoTitulo => 'Éxito';

  @override
  String get adminReglamentoVersionRequerida => 'Nombre de versión requerido';

  @override
  String get adminReglamentoGuardadoOk => 'Reglamento guardado y sincronizado';

  @override
  String adminReglamentoFalloGuardar(String error) {
    return 'Fallo al guardar: $error';
  }

  @override
  String get adminReglamentoErrorCargar => 'Error al cargar historial';

  @override
  String get adminHistorialTitulo => 'Historial';

  @override
  String get adminHistorialSubtitulo => 'Auditoría global de registros';

  @override
  String get adminHistorialTituloDesktop => 'Historial de Asistencia';

  @override
  String get adminHistorialSubtituloDesktop =>
      'Auditoría global de registros de clase y ausentismo';

  @override
  String get adminHistorialBuscarHint => 'Buscar materia o profesor...';

  @override
  String get adminHistorialCualquierFecha => 'Cualquier fecha';

  @override
  String get adminHistorialCursoLabel => 'CURSO';

  @override
  String get adminHistorialGrupoHint => 'Grupo';

  @override
  String get adminHistorialTodos => 'Todos';

  @override
  String get adminHistorialTodosGrupos => 'Todos los grupos';

  @override
  String get adminHistorialSinRegistros => 'SIN REGISTROS QUE MOSTRAR';

  @override
  String get adminHistorialSinDocente => 'Sin docente';

  @override
  String adminHistorialAlumnos(int attended, int total) {
    return '$attended/$total ALUMNOS';
  }

  @override
  String get adminProgramConfigTitulo => 'Configuración del Programa';

  @override
  String get adminProgramConfigSubtitulo =>
      'Gestión de políticas institucionales, roles de usuario y parámetros globales del centro';

  @override
  String get adminProgramConfigRolesTitulo => 'Roles y Matriz de Permisos';

  @override
  String get adminProgramConfigRolesDesc =>
      'Control granular sobre las capacidades de cada perfil';

  @override
  String get adminProgramConfigMatrizPermisos => 'Matriz de Permisos';

  @override
  String get adminProgramConfigMatrizPermisosDesc =>
      'Mapa de privilegios por cada rol del sistema';

  @override
  String get adminProgramConfigGestionRoles => 'Gestión de Roles';

  @override
  String get adminProgramConfigGestionRolesDesc =>
      'Añadir, editar o eliminar etiquetas de usuario';

  @override
  String get adminProgramConfigCalendarioTitulo => 'Calendario Institucional';

  @override
  String get adminProgramConfigCalendarioDesc =>
      'Configuración de festivos y eventos regionales';

  @override
  String get adminProgramConfigFestivos => 'Calendario de Festivos';

  @override
  String get adminProgramConfigFestivosDesc =>
      'Gestionar días no lectivos y puentes';

  @override
  String get adminProgramConfigEventosCentro => 'Eventos del Centro';

  @override
  String get adminProgramConfigEventosCentroDesc =>
      'Graduaciones, claustros y festividades propias';

  @override
  String get adminProgramConfigReglamentoTitulo => 'Reglamento de Convivencia';

  @override
  String get adminProgramConfigReglamentoDesc =>
      'Normas y pautas de comportamiento del centro';

  @override
  String get adminProgramConfigVerEditarReglamento => 'Ver / Editar Reglamento';

  @override
  String get adminProgramConfigVerEditarReglamentoDesc =>
      'Gestión detallada de normas, derechos y deberes';

  @override
  String get adminProgramConfigMantenimientoTitulo =>
      'Mantenimiento del Sistema';

  @override
  String get adminProgramConfigMantenimientoDesc =>
      'Parámetros técnicos y logs de actividad';

  @override
  String get adminProgramConfigAuditoria => 'Auditoría de Cambios';

  @override
  String get adminProgramConfigAuditoriaDesc =>
      'Ver historial de modificaciones administrativas';

  @override
  String get adminProgramConfigLimpieza => 'Limpieza de Temporales';

  @override
  String get adminProgramConfigLimpiezaDesc =>
      'Purgar archivos de subida no referenciados';

  @override
  String get adminProgramConfigUsuarios => 'Gestión de Usuarios';

  @override
  String get adminProgramConfigUsuariosDesc =>
      'Control de IPs, sesiones y actividad de cuentas';

  @override
  String get adminProgramConfigEnDesarrolloTitulo =>
      'Funcionalidad en Desarrollo';

  @override
  String get adminProgramConfigEnDesarrolloDesc =>
      'Esta característica estará disponible en la próxima actualización del sistema GAULA.';

  @override
  String get adminProgramConfigEntendido => 'ENTENDIDO';

  @override
  String get adminProgramConfigEnDesarrolloBadge => 'EN DESARROLLO';

  @override
  String get addAlumnoEditTitle => 'Editar Alumno';

  @override
  String get addAlumnoAddTitle => 'Añadir Nuevo Alumno';

  @override
  String get addAlumnoEditSubtitle => 'Modifica los datos del alumno';

  @override
  String get addAlumnoAddSubtitle =>
      'Completa la información para la matrícula';

  @override
  String get addAlumnoSectionPersonal => 'INFORMACIÓN PERSONAL';

  @override
  String get addAlumnoFieldNombre => 'Nombre *';

  @override
  String get addAlumnoHintNombre => 'Ej: Juan';

  @override
  String get addAlumnoFieldApellidos => 'Apellidos *';

  @override
  String get addAlumnoHintApellidos => 'Ej: García López';

  @override
  String get addAlumnoFieldDni => 'DNI/NIE';

  @override
  String get addAlumnoSectionContacto => 'CONTACTO Y MATRÍCULA';

  @override
  String get addAlumnoFieldEmail => 'Email *';

  @override
  String get addAlumnoHintEmail => 'alumno@gaula.edu';

  @override
  String get addAlumnoFieldUsuario => 'Usuario (Opcional)';

  @override
  String get addAlumnoHintUsuario => 'juan.garcia';

  @override
  String get addAlumnoFieldPassword => 'Contraseña *';

  @override
  String get addAlumnoHintPassword => 'Mín. 6 carac.';

  @override
  String get addAlumnoFieldTelefono => 'Teléfono';

  @override
  String get addAlumnoHintTelefono => '+34 600...';

  @override
  String get addAlumnoFieldDireccion => 'Dirección';

  @override
  String get addAlumnoHintDireccion => 'Calle Principal, 123, Madrid';

  @override
  String get addAlumnoSectionMaterias => 'MATERIAS (MATRÍCULA)';

  @override
  String get addAlumnoButtonGuardar => 'Guardar Cambios';

  @override
  String get addAlumnoButtonRegistrar => 'Registrar Alumno';

  @override
  String get addAlumnoButtonCancelar => 'Cancelar';

  @override
  String get addAlumnoFieldFechaNacimiento => 'Fecha de Nacimiento';

  @override
  String get addAlumnoSeleccionarFecha => 'Seleccionar...';

  @override
  String get addAlumnoSuccessRegistrado => 'Alumno registrado correctamente';

  @override
  String get addAlumnoErrorRegistrar => 'Error al registrar alumno';

  @override
  String get addAlumnoCampoObligatorio => 'Campo obligatorio';

  @override
  String get addIncidenciaTitulo => 'Nueva Incidencia';

  @override
  String get addIncidenciaFieldTitulo => 'Título';

  @override
  String get addIncidenciaHintTitulo => 'Ej: Comportamiento disruptivo';

  @override
  String get addIncidenciaFieldAlumno => 'Alumno';

  @override
  String get addIncidenciaSelectAlumno => 'Seleccione alumno';

  @override
  String get addIncidenciaErrorAlumnos => 'Error cargando alumnos';

  @override
  String get addIncidenciaFieldProfesor => 'Profesor que reporta';

  @override
  String get addIncidenciaSelectProfesor => 'Seleccione profesor';

  @override
  String get addIncidenciaErrorProfesores => 'Error cargando profesores';

  @override
  String get addIncidenciaFieldGravedad => 'Gravedad';

  @override
  String get addIncidenciaHintGravedad => 'Nivel de gravedad';

  @override
  String get addIncidenciaFieldDescripcion => 'Descripción detallada';

  @override
  String get addIncidenciaHintDescripcion => 'Detalles de lo sucedido...';

  @override
  String get addIncidenciaButtonCrear => 'Crear Incidencia';

  @override
  String get addIncidenciaButtonCancelar => 'Cancelar';

  @override
  String get addIncidenciaValidacionSeleccion =>
      'Por favor seleccione alumno y profesor';

  @override
  String get addIncidenciaSuccessCreada => 'Incidencia creada correctamente';

  @override
  String get addIncidenciaErrorCrear => 'Error al crear incidencia';

  @override
  String get addIncidenciaCampoObligatorio => 'Campo obligatorio';

  @override
  String get addIncidenciaBuscar => 'Buscar...';

  @override
  String get addIncidenciaNoResultados => 'No se encontraron resultados';

  @override
  String get addProfesorEditTitle => 'Editar Profesor';

  @override
  String get addProfesorAddTitle => 'Añadir Profesor';

  @override
  String get addProfesorEditSubtitle => 'Modifica los accesos';

  @override
  String get addProfesorAddSubtitle =>
      'Crea un nuevo usuario administrativo o docente';

  @override
  String get addProfesorFieldNombre => 'Nombre *';

  @override
  String get addProfesorHintNombre => 'Ej: Roberto';

  @override
  String get addProfesorFieldApellidos => 'Apellidos *';

  @override
  String get addProfesorHintApellidos => 'Ej: Sánchez Domínguez';

  @override
  String get addProfesorFieldEmail => 'Email *';

  @override
  String get addProfesorHintEmail => 'ejemplo@gaula.edu';

  @override
  String get addProfesorFieldEspecialidades => 'Especialidades';

  @override
  String get addProfesorHintEspecialidades => 'Ej: Informática, Programación';

  @override
  String get addProfesorFieldRol => 'Rol de Usuario *';

  @override
  String get addProfesorRolDocente => 'Profesor / Docente';

  @override
  String get addProfesorRolAdmin => 'Administrador';

  @override
  String get addProfesorButtonGuardar => 'Guardar Cambios';

  @override
  String get addProfesorButtonRegistrar => 'Registrar Profesor';

  @override
  String get addProfesorButtonCancelar => 'Cancelar';

  @override
  String get addProfesorSuccessActualizado => 'Datos actualizados';

  @override
  String get addProfesorSuccessRegistrado => 'Profesor registrado';

  @override
  String get addProfesorCampoObligatorio => 'Campo obligatorio';

  @override
  String get addProfesorEmailInvalido => 'Formato de email inválido';

  @override
  String adminCursoHorarioTitulo(String codigoGrupo) {
    return 'Horario Semanal: $codigoGrupo';
  }

  @override
  String get adminCursoHorarioGeneradoTitle => 'Generado';

  @override
  String get adminCursoHorarioGeneradoMsg => 'Horario generado automáticamente';

  @override
  String get adminCursoHorarioErrorTitle => 'Error';

  @override
  String get adminCursoHorarioButtonGenerar => 'Generar Automáticamente';

  @override
  String get adminCursoHorarioButtonAsignar => 'Asignar Módulo';

  @override
  String get adminCursoHorarioRecreo => 'RECREO';

  @override
  String adminCursoHorarioErrorCargar(String error) {
    return 'Error al cargar horario: $error';
  }

  @override
  String get adminCursoHorarioDesconocido => 'Desconocido';

  @override
  String get adminCursoHorarioEliminadoTitle => 'Eliminado';

  @override
  String get adminCursoHorarioEliminadoMsg => 'Sesión eliminada correctamente';

  @override
  String get adminCursoHorarioErrorAsignar => 'Error al asignar';

  @override
  String get adminCursoHorarioAsignadoTitle => 'Asignado';

  @override
  String get adminCursoHorarioAsignadoMsg => 'Sesión asignada correctamente';

  @override
  String adminCursoHorarioElegirColor(String nombre) {
    return 'Elegir Color: $nombre';
  }

  @override
  String get adminCursoHorarioNoProfesores => 'No hay profesores disponibles';

  @override
  String get adminCursoHorarioDia => 'Día';

  @override
  String get adminCursoHorarioHoraInicio => 'Hora Inicio';

  @override
  String get adminCursoHorarioModuloMateria => 'Módulo / Materia';

  @override
  String get adminCursoHorarioSeleccionarModulo => 'Seleccionar módulo';

  @override
  String get adminCursoHorarioNoMaterias => 'No hay materias en el curso';

  @override
  String get adminCursoHorarioProfesorAsignado => 'Profesor Asignado';

  @override
  String get adminCursoHorarioBuscarProfesor => 'Buscar profesor...';

  @override
  String adminCursoHorarioSoloLibres(String hora) {
    return 'Solo libres a las $hora';
  }

  @override
  String get adminCursoHorarioErrorProfesores => 'Error cargando profesores';

  @override
  String get adminCursoHorarioLibre => 'Libre';

  @override
  String get adminCursoHorarioOcupado => 'Ocupado';

  @override
  String get adminCursoHorarioCancelar => 'Cancelar';

  @override
  String get adminCursoHorarioAsignarButton => 'Asignar';

  @override
  String adminPlanEstudiosConfirmarEliminarMateria(String nombre) {
    return '¿Estás seguro de que quieres eliminar la materia \"$nombre\"? Esta acción no se puede deshacer.';
  }

  @override
  String get adminPlanEstudiosErrorEliminarMateria =>
      'Error al eliminar materia.';

  @override
  String get adminPlanEstudiosConfirmarEliminarPlantilla =>
      '¿Estás seguro de que quieres eliminar esta plantilla? Esta acción no se puede deshacer.';

  @override
  String adminPlanEstudiosMateriaCount(int count) {
    return '$count materias';
  }

  @override
  String get adminPlanEstudiosModulosYProyectos => 'Módulos y Proyectos';

  @override
  String adminPlanEstudiosTipoCodigoLabel(String tipo, String codigo) {
    return '$tipo — Código: $codigo';
  }

  @override
  String get adminPlanEstudiosEditarPlan => 'Editar Plan de Estudios';

  @override
  String get adminPlanEstudiosCrearPlan => 'Crear Plan de Estudios';

  @override
  String get adminPlanEstudiosNombreCurso => 'Nombre del Curso';

  @override
  String get adminPlanEstudiosNombreCursoHint =>
      'ej. Desarrollo de Aplicaciones Multiplataforma';

  @override
  String get adminPlanEstudiosCodigo => 'Código';

  @override
  String get adminPlanEstudiosaCodigoHint => 'ej. DAM';

  @override
  String get adminPlanEstudiosDescripcion => 'Descripción (opcional)';

  @override
  String get adminPlanEstudiosDescripcionHint => 'Breve descripción del curso';

  @override
  String get adminPlanEstudiosColorPlantilla => 'Color de la Plantilla';

  @override
  String get adminPlanEstudiosSeleccionarColor => 'Selecciona un color';

  @override
  String get adminPlanEstudiosAniadirMateria => 'Añadir materia';

  @override
  String get adminPlanEstudiosEditarMateria => 'Editar materia';

  @override
  String get adminPlanEstudiosNombreMateria => 'Nombre';

  @override
  String get adminPlanEstudiosNombreMateriaHint => 'ej. Programación';

  @override
  String get adminPlanEstudiosTipoMateria => 'Tipo de Materia';

  @override
  String get adminPlanEstudiosHoras => 'Horas';

  @override
  String get adminPlanEstudiosMateriasAniadidas => 'Materias añadidas:';

  @override
  String adminAlumnosConfirmarDesactivar(String nombre) {
    return '¿Está seguro de que desea desactivar el expediente de $nombre?';
  }

  @override
  String adminAlumnosConfirmarActivar(String nombre) {
    return '¿Está seguro de que desea activar el expediente de $nombre?';
  }

  @override
  String get adminPlanEstudiosTipoProyecto => 'Proyecto';

  @override
  String get adminPlanEstudiosTipoAsignatura => 'Asignatura';

  @override
  String get adminPlanEstudiosTipoModulo => 'Módulo';

  @override
  String get adminProfesoresRolLabel => 'Rol';

  @override
  String get adminProfesoresDesconocido => 'Desconocido';

  @override
  String adminProfesoresCursoLabel(String cursoId) {
    return 'Curso: $cursoId';
  }

  @override
  String get procesandoExportacion => 'PROCESANDO EXPORTACIÓN...';

  @override
  String get estaImaTardar => 'ESTO PUEDE TARDAR UNOS SEGUNDOS';

  @override
  String get adminCursosNoEliminarConAlumnos =>
      'No se puede eliminar un curso con alumnos matriculados.';

  @override
  String get adminCursoEliminadoOk => 'Curso eliminado correctamente.';

  @override
  String get adminCursoEliminadoError => 'Error al eliminar el curso.';

  @override
  String get adminCursosVolverCursos => 'Volver a Cursos';

  @override
  String get adminCursosCompletaInfo => 'Completa la información del curso';

  @override
  String get adminCursosPlantillaCurso => 'Plan de Estudios';

  @override
  String get adminCursosSeleccionaPlantilla => 'Selecciona un plan';

  @override
  String get adminCursosValidarPlantilla => 'Selecciona un plan de estudios';

  @override
  String get adminCursosTurnoOpcional => 'Turno (opcional)';

  @override
  String get adminCursosEtapa => 'Etapa';

  @override
  String get adminCursosDesdoblamiento => 'Desdoblamiento';

  @override
  String get adminCursosCodigoGrupo => 'Código de Grupo';

  @override
  String get adminCursosAnioAcademico => 'Año Académico';

  @override
  String get adminCursosSinAnios => 'No hay años académicos disponibles';

  @override
  String get adminCursosValidarAnio => 'Selecciona un año académico';

  @override
  String get adminCursosValidarTutor => 'Debes asignar un tutor al curso.';

  @override
  String get adminCursosValidarMateria =>
      'Debes seleccionar al menos una materia para el curso.';

  @override
  String get adminCursosValidarCodigoGrupoVacio =>
      'El código de grupo es obligatorio y no debe coincidir con ningún otro código del mismo año.';

  @override
  String get adminCursosProfesorTutor => 'Profesor Tutor';

  @override
  String adminCursosMatriculacion(int count) {
    return 'Matriculación: $count alumno(s)';
  }

  @override
  String get adminCursosMaterias => 'Materias';

  @override
  String get adminCursosSinMaterias =>
      'No hay materias asignadas a este curso.';

  @override
  String get adminCursosBuscarAnio => 'Buscar año...';

  @override
  String get adminCursosOrdenHint => 'A-Z (Opcional)';

  @override
  String get adminCursosCodigoHint => 'Ej: DAM1M';

  @override
  String get adminCursosTutorAsignado => 'Tutor asignado';

  @override
  String get adminCursosBuscarProfesor => 'Buscar profesor por nombre...';

  @override
  String get adminCursosSeleccionaAsignaturas =>
      'Selecciona las asignaturas que se impartirán';

  @override
  String get adminCursosVistaPrevia => 'Vista Previa del Curso';

  @override
  String get adminCursosPlantillaOficial => 'Plantilla Oficial';

  @override
  String get adminCursosInstanciados => 'Cursos Instanciados';

  @override
  String get adminCursosVisualizacion => 'Visualización de grupos activos';

  @override
  String get adminCursosAniadirNuevo => 'Añadir Nuevo Curso';

  @override
  String get adminCursosNoRegistrados =>
      'No hay cursos registrados para esta plantilla';

  @override
  String get adminCursosEliminarTooltip => 'Eliminar curso';

  @override
  String get adminCursosGestionarHorario => 'Gestionar Horario';

  @override
  String get adminCursosGestionarAlumnos => 'Gestionar Alumnos';

  @override
  String get adminCursosPlanificacion => 'Planificación Académica';

  @override
  String get adminCursosProgresoModulo => 'Progreso del Módulo';

  @override
  String get adminCursosTemporalidad => 'Temporalidad';

  @override
  String get adminCursosEditarFechas => 'Editar Fechas';

  @override
  String get adminCursosVolverDetalles => 'Volver a detalles';

  @override
  String get adminCursosVolverGrupos => 'Volver a grupos';

  @override
  String get adminCursosSinTutor => 'Sin tutor';

  @override
  String get adminCursosAlumnosMatriculados => 'Alumnos Matriculados';

  @override
  String get adminCursosAniadirAlumno => 'Añadir Alumno';

  @override
  String get adminCursosSinAlumnos =>
      'No hay alumnos matriculados en este curso.';

  @override
  String get adminCursosQuitarAlumno => 'Quitar Alumno';

  @override
  String get adminDashResumenEjecutivo => 'Resumen Ejecutivo';

  @override
  String get adminDashMetricasTiempoReal =>
      'Métricas principales del centro en tiempo real';

  @override
  String get adminDashAccionesRapidas => 'Acciones Rápidas';

  @override
  String get adminDashMatricularAlumno => 'Matricular Alumno';

  @override
  String get adminDashGestionarFestivos => 'Gestionar Festivos';

  @override
  String get adminDashRevisarPermisos => 'Revisar Permisos';

  @override
  String get adminDashBienvenido => '¡Bienvenido de nuevo, Administrador!';

  @override
  String get adminDashVerReporteMensual => 'Ver reporte mensual';

  @override
  String get adminDashAsistenciaGlobal => 'Asistencia Global';

  @override
  String get adminDashAsistenciaSubtitulo =>
      'Rendimiento promedio de los últimos 7 días';

  @override
  String get adminDashIncidenciasPorCurso => 'Incidencias por Curso (Top 5)';

  @override
  String get adminDashSinIncidencias => 'Sin incidencias registradas';

  @override
  String get adminDashErrorGrafico => 'Error al cargar gráfico';

  @override
  String get adminDashAlertasRecientes => 'Alertas Recientes';

  @override
  String get adminDashSinAlertas => 'Sin alertas recientes';

  @override
  String get adminDashFiltroAplicado => 'Filtro aplicado';

  @override
  String adminDashMostrandoDatos(String periodo) {
    return 'Mostrando datos de $periodo';
  }

  @override
  String get adminDashSeleccionarEtapa =>
      'Selecciona la etapa actual de esta incidencia';

  @override
  String get adminAuditoriaTitulo => 'Auditoría del Sistema';

  @override
  String get adminAuditoriaSubtitulo =>
      'Registro de actividad y cambios críticos';

  @override
  String get adminAuditoriaFiltrarPor => 'Filtrar por acción';

  @override
  String get adminAuditoriaBuscar => 'Buscar en el registro...';

  @override
  String get adminAuditoriaSinRegistros => 'No hay registros de auditoría.';

  @override
  String get adminAuditoriaUsuario => 'Usuario';

  @override
  String get adminAuditoriaAccion => 'Acción';

  @override
  String get adminAuditoriaFecha => 'Fecha';

  @override
  String get adminAuditoriaDetalle => 'Detalle';

  @override
  String get adminAuditoriaTodos => 'TODOS';

  @override
  String get adminAuditoriaExportar => 'Exportar';

  @override
  String get adminUsuariosSubtitulo => 'Administra los accesos al sistema';

  @override
  String get adminUsuariosBuscar => 'Buscar usuario...';

  @override
  String get adminUsuariosNuevo => 'Nuevo Usuario';

  @override
  String get adminUsuariosEmail => 'Email';

  @override
  String get adminUsuariosSinUsuarios => 'No hay usuarios registrados.';

  @override
  String get adminUsuariosEliminarTitulo => 'Eliminar Usuario';

  @override
  String get adminUsuariosEliminarDesc =>
      '¿Estás seguro de que deseas eliminar este usuario? Esta acción no se puede deshacer.';

  @override
  String get adminUsuariosActivar => 'Activar';

  @override
  String get adminUsuariosDesactivar => 'Desactivar';

  @override
  String get adminUsuariosEditar => 'Editar';

  @override
  String get adminUsuariosActivadoMsg => 'Usuario activado correctamente.';

  @override
  String get adminUsuariosDesactivadoMsg =>
      'Usuario desactivado correctamente.';

  @override
  String get adminUsuariosEliminadoMsg => 'Usuario eliminado correctamente.';

  @override
  String get adminUsuariosErrorMsg => 'Error al procesar la solicitud.';

  @override
  String get adminConfigTitulo => 'Configuración del Sistema';

  @override
  String get adminConfigSubtitulo =>
      'Gestiona los ajustes generales del centro';

  @override
  String get adminConfigGuardar => 'Guardar Cambios';

  @override
  String get adminConfigCambiosGuardados => 'Cambios guardados correctamente.';

  @override
  String get adminConfigErrorGuardar => 'Error al guardar los cambios.';

  @override
  String get adminConfigNombreCentro => 'Nombre del Centro';

  @override
  String get adminConfigDireccion => 'Dirección';

  @override
  String get adminConfigTelefono => 'Teléfono';

  @override
  String get adminConfigEmail => 'Email de Contacto';

  @override
  String get adminConfigCursoActivo => 'Año Académico Activo';

  @override
  String get adminHorarioSinSesiones => 'No hay sesiones configuradas.';

  @override
  String get adminHorarioNuevaSesion => 'Nueva Sesión';

  @override
  String get adminHorarioEliminarSesion => 'Eliminar Sesión';

  @override
  String get adminHorarioEliminarSesionDesc =>
      '¿Eliminar esta sesión del horario?';

  @override
  String get adminHorarioSesionCreada => 'Sesión creada correctamente.';

  @override
  String get adminHorarioSesionEliminada => 'Sesión eliminada correctamente.';

  @override
  String get adminRolesTitulo => 'Gestión de Roles';

  @override
  String get adminRolesSubtitulo => 'Define permisos y accesos por rol';

  @override
  String get adminRolesSinRoles => 'No hay roles definidos.';

  @override
  String get adminRolesGuardado => 'Rol actualizado correctamente.';

  @override
  String get adminRolesError => 'Error al actualizar el rol.';

  @override
  String get adminReglamentoGuardado => 'Reglamento guardado correctamente.';

  @override
  String get adminReglamentoNuevoArticulo => 'Nuevo Artículo';

  @override
  String get adminReglamentoEliminar => 'Eliminar Artículo';

  @override
  String get adminReglamentoEliminarDesc =>
      '¿Eliminar este artículo del reglamento?';

  @override
  String get adminProgConfigTitulo => 'Configuración del Programa';

  @override
  String get adminProgConfigSubtitulo =>
      'Gestiona los módulos y configuración académica';

  @override
  String get adminProgConfigGuardado => 'Configuración guardada correctamente.';

  @override
  String get adminProgConfigError => 'Error al guardar la configuración.';

  @override
  String get adminPermissionsTitulo => 'Gestión de Permisos';

  @override
  String get adminPermissionsSubtitulo =>
      'Controla el acceso a funcionalidades del sistema';

  @override
  String get adminPermissionsGuardado => 'Permisos actualizados correctamente.';

  @override
  String get adminPermissionsError => 'Error al actualizar los permisos.';

  @override
  String get adminUsuariosBuscarDetalle =>
      'Buscar por nombre, apellidos, usuario...';

  @override
  String get adminUsuariosColUsuario => 'USUARIO / IDENTIFICACIÓN';

  @override
  String get adminUsuariosColEmail => 'EMAIL';

  @override
  String get adminUsuariosColRol => 'ROL';

  @override
  String get adminUsuariosColEstado => 'ESTADO';

  @override
  String get adminUsuariosColUltimaActividad => 'ÚLTIMA ACTIVIDAD';

  @override
  String get adminUsuariosColIpSesion => 'IP SESIÓN';

  @override
  String get adminUsuariosColAcciones => 'ACCIONES';

  @override
  String get adminUsuariosSinResultados =>
      'Sin resultados para el filtro actual';

  @override
  String adminUsuariosMostrando(int from, int to, int total) {
    return 'Mostrando $from - $to de $total';
  }

  @override
  String adminUsuariosMostrandoRegistros(int from, int to, int total) {
    return 'Mostrando $from - $to de $total registros';
  }

  @override
  String get adminUsuariosMenuVerPerfil => 'Ver Perfil Completo';

  @override
  String get adminUsuariosMenuEditar => 'Editar Usuario';

  @override
  String get adminUsuariosMenuResetear => 'Resetear Contraseña';

  @override
  String get adminUsuariosMenuDesactivar => 'Desactivar Cuenta';

  @override
  String get adminUsuariosMenuActivar => 'Activar Cuenta';

  @override
  String get adminUsuariosMenuEliminar => 'Eliminar Usuario';

  @override
  String get adminUsuariosToastCopiado => 'Copiado';

  @override
  String get adminUsuariosToastTokenCopiado => 'Token de sesión copiado.';

  @override
  String get adminUsuariosToastContrasenaReseteada => 'Contraseña Reseteada';

  @override
  String adminUsuariosToastContrasenaMsg(String username) {
    return 'La contraseña para $username es ahora: gaula123';
  }

  @override
  String get adminUsuariosToastError => 'Error';

  @override
  String get adminUsuariosToastNoResetear =>
      'No se pudo resetear la contraseña.';

  @override
  String get adminUsuariosToastEstadoActualizado => 'Estado Actualizado';

  @override
  String adminUsuariosToastEstadoMsg(String username, String estado) {
    return 'Usuario $username está ahora $estado';
  }

  @override
  String get adminUsuariosToastNoEstado => 'No se pudo cambiar el estado.';

  @override
  String get adminUsuariosToastEliminado => 'Usuario Eliminado';

  @override
  String get adminUsuariosToastEliminadoMsg =>
      'El registro ha sido borrado del sistema.';

  @override
  String get adminUsuariosToastNoEliminar => 'No se pudo eliminar el usuario.';

  @override
  String get adminUsuariosDialogEliminarTitulo => '¿Eliminar Usuario?';

  @override
  String adminUsuariosDialogEliminarMsg(String nombre, String username) {
    return 'Esta acción eliminará permanentemente a $nombre (@$username). Esta acción no se puede deshacer.';
  }

  @override
  String get adminUsuariosDialogCancelar => 'CANCELAR';

  @override
  String get adminUsuariosDialogEliminar => 'ELIMINAR';

  @override
  String adminUsuariosTodosFiltro(String hint) {
    return 'Todos ($hint)';
  }

  @override
  String get crearIncidenciaCompletaCampos =>
      'Por favor completa todos los campos';

  @override
  String get crearIncidenciaSeleccionaAlumno =>
      'Por favor selecciona un alumno';

  @override
  String get crearIncidenciaExito => '✅ Incidencia creada correctamente';

  @override
  String get crearIncidenciaError => 'Error al crear incidencia';

  @override
  String get crearIncidenciaSubtituloAlumno =>
      'Reporta un problema o incidencia';

  @override
  String get crearIncidenciaSubtituloProfesor =>
      'Registra una incidencia de un alumno';

  @override
  String get crearIncidenciaAlumnoLabel => 'Alumno *';

  @override
  String get crearIncidenciaTituloLabel => 'Título *';

  @override
  String get crearIncidenciaTituloHint => 'Breve descripción del problema';

  @override
  String get crearIncidenciaDescripcionLabel => 'Descripción *';

  @override
  String get crearIncidenciaDescripcionHint =>
      'Describe el problema en detalle...';

  @override
  String get crearIncidenciaGravedadLabel => 'Gravedad';

  @override
  String get crearIncidenciaBoton => 'Crear Incidencia';

  @override
  String get crearIncidenciaBuscarAlumno => 'Escribe para buscar...';

  @override
  String get crearIncidenciaSinGrupo => 'Sin grupo';

  @override
  String get crearIncidenciaErrorAlumnos => 'Error cargando alumnos';

  @override
  String get verReporteMensual => 'Ver reporte mensual';

  @override
  String get sinAlertasRecientes => 'Sin alertas recientes';

  @override
  String get buscarPorNombre => 'Buscar por nombre...';

  @override
  String get asignarMaterias => 'Asignar Materias';

  @override
  String get cursoSinMaterias => 'Este curso no tiene materias asignadas';

  @override
  String get marcarTodos => 'Marcar todos';

  @override
  String get desmarcarTodos => 'Desmarcar todos';

  @override
  String get atras => 'Atrás';

  @override
  String get matricular => 'Matricular';

  @override
  String get anadirCursoModalidad => 'Añadir curso a esta modalidad';

  @override
  String get etapaActualIncidencia =>
      'Selecciona la etapa actual de esta incidencia';

  @override
  String get buscarPorTituloDesc => 'Buscar por título o descripción...';

  @override
  String get topAlumnosIncidencias => 'Top Alumnos con Incidencias';

  @override
  String get noHayIncidencias => 'No hay incidencias registradas';

  @override
  String get resolucionIncidencia => 'Resolución de Incidencia';

  @override
  String get esInvalida => 'ES INVÁLIDA';

  @override
  String get esValida => 'ES VÁLIDA';

  @override
  String get fechaPlaceholder => 'Fecha...';

  @override
  String get materia => 'Materia';

  @override
  String get seleccionarMateria => 'Seleccionar materia';

  @override
  String docenteConNombreLabel(String nombre) {
    return 'Docente: $nombre';
  }

  @override
  String get siguienteLabel => 'Siguiente';

  @override
  String get cambiarPasswordTitulo => 'Cambiar Contraseña';

  @override
  String get cambiarPasswordDesc => 'Introduce tu contraseña actual y la nueva';

  @override
  String get dialogContrasenyaActual => 'Contraseña Actual';

  @override
  String get dialogNovaContrasenya => 'Nueva Contraseña';

  @override
  String get dialogConfirmarNovaContrasenya => 'Confirmar Nueva Contraseña';

  @override
  String get notificacionesTitulo => 'Notificaciones';

  @override
  String get marcarTodas => 'Marcar todas';

  @override
  String get noHayNotificaciones => 'No hay notificaciones';

  @override
  String get reglamentoCentro => 'REGLAMENTO DEL CENTRO';

  @override
  String get normativaVigente => 'NORMATIVA VIGENTE';

  @override
  String get versionActualizada => 'Versión Actualizada';

  @override
  String paginaNoEncontrada(String uri) {
    return 'Página no encontrada: $uri';
  }

  @override
  String get irAlInicio => 'Ir al inicio';

  @override
  String get tabTotes => 'TODAS';

  @override
  String get tabObert => 'ABIERTO';

  @override
  String get tabEnProces => 'EN PROCESO';

  @override
  String get tabTancat => 'CERRADO';

  @override
  String get filtreCurs => 'Curso';

  @override
  String get filtreAlumne => 'Alumno';

  @override
  String get filtreProfessor => 'Profesor';

  @override
  String get filtrarPorAlumno => 'Filtrar por alumno...';

  @override
  String get filtrarPorProfesor => 'Filtrar por profesor...';

  @override
  String get todosAlumnos => 'Todos los Alumnos';

  @override
  String get todosProfesores => 'Todos los Profesores';

  @override
  String get todos => 'Todos';

  @override
  String get incidenciaPendiente => 'PENDIENTE';

  @override
  String get resValida => 'VÁLIDA';

  @override
  String get resInvalida => 'INVÁLIDA';

  @override
  String get incidenciasEsInvalida => 'ES INVÁLIDA';

  @override
  String get incidenciaConfirmacioText =>
      'Tras la investigación realizada, ¿se confirma que la incidencia es verídica y amerita sanción?';

  @override
  String get topAlumnesIncidencies => 'Top Alumnos con Incidencias';

  @override
  String get alertesTotals => 'ALERTAS TOTALES';

  @override
  String get incidenciaSeveridadLeve => 'Leve';

  @override
  String get incidenciaSeveridadGrave => 'Grave';

  @override
  String get incidenciaSeveridadMuyGrave => 'Muy Grave';

  @override
  String get adminCursosCalendario => 'Calendario Escolar';

  @override
  String get adminCursosVerOtrosAnios => 'Ver otros años';

  @override
  String get adminCursosAniadirCurso => 'Añadir Curso';

  @override
  String get adminCursosTurnoPartido => 'Partido (P)';

  @override
  String get adminCursosTurnoManana => 'Mañana (M)';

  @override
  String get adminCursosTurnoTarde => 'Tarde (T)';

  @override
  String get adminCursosTurnoNocturno => 'Nocturno (N)';

  @override
  String get statPresentes => 'Pres.';

  @override
  String get statAusentes => 'Aus.';

  @override
  String get statRetrasos => 'Retr.';

  @override
  String get diaSabado => 'Sábado';

  @override
  String get diaDomingo => 'Domingo';

  @override
  String asistenciaAlumnoIndex(int index, int total) {
    return 'Alumno $index de $total';
  }

  @override
  String get asistenciaHoraLabel => 'Hora';

  @override
  String get asistenciaCursoLabel => 'Curso';
}
