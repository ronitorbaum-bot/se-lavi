import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/category_button.dart';

class CategoryPickerSheet extends StatelessWidget {
  const CategoryPickerSheet({super.key});

  static const _categories = [
    {'name': 'כלבו', 'icon': Icons.shopping_cart_outlined},
    {'name': 'חשמל', 'icon': Icons.bolt_outlined},
    {'name': 'כביסה', 'icon': Icons.local_laundry_service_outlined},
    {'name': 'נסיעות', 'icon': Icons.directions_bus_outlined},
    {'name': 'קופת משק', 'icon': Icons.home_outlined},
    {'name': 'בריאות', 'icon': Icons.medical_services_outlined},
    {'name': 'פינוקים ומשפחה', 'icon': Icons.favorite_outline},
    {'name': 'אחר', 'icon': Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'איזה סוג הוצאה?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.95,
            children: _categories
                .map((cat) => CategoryButton(
                      label: cat['name'] as String,
                      icon: cat['icon'] as IconData,
                      onPressed: () =>
                          Navigator.pop(context, cat['name'] as String),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
