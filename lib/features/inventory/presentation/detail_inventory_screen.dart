import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_app/core/constant/strings.dart';
import 'package:inventory_app/core/theme/color.dart';
import 'package:inventory_app/core/theme/typo.dart';
import 'package:inventory_app/features/auth/data/auth_service.dart';
import 'package:inventory_app/features/inventory/data/inventory_service.dart';
import 'package:inventory_app/features/inventory/data/model/inventory.dart';
import 'package:inventory_app/features/inventory/presentation/add_edit_inventory_screen.dart';
import 'package:inventory_app/features/inventory/presentation/full_image_screen.dart';

class DetailInventoryScreen extends StatefulWidget {
  DetailInventoryScreen({super.key, required this.docId});

  final String docId;

  @override
  State<DetailInventoryScreen> createState() => _DetailInventoryScreenState();
}

class _DetailInventoryScreenState extends State<DetailInventoryScreen> {
  Inventory? inventory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () async {
                  final result = await InventoryService.deleteInventory(
                      FirebaseAuth.instance.currentUser!, widget.docId);

                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Inventory has been succesfuly delted')));

                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Delete inventory failed')));
                  }
                },
                icon: const Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEDitInventoryScreen(
                          inventory: inventory,
                          docId: widget.docId,
                        ),
                      ));
                },
                icon: const Icon(Icons.edit)),
          ],
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('inventory')
              .doc(widget.docId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              inventory = Inventory.fromDocumentSnapshot(snapshot.data!);

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView(
                  children: [
                    if (inventory!.imageUrl.isEmpty)
                      Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 50,
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return FullImageScreen(
                                  imageUrl: inventory!.imageUrl);
                            },
                          ));
                        },
                        child: Image.network(
                          inventory!.imageUrl,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: AppColor.bgSecondary,
                      child: Text(
                        inventory!.title,
                        style: AppTypography.headline
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _dataItem(
                          'Updated at',
                          DateFormat('MM/dd/yyyy hh:mm a')
                              .format(DateTime.parse(inventory!.updatedAt))),
                    ),
                    const Divider(
                      height: 25,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _dataItem('Quantity', inventory!.quantity),
                    ),
                    const Divider(
                      height: 25,
                      color: Colors.grey,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  _dataItem('Price', 'Rp.${inventory!.price}'),
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: _dataItem(
                                  'Total value', 'Rp.${inventory!.totalValue}'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 25,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _dataItem('Note', inventory!.note),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Widget _dataItem(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.regular12.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Text(
          data.isEmpty ? '-' : data,
          style: AppTypography.regular12,
        ),
      ],
    );
  }
}
