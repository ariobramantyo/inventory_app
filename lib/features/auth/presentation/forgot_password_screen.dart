import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_app/core/constant/strings.dart';
import 'package:inventory_app/core/theme/color.dart';
import 'package:inventory_app/core/theme/typo.dart';
import 'package:inventory_app/core/widget/loading_dialog.dart';
import 'package:inventory_app/features/auth/data/auth_service.dart';
import 'package:inventory_app/features/auth/presentation/widget/custom_text_filed.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          SvgPicture.asset(
            'assets/images/forget_password.svg',
            width: 242,
          ),
          const SizedBox(height: 82),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Forgot\nPassword?',
              style:
                  AppTypography.headline.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              Strings.forgotPassDesc,
              style: AppTypography.regular12,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(controller: _emailController, hint: 'Email'),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () async {
                  if (_emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      'Email cannot be empty',
                      style:
                          AppTypography.regular12.copyWith(color: Colors.white),
                    )));
                  } else {
                    LoadingDialog.showLoadingDialog(context);

                    try {
                      await AuthService.resetPassword(_emailController.text);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        'Reset password successfully send to given Email',
                        style: AppTypography.regular12
                            .copyWith(color: Colors.white),
                      )));
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        e.message ?? 'Error',
                        style: AppTypography.regular12
                            .copyWith(color: Colors.white),
                      )));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        'Failed to send reset password to given email',
                        style: AppTypography.regular12
                            .copyWith(color: Colors.white),
                      )));
                    }

                    LoadingDialog.dismissLoadingDialog(context);
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
                child: const Text('Submit')),
          ),
        ],
      )),
    );
  }
}
