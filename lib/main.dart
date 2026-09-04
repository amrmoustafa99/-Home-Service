import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/constants/supabase_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/data/repositories/profile_repository.dart';
import 'features/profile/logic/cubit/profile_cubit.dart';
import 'features/profile/presentation/screens/edit_profile_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    publishableKey: SupabaseConstants.supabaseAnonKey,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const HomeServiceApp(),
    ),
  );
}

class HomeServiceApp extends StatelessWidget {
  const HomeServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileCubit(repository: ProfileRepository()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (_) => const _FoundationHome(),
          AppRoutes.profile: (_) => const ProfileScreen(),
          AppRoutes.profileEdit: (_) => const EditProfileScreen(),
        },
      ),
    );
  }
}

class _FoundationHome extends StatelessWidget {
  const _FoundationHome();

  Future<void> signInWithTemporaryTestAccountUntilTeamAAuthIsMerged(
    BuildContext context,
  ) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'abdomanakram555@gmail.com',
          password: 'dcyjdcyj',
        );
      }
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.profile);
      }
    } catch (e) {
      debugPrint('Temporary test sign-in failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(AppConstants.appName),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  signInWithTemporaryTestAccountUntilTeamAAuthIsMerged(context),
              child: const Text('الملف الشخصي (تجريبي)'),
            ),
          ],
        ),
      ),
    );
  }
}