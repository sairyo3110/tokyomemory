import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mapapp/businesslogic/user/user.dart';
import 'package:mapapp/view/profile/profile_login.dart';
import 'package:mapapp/view/profile/profile_main.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUserid();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, viewModel, child) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return ProfileLogin();
          } else {
            return ProfileLogin();
          }
        },
      ),
    );
  }
}
