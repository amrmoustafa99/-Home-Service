import 'package:flutter/material.dart';

class SelectCityBottomSheet extends StatefulWidget {
  final String currentCity;

  const SelectCityBottomSheet({super.key, required this.currentCity});

  @override
  State<SelectCityBottomSheet> createState() => _SelectCityBottomSheetState();
}

class _SelectCityBottomSheetState extends State<SelectCityBottomSheet> {
  static const Color primaryGreen = Color(0xFF1D5C4B);

  final List<String> allCities = const [
    'سوهاج - سوهاج',
    'سوهاج - اخميم',
    'سوهاج - جهينة',
    'سوهاج - المراغة',
    'سوهاج - دار السلام',
    'سوهاج - البلينا',
    'سوهاج - طهطا',
    'سوهاج - طما',
  ];

  late String selectedCity;
  late List<String> filteredCities;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCity = widget.currentCity;
    filteredCities = allCities;
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();
    setState(() {
      filteredCities = query.isEmpty
          ? allCities
          : allCities
              .where((city) => city.contains(query))
              .toList(growable: false);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // مقبض السحب
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            'اختر المدينة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          // حقل البحث
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black45),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      hintText: 'ابحث عن مدينتك',
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 13),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // قائمة المدن
          Expanded(
            child: RadioGroup<String>(
              groupValue: selectedCity,
              onChanged: (value) {
                setState(() => selectedCity = value!);
              },
              child: ListView.separated(
                itemCount: filteredCities.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
                itemBuilder: (context, index) {
                  final city = filteredCities[index];
                  final bool isSelected = city == selectedCity;

                  return RadioListTile<String>(
                    value: city,
                    activeColor: primaryGreen,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      city,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? primaryGreen : Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // زر التأكيد
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedCity),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'تأكيد الإختيار',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}