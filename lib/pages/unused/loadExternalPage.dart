import 'dart:async';

import 'package:flutter/material.dart';
import '../../widgets/side_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ClientCreatePage extends StatelessWidget {
  
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer('/'),
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return WebView(
        initialUrl: 'http://ezuniga.interdevcr.com/admin/clients/add',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      );
      }),
    );
  }
}
