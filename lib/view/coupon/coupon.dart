import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/coupon/coupon_main.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/coupon/coupon_list.dart';
import 'package:mapapp/view/coupon/widget/tab_widget.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatefulWidget {
  @override
  _CouponScreenState createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CouponViewModel>().fetchCoupons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Coupons',
      ),
      body: BaseScreen(
        body: Column(
          children: [
            //TODO クーポンフィルタリングができるようになったら実装
            //CouponTabWidget(),
            Expanded(
              child: Consumer<CouponViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.coupons.isEmpty) {
                    return Center(child: Text('No available coupons.'));
                  }
                  return CouponList(coupons: viewModel.coupons);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
