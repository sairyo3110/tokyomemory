import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/coupon/widget/detail/botann.dart';
import 'package:mapapp/view/coupon/widget/detail/coupon_uses.dart';
import 'package:mapapp/view/coupon/widget/detail/dash.dart';
import 'package:mapapp/view/coupon/widget/detail/detial.dart';
import 'package:mapapp/view/coupon/widget/detail/explanation.dart';
import 'package:mapapp/view/coupon/widget/detail/spot_detial.dart';
import 'package:mapapp/view/coupon/widget/detail/title.dart';
import 'package:mapapp/view/search/spot/spot_detail.dart';

class CouponDetail extends StatelessWidget {
  final Spot coupon;

  CouponDetail({required this.coupon});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    return Scaffold(
      appBar: CustomAppBar(
        title: coupon.name ?? '',
        showBackButton: true,
      ),
      body: BaseScreen(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "https://mymapapp.s3.ap-northeast-1.amazonaws.com/coupon/${coupon.name}/1.png",
                ),
                SizedBox(height: 10),
                CouponDetailSpotTitle(
                  title: coupon.name ?? '',
                ),
                CouponDetailExplanation(
                  explanation: coupon.cDescription ?? '',
                ),
                SizedBox(height: 20),
                CouponDetailUsesWidget(
                  uses: 1,
                ),
                SizedBox(height: 40),
                CouponDetailText(
                  detial: coupon.description ?? '',
                ),
                SizedBox(height: 20),
                CouponDetailDash(),
                SizedBox(height: 10),
                CouponDetailText(
                  detial: '▼注意事項',
                ),
                SizedBox(height: 10),
                CouponDetailText(
                  detial: '※クーポンを使用するには、お会計時にこの画面をスタッフに提示してください。',
                ),
                SizedBox(height: 10),
                CouponDetailText(
                  detial: '※クーポンの有効期日日時は、UTC+9:00を基準に表示しています。',
                ),
                SizedBox(height: 10),
                CouponDetailText(
                  detial:
                      '※使用済みのクーポンはご利用になれません。また、お客様の操作で誤って「使用済み」にしてしまった場合も利用できなくなります。',
                ),
                SizedBox(height: 40),
                CouponDetailSpotWidget(
                  address:
                      '${coupon.prefecture ?? 'No city'}${coupon.city ?? 'No city'} ${coupon.chome ?? 'No location'}-${coupon.banchi ?? 'No location'}-${coupon.go ?? 'No location'}-${coupon.buildingName ?? ''}',
                  phone: '00-0000-0000',
                  minDayTime: coupon.dayStart ?? '',
                  maxDayTime: coupon.dayEnd ?? '',
                  minNightTime: coupon.nightStart ?? '',
                  maxNightTime: coupon.nightEnd ?? '',
                  timeDetails: [],
                  minDayBudget: coupon.dayMin ?? '',
                  maxDayBudget: coupon.dayMax ?? '',
                  minNightBudget: coupon.nightMin ?? '',
                  maxNightBudget: coupon.nightMax ?? '',
                  websiteUrl: coupon.reservationSite ?? '',
                  placeName: coupon.name ?? '',
                  latitude: coupon.latitude ?? 0,
                  longitude: coupon.longitude ?? 0,
                  onSeeDetails: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpotDetail(spot: coupon)),
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.all(10),
          color: AppColors.primary,
          child: CouponDetailBotannWidget(
            userId: userId ?? '',
          )),
    );
  }
}
