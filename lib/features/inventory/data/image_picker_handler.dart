import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHandler {
  final ImagePicker imagePicker = ImagePicker();
  XFile? pickedImage;

  Future<File?> pickImage() async {
    try {
      pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        return File(pickedImage!.path);
      }

      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
