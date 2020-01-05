import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './pages/home.dart';
import './pages/not_found.dart';
import './pages/clients.dart';
import './pages/sales.dart';
import './pages/presales.dart';
import './pages/settings.dart';
import 'state/global.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // CUSTOM COLOR
    final MaterialColor interdevPrimary =
        MaterialColor(0xFF13334C, <int, Color>{
      50: Color.fromRGBO(53, 64, 82, .1),
      100: Color.fromRGBO(53, 64, 82, .2),
      200: Color.fromRGBO(53, 64, 82, .3),
      300: Color.fromRGBO(53, 64, 82, .4),
      400: Color.fromRGBO(53, 64, 82, .5),
      500: Color.fromRGBO(53, 64, 82, .6),
      600: Color.fromRGBO(53, 64, 82, .7),
      700: Color.fromRGBO(53, 64, 82, .8),
      800: Color.fromRGBO(53, 64, 82, .9),
      900: Color.fromRGBO(53, 64, 82, 1)
    });

    final GlobalModel model = GlobalModel();
    return ScopedModel<GlobalModel>(
        model: model,
        child: MaterialApp(
          title: 'Factura Electrónica',
          theme: ThemeData(
            primarySwatch: interdevPrimary,
            accentColor: Colors.orangeAccent,
          ),
          routes: {
            '/': (BuildContext context) => HomePage(),
            '/clients': (BuildContext context) => ClientsPage(model),
            '/sales': (BuildContext context) => SalesPage(model),
            '/presales': (BuildContext context) => PresalesPage(model),
            '/settings': (BuildContext context) => SettingsPage(model),
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => NotFoundPage());
          },
        ));
  }
}
