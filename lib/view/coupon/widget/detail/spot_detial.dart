import 'package:flutter/material.dart';
import 'package:mapapp/view/search/spot/widget/diteail/mapapp_open_botton.dart';
import 'package:mapapp/view/search/spot/widget/diteail/price.dart';
import 'package:mapapp/view/search/spot/widget/diteail/spot_inf.dart';
import 'package:mapapp/view/search/spot/widget/diteail/spot_web.dart';
import 'package:mapapp/view/search/spot/widget/diteail/time.dart';
import 'package:mapapp/view/search/spot/widget/diteail/time_widget.dart';
import 'package:mapapp/view/search/spot/widget/list/line.dart';

class CouponDetailSpotWidget extends StatelessWidget {
  final String address;
  final String phone;
  final List<Map<String, String>> timeDetails;
  final String minDayBudget;
  final String maxDayBudget;
  final String minNightBudget;
  final String maxNightBudget;
  final String websiteUrl;
  final VoidCallback onSeeDetails;
  final String minDayTime;
  final String maxDayTime;
  final String minNightTime;
  final String maxNightTime;
  final String placeName;
  final double latitude;
  final double longitude;

  CouponDetailSpotWidget({
    required this.address,
    required this.phone,
    required this.timeDetails,
    required this.minDayTime,
    required this.maxDayTime,
    required this.minNightTime,
    required this.maxNightTime,
    required this.minDayBudget,
    required this.maxDayBudget,
    required this.minNightBudget,
    required this.maxNightBudget,
    required this.websiteUrl,
    required this.onSeeDetails,
    required this.placeName,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[400],
      child: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 20),
                Text('スポット詳細情報',
                    style: TextStyle(
                      fontSize: 12,
                    ))
              ],
            ),
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SpotLine()),
            SizedBox(height: 20),
            SpotDetailWidget(
              icon: Icons.map,
              text: address,
            ),
            SizedBox(height: 10),
            OpenMapsButton(
              placeName: placeName,
              latitude: latitude, // 緯度
              longitude: longitude, // 経度
            ),
            //TODO 電話番号の情報が入るまで非表示
            //SizedBox(height: 20),
            //SpotDetailWidget(
            //  icon: Icons.phone,
            //  text: phone,
            //),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20), // 左側のスペース
                Icon(
                  Icons.watch_later,
                  size: 18,
                  color: Colors.black,
                ),
                SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
                Expanded(
                  child: SpotDetailTimeText(
                      text: "",
                      minDayTime: minDayTime,
                      maxDayTime: maxDayTime,
                      minNightTime: minNightTime,
                      maxNightTime: maxNightTime),
                ),
              ],
            ),
            //SpotDetailTimeListWidget(
            //  timeDetails: timeDetails,
            //),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                Icon(
                  Icons.currency_yen,
                  size: 18,
                  color: Colors.black,
                ),
                SpotDiteailPriceWidget(
                  minDayBudget: minDayBudget,
                  maxDayBudget: maxDayBudget,
                  minNightBudget: minNightBudget,
                  maxNightBudget: maxNightBudget,
                ),
              ],
            ),
            SizedBox(height: 20),
            SpotDetailWebWidget(
              icon: Icons.web,
              text: '予約公式サイト',
              url: websiteUrl,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: onSeeDetails,
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // 角に丸みをつける
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    'スポット詳細情報を見る',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
