import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import '../../Provider/print_thermal_invoice_provider.dart';
// ignore: library_prefixes
import '../../constant.dart' as mainConstant;
import '../../currency.dart';
import '../../invoice_constant.dart';
import '../../model/business_info_model.dart';
import '../../model/print_transaction_model.dart';
import '../../model/sale_transaction_model.dart';

class SalesInvoiceDetails extends StatefulWidget {
  const SalesInvoiceDetails({Key? key, required this.saleTransaction, required this.businessInfo, this.fromSale}) : super(key: key);

  final SalesTransaction saleTransaction;
  final BusinessInformation businessInfo;
  final bool? fromSale;

  @override
  State<SalesInvoiceDetails> createState() => _SalesInvoiceDetailsState();
}

class _SalesInvoiceDetailsState extends State<SalesInvoiceDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final _lang = lang.S.of(context);
      final _theme = Theme.of(context);
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
                                    text: widget.saleTransaction.party?.name ?? '',
                                  )
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: '${lang.S.of(context).mobile} ',
                                children: [
                                  TextSpan(
                                    text: widget.saleTransaction.party?.phone ?? (widget.saleTransaction.meta?.customerPhone ?? lang.S.of(context).guest),
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
                                text: '${lang.S.of(context).salesBy} ',
                                children: [
                                  TextSpan(
                                    text: widget.saleTransaction.user?.name ?? '',
                                  )
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: '${lang.S.of(context).inv} : ',
                                children: [
                                  TextSpan(
                                    text: '#${widget.saleTransaction.invoiceNumber}',
                                  )
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: '${lang.S.of(context).date} : ',
                                children: [
                                  TextSpan(
                                    text: DateFormat.yMMMd().format(DateTime.parse(widget.saleTransaction.saleDate ?? DateTime.now().toString())),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  //Product table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      defaultColumnWidth: const FixedColumnWidth(100), // Set a default fixed width for all columns
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
                                lang.S.of(context).quantity,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              color: const Color(0xff019934),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _lang.unitPirce,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              color: const Color(0xff019934),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                lang.S.of(context).totalPrice,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        // Data rows from ListView.builder
                        ...widget.saleTransaction.details!.asMap().entries.map(
                          (entry) {
                            final i = entry.key; // This is the index
                            return TableRow(
                              decoration: i % 2 == 0
                                  ? const BoxDecoration(
                                      color: Colors.white,
                                    ) // Odd row color
                                  : BoxDecoration(
                                      color: const Color(0xffFF902A).withValues(alpha: 0.07),
                                    ),
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${i + 1}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.saleTransaction.details![i].product?.productName.toString() ?? '',
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.saleTransaction.details![i].quantities.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '$currency ${widget.saleTransaction.details![i].price}',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '$currency ${(widget.saleTransaction.details![i].price ?? 0) * (widget.saleTransaction.details![i].quantities ?? 0)}',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  //total subtotal,amount,calculation
                  SizedBox(height: 28),
                  //subtotal
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        text: '${lang.S.of(context).subTotal} : ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(
                            text: '$currency ${widget.saleTransaction.totalAmount!.toDouble() + widget.saleTransaction.discountAmount!.toDouble()}',
                          ),
                        ],
                      ),
                      style: _theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 5),
                  //total vat
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        text: '${lang.S.of(context).vat} : ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(
                            text: '$currency ${widget.saleTransaction.vatAmount}',
                          ),
                        ],
                      ),
                      style: _theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 5),
                  //Discount
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        text: '${lang.S.of(context).discount} : ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(
                            text: '$currency ${widget.saleTransaction.discountAmount}',
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
                      Text(
                        "${_lang.paidVia}: ${widget.saleTransaction.paymentType}",
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(color: Color(0xffFF902A)),
                          child: Text.rich(
                            TextSpan(
                              text: '${lang.S.of(context).totalPayable} : ',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              children: [
                                TextSpan(
                                  text: '$currency ${widget.saleTransaction.totalAmount}',
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
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(
                            text: '$currency ${widget.saleTransaction.totalAmount! - widget.saleTransaction.dueAmount!.toDouble()}',
                          ),
                        ],
                      ),
                      style: _theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  //due
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        text: '${lang.S.of(context).due} : ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(
                            text: '$currency ${widget.saleTransaction.dueAmount}',
                          ),
                        ],
                      ),
                      style: _theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
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
                  onTap: () async {
                    if (widget.fromSale ?? false) {
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
                        //'Cancel',
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
                    PrintTransactionModel model = PrintTransactionModel(transitionModel: widget.saleTransaction, personalInformationModel: widget.businessInfo);
                    mainConstant.connected
                        ? printerData.printSalesTicket(
                            printTransactionModel: model,
                            productList: model.transitionModel!.details,
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
