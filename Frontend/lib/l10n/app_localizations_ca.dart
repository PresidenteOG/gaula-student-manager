// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'GAULA — Gestió d\'Aules';

  @override
  String get loading => 'Carregant...';

  @override
  String get errorGenerico => 'Error';

  @override
  String get reintentar => 'Torna-ho a provar';

  @override
  String get guardar => 'Desar';

  @override
  String get cancelar => 'Cancel·lar';

  @override
  String get cerrar => 'Tancar';

  @override
  String get volver => 'Tornar';

  @override
  String get confirmar => 'Confirmar';

  @override
  String get buscar => 'Cercar';

  @override
  String get buscarPlaceholder => 'Cerca...';

  @override
  String get sinDatos => 'Sense dades disponibles.';

  @override
  String get aceptar => 'Acceptar';

  @override
  String get eliminar => 'Eliminar';

  @override
  String get justificar => 'Justificar';

  @override
  String get editar => 'Editar';

  @override
  String get crear => 'Crear';

  @override
  String get agregar => 'Afegir';

  @override
  String get ver => 'Veure';

  @override
  String get exportar => 'Exportar';

  @override
  String get importar => 'Importar';

  @override
  String get actualizar => 'Actualitzar';

  @override
  String pagina(int actual, int total) {
    return 'Pàgina $actual de $total';
  }

  @override
  String get navInicio => 'Inici';

  @override
  String get navAsistencia => 'Assistència';

  @override
  String get navCalendario => 'Calendari';

  @override
  String get navAlumnos => 'Alumnes';

  @override
  String get navProfesores => 'Professors';

  @override
  String get navCursos => 'Cursos';

  @override
  String get navIncidencias => 'Incidències';

  @override
  String get navReglamento => 'Reglament';

  @override
  String get navCerrarSesion => 'Tancar sessió';

  @override
  String get navResumen => 'Resum';

  @override
  String get navPlanesEstudios => 'Plans d\'Estudis';

  @override
  String get navConfiguracion => 'Configuració';

  @override
  String get navCopiaSeguridad => 'Còpia de Seguretat';

  @override
  String get navMiHorario => 'El meu Horari';

  @override
  String get navNormasCentro => 'Normes del Centre';

  @override
  String get navHistorialClases => 'Historial de Classes';

  @override
  String get navMiPerfil => 'El meu Perfil';

  @override
  String get navAjustes => 'Ajustos';

  @override
  String get navMiAsistencia => 'La meva Assistència';

  @override
  String get navHistorial => 'Historial';

  @override
  String get navMiFicha => 'La meva Fitxa';

  @override
  String get navMisIncidencias => 'Les meves Incidències';

  @override
  String get navPasarLista => 'Passar llista';

  @override
  String get rolAdministrador => 'ADMINISTRADOR';

  @override
  String get rolProfesor => 'PROFESSOR';

  @override
  String get rolAlumno => 'ALUMNE';

  @override
  String get shellAdminTitulo => 'Panell Administratiu';

  @override
  String get shellAdminSubtitulo => 'Gestió Central GAULA';

  @override
  String get shellAdminTituloMovil => 'GAULA Admin';

  @override
  String get shellTeacherTitulo => 'Portal Docent';

  @override
  String get shellTeacherSubtitulo => 'Gestió Educativa GAULA';

  @override
  String get shellTeacherTituloMovil => 'GAULA Docent';

  @override
  String get shellStudentSubtitulo => 'Panell d\'Alumne';

  @override
  String saludoHola(String nombre) {
    return 'Hola, $nombre';
  }

  @override
  String get sinNotificaciones => 'No hi ha notificacions';

  @override
  String get loginTitulo => 'Iniciar sessió';

  @override
  String get loginUsuario => 'Usuari';

  @override
  String get loginContrasena => 'Contrasenya';

  @override
  String get loginBoton => 'Entrar';

  @override
  String get loginErrorCredenciales => 'Usuari o contrasenya incorrectes.';

  @override
  String get loginErrorConexion =>
      'Error de connexió. El servidor està en marxa?';

  @override
  String get dashClasesHoy => 'Classes avui';

  @override
  String get dashAlumnosTotales => 'Alumnes totals';

  @override
  String get dashIncidenciasHoy => 'Incidències avui';

  @override
  String get dashAsistenciaMedia => 'Assistència mitja';

  @override
  String get dashAsistenciaTotal => 'Assistència total';

  @override
  String get dashAusencias => 'Absències';

  @override
  String get dashRetrasos => 'Retards';

  @override
  String get dashHorasFaltadas => 'Hores Faltades';

  @override
  String get dashClasesTotales => 'Classes Totals';

  @override
  String get seccionListasPendientes => 'Llistes Pendents';

  @override
  String get todoAlDia => 'Tot al dia 🎉';

  @override
  String get seccionProximasClases => 'Properes Classes';

  @override
  String get sinClasesHoy => 'No tens classes avui';

  @override
  String get sinClasesProximas => 'No tens classes properes ara';

  @override
  String get accesRapido => 'Accés Ràpid';

  @override
  String get irAPasarLista => 'Anar a Passar Llista';

  @override
  String proximaClaseLabel(String materia) {
    return 'Propera: $materia';
  }

  @override
  String aulaHoraLabel(String aula, String horaInicio, String horaFin) {
    return 'Aula: $aula • $horaInicio - $horaFin';
  }

  @override
  String get errorCargarProximaClase => 'Error carregant la propera classe';

  @override
  String get misClasesHoy => 'Les meves Classes d\'Avui';

  @override
  String get horarioCompleto => 'Horari Complet';

  @override
  String get cargandoHorario => 'Carregant horari...';

  @override
  String get errorCargandoHorario => 'Error carregant l\'horari';

  @override
  String get sinClasesHoyAlumno => 'No tens classes programades per avui';

  @override
  String get saludoEstudiante => 'Estudiant';

  @override
  String get saludoProfesor => 'Professor';

  @override
  String get historialTitulo => 'Historial de Classes';

  @override
  String get historialSubtitulo =>
      'Registre complet de totes les teves sessions de classe';

  @override
  String get historialVacio => 'Encara no hi ha historial de classes';

  @override
  String get historialVacioDesc =>
      'El teu historial d\'assistència apareixerà aquí quan el professor passi llista';

  @override
  String get fechaHoy => 'Avui';

  @override
  String get asistenciaTitulo => 'La meva assistència';

  @override
  String get asistenciaMaterias => 'Matèries';

  @override
  String get asistenciaRegistro => 'Registre';

  @override
  String get asistenciaAusente => 'Absent';

  @override
  String get asistenciaRetraso => 'Retard';

  @override
  String get asistenciaJustificado => 'Justificat';

  @override
  String get asistenciaPresente => 'Present';

  @override
  String get asistenciaSinFaltas => 'Sense registres de faltes o retards.';

  @override
  String get asistenciaPasarLista => 'Passar llista';

  @override
  String get estadoPresente => 'PRESENT';

  @override
  String get estadoAusente => 'ABSENT';

  @override
  String get estadoRetraso => 'RETARD';

  @override
  String get estadoJustificado => 'JUSTIFICAT';

  @override
  String get estadoActivo => 'ACTIU';

  @override
  String get estadoInactivo => 'INACTIU';

  @override
  String get estadoMatriculado => 'MATRICULAT';

  @override
  String get estadoAbierto => 'OBERT';

  @override
  String get estadoEnProceso => 'EN PROCÉS';

  @override
  String get estadoCerrado => 'TANCAT';

  @override
  String get calendarioTitulo => 'Calendari de Festius';

  @override
  String get calendarioSubtitulo =>
      'Dies no lectius i festivitats acadèmiques sincronitzades';

  @override
  String get calendarioProximosDias => 'PROPERS DIES';

  @override
  String get calendarioConfigurarRegion => 'CONFIGURAR REGIÓ';

  @override
  String get calendarioSincronizar => 'Sincronitzar festius';

  @override
  String get calendarioSinFestivos =>
      'No hi ha festius registrats per a aquest període.';

  @override
  String get calendarioNacional => 'Nacional';

  @override
  String get calendarioAutonomico => 'Autonòmic';

  @override
  String get seleccionarCurso => 'Seleccionar curs';

  @override
  String get seleccionarCursoDesc =>
      'Selecciona un curs per veure les matèries disponibles avui.';

  @override
  String get seleccionarMateriaDesc =>
      'Selecciona la matèria per veure les seves sessions.';

  @override
  String get seleccionarSesionDesc =>
      'Selecciona la sessió exacta per passar llista.';

  @override
  String get sinSesionesHoy => 'No hi ha sessions per a avui.';

  @override
  String get sinMaterias => 'No hi ha matèries en aquest curs.';

  @override
  String get sinCursos => 'No s\'han trobat cursos.';

  @override
  String get volverMisClases => 'Tornar a les meves classes';

  @override
  String get modoUnoEnUno => 'Un per un';

  @override
  String get modoClasico => 'Clàssic';

  @override
  String get perfilFoto => 'Foto de perfil';

  @override
  String get perfilCambiarFoto => 'Canviar foto';

  @override
  String get errorServidor =>
      'Error del servidor. Torna-ho a intentar més tard.';

  @override
  String get mantenimiento =>
      'El servidor està en manteniment. Torna a intentar-ho en uns minuts.';

  @override
  String get alumnosTitulo => 'Alumnes';

  @override
  String get alumnoNuevo => 'Nou Alumne';

  @override
  String get alumnoEditar => 'Editar Alumne';

  @override
  String get alumnoRegistrado => 'Alumne registrat correctament';

  @override
  String get alumnoActualizado => 'Alumne actualitzat correctament';

  @override
  String get alumnoEliminado => 'Alumne eliminat correctament';

  @override
  String get errorRegistrarAlumno => 'Error en registrar l\'alumne';

  @override
  String get alumnoNombre => 'Nom';

  @override
  String get alumnoApellidos => 'Cognoms';

  @override
  String get alumnoEmail => 'Correu electrònic';

  @override
  String get alumnoDni => 'DNI';

  @override
  String get alumnoUsuario => 'Usuari';

  @override
  String get alumnoContrasena => 'Contrasenya';

  @override
  String get alumnoCurso => 'Curs';

  @override
  String get alumnoSinCurso => 'Sense assignar';

  @override
  String get alumnoSinMatricular => 'Sense matricular';

  @override
  String get profesoresTitulo => 'Professors';

  @override
  String get profesorNuevo => 'Nou Professor';

  @override
  String get profesorEditar => 'Editar Professor';

  @override
  String get profesorRegistrado => 'Professor registrat correctament';

  @override
  String get profesorActualizado => 'Professor actualitzat correctament';

  @override
  String get profesorEliminado => 'Professor eliminat correctament';

  @override
  String get cursosTitulo => 'Cursos';

  @override
  String get cursoNuevo => 'Crear Nou Curs';

  @override
  String get cursoEliminar => 'Eliminar Curs';

  @override
  String get cursoEliminadoOk => 'Curs eliminat correctament';

  @override
  String get cursoEliminadoError =>
      'Error en eliminar el curs. Comproveu si té dependències actives.';

  @override
  String get cursoConAlumnos =>
      'No es pot eliminar un curs que té alumnes matriculats.';

  @override
  String cursoConfirmarEliminar(String codigo) {
    return 'Esteu segur que voleu eliminar el curs $codigo? Aquesta acció també eliminarà les matèries i l\'horari associat.';
  }

  @override
  String matriculacionTitulo(int count) {
    return 'Matriculació d\'Alumnes ($count)';
  }

  @override
  String get buscarAlumnos => 'Cerca alumnes per nom...';

  @override
  String get incidenciasTitulo => 'Incidències';

  @override
  String get incidenciasAbiertaDesc => 'Nova incidència pendent de revisió';

  @override
  String get incidenciasCerradaDesc => 'Incidència resolta i arxivada';

  @override
  String get incidenciasCursoGrupo => 'CURS/GRUP';

  @override
  String get incidenciasDescripcionHechos => 'DESCRIPCIÓ DELS FETS';

  @override
  String get incidenciasAlumnoLabel => 'ALUMNE';

  @override
  String get incidenciasProfesorResponsable => 'PROFESSOR RESPONSABLE';

  @override
  String get incidenciasEsValida => 'ÉS VÀLIDA';

  @override
  String get incidenciasEnProcesoDesc =>
      'S\'estan prenent mesures disciplinàries';

  @override
  String get incidenciasSistemaLimpio =>
      'El sistema està net per als filtres seleccionats';

  @override
  String get incidenciaNueva => 'Nova Incidència';

  @override
  String get horarioTitulo => 'Horari';

  @override
  String get planEstudiosTitulo => 'Plans d\'Estudis';

  @override
  String get alumnosTituloTeacher => 'Els meus Alumnes';

  @override
  String get fichaAlumnoTitulo => 'Fitxa de l\'Alumne';

  @override
  String get ajustesTitulo => 'Ajustos';

  @override
  String get idioma => 'Idioma';

  @override
  String get tema => 'Tema';

  @override
  String get temaClaroOscuro => 'Clar / Fosc';

  @override
  String get sinAlumnos => 'No hi ha alumnes en aquest curs';

  @override
  String get sinProfesores => 'No hi ha professors registrats';

  @override
  String get sinIncidencias => 'No hi ha incidències registrades';

  @override
  String get confirmarEliminar => 'Confirmar eliminació';

  @override
  String get accionNoDeshacer => 'Aquesta acció no es pot desfer.';

  @override
  String get errorConexion => 'Error de connexió';

  @override
  String get reintentarBoton => 'Tornar a intentar';

  @override
  String get horarioAlumno => 'Horari de l\'Alumne';

  @override
  String get horarioMio => 'El meu Horari Escolar';

  @override
  String get horarioProfesor => 'Horari del Professor';

  @override
  String get horarioAlumnoSubtitulo =>
      'Visualitzant la planificació setmanal de l\'alumne.';

  @override
  String get horarioAlumnoSubtituloPropio =>
      'Visualitza la teva planificació setmanal completa.';

  @override
  String get horarioProfesorSubtitulo =>
      'Gestiona sessions setmanals i esdeveniments.';

  @override
  String get horarioDescanso => 'DESCANS';

  @override
  String get horarioEventosAsignacion =>
      'Assignació d\'Esdeveniments i Exàmens';

  @override
  String get horarioTipoEvento => 'Tipus d\'Esdeveniment';

  @override
  String get horarioFecha => 'Data';

  @override
  String get horarioDescripcionLabel => 'Descripció';

  @override
  String get horarioFechaPlaceholder => 'Seleccionar Data';

  @override
  String get horarioDescPlaceholder => 'Ex. Examen Final DAW';

  @override
  String get horarioEventoAniadido => 'Esdeveniment afegit correctament';

  @override
  String get horarioSinClases => 'No hi ha classes programades.';

  @override
  String horarioErrorCargar(Object error) {
    return 'Error en carregar l\'horari: $error';
  }

  @override
  String horarioAsignarEvento(String fecha) {
    return 'Assignar Esdeveniment: $fecha';
  }

  @override
  String horarioEventosDia(String fecha) {
    return 'Esdeveniments: $fecha';
  }

  @override
  String get horarioSinEventos => 'No hi ha esdeveniments assignats.';

  @override
  String get horarioDescripcionEvento => 'Descripció de l\'Esdeveniment';

  @override
  String get horarioAulaDefault => 'Aula 101';

  @override
  String get fichaVolverAlumnos => 'Tornar als alumnes';

  @override
  String get fichaSinGrupo => 'Sense grup';

  @override
  String get fichaTelefono => 'Telèfon';

  @override
  String get fichaNoEspecificado => 'No especificat';

  @override
  String get fichaDireccion => 'Adreça';

  @override
  String get fichaSinDireccion => 'Sense adreça';

  @override
  String get fichaEstadisticasAsistencia => 'Estadístiques d\'Assistència';

  @override
  String get fichaDesgloseModulo => 'Desglossament per Mòdul';

  @override
  String get fichaSinDatosModulo => 'No hi ha dades per mòdul registrades.';

  @override
  String get fichaAsistencia => 'Assistència';

  @override
  String get fichaFaltas => 'Faltes';

  @override
  String get fichaRetrasos => 'Retards';

  @override
  String get fichaJustificadas => 'Justificades';

  @override
  String get fichaTotalClases => 'Total Classes';

  @override
  String get fichaHorasFaltadas => 'Hores Faltades';

  @override
  String get fichaRiesgo => 'RISC';

  @override
  String get fichaLimiteExcedido => 'LÍMIT EXCEDIT';

  @override
  String fichaFaltasDetalle(String total, int max) {
    return 'Faltes: $total / $max màx.';
  }

  @override
  String fichaAsistencias(int presentes, int total) {
    return '$presentes/$total assistides';
  }

  @override
  String get fichaVerHorario => 'Veure Horari Complet';

  @override
  String get fichaCrearIncidencia => 'Crear Incidència';

  @override
  String fichaHorarioDe(String nombre) {
    return 'Horari de $nombre';
  }

  @override
  String get fichaRegistroAsistencia => 'Registre d\'Assistència';

  @override
  String fichaFaltasDe(String nombre) {
    return 'Faltes de $nombre';
  }

  @override
  String fichaRetrasosDe(String nombre) {
    return 'Retards de $nombre';
  }

  @override
  String fichaJustificadasDe(String nombre) {
    return 'Faltes justificades de $nombre';
  }

  @override
  String fichaErrorHistorial(Object error) {
    return 'Error en carregar l\'historial: $error';
  }

  @override
  String get fichaSinRegistros => 'No hi ha registres d\'aquest tipus.';

  @override
  String fichaRegistradoPor(String nombre) {
    return 'Registrat per: $nombre';
  }

  @override
  String get fichaSinFecha => 'Sense data';

  @override
  String get alumnosTituloDesc =>
      'Gestió centralitzada de l\'expedient acadèmic i l\'assistència';

  @override
  String get matricularAlumno => 'Matricular Alumne';

  @override
  String get todosCursos => 'Tots els Cursos';

  @override
  String get sinAlumnosEncontrados => 'No s\'han trobat alumnes registrats';

  @override
  String get confirmarBaja => 'Confirmar Baixa';

  @override
  String get activarAlumno => 'Activar Alumne';

  @override
  String get darDeBaja => 'Donar de Baixa';

  @override
  String get reporteAsistenciaLabel => 'Informe d\'Assistència';

  @override
  String get editarExpediente => 'Editar Expedient';

  @override
  String get profesoresTituloDesc =>
      'Gestió integral del claustre i el personal administratiu';

  @override
  String get registrarNuevoProfesor => 'Registrar Nou';

  @override
  String get buscarProfesoresHint => 'Cercar professors...';

  @override
  String get buscarProfesoresDetalle =>
      'Cercar per nom, especialitat o departament...';

  @override
  String get filtrarPorCurso => 'Filtrar per curs...';

  @override
  String get filtrarPorRol => 'Filtrar per rol...';

  @override
  String get todosRoles => 'Tots els Rols';

  @override
  String get docenteLabel => 'Docent';

  @override
  String get cuerpoDocenteLabel => 'COS DOCENT';

  @override
  String get directivaAdminLabel => 'DIRECTIVA / ADM.';

  @override
  String get horarioSemanalReal => 'HORARI SETMANAL REAL';

  @override
  String get filtrarCursoMateria => 'Filtrar per curs o matèria...';

  @override
  String get sinClasesHorarioProfesor =>
      'No hi ha classes assignades a l\'horari setmanal';

  @override
  String get sinProfesoresEncontrados =>
      'No s\'han trobat professors amb els filtres aplicats';

  @override
  String get gestionar => 'Gestionar';

  @override
  String get sesionLabel => 'SESSIÓ';

  @override
  String get incidenciasTituloDesc =>
      'Control disciplinari, convivència i alertes primerenques';

  @override
  String get registrarIncidencia => 'Registrar Incidència';

  @override
  String get actualizarEstado => 'Actualitzar Estat';

  @override
  String get eliminarRegistro => 'Eliminar Registre';

  @override
  String get incidenciaEliminadaDesc =>
      'Aquesta acció és permanent i no es podrà recuperar la informació d\'aquesta incidència.';

  @override
  String get planEstudiosTituloDesc =>
      'Gestió curricular i plans d\'estudis del centre';

  @override
  String get cursosTituloDesc => 'Gestió de grups i matriculació d\'alumnes';

  @override
  String get authPwdOlvidasteTitulo => 'Has oblidat la teva contrasenya?';

  @override
  String get authPwdOlvidasteDesc =>
      'Introdueix el teu correu electrònic i t\'enviarem un codi de recuperació.';

  @override
  String get authPwdCorreoHint => 'Correu electrònic';

  @override
  String get authPwdEnviarCodigo => 'ENVIAR CODI';

  @override
  String get authPwdVolverLogin => 'Tornar al Login';

  @override
  String authPwdError(Object error) {
    return 'Error: $error';
  }

  @override
  String get authPwdNoCoinciden => 'Les contrasenyes no coincideixen';

  @override
  String get authPwdActualizadaOk => '✅ Contrasenya actualitzada correctament';

  @override
  String get authPwdRestablecerTitulo => 'Restablir Contrasenya';

  @override
  String get authPwdRestablecerDesc =>
      'Introdueix el codi que has rebut i la teva nova contrasenya.';

  @override
  String get authPwdCodigoHint => 'CODI';

  @override
  String get authPwdNuevaContrasena => 'Nova Contrasenya';

  @override
  String get authPwdConfirmarContrasena => 'Confirmar Contrasenya';

  @override
  String get authPwdActualizar => 'ACTUALITZAR CONTRASENYA';

  @override
  String get authMantTitulo => 'Servidor en Manteniment';

  @override
  String get authMantDesc =>
      'Estem realitzant millores al sistema per oferir-te un millor servei.\nSi us plau, torna-ho a intentar en uns minuts.';

  @override
  String get authMantReintentar => 'REINTENTAR CONNEXIÓ';

  @override
  String get authDevAutocompletar => 'Autocompletar login (només devs)';

  @override
  String get authPwdOlvidasteLink => 'Has oblidat la teva contrasenya?';

  @override
  String get horarioEventoExamen => 'Examen';

  @override
  String get horarioEventoEvaluacion => 'Avaluació';

  @override
  String get horarioEventoPresentacion => 'Presentació';

  @override
  String get horarioEventoReunion => 'Reunió';

  @override
  String get horarioEventoFestivo => 'Festiu';

  @override
  String get horarioFechaLabel => 'Data';

  @override
  String get diaLunes => 'Dilluns';

  @override
  String get diaMartes => 'Dimarts';

  @override
  String get diaMiercoles => 'Dimecres';

  @override
  String get diaJueves => 'Dijous';

  @override
  String get diaViernes => 'Divendres';

  @override
  String get userProfileGuardado => 'Canvis desats correctament';

  @override
  String get userProfileMisDatos => 'Les meves Dades';

  @override
  String get userProfileSubtitulo =>
      'Gestiona la teva informació personal i professional.';

  @override
  String get userProfileFotoActualizada => 'Foto actualitzada correctament';

  @override
  String get userProfileInfoPersonal => 'Informació Personal';

  @override
  String get userProfileNombreCompleto => 'Nom Complet';

  @override
  String get userProfileDniNie => 'DNI/NIE';

  @override
  String get userProfileFechaNacimiento => 'Data Naixement';

  @override
  String get userProfileInfoContacto => 'Informació de Contacte';

  @override
  String get userProfileTelefono => 'Telèfon';

  @override
  String get userProfileDireccion => 'Adreça';

  @override
  String get userProfileSeguridad => 'Seguretat';

  @override
  String get userProfileSeguridadDesc =>
      'Protegeix el teu compte actualitzant la teva contrasenya regularment.';

  @override
  String get userProfileCambiarPassword => 'Canviar Contrasenya';

  @override
  String studentAsisError(Object error) {
    return 'Error: $error';
  }

  @override
  String get studentAsisDesconocido => 'Desconegut';

  @override
  String studentAsisFaltas(Object max, Object total) {
    return 'Faltes: $total / $max màx';
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
  String get studentAsisProgresoClases => 'Progrés de Classes';

  @override
  String get studentFichaDatosDesc =>
      'Dades personals i acadèmiques de la teva matrícula';

  @override
  String get studentFichaRolAlumno => 'ALUMNE';

  @override
  String get studentFichaDatosPersonales => 'Dades Personals';

  @override
  String get studentFichaDniNie => 'DNI / NIE';

  @override
  String get studentFichaTelefono => 'Telèfon';

  @override
  String get studentFichaDireccion => 'Adreça';

  @override
  String get studentFichaFechaNacimiento => 'Data de Naixement';

  @override
  String get studentFichaDatosAcademicos => 'Dades Acadèmiques';

  @override
  String get studentFichaGrupo => 'Grup';

  @override
  String get studentFichaEstadoMatricula => 'Estat de Matrícula';

  @override
  String get studentFichaMateriasMatriculadas => 'Matèries Matriculades';

  @override
  String studentFichaModulos(Object count) {
    return '$count mòduls';
  }

  @override
  String get studentFichaMatriculado => 'MATRICULAT';

  @override
  String get studentFichaAlumno => 'Alumne';

  @override
  String get studentFichaOfflineDesc =>
      'Sense connexió. Mostrant les dades bàsiques del teu perfil.';

  @override
  String get teacherAlumnosAnterior => 'Anterior';

  @override
  String get teacherAlumnosSiguiente => 'Següent';

  @override
  String get teacherAlumnosSinGrupo => 'Sense grup';

  @override
  String get teacherAlumnosAsistencia => 'Assistència';

  @override
  String get teacherAlumnosFaltas => 'Faltes';

  @override
  String get teacherSettingsSubtitulo =>
      'Personalitza la teva experiència a la plataforma GAULA';

  @override
  String get teacherSettingsPerfilUsuario => 'Perfil d\'Usuari';

  @override
  String get teacherSettingsPerfilDesc =>
      'Gestiona la teva informació personal';

  @override
  String get teacherSettingsVerPerfil => 'Veure Perfil';

  @override
  String get teacherSettingsEditarPerfil => 'Editar Perfil';

  @override
  String get teacherSettingsSeguridad => 'Seguretat';

  @override
  String get teacherSettingsSeguridadDesc =>
      'Protegeix el teu accés al sistema';

  @override
  String get teacherSettingsCambiarPass => 'Canviar Contrasenya';

  @override
  String get teacherSettingsSesionesActivas => 'Sessions Actives';

  @override
  String get teacherSettingsSeguridadProximamente =>
      'Funcionalitat de seguretat pròximament';

  @override
  String get teacherSettingsNotificaciones => 'Notificacions';

  @override
  String get teacherSettingsNotificacionesDesc =>
      'Configura les alertes i avisos';

  @override
  String get teacherSettingsAlertasAsistencia => 'Alertes d\'Assistència';

  @override
  String get teacherSettingsMensajesAlumnos => 'Missatges d\'Alumnes';

  @override
  String get teacherSettingsPreferencias => 'Preferències';

  @override
  String get teacherSettingsPreferenciasDesc => 'Ajustos de visualització';

  @override
  String get teacherSettingsSoporte => 'Suport i Ajuda';

  @override
  String get teacherSettingsSoporteDesc => 'Recursos d\'assistència';

  @override
  String get teacherSettingsNormasCentro => 'Normes del Centre';

  @override
  String get teacherSettingsContactarSoporte => 'Contactar Suport';

  @override
  String get teacherSettingsContactandoSoporte =>
      'Contactant amb suport tècnic...';

  @override
  String get teacherSettingsVersion => 'GAULA • Desenvolupat per VicePresi';

  @override
  String get teacherSettingsCopyright => '© 2026 Sistema de Gestió Educativa';

  @override
  String get teacherSettingsNotifPush => 'Notificacions Push';

  @override
  String get teacherSettingsNotifEmail => 'Notificacions per Email';

  @override
  String adminDashErrorMetricas(String error) {
    return 'Error en carregar mètriques: $error';
  }

  @override
  String get adminDashDocentes => 'Docents';

  @override
  String get adminDashTrendEstable => 'Estable';

  @override
  String get adminUsuariosErrorRedTitulo => 'Error de xarxa';

  @override
  String get adminUsuariosErrorRedMsg =>
      'No s\'ha pogut connectar amb el servidor';

  @override
  String get adminUsuariosTitulo => 'Gestió d\'Usuaris';

  @override
  String get adminUsuariosMonitorTiempoReal => 'MONITOR EN TEMPS REAL';

  @override
  String get adminUsuariosTotal => 'Total';

  @override
  String get adminUsuariosRol => 'Rol...';

  @override
  String get adminUsuariosEstado => 'Estat...';

  @override
  String get attendanceScheduleMyClasses => 'Les meves Classes';

  @override
  String get attendanceScheduleOtherClass => 'Passar Llista d\'Altra Classe';

  @override
  String get attendanceScheduleTodaySchedule => 'Horari d\'Avui';

  @override
  String attendanceSchedulePendingClasses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'classes pendents',
      one: 'classe pendent',
    );
    return 'Tens $count $_temp0 de passar llista';
  }

  @override
  String get attendanceScheduleNoClassesToday =>
      'No hi ha classes programades per avui.';

  @override
  String get attendanceScheduleHistory => 'Historial';

  @override
  String get attendanceScheduleSearchByDate => 'Cercar per data...';

  @override
  String get attendanceScheduleNoHistory =>
      'No hi ha historial d\'assistència.';

  @override
  String get attendanceScheduleTakeAttendance => 'Passar Llista';

  @override
  String get attendanceScheduleCompleted => 'Completat';

  @override
  String get attendanceScheduleSelectCourse => 'Seleccionar Curs';

  @override
  String get attendanceScheduleSelectCourseHint =>
      'Selecciona un curs per veure les seves matèries disponibles avui.';

  @override
  String get attendanceScheduleSearchCourse => 'Cercar per nom o codi...';

  @override
  String attendanceScheduleErrorLoadingYears(String error) {
    return 'Error en carregar anys: $error';
  }

  @override
  String get attendanceScheduleNoCourses => 'No s\'han trobat cursos.';

  @override
  String get attendanceScheduleSelectSubjectHint =>
      'Selecciona la matèria per veure les seves sessions.';

  @override
  String get attendanceScheduleNoSubjects =>
      'No hi ha matèries en aquest curs.';

  @override
  String get attendanceScheduleSubjectFallback => 'Matèria';

  @override
  String get attendanceScheduleSelectSessionHint =>
      'Selecciona la sessió exacta per passar llista.';

  @override
  String get attendanceScheduleNoSessionsToday => 'No hi ha sessions per avui.';

  @override
  String get attendanceScheduleSessionsFallback => 'Sessions';

  @override
  String get attendanceScheduleAulaFallback => 'Aula';

  @override
  String get attendanceDetailRegisteredBy => 'REGISTRAT PER:';

  @override
  String get attendanceDetailSystemAuto => 'SISTEMA / AUTOMÀTIC';

  @override
  String get attendanceDetailPresent => 'PRESENTS';

  @override
  String get attendanceDetailAbsent => 'ABSENTS';

  @override
  String get attendanceDetailAttendance => 'ASSISTÈNCIA';

  @override
  String get attendanceDetailStudentList => 'LLISTAT DE FALTES';

  @override
  String get attendanceDetailNoRecords =>
      'No hi ha registres d\'assistència per a aquesta sessió.';

  @override
  String get attendanceDetailStudentFallback => 'Alumne';

  @override
  String get attendanceDetailStatusPresente => 'PRESENT';

  @override
  String get attendanceDetailStatusAusente => 'ABSENT';

  @override
  String get attendanceDetailStatusRetraso => 'RETARD';

  @override
  String get attendanceDetailStatusJustificado => 'JUSTIFICAT';

  @override
  String get attendanceDetailStatusPendiente => 'PENDENT';

  @override
  String get adminAuditoriaTitle => 'Registre d\'Auditoria';

  @override
  String get adminAuditoriaSubtitle =>
      'Traçabilitat completa d\'accions administratives';

  @override
  String get adminAuditoriaEmpty => 'SENSE REGISTRES D\'ACTIVITAT';

  @override
  String get adminConfigTitle => 'CONFIGURACIÓ';

  @override
  String get adminConfigSubtitle =>
      'Gestiona els paràmetres globals i manteniment';

  @override
  String get adminConfigSecurityTitle => 'Seguretat i Accés';

  @override
  String get adminConfigSecurityDesc => 'Control de credencials i sessions';

  @override
  String get adminConfigSecurityChangePassword => 'Canviar Contrasenya';

  @override
  String get adminConfigSecurityActiveSessions => 'Sessions Actives';

  @override
  String get adminConfigSecurity2FA => 'Doble Factor (2FA)';

  @override
  String get adminConfigReglamentoTitle => 'Reglament del Centre';

  @override
  String get adminConfigReglamentoDesc => 'Normativa i convivència escolar';

  @override
  String get adminConfigReglamentoEdit => 'Editar Reglament';

  @override
  String get adminConfigReglamentoHistory => 'Historial de Versions';

  @override
  String get adminConfigReglamentoPublish => 'Publicar Canvis';

  @override
  String get adminConfigAuditoriaTitle => 'Auditoria de Canvis';

  @override
  String get adminConfigAuditoriaDesc => 'Registre d\'activitat administrativa';

  @override
  String get adminConfigAuditoriaViewLog => 'Veure Log d\'Activitat';

  @override
  String get adminConfigAuditoriaExport => 'Exportar Informe';

  @override
  String get adminConfigAuditoriaAlerts => 'Alertes d\'Auditoria';

  @override
  String get adminConfigComingSoon => 'AVIAT';

  @override
  String get adminPermTitle => 'Matriu RBAC';

  @override
  String get adminPermSubtitle => 'Control granular de seguretat i accessos';

  @override
  String get adminPermSyncButton => 'SINCRONITZAR POLÍTIQUES';

  @override
  String get adminPermColRolPerfil => 'ROL / PERFIL';

  @override
  String get adminPermPermGestionAcademica => 'Gestió Acadèmica';

  @override
  String get adminPermPermPasarLista => 'Passar Llista';

  @override
  String get adminPermPermVerHistorial => 'Veure Historial';

  @override
  String get adminPermPermCrearIncidencias => 'Crear Incidències';

  @override
  String get adminPermPermBorrarRegistros => 'Esborrar Registres';

  @override
  String get adminPermPermConfigurarSistema => 'Configurar Sistema';

  @override
  String get adminPermPermEditarPerfiles => 'Editar Perfils';

  @override
  String get adminPermPermExportarDatos => 'Exportar Dades';

  @override
  String get adminPermToastSyncTitle => 'Matriu Sincronitzada';

  @override
  String get adminPermToastSyncMessage =>
      'Els permisos globals han estat actualitzats.';

  @override
  String get adminPermToastErrorTitle => 'Error';

  @override
  String get adminPermToastErrorMessage =>
      'No s\'ha pogut desar la configuració.';

  @override
  String adminPermErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get adminRolesTitle => 'Gestió de Rols';

  @override
  String get adminRolesSubtitle =>
      'Configuració de perfils i jerarquies de sistema';

  @override
  String get adminRolesSaveButton => 'DESAR CANVIS';

  @override
  String get adminRolesBadgeSystem => 'SISTEMA';

  @override
  String get adminRolesNewProfileTitle => 'Nou Perfil';

  @override
  String get adminRolesNewProfileDesc =>
      'Defineix un nou rol per a la gestió d\'usuaris.';

  @override
  String get adminRolesFieldLabel => 'NOM DEL ROL';

  @override
  String get adminRolesAddButton => 'AFEGIR ROL';

  @override
  String get adminRolesInfoBox =>
      'Assigna permisos a la Matriu després de crear el rol.';

  @override
  String get adminRolesToastSuccessTitle => 'Èxit';

  @override
  String get adminRolesToastSuccessMessage =>
      'Llista de rols actualitzada correctament.';

  @override
  String get adminRolesToastErrorTitle => 'Error';

  @override
  String get adminRolesToastErrorMessage =>
      'No s\'ha pogut desar la configuració.';

  @override
  String adminRolesErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get adminAnioTitulo => 'Anys Acadèmics';

  @override
  String get adminAnioSubtitulo => 'Gestiona els períodes escolars del centre.';

  @override
  String get adminAnioNuevo => 'Nou Any';

  @override
  String get adminAnioActivo => 'ACTIU';

  @override
  String adminAnioCursos(int n) {
    return '$n cursos';
  }

  @override
  String adminAnioMiembros(int n) {
    return '$n membres';
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
      'No es pot eliminar l\'any actiu';

  @override
  String get adminAnioTooltipNoEliminarAlumnos =>
      'No es pot eliminar (té alumnes)';

  @override
  String adminAnioErrorCargar(Object e) {
    return 'Error en carregar les dades: $e';
  }

  @override
  String get adminAnioReintentar => 'Reintentar';

  @override
  String get adminAnioVacio => 'No hi ha anys acadèmics registrats.';

  @override
  String get adminAnioCrearPrimero => 'Crear el primer';

  @override
  String get adminAnioDialogNuevo => 'Nou Any Acadèmic';

  @override
  String get adminAnioDialogEditar => 'Editar Any Acadèmic';

  @override
  String get adminAnioNombrePeriodo => 'Nom del període';

  @override
  String get adminAnioNombreHint => 'Ex. 2025-2026';

  @override
  String get adminAnioNombreObligatorio => 'Camp obligatori';

  @override
  String get adminAnioFechaInicio => 'Data d\'inici';

  @override
  String get adminAnioFechaFin => 'Data de fi';

  @override
  String get adminAnioSeleccionar => 'Seleccionar';

  @override
  String get adminAnioDescripcion => 'Descripció (opcional)';

  @override
  String get adminAnioDescripcionHint => 'Breu descripció del període';

  @override
  String get adminAnioCancelar => 'Cancel·lar';

  @override
  String get adminAnioGuardarCambios => 'Desar Canvis';

  @override
  String get adminAnioCrearAnio => 'Crear Any';

  @override
  String get adminAnioDesactivarTitulo => 'Desactivar Any Acadèmic';

  @override
  String adminAnioDesactivarMensaje(String nombre) {
    return 'Segur que vols desactivar \"$nombre\"? Passarà a mode historial.';
  }

  @override
  String get adminAnioActivarTitulo => 'Activar Any Acadèmic';

  @override
  String adminAnioActivarMensaje(String nombre) {
    return 'Segur que vols activar \"$nombre\"? L\'any actiu actualment passarà a mode historial.';
  }

  @override
  String get adminAnioEliminarTitulo => 'Eliminar Any Acadèmic';

  @override
  String adminAnioEliminarMensaje(String nombre) {
    return 'Eliminar \"$nombre\" permanentment? Aquesta acció no es pot desfer.';
  }

  @override
  String get adminAnioSnackDesactivado => 'Any desactivat';

  @override
  String get adminAnioSnackActivado => 'Any activat';

  @override
  String get adminAnioSnackEliminado => 'Any eliminat';

  @override
  String get adminAnioSnackGuardado => 'Any desat correctament';

  @override
  String get adminAnioSnackErrorGuardar => 'Error en desar';

  @override
  String get adminAnioSnackNoEliminarActivo => 'No pots eliminar l\'any actiu.';

  @override
  String adminAnioDuplicado(String nombre) {
    return 'Ja existeix un any acadèmic amb el nom \"$nombre\".';
  }

  @override
  String get adminAnioSeleccionarFechas =>
      'Selecciona les dates d\'inici i fi.';

  @override
  String get adminAnioErrorConexion => 'Error de connexió';

  @override
  String get adminHorarioTitulo => 'Calendari';

  @override
  String get adminHorarioTituloDesktop => 'Calendari d\'Esdeveniments';

  @override
  String get adminHorarioSubtitulo =>
      'Planificació acadèmica i recordatoris del centre';

  @override
  String get adminHorarioNuevoEvento => 'NOU ESDEVENIMENT';

  @override
  String get adminHorarioEventosDia => 'Esdeveniments del Dia';

  @override
  String get adminHorarioSinEventos => 'No hi ha esdeveniments per avui';

  @override
  String get adminHorarioProgramarEvento => 'Programar Festiu';

  @override
  String get adminHorarioTituloEvento => 'Títol del dia festiu';

  @override
  String get adminHorarioTipo => 'Tipus';

  @override
  String get adminHorarioCancelar => 'CANCEL·LAR';

  @override
  String get adminHorarioGuardar => 'DESAR';

  @override
  String get adminHorarioEliminadoTitulo => 'Eliminat';

  @override
  String get adminHorarioEliminadoMensaje =>
      'L\'esdeveniment ha estat esborrat.';

  @override
  String get adminHorarioErrorTitulo => 'Error';

  @override
  String get adminReglamentoTitulo => 'Reglament';

  @override
  String get adminReglamentoSubtitulo => 'Gestió de versions i vigència legal';

  @override
  String get adminReglamentoHistorialTitulo => 'Historial Normatiu';

  @override
  String get adminReglamentoHistorialSubtitulo =>
      'Gestió de versions i vigència legal';

  @override
  String get adminReglamentoHistorialBtn => 'Historial';

  @override
  String get adminReglamentoNuevaVersion => 'NOVA VERSIÓ';

  @override
  String get adminReglamentoPublicar => 'PUBLICAR CANVIS';

  @override
  String get adminReglamentoVersionHint => 'Nom de la Versió...';

  @override
  String get adminReglamentoVersionActivaLabel => 'VERSIÓ ACTIVA';

  @override
  String get adminReglamentoActivoBadge => 'ACTIU';

  @override
  String get adminReglamentoEditorPlaceholder =>
      'Comença a redactar la normativa del centre...';

  @override
  String get adminReglamentoNuevaBorrador => 'Nova versió en esborrany';

  @override
  String adminReglamentoModificandoVersion(String fecha) {
    return 'Modificant versió del $fecha';
  }

  @override
  String get adminReglamentoErrorTitulo => 'Error';

  @override
  String get adminReglamentoExitoTitulo => 'Èxit';

  @override
  String get adminReglamentoVersionRequerida => 'Nom de versió requerit';

  @override
  String get adminReglamentoGuardadoOk => 'Reglament desat i sincronitzat';

  @override
  String adminReglamentoFalloGuardar(String error) {
    return 'Error en desar: $error';
  }

  @override
  String get adminReglamentoErrorCargar => 'Error en carregar historial';

  @override
  String get adminHistorialTitulo => 'Historial';

  @override
  String get adminHistorialSubtitulo => 'Auditoria global de registres';

  @override
  String get adminHistorialTituloDesktop => 'Historial d\'Assistència';

  @override
  String get adminHistorialSubtituloDesktop =>
      'Auditoria global de registres de classe i absentisme';

  @override
  String get adminHistorialBuscarHint => 'Cercar matèria o professor...';

  @override
  String get adminHistorialCualquierFecha => 'Qualsevol data';

  @override
  String get adminHistorialCursoLabel => 'CURS';

  @override
  String get adminHistorialGrupoHint => 'Grup';

  @override
  String get adminHistorialTodos => 'Tots';

  @override
  String get adminHistorialTodosGrupos => 'Tots els grups';

  @override
  String get adminHistorialSinRegistros => 'SENSE REGISTRES A MOSTRAR';

  @override
  String get adminHistorialSinDocente => 'Sense docent';

  @override
  String adminHistorialAlumnos(int attended, int total) {
    return '$attended/$total ALUMNES';
  }

  @override
  String get adminProgramConfigTitulo => 'Configuració del Programa';

  @override
  String get adminProgramConfigSubtitulo =>
      'Gestió de polítiques institucionals, rols d\'usuari i paràmetres globals del centre';

  @override
  String get adminProgramConfigRolesTitulo => 'Rols i Matriu de Permisos';

  @override
  String get adminProgramConfigRolesDesc =>
      'Control granular sobre les capacitats de cada perfil';

  @override
  String get adminProgramConfigMatrizPermisos => 'Matriu de Permisos';

  @override
  String get adminProgramConfigMatrizPermisosDesc =>
      'Mapa de privilegis per cada rol del sistema';

  @override
  String get adminProgramConfigGestionRoles => 'Gestió de Rols';

  @override
  String get adminProgramConfigGestionRolesDesc =>
      'Afegir, editar o eliminar etiquetes d\'usuari';

  @override
  String get adminProgramConfigCalendarioTitulo => 'Calendari Institucional';

  @override
  String get adminProgramConfigCalendarioDesc =>
      'Configuració de festius i esdeveniments regionals';

  @override
  String get adminProgramConfigFestivos => 'Calendari de Festius';

  @override
  String get adminProgramConfigFestivosDesc =>
      'Gestionar dies no lectius i ponts';

  @override
  String get adminProgramConfigEventosCentro => 'Esdeveniments del Centre';

  @override
  String get adminProgramConfigEventosCentroDesc =>
      'Graduacions, claustres i festivitats pròpies';

  @override
  String get adminProgramConfigReglamentoTitulo => 'Reglament de Convivència';

  @override
  String get adminProgramConfigReglamentoDesc =>
      'Normes i pautes de comportament del centre';

  @override
  String get adminProgramConfigVerEditarReglamento =>
      'Veure / Editar Reglament';

  @override
  String get adminProgramConfigVerEditarReglamentoDesc =>
      'Gestió detallada de normes, drets i deures';

  @override
  String get adminProgramConfigMantenimientoTitulo => 'Manteniment del Sistema';

  @override
  String get adminProgramConfigMantenimientoDesc =>
      'Paràmetres tècnics i logs d\'activitat';

  @override
  String get adminProgramConfigAuditoria => 'Auditoria de Canvis';

  @override
  String get adminProgramConfigAuditoriaDesc =>
      'Veure historial de modificacions administratives';

  @override
  String get adminProgramConfigLimpieza => 'Neteja de Temporals';

  @override
  String get adminProgramConfigLimpiezaDesc =>
      'Purgar arxius de pujada no referenciats';

  @override
  String get adminProgramConfigUsuarios => 'Gestió d\'Usuaris';

  @override
  String get adminProgramConfigUsuariosDesc =>
      'Control d\'IPs, sessions i activitat de comptes';

  @override
  String get adminProgramConfigEnDesarrolloTitulo =>
      'Funcionalitat en Desenvolupament';

  @override
  String get adminProgramConfigEnDesarrolloDesc =>
      'Aquesta característica estarà disponible en la propera actualització del sistema GAULA.';

  @override
  String get adminProgramConfigEntendido => 'ENTÈS';

  @override
  String get adminProgramConfigEnDesarrolloBadge => 'EN DESENVOLUPAMENT';

  @override
  String get addAlumnoEditTitle => 'Editar Alumne';

  @override
  String get addAlumnoAddTitle => 'Afegir Nou Alumne';

  @override
  String get addAlumnoEditSubtitle => 'Modifica les dades de l\'alumne';

  @override
  String get addAlumnoAddSubtitle =>
      'Completa la informació per a la matrícula';

  @override
  String get addAlumnoSectionPersonal => 'INFORMACIÓ PERSONAL';

  @override
  String get addAlumnoFieldNombre => 'Nom *';

  @override
  String get addAlumnoHintNombre => 'Ex: Joan';

  @override
  String get addAlumnoFieldApellidos => 'Cognoms *';

  @override
  String get addAlumnoHintApellidos => 'Ex: García López';

  @override
  String get addAlumnoFieldDni => 'DNI/NIE';

  @override
  String get addAlumnoSectionContacto => 'CONTACTE I MATRÍCULA';

  @override
  String get addAlumnoFieldEmail => 'Email *';

  @override
  String get addAlumnoHintEmail => 'alumne@gaula.edu';

  @override
  String get addAlumnoFieldUsuario => 'Usuari (Opcional)';

  @override
  String get addAlumnoHintUsuario => 'joan.garcia';

  @override
  String get addAlumnoFieldPassword => 'Contrasenya *';

  @override
  String get addAlumnoHintPassword => 'Mín. 6 carac.';

  @override
  String get addAlumnoFieldTelefono => 'Telèfon';

  @override
  String get addAlumnoHintTelefono => '+34 600...';

  @override
  String get addAlumnoFieldDireccion => 'Adreça';

  @override
  String get addAlumnoHintDireccion => 'Carrer Principal, 123, Barcelona';

  @override
  String get addAlumnoSectionMaterias => 'MATÈRIES (MATRÍCULA)';

  @override
  String get addAlumnoButtonGuardar => 'Desar Canvis';

  @override
  String get addAlumnoButtonRegistrar => 'Registrar Alumne';

  @override
  String get addAlumnoButtonCancelar => 'Cancel·lar';

  @override
  String get addAlumnoFieldFechaNacimiento => 'Data de Naixement';

  @override
  String get addAlumnoSeleccionarFecha => 'Seleccionar...';

  @override
  String get addAlumnoSuccessRegistrado => 'Alumne registrat correctament';

  @override
  String get addAlumnoErrorRegistrar => 'Error en registrar l\'alumne';

  @override
  String get addAlumnoCampoObligatorio => 'Camp obligatori';

  @override
  String get addIncidenciaTitulo => 'Nova Incidència';

  @override
  String get addIncidenciaFieldTitulo => 'Títol';

  @override
  String get addIncidenciaHintTitulo => 'Ex: Comportament disruptiu';

  @override
  String get addIncidenciaFieldAlumno => 'Alumne';

  @override
  String get addIncidenciaSelectAlumno => 'Selecciona alumne';

  @override
  String get addIncidenciaErrorAlumnos => 'Error carregant alumnes';

  @override
  String get addIncidenciaFieldProfesor => 'Professor que reporta';

  @override
  String get addIncidenciaSelectProfesor => 'Selecciona professor';

  @override
  String get addIncidenciaErrorProfesores => 'Error carregant professors';

  @override
  String get addIncidenciaFieldGravedad => 'Gravetat';

  @override
  String get addIncidenciaHintGravedad => 'Nivell de gravetat';

  @override
  String get addIncidenciaFieldDescripcion => 'Descripció detallada';

  @override
  String get addIncidenciaHintDescripcion => 'Detalls del que ha passat...';

  @override
  String get addIncidenciaButtonCrear => 'Crear Incidència';

  @override
  String get addIncidenciaButtonCancelar => 'Cancel·lar';

  @override
  String get addIncidenciaValidacionSeleccion =>
      'Si us plau selecciona alumne i professor';

  @override
  String get addIncidenciaSuccessCreada => 'Incidència creada correctament';

  @override
  String get addIncidenciaErrorCrear => 'Error en crear incidència';

  @override
  String get addIncidenciaCampoObligatorio => 'Camp obligatori';

  @override
  String get addIncidenciaBuscar => 'Cercar...';

  @override
  String get addIncidenciaNoResultados => 'No s\'han trobat resultats';

  @override
  String get addProfesorEditTitle => 'Editar Professor';

  @override
  String get addProfesorAddTitle => 'Afegir Professor';

  @override
  String get addProfesorEditSubtitle => 'Modifica els accessos';

  @override
  String get addProfesorAddSubtitle =>
      'Crea un nou usuari administratiu o docent';

  @override
  String get addProfesorFieldNombre => 'Nom *';

  @override
  String get addProfesorHintNombre => 'Ex: Roberto';

  @override
  String get addProfesorFieldApellidos => 'Cognoms *';

  @override
  String get addProfesorHintApellidos => 'Ex: Sánchez Domínguez';

  @override
  String get addProfesorFieldEmail => 'Email *';

  @override
  String get addProfesorHintEmail => 'exemple@gaula.edu';

  @override
  String get addProfesorFieldEspecialidades => 'Especialitats';

  @override
  String get addProfesorHintEspecialidades => 'Ex: Informàtica, Programació';

  @override
  String get addProfesorFieldRol => 'Rol d\'Usuari *';

  @override
  String get addProfesorRolDocente => 'Professor / Docent';

  @override
  String get addProfesorRolAdmin => 'Administrador';

  @override
  String get addProfesorButtonGuardar => 'Desar Canvis';

  @override
  String get addProfesorButtonRegistrar => 'Registrar Professor';

  @override
  String get addProfesorButtonCancelar => 'Cancel·lar';

  @override
  String get addProfesorSuccessActualizado => 'Dades actualitzades';

  @override
  String get addProfesorSuccessRegistrado => 'Professor registrat';

  @override
  String get addProfesorCampoObligatorio => 'Camp obligatori';

  @override
  String get addProfesorEmailInvalido => 'Format d\'email invàlid';

  @override
  String adminCursoHorarioTitulo(String codigoGrupo) {
    return 'Horari Setmanal: $codigoGrupo';
  }

  @override
  String get adminCursoHorarioGeneradoTitle => 'Generat';

  @override
  String get adminCursoHorarioGeneradoMsg => 'Horari generat automàticament';

  @override
  String get adminCursoHorarioErrorTitle => 'Error';

  @override
  String get adminCursoHorarioButtonGenerar => 'Generar Automàticament';

  @override
  String get adminCursoHorarioButtonAsignar => 'Assignar Mòdul';

  @override
  String get adminCursoHorarioRecreo => 'DESCANS';

  @override
  String adminCursoHorarioErrorCargar(String error) {
    return 'Error en carregar horari: $error';
  }

  @override
  String get adminCursoHorarioDesconocido => 'Desconegut';

  @override
  String get adminCursoHorarioEliminadoTitle => 'Eliminat';

  @override
  String get adminCursoHorarioEliminadoMsg => 'Sessió eliminada correctament';

  @override
  String get adminCursoHorarioErrorAsignar => 'Error en assignar';

  @override
  String get adminCursoHorarioAsignadoTitle => 'Assignat';

  @override
  String get adminCursoHorarioAsignadoMsg => 'Sessió assignada correctament';

  @override
  String adminCursoHorarioElegirColor(String nombre) {
    return 'Triar Color: $nombre';
  }

  @override
  String get adminCursoHorarioNoProfesores => 'No hi ha professors disponibles';

  @override
  String get adminCursoHorarioDia => 'Dia';

  @override
  String get adminCursoHorarioHoraInicio => 'Hora Inici';

  @override
  String get adminCursoHorarioModuloMateria => 'Mòdul / Matèria';

  @override
  String get adminCursoHorarioSeleccionarModulo => 'Seleccionar mòdul';

  @override
  String get adminCursoHorarioNoMaterias => 'No hi ha matèries en el curs';

  @override
  String get adminCursoHorarioProfesorAsignado => 'Professor Assignat';

  @override
  String get adminCursoHorarioBuscarProfesor => 'Cercar professor...';

  @override
  String adminCursoHorarioSoloLibres(String hora) {
    return 'Només lliures a les $hora';
  }

  @override
  String get adminCursoHorarioErrorProfesores => 'Error carregant professors';

  @override
  String get adminCursoHorarioLibre => 'Lliure';

  @override
  String get adminCursoHorarioOcupado => 'Ocupat';

  @override
  String get adminCursoHorarioCancelar => 'Cancel·lar';

  @override
  String get adminCursoHorarioAsignarButton => 'Assignar';

  @override
  String adminPlanEstudiosConfirmarEliminarMateria(String nombre) {
    return 'Estàs segur que vols eliminar la matèria \"$nombre\"? Aquesta acció no es pot desfer.';
  }

  @override
  String get adminPlanEstudiosErrorEliminarMateria =>
      'Error en eliminar matèria.';

  @override
  String get adminPlanEstudiosConfirmarEliminarPlantilla =>
      'Estàs segur que vols eliminar aquesta plantilla? Aquesta acció no es pot desfer.';

  @override
  String adminPlanEstudiosMateriaCount(int count) {
    return '$count matèries';
  }

  @override
  String get adminPlanEstudiosModulosYProyectos => 'Mòduls i Projectes';

  @override
  String adminPlanEstudiosTipoCodigoLabel(String tipo, String codigo) {
    return '$tipo — Codi: $codigo';
  }

  @override
  String get adminPlanEstudiosEditarPlan => 'Editar Pla d\'Estudis';

  @override
  String get adminPlanEstudiosCrearPlan => 'Crear Pla d\'Estudis';

  @override
  String get adminPlanEstudiosNombreCurso => 'Nom del Curs';

  @override
  String get adminPlanEstudiosNombreCursoHint =>
      'ex. Desenvolupament d\'Aplicacions Multiplataforma';

  @override
  String get adminPlanEstudiosCodigo => 'Codi';

  @override
  String get adminPlanEstudiosaCodigoHint => 'ex. DAM';

  @override
  String get adminPlanEstudiosDescripcion => 'Descripció (opcional)';

  @override
  String get adminPlanEstudiosDescripcionHint => 'Breu descripció del curs';

  @override
  String get adminPlanEstudiosColorPlantilla => 'Color de la Plantilla';

  @override
  String get adminPlanEstudiosSeleccionarColor => 'Selecciona un color';

  @override
  String get adminPlanEstudiosAniadirMateria => 'Afegir matèria';

  @override
  String get adminPlanEstudiosEditarMateria => 'Editar matèria';

  @override
  String get adminPlanEstudiosNombreMateria => 'Nom';

  @override
  String get adminPlanEstudiosNombreMateriaHint => 'ex. Programació';

  @override
  String get adminPlanEstudiosTipoMateria => 'Tipus de Matèria';

  @override
  String get adminPlanEstudiosHoras => 'Hores';

  @override
  String get adminPlanEstudiosMateriasAniadidas => 'Matèries afegides:';

  @override
  String adminAlumnosConfirmarDesactivar(String nombre) {
    return 'Estàs segur que vols desactivar l\'expedient de $nombre?';
  }

  @override
  String adminAlumnosConfirmarActivar(String nombre) {
    return 'Estàs segur que vols activar l\'expedient de $nombre?';
  }

  @override
  String get adminPlanEstudiosTipoProyecto => 'Projecte';

  @override
  String get adminPlanEstudiosTipoAsignatura => 'Assignatura';

  @override
  String get adminPlanEstudiosTipoModulo => 'Mòdul';

  @override
  String get adminProfesoresRolLabel => 'Rol';

  @override
  String get adminProfesoresDesconocido => 'Desconegut';

  @override
  String adminProfesoresCursoLabel(String cursoId) {
    return 'Curs: $cursoId';
  }

  @override
  String get procesandoExportacion => 'PROCESSANT EXPORTACIÓ...';

  @override
  String get estaImaTardar => 'AIXÒ POT TRIGAR UNS SEGONS';

  @override
  String get adminCursosNoEliminarConAlumnos =>
      'No es pot eliminar un curs amb alumnes matriculats.';

  @override
  String get adminCursoEliminadoOk => 'Curs eliminat correctament.';

  @override
  String get adminCursoEliminadoError => 'Error en eliminar el curs.';

  @override
  String get adminCursosVolverCursos => 'Tornar a Cursos';

  @override
  String get adminCursosCompletaInfo => 'Completa la informació del curs';

  @override
  String get adminCursosPlantillaCurso => 'Plantilla de Curs';

  @override
  String get adminCursosSeleccionaPlantilla => 'Selecciona una plantilla';

  @override
  String get adminCursosValidarPlantilla => 'Selecciona una plantilla de curs';

  @override
  String get adminCursosTurnoOpcional => 'Torn (opcional)';

  @override
  String get adminCursosEtapa => 'Etapa';

  @override
  String get adminCursosDesdoblamiento => 'Desdoblament';

  @override
  String get adminCursosCodigoGrupo => 'Codi de Grup';

  @override
  String get adminCursosAnioAcademico => 'Any Acadèmic';

  @override
  String get adminCursosSinAnios => 'No hi ha anys acadèmics disponibles';

  @override
  String get adminCursosValidarAnio => 'Selecciona un any acadèmic';

  @override
  String get adminCursosValidarTutor => 'Has d\'assignar un tutor al curs.';

  @override
  String get adminCursosValidarMateria =>
      'Has de seleccionar almenys una matèria per al curs.';

  @override
  String get adminCursosValidarCodigoGrupoVacio =>
      'El codi de grup és obligatori i no ha de coincidir amb cap altre codi del mateix any.';

  @override
  String get adminCursosProfesorTutor => 'Professor Tutor';

  @override
  String adminCursosMatriculacion(int count) {
    return 'Matriculació: $count alumne(s)';
  }

  @override
  String get adminCursosMaterias => 'Matèries';

  @override
  String get adminCursosSinMaterias =>
      'No hi ha matèries assignades a aquest curs.';

  @override
  String get adminCursosBuscarAnio => 'Cercar any...';

  @override
  String get adminCursosOrdenHint => 'A-Z (Opcional)';

  @override
  String get adminCursosCodigoHint => 'Ex: DAM1M';

  @override
  String get adminCursosTutorAsignado => 'Tutor assignat';

  @override
  String get adminCursosBuscarProfesor => 'Cercar professor per nom...';

  @override
  String get adminCursosSeleccionaAsignaturas =>
      'Selecciona les assignatures que s\'impartiran';

  @override
  String get adminCursosVistaPrevia => 'Vista Prèvia del Curs';

  @override
  String get adminCursosPlantillaOficial => 'Plantilla Oficial';

  @override
  String get adminCursosInstanciados => 'Cursos Instanciats';

  @override
  String get adminCursosVisualizacion => 'Visualització de grups actius';

  @override
  String get adminCursosAniadirNuevo => 'Afegir Nou Curs';

  @override
  String get adminCursosNoRegistrados =>
      'No hi ha cursos registrats per a aquesta plantilla';

  @override
  String get adminCursosEliminarTooltip => 'Eliminar curs';

  @override
  String get adminCursosGestionarHorario => 'Gestionar Horari';

  @override
  String get adminCursosGestionarAlumnos => 'Gestionar Alumnes';

  @override
  String get adminCursosPlanificacion => 'Planificació Acadèmica';

  @override
  String get adminCursosProgresoModulo => 'Progrés del Mòdul';

  @override
  String get adminCursosTemporalidad => 'Temporalitat';

  @override
  String get adminCursosEditarFechas => 'Editar Dates';

  @override
  String get adminCursosVolverDetalles => 'Tornar a detalls';

  @override
  String get adminCursosVolverGrupos => 'Tornar a grups';

  @override
  String get adminCursosSinTutor => 'Sense tutor';

  @override
  String get adminCursosAlumnosMatriculados => 'Alumnes Matriculats';

  @override
  String get adminCursosAniadirAlumno => 'Afegir Alumne';

  @override
  String get adminCursosSinAlumnos =>
      'No hi ha alumnes matriculats en aquest curs.';

  @override
  String get adminCursosQuitarAlumno => 'Treure Alumne';

  @override
  String get adminDashResumenEjecutivo => 'Resum Executiu';

  @override
  String get adminDashMetricasTiempoReal =>
      'Mètriques principals del centre en temps real';

  @override
  String get adminDashAccionesRapidas => 'Accions Ràpides';

  @override
  String get adminDashMatricularAlumno => 'Matricular Alumne';

  @override
  String get adminDashGestionarFestivos => 'Gestionar Festius';

  @override
  String get adminDashRevisarPermisos => 'Revisar Permisos';

  @override
  String get adminDashBienvenido => 'Benvingut de nou, Administrador!';

  @override
  String get adminDashVerReporteMensual => 'Veure informe mensual';

  @override
  String get adminDashAsistenciaGlobal => 'Assistència Global';

  @override
  String get adminDashAsistenciaSubtitulo =>
      'Rendiment promig dels últims 7 dies';

  @override
  String get adminDashIncidenciasPorCurso => 'Incidències per Curs (Top 5)';

  @override
  String get adminDashSinIncidencias => 'Sense incidències registrades';

  @override
  String get adminDashErrorGrafico => 'Error en carregar gràfic';

  @override
  String get adminDashAlertasRecientes => 'Alertes Recents';

  @override
  String get adminDashSinAlertas => 'Sense alertes recents';

  @override
  String get adminDashFiltroAplicado => 'Filtre aplicat';

  @override
  String adminDashMostrandoDatos(String periodo) {
    return 'Mostrant dades de $periodo';
  }

  @override
  String get adminDashSeleccionarEtapa =>
      'Selecciona l\'etapa actual d\'aquesta incidència';

  @override
  String get adminAuditoriaTitulo => 'Auditoria del Sistema';

  @override
  String get adminAuditoriaSubtitulo =>
      'Registre d\'activitat i canvis crítics';

  @override
  String get adminAuditoriaFiltrarPor => 'Filtrar per acció';

  @override
  String get adminAuditoriaBuscar => 'Cercar en el registre...';

  @override
  String get adminAuditoriaSinRegistros => 'No hi ha registres d\'auditoria.';

  @override
  String get adminAuditoriaUsuario => 'Usuari';

  @override
  String get adminAuditoriaAccion => 'Acció';

  @override
  String get adminAuditoriaFecha => 'Data';

  @override
  String get adminAuditoriaDetalle => 'Detall';

  @override
  String get adminAuditoriaTodos => 'TOTS';

  @override
  String get adminAuditoriaExportar => 'Exportar';

  @override
  String get adminUsuariosSubtitulo => 'Administra els accessos al sistema';

  @override
  String get adminUsuariosBuscar => 'Cercar usuari...';

  @override
  String get adminUsuariosNuevo => 'Nou Usuari';

  @override
  String get adminUsuariosEmail => 'Email';

  @override
  String get adminUsuariosSinUsuarios => 'No hi ha usuaris registrats.';

  @override
  String get adminUsuariosEliminarTitulo => 'Eliminar Usuari';

  @override
  String get adminUsuariosEliminarDesc =>
      'Estàs segur que vols eliminar aquest usuari? Aquesta acció no es pot desfer.';

  @override
  String get adminUsuariosActivar => 'Activar';

  @override
  String get adminUsuariosDesactivar => 'Desactivar';

  @override
  String get adminUsuariosEditar => 'Editar';

  @override
  String get adminUsuariosActivadoMsg => 'Usuari activat correctament.';

  @override
  String get adminUsuariosDesactivadoMsg => 'Usuari desactivat correctament.';

  @override
  String get adminUsuariosEliminadoMsg => 'Usuari eliminat correctament.';

  @override
  String get adminUsuariosErrorMsg => 'Error en processar la sol·licitud.';

  @override
  String get adminConfigTitulo => 'Configuració del Sistema';

  @override
  String get adminConfigSubtitulo => 'Gestiona els ajustos generals del centre';

  @override
  String get adminConfigGuardar => 'Desar Canvis';

  @override
  String get adminConfigCambiosGuardados => 'Canvis desats correctament.';

  @override
  String get adminConfigErrorGuardar => 'Error en desar els canvis.';

  @override
  String get adminConfigNombreCentro => 'Nom del Centre';

  @override
  String get adminConfigDireccion => 'Adreça';

  @override
  String get adminConfigTelefono => 'Telèfon';

  @override
  String get adminConfigEmail => 'Email de Contacte';

  @override
  String get adminConfigCursoActivo => 'Any Acadèmic Actiu';

  @override
  String get adminHorarioSinSesiones => 'No hi ha sessions configurades.';

  @override
  String get adminHorarioNuevaSesion => 'Nova Sessió';

  @override
  String get adminHorarioEliminarSesion => 'Eliminar Sessió';

  @override
  String get adminHorarioEliminarSesionDesc =>
      'Eliminar aquesta sessió de l\'horari?';

  @override
  String get adminHorarioSesionCreada => 'Sessió creada correctament.';

  @override
  String get adminHorarioSesionEliminada => 'Sessió eliminada correctament.';

  @override
  String get adminRolesTitulo => 'Gestió de Rols';

  @override
  String get adminRolesSubtitulo => 'Defineix permisos i accessos per rol';

  @override
  String get adminRolesSinRoles => 'No hi ha rols definits.';

  @override
  String get adminRolesGuardado => 'Rol actualitzat correctament.';

  @override
  String get adminRolesError => 'Error en actualitzar el rol.';

  @override
  String get adminReglamentoGuardado => 'Reglament desat correctament.';

  @override
  String get adminReglamentoNuevoArticulo => 'Nou Article';

  @override
  String get adminReglamentoEliminar => 'Eliminar Article';

  @override
  String get adminReglamentoEliminarDesc =>
      'Eliminar aquest article del reglament?';

  @override
  String get adminProgConfigTitulo => 'Configuració del Programa';

  @override
  String get adminProgConfigSubtitulo =>
      'Gestiona els mòduls i la configuració acadèmica';

  @override
  String get adminProgConfigGuardado => 'Configuració desada correctament.';

  @override
  String get adminProgConfigError => 'Error en desar la configuració.';

  @override
  String get adminPermissionsTitulo => 'Gestió de Permisos';

  @override
  String get adminPermissionsSubtitulo =>
      'Controla l\'accés a funcionalitats del sistema';

  @override
  String get adminPermissionsGuardado => 'Permisos actualitzats correctament.';

  @override
  String get adminPermissionsError => 'Error en actualitzar els permisos.';

  @override
  String get adminUsuariosBuscarDetalle => 'Cercar per nom, cognoms, usuari...';

  @override
  String get adminUsuariosColUsuario => 'USUARI / IDENTIFICACIÓ';

  @override
  String get adminUsuariosColEmail => 'EMAIL';

  @override
  String get adminUsuariosColRol => 'ROL';

  @override
  String get adminUsuariosColEstado => 'ESTAT';

  @override
  String get adminUsuariosColUltimaActividad => 'ÚLTIMA ACTIVITAT';

  @override
  String get adminUsuariosColIpSesion => 'IP SESSIÓ';

  @override
  String get adminUsuariosColAcciones => 'ACCIONS';

  @override
  String get adminUsuariosSinResultados =>
      'Sense resultats per al filtre actual';

  @override
  String adminUsuariosMostrando(int from, int to, int total) {
    return 'Mostrant $from - $to de $total';
  }

  @override
  String adminUsuariosMostrandoRegistros(int from, int to, int total) {
    return 'Mostrant $from - $to de $total registres';
  }

  @override
  String get adminUsuariosMenuVerPerfil => 'Veure Perfil Complet';

  @override
  String get adminUsuariosMenuEditar => 'Editar Usuari';

  @override
  String get adminUsuariosMenuResetear => 'Restablir Contrasenya';

  @override
  String get adminUsuariosMenuDesactivar => 'Desactivar Compte';

  @override
  String get adminUsuariosMenuActivar => 'Activar Compte';

  @override
  String get adminUsuariosMenuEliminar => 'Eliminar Usuari';

  @override
  String get adminUsuariosToastCopiado => 'Copiat';

  @override
  String get adminUsuariosToastTokenCopiado => 'Token de sessió copiat.';

  @override
  String get adminUsuariosToastContrasenaReseteada => 'Contrasenya Restablerta';

  @override
  String adminUsuariosToastContrasenaMsg(String username) {
    return 'La contrasenya per a $username és ara: gaula123';
  }

  @override
  String get adminUsuariosToastError => 'Error';

  @override
  String get adminUsuariosToastNoResetear =>
      'No s\'ha pogut restablir la contrasenya.';

  @override
  String get adminUsuariosToastEstadoActualizado => 'Estat Actualitzat';

  @override
  String adminUsuariosToastEstadoMsg(String username, String estado) {
    return 'Usuari $username està ara $estado';
  }

  @override
  String get adminUsuariosToastNoEstado => 'No s\'ha pogut canviar l\'estat.';

  @override
  String get adminUsuariosToastEliminado => 'Usuari Eliminat';

  @override
  String get adminUsuariosToastEliminadoMsg =>
      'El registre ha estat esborrat del sistema.';

  @override
  String get adminUsuariosToastNoEliminar =>
      'No s\'ha pogut eliminar l\'usuari.';

  @override
  String get adminUsuariosDialogEliminarTitulo => 'Eliminar Usuari?';

  @override
  String adminUsuariosDialogEliminarMsg(String nombre, String username) {
    return 'Aquesta acció eliminarà permanentment $nombre (@$username). Aquesta acció no es pot desfer.';
  }

  @override
  String get adminUsuariosDialogCancelar => 'CANCEL·LAR';

  @override
  String get adminUsuariosDialogEliminar => 'ELIMINAR';

  @override
  String adminUsuariosTodosFiltro(String hint) {
    return 'Tots ($hint)';
  }

  @override
  String get crearIncidenciaCompletaCampos =>
      'Si us plau, completa tots els camps';

  @override
  String get crearIncidenciaSeleccionaAlumno =>
      'Si us plau, selecciona un alumne';

  @override
  String get crearIncidenciaExito => '✅ Incidència creada correctament';

  @override
  String get crearIncidenciaError => 'Error en crear la incidència';

  @override
  String get crearIncidenciaSubtituloAlumno =>
      'Reporta un problema o incidència';

  @override
  String get crearIncidenciaSubtituloProfesor =>
      'Registra una incidència d\'un alumne';

  @override
  String get crearIncidenciaAlumnoLabel => 'Alumne *';

  @override
  String get crearIncidenciaTituloLabel => 'Títol *';

  @override
  String get crearIncidenciaTituloHint => 'Breu descripció del problema';

  @override
  String get crearIncidenciaDescripcionLabel => 'Descripció *';

  @override
  String get crearIncidenciaDescripcionHint =>
      'Descriu el problema en detall...';

  @override
  String get crearIncidenciaGravedadLabel => 'Gravetat';

  @override
  String get crearIncidenciaBoton => 'Crear Incidència';

  @override
  String get crearIncidenciaBuscarAlumno => 'Escriu per cercar...';

  @override
  String get crearIncidenciaSinGrupo => 'Sense grup';

  @override
  String get crearIncidenciaErrorAlumnos => 'Error carregant alumnes';

  @override
  String get verReporteMensual => 'Veure informe mensual';

  @override
  String get sinAlertasRecientes => 'Sense alertes recents';

  @override
  String get buscarPorNombre => 'Cercar per nom...';

  @override
  String get asignarMaterias => 'Assignar Matèries';

  @override
  String get cursoSinMaterias => 'Aquest curs no té matèries assignades';

  @override
  String get marcarTodos => 'Marcar tots';

  @override
  String get desmarcarTodos => 'Desmarcar tots';

  @override
  String get atras => 'Enrere';

  @override
  String get matricular => 'Matricular';

  @override
  String get anadirCursoModalidad => 'Afegir curs a aquesta modalitat';

  @override
  String get etapaActualIncidencia =>
      'Selecciona l\'etapa actual d\'aquesta incidència';

  @override
  String get buscarPorTituloDesc => 'Cercar per títol o descripció...';

  @override
  String get topAlumnosIncidencias => 'Top Alumnes amb Incidències';

  @override
  String get noHayIncidencias => 'No hi ha incidències registrades';

  @override
  String get resolucionIncidencia => 'Resolució d\'Incidència';

  @override
  String get esInvalida => 'ÉS INVÀLIDA';

  @override
  String get esValida => 'ÉS VÀLIDA';

  @override
  String get fechaPlaceholder => 'Data...';

  @override
  String get materia => 'Matèria';

  @override
  String get seleccionarMateria => 'Seleccionar matèria';

  @override
  String docenteConNombreLabel(String nombre) {
    return 'Docent: $nombre';
  }

  @override
  String get siguienteLabel => 'Següent';

  @override
  String get cambiarPasswordTitulo => 'Canviar Contrasenya';

  @override
  String get cambiarPasswordDesc =>
      'Introdueix la teva contrasenya actual i la nova';

  @override
  String get dialogContrasenyaActual => 'Contrasenya Actual';

  @override
  String get dialogNovaContrasenya => 'Nova Contrasenya';

  @override
  String get dialogConfirmarNovaContrasenya => 'Confirmar Nova Contrasenya';

  @override
  String get notificacionesTitulo => 'Notificacions';

  @override
  String get marcarTodas => 'Marcar totes';

  @override
  String get noHayNotificaciones => 'No hi ha notificacions';

  @override
  String get reglamentoCentro => 'REGLAMENT DEL CENTRE';

  @override
  String get normativaVigente => 'NORMATIVA VIGENT';

  @override
  String get versionActualizada => 'Versió Actualitzada';

  @override
  String paginaNoEncontrada(String uri) {
    return 'Pàgina no trobada: $uri';
  }

  @override
  String get irAlInicio => 'Anar a l\'inici';

  @override
  String get tabTotes => 'TOTES';

  @override
  String get tabObert => 'OBERT';

  @override
  String get tabEnProces => 'EN PROCÉS';

  @override
  String get tabTancat => 'TANCAT';

  @override
  String get filtreCurs => 'Curs';

  @override
  String get filtreAlumne => 'Alumne';

  @override
  String get filtreProfessor => 'Professor';

  @override
  String get filtrarPorAlumno => 'Filtrar per alumne...';

  @override
  String get filtrarPorProfesor => 'Filtrar per professor...';

  @override
  String get todosAlumnos => 'Tots els Alumnes';

  @override
  String get todosProfesores => 'Tots els Professors';

  @override
  String get todos => 'Tots';

  @override
  String get incidenciaPendiente => 'PENDENT';

  @override
  String get resValida => 'VÀLIDA';

  @override
  String get resInvalida => 'INVÀLIDA';

  @override
  String get incidenciasEsInvalida => 'ÉS INVÀLIDA';

  @override
  String get incidenciaConfirmacioText =>
      'Després de la investigació realitzada, es confirma que la incidència és verídica i mereix sanció?';

  @override
  String get topAlumnesIncidencies => 'Top Alumnes amb Incidències';

  @override
  String get alertesTotals => 'ALERTES TOTALS';

  @override
  String get incidenciaSeveridadLeve => 'Lleu';

  @override
  String get incidenciaSeveridadGrave => 'Greu';

  @override
  String get incidenciaSeveridadMuyGrave => 'Molt Greu';

  @override
  String get adminCursosCalendario => 'Calendari Escolar';

  @override
  String get adminCursosVerOtrosAnios => 'Veure altres anys';

  @override
  String get adminCursosAniadirCurso => 'Afegir Curs';

  @override
  String get adminCursosTurnoPartido => 'Partit (P)';

  @override
  String get adminCursosTurnoManana => 'Matí (M)';

  @override
  String get adminCursosTurnoTarde => 'Tarda (T)';

  @override
  String get adminCursosTurnoNocturno => 'Nocturn (N)';

  @override
  String get statPresentes => 'Pres.';

  @override
  String get statAusentes => 'Abs.';

  @override
  String get statRetrasos => 'Tard.';

  @override
  String get diaSabado => 'Dissabte';

  @override
  String get diaDomingo => 'Diumenge';

  @override
  String asistenciaAlumnoIndex(int index, int total) {
    return 'Alumne $index de $total';
  }

  @override
  String get asistenciaHoraLabel => 'Hora';

  @override
  String get asistenciaCursoLabel => 'Curs';
}
