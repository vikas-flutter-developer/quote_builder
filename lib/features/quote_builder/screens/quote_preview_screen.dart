import 'dart:typed_data'; // Needed for PDF
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // To load assets
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quote_builder/features/quote_builder/bloc/quote_builder_bloc.dart';
import 'package:quote_builder/features/quote_builder/models/client_info.dart';
import 'package:quote_builder/features/quote_builder/models/line_item.dart';
// --- NEW IMPORT FOR SAVING ---
import 'package:file_saver/file_saver.dart';
// --- NEW IMPORT FOR SHARING ---
import 'package:share_plus/share_plus.dart';

// --- PDF IMPORTS ---
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// --- Correct import for number_to_words_english ---
import 'package:number_to_words_english/number_to_words_english.dart';

class QuotePreviewScreen extends StatelessWidget {
  const QuotePreviewScreen({super.key});

  double _parseDouble(String text) => double.tryParse(text) ?? 0;

  @override
  Widget build(BuildContext context) {
    final state = context.read<QuoteBuilderBloc>().state;
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'en_IN');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Invoice/Bill of Supply'),
      ),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20.0),
        minScale: 0.25,
        maxScale: 4.0,
        constrained: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 1000, // Kept your width
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Added to help layout
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const Divider(height: 32),
                    _buildSellerAndBillingInfo(context, state.clientInfo),
                    const SizedBox(height: 24),
                    _buildShippingAndOrderInfo(context, state.clientInfo),
                    const SizedBox(height: 24),
                    _buildItemsTable(context, state, currencyFormat),
                    _buildFooter(context, state, currencyFormat),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // --- UI CHANGE: Replaced with a Column of two buttons (Share and Download) ---
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'shareBtn', // Added heroTag to prevent tag conflict
            onPressed: () => _generateAndSharePdf(context),
            tooltip: 'Share PDF',
            child: const Icon(Icons.share),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'downloadBtn', // Added heroTag to prevent tag conflict
            onPressed: () => _generateAndSavePdf(context),
            tooltip: 'Download PDF',
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: 200,
      height: 150,
      child: Image.asset(
        'assets/images/meru_logo.png', // Your logo
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildSellerAndBillingInfo(BuildContext context, ClientInfo clientInfo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildSellerInfo(context),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: _buildBillingInfo(context, clientInfo),
        ),
      ],
    );
  }

  Widget _buildSellerInfo(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sold By:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Meru Technosoft', style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
        Text('https://merufintech.com', style: textStyle),
        Text('hello@merufintech.net', style: textStyle),
        Text('+91-7069083968', style: textStyle),
        const SizedBox(height: 16),
        Text('PAN No: AAJCC8517E ', style: textStyle),
        Text('GST Registration No: 27AAJCC8517E1ZL', style: textStyle),
      ],
    );
  }

  Widget _buildBillingInfo(BuildContext context, ClientInfo clientInfo) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Billing Address:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          clientInfo.name.isEmpty ? 'Client Name' : clientInfo.name,
          style: textStyle?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(clientInfo.address.isEmpty ? 'Client Address' : clientInfo.address, style: textStyle),
        const SizedBox(height: 16),
        Text('State/UT Code: 27', style: textStyle), // Example
      ],
    );
  }

  Widget _buildShippingAndOrderInfo(BuildContext context, ClientInfo clientInfo) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Number: ${clientInfo.reference.isEmpty ? 'N/A' : clientInfo.reference}', style: textStyle),
              Text('Order Date: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}', style: textStyle),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Shipping Address:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                clientInfo.name.isEmpty ? 'Client Name' : clientInfo.name,
                style: textStyle?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(clientInfo.address.isEmpty ? 'Client Address' : clientInfo.address, style: textStyle),
              const SizedBox(height: 16),
              Text('Place of supply: MAHARASHTRA', style: textStyle), // Example
              Text('Place of delivery: MAHARASHTRA', style: textStyle), // Example
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, QuoteBuilderState state, NumberFormat currencyFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        Text(
          'Amount in Words: ${_getAmountInWords(state.grandTotal)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),
        Text(
          'Whether tax is payable on reverse charge - No',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 48),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'For Meru Technosoft',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'assets/images/signature.png',
              height: 50,
              width: 150,
            ),
            const SizedBox(height: 8),
            Container(
              width: 200,
              height: 1,
              color: Colors.black,
            ),
            const SizedBox(height: 8),
            Text(
              'Authorized Signatory',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ],
    );
  }

  String _getAmountInWords(double total) {
    final int rupees = total.truncate();
    String rupeeWords = NumberToWordsEnglish.convert(rupees);
    rupeeWords = '${rupeeWords[0].toUpperCase()}${rupeeWords.substring(1)}';

    return '$rupeeWords only';
  }


  Widget _buildItemsTable(
      BuildContext context, QuoteBuilderState state, NumberFormat currencyFormat) {

    final headerStyle = const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    final cellStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    final totalCellStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    const double descriptionWidth = 381.0;

    final columns = [
      DataColumn(label: Center(child: Text('Sl. No', style: headerStyle))),
      DataColumn(label: SizedBox(
          width: descriptionWidth,
          child: Text('Description', style: headerStyle)
      )),
      DataColumn(label: Text('Unit Price', style: headerStyle), numeric: true),
      DataColumn(label: Text('Qty', style: headerStyle), numeric: true),
      DataColumn(label: Text('Net Amount', style: headerStyle), numeric: true),
      DataColumn(label: Text('Tax Rate', style: headerStyle), numeric: true),
      DataColumn(label: Text('Tax Type', style: headerStyle)),
      DataColumn(label: Text('Tax Amount', style: headerStyle), numeric: true),
      DataColumn(label: Center(child: Text('Total Amount', style: headerStyle)), numeric: true),
    ];

    int index = 0;
    double totalTaxableAmount = 0;
    double totalTaxAmount = 0;

    final rows = state.lineItems.map((item) {
      index++;
      final rate = _parseDouble(item.rateController.text);
      final qty = _parseDouble(item.quantityController.text);
      final discount = _parseDouble(item.discountController.text);
      final taxPercent = _parseDouble(item.taxController.text);

      final taxableAmount = (rate - discount) * qty;
      final taxAmount = taxableAmount * (taxPercent / 100);
      final totalAmount = taxableAmount + taxAmount;

      totalTaxableAmount += taxableAmount;
      totalTaxAmount += taxAmount;

      return DataRow(
        cells: [
          DataCell(Center(child: Text(index.toString(), style: cellStyle))), // Centered cell
          DataCell(
            SizedBox(
              width: descriptionWidth,
              child: Text(
                item.nameController.text,
                softWrap: true,
                style: cellStyle,
              ),
            ),
          ),
          DataCell(Text(currencyFormat.format(rate), style: cellStyle)),
          DataCell(Text(item.quantityController.text, style: cellStyle)),
          DataCell(Text(currencyFormat.format(taxableAmount), style: cellStyle)),
          DataCell(Text('${item.taxController.text}%', style: cellStyle)),
          DataCell(Text('CGST+SGST', style: cellStyle)),
          DataCell(Text(currencyFormat.format(taxAmount), style: cellStyle)),
          DataCell(Text(currencyFormat.format(totalAmount), style: cellStyle)),
        ],
      );
    }).toList();

    return Column(
      children: [
        DataTable(
          horizontalMargin: 0,
          columnSpacing: 10,
          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
          headingRowHeight: 40,
          dataRowMinHeight: 40.0,
          dataRowMaxHeight: 120.0,
          dataTextStyle: cellStyle,
          border: TableBorder.all(
            color: Colors.grey[400]!,
            width: 1,
          ),
          columns: columns,
          rows: rows,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.grey[400]!, width: 1),
              right: BorderSide(color: Colors.grey[400]!, width: 1),
              bottom: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
          ),
          child: Row(
            children: [
              const Expanded(flex: 2, child: SizedBox()), // Sl. No
              Expanded(
                  flex: 12,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                    child: Text('TOTAL:', style: totalCellStyle),
                  )
              ), // Description
              const Expanded(flex: 3, child: SizedBox()), // Unit Price
              const Expanded(flex: 2, child: SizedBox()), // Qty
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(currencyFormat.format(totalTaxableAmount), style: totalCellStyle, textAlign: TextAlign.right),
                  )
              ), // Net Amount
              const Expanded(flex: 2, child: SizedBox()), // Tax Rate
              const Expanded(flex: 2, child: SizedBox()), // Tax Type
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(currencyFormat.format(totalTaxAmount), style: totalCellStyle, textAlign: TextAlign.right),
                  )
              ), // Tax Amount
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(currencyFormat.format(state.grandTotal), style: totalCellStyle, textAlign: TextAlign.right),
                  )
              ), // Total Amount
            ],
          ),
        ),
      ],
    );
  }


  // --- PDF Generation Methods ---

  // --- 1. NEW HELPER FUNCTION: Generates PDF bytes once ---
  Future<Uint8List> _generatePdfBytes(BuildContext context) async {
    final state = context.read<QuoteBuilderBloc>().state;
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'en_IN');

    final logoImageBytes = await rootBundle.load('assets/images/meru_logo.png');
    final logoImage = pw.MemoryImage(logoImageBytes.buffer.asUint8List());

    final signatureImageBytes = await rootBundle.load('assets/images/signature.png');
    final signatureImage = pw.MemoryImage(signatureImageBytes.buffer.asUint8List());

    final regularFontData = await rootBundle.load('assets/fonts/Hind-Regular.ttf');
    final boldFontData = await rootBundle.load('assets/fonts/Hind-Bold.ttf');
    final ttfRegular = pw.Font.ttf(regularFontData);
    final ttfBold = pw.Font.ttf(boldFontData);

    final doc = pw.Document();

    final pdfTheme = pw.ThemeData.withFont(
      base: ttfRegular,
      bold: ttfBold,
    );

    doc.addPage(
      pw.Page(
        theme: pdfTheme,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pdfContext) {
          return _buildPdfPage(pdfContext, state, currencyFormat, logoImage, signatureImage);
        },
      ),
    );

    // Return the bytes
    return await doc.save();
  }

  // --- 2. UPDATED SAVE FUNCTION (for Download button) ---
  Future<void> _generateAndSavePdf(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating PDF for Download...')),
    );

    try {
      // 1. Generate the PDF bytes
      final Uint8List bytes = await _generatePdfBytes(context);
      final state = context.read<QuoteBuilderBloc>().state;

      // 2. Create a unique file name
      final String fileName = state.clientInfo.reference.isNotEmpty
          ? 'Invoice_${state.clientInfo.reference}.pdf'
          : 'Invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // 3. Use file_saver to save the file
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        mimeType: MimeType.pdf,
      );

      // 4. Show success message
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Success! Saved to Downloads as $fileName')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving PDF: $e')),
      );
    }
  }

  // --- 3. NEW SHARE FUNCTION (for Share button) ---
  Future<void> _generateAndSharePdf(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparing PDF for sharing...')),
    );

    try {
      // 1. Generate the PDF bytes
      final Uint8List bytes = await _generatePdfBytes(context);
      final state = context.read<QuoteBuilderBloc>().state;

      // 2. Create a unique file name
      final String fileName = state.clientInfo.reference.isNotEmpty
          ? 'Invoice_${state.clientInfo.reference}.pdf'
          : 'Invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // 3. Create an XFile from the bytes (necessary for share_plus)
      final file = XFile.fromData(
        bytes,
        name: fileName,
        mimeType: 'application/pdf',
      );

      // 4. Use share_plus to open the native share dialog
      ScaffoldMessenger.of(context).removeCurrentSnackBar(); // Remove "Preparing..." message
      await Share.shareXFiles(
        [file],
        text: 'Please find the attached invoice from Meru Technosoft: $fileName',
      );

    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing PDF: $e')),
      );
    }
  }


  // --- PDF Page Building (Includes layout fixes) ---

  pw.Widget _buildPdfPage(
      pw.Context context,
      QuoteBuilderState state,
      NumberFormat currencyFormat,
      pw.MemoryImage logoImage,
      pw.MemoryImage signatureImage,
      ) {
    final boldStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold);
    final smallStyle = const pw.TextStyle(fontSize: 9);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Image(logoImage, width: 100, height: 50, fit: pw.BoxFit.contain),
        pw.Divider(height: 16),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Sold By:', style: boldStyle),
                  pw.SizedBox(height: 8),
                  pw.Text('Meru Technosoft', style: boldStyle),
                  pw.Text('https://merufintech.com'),
                  pw.Text('hello@merufintech.net'),
                  pw.Text('+91-7069083968'),
                  pw.SizedBox(height: 16),
                  pw.Text('PAN No: AAJCC8517E'),
                  pw.Text('GST Registration No: 27AAJCC8517E1ZL'),
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                // FIX: Used pw.CrossAxisAlignment to resolve namespace conflict
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Billing Address:', style: boldStyle),
                  pw.SizedBox(height: 8),
                  pw.Text(state.clientInfo.name.isEmpty ? 'Client Name' : state.clientInfo.name, style: boldStyle),
                  pw.Text(state.clientInfo.address.isEmpty ? 'Client Address' : state.clientInfo.address),
                  pw.SizedBox(height: 16),
                  pw.Text('State/UT Code: 27'),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Order Number: ${state.clientInfo.reference.isEmpty ? 'N/A' : state.clientInfo.reference}'),
                  pw.Text('Order Date: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}'),
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Shipping Address:', style: boldStyle),
                  pw.SizedBox(height: 8),
                  pw.Text(state.clientInfo.name.isEmpty ? 'Client Name' : state.clientInfo.name, style: boldStyle),
                  pw.Text(state.clientInfo.address.isEmpty ? 'Client Address' : state.clientInfo.address),
                ],
              ),
            ),
          ],
        ),
        pw.Divider(height: 24),
        _buildPdfTable(state, currencyFormat, boldStyle),
        // FIX: Spacer placed here to push footer to the bottom of the PDF page
        pw.Spacer(),
        _buildPdfFooter(state, currencyFormat, boldStyle, smallStyle, signatureImage),
      ],
    );
  }

  pw.Widget _buildPdfTable(
      QuoteBuilderState state, NumberFormat currencyFormat, pw.TextStyle boldStyle) {

    final headers = [
      'Sl.',
      'Description',
      'Unit Price',
      'Qty',
      'Net Amount',
      'Tax Rate',
      'Tax Type',
      'Tax Amount',
      'Total Amount'
    ];

    final cellStyle = const pw.TextStyle(fontSize: 9);
    final boldCellStyle = boldStyle.copyWith(fontSize: 9);

    final tableRows = <pw.TableRow>[];

    tableRows.add(pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: headers.map((header) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(header, style: boldCellStyle),
        );
      }).toList(),
    ));

    double totalTaxableAmount = 0;
    double totalTaxAmount = 0;

    for (var i = 0; i < state.lineItems.length; i++) {
      final item = state.lineItems[i];
      final rate = _parseDouble(item.rateController.text);
      final qty = _parseDouble(item.quantityController.text);
      final discount = _parseDouble(item.discountController.text);
      final taxPercent = _parseDouble(item.taxController.text);

      final taxableAmount = (rate - discount) * qty;
      final taxAmount = taxableAmount * (taxPercent / 100);
      final totalAmount = taxableAmount + taxAmount;

      totalTaxableAmount += taxableAmount;
      totalTaxAmount += taxAmount;

      final rowData = [
        (i + 1).toString(),
        item.nameController.text,
        currencyFormat.format(rate),
        item.quantityController.text,
        currencyFormat.format(taxableAmount),
        '${item.taxController.text}%',
        'GST',
        currencyFormat.format(taxAmount),
        currencyFormat.format(totalAmount),
      ];

      tableRows.add(pw.TableRow(
        children: rowData.map((data) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(data, style: cellStyle),
          );
        }).toList(),
      ));
    }

    tableRows.add(pw.TableRow(
      children: [
        pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: boldCellStyle)),
        pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('TOTAL:', style: boldCellStyle)),
        pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: boldCellStyle)),
        pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: boldCellStyle)),
        pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text(currencyFormat.format(totalTaxableAmount), style: boldCellStyle)),
        pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: boldCellStyle)),
        pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text('', style: boldCellStyle)),
        // FIX: Corrected variable name to totalTaxAmount
        pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text(currencyFormat.format(totalTaxAmount), style: boldCellStyle)),
        pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text(currencyFormat.format(state.grandTotal), style: boldCellStyle)),
      ],
    ));

    return pw.Table(
      children: tableRows,
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
      columnWidths: {
        0: const pw.FixedColumnWidth(25), // Sl.
        1: const pw.FlexColumnWidth(3),   // Description
        2: const pw.FlexColumnWidth(2),   // Unit Price
        3: const pw.FixedColumnWidth(30), // Qty
        4: const pw.FlexColumnWidth(2),   // Net Amount
        5: const pw.FixedColumnWidth(35), // Tax Rate
        6: const pw.FixedColumnWidth(35), // Tax Type
        7: const pw.FlexColumnWidth(2),   // Tax Amount
        8: const pw.FlexColumnWidth(2),   // Total Amount
      },
    );
  }

  pw.Widget _buildPdfFooter(
      QuoteBuilderState state,
      NumberFormat currencyFormat,
      pw.TextStyle boldStyle,
      pw.TextStyle smallStyle,
      pw.MemoryImage signatureImage,
      ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.SizedBox(height: 32),
        pw.Text(
          'Amount in Words: ${_getAmountInWords(state.grandTotal)}',
          style: smallStyle,
        ),
        pw.SizedBox(height: 16),
        pw.Text(
          'Whether tax is payable on reverse charge - No',
          style: smallStyle.copyWith(fontWeight: pw.FontWeight.bold),
        ),

        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('For Meru Technosoft', style: boldStyle),
              pw.Image(
                signatureImage,
                height: 40,
                width: 150,
              ),
              pw.SizedBox(height: 8),
              pw.Container(width: 200, height: 1, color: PdfColors.black),
              pw.SizedBox(height: 8),
              pw.Text('Authorized Signatory'),
            ],
          ),
        ),
      ],
    );
  }
}