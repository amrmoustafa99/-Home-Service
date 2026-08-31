import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_service/features/auth/data/auth_repository.dart';
import 'package:home_service/features/auth/logic/auth/auth_cubit.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/onboarding/pages/onboading_one_screen.dart';
import 'features/auth/presentation/onboarding/pages/onboarding_two_screen.dart';
import 'features/auth/presentation/onboarding/pages/onboarding_three_screen.dart';
import 'features/auth/presentation/onboarding/pages/onboarding_four_screen.dart';
import 'package:home_service/features/auth/presentation/register_screen.dart'
    as register_screen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   runApp(
  BlocProvider(
    create: (_) => AuthCubit(AuthRepository()),
    child: const HomeServiceApp(),
  ),
);
  
}

class HomeServiceApp extends StatelessWidget {
  const HomeServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.light,
      initialRoute: AppRoutes.onboardingOne,
    
      routes: {
        AppRoutes.home: (_) => const _FoundationHome(),
        // AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.register: (_) => register_screen.RegisterScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.onboardingOne: (_) => const OnboadingOneScreen(),
        AppRoutes.onboardingTwo: (_) => const OnboadingTwoScreen(),
        AppRoutes.onboardingThree: (_) => const OnboadingThreeScreen(),
        AppRoutes.onboardingFour: (_) => const OnboadingFourScreen(),
      },
    );
  }
}

class _FoundationHome extends StatelessWidget {
  const _FoundationHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: const Center(child: Text(AppConstants.appName)),
    );
  }
}
