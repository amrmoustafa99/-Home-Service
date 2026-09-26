import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../data/models/offer_model.dart';
import '../../data/models/offers_copy.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;

  const OfferCard({super.key, required this.offer});

  static const Color _activeBorder = Color(0xFFE0E0E0);
  static const Color _expiredBorder = Color(0xFFEEEEEE);

  @override
  Widget build(BuildContext context) {
    final bool isExpired = offer.isExpired;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: isExpired ? _expiredBorder : _activeBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (offer.usageNote.isNotEmpty) ...[
            _OfferCardTagHeader(
              usageNote: offer.usageNote,
              hasProgress: offer.hasProgress,
              isExpired: isExpired,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
          ],
          _OfferCardMainHeader(offer: offer, isExpired: isExpired),
          const SizedBox(height: AppDimensions.spacingLg),
          _OfferCardMetadataChips(offer: offer, isExpired: isExpired),
          if (!isExpired && offer.code.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingLg),
            _OfferCardCodeActionRow(code: offer.code),
          ],
        ],
      ),
    );
  }
}

class _OfferCardTagHeader extends StatelessWidget {
  final String usageNote;
  final bool hasProgress;
  final bool isExpired;

  const _OfferCardTagHeader({
    required this.usageNote,
    required this.hasProgress,
    required this.isExpired,
  });

  static const Color _activeTagBg = Color(0x0C0457D1);
  static const Color _activeTagText = Color(0xFF0457D1);
  static const Color _purpleTagBg = Color(0x0C3F1CA6);
  static const Color _purpleTagText = Color(0xFF3F1CA6);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isExpired
        ? Colors.grey.shade200
        : (hasProgress ? _purpleTagBg : _activeTagBg);

    final Color textColor = isExpired
        ? Colors.grey.shade600
        : (hasProgress ? _purpleTagText : _activeTagText);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        usageNote,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontFamily: 'IBMPlexSansArabic',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _OfferCardMainHeader extends StatelessWidget {
  final Offer offer;
  final bool isExpired;

  const _OfferCardMainHeader({required this.offer, required this.isExpired});

  static const Color _activeTagBg = Color(0x0C0457D1);
  static const Color _activeTagText = Color(0xFF0457D1);
  static const Color _activeTitleColor = Color(0xFF181818);
  static const Color _activeDescColor = Color(0xFF979797);
  static const Color _expiredTextColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offer.name,
                style: TextStyle(
                  color: isExpired ? _expiredTextColor : _activeTitleColor,
                  fontSize: 18,
                  fontFamily: 'IBMPlexSansArabic',
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              if (offer.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  offer.description,
                  style: TextStyle(
                    color: isExpired ? _expiredTextColor : _activeDescColor,
                    fontSize: 14,
                    fontFamily: 'IBMPlexSansArabic',
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingSm),
          decoration: BoxDecoration(
            color: isExpired ? Colors.grey.shade100 : _activeTagBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Icon(
            offer.iconData,
            color: isExpired ? Colors.grey : _activeTagText,
            size: 26,
          ),
        ),
      ],
    );
  }
}

class _OfferCardMetadataChips extends StatelessWidget {
  final Offer offer;
  final bool isExpired;

  const _OfferCardMetadataChips({required this.offer, required this.isExpired});

  static const Color _chipTextColor = Color(0xFF707070);
  static const Color _expiredTextColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      children: [
        if (isExpired)
          const _OfferCardChip(
            icon: Icons.access_time_filled_rounded,
            text: OffersCopy.expiredTag,
            isExpired: true,
          )
        else if (offer.daysRemaining >= 0)
          _OfferCardChip(
            icon: Icons.calendar_today_outlined,
            text:
                '${OffersCopy.daysRemainingPrefix} ${offer.daysRemaining} ${OffersCopy.daysSuffix}',
            isExpired: false,
          ),
        if (offer.hasProgress)
          _OfferCardChip(
            icon: Icons.people_outline_rounded,
            childWidget: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                '${offer.progressCurrent}/${offer.progressTarget}',
                style: TextStyle(
                  color: isExpired ? _expiredTextColor : _chipTextColor,
                  fontSize: 12,
                  fontFamily: 'IBMPlexSansArabic',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            isExpired: isExpired,
          ),
      ],
    );
  }
}

class _OfferCardChip extends StatelessWidget {
  final IconData icon;
  final String? text;
  final Widget? childWidget;
  final bool isExpired;

  const _OfferCardChip({
    required this.icon,
    this.text,
    this.childWidget,
    required this.isExpired,
  });

  static const Color _chipBg = Color(0xFFF7F7F7);
  static const Color _chipTextColor = Color(0xFF707070);
  static const Color _expiredTextColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _chipBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isExpired ? _expiredTextColor : _chipTextColor,
          ),
          const SizedBox(width: 6),
          childWidget ??
              Text(
                text ?? '',
                style: TextStyle(
                  color: isExpired ? _expiredTextColor : _chipTextColor,
                  fontSize: 12,
                  fontFamily: 'IBMPlexSansArabic',
                  fontWeight: FontWeight.w500,
                ),
              ),
        ],
      ),
    );
  }
}

class _OfferCardCodeActionRow extends StatelessWidget {
  final String code;

  const _OfferCardCodeActionRow({required this.code});

  static const Color _codeBorderColor = Color(0xFF0457D1);
  static const Color _codeBgColor = Color(0x0C0457D1);
  static const Color _snackBgColor = Color(0xFF16865F);
  static const Color _activeTitleColor = Color(0xFF181818);

  Future<void> _copyCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Text(
                OffersCopy.codeCopiedSuccess,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IBMPlexSansArabic',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _snackBgColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppDimensions.spacingLg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
              vertical: AppDimensions.spacingMd,
            ),
            decoration: BoxDecoration(
              color: _codeBgColor,
              border: Border.all(color: _codeBorderColor, width: 1.5),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Center(
              child: Text(
                code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _codeBorderColor,
                  fontSize: 16,
                  fontFamily: 'IBMPlexSansArabic',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _copyCode(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMd,
                vertical: AppDimensions.spacingMd,
              ),
              side: const BorderSide(color: _codeBorderColor, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              foregroundColor: _activeTitleColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.copy_rounded, size: 18, color: _activeTitleColor),
                SizedBox(width: AppDimensions.spacingXs),
                Text(
                  OffersCopy.copyCode,
                  style: TextStyle(
                    color: _activeTitleColor,
                    fontSize: 15,
                    fontFamily: 'IBMPlexSansArabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
