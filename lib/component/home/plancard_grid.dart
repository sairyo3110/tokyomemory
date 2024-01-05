import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';

class PlanCardGrid extends StatelessWidget {
  final List<PlanCategory> planCategories;
  final Function(int) onCategoryTap;

  PlanCardGrid({required this.planCategories, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: planCategories.length,
        itemBuilder: (context, index) {
          String imageUrl =
              'https://mymapapp.s3.ap-northeast-1.amazonaws.com/PlanChategori/${planCategories[index].name}/1.jpg';
          return GestureDetector(
            onTap: () => onCategoryTap(planCategories[index].id),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      '${planCategories[index].name}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
