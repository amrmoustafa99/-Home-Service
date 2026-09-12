import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/core/theme/app_colors.dart';
import 'package:home_service/core/widgets/custom_bottom_nav_bar.dart';
import 'package:home_service/features/auth/logic/service/service_cubit.dart';
import 'package:home_service/features/auth/logic/service/service_state.dart';
import 'package:home_service/features/auth/presentation/services/data/models/service_model.dart';
import 'package:home_service/features/auth/presentation/services/data/service_repository.dart';


class ServiceCategoryScreen extends StatelessWidget {
  final String categoryTitle;
  final String categoryId;
const ServiceCategoryScreen({
  super.key,
  required this.categoryTitle,
  required this.categoryId,
});

  // static const Color primaryGreen = Color(0xFF1D5C4B);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceCubit(
        ServiceRepository(),
      )..getServicesByCategory(categoryId),
      child: _ServiceCategoryView(
        categoryTitle: categoryTitle,
      ),
    );
  }
}

class _ServiceCategoryView extends StatefulWidget {
  final String categoryTitle;

  const _ServiceCategoryView({
    required this.categoryTitle,
  });

  @override
  State<_ServiceCategoryView> createState() => _ServiceCategoryViewState();
}

class _ServiceCategoryViewState extends State<_ServiceCategoryView> {
  final TextEditingController searchController = TextEditingController();

  List<ServiceModel> allServices = [];
  List<ServiceModel> filteredServices = [];

  @override
  void initState() {
    super.initState();

    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();

    setState(() {
      if (query.isEmpty) {
        filteredServices = allServices;
      } else {
        filteredServices = allServices
            .where(
              (service) => service.name.contains(query),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String getServiceImage(String imageName) {
    switch (imageName) {
      case 'building':
        return AppAssets.building;

      case 'pool':
        return AppAssets.pool;

      case 'apartment':
        return AppAssets.apartment;

      case 'bugs':
        return AppAssets.bugs;

      case 'houses':
        return AppAssets.houses;

      case 'office':
        return AppAssets.office;

      case 'sofa':
        return AppAssets.sofa;

      case 'kitchen':
        return AppAssets.kitchen;

      default:
        return AppAssets.cleaning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
     textDirection: TextDirection.rtl,
  child: Scaffold(
    backgroundColor: const Color(0xFFF9FAF9),

    bottomNavigationBar: CustomBottomNavBar(
      currentIndex: 1,
      onTap: (index) {
        if (index == 1) {
          return;
        }

        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/home');
        }

        if (index == 2) {
          // صفحة الفني الذكي
        }

        if (index == 3) {
          // صفحة حجوزاتي
        }

        if (index == 4) {
          // صفحة الحساب
        }
      },
    ),
        // ================= APP BAR =================

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,

          leading: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              AppAssets.cleaning,
              height: 34,
              width: 34,
            ),
          ),

          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ],

          centerTitle: true,

          title: Text(
            widget.categoryTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),

        // ================= BODY =================

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 18),

              _buildSearchField(),

              const SizedBox(height: 22),

              _buildSectionHeader(),

              const SizedBox(height: 18),

              Expanded(
                child: BlocBuilder<ServiceCubit, ServiceState>(
                  builder: (context, state) {
                    // ================= LOADING =================

                    if (state is ServiceLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGreen,
                        ),
                      );
                    }

                    // ================= ERROR =================

                    if (state is ServiceError) {
                      return _buildErrorState(
                        state.message,
                      );
                    }

                    // ================= EMPTY =================

                    if (state is ServiceEmpty) {
                      return _buildEmptyState(
                        message: 'لا توجد خدمات متاحة حاليًا',
                      );
                    }

                    // ================= LOADED =================

                    if (state is ServiceLoaded) {
                      if (allServices != state.services) {
                        allServices = state.services;

                        if (searchController.text.trim().isEmpty) {
                          filteredServices = state.services;
                        }
                      }

                      if (filteredServices.isEmpty) {
                        return _buildEmptyState(
                          message: 'لم يتم العثور على خدمة',
                        );
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),

                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),

                        itemCount: filteredServices.length,

                        separatorBuilder: (_, __) {
                          return const SizedBox(height: 14);
                        },

                        itemBuilder: (context, index) {
                          return _buildServiceCard(
                            filteredServices[index],
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SEARCH FIELD
  // =========================================================

  Widget _buildSearchField() {
    return Container(
      height: 52,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: TextField(
        controller: searchController,

        textAlign: TextAlign.right,

        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),

        decoration: InputDecoration(
          hintText:
              'ابحث عن خدمة ${widget.categoryTitle}...',

          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
          ),

          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.primaryGreen,
            size: 22,
          ),

          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    searchController.clear();
                  },

                  icon: const Icon(
                    Icons.close,
                    size: 19,
                    color: Colors.grey,
                  ),
                )
              : null,

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SECTION HEADER
  // =========================================================

  Widget _buildSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,

              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 8),

            Text(
              widget.categoryTitle,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          'تصفح الخدمات المتاحة واختر الخدمة المناسبة لك',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // SERVICE CARD
  // =========================================================

  Widget _buildServiceCard(ServiceModel service) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          // =================================================
          // IMAGE + TEXT
          // =================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ================= IMAGE =================

              ClipRRect(
                borderRadius: BorderRadius.circular(13),

                child: Image.asset(
                  getServiceImage(service.image),

                  width: 88,
                  height: 88,

                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 14),

              // ================= TEXT =================

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      service.name,

                      textAlign: TextAlign.left,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        fontFamily: "IBMPlexSansArabic",
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      service.description,

                      textAlign: TextAlign.start,

                      maxLines: 3,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${service.price} جنيه',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =================================================
          // BUTTONS
          // =================================================

          Row(
            children: [
              // ================= DETAILS =================

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'عرض تفاصيل ${service.name}',
                        ),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 13,
                  ),

                  label: const Text(
                    'عرض التفاصيل',
                  ),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,

                    side: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: 1.2,
                    ),

                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    textStyle: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ================= ORDER =================

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم اختيار ${service.name}',
                        ),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: Colors.white,
                  ),

                  label: const Text(
                    'اطلب الآن',
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,

                    foregroundColor: Colors.white,

                    elevation: 0,

                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    textStyle: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmptyState({
    String message = 'لم يتم العثور على خدمة',
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            Icons.search_off_rounded,
            size: 60,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'جربي البحث باسم خدمة أخرى',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ERROR STATE
  // =========================================================

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red.shade300,
          ),

          const SizedBox(height: 12),

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: () {
              context
                  .read<ServiceCubit>()
                  .getServicesByCategory(
                    '',
                  );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),

            child: const Text(
              'إعادة المحاولة',
            ),
          ),
        ],
      ),
    );
  }
}
