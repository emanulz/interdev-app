import '../models/client.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/side_drawer.dart';
import '../state/global.dart';

class ClientsPage extends StatefulWidget {
  final GlobalModel model;
  ClientsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ClientsPageState();
  }
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  initState() {
    widget.model.setIsLoading(true);
    widget.model.fetchClients().then((_) {
      widget.model.setIsLoading(false);
    });
    super.initState();
  }

  String _searchValue = '';

  Widget _buildListBody(_clients) {
    return _clients.length > 0
        ? ListView.builder(
            itemCount: _clients.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Text(_clients[index].code),
                    title: Text(
                        '${_clients[index].name} ${_clients[index].lastName}'),
                    subtitle: _clients[index].idNum != null
                        ? Text('Identificación: ${_clients[index].idNum}')
                        : Text('Identificación: No existente'),
                    // trailing: Icon(Icons.edit),
                  ),
                  Divider(thickness: 0.8,),
                ],
              );
            },
          )
        : Center(
            child: Text('NO SE ENCONTRARON CLIENTES'),
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
        drawer: SideDrawer('/clients'),
        appBar: AppBar(
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF13334C),
          foregroundColor: Colors.white,
        ),
        body: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, GlobalModel model) {
          final List<Client> _clients = model.clients;
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
                      return model.fetchClients().then((_) {
                        model.setIsLoading(false);
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(10),
                          child: Text('LISTADO DE CLIENTES:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: buildSearchField(),
                        ),
                        Expanded(child: _buildListBody(_clients)),
                      ],
                    ),
                  );
                });
        }));
  }
}
