import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Circular profile avatar.
///
/// Shows the picked photo via [Image.memory] when [imageBytes] is provided
/// (web-safe, no [dart:io]), otherwise a light-grey circle with a generic
/// person icon. When [onCameraTap] is provided, a small green camera button
/// overlaps the avatar's bottom-right edge.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.imageBytes,
    this.size = AppDimensions.avatarSizeSm,
    this.onCameraTap,
  });

  /// Raw avatar image bytes; falls back to the placeholder icon when null.
  final Uint8List? imageBytes;

  /// Diameter of the circular avatar.
  final double size;

  /// When non-null, renders the camera badge and calls this on tap.
  final VoidCallback? onCameraTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: imageBytes == null ? AppColors.avatarBackground : null,
            border: Border.all(color: AppColors.border),
          ),
          child: imageBytes != null
              ? Image.memory(imageBytes!, fit: BoxFit.cover)
              : Icon(
                  Icons.person,
                  size: size * 0.5,
                  color: AppColors.textSecondary,
                ),
        ),
        if (onCameraTap != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: onCameraTap,
              child: Container(
                width: AppDimensions.cameraBadgeSize,
                height: AppDimensions.cameraBadgeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}