import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  final String _activeRoute;

  SideDrawer(this._activeRoute);

  Widget _buildListTile(String textToShow, String linkToRedirect, IconData iconToShow, BuildContext context) {
  
    if (_activeRoute != linkToRedirect){
      return ListTile(
        leading: Icon(iconToShow),
        title: Text(
          textToShow,
        ),
        onTap: () {
          if (_activeRoute != linkToRedirect){
            Navigator.pushReplacementNamed(context, linkToRedirect);
          } 
        },
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEDEDED)
      ),
      child: ListTile(
        leading: Icon(iconToShow),
        title: Text(
          textToShow,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Interdev'),
          ),
          _buildListTile('Inicio', '/', Icons.home, context),
          _buildListTile('Facturas', '/sales', Icons.archive, context),
          _buildListTile('Preventas', '/presales', Icons.add_to_photos, context),
          _buildListTile('Clientes', '/clients', Icons.person, context),
          Divider(),
          _buildListTile('Configuración', '/settings', Icons.phonelink, context),
        ],
      ),
    );
  }
}
