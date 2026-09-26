import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/supabase_constants.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/account_settings/about_app/presentation/screens/about_app_screen.dart';
import 'features/account_settings/addresses/presentation/screens/addresses_screen.dart';
import 'features/account_settings/invite_friend/presentation/screens/invite_friend_screen.dart';
import 'features/account_settings/security_privacy/presentation/screens/security_privacy_screen.dart';
import 'features/app/temporary_bottom_nav_shell.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/logic/auth/auth_cubit.dart';
import 'features/auth/presentation/login/login_screen.dart';
import 'features/auth/presentation/onboarding/pages/onboading_one_screen.dart';
import 'features/auth/presentation/onboarding/pages/onboarding_four_screen.dart';
import 'features/auth/presentation/onboarding/pages/onboarding_three_screen.dart';
import 'features/auth/presentation/onboarding/pages/onboarding_two_screen.dart';
import 'features/auth/presentation/register/register_screen.dart'
    as register_screen;
import 'features/offers/presentation/screens/offers_screen.dart';
import 'features/profile/data/repositories/profile_repository.dart';
import 'features/profile/logic/cubit/profile_cubit.dart';
import 'features/profile/presentation/screens/edit_profile_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit(AuthRepository())),
          BlocProvider(
            create: (_) => ProfileCubit(repository: ProfileRepository()),
          ),
        ],
        child: const HomeServiceApp(),
      ),
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
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: AppRoutes.onboardingOne,

      routes: {
        AppRoutes.home: (_) => const _FoundationHome(),
        AppRoutes.register: (_) => register_screen.RegisterScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.onboardingOne: (_) => const OnboadingOneScreen(),
        AppRoutes.onboardingTwo: (_) => const OnboadingTwoScreen(),
        AppRoutes.onboardingThree: (_) => const OnboadingThreeScreen(),
        AppRoutes.onboardingFour: (_) => const OnboadingFourScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.profileEdit: (_) => const EditProfileScreen(),
        AppRoutes.securityPrivacy: (_) => const SecurityPrivacyScreen(),
        AppRoutes.aboutApp: (_) => const AboutAppScreen(),
        AppRoutes.inviteFriend: (_) => const InviteFriendScreen(),
        AppRoutes.addresses: (_) => const AddressesScreen(),
        AppRoutes.offers: (_) => const OffersScreen(),
      },
    );
  }
}

class _FoundationHome extends StatelessWidget {
  const _FoundationHome();

  @override
  Widget build(BuildContext context) {
    return const TemporaryBottomNavShell(
      pages: [
        _PlaceholderTab(label: 'الرئيسية'),
        _PlaceholderTab(label: 'الخدمات'),
        _PlaceholderTab(label: 'الفلق الذكي'),
        _PlaceholderTab(label: 'حجوزاتي'),
        ProfileScreen(),
      ],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(label)),
    );
  }
}