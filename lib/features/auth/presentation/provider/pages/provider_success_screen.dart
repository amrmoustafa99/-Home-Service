import 'package:flutter/material.dart';
import 'package:home_service/core/constants/app_provider.dart';
import 'package:home_service/features/auth/presentation/provider/pages/provider_intro_screen.dart';
import 'package:home_service/features/auth/presentation/provider/widgets/primary_button.dart';


class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                          color: kPrimaryLight, shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: 92,
                          height: 92,
                          decoration: const BoxDecoration(
                              color: kPrimary, shape: BoxShape.circle),
                          child: const Icon(Icons.check,
                              color: Colors.white, size: 54),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('تم إرسال طلبك بنجاح',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: kPrimary)),
                    const SizedBox(height: 8),
                    const Text(
                      'شكرا لتقديم طلب الانضمام إلى فريق أي خدمة، سيتم مراجعة بياناتك و التواصل معك قريبا.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              PrimaryButton('العودة للرئيسية', onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const IntroScreen()),
                  (_) => false,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}