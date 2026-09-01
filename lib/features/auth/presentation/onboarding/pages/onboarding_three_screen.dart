import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/core/routes/app_routes.dart';
import 'package:home_service/core/theme/app_colors.dart';
import 'package:home_service/features/auth/presentation/onboarding/widgets/custom_button.dart';

class OnboadingThreeScreen extends StatefulWidget {
  const OnboadingThreeScreen({super.key});

  @override
  State<OnboadingThreeScreen> createState() => _OnboadingThreeScreenState();
}

class _OnboadingThreeScreenState extends State<OnboadingThreeScreen> {
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
              Gap(25),
              Image.asset(AppAssets.onboarding3, width: 430, height: 260),
              Gap(25),
              const Text.rich(
                textAlign: TextAlign.center,

                TextSpan(
                  children: [
                    TextSpan(
                      text: 'فنيين موثوقيين',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: " لخدمتك",
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
              Gap(15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  textAlign: TextAlign.center,
                  "بنوصلك بفنيين متخصصين لتنفيذ خدمتك بجودة عالية\n .مع ضمانات تساعدك تطلب و انت مطمن",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 90, 89, 89),
                    fontFamily: 'Tajawal',
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
              Gap(35),
              CustomButton(
                text: 'التالي',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.onboardingFour);
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
