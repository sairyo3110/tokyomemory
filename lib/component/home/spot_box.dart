import 'package:mapapp/importer.dart';

class SpotSearchBox extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  SpotSearchBox({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            width: 325,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
