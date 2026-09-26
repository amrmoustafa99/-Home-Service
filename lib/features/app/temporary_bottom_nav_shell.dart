import 'package:flutter/material.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/core/theme/app_colors.dart';

// TODO(team-b): temporary scaffolding bottom nav for local testing only.
// Remove once Team A's shared Bottom Navigation component is wired in.
class TemporaryBottomNavShell extends StatefulWidget {
  const TemporaryBottomNavShell({super.key, required this.pages});

  final List<Widget> pages;

  @override
  State<TemporaryBottomNavShell> createState() => _TemporaryBottomNavShellState();
}

class _TemporaryBottomNavShellState extends State<TemporaryBottomNavShell> {
  static const Duration _transitionDuration = Duration(milliseconds: 175);
  static const int _centerTabIndex = 2;

  int _index = 0;

  void _onTap(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    const iconTabs = [
      (icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'الرئيسية'),
      (
        icon: Icons.grid_view_outlined,
        selectedIcon: Icons.grid_view,
        label: 'الخدمات',
      ),
      (
        icon: Icons.calendar_month_outlined,
        selectedIcon: Icons.calendar_month,
        label: 'حجوزاتي',
      ),
      (
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'الحساب',
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(index: _index, children: widget.pages),
        bottomNavigationBar: _BottomNavBar(
          iconTabs: iconTabs,
          centerTabIndex: _centerTabIndex,
          selectedIndex: _index,
          transitionDuration: _transitionDuration,
          onSelect: _onTap,
        ),
      ),
    );
  }
}

/// Shared metrics for all five tabs so icons, image and labels stay aligned
/// on any screen size. The bar height is content-driven (no fixed height),
/// and horizontal sizing uses Expanded slots, so nothing can overflow.
abstract final class _NavMetrics {
  static const double pillHorizontalPadding = 16;
  static const double pillVerticalPadding = 6;
  static const double pillRadius = 20;
  static const double iconSize = 26;
  static const double imageSize = 56;
  static const double imageRadius = 14;
  static const double imageRaise = imageSize * 0.32;
  static const double pillRowHeight = pillVerticalPadding * 2 + iconSize;
  static const double labelGap = 4;
  static const double labelFontSize = 12;
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.iconTabs,
    required this.centerTabIndex,
    required this.selectedIndex,
    required this.transitionDuration,
    required this.onSelect,
  });

  final List<({IconData icon, IconData selectedIcon, String label})> iconTabs;
  final int centerTabIndex;
  final int selectedIndex;
  final Duration transitionDuration;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final tabCount = iconTabs.length + 1;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var slot = 0; slot < tabCount; slot++)
                  Expanded(
                    child: slot == centerTabIndex
                        ? _CenterTabItem(
                            label: 'الفني الذكي',
                            selected: selectedIndex == centerTabIndex,
                            animationDuration: transitionDuration,
                            onTap: () => onSelect(centerTabIndex),
                          )
                        : _IconTabItem(
                            icon: _iconTabsFor(slot, slot < centerTabIndex)
                                .icon,
                            selectedIcon: _iconTabsFor(
                              slot,
                              slot < centerTabIndex,
                            ).selectedIcon,
                            label: _iconTabsFor(
                              slot,
                              slot < centerTabIndex,
                            ).label,
                            selected: selectedIndex == slot,
                            animationDuration: transitionDuration,
                            onTap: () => onSelect(slot),
                          ),
                  ),
              ],
            ),
            _RaisedCenterImage(
              assetPath: AppAssets.smartTechnician,
              onTap: () => onSelect(centerTabIndex),
            ),
          ],
        ),
      ),
    );
  }

  ({IconData icon, IconData selectedIcon, String label}) _iconTabsFor(
    int slot,
    bool beforeCenter,
  ) {
    final index = beforeCenter ? slot : slot - 1;
    return iconTabs[index];
  }
}

class _IconTabItem extends StatelessWidget {
  const _IconTabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.animationDuration,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final Duration animationDuration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.figmaDarkGreen;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: animationDuration,
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: _NavMetrics.pillHorizontalPadding,
              vertical: _NavMetrics.pillVerticalPadding,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(_NavMetrics.pillRadius),
            ),
            child: AnimatedSwitcher(
              duration: animationDuration,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Icon(
                selected ? selectedIcon : icon,
                key: ValueKey(selected),
                color: selected ? accent : AppColors.textSecondary,
                size: _NavMetrics.iconSize,
              ),
            ),
          ),
          const SizedBox(height: _NavMetrics.labelGap),
          _NavLabel(
            label: label,
            selected: selected,
            animationDuration: animationDuration,
          ),
        ],
      ),
    );
  }
}

class _CenterTabItem extends StatelessWidget {
  const _CenterTabItem({
    required this.label,
    required this.selected,
    required this.animationDuration,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Duration animationDuration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _NavMetrics.imageSize,
            height: _NavMetrics.pillRowHeight,
            child: Center(
              child: AnimatedContainer(
                duration: animationDuration,
                curve: Curves.easeOut,
                width: _NavMetrics.pillRowHeight,
                height: _NavMetrics.pillRowHeight,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryContainer
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: _NavMetrics.labelGap),
          _NavLabel(
            label: label,
            selected: selected,
            animationDuration: animationDuration,
          ),
        ],
      ),
    );
  }
}

/// The technician image floats above the bar, centered over the middle tab
/// and raised slightly via a paint-only translation, so the underlying Row
/// layout stays fully responsive and clip-free.
class _RaisedCenterImage extends StatelessWidget {
  const _RaisedCenterImage({required this.assetPath, required this.onTap});

  final String assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -_NavMetrics.imageRaise),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_NavMetrics.imageRadius),
          child: Image.asset(
            assetPath,
            width: _NavMetrics.imageSize,
            height: _NavMetrics.imageSize,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _NavLabel extends StatelessWidget {
  const _NavLabel({
    required this.label,
    required this.selected,
    required this.animationDuration,
  });

  final String label;
  final bool selected;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.figmaDarkGreen;

    return AnimatedDefaultTextStyle(
      duration: animationDuration,
      curve: Curves.easeOut,
      style: TextStyle(
        fontSize: _NavMetrics.labelFontSize,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        color: selected ? accent : AppColors.textfromfield,
      ),
      child: Text(label),
    );
  }
}