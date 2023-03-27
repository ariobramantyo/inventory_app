import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/color.dart';
import 'package:inventory_app/core/theme/typo.dart';
import 'package:inventory_app/features/auth/data/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColor.bgLight),
              child: Center(
                  child: Text(
                _getFirstLetterFromEmail(
                    FirebaseAuth.instance.currentUser!.email ?? 'email'),
                style: AppTypography.headline
                    .copyWith(fontWeight: FontWeight.w600),
              )),
            ),
            SizedBox(height: 10),
            Text(
              FirebaseAuth.instance.currentUser!.email ?? 'email',
              style: AppTypography.regular12,
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  onPressed: () async {
                    await AuthService.logOut();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      minimumSize: const Size.fromHeight(40)),
                  child: const Text('Log out')),
            ),
          ],
        ),
      ),
    );
  }

  String _getFirstLetterFromEmail(String email) {
    return email[0];
  }
}
