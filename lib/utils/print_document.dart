import 'package:flutter/cupertino.dart';

import '../models/sale.dart';
import '../models/presale.dart';
import '../models/auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';

class PrintDocument{

  //Define your method
  void printOldSaleDEPRECATED (Sale sale, Local local, TaxPayer taxPayer, invoice, ticket) {

    List<int> buildPdf(PdfPageFormat format) {
    final pdf.Document doc = pdf.Document();
    doc.addPage(
      pdf.Page(
        pageTheme: pdf.PageTheme(theme: pdf.Theme(defaultTextStyle: pdf.TextStyle(fontSize: 9.0)), pageFormat:format),
        build: (pdf.Context context) {
          return pdf.ConstrainedBox(
            constraints: const pdf.BoxConstraints.expand(),
            child: pdf.Container(
              child: _buildSalePdf(sale, local, taxPayer, invoice, ticket),
            )
          );
          
          
        },
      ),
    );

    return doc.save();
  }

    Printing.layoutPdf(
      onLayout: buildPdf,
    );
  
  
  }

  //Define your method
  void printOldPresaleDEPRECATED (Presale presale, Local local, TaxPayer taxPayer) {

    List<int> buildPdf(PdfPageFormat format) {
    final pdf.Document doc = pdf.Document();
    doc.addPage(
      pdf.Page(
        pageTheme: pdf.PageTheme(theme: pdf.Theme(defaultTextStyle: pdf.TextStyle(fontSize: 9.0)), pageFormat:format),
        build: (pdf.Context context) {
          return pdf.ConstrainedBox(
            constraints: const pdf.BoxConstraints.expand(),
            child: pdf.Container(
              child: _buildPresalePdf(presale, local, taxPayer),
            )
          );
          
          
        },
      ),
    );

    return doc.save();
  }

    Printing.layoutPdf(
      onLayout: buildPdf,
    );
  
  
  }

  // ### DOCS TO PRINT ###
  void printPresale (Presale presale, Local local, TaxPayer taxPayer) {

    List<int> buildPdf(PdfPageFormat format) {
    final pdf.Document doc = pdf.Document();
    doc.addPage(
      pdf.MultiPage(
        pageTheme: pdf.PageTheme(theme: pdf.Theme(defaultTextStyle: pdf.TextStyle(fontSize: 9.0)), pageFormat:format),
        crossAxisAlignment: pdf.CrossAxisAlignment.center,
        build: (pdf.Context context) {
          return _buildNewPresalePdf(presale, local, taxPayer);         
        },
      ),
    );

    return doc.save();
  }

    Printing.layoutPdf(
      onLayout: buildPdf,
    );

  }

  void printSale (Sale sale, Local local, TaxPayer taxPayer, invoice, ticket) {

    List<int> buildPdf(PdfPageFormat format) {
    final pdf.Document doc = pdf.Document();
    doc.addPage(
      pdf.MultiPage(
        pageTheme: pdf.PageTheme(theme: pdf.Theme(defaultTextStyle: pdf.TextStyle(fontSize: 9.0)), pageFormat:format),
        crossAxisAlignment: pdf.CrossAxisAlignment.center,
        build: (pdf.Context context) {
          return _buildNewSalePdf(sale, local, taxPayer, invoice, ticket);         
        },
      ),
    );

    return doc.save();
  }

    Printing.layoutPdf(
      onLayout: buildPdf,
    );

  }

