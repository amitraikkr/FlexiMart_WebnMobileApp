// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/model/sale_transaction_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../Screens/Due Calculation/Model/due_collection_model.dart';
import '../Screens/PDF/pdf.dart';
import '../Screens/Purchase/Model/purchase_transaction_model.dart';
import '../model/business_info_model.dart';

class GeneratePdf {
  //load asset image
  Future<Uint8List?> loadAssetImage(String path)async{
    try{
      final ByteData data=await rootBundle.load(path);
      return data.buffer.asUint8List();
    }
    catch(e){
      print('Error loading local image :$e');
      return null;
    }
  }

  Future<void> generatePurchaseDocument(PurchaseTransaction transactions, BusinessInformation personalInformation, BuildContext context) async {
    final pw.Document doc = pw.Document();
    final imageData=await loadAssetImage(logo);
    EasyLoading.show(status: 'Generating PDF');
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        //pdf header
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20.0),
            child: pw.Column(
              children: [
                pw.Row(
                  children: [
                    // image section
                    pw.Container(
                      width:64.04,
                      height:62.51,
                      decoration: pw.BoxDecoration(
                        image: pw.DecorationImage(image: pw.MemoryImage(imageData!),),
                      ),
                    ),
                    pw.SizedBox(width: 16),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          personalInformation.companyName ?? '',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.black,
                            fontSize: 25.0,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Mobile: ${personalInformation.phoneNumber ?? ''}',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                    pw.Spacer(),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      height: 52,
                      width: 231,
                      decoration: const pw.BoxDecoration(
                        color: PdfColor.fromInt(0xff019934),
                        borderRadius: pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(25),
                          bottomLeft: pw.Radius.circular(25),
                        ),
                      ),
                      child: pw.Text(
                        'INVOICE',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 35.0),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Bill To',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.party?.name ?? '',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Mobile',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.party?.phone ?? '',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Purchase By',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.user?.name ?? '',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Invoice Number',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          '#${transactions.invoiceNumber}',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Date',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          DateTimeFormat.format(DateTime.parse(transactions.purchaseDate ?? ''), format: 'D, M j'),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        //pdf footer
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Customer Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Authorized Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              color: const PdfColor.fromInt(0xffFF902A),
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Center(child: pw.Text('Powered By $companyName', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
            ),
          ]);
        },
        //pdf build body
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                pw.Table(
                    columnWidths: <int, pw.TableColumnWidth>{
                      0: const pw.FlexColumnWidth(1),
                      1: const pw.FlexColumnWidth(6),
                      2: const pw.FlexColumnWidth(2),
                      3: const pw.FlexColumnWidth(2),
                      4: const pw.FlexColumnWidth(2),
                    },
                    border: const pw.TableBorder(
                      verticalInside: pw.BorderSide(
                        color: PdfColor.fromInt(0xffD9D9D9),
                      ),
                      left: pw.BorderSide(
                        color: PdfColor.fromInt(0xffD9D9D9),
                      ),
                      right: pw.BorderSide(
                        color: PdfColor.fromInt(0xffD9D9D9),
                      ),
                      bottom: pw.BorderSide(
                        color: PdfColor.fromInt(0xffD9D9D9),
                      ),
                    ),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            decoration: const pw.BoxDecoration(
                              color: PdfColor.fromInt(0xffFF902A),
                            ), // Red background
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'SL',
                              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Container(
                            color: const PdfColor.fromInt(0xffFF902A), // Red background
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Item',
                              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.left,
                            ),
                          ),
                          pw.Container(
                            color: const PdfColor.fromInt(0xff019934), // Black background
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Quantity',
                              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Container(
                            color: const PdfColor.fromInt(0xff019934), // Black background
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Unit Price',
                              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Container(
                            color: const PdfColor.fromInt(0xff019934), // Black background
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Total Price',
                              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < transactions.details!.length; i++)
                        pw.TableRow(
                          decoration: i % 2 == 0
                              ? const pw.BoxDecoration(
                            color: PdfColors.white,
                          ) // Odd row color
                              : const pw.BoxDecoration(
                            color: PdfColors.orange50,
                          ),
                          children: [
                            //serial number
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                '${i + 1}',
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            //Item Name
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                (transactions.details!.elementAt(i).product?.productName).toString(),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                            //Quantity
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                (transactions.details!.elementAt(i).quantities).toString(),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            //unit price
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                (transactions.details!.elementAt(i).productPurchasePrice ?? 0).toString(),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            //Total price
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                (((transactions.details!.elementAt(i).productPurchasePrice ?? 0) * (transactions.details!.elementAt(i).quantities ?? 0)).toString()),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                    ]),
                pw.SizedBox(height: 5),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                    pw.SizedBox(height: 10.0),
                    pw.Text(
                      "Subtotal: ${transactions.totalAmount! + transactions.discountAmount!}",
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5.0),
                    pw.Text(
                      "Vat: 0.00",
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5.0),
                    pw.Text(
                      "Tax: 0.00",
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5.0),
                    pw.Text(
                      "Discount: ${transactions.discountAmount}",
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10.0),
                    pw.Container(
                      color: PdfColor.fromInt(0xffFF902A),
                      padding: const pw.EdgeInsets.all(5.0),
                      child: pw.Text("Total Amount: ${transactions.totalAmount}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.SizedBox(height: 5.0),
                    pw.Container(
                      width: 540,
                      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                        pw.Text(
                          "Paid Via: ${transactions.paymentType}",
                          style: const pw.TextStyle(
                            color: PdfColors.black,
                          ),
                        ),
                        pw.Text(
                          "Paid Amount: ${transactions.totalAmount!.toDouble() - transactions.dueAmount!.toDouble()}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                    pw.SizedBox(height: 5.0),
                    pw.Text(
                      "Due: ${transactions.dueAmount}",
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ]),
                ]),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
    ));
    if (Platform.isIOS) {
      EasyLoading.show(status: 'Generating PDF');
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess('Done');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );

        // OpenFile.open("${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
    }
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (true) {
        EasyLoading.show(status: 'Generating PDF');
        const downloadsFolderPath = '/storage/emulated/0/Download/';
        Directory dir = Directory(downloadsFolderPath);
        final file = File('${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

        final byteData = await doc.save();
        try {
          await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          EasyLoading.showSuccess('Done');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerPage(path: '${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
            ),
          );
          // OpenFile.open("/storage/emulated/0/download/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
        } on FileSystemException catch (err) {
          EasyLoading.showError(err.message);
          // handle error
        }
      }
    }

