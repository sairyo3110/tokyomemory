import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/test/businesslogic/couple.dart';
import 'package:mapapp/test/businesslogic/user.dart';
import 'package:mapapp/test/model/couple.dart';
import 'package:mapapp/test/model/user.dart';
import 'package:mapapp/test/repositories/couple_repository.dart';
import 'package:mapapp/test/repositories/user_repository.dart';
import 'package:mapapp/test/view/couple.dart';
import 'package:mapapp/test/view/user.dart';

class HomePage extends StatefulWidget {
  final User? user;

  HomePage({Key? key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserInfoService userInfoService =
      UserInfoService(userInfoRepository: UserInfoRepository());

  final CoupleService coupleService =
      CoupleService(coupleRepository: CoupleRepository());

  late Couple _newCouple;
  List<Couple> _couples = [];
  bool _isCoupleLoaded = false;

  @override
  void initState() {
    super.initState();
    _newCouple = Couple(
      coupleId: 0,
      user1Id: widget.user?.uid ?? '',
      user2Id: '',
      anniversaryDate: '',
      createdAt: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: userInfoService.fetchUserInfo(widget.user?.uid ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return UserInfoForm(
                userInfoService: userInfoService,
                userInfo: null,
                isUserLoaded: false,
                onSave: _onSaveUser,
                onDelete: _onDeleteUser,
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final user = snapshot.data!['user'] as UserInfoRDB;
              final couples = snapshot.data!['couples'] as List<Couple>;
              if (user.firebaseUserId == null || user.firebaseUserId!.isEmpty) {
                return UserInfoForm(
                  userInfoService: userInfoService,
                  userInfo: null,
                  isUserLoaded: false,
                  onSave: _onSaveUser,
                  onDelete: _onDeleteUser,
                );
              }
              _isCoupleLoaded = couples.isNotEmpty;
              _couples = couples;
              return Column(
                children: [
                  UserInfoForm(
                    userInfoService: userInfoService,
                    userInfo: user,
                    isUserLoaded: true,
                    onSave: _onSaveUser,
                    onDelete: _onDeleteUser,
                  ),
                  CoupleInfoForm(
                    coupleService: coupleService,
                    couples: couples,
                    isCoupleLoaded: _isCoupleLoaded,
                    newCouple: _newCouple,
                    onAdd: _onAddCouple,
                    onDelete: _onDeleteCouple,
                    onSave: _onSaveAllCouples,
                  ),
                ],
              );
            } else {
              return UserInfoForm(
                userInfoService: userInfoService,
                userInfo: null,
                isUserLoaded: false,
                onSave: _onSaveUser,
                onDelete: _onDeleteUser,
              );
            }
          },
        ),
      ),
    );
  }

  void _onSaveUser(UserInfoRDB userInfo) {
    setState(() {});
  }

  void _onDeleteUser() {
    Navigator.pop(context);
  }

  void _onAddCouple(Couple couple) {
    setState(() {
      _couples.add(couple);
      _isCoupleLoaded = true;
    });
  }

  void _onDeleteCouple(int index) {
    setState(() {
      _couples.removeAt(index);
      _isCoupleLoaded = _couples.isNotEmpty;
    });
  }

  void _onSaveAllCouples(List<Couple> couples) {
    setState(() {
      _couples = couples;
    });
  }
}
