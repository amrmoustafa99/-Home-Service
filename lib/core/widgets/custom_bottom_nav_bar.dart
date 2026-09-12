import 'package:flutter/material.dart';
import 'package:home_service/core/constants/app_assets.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // ألوان التصميم
  static const Color activeColor = Color(0xFF00695C); // أخضر داكن
  static const Color inactiveColor = Color(0xFF707070); // رمادي

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 90,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // خلفية الشريط
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: 'الرئيسية',
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: Icons.grid_view_outlined,
                      activeIcon: Icons.grid_view,
                      label: 'الخدمات',
                    ),
                    // مساحة فاضية للأيقونة المرفوعة في المنتصف
                    const SizedBox(width: 60),
                    _buildNavItem(
                      index: 3,
                      icon: Icons.calendar_today_outlined,
                      activeIcon: Icons.calendar_today,
                      label: 'حجوزاتي',
                    ),
                    _buildNavItem(
                      index: 4,
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: 'الحساب',
                    ),
                  ],
                ),
              ),
            ),

            // الأيقونة المرفوعة (الفني الذكي)
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () => onTap(2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeColor,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      // ضع هنا صورة/أيقونة الروبوت الخاصة بك
                      child:  Image.asset(
                        AppAssets.chatbot,
                        // color: Colors.white,
                        // size: 30,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الفني الذكي',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: currentIndex == 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: currentIndex == 2 ? activeColor : inactiveColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isActive = currentIndex == index;
    final Color color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? activeIcon : icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}


