import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/api_constants.dart';

class GaulaProfileImage extends StatelessWidget {
  final String? fotoUrl;
  final Uint8List? bytes;
  final String nombre;
  final double radius;
  final TextStyle? textStyle;
  final bool isSquare;

  const GaulaProfileImage({
    super.key,
    this.fotoUrl,
    this.bytes,
    required this.nombre,
    this.radius = 20,
    this.textStyle,
    this.isSquare = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultAvatarSuffixes = ['student', 'teacher', 'admin'];
    final isDefaultAvatar = fotoUrl != null && (
      defaultAvatarSuffixes.contains(fotoUrl) ||
      defaultAvatarSuffixes.any((s) => fotoUrl!.endsWith('/$s') || fotoUrl!.endsWith('/profiles/$s'))
    );

    // Evitamos cargar como imagen cadenas que son emojis o que no tienen extension de archivo
    final isEmojiOrWord = fotoUrl != null && (
      fotoUrl!.runes.any((r) => r >= 0x1F600 && r <= 0x1F64F || r > 0x2000) || 
      !fotoUrl!.contains('.')
    );

    final hasImage = !isDefaultAvatar && !isEmojiOrWord && ((fotoUrl != null && fotoUrl!.isNotEmpty) || bytes != null);

    ImageProvider? image;
    if (hasImage) {
      if (bytes != null) {
        image = MemoryImage(bytes!);
      } else if (fotoUrl != null && fotoUrl!.isNotEmpty) {
        String finalUrl = fotoUrl!;
        if (!finalUrl.startsWith('http') && !finalUrl.startsWith('data:')) {
          final filename = finalUrl.split('/').last;
          finalUrl = '${ApiConstants.uploadsBaseUrl}$filename';
        }
        image = NetworkImage(finalUrl);
      }
    }

    final avatarPlaceholder = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: isSquare ? BorderRadius.circular(radius * 0.4) : null,
      ),
      child: Center(
        child: Icon(Icons.person_rounded, color: Colors.white, size: radius),
      ),
    );

    if (isSquare) {
      return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(radius * 0.4),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius * 0.4),
          child: image != null 
            ? Image(
                image: image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => avatarPlaceholder,
              )
            : avatarPlaceholder,
        ),
      );
    }

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: image != null 
          ? Image(
              image: image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => avatarPlaceholder,
            )
          : avatarPlaceholder,
      ),
    );
  }
}
