import 'package:flutter/material.dart';
import 'package:home_service/core/constants/app_provider.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const PrimaryButton(this.text, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  const FieldLabel(
    this.text, {
    super.key,
    this.required = false,
    required String label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kText,
              ),
            ),
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

InputDecoration deco(String hint, {IconData? icon}) {
  OutlineInputBorder b(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: c),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: kHint, fontSize: 12),
    suffixIcon: icon == null ? null : Icon(icon, size: 20, color: kHint),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: b(kBorder),
    enabledBorder: b(kBorder),
    focusedBorder: b(kPrimary),
  );
}

class PageTitle extends StatelessWidget {
  final String title, subtitle;
  const PageTitle(this.title, this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: kPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class StepperHeader extends StatelessWidget {
  final int current; // 0..3
  const StepperHeader({super.key, required this.current});

  static const labels = [
    'بياناتك',
    'خبرتك و خدماتك',
    'نطاق العمل والوقت المتاح',
    'مراجعة و إرسال',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(4, (i) {
          final done = i < current;
          final active = i == current;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i == 0
                            ? Colors.transparent
                            : (i <= current ? kPrimary : kBorder),
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (done || active)
                            ? kPrimary
                            : const Color(0xFFE8EAEC),
                      ),
                      child: done
                          ? const Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            )
                          : Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: active ? Colors.white : kHint,
                              ),
                            ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i == 3
                            ? const Color.fromRGBO(0, 0, 0, 0)
                            : (i < current ? kPrimary : kBorder),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 8.5, color: Colors.black87),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Common layout for the 4 steps: header + stepper + scrollable body + bottom button.
class StepScaffold extends StatelessWidget {
  final int step;
  final Widget child;
  final String buttonText;
  final VoidCallback onNext;

  const StepScaffold({
    super.key,
    required this.step,
    required this.child,
    required this.onNext,
    this.buttonText = 'التالي',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Center(
                      child: Text(
                        'انضم إلينا',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: "IBMPlexSansArabic",
                        ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_forward, size: 25),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: StepperHeader(current: step),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: child,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: PrimaryButton(buttonText, onTap: onNext),
            ),
          ],
        ),
      ),
    );
  }
}
