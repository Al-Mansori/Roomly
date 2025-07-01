import 'package:flutter/material.dart';

import '../widget/category_item.dart';
import '../widget/section_title.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('Find the perfect workspace for you'),
        _CategoryItemsRow(),
      ],
    );
  }
}

class _CategoryItemsRow extends StatelessWidget {
  const _CategoryItemsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CategoryItem('Desk', 'assets/images/image.png', 'desk'),
        CategoryItem('Meeting Room', 'assets/images/image-1.png', 'meeting'),
        CategoryItem('Gaming Room', 'assets/images/image-2.png', 'gaming'),
      ],
    );
  }
}