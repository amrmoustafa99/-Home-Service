import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../profile/presentation/widgets/profile_app_bar.dart';
import '../../data/models/invite_friend_copy.dart';
import '../widgets/how_it_works_steps.dart';

class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({super.key});

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  static const List<IconData> _stepIcons = [
    Icons.share_outlined,
    Icons.person_add_alt_outlined,
    Icons.local_offer_outlined,
    Icons.card_giftcard_outlined,
  ];

  static const TextStyle _headingTextStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.56,
  );

  static const TextStyle _subtitleTextStyle = TextStyle(
    color: AppColors.textfromfield,
    fontSize: 16,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.32,
  );

  static const TextStyle _highlightTextStyle = TextStyle(
    color: AppColors.primary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.36,
  );

  static const TextStyle _codeLabelTextStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.32,
  );

  static const TextStyle _codeTextStyle = TextStyle(
    color: AppColors.primary,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.44,
  );

  static const TextStyle _shareButtonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  static const TextStyle _howItWorksTextStyle = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.32,
  );

  static const TextStyle _footerTextStyle = TextStyle(
    color: AppColors.textfromfield,
    fontSize: 16,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.32,
  );

  bool _expanded = true;

  Future<void> _copyCode() async {
    await Clipboard.setData(
      ClipboardData(text: InviteFriendCopy.inviteCode),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(InviteFriendCopy.copiedFeedback)),
    );
  }

  void _shareCode() {
    // TODO: Integrate the platform share sheet once share_plus is added
    // to the project dependencies.
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              const ProfileHeader(title: InviteFriendCopy.screenTitle),
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
                            child: SizedBox(
                              width: 240,
                              height: 176,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.inviteFriendDecorations,
                                    width: 200,
                                    height: 146,
                                    fit: BoxFit.fill,
                                  ),
                                  Image.asset(
                                    AppAssets.inviteFriendGift,
                                    width: 150,
                                    height: 225,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingMd),
                          const Text(
                            InviteFriendCopy.heading,
                            textAlign: TextAlign.center,
                            style: _headingTextStyle,
                          ),
                          const SizedBox(height: AppDimensions.spacingMd),
                          const Text(
                            InviteFriendCopy.subtitleInfo,
                            textAlign: TextAlign.center,
                            style: _subtitleTextStyle,
                          ),
                          const SizedBox(height: AppDimensions.spacingXs),
                          Text.rich(
                            TextSpan(
                              style: _subtitleTextStyle,
                              children: const [
                                TextSpan(text: InviteFriendCopy.subtitlePrefix),
                                TextSpan(
                                  text: InviteFriendCopy.subtitleHighlight,
                                  style: _highlightTextStyle,
                                ),
                                TextSpan(text: InviteFriendCopy.subtitleSuffix),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDimensions.spacing2xl),
                          Container(
                            padding: const EdgeInsets.all(
                              AppDimensions.spacingXl,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppDimensions.radiusLg),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  InviteFriendCopy.codeLabel,
                                  textAlign: TextAlign.center,
                                  style: _codeLabelTextStyle,
                                ),
                                const SizedBox(
                                  height: AppDimensions.spacingLg,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimensions.spacingLg,
                                    vertical: AppDimensions.spacingMd,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    border: Border.all(
                                      color: AppColors.figmaDarkGreen,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppDimensions.radiusMd),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          InviteFriendCopy.inviteCode,
                                          textAlign: TextAlign.center,
                                          style: _codeTextStyle,
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints:
                                            const BoxConstraints(),
                                        onPressed: _copyCode,
                                        icon: const Icon(
                                          Icons.copy,
                                          color: AppColors.figmaDarkGreen,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: AppDimensions.spacingLg,
                                ),
                                Material(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppDimensions.radiusMd),
                                  ),
                                  child: InkWell(
                                    onTap: _shareCode,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppDimensions.radiusMd),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppDimensions.spacingLg,
                                        vertical: AppDimensions.spacingMd,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.share,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: AppDimensions.spacingSm,
                                          ),
                                          Flexible(
                                            child: Text(
                                              InviteFriendCopy.shareButton,
                                              textAlign: TextAlign.center,
                                              style: _shareButtonTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing2xl),
                          InkWell(
                            onTap: () =>
                                setState(() => _expanded = !_expanded),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.spacingSm,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Opacity(
                                    opacity: 0.5,
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppDimensions.spacingLg,
                                  ),
                                  Flexible(
                                    child: Text(
                                      InviteFriendCopy.howItWorksTitle,
                                      textAlign: TextAlign.center,
                                      style: _howItWorksTextStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppDimensions.spacingLg,
                                  ),
                                  AnimatedRotation(
                                    turns: _expanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: const Opacity(
                                      opacity: 0.5,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_expanded)
                            const SizedBox(height: AppDimensions.spacingXl),
                          if (_expanded)
                            for (var i = 0;
                                i < InviteFriendCopy.steps.length;
                                i++) ...[
                              HowItWorksStep(
                                icon: _stepIcons[i],
                                number: '${i + 1}',
                                title: InviteFriendCopy.steps[i].title,
                                subtitle: InviteFriendCopy.steps[i].subtitle,
                              ),
                              if (i < InviteFriendCopy.steps.length - 1)
                                const SizedBox(
                                  height: AppDimensions.spacingXs,
                                ),
                            ],
                          const SizedBox(height: AppDimensions.spacing2xl),
                          Container(
                            padding: const EdgeInsets.all(
                              AppDimensions.spacingLg,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              border: Border.all(color: AppColors.lightGrey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppDimensions.radiusMd),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    InviteFriendCopy.footerNote,
                                    textAlign: TextAlign.center,
                                    style: _footerTextStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: AppDimensions.spacingMd,
                                ),
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.figmaDarkGreen,
                                  size: 20,
                                ),
                              ],
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