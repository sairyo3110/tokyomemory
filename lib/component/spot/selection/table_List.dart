import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';

class SelectableList extends StatelessWidget {
  final String title;
  final List<String> options;
  final ValueChanged<String> onOptionSelected;
  final List<String> selectedOptions;

  const SelectableList({
    Key? key,
    required this.title,
    required this.options,
    required this.onOptionSelected,
    required this.selectedOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3.0,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            final isSelected = selectedOptions.contains(option);
            return InkWell(
              onTap: () => onOptionSelected(option),
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
                  option,
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
