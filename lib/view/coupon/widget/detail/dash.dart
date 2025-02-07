import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

class CouponDetailDash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Dash(
          direction: Axis.horizontal,
          length: 150,
          dashLength: 3,
          dashColor: Colors.black,
        ),
      ],
    );
  }
}
