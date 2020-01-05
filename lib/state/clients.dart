import 'package:scoped_model/scoped_model.dart';
import '../models/client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

mixin ClientsModel on Model {
  
  // THE GLOBAL CONTAINERS OF THE MODEL
  List<Client> _clients = [];
  Client _selectedClient;

  // GETTERS METHODS OF THE MODEL
  List<Client> get clients {
    return List.from(_clients);
  }

  Client get selectedClient {
    return _selectedClient;
  }

  Future<Null> fetchClients() async{

    final prefs = await SharedPreferences.getInstance();
    
    final apiURL = prefs.getString('apiURL') ?? '';
    final username = prefs.getString('username') ?? '';
    final password = prefs.getString('password') ?? '';
    // String username = 'admin';
    // String password = 'admin123456';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return http.get('http://$apiURL/api/clients/?order_by=code', headers: <String, String>{'authorization': basicAuth})
    .then((http.Response response) {
      final Map<String, dynamic> clientData = json.decode(utf8.decode(response.bodyBytes));
      final List <dynamic> clientResults = clientData['results'];
      final List<Client> fetchedClientsList = [];
      if (clientResults.length > 0 ) {
        clientResults.forEach((dynamic client) {
          // final Map<String, dynamic> clientObject = json.decode(client);
          final Client fetchedClient = Client(
            id: client['id'],
            code: client['code'],
            name: client['name'],
            lastName: client['last_name'],
            idType: client['id_type'],
            idNum: client['id_num'],
            idForeigner: client['id_foreigner'],
            province: client['province'],
            canton: client['canton'],
            district: client['district'],
            town: client['town'],
            otherAddress: client['other_address'],
            phoneNumber: client['phone_number'],
            cellphoneNumber: client['cellphone_number'],
            faxNumber: client['fax_number'],
            email: client['email'],
            categoryId: client['category_id'],
            predDiscount: client['pred_discount'],
            maxDiscount: client['max_discount'],
            predPriceList: client['pred_price_list'],
            paysTaxes: client['pays_taxes'],
            balance: double.parse(client['balance']),
            hasCredit: client['has_credit'],
            isBlocked: client['is_blocked'],
            creditLimit: double.parse(client['credit_limit']),
            creditDays: client['credit_days'],
            observations: client['observations'],
            localData: client['local_data']
          );
          fetchedClientsList.add(fetchedClient);
        });
      }
      _clients = fetchedClientsList;
      notifyListeners();
    });
  
  }

}