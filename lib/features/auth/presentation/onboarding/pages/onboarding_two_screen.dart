import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/core/routes/app_routes.dart';
import 'package:home_service/core/theme/app_colors.dart';
import 'package:home_service/features/auth/presentation/onboarding/widgets/custom_button.dart';

class OnboadingTwoScreen extends StatefulWidget {
  const OnboadingTwoScreen({super.key});

  @override
  State<OnboadingTwoScreen> createState() => _OnboadingTwoScreenState();
}

class _OnboadingTwoScreenState extends State<OnboadingTwoScreen> {
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
              Gap(10),
              Image.asset(AppAssets.onboarding2, width: 430, height: 260),
              Gap(20),
              const Text.rich(
                textAlign: TextAlign.center,

                TextSpan(
                  children: [
                    TextSpan(
                      text: 'اطلب خدمتك',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: " في خطوات\n بسيطة",
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w600,
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
                  'اختر الخدمة الي محتاجها، حدد الموعد و المكان.. و سيب \nالباقي  علينا',
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
                    width: 36,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(0xFF168B72),
                      borderRadius: BorderRadius.circular(20),
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
                ],
              ),
              Gap(30),
              CustomButton(
                text: 'التالي',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.onboardingThree);
                },
              ),

              Gap(5),
              CustomButton(
                text: 'تخطي',
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
              ),

              Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
