import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../profile/presentation/widgets/profile_app_bar.dart';
import '../../data/models/security_privacy_copy.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  static const TextStyle _titleStyle = TextStyle(
    color: AppColors.primary,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.44,
  );

  static const TextStyle _headingStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.36,
  );

  static const TextStyle _bodyStyle = TextStyle(
    color: AppColors.textfromfield,
    fontSize: 16,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.32,
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              const ProfileHeader(title: SecurityPrivacyCopy.screenTitle),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingXl,
                    vertical: AppDimensions.spacingXl,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppDimensions.maxContentWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            SecurityPrivacyCopy.policyTitle,
                            textAlign: TextAlign.center,
                            style: _titleStyle,
                          ),
                          const SizedBox(height: AppDimensions.spacing2xl),
                          for (final section
                              in SecurityPrivacyCopy.sections) ...[
                            Text(
                              section.heading,
                              textAlign: TextAlign.center,
                              style: _headingStyle,
                            ),
                            const SizedBox(height: AppDimensions.spacingSm),
                            Text(
                              section.body,
                              textAlign: TextAlign.center,
                              style: _bodyStyle,
                            ),
                            const SizedBox(height: AppDimensions.spacingXl),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}