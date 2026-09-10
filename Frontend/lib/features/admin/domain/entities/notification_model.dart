import 'package:flutter/material.dart';

enum NotificationType { info, warning, error, success, incidencia, alerta, asistencia }

class GaulaNotification {
  final int id;
  final String title;
  final String description;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? route;
  final Map<String, String>? routeParams;

  GaulaNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.route,
    this.routeParams,
  });

  IconData get icon => switch (type) {
    NotificationType.info       => Icons.info_outline_rounded,
    NotificationType.warning    => Icons.warning_amber_rounded,
    NotificationType.error      => Icons.error_outline_rounded,
    NotificationType.success    => Icons.check_circle_outline_rounded,
    NotificationType.incidencia => Icons.error_outline_rounded,
    NotificationType.alerta     => Icons.notifications_active_outlined,
    NotificationType.asistencia => Icons.fact_check_outlined,
  };

  Color get color => switch (type) {
    NotificationType.info       => Colors.blueAccent,
    NotificationType.warning    => Colors.orangeAccent,
    NotificationType.error      => Colors.redAccent,
    NotificationType.success    => Colors.greenAccent,
    NotificationType.incidencia => Colors.deepOrangeAccent,
    NotificationType.alerta     => Colors.red,
    NotificationType.asistencia => Colors.indigoAccent,
  };

  factory GaulaNotification.fromJson(Map<String, dynamic> json) {
    return GaulaNotification(
      id: json['id'],
      title: json['titulo'] ?? json['title'] ?? 'Notificación',
      description: json['mensaje'] ?? json['description'] ?? '',
      timestamp: DateTime.parse(json['fecha'] ?? json['timestamp']),
      type: _parseType(json['tipo'] ?? json['type']),
      isRead: json['leida'] ?? json['isRead'] ?? false,
      route: json['route'],
      routeParams: json['routeParams'] != null ? Map<String, String>.from(json['routeParams']) : null,
    );
  }

  static NotificationType _parseType(String? type) {
    if (type == null) return NotificationType.info;
    switch (type.toUpperCase()) {
      case 'INFO': return NotificationType.info;
      case 'WARNING': return NotificationType.warning;
      case 'ERROR': return NotificationType.error;
      case 'SUCCESS': return NotificationType.success;
      case 'INCIDENCIA': return NotificationType.incidencia;
      case 'ALERTA': return NotificationType.alerta;
      case 'ASISTENCIA': return NotificationType.asistencia;
      default: return NotificationType.info;
    }
  }
}
