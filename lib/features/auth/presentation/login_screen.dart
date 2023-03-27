import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_app/core/theme/color.dart';
import 'package:inventory_app/core/theme/typo.dart';
import 'package:inventory_app/core/widget/loading_dialog.dart';
import 'package:inventory_app/features/auth/data/auth_service.dart';
import 'package:inventory_app/features/auth/presentation/forgot_password_screen.dart';
import 'package:inventory_app/features/auth/presentation/register_screen.dart';
import 'package:inventory_app/features/auth/presentation/widget/custom_text_filed.dart';
import 'package:inventory_app/features/inventory/presentation/home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      body: SafeArea(
          child: ListView(
        children: [
          const SizedBox(height: 50),
          SvgPicture.asset(
            'assets/images/login.svg',
            width: 242,
          ),
          const SizedBox(height: 82),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Login',
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
                            print(obscurePassword);
                          },
                          icon: obscurePassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility_rounded))),
                ],
              )),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppTypography.regular12
                        .copyWith(color: AppColor.secondary),
                  )),
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
                      final result = await AuthService.login(
                          _emailController.text, _passwordController.text);
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
                child: const Text('Login')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'New to Terature?',
                style: AppTypography.regular12,
              ),
              const SizedBox(width: 3),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ));
                },
                child: Text(
                  'Register',
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
