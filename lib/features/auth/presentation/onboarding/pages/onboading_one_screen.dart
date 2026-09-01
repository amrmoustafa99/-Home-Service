import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/core/routes/app_routes.dart';
import 'package:home_service/core/theme/app_colors.dart';
import 'package:home_service/features/auth/presentation/onboarding/widgets/custom_button.dart';

class OnboadingOneScreen extends StatefulWidget {
  const OnboadingOneScreen({super.key});

  @override
  State<OnboadingOneScreen> createState() => _OnboadingOneScreenState();
}

class _OnboadingOneScreenState extends State<OnboadingOneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(50),
              Image.asset(AppAssets.logo, width: 100, height: 80),
              Gap(20),
              Image.asset(AppAssets.onboarding1, width: 430, height: 260),
              Gap(40),
              const Text.rich(
                textAlign: TextAlign.center,

                TextSpan(
                  children: [
                    TextSpan(
                      text: 'كل خدمات بيتك ',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'IBMPlexSansArabic',
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'في مكان\n واحد',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'IBMPlexSansArabic',
                        color: AppColors.textcolor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'من الصيانة والتنظيف لحد النقل والتركيب، اطلب الخدمة اللي \nمحتاجها بسهولة من تطبيق أي خدمة ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                    fontFamily: 'IBMPlexSansArabic',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Gap(25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    width: 36,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(0xFF168B72),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
              Gap(40),
              CustomButton(
                text: 'التالي',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.onboardingTwo);
                },
              ),
              Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
