import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../profile/presentation/widgets/profile_app_bar.dart';
import '../../data/models/about_app_copy.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static const TextStyle _taglineStyle = TextStyle(
    color: AppColors.text,
    fontSize: 14,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.28,
  );

  static const TextStyle _headingStyle = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.32,
  );

  static const TextStyle _versionLabelStyle = TextStyle(
    color: AppColors.textfromfield,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle _versionStyle = TextStyle(
    color: AppColors.figmaDarkGreen,
    fontSize: 14,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w700,
    height: 1.5,
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
              const ProfileHeader(title: AboutAppCopy.screenTitle),
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
                          Center(
                            child: Image.asset(
                              AppAssets.logo,
                              width: 100,
                              height: 80,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingXl),
                          const Text(
                            AboutAppCopy.tagline,
                            textAlign: TextAlign.center,
                            style: _taglineStyle,
                          ),
                          const SizedBox(height: AppDimensions.spacingLg),
                          Center(
                            child: Image.asset(
                              AppAssets.aboutAppIllustration,
                              width: 277,
                              height: 144,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingLg),
                          const Text(
                            AboutAppCopy.description,
                            textAlign: TextAlign.center,
                            style: _taglineStyle,
                          ),
                          const SizedBox(height: AppDimensions.spacing2xl),
                          const Text(
                            AboutAppCopy.featuresHeading,
                            textAlign: TextAlign.center,
                            style: _headingStyle,
                          ),
                          const SizedBox(height: AppDimensions.spacingLg),
                          _FeatureCard(
                            icon: Icons.miscellaneous_services,
                            title: AboutAppCopy
                                .features[0].title,
                            subtitle: AboutAppCopy
                                .features[0].subtitle,
                          ),
                          const SizedBox(height: AppDimensions.spacingSm),
                          _FeatureCard(
                            icon: Icons.verified_user_outlined,
                            title: AboutAppCopy
                                .features[1].title,
                            subtitle: AboutAppCopy
                                .features[1].subtitle,
                          ),
                          const SizedBox(height: AppDimensions.spacingSm),
                          _FeatureCard(
                            icon: Icons.stars_outlined,
                            title: AboutAppCopy
                                .features[2].title,
                            subtitle: AboutAppCopy
                                .features[2].subtitle,
                          ),
                          const SizedBox(height: AppDimensions.spacing2xl),
                          const Text(
                            AboutAppCopy.versionLabel,
                            textAlign: TextAlign.center,
                            style: _versionLabelStyle,
                          ),
                          const SizedBox(height: AppDimensions.spacingSm),
                          const Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(AppDimensions.radiusSm),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.spacingLg,
                                  vertical: AppDimensions.spacingSm,
                                ),
                                child: Text(
                                  AboutAppCopy.version,
                                  style: _versionStyle,
                                ),
                              ),
                            ),
                          ),
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

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  static const TextStyle _titleStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.32,
  );

  static const TextStyle _subtitleStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.28,
  );

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.radiusSm),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingMd,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(title, style: _titleStyle),
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(subtitle, style: _subtitleStyle),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spacingLg),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radiusSm),
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.figmaDarkGreen,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}