  pdf.Widget _buildSalePdfDEPRECATED(Sale sale, Local local, TaxPayer taxPayer, invoice, ticket) {
    
    final String idText = taxPayer.idType == '02' ? 'Céd Jurid No' : 'Céd No';
    final String type = invoice != null ? 'Factura Electrónica' : ticket != null ? 'Tiquete Electronico' : 'No Encontrado';
    final String consetuveNumbering = invoice != null ? invoice.consecutiveNumbering : ticket != null ? ticket.consecutiveNumbering : 'No Encontrado';
    final String numericKey = invoice != null ? '${invoice.numericKey.substring(0,21)} ${invoice.numericKey.substring(21)}' : ticket != null ? ticket.numericKey : 'No Encontrado';
    // TODO: IMPLEMENT CURRENCY SYMBOL WITH OTHER FONT
    // final String currencySymbol = sale.currencyCode == 'CRC' ? '₡' : sale.currencyCode == 'USD' ? '\$' : 'N';
    final String currencySymbol = 'C ';
    final List<pdf.Widget> table = List<pdf.Widget>.generate(sale.cart.cartItems.length, (int index){
      return generateTableRow(sale.cart.cartItems[index], currencySymbol);
    });

    return pdf.Column(children: <pdf.Widget>[
      // HEADER
      pdf.Center(child: pdf.Text(local.name, style: pdf.TextStyle(fontSize: 10.0))),
      pdf.Center(child: pdf.Text(taxPayer.legalName)),
      pdf.Center(child: pdf.Text('$idText ${taxPayer.idNumber}')),
      pdf.Center(child: pdf.Text(local.receiptAddress)),
      pdf.Center(child: pdf.Text(local.longAddress, style: pdf.TextStyle(fontSize: 8.0))),
      pdf.Center(child: pdf.Text('Tel: ${local.phoneNumber}')),
      pdf.Center(child: pdf.Text(local.email)),
      // BLANK SPACE
      pdf.SizedBox(height: 10.0),
      // SEPARATOR
      generateSeparator('FACTURA DE CONTADO'),
      // BLANK SPACE
      pdf.SizedBox(height: 10.0),
      // DATA
      // generateFlexibleRow('Fecha:', '22/10/2019 03:06:48 pm'),
      generateFlexibleRow('Tipo:', type),
      generateFlexibleRow('Factura:', sale.consecutive.toString()),
      generateFlexibleRow('Consec:', consetuveNumbering),
      generateFlexibleRow('Clave:', numericKey),
      generateFlexibleRow('Cliente:', '${sale.client.code} - ${sale.client.name} ${sale.client.lastName}'),

      pdf.SizedBox(height: 10.0),
      
      // TABLE
      generateTableHeader(),
      generateSeparatorLine(),
      pdf.Column(children: table),
      
      pdf.SizedBox(height: 10.0),
      //TOTALS
      generateSubTotalsRow('Subtotal', sale.cart.cartSubtotalNoDiscount.toStringAsFixed(2), currencySymbol),
      generateSubTotalsRow('Descuento', sale.cart.discountTotal.toStringAsFixed(2), currencySymbol),
      generateSubTotalsRow('IVA', sale.cart.cartTaxes.toStringAsFixed(2), currencySymbol),

      generateSubtotalsSeparator(),

      generateSubTotalsRow('Total', sale.cart.cartTotal.toStringAsFixed(2), currencySymbol),
      
      pdf.SizedBox(height: 10.0),
      generateHaciendaStatementRow(),



    ]);
  }

  pdf.Widget _buildPresalePdfDEPRECATED(Presale presale, Local local, TaxPayer taxPayer) {
    
    final String idText = taxPayer.idType == '02' ? 'Céd Jurid No' : 'Céd No';
    final String type = presale.presaleType == 'REGULAR' ? 'PREVENTA' : presale.presaleType == 'RESERVE' ? 'RECIBO' : presale.presaleType == 'QUOTING' ? 'PROFORMA' : 'PREVENTA';
    // TODO: IMPLEMENT CURRENCY SYMBOL WITH OTHER FONT
    // final String currencySymbol = sale.currencyCode == 'CRC' ? '₡' : sale.currencyCode == 'USD' ? '\$' : 'N';
    final String currencySymbol = 'C ';
    final List<pdf.Widget> table = List<pdf.Widget>.generate(presale.cart.cartItems.length, (int index){
      return generateTableRow(presale.cart.cartItems[index], currencySymbol);
    });

    return pdf.Column(children: <pdf.Widget>[
      // HEADER
      pdf.Center(child: pdf.Text(local.name, style: pdf.TextStyle(fontSize: 10.0))),
      pdf.Center(child: pdf.Text(taxPayer.legalName)),
      pdf.Center(child: pdf.Text('$idText ${taxPayer.idNumber}')),
      pdf.Center(child: pdf.Text(local.receiptAddress)),
      pdf.Center(child: pdf.Text(local.longAddress, style: pdf.TextStyle(fontSize: 8.0))),
      pdf.Center(child: pdf.Text('Tel: ${local.phoneNumber}')),
      pdf.Center(child: pdf.Text(local.email)),
      // BLANK SPACE
      pdf.SizedBox(height: 10.0),
      // SEPARATOR
      generateSeparator('RECIBO DE VENTA'),
      // BLANK SPACE
      pdf.SizedBox(height: 10.0),
      // DATA
      // generateFlexibleRow('Fecha:', '22/10/2019 03:06:48 pm'),
      generateFlexibleRow('Tipo:', type),
      generateFlexibleRow('Preventa:', presale.consecutive.toString()),
      generateFlexibleRow('Cliente:', '${presale.client.code} - ${presale.client.name} ${presale.client.lastName}'),

      pdf.SizedBox(height: 10.0),
      
      // TABLE
      generateTableHeader(),
      generateSeparatorLine(),
      pdf.Column(children: table),
      
      pdf.SizedBox(height: 10.0),
      //TOTALS
      // generateSubTotalsRow('Subtotal', presale.cart.cartSubtotalNoDiscount.toStringAsFixed(2), currencySymbol),
      generateSubTotalsRow('Descuento', presale.cart.discountTotal.toStringAsFixed(2), currencySymbol),
      // generateSubTotalsRow('IVA', presale.cart.cartTaxes.toStringAsFixed(2), currencySymbol),

      generateSubtotalsSeparator(),

      generateSubTotalsRow('Total', presale.cart.cartTotal.toStringAsFixed(2), currencySymbol),
      
      pdf.SizedBox(height: 10.0),



    ]);
  }

