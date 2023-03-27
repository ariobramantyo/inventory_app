import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/typo.dart';
import 'package:inventory_app/features/inventory/data/model/inventory.dart';

class InventorySummaryCard extends StatelessWidget {
  const InventorySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 0)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.inventory,
            size: 18,
          ),
          const SizedBox(height: 10),
          Text(
            'Inventory Summary',
            style:
                AppTypography.regular12.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection('inventory').get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final inventories = snapshot.data!.docs.map((inventory) {
                  return Inventory.fromQuerySnapshot(inventory);
                }).toList();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dataItems('Items', inventories.length.toString()),
                    _dataItems('Total Qty', _getTotalQuantity(inventories)),
                    _dataItems('Total Value', _getTotalValue(inventories)),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }

  String _getTotalQuantity(List<Inventory> inventories) {
    var totalQuantity = 0;

    for (var inventory in inventories) {
      totalQuantity = totalQuantity + int.parse(inventory.quantity);
    }

    return totalQuantity.toString();
  }

  String _getTotalValue(List<Inventory> inventories) {
    var totalValue = 0;

    for (var inventory in inventories) {
      totalValue = totalValue + int.parse(inventory.totalValue);
    }
    print(totalValue);

    return _convertTotalValue(totalValue.toString());
  }

  String _convertTotalValue(String totalValue) {
    // 1.000.000
    // 100.000
    var convertedValue = 0.0;

    if (totalValue.length >= 7) {
      convertedValue = double.parse(totalValue) / 1000000;

      return 'Rp.${convertedValue}M';
    } else {
      convertedValue = double.parse(totalValue) / 1000;

      return 'Rp.${convertedValue}k';
    }
  }

  Widget _dataItems(String title, String data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTypography.regular12.copyWith(color: Colors.grey),
        ),
        Text(data, style: AppTypography.regular12)
      ],
    );
  }
}
