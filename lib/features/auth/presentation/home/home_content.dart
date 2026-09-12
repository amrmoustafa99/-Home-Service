import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/core/routes/app_routes.dart';
import 'package:home_service/features/auth/presentation/home/select_city_bottom_sheet.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  static const Color primaryGreen = Color(0xFF0F5A47);
  static const Color lightGreenBg = Color(0xFFE8F5E9);

  String selectedCity = 'سوهاج, اخميم';

  final List<_ServiceCategory> services = const [
    _ServiceCategory(icon: AppAssets.laundry, label: 'الصيانة المنزلية'),
    _ServiceCategory(icon: AppAssets.repair, label: 'التشطيب والإصلاح'),
    _ServiceCategory(icon: AppAssets.cleaning, label: 'النظافة والتعقيم'),
    _ServiceCategory(icon: AppAssets.dailyServices, label: 'الخدمات اليومية'),
    _ServiceCategory(icon: AppAssets.security, label: 'الأنظمة الأمنية'),
    _ServiceCategory(icon: AppAssets.delivery, label: 'النقل والتركيب'),
  ];

  Future<void> _openCitySelector() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectCityBottomSheet(currentCity: selectedCity),
    );

    if (result != null) {
      setState(() => selectedCity = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(AppAssets.notifications, width: 26, height: 26),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(AppAssets.logo, height: 32),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(8),
                _buildLocationRow(),
                const Gap(16),
                _buildSearchField(),
                const Gap(24),
                const Text(
                  'الخدمات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Gap(14),
                _buildServicesGrid(),
                const Gap(16),
                _buildShowAllButton(),
                const Gap(24),
                _buildPromoCard(),
                const Gap(12),
                _buildDotsIndicator(),
                const Gap(24),
                const Text(
                  'الخدمات السريعة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Gap(14),
                _buildQuickServicesList(),
                const Gap(24),
                const Text(
                  'لماذا تختارنا',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Gap(14),
                _buildWhyChooseUs(),
                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // صف العنوان
  Widget _buildLocationRow() {
    return GestureDetector(
      onTap: _openCitySelector,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: primaryGreen, size: 22),
          const SizedBox(width: 4),
          const Text(
            'العنوان : ',
            style: TextStyle(color: Colors.black45, fontSize: 15),
          ),
          Text(
            selectedCity,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down, color: primaryGreen, size: 22),
        ],
      ),
    );
  }

  // حقل البحث
  Widget _buildSearchField() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: primaryGreen, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'ابحث عن خدمة : التنظيف الشامل ....',
              style: TextStyle(color: Colors.black.withOpacity(0.35), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // شبكة الخدمات
  Widget _buildServicesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        return _buildServiceItem(services[index]);
      },
    );
  }

  Widget _buildServiceItem(_ServiceCategory service) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(service.icon, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(
            service.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 1.2),
          ),
        ],
      ),
    );
  }

  // زر عرض جميع الخدمات
  Widget _buildShowAllButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        onPressed: () {
            Navigator.pushNamed(context, AppRoutes.services); 
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE3F2ED),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.arrow_back, color: primaryGreen, size: 18),
        label: const Text(
          'عرض جميع الخدمات',
          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  // كارت الإعلان الترويجي
  Widget _buildPromoCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          SizedBox(
            height: 170,
            width: double.infinity,
            child: Image.asset(AppAssets.acpromoBanner, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بدأنا الصيف ؟',
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  'خدمة صيانة وتركيب\nالتكييف بكفاءة عالية',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, height: 1.3),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('احجز الآن', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // مؤشر النقاط
  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final bool isActive = index == 0;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? primaryGreen : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  // قسم الخدمات السريعة
  Widget _buildQuickServicesList() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 260,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.water_drop_outlined, color: Colors.grey.shade600, size: 36),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'خصم 20%',
                          style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('تركيب حنافية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const Text('يبدأ من:', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      const Text('100 ج.م', style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen, fontSize: 12)),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFE3F2ED),
                  child: const Icon(Icons.arrow_back, color: primaryGreen, size: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // قسم لماذا تختارنا
  Widget _buildWhyChooseUs() {
    final items = [
      {'title': 'فنيون معتمدون', 'icon': Icons.verified_user_outlined},
      {'title': 'خدمة 24 ساعة', 'icon': Icons.calendar_month_outlined},
      {'title': 'أفضل الأسعار', 'icon': Icons.account_balance_wallet_outlined},
    ];

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2ED),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(item['icon'] as IconData, color: primaryGreen, size: 36),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ServiceCategory {
  final String icon;
  final String label;

  const _ServiceCategory({required this.icon, required this.label});
}