    // if (Platform.isAndroid) {
    //   var status = await Permission.storage.status;
    //   if (status != PermissionStatus.granted) {
    //     status = await Permission.storage.request();
    //   }
    //   if (status.isGranted) {
    //     // const downloadsFolderPath = '/storage/emulated/0/Download/';
    //     // Directory dir = Directory(downloadsFolderPath);
    //     // final file = File('${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');
    //     // await file.writeAsBytes(await doc.save());
    //     // EasyLoading.showSuccess('Successful');
    //     // OpenFile.open("/storage/emulated/0/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
    //
    //     final file = File("/storage/emulated/0/download/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
    //     await file.writeAsBytes(await doc.save());
    //     EasyLoading.showSuccess('Successful');
    //     OpenFile.open("/storage/emulated/0/download/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
    //   } else {
    //     EasyLoading.showError('Sorry, Permission not granted');
    //   }
    // }

    // final byteData = await rootBundle.load('assets/$fileName');
    // try {
    //   await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    // } on FileSystemException catch (err) {
    //   // handle error
    // }
    // var status = await Permission.storage.request();
    // if (status.isGranted) {
    //   final file = File("/storage/emulated/0/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
    //   await file.writeAsBytes(await doc.save());
    //   EasyLoading.showSuccess('Successful');
    //   OpenFile.open("/storage/emulated/0/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
    // } else if (status.isDenied) {
    //   EasyLoading.dismiss();
    //   await Permission.storage.request();
    // } else if (status.isPermanentlyDenied) {
    //   EasyLoading.showError('Grant Access');
    // }
  }

  Future<void> generateSaleDocument(SalesTransaction transactions, BusinessInformation personalInformation, BuildContext context) async {
    final pw.Document doc = pw.Document();
    final imageData= await loadAssetImage(logo);
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20.0),
            child: pw.Column(
              children: [
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Row(children: [
                    // image section
                      pw.Container(
                        width:64.04,
                        height:62.51,
                        decoration: pw.BoxDecoration(
                          image: pw.DecorationImage(
                            fit: pw.BoxFit.cover,
                            image:
                              pw.MemoryImage(imageData!),
                          ),
                        ),
                      ),
                    pw.SizedBox(width: 16.0),
                    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(
                        personalInformation.companyName ?? '',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 24.0, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'Mobile: ${personalInformation.phoneNumber ?? ''}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ]),
                  ]),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    height: 52,
                    width: 231,
                    decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xff019934),
                      borderRadius: pw.BorderRadius.only(
                        topLeft: pw.Radius.circular(25),
                        bottomLeft: pw.Radius.circular(25),
                      ),
                    ),
                    child: pw.Text(
                      'INVOICE',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ]),
                pw.SizedBox(height: 35.0),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Bill To',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.party?.name ?? '',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Mobile',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.party?.phone ?? (transactions.meta?.customerPhone ?? 'Guest'),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Sells By',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.user?.name ?? '',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Invoice Number',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          '#${transactions.invoiceNumber}',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Date',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          DateTimeFormat.format(DateTime.parse(transactions.saleDate ?? ''), format: 'D, M j'),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Customer Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Authorized Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              color: const PdfColor.fromInt(0xffFF902A),
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Center(child: pw.Text('Powered By $companyName', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
            ),
          ]);
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                pw.Table(
                  border: const pw.TableBorder(
                    verticalInside: pw.BorderSide(color: PdfColor.fromInt(0xffD9D9D9)),
                    left: pw.BorderSide(color: PdfColor.fromInt(0xffD9D9D9)),
                    right: pw.BorderSide(color: PdfColor.fromInt(0xffD9D9D9)),
                    bottom: pw.BorderSide(color: PdfColor.fromInt(0xffD9D9D9)),
                  ),
                  columnWidths: <int, pw.TableColumnWidth>{
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(6),
                    2: const pw.FlexColumnWidth(2),
                    3: const pw.FlexColumnWidth(2),
                    4: const pw.FlexColumnWidth(2),
                  },
                  children: [
                    //pdf header
                    pw.TableRow(
                      children: [
                        pw.Container(
                          decoration: const pw.BoxDecoration(
                            color: PdfColor.fromInt(0xffFF902A),
                          ), // Red background
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'SL',
                            style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          color: const PdfColor.fromInt(0xffFF902A), // Red background
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Item',
                            style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Container(
                          color: const PdfColor.fromInt(0xff019934), // Black background
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Quantity',
                            style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          color: const PdfColor.fromInt(0xff019934), // Black background
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Unit Price',
                            style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                        pw.Container(
                          color: const PdfColor.fromInt(0xff019934), // Black background
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Total Price',
                            style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    for (int i = 0; i < transactions.details!.length; i++)
                      pw.TableRow(
                        decoration: i % 2 == 0
                            ? const pw.BoxDecoration(
                          color: PdfColors.white,
                        ) // Odd row color
                            :  pw.BoxDecoration(
                          color: PdfColors.orange50,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('${i + 1}', textAlign: pw.TextAlign.center),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(transactions.details!.elementAt(i).product?.productName.toString() ?? '', textAlign: pw.TextAlign.left),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(transactions.details!.elementAt(i).quantities.toString(),
                                textAlign: pw.TextAlign.center),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(transactions.details!.elementAt(i).price.toString(), textAlign: pw.TextAlign.right),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                                ((transactions.details!.elementAt(i).price ?? 0) * (transactions.details!.elementAt(i).quantities ?? 0)).toStringAsFixed(2),
                                textAlign: pw.TextAlign.right),
                          ),
                        ],
                      ),
                  ],
                ),

                // Subtotal, VAT, Discount, and Total Amount
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.SizedBox(height: 10.0),
                        pw.Text(
                          "Subtotal: ${transactions.totalAmount! + transactions.discountAmount!}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5.0),
                        pw.Text(
                          "VAT: ${transactions.vatAmount ?? 0.00}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5.0),
                        pw.Text(
                          "Discount: ${transactions.discountAmount}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5.0),
                        pw.Container(
                          color: PdfColor.fromInt(0xffFF902A),
                          padding: const pw.EdgeInsets.all(5.0),
                          child: pw.Text("Total Amount: ${transactions.totalAmount}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.SizedBox(height: 5.0),
                        pw.Container(
                          width: 540,
                          child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text(
                              "Paid Via: ${transactions.paymentType}",
                              style: const pw.TextStyle(
                                color: PdfColors.black,
                              ),
                            ),
                            pw.Text(
                              "Paid Amount: ${transactions.totalAmount!.toDouble() - transactions.dueAmount!.toDouble()}",
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ]),
                        ),
                        pw.SizedBox(height: 5.0),
                        pw.Text(
                          "Due: ${transactions.dueAmount}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 10.0),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],

      ),
    );
    if (Platform.isIOS) {
      EasyLoading.show(status: 'Generating PDF');
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess('Done');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );
        // OpenFile.open("${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
    }

    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (true) {
        EasyLoading.show(status: 'Generating PDF');
        const downloadsFolderPath = '/storage/emulated/0/Download/';
        Directory dir = Directory(downloadsFolderPath);
        final file = File('${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

        final byteData = await doc.save();
        try {
          await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          EasyLoading.showSuccess('Created and Saved');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerPage(path: '${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
            ),
          );
          // OpenFile.open("/storage/emulated/0/download/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
        } on FileSystemException catch (err) {
          EasyLoading.showError(err.message);
          // handle error
        }
      }
    }
  }

  Future<void> generateDueDocument(DueCollection transactions, BusinessInformation personalInformation, BuildContext context) async {
    final pw.Document doc = pw.Document();
    final imageData=await loadAssetImage(logo);
    EasyLoading.show(status: 'Generating PDF');
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        margin: pw.EdgeInsets.zero,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        //pdf header
        header: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20.0),
            child: pw.Column(
              children: [
                pw.Row(children: [
                  // image section
                  pw.Container(
                    width:64.04,
                    height:62.51,
                    decoration: pw.BoxDecoration(
                      image: pw.DecorationImage(
                        fit: pw.BoxFit.cover,
                        image:
                        pw.MemoryImage(imageData!),
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 10.0),
                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(
                      personalInformation.companyName ?? '',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 24.0, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Mobile: ${personalInformation.phoneNumber ?? ''}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    ),
                  ]),
                  pw.Spacer(),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    height: 52,
                    width: 247,
                    decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xff019934),
                      borderRadius: pw.BorderRadius.only(
                        topLeft: pw.Radius.circular(25),
                        bottomLeft: pw.Radius.circular(25),
                      ),
                    ),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 12, right: 19, top: 8, bottom: 8),
                      child: pw.Text(
                        'Money Receipt',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ]),
                pw.SizedBox(height: 35.0),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Bill To',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.party?.name ?? '',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Phone',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.party?.phone ?? '',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                  pw.Column(children: [
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Receipt',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          '${transactions.invoiceNumber}',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Date',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          DateTimeFormat.format(DateTime.parse(transactions.paymentDate ?? ''), format: 'D, M j'),
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                    pw.Row(children: [
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          'Collected By',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 10.0,
                        child: pw.Text(
                          ':',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                      pw.SizedBox(
                        width: 100.0,
                        child: pw.Text(
                          transactions.user?.name ?? '',
                          style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ],
            ),
          );
        },
        //pdf footer
        footer: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Customer Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Column(children: [
                    pw.Container(
                      width: 120.0,
                      height: 2.0,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 4.0),
                    pw.Text(
                      'Authorized Signature',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                    )
                  ]),
                ),
              ]),
            ),
            pw.Container(
              width: double.infinity,
              color: const PdfColor.fromInt(0xffFF902A),
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Center(child: pw.Text('Powered By Acnoo', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
            ),
          ]);
        },
        //pdf body
        build: (pw.Context context) => <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: pw.Column(
              children: [
                pw.Table(
                    columnWidths: <int, pw.TableColumnWidth>{
                      0: const pw.FlexColumnWidth(1),
                      1: const pw.FlexColumnWidth(3),
                      2: const pw.FlexColumnWidth(3),
                      3: const pw.FlexColumnWidth(3),
                    },
                    border: const pw.TableBorder(
                      verticalInside: pw.BorderSide(color: PdfColor.fromInt(0xffD9D9D9)),
                      left: pw.BorderSide(color: PdfColor.fromInt(0xffD9D9D9)),
                      right: pw.BorderSide(color: PdfColor.fromInt(0xffD9D9D9)),
                      bottom: pw.BorderSide(color: PdfColor.fromInt(0xffD9D9D9)),
                    ),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            decoration: const pw.BoxDecoration(
                              color: PdfColor.fromInt(0xffFF902A),
                            ), // Red background
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'SL',
                              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.left,
                            ),
                          ),
                          pw.Container(
                            color: const PdfColor.fromInt(0xffFF902A), // Red background
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Total Due',
                              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.left,
                            ),
                          ),
                          pw.Container(
                            color: const PdfColor.fromInt(0xff019934), // Black background
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Payment Amount',
                              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.left,
                            ),
                          ),
                          pw.Container(
                            color: const PdfColor.fromInt(0xff019934), // Black background
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Remaining Due',
                              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('1', textAlign: pw.TextAlign.left),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text("${transactions.totalDue}", textAlign: pw.TextAlign.left),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text("${transactions.totalDue!.toDouble() - transactions.dueAmountAfterPay!.toDouble()}", textAlign: pw.TextAlign.left),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text("${transactions.dueAmountAfterPay}", textAlign: pw.TextAlign.left),
                          ),
                        ],
                      ),
                    ]),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.SizedBox(height: 10.0),
                        pw.Container(
                          width: 570,
                          child: pw.Row(
                            children: [
                              pw.Text(
                                "Paid By: ${transactions.paymentType}",
                                style: const pw.TextStyle(
                                  color: PdfColors.black,
                                ),
                              ),
                              pw.Spacer(),
                              pw.Text(
                                "Payable Amount: ${transactions.totalDue}",
                                style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 5.0),
                        // pw.Text(
                        //   "Discount: ${0.0}",
                        //   style: pw.TextStyle(
                        //     color: PdfColors.black,
                        //     fontWeight: pw.FontWeight.bold,
                        //   ),
                        // ),
                        // pw.SizedBox(height: 5.0),
                        // pw.Container(
                        //   color: PdfColors.blueAccent,
                        //   padding: const pw.EdgeInsets.all(5.0),
                        //   child: pw.Text("Total Due: ${transactions.totalDue}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                        // ),
                        pw.SizedBox(height: 5.0),
                        pw.Text(
                          "Received Amount : ${transactions.totalDue!.toDouble() - transactions.dueAmountAfterPay!.toDouble()}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5.0),
                        pw.Text(
                          "Due Amount : ${transactions.dueAmountAfterPay}",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 10.0),
                      ],
                    ),
                  ],
                ),
                pw.Padding(padding: const pw.EdgeInsets.all(10)),
              ],
            ),
          ),
        ],
      ),
    );
    if (Platform.isIOS) {
      EasyLoading.show(status: 'Generating PDF');
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

      final byteData = await doc.save();
      try {
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        EasyLoading.showSuccess('Done');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(path: '${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
          ),
        );
        // OpenFile.open("${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
      } on FileSystemException catch (err) {
        EasyLoading.showError(err.message);
        // handle error
      }
    }
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (true) {
        EasyLoading.show(status: 'Generating PDF');
        const downloadsFolderPath = '/storage/emulated/0/Download/';
        Directory dir = Directory(downloadsFolderPath);
        final file = File('${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');

        final byteData = await doc.save();
        try {
          await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          EasyLoading.showSuccess('Done');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerPage(path: '${dir.path}/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
            ),
          );
          // OpenFile.open("/storage/emulated/0/download/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
        } on FileSystemException catch (err) {
          EasyLoading.showError(err.message);
          // handle error
        }
      }
    }
    // var status = await Permission.storage.request();
    // if (status.isGranted) {
    //   final file = File("/storage/emulated/0/download/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
    //   await file.writeAsBytes(await doc.save());
    //   EasyLoading.showSuccess('Successful');
    //   OpenFile.open("/storage/emulated/0/download/${'Gracery Shop-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
    // } else if (status.isDenied) {
    //   EasyLoading.dismiss();
    //   await Permission.storage.request();
    // } else if (status.isPermanentlyDenied) {
    //   EasyLoading.showError('Grant Access');
    // }
  }
} // import 'dart:io';
