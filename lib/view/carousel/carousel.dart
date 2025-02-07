import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/plan/plan_main.dart';
import 'package:mapapp/businesslogic/spot/spot_main.dart';
import 'package:mapapp/businesslogic/updart.dart';
import 'package:mapapp/view/carousel/carousel_plan.dart';
import 'package:mapapp/view/carousel/carousel_spot.dart';
import 'package:mapapp/view/carousel/widget/tabbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/common/update_dialog.dart';
import 'package:mapapp/view/common/use/welcome_dialog.dart';
import 'package:provider/provider.dart';

class CarouselScreen extends StatefulWidget {
  @override
  _CarouselScreenState createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AppVersionController _versionController = AppVersionController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<SpotViewModel>(context, listen: false)
          .fetchSpots(context);

      await Provider.of<PlanViewModel>(context, listen: false).loadPlans();
    });
    WelcomeDialog.showWelcomeMessageIfNeeded(context);
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    bool updateAvailable = await _versionController.isUpdateAvailable();
    if (updateAvailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => UpdatePromptDialog(
            updateRequestType: UpdateRequestType.mandatory, // またはcancelable
            androidUpdateUrl:
                'https://play.google.com/store/apps/details?id=your.android.package',
            iosUpdateUrl: 'https://apps.apple.com/app/your-ios-app-id',
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Stack(
        children: [
          Positioned.fill(
            child: TabBarView(
              controller: _tabController,
              children: [
                Consumer<SpotViewModel>(
                  builder: (context, spotViewModel, child) {
                    return spotViewModel.isLoading
                        ? Center(
                            child: Image.asset('images/loading_image.gif',
                                width: 250))
                        : CarouselSpot(spots: spotViewModel.spots);
                  },
                ),
                Consumer<PlanViewModel>(
                  builder: (context, planViewModel, child) {
                    return planViewModel.isLoading
                        ? Center(
                            child: Image.asset('images/loading_image.gif',
                                width: 250))
                        : CarouselPlan(plans: planViewModel.plans);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: CarouselTabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Spot'),
                Tab(text: 'Plan'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
