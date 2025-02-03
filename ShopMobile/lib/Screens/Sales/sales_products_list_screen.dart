import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Customers/Model/parties_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Const/api_config.dart';
import '../../Provider/add_to_cart.dart';
import '../../currency.dart';
import '../../model/add_to_cart_model.dart';

// ignore: must_be_immutable
class SaleProductsList extends StatefulWidget {
  SaleProductsList({Key? key, @required this.catName, this.customerModel}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var catName;
  Party? customerModel;

  @override
  // ignore: library_private_types_in_public_api
  _SaleProductsListState createState() => _SaleProductsListState();
}

class _SaleProductsListState extends State<SaleProductsList> {
  String dropdownValue = '';
  String productCode = '0000';
  TextEditingController codeController = TextEditingController();

  var salesCart = FlutterCart();
  num productPrice = 0;
  String sentProductPrice = '';

  @override
  void initState() {
    widget.catName == null ? dropdownValue = 'Fashion' : dropdownValue = widget.catName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      final productList = ref.watch(productProvider(null));

      return Scaffold(
        backgroundColor: kWhite,
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
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
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
                          labelText: lang.S.of(context).productCode,
                         // hintText: productCode == '0000' || productCode == '-1' ? 'Scan product QR code' : productCode,
                          hintText: productCode == '0000' || productCode == '-1' ? lang.S.of(context).scanProductQRCode : productCode,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
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
                  ],
                ),
                productList.when(data: (products) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        if (widget.customerModel != null) {
                          if (widget.customerModel!.type!.contains('Retailer')) {
                            productPrice = products[i].productSalePrice ?? 0;
                          } else if (widget.customerModel!.type!.contains('Dealer')) {
                            productPrice = products[i].productDealerPrice ?? 0;
                          } else if (widget.customerModel!.type!.contains('Wholesaler')) {
                            productPrice = products[i].productWholeSalePrice ?? 0;
                          } else if (widget.customerModel!.type!.contains('Supplier')) {
                            productPrice = products[i].productPurchasePrice ?? 0;
                          } else if (widget.customerModel!.type!.contains('Guest')) {
                            productPrice = products[i].productSalePrice ?? 0;
                          }
                        } else {
                          productPrice = products[i].productSalePrice ?? 0;
                        }

                        return GestureDetector(
                          onTap: () async {
                            if ((products[i].productStock ?? 0) <= 0) {
                              //EasyLoading.showError('Out of stock');
                              EasyLoading.showError(lang.S.of(context).outOfStock);
                            } else {
                              if (widget.customerModel == null) {
                                sentProductPrice = products[i].productSalePrice.toString();
                              } else {
                                if (widget.customerModel!.type!.contains('Retailer')) {
                                  sentProductPrice = products[i].productSalePrice.toString();
                                } else if (widget.customerModel!.type!.contains('Dealer')) {
                                  sentProductPrice = products[i].productDealerPrice.toString();
                                } else if (widget.customerModel!.type!.contains('Wholesaler')) {
                                  sentProductPrice = products[i].productWholeSalePrice.toString();
                                } else if (widget.customerModel!.type!.contains('Supplier')) {
                                  sentProductPrice = products[i].productPurchasePrice.toString();
                                }
                              }

                              AddToCartModel cartItem = AddToCartModel(
                                productName: products[i].productName,
                                price: sentProductPrice,
                                productId: products[i].productCode,
                                productBrandName: products[i].brand?.brandName ?? '',
                                productPurchasePrice: products[i].productPurchasePrice,
                                stock: (products[i].productStock ?? 0).round(),
                                uuid: products[i].id ?? 0,
                              );
                              providerData.addToCart(cartItem);
                              providerData.addProductsInSales(products[i]);
                              Navigator.pop(context);
                            }
                          },
                          child: ProductCard(
                            productTitle: products[i].productName.toString(),
                            productDescription: products[i].brand?.brandName ?? '',
                            productPrice: productPrice,
                            productImage: products[i].productPicture,
                            stock: products[i].productStock ?? 0,
                          ).visible((products[i].productCode == productCode || productCode == '0000' || productCode == '-1') && productPrice != '0' ||
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
        // bottomNavigationBar: ButtonGlobal(
        //   iconWidget: Icons.arrow_forward,
        //   buttontext: 'Sales List',
        //   iconColor: Colors.white,
        //   buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
        //   onPressed: () {
        //     // ignore: missing_required_param
        //     providerData.getTotalAmount() <= 0
        //         ? EasyLoading.showError('Cart Is Empty')
        //         : SalesDetails(
        //             customerName: widget.customerModel!.customerName,
        //           ).launch(context);
        //   },
        // ),
      );
    });
  }
}

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  ProductCard({Key? key, required this.productTitle, required this.productDescription, required this.productPrice, required this.productImage, required this.stock})
      : super(key: key);

  // final Product product;
  String productTitle, productDescription;
  num productPrice, stock;
  String? productImage;
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  num quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      for (var element in providerData.cartItemList) {
        if (element.productName == widget.productTitle) {
          quantity = element.quantity;
        }
      }
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 60,
                width: 60,
                decoration: widget.productImage == null
                    ? BoxDecoration(
                        image: DecorationImage(image: AssetImage(noProductImageUrl), fit: BoxFit.cover),
                      )
                    : BoxDecoration(
                        image: DecorationImage(image: NetworkImage("${APIConfig.domain}${widget.productImage}"), fit: BoxFit.cover),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.productTitle,
                        style: GoogleFonts.jost(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        //'Stock: ${widget.stock}',
                        '${lang.S.of(context).stocks}${widget.stock}',
                        style: GoogleFonts.jost(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.productDescription,
                    style: GoogleFonts.jost(
                      fontSize: 15.0,
                      color: kGreyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              '$currency${widget.productPrice}',
              style: GoogleFonts.jost(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    });
  }
}
