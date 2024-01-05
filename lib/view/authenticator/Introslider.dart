import 'package:flutter/material.dart';
import 'package:mapapp/view/navigation/main_bottom_navigation.dart';

class IntroSliderScreen extends StatefulWidget {
  IntroSliderScreen({Key? key}) : super(key: key); // 引数を削除

  @override
  _IntroSliderScreenState createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 4; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 6.0,
      width: isActive ? 16.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.black45 : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF444440), // ここで背景色を設定
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            height: MediaQuery.of(context).size.height * 0.80,
            width: MediaQuery.of(context).size.width * 0.90,
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: <Widget>[
                _buildSlide("images/int1.png"),
                _buildSlide("images/int2.png"),
                _buildSlide("images/int3.png"),
                _buildSlide("images/int4.png"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(),
          ),
          SizedBox(height: 20),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildSlide(String imagePath) {
    return Column(
      children: <Widget>[
        Image.asset(imagePath),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(height: 10),
        TextButton(
          child: Text(
            '使い始める',
            style: TextStyle(fontSize: 20, color: Color(0xFFF6E6DC)),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainBottomNavigation()),
            );
          },
        ),
      ],
    );
  }
}
