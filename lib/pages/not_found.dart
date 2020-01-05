import 'package:flutter/material.dart';
import '../widgets/side_drawer.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer('/notfound'),
      appBar: AppBar(
        title: Text('Página No Encontrada'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text('Página no encontrada, esto es un error.'),
          ),
          Center(
            child: Text('Notifíquelo al Administrador del Sistema'),
          )
        ],
      ),
    );
  }
}
