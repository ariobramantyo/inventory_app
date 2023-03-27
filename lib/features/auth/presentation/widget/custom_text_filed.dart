import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/typo.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.hint,
      this.suffix,
      this.obscure = false,
      required this.controller});

  final String hint;
  final Widget? suffix;
  bool obscure;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
              suffixIcon: suffix,
              border: InputBorder.none,
              filled: true,
              hintText: hint,
              hintStyle: AppTypography.regular.copyWith(color: Colors.grey)),
          validator: (value) {
            if (value!.isEmpty) {
              return 'This filed cannot be empty';
            }
          },
        ),
      ),
    );
  }
}
