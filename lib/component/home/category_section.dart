import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';

class CategorySearchSection extends StatelessWidget {
  final List<PlaceCategorySub> placeCategories;
  final Function(int) onCategoryTap;

  CategorySearchSection({
    required this.placeCategories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180.0,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 50.0),
            scrollDirection: Axis.horizontal,
            itemCount: placeCategories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(context, placeCategories[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, PlaceCategorySub category) {
    String imageUrl =
        'https://mymapapp.s3.ap-northeast-1.amazonaws.com/PlaceChategori/${category.name}/1.jpg';

    return InkWell(
      onTap: () => onCategoryTap(category.categoryId),
      child: Padding(
        padding: EdgeInsets.only(right: 15.0),
        child: Column(
          children: [
            Container(
              width: 130.0,
              height: 130.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(category.name),
          ],
        ),
      ),
    );
  }
}
