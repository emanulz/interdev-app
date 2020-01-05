import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/side_drawer.dart';
import '../state/global.dart';

class SettingsPage extends StatefulWidget {
  final GlobalModel model;
  SettingsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  final Map<String, dynamic> _formData = {
    'username': null,
    'password': null,
    'apiURL': true
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  initState() {
    widget.model.setIsLoading(true);
    widget.model.getConnectionData().then((_) {
      widget.model.setIsLoading(false);
    });
    super.initState();
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Ingrese la contraseña',
          filled: true,
          fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Contraseña Inválida';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildApiURLTextField() {
    return TextFormField(
      initialValue: widget.model.apiURL,
      decoration: InputDecoration(
          labelText: 'Dirección del API',
          filled: true,
          fillColor: Colors.white),
      validator: (String value) {
        if (value.isEmpty || value.length < 15) {
          return 'API Inválido';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['apiURL'] = value;
      },
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      initialValue: widget.model.username,
      decoration: InputDecoration(
          labelText: 'Nombre de Usuario',
          filled: true,
          fillColor: Colors.white),
      validator: (String value) {
        if (value.isEmpty) {
          return 'El usuario no puede estar en blanco';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['username'] = value;
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    widget.model.setIsLoading(true);
    widget.model
        .saveConnectionData(
            _formData['apiURL'], _formData['username'], _formData['password'])
        .then((_) {
      widget.model.setIsLoading(false);
      _showSuccessMessage();
    });
  }

  void _showSuccessMessage() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Completado"),
          content: new Text("Ajustes actualizados correctamente"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideDrawer('/settings'),
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
                        return model.getConnectionData().then((_) {
                          model.setIsLoading(false);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'AJUSTES GENERALES:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  _buildApiURLTextField(),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  _buildUsernameTextField(),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  _buildPasswordTextField(),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  RaisedButton(
                                    textColor: Colors.black,
                                    child: Text('Actualizar'),
                                    onPressed: () => _submitForm(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ));
                });
        }));
  }
}
