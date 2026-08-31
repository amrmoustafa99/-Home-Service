import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/core/routes/app_routes.dart';
import 'package:home_service/features/auth/presentation/onboarding/widgets/custom_button.dart';

class OnboadingFourScreen extends StatefulWidget {
  const OnboadingFourScreen({super.key});

  @override
  State<OnboadingFourScreen> createState() => _OnboadingFourScreenState();
}

class _OnboadingFourScreenState extends State<OnboadingFourScreen> {
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
              Image.asset(AppAssets.onboarding4, width: 430, height: 260),
              Gap(25),
              const Text(
                textAlign: TextAlign.center,
                "عروض و خصومات حصرية",

                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'IBMPlexSansArabic',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    
              ),
              Gap(15),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  textAlign: TextAlign.center,
                  "استفييد من العروض و الخصومات الحصرية، و احصل\n على أفضل تجربة، من أول الطلب لحد إتمام الخدمة",
                  style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 96, 96, 96), fontFamily: 'Tajawal'),
                ),
              ),
              Gap(25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
              CustomButton( text: 'ابدأ الآن', onPressed: () { Navigator.pushNamed( context, AppRoutes.login, ); }, ),
            

              Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
