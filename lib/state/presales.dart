import 'package:scoped_model/scoped_model.dart';
import '../models/presale.dart';
import '../models/client.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../models/electronic_documents.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

mixin PresalesModel on Model {
  
  // THE GLOBAL CONTAINERS OF THE MODEL
  List<Presale> _presales = [];
  Presale _selectedPresale;
  ElectronicInvoice _selectedElectronicInvoice;
  ElectronicTicket _selectedElectronicTicket;
  String _nextLink;
  String _prevLink;
  

  // GETTERS METHODS OF THE MODEL
  List<Presale> get presales {
    return List.from(_presales);
  }

  Presale get selectedPresale {
    return _selectedPresale;
  }

  ElectronicInvoice get selectedElectronicInvoice {
    return _selectedElectronicInvoice;
  }

  ElectronicTicket get selectedElectronicTicket {
    return _selectedElectronicTicket;
  }

  String get nextPresalePageLink {
    return _nextLink;
  }

  String get previousPresalePageLink {
    return _prevLink;
  }

  clearPresales() {
    _presales = [];
    _selectedPresale = null;
    _selectedElectronicInvoice = null;
    _selectedElectronicTicket = null;
    _nextLink = null;
    _prevLink = null;
  }

  Future<Null> fetchPresales() async {
    final prefs = await SharedPreferences.getInstance();
    
    final apiURL = prefs.getString('apiURL') ?? '';
    final username = prefs.getString('username') ?? '';
    final password = prefs.getString('password') ?? '';
    // String username = 'admin';
    // String password = 'admin123456';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    String apiFullURL = '';
    if (_nextLink == null) {
      apiFullURL = 'http://$apiURL/api/presales/?limit=10&ordering=-consecutive';
    } else {
      apiFullURL = _nextLink;
    }

    return http.get(apiFullURL, headers: <String, String>{'authorization': basicAuth})
    .then((http.Response response) {
      final Map<String, dynamic> presaleData = json.decode(utf8.decode(response.bodyBytes));
      _nextLink = presaleData['next'];
      _prevLink = presaleData['previous'];
      final List <dynamic> presaleResults = presaleData['results'];
      final List<Presale> fetchedPresalesList = [];
      if (presaleResults.length > 0 ) {
        presaleResults.forEach((dynamic presale) {
          // final Map<String, dynamic> saleObject = json.decode(presale);
          final Presale fetchedPresale = Presale(
            id: presale['id'],
            consecutive: presale['consecutive'],
            saleTotal: double.parse(presale['sale_total']),
            client: parseClient(presale['client']),
            cart: parseCart((presale['cart'])),
            presaleType: presale['presale_type'],
            date: DateTime.parse(presale['created']),
          );
          _presales.add(fetchedPresale);
        });
      }
      // _presales = fetchedPresalesList;
      notifyListeners();
    });
  
  }

  Future<Map<String, dynamic>> fetchPresaleAndRelated(int consecutive) async {
  
    final prefs = await SharedPreferences.getInstance();
    
    final apiURL = prefs.getString('apiURL') ?? '';
    final username = prefs.getString('username') ?? '';
    final password = prefs.getString('password') ?? '';
    // String username = 'admin';
    // String password = 'admin123456';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return http.get('http://$apiURL/api/presales/?consecutive=$consecutive', headers: <String, String>{'authorization': basicAuth})
    .then((http.Response response) {
      final Map<String, dynamic> presaleData = json.decode(utf8.decode(response.bodyBytes));
      final List <dynamic> presaleResults = presaleData['results'];
      final Presale fetchedPresale = Presale(
        id: presaleResults[0]['id'],
        consecutive: presaleResults[0]['consecutive'],
        saleTotal: double.parse(presaleResults[0]['sale_total']),
        client: parseClient(presaleResults[0]['client']),
        cart: parseCart((presaleResults[0]['cart'])),
        presaleType: presaleResults[0]['presale_type'],
        date: DateTime.parse(presaleResults[0]['created']),
      );
    
      return {
        'presale': fetchedPresale
      };
    });
  
  }
  
  Client parseClient(String clientString){

    final Map<String, dynamic> client = json.decode(clientString);

    Client parsedClient = Client(
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
      predDiscount: doubleFA(client['pred_discount']),
      maxDiscount: doubleFA(client['max_discount']),
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

    return parsedClient;

  }

  Cart parseCart(String cartString) {
    final Map<String, dynamic> cart = json.decode(cartString);
    
    final List<CartItem> cartItems = [];
    // ITERATE OVER CART ITEMS TO BUILD THE OBJECTS
    for(var item in cart['cartItems']) {
      // DECLARE THE PRODUCT
      final Product product = Product (
        id: item['product']['id'],
        code: item['product']['code'],
        description: item['product']['description'],
        isService: item['product']['is_service'],
        unit: item['product']['unit'],
        fractioned: item['product']['fractioned'],
        department: item['product']['department'],
        subdepartment: item['product']['subdepartment'],
        barcode: item['product']['barcode'],
        internalBarcode: item['product']['internal_barcode'],
        supplierCode: item['product']['supplier_code'],
        model: item['product']['model'],
        partNumber: item['product']['partNumber'],
        brandCode: item['product']['brandCode'],
        inventoryEnabled: item['product']['inventory_enabled'],
        inventoryMinimum: doubleFA(item['product']['inventory_minimum']),
        inventoryMaximum: doubleFA(item['product']['inventory_maximum']),
        inventoryNegative: item['product']['inventory_negative'],
        inventoryExistent: item['product']['inventory_existent'],
        cost: doubleFA(item['product']['cost']),
        costBased: item['product']['cost_based'],
        useCoinRound: item['product']['use_coin_round'],
        utility1: doubleFA(item['product']['utility1']),
        utility2: doubleFA(item['product']['utility2']),
        utility3: doubleFA(item['product']['utility3']),
        price: doubleFA(item['product']['price']),
        price1: doubleFA(item['product']['price1']),
        price2: doubleFA(item['product']['price2']),
        price3: doubleFA(item['product']['price3']),
        sellPrice: doubleFA(item['product']['sell_price']),
        sellPrice1: doubleFA(item['product']['sell_price1']),
        sellPrice2: doubleFA(item['product']['sell_price2']),
        sellPrice3: doubleFA(item['product']['sell_price3']),
        askPrice: item['product']['ask_price'],
        useTaxes: item['product']['use_taxes'],
        taxes: doubleFA(item['product']['taxes']),
        taxCode: item['product']['tax_code'],
        predDiscount: doubleFA(item['product']['pred_discount']),
        maxRegularDiscount: doubleFA(item['product']['max_regular_discount']),
        maxSaleDiscount: doubleFA(item['product']['max_sale_discount']),
        taxCodeIVA: item['product']['tax_code_IVA'],
        rateCodeIVA: item['product']['rate_code_IVA'],
        taxesIVA: doubleFA(item['product']['taxes_IVA']),
        factorIVA: doubleFA(item['product']['factor_IVA']),
        isUsed: item['product']['is_used'],
        isActive: item['product']['is_active']
      );
      // DECLARE THE CART ITEM
      final CartItem cartItem = CartItem(
        uuid: item['uuid'],
        lote: item['lote'],
        discount: doubleFA(item['discount']),
        discountCurrency: doubleFA(item['discountCurrency']),
        exemptPercentage: doubleFA(item['exempt_percentage']),
        priceToUse: doubleFA(item['priceToUse']),
        qty: doubleFA(item['qty']),
        subTotalNoDiscount: doubleFA(item['subTotalNoDiscount']),
        subtotal: doubleFA(item['subtotal']),
        totalWithIv: doubleFA(item['totalWithIv']),
        product: product
      );

      // PUSH THE CART ITEM
      cartItems.add(cartItem);
    }
    
    Cart parsedCart = Cart(
    cartItems: cartItems,
    cartExemptAmount: doubleFA(cart['cartExemptAmount']),
    cartHasItems: cart['cartHasItems'],
    cartItemActive: cart['cartItemActive'],
    cartSubtotal: doubleFA(cart['cartSubtotal']),
    cartSubtotalNoDiscount: doubleFA(cart['cartSubtotalNoDiscount']),
    cartTaxes: doubleFA(cart['cartTaxes']),
    cartTotal: doubleFA(cart['cartTotal']),
    discountTotal: doubleFA(cart['discountTotal']),
    editable: cart['editable'],
    globalDiscount: doubleFA(cart['globalDiscount']),
    globalExemptPercentage: doubleFA(cart['globalExemptPercentage']),
    isExempt: cart['isExempt'],
    isNull: cart['isNull'],
    needsRecalc: cart['needsRecalc'],
    pays10Percent: cart['pays10Percent'],
    pays10Setted: cart['pays10Setted'],
    returnedIVA: doubleFA(cart['returnedIVA']),
    totalNotRounded: doubleFA(cart['totalNotRounded']),
    workOrder: cart['work_order'],
    workOrderId: cart['work_order_id'],
    );
    return parsedCart;
  }
  
  // CREATES A DOUBLE FROM ANYTHING
  double doubleFA(element) {
    try{
      return double.parse(element.toString());
    } catch(e){
      print('Error al convertir a double $e, elemento: $element');
      return 0.0;
    }
  }

}