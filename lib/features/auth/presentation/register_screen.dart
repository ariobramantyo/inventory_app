import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_app/core/constant/strings.dart';
import 'package:inventory_app/core/theme/color.dart';
import 'package:inventory_app/core/theme/typo.dart';
import 'package:inventory_app/core/widget/loading_dialog.dart';
import 'package:inventory_app/features/auth/data/auth_service.dart';
import 'package:inventory_app/features/auth/presentation/widget/custom_text_filed.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  var obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          SvgPicture.asset(
            'assets/images/register.svg',
            width: 242,
          ),
          const SizedBox(height: 82),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Register',
              style:
                  AppTypography.headline.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Form(
              key: _key,
              child: Column(
                children: [
                  CustomTextField(controller: _emailController, hint: 'Email'),
                  const SizedBox(height: 10),
                  CustomTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      obscure: obscurePassword,
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: obscurePassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility_rounded))),
                ],
              )),
          SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              Strings.registerDesc,
              style: AppTypography.regular12,
            ),
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    LoadingDialog.showLoadingDialog(context);

                    try {
                      final result = await AuthService.register(
                          _emailController.text, _passwordController.text);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        'Account succesfully registered',
                        style: AppTypography.regular12
                            .copyWith(color: Colors.white),
                      )));

                      Navigator.pop(context);
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
                        'Register failed, please try again later',
                        style: AppTypography.regular12
                            .copyWith(color: Colors.white),
                      )));
                    }

                    LoadingDialog.dismissLoadingDialog(context);
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
                child: const Text('Register')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined us before?',
                style: AppTypography.regular12,
              ),
              const SizedBox(width: 3),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Login',
                  style: AppTypography.regular12
                      .copyWith(color: AppColor.secondary),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
