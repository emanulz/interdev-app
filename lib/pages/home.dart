import 'package:flutter/material.dart';
import '../widgets/side_drawer.dart';

class HomePage extends StatelessWidget {
  Widget _buildTextIconWidget(String text, IconData icon) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Icon(icon, color: Color(0xFF13334C), size: 40),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 14, color: Color(0xFF13334C)),
          ),
        ],
      ),
    );
  }

  Widget _buildFirtsActionRow(context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/sales'),
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.3),
                        right: BorderSide(color: Colors.grey, width: 0.3))),
                child:
                    _buildTextIconWidget('FACTURAS', Icons.insert_drive_file)),
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/presales'),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.3))),
              child: _buildTextIconWidget('PREVENTAS', Icons.note_add),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSecondActionRow(context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/clients'),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: Colors.grey, width: 0.3))),
              child: _buildTextIconWidget('CLIENTES', Icons.person),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/pays'),
            child: Container(
              child: _buildTextIconWidget('NUEVO PAGO', Icons.attach_money),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLogoAndTitle(Orientation orientation, BuildContext context) {
  
    // Determins a padding and Aligment for the elements acording to orientation
    final EdgeInsets padding = orientation == Orientation.landscape
        ? EdgeInsets.only(right: 30.0, left: 30.0)
        : EdgeInsets.only(bottom: 20.0);
    
    final MainAxisAlignment alignment = orientation == Orientation.landscape
        ? MainAxisAlignment.center
        : MainAxisAlignment.start;
    
    return Container(
        padding: padding,
        decoration: BoxDecoration(color: Color(0xFF13334C)),
        child: Column(
          mainAxisAlignment: alignment,
          children: <Widget>[
            Text('FACTURACIÓN ELECTRÓNICA',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                  width: 200,
                  // child: Image(image: AssetImage('images/logoInterdevBlanco.png'))
                  child: CircleAvatar(
                    radius: 80.0,
                    // backgroundImage: AssetImage('images/interdevLogo.png'),
                    child: Image.asset(
                      'images/interdevLogo.png',
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                    backgroundColor: Colors.white,
                  ),
                )
              ],
            ),
            Text('ELIJA UNA OPCIÓN PARA INICIAR',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ));
  }

  Widget _buildActionButtons(Orientation orientation, BuildContext context) {
    return Expanded(
        child: Container(
            child: Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: _buildFirtsActionRow(context),
        ),
        Flexible(
          flex: 1,
          child: _buildSecondActionRow(context),
        ),
      ],
    )));
  }

  Widget _buildLayout(Orientation orientation, BuildContext context) {
    // Checks for the orientation, and renders a layout acording to it
    if (orientation == Orientation.landscape) {
      return Row(
        children: <Widget>[
          _buildLogoAndTitle(orientation, context),
          _buildActionButtons(orientation, context),
        ],
      );
    }
    return Column(
      children: <Widget>[
        _buildLogoAndTitle(orientation, context),
        _buildActionButtons(orientation, context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer('/'),
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return _buildLayout(orientation, context);
      }),
    );
  }
}
