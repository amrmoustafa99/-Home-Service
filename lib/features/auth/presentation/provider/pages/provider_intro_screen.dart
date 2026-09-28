import 'package:flutter/material.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/core/constants/app_provider.dart';
import 'package:home_service/features/auth/data/provider/join_data.dart';
import 'package:home_service/features/auth/presentation/provider/pages/provider_personal_data_screen.dart';
import 'package:home_service/features/auth/presentation/provider/widgets/primary_button.dart';



class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Image.asset(
              AppAssets.logo,
              width: 130,
                height: 104,
                // errorBuilder: (_, __, ___) => const Text('أي خدمة',
                //     style: TextStyle(
                //         fontSize: 28,
                //         fontWeight: FontWeight.w900,
                //         color: kPrimary)),
              ),
              const SizedBox(height: 20),
              const Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: 'انضم إلى فريق أي\n',
                      style: TextStyle(color: kText,fontFamily: "IBMPlexSansArabic")),
                  TextSpan(text: 'خدمة', style: TextStyle(color: kPrimary)),
                ]),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              const Text(
                'شارك خبراتك وكن جزءا من شبكتنا لتقديم\nأفضل الخدمات للعملاء',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF3F3F3F)),
              ),
              Expanded(
                child: Image.asset(
                  AppAssets.providerIntro,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.engineering, size: 160, color: kPrimary),
                ),
              ),
              PrimaryButton('ابدأ التسجيل', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PersonalDataScreen(data: JoinData()),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}