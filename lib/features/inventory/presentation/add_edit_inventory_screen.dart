import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/core/constant/strings.dart';
import 'package:inventory_app/core/theme/color.dart';
import 'package:inventory_app/core/theme/typo.dart';
import 'package:inventory_app/core/widget/loading_dialog.dart';
import 'package:inventory_app/features/inventory/data/firebase_storage_service.dart';
import 'package:inventory_app/features/inventory/data/image_picker_handler.dart';
import 'package:inventory_app/features/inventory/data/inventory_service.dart';
import 'package:inventory_app/features/inventory/data/model/inventory.dart';

class AddEDitInventoryScreen extends StatefulWidget {
  AddEDitInventoryScreen({super.key, this.inventory, this.docId});

  Inventory? inventory;
  String? docId;

  @override
  State<AddEDitInventoryScreen> createState() => _AddEDitInventoryScreenState();
}

class _AddEDitInventoryScreenState extends State<AddEDitInventoryScreen> {
  late TextEditingController _titleController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _noteController;

  File? pickedImage;

  @override
  void initState() {
    super.initState();

    var title = '';
    var quantity = '';
    var price = '';
    var note = '';

    if (widget.inventory != null) {
      title = widget.inventory!.title;
      quantity = widget.inventory!.quantity;
      price = widget.inventory!.price;
      note = widget.inventory!.note;
      totalValue = (int.parse(quantity) * int.parse(price)).toString();
    }
    _titleController = TextEditingController(text: title);
    _quantityController = TextEditingController(text: quantity);
    _priceController = TextEditingController(text: price);
    _noteController = TextEditingController(text: note);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  var totalValue = '0';

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        actions: [
          IconButton(
              onPressed: () async {
                if (_key.currentState!.validate()) {
                  LoadingDialog.showLoadingDialog(context);

                  final timeNow = DateTime.now().toIso8601String();
                  if (widget.inventory != null) {
                    String imageUrl = '';

                    if (pickedImage != null) {
                      imageUrl = await FirebaseStorageService.uploadImage(
                          timeNow, pickedImage!.path);
                    }

                    final result = await InventoryService.editInventory(
                        FirebaseAuth.instance.currentUser!,
                        Inventory(
                            title: _titleController.text,
                            quantity: _quantityController.text,
                            price: _priceController.text,
                            totalValue: totalValue,
                            note: _noteController.text,
                            imageUrl: imageUrl,
                            updatedAt: timeNow),
                        widget.docId!);

                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('Inventory has been succesfuly edited')));

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Edit inventory failed')));
                    }
                  } else {
                    String imageUrl = '';

                    if (pickedImage != null) {
                      imageUrl = await FirebaseStorageService.uploadImage(
                          timeNow, pickedImage!.path);
                    }

                    final result = await InventoryService.addInventory(
                        FirebaseAuth.instance.currentUser!,
                        Inventory(
                            title: _titleController.text,
                            quantity: _quantityController.text,
                            price: _priceController.text,
                            totalValue: totalValue,
                            note: _noteController.text,
                            imageUrl: imageUrl,
                            updatedAt: timeNow));

                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('Inventory has been succesfuly added')));

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('Inventory failed added to firestore')));
                    }
                  }

                  LoadingDialog.dismissLoadingDialog(context);
                }
              },
              icon: const Icon(Icons.check))
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          pickedImage != null
              ? SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Image.file(
                        pickedImage!,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              'Edit photo',
                              style: AppTypography.regular12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : widget.inventory != null
                  ? widget.inventory!.imageUrl == ''
                      ? _containerAddImage()
                      : SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Image.network(
                                widget.inventory!.imageUrl,
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Text(
                                      'Edit photo',
                                      style: AppTypography.regular12,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                  : _containerAddImage(),
          Form(
              key: _key,
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(20),
                      color: AppColor.bgSecondary,
                      child: TextFormField(
                        controller: _titleController,
                        style: AppTypography.headline
                            .copyWith(fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                            hintText: 'Enter item name',
                            hintStyle: AppTypography.headline.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "this field can't be empty";
                          }
                        },
                      )),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _dataItem(_quantityController, 'Quantity', '12'),
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _dataItem(
                                _priceController, 'Price', 'Rp.1000000'),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.grey,
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total value',
                                  style: AppTypography.regular12
                                      .copyWith(color: Colors.grey),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  totalValue,
                                  style: AppTypography.regular12,
                                ),
                              ],
                            ),
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
                    child: _dataItem(_noteController, 'Note', Strings.lorem,
                        mustFilled: false),
                  ),
                ],
              )),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  Widget _dataItem(TextEditingController controller, String title, String data,
      {bool mustFilled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.regular12.copyWith(color: Colors.grey),
        ),
        TextFormField(
          controller: controller,
          style: AppTypography.regular12,
          keyboardType: title == 'Quantity' || title == 'Price'
              ? TextInputType.number
              : TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Enter item name',
              hintStyle: AppTypography.regular12
                  .copyWith(color: Colors.grey, fontWeight: FontWeight.w500)),
          validator: ((value) {
            if (mustFilled) {
              if (value!.isEmpty) {
                return "This field can't be empty";
              }
            }
          }),
          onChanged: (value) {
            if (title == 'Quantity' || title == 'Price') {
              if (_quantityController.text.isNotEmpty &&
                  _priceController.text.isNotEmpty) {
                setState(() {
                  totalValue = (int.parse(_quantityController.text) *
                          int.parse(_priceController.text))
                      .toString();
                });
              }
            }
          },
        )
      ],
    );
  }

  void _pickImage() async {
    final imagePicker = ImagePickerHandler();

    pickedImage = await imagePicker.pickImage();
    setState(() {});
  }

  Widget _containerAddImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              color: Colors.grey[300],
              size: 60,
            ),
            Text(
              'Add a photo',
              style: AppTypography.subHeading.copyWith(color: Colors.grey[300]),
            )
          ],
        ),
      ),
    );
  }
}