  List<pdf.Widget> _buildNewPresalePdf(Presale presale, Local local, TaxPayer taxPayer) {
    
    final String idText = taxPayer.idType == '02' ? 'Céd Jurid No' : 'Céd No';
    final String type = presale.presaleType == 'REGULAR' ? 'PREVENTA' : presale.presaleType == 'RESERVE' ? 'RECIBO' : presale.presaleType == 'QUOTING' ? 'PROFORMA' : 'PREVENTA';
    // TODO: IMPLEMENT CURRENCY SYMBOL WITH OTHER FONT
    // final String currencySymbol = sale.currencyCode == 'CRC' ? '₡' : sale.currencyCode == 'USD' ? '\$' : 'N';
    final String currencySymbol = 'C ';

    final List<pdf.Widget> table = List<pdf.Widget>.generate(presale.cart.cartItems.length, (int index){
      return generateTableRow(presale.cart.cartItems[index], currencySymbol);
    });
    
    return <pdf.Widget> [
      // BLANK SPACE
      pdf.SizedBox(height: 10.0),
      // HEADER
      pdf.Center(child: pdf.Text(local.name, style: pdf.TextStyle(fontSize: 10.0))),
      pdf.Center(child: pdf.Text(taxPayer.legalName)),
      pdf.Center(child: pdf.Text('$idText ${taxPayer.idNumber}')),
      pdf.Center(child: pdf.Text(local.receiptAddress)),
      pdf.Center(child: pdf.Text(local.longAddress, style: pdf.TextStyle(fontSize: 8.0))),
      pdf.Center(child: pdf.Text('Tel: ${local.phoneNumber}')),
      pdf.Center(child: pdf.Text(local.email)),
      // BLANK SPACE
      pdf.SizedBox(height: 10.0),
      // SEPARATOR
      generateSeparator('RECIBO DE VENTA'),
      // BLANK SPACE
      pdf.SizedBox(height: 10.0),
      // DATA
      // generateFlexibleRow('Fecha:', '22/10/2019 03:06:48 pm'),
      generateFlexibleRow('Tipo:', type),
      generateFlexibleRow('Preventa:', presale.consecutive.toString()),
      generateFlexibleRow('Cliente:', '${presale.client.code} - ${presale.client.name} ${presale.client.lastName}'),

      pdf.SizedBox(height: 10.0),

      generateTableHeader(),
      generateSeparatorLine(),

      pdf.Wrap(children: table),

      pdf.SizedBox(height: 10.0),
      //TOTALS
      // generateSubTotalsRow('Subtotal', presale.cart.cartSubtotalNoDiscount.toStringAsFixed(2), currencySymbol),
      generateSubTotalsRow('Descuento', presale.cart.discountTotal.toStringAsFixed(2), currencySymbol),
      // generateSubTotalsRow('IVA', presale.cart.cartTaxes.toStringAsFixed(2), currencySymbol),

      generateSubtotalsSeparator(),

      generateSubTotalsRow('Total', presale.cart.cartTotal.toStringAsFixed(2), currencySymbol),
      
      pdf.SizedBox(height: 10.0),

    ];
  }

