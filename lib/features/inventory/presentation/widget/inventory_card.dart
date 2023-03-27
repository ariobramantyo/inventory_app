import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/typo.dart';
import 'package:inventory_app/features/inventory/data/model/inventory.dart';
import 'package:inventory_app/features/inventory/presentation/detail_inventory_screen.dart';

class InventoryCard extends StatelessWidget {
  const InventoryCard(
      {super.key, required this.inventory, required this.docId});

  final Inventory inventory;
  final String docId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailInventoryScreen(docId: docId),
            ));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 9,
                  spreadRadius: 2)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (inventory.imageUrl.isEmpty)
              Container(
                height: 80,
                width: 80,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.image,
                  color: Colors.grey,
                ),
              )
            else
              Image.network(
                inventory.imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 + 20,
                  child: Text(
                    inventory.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.regular12
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 + 20,
                  child: Text(
                    '${inventory.quantity} units | Rp.${inventory.price}',
                    style: AppTypography.regular12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
