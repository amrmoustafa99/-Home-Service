import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:home_service/core/theme/app_colors.dart';
import 'package:home_service/features/auth/logic/login/login_cubit.dart';
import 'package:home_service/features/auth/logic/login/login_state.dart';
import 'package:home_service/features/auth/presentation/widgets/auth_button.dart';
import 'package:home_service/features/auth/presentation/widgets/auth_header.dart';
import 'package:home_service/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:home_service/features/auth/presentation/widgets/field_label.dart';
import 'package:home_service/features/auth/presentation/widgets/provider_register_button.dart';
import '../../data/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // final AuthRepository _authRepository = AuthRepository();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  // bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<LoginCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(AuthRepository()),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تم تسجيل الدخول بنجاح',
                  style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
                ),
              ),
            );

            // بعدين لما نحدد صفحة الـ Home:
            Navigator.pushReplacementNamed(context, '/_FoundationHome');
          }

          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(fontFamily: 'IBMPlexSansArabic'),
                ),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const AuthHeader(),

                    Text(
                      'مرحباً بعودتك',
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
                        'أهلاً بك في أي خدمة. سجل دخولك علشان تتابع خدماتك\nوطلباتك.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.text,
                          fontFamily: 'IBMPlexSansArabic',
                        ),
                      ),
                    ),

                    const Gap(30),

                    // ---------------- EMAIL ----------------
                    FieldLabel(label: 'البريد الإلكتروني', required: true),
                    const Gap(8),
                    AuthTextField(
                      // label: 'البريد الإلكتروني',
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
                      hint: '***********',
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

                        if (value.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }

                        return null;
                      },
                    ),

                    const Gap(10),

                    // ---------------- REMEMBER ME / FORGOT ----------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Navigator.pushNamed(
                              //   context,
                              //   '/forgot-password',
                              // );
                            },
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color(0xff181818),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'IBMPlexSansArabic',
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                'تذكرني',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'IBMPlexSansArabic',
                                  color: const Color(0xff707070),
                                ),
                              ),

                              Checkbox(
                                value: _rememberMe,
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return AppColors.primary;
                                      }

                                      return Colors.white;
                                    }),
                                checkColor: Colors.white,
                                side: const BorderSide(
                                  color: Color(0xffE0E0E0),
                                  width: 1.5,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Gap(20),

                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        final isLoading = state is LoginLoading;

                        return AuthButton(
                          text: 'سجل دخولك',
                          isLoading: isLoading,
                          onPressed: () => _login(context),
                        );
                      },
                    ),

                    const Gap(12),

                    // ---------------- PROVIDER REGISTER ----------------
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

                    // ---------------- REGISTER ----------------
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
                            const TextSpan(text: 'ليس لديك حساب؟ '),
                            TextSpan(
                              text: 'إنشاء حساب',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontFamily: 'IBMPlexSansArabic',
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/register');
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
        ),
      ),
    );
  }
}