  List<pdf.Widget> _buildNewSalePdf(Sale sale, Local local, TaxPayer taxPayer, invoice, ticket) {
    
    final String idText = taxPayer.idType == '02' ? 'Céd Jurid No' : 'Céd No';
    final String type = invoice != null ? 'Factura Electrónica' : ticket != null ? 'Tiquete Electronico' : 'No Encontrado';
    final String consetuveNumbering = invoice != null ? invoice.consecutiveNumbering : ticket != null ? ticket.consecutiveNumbering : 'No Encontrado';
    final String numericKey = invoice != null ? '${invoice.numericKey.substring(0,21)} ${invoice.numericKey.substring(21)}' : ticket != null ? ticket.numericKey : 'No Encontrado';
    // TODO: IMPLEMENT CURRENCY SYMBOL WITH OTHER FONT
    // final String currencySymbol = sale.currencyCode == 'CRC' ? '₡' : sale.currencyCode == 'USD' ? '\$' : 'N';
    final String currencySymbol = 'C ';
    final List<pdf.Widget> table = List<pdf.Widget>.generate(sale.cart.cartItems.length, (int index){
      return generateTableRow(sale.cart.cartItems[index], currencySymbol);
    });
    
    return <pdf.Widget> [
      pdf.Center(child: pdf.Text(local.name, style: pdf.TextStyle(fontSize: 10.0))),
      pdf.Center(child: pdf.Text(taxPayer.legalName)),
      pdf.Center(child: pdf.Text('$idText ${taxPayer.idNumber}')),
      pdf.Center(child: pdf.Text(local.receiptAddress)),
      pdf.Center(child: pdf.Text(local.longAddress, style: pdf.TextStyle(fontSize: 8.0))),
      pdf.Center(child: pdf.Text('Tel: ${local.phoneNumber}')),
      pdf.Center(child: pdf.Text(local.email)),
      // BLANK SPACE
      pdf.SizedBox(height: 10.0),
      // SEPARATOR
      generateSeparator('FACTURA DE CONTADO'),
      // BLANK SPACE
      pdf.SizedBox(height: 10.0),
      // DATA
      // generateFlexibleRow('Fecha:', '22/10/2019 03:06:48 pm'),
      generateFlexibleRow('Tipo:', type),
      generateFlexibleRow('Factura:', sale.consecutive.toString()),
      generateFlexibleRow('Consec:', consetuveNumbering),
      generateFlexibleRow('Clave:', numericKey),
      generateFlexibleRow('Cliente:', '${sale.client.code} - ${sale.client.name} ${sale.client.lastName}'),

      pdf.SizedBox(height: 10.0),
      
      // TABLE
      generateTableHeader(),
      generateSeparatorLine(),
      pdf.Wrap(children: table),
      
      pdf.SizedBox(height: 10.0),
      //TOTALS
      generateSubTotalsRow('Subtotal', sale.cart.cartSubtotalNoDiscount.toStringAsFixed(2), currencySymbol),
      generateSubTotalsRow('Descuento', sale.cart.discountTotal.toStringAsFixed(2), currencySymbol),
      generateSubTotalsRow('IVA', sale.cart.cartTaxes.toStringAsFixed(2), currencySymbol),

      generateSubtotalsSeparator(),

      generateSubTotalsRow('Total', sale.cart.cartTotal.toStringAsFixed(2), currencySymbol),
      
      pdf.SizedBox(height: 10.0),
      generateHaciendaStatementRow(),

    ];
  }

  // ### AUX METHOS FOR BUILDING PDF SECTIONS ###

  pdf.Widget generateFlexibleRow(String text1, String text2){
    final pdf.TextStyle style = pdf.TextStyle(fontSize: 9.0);

    return pdf.Row(children: <pdf.Widget>[
        pdf.Flexible(child: pdf.Text(text1, style: style), flex: 1, fit: pdf.FlexFit.tight),
        pdf.Flexible(child: pdf.Text(text2, style: style), flex: 4, fit: pdf.FlexFit.loose)
      ]);
  }

