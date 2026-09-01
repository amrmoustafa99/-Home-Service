import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:home_service/core/theme/app_colors.dart';
import 'package:home_service/features/auth/logic/register/register_cubit.dart';
import 'package:home_service/features/auth/logic/register/register_state.dart';
import 'package:home_service/features/auth/presentation/login/login_screen.dart';
import 'package:home_service/features/auth/presentation/widgets/auth_button.dart';
import 'package:home_service/features/auth/presentation/widgets/auth_header.dart';
import 'package:home_service/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:home_service/features/auth/presentation/widgets/field_label.dart';
import 'package:home_service/features/auth/presentation/widgets/provider_register_button.dart';
// import 'package:home_service/features/auth/presentation/widgets/auth_header.dart';

import '../../data/auth_repository.dart';

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
                      const AuthHeader(),
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

                      // ---------------- FULL NAME ----------------
                      FieldLabel(label: 'الإسم بالكامل', required: true),

                      const Gap(8),

                      AuthTextField(
                        controller: _nameController,
                        hint: 'أحمد علي السيد',
                        icon: Icons.person,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'من فضلك أدخل اسمك الكامل';
                          }

                          return null;
                        },
                      ),

                      const Gap(16),

                      // ---------------- PHONE ----------------
                      FieldLabel(label: 'رقم الهاتف', required: true),

                      const Gap(8),

                      AuthTextField(
                        controller: _phoneController,
                        hint: '01xxxxxxxxx',
                        icon: Icons.phone_enabled_sharp,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'من فضلك أدخل رقم الهاتف';
                          }

                          return null;
                        },
                      ),

                      const Gap(16),

                      // ---------------- EMAIL ----------------
                      FieldLabel(label: 'البريد الإلكتروني', required: true),

                      const Gap(8),

                      AuthTextField(
                        controller: _emailController,
                        hint: 'example@email.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
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

                      const Gap(16),

                      // ---------------- PASSWORD ----------------
                      FieldLabel(label: 'كلمة المرور', required: true),

                      const Gap(8),

                      AuthTextField(
                        controller: _passwordController,
                        hint: '****************',
                        icon: Icons.key_sharp,
                        isPassword: true,
                        obscurePassword: _obscurePassword,
                        onTogglePassword: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك أدخل كلمة المرور';
                          }

                          return null;
                        },
                      ),
                      const Gap(10),

                      // زر إنشاء الحساب
                      AuthButton(
                        text: 'إنشاء حساب',
                        isLoading: isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<RegisterCubit>().register(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                      ),
                      const Gap(12),
                      ProviderRegisterButton(
                        text: 'التسجيل كمقدم خدمة',
                        onPressed: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   '/provider-register',
                          // );
                        },
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
