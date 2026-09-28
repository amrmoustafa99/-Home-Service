import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_service/core/constants/app_provider.dart';
import 'package:home_service/features/auth/data/provider/join_data.dart';
import 'package:home_service/features/auth/data/provider/provider_repository.dart';
import 'package:home_service/features/auth/logic/provider/provider_cubit.dart';
import 'package:home_service/features/auth/logic/provider/provider_state.dart';
import 'package:home_service/features/auth/presentation/provider/pages/provider_experience_screen.dart';
import 'package:home_service/features/auth/presentation/provider/pages/provider_personal_data_screen.dart';
import 'package:home_service/features/auth/presentation/provider/pages/provider_success_screen.dart';
import 'package:home_service/features/auth/presentation/provider/pages/provider_work_scope_screen.dart';
import 'package:home_service/features/auth/presentation/provider/widgets/primary_button.dart';

class ReviewScreen extends StatefulWidget {
  final JoinData data;

  const ReviewScreen({
    super.key,
    required this.data,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  JoinData get d => widget.data;

  Future<void> _edit(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cats = d.categories.map((i) => kCategories[i].$1).join('، ');

    return BlocProvider(
      create: (_) => ProviderCubit(
        ProviderRepository(),
      ),
      child: BlocConsumer<ProviderCubit, ProviderState>(
        listener: (context, state) {
          if (state is ProviderSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const SuccessScreen(),
              ),
            );
          }

          if (state is ProviderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProviderLoading;

          return StepScaffold(
            step: 3,
            buttonText: isLoading ? 'جاري الإرسال...' : 'إرسال الطلب',
            onNext: isLoading
                ? () {}
                : () {
                    context.read<ProviderCubit>().submitProvider(d);
                  },
            // RTL للمحتوى بس (الهيدر والخطوات سايبهم زي ما هم)
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageTitle(
                    'مراجعة بياناتك',
                    'يرجى مراجعة البيانات التي أدخلتها والتأكد من صحتها قبل إرسال طلب الانضمام.',
                  ),

                  const SizedBox(height: 8),

                  // البيانات الشخصية
                  _ReviewTile(
                    icon: Icons.person_outline,
                    title: 'البيانات الشخصية',
                    initiallyExpanded: true,
                    onEdit: () {
                      _edit(
                        PersonalDataScreen(
                          data: d,
                          editMode: true,
                        ),
                      );
                    },
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // النص على اليمين
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _kv('الإسم', d.name),
                                _kv('رقم الهاتف', d.phone),
                                _kv('الإيميل', d.email),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // الصورة على الشمال (مربعة بحواف مدورة)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 75,
                              height: 72,
                              color: kPrimaryLight,
                              child: d.avatar == null
                                  ? const Icon(
                                      Icons.person,
                                      color: kPrimary,
                                      size: 32,
                                    )
                                  : Image.file(
                                      File(d.avatar!.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // التخصص والخدمات
                  _ReviewTile(
                    icon: Icons.work_outline,
                    title: 'تخصصك و خدماتك',
                    onEdit: () {
                      _edit(
                        ExperienceScreen(
                          data: d,
                          editMode: true,
                        ),
                      );
                    },
                    children: [
                      _kv(
                        'المجالات',
                        cats.isEmpty ? '-' : cats,
                      ),
                      if (d.subServices.isNotEmpty)
                        _kv(
                          'الخدمات',
                          d.subServices.join('، '),
                        ),
                      _kv(
                        'الخبرة',
                        d.experience ?? '-',
                      ),
                      if (d.notes.isNotEmpty)
                        _kv(
                          'نبذة',
                          d.notes,
                        ),
                    ],
                  ),

                  // نطاق العمل والوقت
                  _ReviewTile(
                    icon: Icons.location_on_outlined,
                    title: 'نطاق العمل و الوقت المتاح',
                    onEdit: () {
                      _edit(
                        WorkScopeScreen(
                          data: d,
                          editMode: true,
                        ),
                      );
                    },
                    children: [
                      _kv(
                        'المدينة',
                        d.city ?? '-',
                      ),
                      _kv(
                        'الأيام',
                        d.days.isEmpty ? '-' : d.days.join('، '),
                      ),
                      _kv(
                        'الساعات',
                        '${d.from.format(context)} - ${d.to.format(context)}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$k: ',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: v.isEmpty ? '-' : v,
            ),
          ],
        ),
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onEdit;
  final List<Widget> children;
  final bool initiallyExpanded;

  const _ReviewTile({
    required this.icon,
    required this.title,
    required this.onEdit,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            12,
            0,
            12,
            12,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: kPrimary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: kPrimary,
                  ),
                ),
              ),
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'تعديل',
                        style: TextStyle(
                          fontSize: 9,
                          color: kPrimary,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.edit,
                        size: 10,
                        color: kPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          children: children,
        ),
      ),
    );
  }
}