import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/typo.dart';

class LoadingDialog {
  static showLoadingDialog(BuildContext context) {
    final loadingDialog = AlertDialog(
      content: Row(
        children: const [
          SizedBox(height: 25, width: 25, child: CircularProgressIndicator()),
          SizedBox(width: 20),
          Text(
            'Loading',
            style: AppTypography.regular,
          )
        ],
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => loadingDialog,
    );
  }

  static dismissLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
