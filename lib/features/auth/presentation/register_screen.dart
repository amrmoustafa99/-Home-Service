import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/core/theme/app_colors.dart';
import 'package:home_service/features/auth/logic/register/register_cubit.dart';
import 'package:home_service/features/auth/logic/register/register_state.dart';
import 'package:home_service/features/auth/presentation/login_screen.dart';

import '../data/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(AuthRepository()),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إنشاء الحساب بنجاح')),
            );

            // بعد النجاح ممكن نروح للـ Login
            Navigator.pushReplacementNamed(context, '/login');
          }

          if (state is RegisterFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final bool isLoading = state is RegisterLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: SizedBox(
                          height: 130,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 15,
                                right: 16,
                                child: SizedBox(
                                  width: 108,
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(
                                        0xFFF7F7F7,
                                      ).withValues(alpha: 0.5),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/FoundationHome');
                                    },
                                    child: Text(
                                      'تصفح كزائر',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontFamily: 'IBMPlexSansArabic',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  AppAssets.logo,
                                  width: 85,
                                  height: 70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff1A1A1A),
                          fontFamily: 'IBMPlexSansArabic',
                        ),
                      ),

                      const Gap(5),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'أنشئ حسابك وابدأ في طلب خدماتك بسهولة.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                            fontFamily: 'IBMPlexSansArabic',
                          ),
                        ),
                      ),

                      const Gap(30),

                      FieldLabel(label: 'الإسم بالكامل ', required: true),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: AppColors.textfromfield,
                              ),
                              hintText: 'أحمد علي السيد',
                              hintTextDirection: TextDirection.ltr,
                              suffixIcon: Icon(
                                Icons.person,
                                color: AppColors.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'من فضلك أدخل اسمك الكامل';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const Gap(16),

                      FieldLabel(label: 'رقم الهاتف', required: true),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: AppColors.textfromfield,
                              ),
                              hintText: '01xxxxxxxxx',
                              hintTextDirection: TextDirection.ltr,
                              suffixIcon: Icon(
                                Icons.phone_enabled_sharp,
                                color: AppColors.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'من فضلك أدخل رقم الهاتف';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const Gap(16),

                      FieldLabel(label: 'البريد الإلكتروني', required: true),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: AppColors.textfromfield,
                              ),
                              hintText: 'example@email.com',
                              hintTextDirection: TextDirection.ltr,
                              suffixIcon: Icon(
                                Icons.email_outlined,
                                color: AppColors.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'من فضلك أدخل البريد الإلكتروني';
                              }

                              final emailRegex = RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              );

                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'من فضلك أدخل بريد إلكتروني صحيح';
                              }

                              return null;
                            },
                          ),
                        ),
                      ),

                      const Gap(16),

                      FieldLabel(label: 'كلمة المرور', required: true),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSansArabic',
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: AppColors.textfromfield,
                              ),
                              hintText: '****************',
                              hintTextDirection: TextDirection.ltr,
                              prefixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              suffixIcon: Icon(
                                Icons.key_sharp,
                                color: AppColors.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'من فضلك أدخل كلمة المرور';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const Gap(10),

                      // زر إنشاء الحساب
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<RegisterCubit>().register(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text
                                            .trim(),
                                      );
                                    }
                                  },
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'إنشاء حساب',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'IBMPlexSansArabic',
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const Gap(12),

                      // التسجيل كمقدم خدمة
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // Navigator.pushNamed(
                              //   context,
                              //   '/provider-register',
                              // );
                            },
                            child: Text(
                              'التسجيل كمقدم خدمة',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontFamily: 'IBMPlexSansArabic',
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Gap(20),

                      // تسجيل الدخول
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'IBMPlexSansArabic',
                              color: Color(0xff979797),
                            ),
                            children: [
                              const TextSpan(text: 'لديك حساب بالفعل؟'),
                              TextSpan(
                                text: 'تسجيل الدخول',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