  pdf.Widget generateSeparator(String text) {
    return pdf.Row(children: <pdf.Widget>[
      pdf.Flexible(
        child: pdf.DecoratedBox(decoration: pdf.BoxDecoration(border: pdf.BoxBorder(top: true, width: 0.5))),
        fit: pdf.FlexFit.tight
      ),
      pdf.Flexible(
        child: pdf.Text(text),
        fit: pdf.FlexFit.loose
      ),
      pdf.Flexible(
        child: pdf.DecoratedBox(decoration: pdf.BoxDecoration(border: pdf.BoxBorder(top: true, width: 0.5))),
        fit: pdf.FlexFit.tight
      ),
    ]);
  }

  pdf.Widget generateTableHeader() {
    return pdf.Row(children: <pdf.Widget>[
      pdf.Flexible(
        child: pdf.Text('Cant'),
        fit: pdf.FlexFit.tight,
        flex: 2
      ),
      pdf.Flexible(
        child: pdf.Text('Cod'),
        fit: pdf.FlexFit.tight,
        flex: 2
      ),
      pdf.Flexible(
        child: pdf.Text('IVA'),
        fit: pdf.FlexFit.tight,
        flex: 2
      ),
      pdf.Flexible(
        child: pdf.Align(child: pdf.Text('Total'), alignment: pdf.Alignment.centerRight),
        fit: pdf.FlexFit.tight,
        flex: 3,
      ),
    ]);
  }

  pdf.Widget generateTableRow(row, String symbol) {
    return pdf.Column(children: <pdf.Widget>[
      pdf.SizedBox(height: 2.0),
      pdf.Row(children: <pdf.Widget>[
        pdf.Flexible(
          child: pdf.Text(row.product.description),
          fit: pdf.FlexFit.tight,
          flex: 1
        )
      ]),
      pdf.Row(children: <pdf.Widget>[
        pdf.Flexible(
          child: pdf.Text(row.qty.toString()),
          fit: pdf.FlexFit.tight,
          flex: 2
        ),
        pdf.Flexible(
          child: pdf.Text(row.product.code),
          fit: pdf.FlexFit.tight,
          flex: 2
        ),
        pdf.Flexible(
          child: pdf.Text(row.product.taxesIVA.toStringAsFixed(2)),
          fit: pdf.FlexFit.tight,
          flex: 2
        ),
        pdf.Flexible(
          child: pdf.Align(child: pdf.Text('$symbol${row.totalWithIv.toStringAsFixed(2)}'), alignment: pdf.Alignment.centerRight),
          fit: pdf.FlexFit.tight,
          flex: 3,
        ),
      ]),
      pdf.SizedBox(height: 2.0),
      generateSeparatorLine()
    ]);
  }

  pdf.Widget generateSeparatorLine(){
    return pdf.Row(children: <pdf.Widget>[
        pdf.Flexible(
          child: pdf.DecoratedBox(decoration: pdf.BoxDecoration(border: pdf.BoxBorder(top: true, width: 0.5))),
          flex: 1,
          fit: pdf.FlexFit.tight
        )
      ]);
  }

  pdf.Widget generateSubTotalsRow(String text, String amount, String symbol){
    return pdf.Row(children: <pdf.Widget>[
      pdf.Flexible(
        child: pdf.SizedBox(height: 10.0),
        fit: pdf.FlexFit.tight,
        flex: 1
      ),
      pdf.Flexible(
        child: pdf.Align(child: pdf.Text(text), alignment: pdf.Alignment.centerRight),
        fit: pdf.FlexFit.tight,
        flex: 2
      ),
      pdf.Flexible(
        child: pdf.Align(child: pdf.Text('$symbol$amount'), alignment: pdf.Alignment.centerRight),
        fit: pdf.FlexFit.tight,
        flex: 3
      ),
    ]);
  }
  
  pdf.Widget generateSubtotalsSeparator(){

    return pdf.Row(children: <pdf.Widget>[
      pdf.Flexible(
        child: pdf.SizedBox(height: 10.0),
        fit: pdf.FlexFit.tight,
        flex: 1
      ),
      pdf.Flexible(
        child: pdf.Align(child: generateSeparatorLine()),
        fit: pdf.FlexFit.tight,
        flex: 5
      ),
    ]);

  }

  pdf.Widget generateHaciendaStatementRow(){
    return pdf.Row(children: <pdf.Widget>[
      pdf.Flexible(
        child: pdf.Text('Autorizada mediante la resolución N DGT-R-033-2019 del 20-06-2019'),
        fit: pdf.FlexFit.tight,
        flex: 1
      )
    ]);
  }

}