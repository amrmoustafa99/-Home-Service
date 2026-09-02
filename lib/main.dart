import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/logic/cubit/profile_cubit.dart';
import 'features/profile/presentation/screens/edit_profile_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HomeServiceApp());
}

class HomeServiceApp extends StatelessWidget {
  const HomeServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // ProfileCubit is provided app-wide so the read-only and edit screens
      // share the same in-memory profile instance.
      providers: [
        BlocProvider(create: (_) => ProfileCubit()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
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
            // TODO(team-b): temporary dev entry point — remove once wired
            // into the real post-login navigation.
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.profile);
              },
              child: const Text('الملف الشخصي (تجريبي)'),
            ),
          ],
        ),
      ),
    );
  }
}