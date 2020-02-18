import '../models/auth.dart';

import '../models/sale.dart';
import '../models/electronic_documents.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/side_drawer.dart';
import '../state/global.dart';
import '../utils/print_document.dart';

class SalesPage extends StatefulWidget {
  final GlobalModel model;
  SalesPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _SalesPageState();
  }
}

class _SalesPageState extends State<SalesPage> {
  @override
  initState() {
    widget.model.setIsLoading(true);
    widget.model.clearSales();
    widget.model.fetchSales().then((_) {
      // TODO: MOVE THIS GET TO OTHER GLOBAL LOCATION
      widget.model.fetchProfileAndRelated().then((_) {
        widget.model.setIsLoading(false);
      });
    });
    super.initState();
  }

  void loadMoreSales() {
    widget.model.fetchSales().then((_) {
      widget.model.setIsLoading(false);
    });
  }

  void getSaleAndPrint(_sale, _local, _taxPayer) {

    widget.model.setIsLoading(true);
    widget.model.fetchSaleAndRelated(_sale.consecutive).then((Map<String, dynamic> saleData) {
      widget.model.setIsLoading(false);
      // TODO: HERE I HAVE THE SALE, THE TICKET AND THE INVOICE, CONTINUE TO PRINT WITH THAT DATA
      PrintDocument().printSale(saleData['sale'], _local, _taxPayer, saleData['invoice'], saleData['ticket']);
    });

  }

  String _searchValue = '';

  Widget _buildListBody(_sales, _local, _taxPayer) {
    return _sales.length > 0
        ? ListView.builder(
            itemCount: _sales.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Text(_sales[index].consecutive.toString()),
                    title: Text(
                        '${_sales[index].client.name} ${_sales[index].client.lastName}'),
                    subtitle: Text(_sales[index].saleTotal.toString()),
                    // subtitle: _sales[index].idNum != null
                    //     ? Text('Identificación: ${_sales[index].idNum}')
                    //     : Text('Identificación: No existente'),
                    trailing: IconButton(
                      icon: Icon(Icons.print),
                      onPressed: () => getSaleAndPrint(_sales[index], _local, _taxPayer),
                    ),
                  ),
                  Divider(thickness: 0.8,),
                ],
              );
            },
          )
        : Center(
            child: Text('NO SE ENCONTRARON VENTAS'),
          );
  }

  Widget builLoadMoreBtn() {
    if (widget.model.nextSalePageLink == null) {

      return null;

    } else {
      return RaisedButton(
        onPressed: () { loadMoreSales(); },
        child: Text(
          'Cargar Más...',
          style: TextStyle(fontSize: 15)
        ),
      );
    }
  }

  Widget buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.search),
      ),
      onChanged: (text) {
        _searchValue = text;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideDrawer('/sales'),
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, GlobalModel model) {
          // GET STATE FROM SCOPED MODELS
          final List<Sale> _sales = model.sales;
          final Local _local = model.selectedLocal;
          final TaxPayer _taxPayer = model.selectedTaxpayer;

          return model.isLoading
              ? Center(
                  child: SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : OrientationBuilder(builder: (context, orientation) {
                  return RefreshIndicator(
                    onRefresh: () {
                      model.setIsLoading(true);
                      widget.model.clearSales();
                      return model.fetchSales().then((_) {
                        model.setIsLoading(false);
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(10),
                          child: Text('LISTADO DE VENTAS:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: buildSearchField(),
                        ),
                        Expanded(child: _buildListBody(_sales, _local, _taxPayer)),
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: builLoadMoreBtn(),
                        ),
                      ],
                    ),
                  );
                });
        }));
  }
}
