import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_service/core/constants/app_provider.dart';
import 'package:home_service/features/auth/data/provider/join_data.dart';
import 'package:home_service/features/auth/presentation/provider/pages/provider_work_scope_screen.dart';
import 'package:home_service/features/auth/presentation/provider/widgets/primary_button.dart';
import 'package:image_picker/image_picker.dart';

class ExperienceScreen extends StatefulWidget {
  final JoinData data;
  final bool editMode;
  const ExperienceScreen({
    super.key,
    required this.data,
    this.editMode = false,
  });

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final _picker = ImagePicker();
  late final Set<int> _cats = {...widget.data.categories};
  late final Set<String> _subs = {...widget.data.subServices};
  late String? _experience = widget.data.experience;
  late final List<XFile> _works = [...widget.data.works];
  late final _notes = TextEditingController(text: widget.data.notes);

  static const kCategories = [
  ('نقل و تركيب', 'assets/images/transportation.png'),
  ('النظافة والتعقيم','assets/images/clean.png' ),
  ('إصلاح و تشطيب', 'assets/images/Repair and Finishing.png'),
  ('صيانة منزلية', 'assets/images/maintenance.png'),
  (' أنظمة أمنية', 'assets/images/Security.png'),
  (' خدمات يومية', 'assets/images/Daily.png'),

      ('خدمات الحدائق', "assets/images/Gardening.png"),

        ('صيانة السيارات', 'assets/images/صيانة السيارات.png'),

];

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _addWork() async {
    if (_works.length >= 3) return;
    final f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => _works.add(f));
  }

  void _next() {
    widget.data
      ..categories = _cats
      ..subServices = _subs
      ..experience = _experience
      ..works = _works
      ..notes = _notes.text.trim();

    if (widget.editMode) {
      Navigator.pop(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WorkScopeScreen(data: widget.data)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      step: 1,
      buttonText: widget.editMode ? 'حفظ' : 'التالي',
      onNext: _next,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const PageTitle(
            'خبرتك و خدماتك',
            'اختر مجالات عملك والخدمات التي تقدمها، أضف معلومات عن خبرتك.',
          ),
          const FieldLabel('مجال العمل (اختر واحد أو أكثر)', label: ''),
          _categoriesGrid(),
          const SizedBox(height: 12),
          _subServicesBox(),
          const FieldLabel('سنوات الخبرة', label: ''),
          Directionality(
            textDirection: TextDirection.rtl,
            child: DropdownButtonFormField<String>(
              initialValue: _experience,
              decoration: deco('اختر سنوات الخبرة'),
              items: kExperienceLevels
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 13)),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _experience = v),
            ),
          ),

          const FieldLabel('أضف صورتين لأعمالك', label: ''),
          _worksRow(),
          const FieldLabel('نبذة عن خبراتك', label: ''),
          TextField(
            controller: _notes,
            maxLines: 4,
            maxLength: 250,
            decoration: deco('اكتب نبذة مختصرة عن خبراتك في عملك...'),
          ),
        ],
      ),
    );
  }

Widget _categoriesGrid() {
  return GridView.count(
    crossAxisCount: 4,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    children: List.generate(kCategories.length, (i) {
      final sel = _cats.contains(i);

      return GestureDetector(
        onTap: () => setState(
          () => sel ? _cats.remove(i) : _cats.add(i),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: sel ? kPrimaryLight : const Color(0xFFF6F7F8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: sel ? kPrimary : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                kCategories[i].$2,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 4),
              Text(
                kCategories[i].$1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      );
    }),
  );
}


  Widget _subServicesBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'ما الخدمات التي تستطيع تقديمها في مجال النظافة و التنظيم؟',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const Text(
            'اختر كل ما ينطبق عليك',
            style: TextStyle(fontSize: 10, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: kSubServices.map((s) {
              final sel = _subs.contains(s);
              return ChoiceChip(
                label: Text(s, style: const TextStyle(fontSize: 10)),
                selected: sel,
                selectedColor: kPrimaryLight,
                backgroundColor: Colors.white,
                onSelected: (_) =>
                    setState(() => sel ? _subs.remove(s) : _subs.add(s)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _worksRow() {
    return Row(
      children: List.generate(4, (i) {
        final isAdd = i == 3;
        final hasImg = !isAdd && i < _works.length;
        return Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: AspectRatio(
              aspectRatio: 1,
              child: GestureDetector(
                onTap: isAdd ? _addWork : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F2F3),
                    borderRadius: BorderRadius.circular(8),
                    border: isAdd ? Border.all(color: kPrimary) : null,
                    image: hasImg
                        ? DecorationImage(
                            image: FileImage(File(_works[i].path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hasImg
                      ? null
                      : Icon(
                          isAdd
                              ? Icons.photo_camera_outlined
                              : Icons.image_outlined,
                          color: isAdd ? kPrimary : kHint,
                        ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
