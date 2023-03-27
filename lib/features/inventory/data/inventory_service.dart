import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_app/features/inventory/data/model/inventory.dart';

class InventoryService {
  static Future<bool> addInventory(User user, Inventory inventory) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('inventory')
          .add(inventory.toMap());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> editInventory(
      User user, Inventory inventory, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('inventory')
          .doc(docId)
          .update(inventory.toMap());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteInventory(User user, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('inventory')
          .doc(docId)
          .delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
