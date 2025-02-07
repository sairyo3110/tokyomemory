import 'package:flutter/material.dart';
import 'package:mapapp/view/common/login_dialog.dart';
import 'package:mapapp/view/coupon/widget/detail/bottann/after.dart';
import 'package:mapapp/view/coupon/widget/detail/bottann/before.dart';
import 'package:mapapp/view/coupon/widget/detail/bottann/chekout.dart';

class CouponDetailBotannWidget extends StatefulWidget {
  final String userId; // userIdを追加

  CouponDetailBotannWidget({required this.userId}); // コンストラクタにuserIdを追加

  @override
  _CouponDetailBotannWidgetState createState() =>
      _CouponDetailBotannWidgetState();
}

class _CouponDetailBotannWidgetState extends State<CouponDetailBotannWidget> {
  bool _isUsed = false;
  bool _isCheckedOut = false;

  void _toggleButtonState() {
    if (widget.userId == '') {
      showDialog(
        context: context,
        builder: (context) => LoginAlertDialog(),
      );
    } else {
      setState(() {
        _isUsed = !_isUsed;
      });
    }
  }

  void _markAsCheckedOut() {
    setState(() {
      _isCheckedOut = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckedOut) {
      return CouponDetailCheckoutBotann();
    } else if (_isUsed) {
      return CouponDetailAfterBotann(onCheckedOut: _markAsCheckedOut);
    } else {
      return GestureDetector(
        onTap: _toggleButtonState,
        child: CouponDetailBeforeBotann(),
      );
    }
  }
}
