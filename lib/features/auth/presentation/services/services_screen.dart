import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/features/auth/presentation/services/service_categories.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  static const Color primaryGreen = Color(0xFF0F5A47);

  void _openCategory(
    BuildContext context, {
    required String title,
    required String categoryId,
    String subtitle = '',
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceCategoryScreen(
          categoryTitle: title,
          categoryId: categoryId, 
        ),
      ),
    );
  }

  late final List<_ServiceCategory> services = [
    _ServiceCategory(
      icon: AppAssets.cleaning,
      label: 'النظافة والتعقيم',
      onTap: (context) => _openCategory(
        context,
        title: 'النظافة والتعقيم',
        categoryId: 'cleaning',
        subtitle: 'تنظيف شامل للمنازل والمكاتب وتعقيم احترافي',
      ),
    ),

    _ServiceCategory(
      icon: AppAssets.repair,
      label: 'التشطيب والإصلاح',
      onTap: (context) => _openCategory(
        context,
        title: 'التشطيب والإصلاح',
        categoryId: 'finishing',
      ),
    ),

    _ServiceCategory(
      icon: AppAssets.laundry,
      label: 'الصيانة المنزلية',
      onTap: (context) => _openCategory(
        context,
        title: 'الصيانة المنزلية',
        categoryId: 'maintenance',
      ),
    ),

    _ServiceCategory(
      icon: AppAssets.delivery,
      label: 'النقل والتركيب',
      onTap: (context) => _openCategory(
        context,
        title: 'النقل والتركيب',
        categoryId: 'transportation',
      ),
    ),

    _ServiceCategory(
      icon: AppAssets.security,
      label: 'الأنظمة الأمنية',
      onTap: (context) => _openCategory(
        context,
        title: 'الأنظمة الأمنية',
        categoryId: 'security',
      ),
    ),

    _ServiceCategory(
      icon: AppAssets.dailyServices,
      label: 'الخدمات اليومية',
      onTap: (context) => _openCategory(
        context,
        title: 'الخدمات اليومية',
        categoryId: 'daily_services',
      ),
    ),

    _ServiceCategory(
      icon: AppAssets.gardening,
      label: 'خدمات الحدائق',
      onTap: (context) => _openCategory(
        context,
        title: 'خدمات الحدائق',
        categoryId: 'gardening',
      ),
    ),

    _ServiceCategory(
      icon: AppAssets.carRepair,
      label: 'صيانة السيارات',
      onTap: (context) => _openCategory(
        context,
        title: 'صيانة السيارات',
        categoryId: 'car_repair',
      ),
    ),

    const _ServiceCategory(
      icon: '',
      label: 'الخدمات السريعة',
      isHighlight: true,
    ),
  ];

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
          centerTitle: true,
          title: const Text(
            'الخدمات',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  AppAssets.notifications,
                  width: 26,
                  height: 26,
                ),
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                AppAssets.logo,
                height: 32,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Gap(12),
                _buildSearchField(),
                const Gap(20),
                const Text(
                  'كل اللي تحتاجه هنا!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Gap(16),
                _buildServicesGrid(),
                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: primaryGreen,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'ابحث عن خدمة : التنظيف الشامل ....',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.35),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
    if (service.isHighlight) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Icon(
                Icons.stars_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              service.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () {
        service.onTap?.call(context);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F8),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                service.icon,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              service.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCategory {
  final String icon;
  final String label;
  final bool isHighlight;
  final void Function(BuildContext context)? onTap;

  const _ServiceCategory({
    required this.icon,
    required this.label,
    this.isHighlight = false,
    this.onTap,
  });
}
