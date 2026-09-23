import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../data/models/offer_model.dart';
import '../../data/models/offers_copy.dart';
import '../../data/repositories/offers_repository.dart';
import '../../logic/cubit/offers_cubit.dart';
import '../../logic/cubit/offers_state.dart';
import '../widgets/info_card.dart';
import '../widgets/offer_card.dart';
import '../widgets/offers_empty_view.dart';
import '../widgets/offers_error_view.dart';
import '../widgets/offers_shimmer_loading.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OffersCubit(FirebaseOffersRepository())..fetchOffers(),
      child: const _OffersView(),
    );
  }
}

class _OffersView extends StatefulWidget {
  const _OffersView();

  @override
  State<_OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<_OffersView> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: const Text(
            OffersCopy.screenTitle,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontFamily: 'IBMPlexSansArabic',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocBuilder<OffersCubit, OffersState>(
          builder: (context, state) {
            return switch (state) {
              OffersInitial() ||
              OffersLoading() => const OffersShimmerLoading(),
              OffersEmpty() => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => context.read<OffersCubit>().fetchOffers(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: const OffersEmptyView(),
                  ),
                ),
              ),
              OffersError(:final message) => OffersErrorView(
                message: message,
                onRetry: () => context.read<OffersCubit>().retryFetch(),
              ),
              OffersLoaded(:final offers) => _buildLoadedContent(
                context,
                offers,
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, List<Offer> offers) {
    final activeOffers = offers.where((o) => !o.isExpired).toList();
    final expiredOffers = offers.where((o) => o.isExpired).toList();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => context.read<OffersCubit>().fetchOffers(),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.spacingMd),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
            ),
            child: _OffersTabBar(
              selectedIndex: _selectedTabIndex,
              activeCount: activeOffers.length,
              expiredCount: expiredOffers.length,
              onTabChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _selectedTabIndex == 0
                  ? _AvailableOffersTab(offers: activeOffers)
                  : _ExpiredOffersTab(offers: expiredOffers),
            ),
          ),
        ],
      ),
    );
  }
}

class _OffersTabBar extends StatelessWidget {
  final int selectedIndex;
  final int activeCount;
  final int expiredCount;
  final ValueChanged<int> onTabChanged;

  const _OffersTabBar({
    required this.selectedIndex,
    required this.activeCount,
    required this.expiredCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: '${OffersCopy.availableTab} ($activeCount)',
              isSelected: selectedIndex == 0,
              onTap: () => onTabChanged(0),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _TabButton(
              label: '${OffersCopy.expiredTab} ($expiredCount)',
              isSelected: selectedIndex == 1,
              onTap: () => onTabChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD8F0E2) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF053429)
                : const Color(0xFF707070),
            fontSize: 15,
            fontFamily: 'IBMPlexSansArabic',
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _AvailableOffersTab extends StatelessWidget {
  final List<Offer> offers;

  const _AvailableOffersTab({required this.offers});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingLg,
        vertical: AppDimensions.spacingSm,
      ),
      children: [
        Row(
          children: const [
            Icon(Icons.stars_rounded, color: AppColors.primary, size: 22),
            SizedBox(width: AppDimensions.spacingSm),
            Text(
              OffersCopy.availableHeader,
              style: TextStyle(
                color: Color(0xFF090909),
                fontSize: 18,
                fontFamily: 'IBMPlexSansArabic',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        if (offers.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: OffersEmptyView(message: OffersCopy.emptyAvailableOffers),
          )
        else
          for (final offer in offers) ...[
            OfferCard(offer: offer),
            const SizedBox(height: AppDimensions.spacingLg),
          ],
        const SizedBox(height: AppDimensions.spacingSm),
        const OffersInfoCard(),
        const SizedBox(height: AppDimensions.spacing2xl),
      ],
    );
  }
}

class _ExpiredOffersTab extends StatelessWidget {
  final List<Offer> offers;

  const _ExpiredOffersTab({required this.offers});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingLg,
        vertical: AppDimensions.spacingSm,
      ),
      children: [
        Row(
          children: const [
            Icon(
              Icons.history_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
            SizedBox(width: AppDimensions.spacingSm),
            Text(
              OffersCopy.expiredHeader,
              style: TextStyle(
                color: Color(0xFF090909),
                fontSize: 18,
                fontFamily: 'IBMPlexSansArabic',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        if (offers.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: OffersEmptyView(message: OffersCopy.emptyExpiredOffers),
          )
        else
          for (final offer in offers) ...[
            OfferCard(offer: offer),
            const SizedBox(height: AppDimensions.spacingLg),
          ],
        const SizedBox(height: AppDimensions.spacing2xl),
      ],
    );
  }
}
