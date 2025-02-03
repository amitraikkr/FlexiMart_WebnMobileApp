import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/Screens/Sales/Repo/sales_repo.dart';
import 'package:mobile_pos/Screens/Sales/customer_screen_for_sales.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Const/api_config.dart';
import '../../Repository/API/future_invoice.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/business_info_model.dart' as b;
import '../../model/sale_transaction_model.dart';
import '../Customers/Model/parties_model.dart';
import '../Home/home.dart';
import '../Home/home_screen.dart';
import '../invoice_details/sales_invoice_details_screen.dart';

// ignore: must_be_immutable
class AddSalesScreen extends StatefulWidget {
  AddSalesScreen({Key? key, required this.customerModel}) : super(key: key);

  Party? customerModel;

  @override
  State<AddSalesScreen> createState() => _AddSalesScreenState();
}

class _AddSalesScreenState extends State<AddSalesScreen> {
  bool isFullReceved = false;
  TextEditingController paindAmountController = TextEditingController();
  TextEditingController paidText = TextEditingController();
  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double dueAmount = 0;
  double subTotal = 0;
  String? paymentType = 'Cash';
  String? selectedPaymentType;
  TextEditingController vatPercentageEditingController = TextEditingController();
  TextEditingController vatAmountEditingController = TextEditingController();
  TextEditingController discountPercentageEditingController = TextEditingController();
  TextEditingController discountAmountEditingController = TextEditingController();

  double vatAmount = 0;

  bool isClicked = false;

  double calculateSubtotal({required double total}) {
    subTotal = total + vatAmount - discountAmount;
    return total + vatAmount - discountAmount;
  }

  double calculateReturnAmount({required double total}) {
    returnAmount = total - paidAmount;
    return paidAmount <= 0 || paidAmount <= subTotal ? 0 : total - paidAmount;
  }

  double calculateDueAmount({required double total}) {
    if (total < 0) {
      dueAmount = 0;
    } else {
      dueAmount = subTotal - paidAmount;
    }
    return returnAmount <= 0 ? 0 : subTotal - paidAmount;
  }

  DateTime selectedDate = DateTime.now();

  late b.BusinessInformation personalInformationModel;
  TextEditingController dateController = TextEditingController(text: DateTime.now().toString().substring(0, 10));
  TextEditingController phoneContoller = TextEditingController();

