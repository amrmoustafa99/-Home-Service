import 'package:flutter/material.dart';
import 'package:home_service/core/constants/app_provider.dart';
import 'package:home_service/features/auth/data/provider/join_data.dart';
import 'package:home_service/features/auth/presentation/provider/pages/provider_review_screen.dart';
import 'package:home_service/features/auth/presentation/provider/widgets/primary_button.dart';

class WorkScopeScreen extends StatefulWidget {
  final JoinData data;
  final bool editMode;
  const WorkScopeScreen({super.key, required this.data, this.editMode = false});

  @override
  State<WorkScopeScreen> createState() => _WorkScopeScreenState();
}

class _WorkScopeScreenState extends State<WorkScopeScreen> {
  late String? _city = widget.data.city;
  late final Set<String> _days = {...widget.data.days};
  late TimeOfDay _from = widget.data.from;
  late TimeOfDay _to = widget.data.to;

  // صيغة الوقت زي فيجما: 10:00 ص / 08:00 م
  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final hh = h.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'ص' : 'م';
    return '$hh:$mm $period';
  }

  Future<void> _pickTime(bool from) async {
    final t = await showTimePicker(
      context: context,
      initialTime: from ? _from : _to,
    );
    if (t != null) setState(() => from ? _from = t : _to = t);
  }

  void _next() {
    widget.data
      ..city = _city
      ..days = _days
      ..from = _from
      ..to = _to;

    if (widget.editMode) {
      Navigator.pop(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ReviewScreen(data: widget.data)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      step: 2,
      buttonText: widget.editMode ? 'حفظ' : 'التالي',
      onNext: _next,
      // RTL للمحتوى بس (الهيدر والخطوات سايبهم زي ما هم)
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageTitle(
              'نطاق العمل و الوقت المتاح',
              'حدد المناطق التي يمكنك العمل بها، و الوقت المتاح، حتى نتمكن من توصيلك للعملاء الأقرب إليك في الوقت المناسب.',
            ),
            const FieldLabel('المدينة / المنطقة', label: ''),

            // أيقونة المبنى يمين + السهم شمال (تلقائي في RTL)
            DropdownButtonFormField<String>(
              initialValue: _city,
              isExpanded: true,
              decoration: deco('اختر المدينة').copyWith(
                prefixIcon: const Icon(
                  Icons.apartment,
                  size: 20,
                  color: kPrimary,
                ),
              ),
              items: kCities
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 13)),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _city = v),
            ),

            const FieldLabel('أيام العمل', label: ''),

            // الـ Wrap في RTL بيبدأ من اليمين (السبت أول واحد يمين)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kDays.map((d) {
                final sel = _days.contains(d);
                return GestureDetector(
                  onTap: () =>
                      setState(() => sel ? _days.remove(d) : _days.add(d)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? kPrimaryLight : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: sel ? kPrimary : kBorder),
                    ),
                    child: Text(
                      d,
                      style: TextStyle(
                        fontSize: 11,
                        color: sel ? kPrimary : Colors.black87,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const FieldLabel('ساعات العمل اليومية', label: ''),

            // "من" يمين و "إلى" شمال
            Row(
              children: [
                _timeBox('من', _from, true),
                const SizedBox(width: 12),
                _timeBox('إلى', _to, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeBox(String label, TimeOfDay t, bool from) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11)),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => _pickTime(from),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: kBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // الوقت يمين والسهم شمال
                  Text(_fmt(t), style: const TextStyle(fontSize: 12)),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: kHint,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}