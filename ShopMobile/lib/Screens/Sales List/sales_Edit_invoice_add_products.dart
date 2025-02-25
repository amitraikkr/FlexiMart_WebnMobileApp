// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart.dart';
import '../../Screens/Sales/sales_products_list_screen.dart';
import '../../model/add_to_cart_model.dart';
import '../../model/sale_transaction_model.dart';

// ignore: must_be_immutable
class EditSaleInvoiceSaleProducts extends StatefulWidget {
  EditSaleInvoiceSaleProducts({Key? key, @required this.catName, required this.salesInfo}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var catName;
  SalesTransaction salesInfo;

  @override
  // ignore: library_private_types_in_public_api
  _EditSaleInvoiceSaleProductsState createState() => _EditSaleInvoiceSaleProductsState();
}

class _EditSaleInvoiceSaleProductsState extends State<EditSaleInvoiceSaleProducts> {
  String dropdownValue = '';
  String productCode = '0000';
  TextEditingController codeController = TextEditingController();

  var salesCart = FlutterCart();
  String productPrice = '0';
  String sentProductPrice = '';

  @override
  void initState() {
    widget.catName == null ? dropdownValue = 'Fashion' : dropdownValue = widget.catName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(salesEditCartProvider);
      final productList = ref.watch(productProvider(null));

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(

          title: Text(
            lang.S.of(context).addItems,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          controller: codeController,
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              productCode = value;
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            //labelText: 'Product Code',
                            labelText: lang.S.of(context).productCode,
                            hintText: productCode == '0000' || productCode == '-1' ? lang.S.of(context).scanProductQRCode : productCode,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: ()async {
                            await showDialog(
                              context: context,
                              useSafeArea: true,
                              builder: (context1) {
                                MobileScannerController controller = MobileScannerController(
                                  torchEnabled: false,
                                  returnImage: false,
                                );
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.circular(6.0),
                                  ),
                                  child: Column(
                                    children: [
                                      AppBar(
                                        backgroundColor: Colors.transparent,
                                        iconTheme: const IconThemeData(color: Colors.white),
                                        leading: IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          onPressed: () {
                                            Navigator.pop(context1);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: MobileScanner(
                                          fit: BoxFit.contain,
                                          controller: controller,
                                          onDetect: (capture) {
                                            final List<Barcode> barcodes = capture.barcodes;

                                            if (barcodes.isNotEmpty) {
                                              final Barcode barcode = barcodes.first;
                                              debugPrint('${lang.S.of(context).barcodeFound}! ${barcode.rawValue}');
                                              setState(() {
                                                productCode = barcode.rawValue!;
                                                codeController.text = productCode;
                                              });
                                              Navigator.pop(context1);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 60.0,
                            width: 100.0,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: kGreyTextColor),
                            ),
                            child: const Image(
                              image: AssetImage('images/barcode.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                productList.when(data: (products) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        if (widget.salesInfo.party!.type!.contains('Retailer')) {
                          productPrice = products[i].productSalePrice.toString();
                        } else if (widget.salesInfo.party!.type!.contains('Dealer')) {
                          productPrice = products[i].productDealerPrice.toString();
                        } else if (widget.salesInfo.party!.type!.contains('Wholesaler')) {
                          productPrice = products[i].productWholeSalePrice.toString();
                        } else if (widget.salesInfo.party!.type!.contains('Supplier')) {
                          productPrice = products[i].productPurchasePrice.toString();
                        } else if (widget.salesInfo.party!.type!.contains('Guest')) {
                          productPrice = products[i].productSalePrice.toString();
                        }
                        return GestureDetector(
                          onTap: () async {
                            if ((products[i].productStock ?? 0) <= 0) {
                              EasyLoading.showError(lang.S.of(context).outOfStock);
                            } else {
                              if (widget.salesInfo.party!.type!.contains('Retailer')) {
                                sentProductPrice = products[i].productSalePrice.toString();
                              } else if (widget.salesInfo.party!.type!.contains('Dealer')) {
                                sentProductPrice = products[i].productDealerPrice.toString();
                              } else if (widget.salesInfo.party!.type!.contains('Wholesaler')) {
                                sentProductPrice = products[i].productWholeSalePrice.toString();
                              } else if (widget.salesInfo.party!.type!.contains('Supplier')) {
                                sentProductPrice = products[i].productPurchasePrice.toString();
                              } else if (widget.salesInfo.party!.type!.contains('Guest')) {
                                sentProductPrice = products[i].productSalePrice.toString();
                              }

                              AddToCartModel cartItem = AddToCartModel(
                                productName: products[i].productName,
                                price: sentProductPrice,
                                productId: products[i].productCode,
                                uuid: products[i].id ?? 0,
                                productBrandName: products[i].brand?.brandName ?? '',
                                stock: (products[i].productStock ?? 0).round(),
                              );
                              providerData.addToCart(cartItem);
                              providerData.addProductsInSales(products[i]);
                              EasyLoading.showSuccess(
                                lang.S.of(context).addedToCart,
                                  //'Added To Cart'
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: ProductCard(
                            stock: products[i].productStock ?? 0,
                            productTitle: products[i].productName.toString(),
                            productDescription: products[i].brand?.brandName ?? '',
                            productPrice: num.tryParse(productPrice) ?? 0,
                            productImage: products[i].productPicture,
                          ).visible((products[i].productCode == productCode || productCode == '0000' || productCode == '-1') && productPrice != '0'||
                              products[i].productName!.toLowerCase().contains(productCode.toLowerCase())),
                        );
                      });
                }, error: (e, stack) {
                  return Text(e.toString());
                }, loading: () {
                  return const Center(child: CircularProgressIndicator());
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
