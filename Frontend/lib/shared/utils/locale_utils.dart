import '../../l10n/app_localizations.dart';

String localizeEstado(String estado, AppLocalizations l10n) {
  switch (estado.toUpperCase().replaceAll('-', '_').replaceAll(' ', '_')) {
    case 'ACTIVO':
      return l10n.estadoActivo;
    case 'INACTIVO':
      return l10n.estadoInactivo;
    case 'PRESENTE':
      return l10n.estadoPresente;
    case 'AUSENTE':
      return l10n.estadoAusente;
    case 'RETRASO':
      return l10n.estadoRetraso;
    case 'JUSTIFICADO':
      return l10n.estadoJustificado;
    case 'MATRICULADO':
      return l10n.estadoMatriculado;
    case 'ABIERTO':
      return l10n.estadoAbierto;
    case 'EN_PROCESO':
      return l10n.estadoEnProceso;
    case 'CERRADO':
      return l10n.estadoCerrado;
    default:
      return estado;
  }
}
