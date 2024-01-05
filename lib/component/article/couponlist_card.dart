import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';

class CouponList extends StatelessWidget {
  final List<PlaceDetail> coupons;
  final String title;
  final String imagePath;
  final String description;

  CouponList({
    required this.coupons,
    required this.title,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFFF6E6DC),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  imagePath,
                  width: 350,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _buildCouponList(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCouponList(BuildContext context) {
    if (coupons.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: coupons.length,
        itemBuilder: (_, index) {
          final coupon = coupons[index];
          return _buildCouponCard(context, coupon);
        },
      ),
    );
  }

  Widget _buildCouponCard(BuildContext context, PlaceDetail coupon) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CouponDetailScreen(coupon: coupon),
            ),
          );
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                "https://mymapapp.s3.ap-northeast-1.amazonaws.com/coupon/${coupon.name}/1.png",
                width: 180,
                height: 100,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  coupon.name ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '${coupon.nearestStation}より ${coupon.walkingMinutes}分',
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
