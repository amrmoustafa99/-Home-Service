import 'package:flutter/material.dart';
import 'package:home_service/core/widgets/custom_bottom_nav_bar.dart';
import 'package:home_service/features/auth/presentation/ai_technician/ai_technician_screen.dart';
import 'package:home_service/features/auth/presentation/bookings/bookings_screen.dart';
import 'package:home_service/features/auth/presentation/home/home_content.dart';
import 'package:home_service/features/auth/presentation/profile/profile_screen.dart';
import 'package:home_service/features/auth/presentation/services/service_categories.dart';
import 'package:home_service/features/auth/presentation/services/services_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
  HomeContent(),
  ServicesScreen(),
  AiTechnicianScreen(),
  BookingsScreen(),
  ProfileScreen(),
  ServiceCategoryScreen(categoryTitle: 'النظافة والتعقيم', categoryId: 'cleaning'),
  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

    );
  }
}