import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/color.dart';
import 'package:inventory_app/core/theme/typo.dart';
import 'package:inventory_app/core/widget/loading_dialog.dart';
import 'package:inventory_app/features/auth/presentation/profile_screen.dart';
import 'package:inventory_app/features/inventory/data/model/inventory.dart';
import 'package:inventory_app/features/inventory/presentation/add_edit_inventory_screen.dart';
import 'package:inventory_app/features/inventory/presentation/widget/inventory_card.dart';
import 'package:inventory_app/features/inventory/presentation/widget/inventory_summary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgSecondary,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEDitInventoryScreen(),
              ));
        },
        backgroundColor: AppColor.primary,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: AppTypography.title.copyWith(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ));
              },
              icon: const Icon(Icons.person))
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Stack(
          children: [
            ListView(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InventorySummaryCard(),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Items',
                    style: AppTypography.regular12
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                      color: Colors.white,
                      child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('user')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('inventory')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final inventories =
                                snapshot.data!.docs.map((inventory) {
                              return Inventory.fromQuerySnapshot(inventory);
                            }).toList();

                            return ListView.builder(
                              itemCount: inventories.length,
                              itemBuilder: (context, index) {
                                return InventoryCard(
                                  inventory: inventories[index],
                                  docId: snapshot.data!.docs[index].id,
                                );
                              },
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
