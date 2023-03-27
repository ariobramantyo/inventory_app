import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseStorageService {
  static FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static Future<String> uploadImage(String uid, String imagePath) async {
    Reference reference = _firebaseStorage.ref('$uid.jpg');

    try {
      await reference.putFile(File(imagePath));

      final imageUrl = await reference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }
}
