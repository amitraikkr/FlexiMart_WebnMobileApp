import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Const/api_config.dart';
import '../../Provider/print_thermal_invoice_provider.dart';
import '../../constant.dart' as mainConstant;
import '../../currency.dart';
import '../../invoice_constant.dart';
import '../../model/business_info_model.dart';
import '../../model/print_transaction_model.dart';
import '../Due Calculation/Model/due_collection_model.dart';

class DueInvoiceDetails extends StatefulWidget {
  const DueInvoiceDetails({Key? key, required this.dueCollection, required this.personalInformationModel, this.isFromDue}) : super(key: key);

  final DueCollection dueCollection;
  final BusinessInformation personalInformationModel;
  final bool? isFromDue;

  @override
  State<DueInvoiceDetails> createState() => _DueInvoiceDetailsState();
}

class _DueInvoiceDetailsState extends State<DueInvoiceDetails> {
  @override
  Widget build(BuildContext context) {
    final _lang = lang.S.of(context);
    return Consumer(builder: (context, ref, __) {
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
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            mainConstant.logo,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      '${widget.personalInformationModel.companyName}',
                      style: _theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        text: '${_lang.mobile} : ',
                        children: [
                          TextSpan(
                            text: '${widget.personalInformationModel.phoneNumber}',
                          )
                        ],
                      ),
                    ),
                    trailing: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 110,
                      // padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xff019934),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                      child: Text(
                        _lang.moneyReceipt,
                        style: _theme.textTheme.titleSmall?.copyWith(
                          color: white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 33.0),
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
                                    text: widget.dueCollection.party?.name ?? '',
                                  )
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: '${_lang.mobile} : ',
                                children: [
                                  TextSpan(
                                    text: widget.dueCollection.party?.phone ?? '',
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
                                text: '${_lang.receipt} : ',
                                children: [
                                  TextSpan(
                                    text: '#${widget.dueCollection.invoiceNumber}',
                                  )
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: '${lang.S.of(context).date} : ',
                                children: [
                                  TextSpan(
                                    text: DateFormat.yMMMd().format(DateTime.parse(widget.dueCollection.paymentDate ?? '')),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: '${_lang.collectedBy} : ',
                                children: [
                                  TextSpan(
                                    text: widget.dueCollection.user?.name ?? '',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //product table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      defaultColumnWidth: const FixedColumnWidth(150),
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
                        TableRow(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffFF902A), // Red background
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _lang.sl,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              color: const Color(0xffFF902A), // Red background
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _lang.totalDue,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              color: const Color(0xff019934), // Black background
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _lang.paymentsAmount,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              color: const Color(0xff019934), // Black background
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _lang.remainingDue,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('1', textAlign: TextAlign.left),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.dueCollection.totalDue}",
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.dueCollection.totalDue!.toDouble() - widget.dueCollection.dueAmountAfterPay!}",
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.dueCollection.dueAmountAfterPay}",
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${_lang.receivedAmount} : $currency ${widget.dueCollection.totalDue!.toDouble() - widget.dueCollection.dueAmountAfterPay!.toDouble()}",
                      style: _theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${_lang.dueAmount} : $currency ${widget.dueCollection.dueAmountAfterPay}",
                      style: _theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      lang.S.of(context).thankYouForYourDuePayment,
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
                    if (widget.isFromDue ?? false) {
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
                        // 'Cancel',
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
                    PrintDueTransactionModel model = PrintDueTransactionModel(dueTransactionModel: widget.dueCollection, personalInformationModel: widget.personalInformationModel);
                    mainConstant.connected
                        ? printerData.printDueTicket(
                            printDueTransactionModel: model,
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
