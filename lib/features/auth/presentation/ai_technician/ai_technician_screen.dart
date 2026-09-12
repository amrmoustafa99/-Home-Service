import 'package:flutter/material.dart';

class AiTechnicianScreen extends StatefulWidget {
  const AiTechnicianScreen({super.key});

  @override
  State<AiTechnicianScreen> createState() => _AiTechnicianScreenState();
}

class _AiTechnicianScreenState extends State<AiTechnicianScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفني الذكي'),
      ),
      body: const Center(
        child: Text('Content for AI Technician Screen'),
      ),
    );
  }
}