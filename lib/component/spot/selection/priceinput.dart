import 'package:flutter/material.dart';

class PriceInput extends StatelessWidget {
  final int minPrice;
  final int maxPrice;
  final Function(RangeValues) onPriceChanged;

  const PriceInput({
    Key? key,
    required this.minPrice,
    required this.maxPrice,
    required this.onPriceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('予算', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        RangeSlider(
          values: RangeValues(minPrice.toDouble(), maxPrice.toDouble()),
          min: 0,
          max: 20000,
          divisions: 200,
          onChanged: onPriceChanged,
          labels: RangeLabels('$minPrice円', '$maxPrice円'),
          activeColor: Color(0xFFF6E6DC),
          inactiveColor: Colors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$minPrice円'),
            Text('$maxPrice円'),
          ],
        ),
      ],
    );
  }
}
