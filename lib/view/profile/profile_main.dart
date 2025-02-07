import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/user/user.dart';
import 'package:mapapp/test/businesslogic/user.dart';
import 'package:mapapp/test/businesslogic/couple.dart';
import 'package:mapapp/test/model/couple.dart';
import 'package:mapapp/test/model/user.dart';
import 'package:mapapp/test/repositories/user_repository.dart';
import 'package:mapapp/test/repositories/couple_repository.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/profile/profile_edit.dart';
import 'package:mapapp/view/profile/profile_plan.dart';
import 'package:mapapp/view/profile/profile_setting.dart';
import 'package:mapapp/view/profile/profile_spot.dart';
import 'package:mapapp/view/profile/widget/favorite_tabbar.dart';
import 'package:provider/provider.dart';

class ProfileMainScreen extends StatefulWidget {
  @override
  _ProfileMainScreenState createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends State<ProfileMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final UserInfoService userInfoService =
      UserInfoService(userInfoRepository: UserInfoRepository());

  final CoupleService coupleService =
      CoupleService(coupleRepository: CoupleRepository());

  UserInfoRDB? _userInfo;
  List<Couple> _couples = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userInfo = await userInfoService.fetchUserInfo(user.uid);
      setState(() {
        _userInfo = userInfo['user'] as UserInfoRDB?;
        _couples = userInfo['couples'] as List<Couple>;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onEditButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEdit()),
    );
  }

  void _onSettingsButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileSetting()),
    );
  }

  void _onAddCouple(Couple newCouple) {
    setState(() {
      _couples.add(newCouple);
    });
  }

  void _onDeleteCouple(int index) {
    setState(() {
      _couples.removeAt(index);
    });
  }

  void _onSaveAllCouples(List<Couple> updatedCouples) {
    setState(() {
      _couples = updatedCouples;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: CustomAppBar(
          title: _userInfo?.name ?? 'プロフィール',
          showEditButton: true,
          onEditButtonPressed: _onEditButtonPressed,
          showSettingsButton: true,
          onSettingsButtonPressed: _onSettingsButtonPressed,
        ),
        body: BaseScreen(
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      _userInfo?.name ?? '未設定',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _userInfo?.prefecture ?? '未設定',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    if (_couples.isNotEmpty) ...[
                      SizedBox(height: 20),
                      Text(
                        'カップル情報',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CoupleInfoForm(
                        coupleService: coupleService,
                        couples: _couples,
                        isCoupleLoaded: true,
                        newCouple: Couple(
                          coupleId: _couples.length + 1,
                          user1Id: FirebaseAuth.instance.currentUser?.uid ?? '',
                          user2Id: '',
                          anniversaryDate: '',
                          createdAt: '',
                        ),
                        onAdd: _onAddCouple,
                        onDelete: _onDeleteCouple,
                        onSave: _onSaveAllCouples,
                      ),
                    ],
                    if (_couples.isEmpty) ...[
                      ElevatedButton(
                        onPressed: () {
                          Couple newCouple = Couple(
                            coupleId: _couples.length + 1,
                            user1Id:
                                FirebaseAuth.instance.currentUser?.uid ?? '',
                            user2Id: '',
                            anniversaryDate: '',
                            createdAt: '',
                          );
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('新しいカップル情報を追加'),
                              content: CoupleInfoForm(
                                coupleService: coupleService,
                                couples: _couples,
                                isCoupleLoaded: false,
                                newCouple: newCouple,
                                onAdd: (couple) {
                                  setState(() {
                                    _couples.add(couple);
                                  });
                                  Navigator.of(context).pop();
                                },
                                onDelete: (index) {},
                                onSave: (couples) {},
                              ),
                            ),
                          );
                        },
                        child: Text('新しいカップル情報を追加'),
                      ),
                    ],
                  ],
                ),
                Container(
                  child: FavoriteCustomTabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'お気に入りスポット'),
                      Tab(text: 'お気に入りプラン'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ProfileSpotList(),
                      ProfilePlanList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CoupleInfoForm extends StatelessWidget {
  final CoupleService coupleService;
  final List<Couple> couples;
  final bool isCoupleLoaded;
  final Couple newCouple;
  final ValueChanged<Couple> onAdd;
  final ValueChanged<int> onDelete;
  final ValueChanged<List<Couple>> onSave;

  CoupleInfoForm({
    required this.coupleService,
    required this.couples,
    required this.isCoupleLoaded,
    required this.newCouple,
    required this.onAdd,
    required this.onDelete,
    required this.onSave,
  });

  final _coupleFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Couple _newCouple = newCouple;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Couples Info:'),
        if (isCoupleLoaded)
          Form(
            key: _coupleFormKey,
            child: Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: couples.length,
                itemBuilder: (context, index) {
                  final couple = couples[index];
                  return ListTile(
                    title: Text('Couple ID: ${couple.coupleId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: couple.anniversaryDate,
                          decoration:
                              InputDecoration(labelText: 'Anniversary Date'),
                          onSaved: (value) {
                            couples[index] =
                                couple.copyWith(anniversaryDate: value);
                          },
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        coupleService
                            .deleteCoupleInfo(couple.user1Id)
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Couple info deleted')),
                          );
                          onDelete(index);
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to delete couple info: $error')),
                          );
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          )
        else
          _buildCoupleForm(context, _newCouple),
        ElevatedButton(
          onPressed: () {
            _coupleFormKey.currentState!.save(); // フォーム全体を保存
            for (var couple in couples) {
              coupleService.updateCoupleInfo(couple).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Couple info updated')),
                );
                onSave(couples);
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Failed to update couple info: $error')),
                );
              });
            }
          },
          child: Text('Save All Couples'),
        ),
      ],
    );
  }

  Widget _buildCoupleForm(BuildContext context, Couple newCouple) {
    return Form(
      key: _coupleFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'User 2 ID'),
            onSaved: (value) {
              newCouple = newCouple.copyWith(user2Id: value ?? '');
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Anniversary Date'),
            onSaved: (value) {
              newCouple = newCouple.copyWith(anniversaryDate: value ?? '');
            },
          ),
          ElevatedButton(
            onPressed: () {
              _coupleFormKey.currentState!.save();
              coupleService.addCoupleInfo(newCouple).then((_) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Couple info added')));
                onAdd(newCouple);
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to add couple info: $error')));
              });
            },
            child: Text('Add New Couple'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
