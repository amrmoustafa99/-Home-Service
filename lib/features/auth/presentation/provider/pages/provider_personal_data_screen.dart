import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_service/core/constants/app_provider.dart';
import 'package:home_service/features/auth/data/provider/join_data.dart';
import 'package:home_service/features/auth/presentation/provider/pages/provider_experience_screen.dart';
import 'package:home_service/features/auth/presentation/provider/widgets/primary_button.dart';
import 'package:image_picker/image_picker.dart';

class PersonalDataScreen extends StatefulWidget {
  final JoinData data;
  final bool editMode;
  const PersonalDataScreen({
    super.key,
    required this.data,
    this.editMode = false,
  });

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late final _name = TextEditingController(text: widget.data.name);
  late final _phone = TextEditingController(text: widget.data.phone);
  late final _email = TextEditingController(text: widget.data.email);
  late XFile? _avatar = widget.data.avatar;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => _avatar = f);
  }

  void _next() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.data
      ..avatar = _avatar
      ..name = _name.text.trim()
      ..phone = _phone.text.trim()
      ..email = _email.text.trim();

    if (widget.editMode) {
      Navigator.pop(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ExperienceScreen(data: widget.data)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      step: 0,
      buttonText: widget.editMode ? 'حفظ' : 'التالي',
      onNext: _next,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const PageTitle(
              'بياناتك الشخصية',
              'يرجى إدخال بياناتك بدقة، سنستخدمها للتواصل معك \nومراجعة طلب انضمامك.',
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: kBorder),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7F8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kHint),
                        image: _avatar == null
                            ? null
                            : DecorationImage(
                                image: FileImage(File(_avatar!.path)),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: _avatar == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_camera_outlined,
                                  color: kPrimary,
                                ),
                                Text(
                                  'إضافة صورة',
                                  style: TextStyle(fontSize: 9, color: kHint),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الصورة الشخصية',
                          // textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'تساعدنا الصورة في التعرف عليك والتأكد من بياناتك.',
                          style: TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const FieldLabel('الاسم بالكامل', required: true, label: ''),
            TextFormField(
              controller: _name,
              decoration: deco('أحمد علي السيد', icon: Icons.person_outline),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
            ),
            const FieldLabel('رقم الواتساب', required: true, label: ''),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              decoration: deco('01xxxxxxxxx', icon: Icons.phone_outlined),
              validator: (v) =>
                  (v == null || v.trim().length < 11) ? 'رقم غير صحيح' : null,
            ),
            const FieldLabel('البريد الإلكتروني', required: true, label: ''),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
              decoration: deco('example@gmail.com', icon: Icons.mail_outline),
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'بريد غير صحيح' : null,
            ),
          ],
        ),
      ),
    );
  }
}
