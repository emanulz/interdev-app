import 'package:scoped_model/scoped_model.dart';
import '../models/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

mixin AuthModel on Model {
  
  // THE GLOBAL CONTAINERS OF THE MODEL
  User _selectedUser;
  UserProfile _selectedUserProfile;
  Local _selectedLocal;
  TaxPayer _selectedTaxpayer;

  String _apiURL;
  String _username;
  String _password;

  // GETTERS METHODS OF THE MODEL
  User get selectedUser {
    return _selectedUser;
  }

  UserProfile get selectedUserProfile {
    return _selectedUserProfile;
  }

  Local get selectedLocal {
    return _selectedLocal;
  }

  TaxPayer get selectedTaxpayer {
    return _selectedTaxpayer;
  }

  String get apiURL {
    return _apiURL;
  }
  String get username {
    return _username;
  }

  String get password {
    return _password;
  }

  Future<Null> fetchProfileAndRelated() async {
    final prefs = await SharedPreferences.getInstance();
    
    final apiURL = prefs.getString('apiURL') ?? '';
    final username = prefs.getString('username') ?? '';
    final password = prefs.getString('password') ?? '';
  
    // String username = 'admin';
    // String password = 'admin123456';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return http.get('http://$apiURL/api/userprofiles/getProfileAndRelated/', headers: <String, String>{'authorization': basicAuth})
    .then((http.Response response) {
      final Map<String, dynamic> profileData = json.decode(utf8.decode(response.bodyBytes));

      // CREATE THE PROFILE
      final UserProfile profile = UserProfile(
        id: profileData['profile']['id'],
        activeLocalId: profileData['profile']['active_local_id'],
        avatar: profileData['profile']['avatar'],
        code: profileData['profile']['code'],
        pin: profileData['profile']['pin'],
        taxPayerId: profileData['profile']['tax_payer_id'],
        taxpayerLocals: profileData['profile']['taxpayer_Locals'],
        user: profileData['profile']['user'],
      );
      _selectedUserProfile = profile;
      
      // CREATE THE TAX PAYER
      final TaxPayer taxpayer = TaxPayer(
        id: profileData['taxpayer']['id'],
        idNumber: profileData['taxpayer']['id_number'],
        idType: profileData['taxpayer']['id_type'],
        legalName: profileData['taxpayer']['legal_name'],
      );
      _selectedTaxpayer = taxpayer;
      
      // LOOP TO GET THE ACTUAL LOCAL
      Map <String, dynamic> activeLocal;

      for(var local in profileData['tp_locals']) {
        if (local['id'] == _selectedUserProfile.activeLocalId) {
          activeLocal = local;
        }
      }
      // TODO: CHECK IF ACTIVE LOCAL IS EMPTY AND RAISE AN ERROR

      // CREATE THE TAX LOCAL

      final Local local = Local (
        id: activeLocal['id'],
        name: activeLocal['name'],
        receiptAddress: activeLocal['receipt_address'],
        longAddress: activeLocal['long_address'],
        phoneNumber: activeLocal['phone_number'],
        taxpayerId: activeLocal['taxpayer_id'],
        email: activeLocal['email']
      );
      _selectedLocal = local;
            
      notifyListeners();
    });
  
  }

  Future<Null> saveConnectionData(apiURL, username, password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('apiURL', apiURL);
    prefs.setString('username', username);
    prefs.setString('password', password);
    notifyListeners();
  }

  Future<Null> getConnectionData() async {
    final prefs = await SharedPreferences.getInstance();
    final apiURL = prefs.getString('apiURL') ?? '';
    final username = prefs.getString('username') ?? '';
    final password = prefs.getString('password') ?? '';
    
    _apiURL = apiURL;
    _username = username;
    _password = password;

    notifyListeners();
  }

}