import '../models/auth.dart';

import '../models/presale.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/side_drawer.dart';
import '../state/global.dart';
import '../utils/print_document.dart';

class PresalesPage extends StatefulWidget {
  final GlobalModel model;
  PresalesPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _PresalesPageState();
  }
}

class _PresalesPageState extends State<PresalesPage> {
  @override
  initState() {
    widget.model.setIsLoading(true);
    widget.model.clearPresales();
    widget.model.fetchPresales().then((_) {
      // TODO: MOVE THIS GET TO OTHER GLOBAL LOCATION
      widget.model.fetchProfileAndRelated().then((_) {
        widget.model.setIsLoading(false);
      });
    });
    super.initState();
  }

  void loadMorePresales() {
    widget.model.fetchPresales().then((_) {
      widget.model.setIsLoading(false);
    });
  }

  void getPresaleAndPrint(_presale, _local, _taxPayer) {

    widget.model.setIsLoading(true);
    widget.model.fetchPresaleAndRelated(_presale.consecutive).then((Map<String, dynamic> presaleData) {
      widget.model.setIsLoading(false);
      // TODO: HERE I HAVE THE SALE, THE TICKET AND THE INVOICE, CONTINUE TO PRINT WITH THAT DATA
      PrintDocument().printPresale(presaleData['presale'], _local, _taxPayer);
    });

  }

  String _searchValue = '';

  Widget builLoadMoreBtn() {
    if (widget.model.nextPresalePageLink == null) {

      return null;

    } else {
      return RaisedButton(
        onPressed: () { loadMorePresales(); },
        child: Text(
          'Cargar Más...',
          style: TextStyle(fontSize: 15)
        ),
      );
    }
  }

  Widget _buildListBody(_presales, _local, _taxPayer) {
    return _presales.length > 0
        ? ListView.builder(
            itemCount: _presales.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Text(_presales[index].consecutive.toString()),
                    title: Text(
                        '${_presales[index].client.name} ${_presales[index].client.lastName}'),
                    subtitle: Text(_presales[index].cart.cartTotal.toString()),
                    // subtitle: _presales[index].idNum != null
                    //     ? Text('Identificación: ${_presales[index].idNum}')
                    //     : Text('Identificación: No existente'),
                    trailing: IconButton(
                      icon: Icon(Icons.print),
                      onPressed: () => getPresaleAndPrint(_presales[index], _local, _taxPayer),
                    ),
                  ),
                  Divider(thickness: 0.8,),
                ],
              );
            },
          )
        : Center(
            child: Text('NO SE ENCONTRARON PREVENTAS'),
          );
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
        drawer: SideDrawer('/presales'),
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, GlobalModel model) {
          // GET STATE FROM SCOPED MODELS
          final List<Presale> _presales = model.presales;
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
                      widget.model.clearPresales();
                      return model.fetchPresales().then((_) {
                        model.setIsLoading(false);
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(10),
                          child: Text('LISTADO DE PREVENTAS:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: buildSearchField(),
                        ),
                        Expanded(child: _buildListBody(_presales, _local, _taxPayer)),
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
