import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/print_thermal_invoice_provider.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import '../../constant.dart' as mainConstant;
import '../../currency.dart';
import '../../invoice_constant.dart';
import '../../model/business_info_model.dart';
import '../../model/print_transaction_model.dart';
import '../Purchase/Model/purchase_transaction_model.dart';

class PurchaseInvoiceDetails extends StatefulWidget {
  const PurchaseInvoiceDetails({Key? key, required this.transitionModel, required this.businessInfo, this.isFromPurchase}) : super(key: key);

  final PurchaseTransaction transitionModel;
  final BusinessInformation businessInfo;
  final bool? isFromPurchase;

  @override
  State<PurchaseInvoiceDetails> createState() => _PurchaseInvoiceDetailsState();
}

class _PurchaseInvoiceDetailsState extends State<PurchaseInvoiceDetails> {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _lang = lang.S.of(context);
    return Consumer(builder: (context, ref, __) {
      final printerData = ref.watch(thermalPrinterProvider);
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //header
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      height: 50,
                      width: 52,
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        image: DecorationImage(
                          // fit: BoxFit.cover,
                          image: AssetImage(
                            mainConstant.logo,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      '${widget.businessInfo.companyName}',
                      style: _theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        text: '${lang.S.of(context).mobile} ',
                        children: [
                          TextSpan(
                            text: widget.businessInfo.phoneNumber.toString(),
                          )
                        ],
                      ),
                    ),
                    trailing: Container(
                      alignment: Alignment.center,
                      // height: 52,
                      width: 110,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xff019934),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                      child: Text(
                        lang.S.of(context).invoice,
                        style: _theme.textTheme.titleLarge?.copyWith(
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 33),
                  //header data
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: '${lang.S.of(context).billTO} : ',
                                children: [
                                  TextSpan(
                                    text: widget.transitionModel.party?.name ?? '',
                                  )
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: '${_lang.mobile} : ',
                                children: [
                                  TextSpan(
                                    text: widget.transitionModel.party?.phone ?? '',
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: '${_lang.purchaseBy} ',
                                children: [
                                  TextSpan(
                                    text: widget.transitionModel.user?.name ?? '',
                                  )
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: '${_lang.inv} : ',
                                children: [
                                  TextSpan(
                                    text: '#${widget.transitionModel.invoiceNumber}',
                                  )
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: '${lang.S.of(context).date} : ',
                                children: [
                                  TextSpan(
                                    text: DateFormat.yMMMd().format(DateTime.parse(widget.transitionModel.purchaseDate ?? '')),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  //product table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      defaultColumnWidth: const FixedColumnWidth(100),
                      border: const TableBorder(
                        verticalInside: BorderSide(
                          color: Color(0xffD9D9D9),
                        ),
                        left: BorderSide(
                          color: Color(0xffD9D9D9),
                        ),
                        right: BorderSide(
                          color: Color(0xffD9D9D9),
                        ),
                        bottom: BorderSide(
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      children: [
                        // Table header row
                        TableRow(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffFF902A),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _lang.sl,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              color: const Color(0xffFF902A),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _lang.item,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              color: const Color(0xff019934),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _lang.quantity,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              color: const Color(0xff019934),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                lang.S.of(context).unitPrices,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              color: const Color(0xff019934),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _lang.totalPrice,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        // Data rows from widget.transitionModel.details
                        ...widget.transitionModel.details!.asMap().entries.map((entry) {
                          final i = entry.key; // This is the index
                          return TableRow(
                            decoration: i % 2 == 0
                                ? const BoxDecoration(
                                    color: Colors.white,
                                  )
                                : BoxDecoration(
                                    color: const Color(0xffFF902A).withValues(alpha: 0.07),
                                  ),
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (i + 1).toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.transitionModel.details![i].product?.productName.toString() ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.transitionModel.details![i].quantities.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '$currency ${widget.transitionModel.details![i].productPurchasePrice}',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '$currency ${(widget.transitionModel.details![i].productPurchasePrice ?? 0) * (widget.transitionModel.details![i].quantities ?? 0)}',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  //subtotal,discount,total payable,due,paid
                  //sub total
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        text: '${lang.S.of(context).subTotal} : ',
                        children: [
                          TextSpan(
                            text: '$currency ${widget.transitionModel.totalAmount!.toDouble() + widget.transitionModel.discountAmount!.toDouble()}',
                          ),
                        ],
                      ),
                      style: _theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  //discount
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        text: '${lang.S.of(context).discount} : ',
                        children: [
                          TextSpan(
                            text: '$currency ${widget.transitionModel.discountAmount}',
                          ),
                        ],
                      ),
                      style: _theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  //total payable
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //paid by
                      Text(
                        "${_lang.paidVia}: ${widget.transitionModel.paymentType}",
                      ),
                      //Total payable
                      Container(
                        padding: EdgeInsets.all(3),
                        color: Color(0xffFF902A),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text.rich(
                            TextSpan(
                              text: '${lang.S.of(context).totalPayable} : ',
                              children: [
                                TextSpan(
                                  text: '$currency ${widget.transitionModel.totalAmount}',
                                ),
                              ],
                            ),
                            style: _theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  //paid
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        text: '${lang.S.of(context).paid} : ',
                        children: [
                          TextSpan(
                            text: '$currency ${widget.transitionModel.totalAmount! - widget.transitionModel.dueAmount!.toDouble()}',
                          ),
                        ],
                      ),
                      style: _theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  //due
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        text: '${lang.S.of(context).due} : ',
                        children: [
                          TextSpan(
                            text: '$currency ${widget.transitionModel.dueAmount}',
                          ),
                        ],
                      ),
                      style: _theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Center(
                    child: Text(
                      lang.S.of(context).thakYouForYourPurchase,
                      maxLines: 1,
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    if (widget.isFromPurchase ?? false) {
                      int count = 0;
                      Navigator.popUntil(context, (route) {
                        return count++ == 2;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    height: 60,
                    width: context.width() / 3,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        lang.S.of(context).cancel,

                        ///'Cancel',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () async {
                    await printerData.getBluetooth();
                    PrintPurchaseTransactionModel model =
                        PrintPurchaseTransactionModel(purchaseTransitionModel: widget.transitionModel, personalInformationModel: widget.businessInfo);
                    mainConstant.connected
                        ? printerData.printPurchaseThermalInvoice(
                            printTransactionModel: model,
                            productList: model.purchaseTransitionModel!.details,
                          )
                        // ignore: use_build_context_synchronously
                        : printerData.listOfBluDialog(context: context);
                  },
                  child: Container(
                    height: 60,
                    width: context.width() / 3,
                    decoration: const BoxDecoration(
                      color: mainConstant.kMainColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        lang.S.of(context).print,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
