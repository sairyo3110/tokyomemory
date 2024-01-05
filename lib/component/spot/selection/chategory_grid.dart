import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart'; // 必要に応じてインポートを調整

class CategorySelectionGrid extends StatelessWidget {
  final List<PlaceCategorySub> categories;
  final List<int> selectedCategoryIds;
  final ValueChanged<int> onCategorySelected;

  const CategorySelectionGrid({
    Key? key,
    required this.categories,
    required this.selectedCategoryIds,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('カテゴリー', style: TextStyle(fontWeight: FontWeight.bold)),
        Divider(),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected =
                selectedCategoryIds.contains(category.categoryId);
            return GestureDetector(
              onTap: () => onCategorySelected(category.categoryId),
              child: Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFF6E6DC) : Colors.transparent,
                  border: Border.all(
                    color: const Color.fromRGBO(224, 224, 224, 1),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Color(0xFFF6E6DC),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
