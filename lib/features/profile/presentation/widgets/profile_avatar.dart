import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.imageBytes,
    this.size = AppDimensions.avatarSizeSm,
    this.onCameraTap,
  });

  final String? imageUrl;
  final Uint8List? imageBytes;
  final double size;
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
            color: imageBytes == null && _urlIsEmpty
                ? AppColors.avatarBackground
                : null,
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: AppDimensions.elevationSm,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: _buildImage(),
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
                  color: AppColors.figmaDarkGreen,
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

  bool get _urlIsEmpty => imageUrl == null || imageUrl!.isEmpty;

  Widget _buildImage() {
    if (imageBytes != null) {
      return Image.memory(imageBytes!, fit: BoxFit.cover);
    }
    if (!_urlIsEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Icon(
      Icons.person,
      size: size * 0.5,
      color: AppColors.textSecondary,
    );
  }
}