  Party? selectedCustomer;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    paindAmountController.dispose();
    phoneContoller.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final cartProviderData = consumerRef.watch(cartNotifier);
      final personalData = consumerRef.watch(businessInfoProvider);
      return personalData.when(data: (data) {
        personalInformationModel = data;
        return Scaffold(
          backgroundColor: kBackgroundColor,

          ///________APP_BAR_______________________
          appBar: AppBar(
            backgroundColor: kWhite,
            title: Text(
              lang.S.of(context).addSales,
              style: GoogleFonts.poppins(
                color: Colors.black,
              ),
            ),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        cartProviderData.clearCart();
                        Navigator.pop(context);
                      },
                      //child: const Text('Clear All'),
                      child: Text(lang.S.of(context).clearAll),
                    ),
                  ];
                },
              )
            ],
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 2.0,
            surfaceTintColor: kWhite,
          ),

          ///_______Body___________________________
          body: SingleChildScrollView(
            child: Column(
              children: [
                ///__________Select_Customer________________________________
                selectedCustomer != null
                    ? ListTile(
                        tileColor: kWhite,
                        leading: const Icon(IconlyBold.add_user, color: kMainColor, size: 26),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCustomer?.name ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              selectedCustomer?.due.toString() ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCustomer?.phone ?? '',
                            ),
                            Text(
                              lang.S.of(context).previousDue,
                              //'Previous Due',
                            ),
                          ],
                        ),
                        shape: const Border(bottom: BorderSide(width: 1, color: kBorderColor), top: BorderSide(width: 1, color: kBorderColor)),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCustomer = null;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : ListTile(
                        tileColor: kWhite,
                        onTap: () async {
                          selectedCustomer = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomerScreenSales(),
                              ));

                          setState(() {});
                        },
                        leading: const Icon(IconlyBold.add_user, color: kMainColor, size: 26),
                        title: Text(
                          lang.S.of(context).addCustomer,
                          //'Add Customer',
                          style: const TextStyle(color: kMainColor),
                        ),
                        shape: const Border(bottom: BorderSide(width: 1, color: kBorderColor), top: BorderSide(width: 1, color: kBorderColor)),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ),

                const SizedBox(height: 15),

                ///______________Invoice and Date________________________________
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    children: [
                      FutureBuilder(
                        future: FutureInvoice().getFutureInvoice(tag: 'sales'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: AppTextField(
                                textFieldType: TextFieldType.NAME,
                                initialValue: snapshot.data.toString(),
                                readOnly: true,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: lang.S.of(context).inv,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            );
                          } else {
                            // return const CircularProgressIndicator();
                            return Expanded(
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: lang.S.of(context).inv,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: dateController,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).date,
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                  context: context,
                                );
                                if (picked != null && picked != selectedDate) {
                                  setState(() {
                                    selectedDate = picked;
                                  });
                                }
                              },
                              icon: const Icon(FeatherIcons.calendar),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                ///_______Added_ItemS__________________________________________________
                Container(
                  decoration: const BoxDecoration(color: kWhite),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.S.of(context).itemAdded,
                                style: const TextStyle(fontSize: 16),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    '+ ${lang.S.of(context).addItems}',
                                    style: const TextStyle(fontSize: 16, color: kMainColor),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartProviderData.cartItemList.length,
                          itemBuilder: (context, index) {
                            cartProviderData.controllers[index].text = (cartProviderData.cartItemList[index].quantity.toString());
                            cartProviderData.focus[index].addListener(
                              () {
                                if (!cartProviderData.focus[index].hasFocus) {
                                  setState(() {
                                    vatAmount = (vatPercentageEditingController.text.toDouble() / 100) * cartProviderData.getTotalAmount().toDouble();
                                    vatAmountEditingController.text = vatAmount.toStringAsFixed(2);
                                  });
                                }
                              },
                            );
                            return Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: cartProviderData.cartItemList[index].imageUrl != null
                                    ? Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: kMainColor,
                                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                                            image: DecorationImage(image: NetworkImage('${APIConfig.domain}${cartProviderData.cartItemList[index].imageUrl!}'), fit: BoxFit.cover)),
                                      )
                                    : Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: kMainColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                                          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(noProductImageUrl)),
                                        ),
                                      ),
                                title: RichText(
                                  text: TextSpan(
                                    text: cartProviderData.cartItemList[index].productName.toString(),
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(text: ' X ${cartProviderData.cartItemList[index].quantity}', style: const TextStyle(color: kMainColor)),
                                    ],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$currency ${cartProviderData.cartItemList[index].price * cartProviderData.cartItemList[index].quantity}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      onPressed: () async {
                                        await showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (context) => ItemDetailsModal(
                                            product: cartProviderData.cartItemList[index],
                                            ref: consumerRef,
                                          ),
                                        );

                                        setState(() {
                                          vatPercentageEditingController.text = ((vatAmount * 100) / cartProviderData.getTotalAmount()).toStringAsFixed(2);
                                          discountPercentageEditingController.text = ((discountAmount * 100) / cartProviderData.getTotalAmount()).toStringAsFixed(2);
                                        });
                                      },
                                      icon: const Icon(IconlyLight.edit_square),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                ///_____Total_______________________________________________________
                Container(
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kMainColor.withOpacity(.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang.S.of(context).subTotal,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              cartProviderData.getTotalAmount().toStringAsFixed(2),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      ///________Vat__________________________________________
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang.S.of(context).vat,
                              // 'VAT',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: context.width() / 4,
                                  height: 40.0,
                                  child: Center(
                                    child: AppTextField(
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                      controller: vatPercentageEditingController,
                                      onChanged: (value) {
                                        if (value == '') {
                                          setState(() {
                                            vatAmountEditingController.text = 0.toString();
                                            vatAmount = 0;
                                          });
                                        } else {
                                          setState(() {
                                            vatAmount = (value.toDouble() / 100) * cartProviderData.getTotalAmount().toDouble();
                                            vatAmountEditingController.text = vatAmount.toStringAsFixed(2);
                                          });
                                        }
                                      },
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(right: 6.0),
                                        hintText: '0',
                                        border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                        enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                        disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                        focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                        prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                        prefixIcon: Container(
                                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                          height: 40,
                                          decoration: const BoxDecoration(
                                              color: Color(0xFFff5f00), borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                          child: const Text(
                                            '%',
                                            style: TextStyle(fontSize: 18.0, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      textFieldType: TextFieldType.PHONE,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                SizedBox(
                                  width: context.width() / 4,
                                  height: 40.0,
                                  child: Center(
                                    child: AppTextField(
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                      controller: vatAmountEditingController,
                                      onChanged: (value) {
                                        if (value == '') {
                                          setState(() {
                                            vatAmount = 0;
                                            vatPercentageEditingController.clear();
                                          });
                                        } else {
                                          setState(() {
                                            vatAmount = double.parse(value);
                                            vatPercentageEditingController.text = ((vatAmount * 100) / cartProviderData.getTotalAmount()).toStringAsFixed(2);
                                          });
                                        }
                                      },
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(right: 6.0),
                                        hintText: '0',
                                        border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                        enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                        disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                        focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                        prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                        prefixIcon: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                              color: kMainColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                          child: Text(
                                            currency,
                                            style: const TextStyle(fontSize: 14.0, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      textFieldType: TextFieldType.PHONE,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      ///_______Discount__________________________________________
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang.S.of(context).discount,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: context.width() / 4,
                                  height: 40.0,
                                  child: Center(
                                    child: AppTextField(
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                      controller: discountPercentageEditingController,
                                      onChanged: (value) {
                                        if (value == '') {
                                          setState(() {
                                            discountAmountEditingController.text = 0.toString();
                                            discountAmount = 0;
                                          });
                                        } else {
                                          if (value.toDouble() > 100) {
                                            EasyLoading.showError(lang.S.of(context).enterAValidDiscount);
                                            setState(() {
                                              discountAmount = 0;
                                              discountAmountEditingController.clear();
                                              discountPercentageEditingController.clear();
                                            });
                                          } else {
                                            setState(() {
                                              discountAmount = (value.toDouble() / 100) * cartProviderData.getTotalAmount().toDouble();
                                              discountAmountEditingController.text = discountAmount.toStringAsFixed(2);
                                            });
                                          }
                                        }
                                      },
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(right: 6.0),
                                        hintText: '0',
                                        border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                        enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                        disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                        focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: Color(0xFFff5f00))),
                                        prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                        prefixIcon: Container(
                                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                          height: 40,
                                          decoration: const BoxDecoration(
                                              color: Color(0xFFff5f00), borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                          child: const Text(
                                            '%',
                                            style: TextStyle(fontSize: 18.0, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      textFieldType: TextFieldType.PHONE,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                SizedBox(
                                  width: context.width() / 4,
                                  height: 40.0,
                                  child: Center(
                                    child: AppTextField(
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                                      controller: discountAmountEditingController,
                                      onChanged: (value) {
                                        if (value == '') {
                                          setState(() {
                                            discountAmount = 0;
                                            discountPercentageEditingController.clear();
                                          });
                                        } else {
                                          if (value.toDouble() > cartProviderData.getTotalAmount()) {
                                            EasyLoading.showError(lang.S.of(context).enterAValidDiscount);
                                            setState(() {
                                              discountAmount = 0;
                                              discountAmountEditingController.clear();
                                              discountPercentageEditingController.clear();
                                            });
                                          } else {
                                            setState(() {
                                              discountAmount = double.parse(value);
                                              discountPercentageEditingController.text = ((discountAmount * 100) / cartProviderData.getTotalAmount()).toStringAsFixed(2);
                                            });
                                          }
                                        }
                                      },
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(right: 6.0),
                                        hintText: '0',
                                        border: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                        enabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                        disabledBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                        focusedBorder: const OutlineInputBorder(gapPadding: 0.0, borderSide: BorderSide(color: kMainColor)),
                                        prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                        prefixIcon: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                              color: kMainColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                          child: Text(
                                            currency,
                                            style: const TextStyle(fontSize: 14.0, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      textFieldType: TextFieldType.PHONE,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      ///______Total____________________________________________
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang.S.of(context).total,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              calculateSubtotal(total: cartProviderData.getTotalAmount()).toStringAsFixed(2),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      ///______Received_amount___________________________________________
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  activeColor: kMainColor,
                                  value: isFullReceved,
                                  onChanged: (value) {
                                    setState(() {
                                      isFullReceved = !isFullReceved;
                                      paidAmount = subTotal;
                                      paindAmountController.text = subTotal.toString();
                                    });
                                  },
                                ),
                                Text(
                                  lang.S.of(context).receivedAmount,
                                  //'Received Amount',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: context.width() / 4,
                              child: TextField(
                                controller: paindAmountController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value == '') {
                                    setState(() {
                                      paidAmount = 0;
                                    });
                                  } else {
                                    setState(() {
                                      paidAmount = double.parse(value);
                                    });
                                  }
                                },
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(hintText: '0'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang.S.of(context).returnAmount,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              calculateReturnAmount(total: subTotal).abs().toStringAsFixed(2),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang.S.of(context).dueAmount,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              calculateDueAmount(total: subTotal).toStringAsFixed(2),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                ///_____Payment_Type____________________________________________________
                Container(
                  decoration: const BoxDecoration(color: kWhite),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).paymentTypes,
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.wallet,
                              color: Colors.green,
                            )
                          ],
                        ),
                        DropdownButton(
                          value: paymentType,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: paymentsTypeList.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              paymentType = newValue.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                ///______Buttons_________________________________________________________
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () async {
                          const Home().launch(context, isNewTask: true);
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Text(
                              lang.S.of(context).cancel,
                              //'Cancel',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (cartProviderData.cartItemList.isNotEmpty) {
                              try {
                                EasyLoading.show(
                                    status: lang.S.of(context).loading,
                                    //'Loading...',
                                    dismissOnTap: false);
                                List<CartSaleProducts> selectedProductList = [];

                                for (var element in cartProviderData.cartItemList) {
                                  selectedProductList.add(

                                    CartSaleProducts(
                                      productId: element.uuid.toInt(),
                                      quantities: element.quantity,
                                      price: (num.tryParse(element.price.toString()) ?? 0),
                                      lossProfit: (element.quantity * (num.tryParse(element.price.toString()) ?? 0)) -
                                          (element.quantity * (num.tryParse(element.productPurchasePrice.toString()) ?? 0)),
                                    ),
                                  );
                                }

                                SaleRepo repo = SaleRepo();
                                SalesTransaction? saleData = await repo.createSale(
                                  ref: consumerRef,
                                  context: context,
                                  totalAmount: subTotal,
                                  purchaseDate: selectedDate.toString(),
                                  products: selectedProductList,
                                  paymentType: paymentType ?? 'Cash',
                                  partyId: selectedCustomer?.id,
                                  customerPhone: widget.customerModel == null ? phoneContoller.text : null,
                                  vatAmount: vatAmount,
                                  vatPercent: vatPercentageEditingController.text.toInt(),
                                  isPaid: dueAmount <= 0 ? true : false,
                                  dueAmount: dueAmount <= 0 ? 0 : dueAmount,
                                  discountAmount: discountAmount,
                                  paidAmount: paidAmount,
                                );
                                if (saleData != null) {
                                  cartProviderData.clearCart();
                                  SalesInvoiceDetails(
                                    businessInfo: personalData.value!,
                                    saleTransaction: saleData,
                                    fromSale: true,
                                  ).launch(context);
                                }
                              } catch (e) {
                                EasyLoading.dismiss();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            } else {
                              EasyLoading.showError(
                                lang.S.of(context).addProductFirst,
                                //'Add product first'
                              );
                            }
                          },
                          child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: kMainColor,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Text(
                                lang.S.of(context).save,
                                //'Save',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }, error: (e, stack) {
        return Center(
          child: Text(e.toString()),
        );
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      });
    });
  }
}
