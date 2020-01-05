import 'package:scoped_model/scoped_model.dart';
import '../models/sale.dart';
import '../models/client.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../models/electronic_documents.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

mixin SalesModel on Model {
  
  // THE GLOBAL CONTAINERS OF THE MODEL
  List<Sale> _sales = [];
  Sale _selectedSale;
  ElectronicInvoice _selectedElectronicInvoice;
  ElectronicTicket _selectedElectronicTicket;

  // GETTERS METHODS OF THE MODEL
  List<Sale> get sales {
    return List.from(_sales);
  }

  Sale get selectedSale {
    return _selectedSale;
  }

  ElectronicInvoice get selectedElectronicInvoice {
    return _selectedElectronicInvoice;
  }

  ElectronicTicket get selectedElectronicTicket {
    return _selectedElectronicTicket;
  }

  Future<Null> fetchSales() async {
    final prefs = await SharedPreferences.getInstance();
    
    final apiURL = prefs.getString('apiURL') ?? '';
    final username = prefs.getString('username') ?? '';
    final password = prefs.getString('password') ?? '';
    // String username = 'admin';
    // String password = 'admin123456';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return http.get('http://$apiURL/api/saleslistcustom/?limit=30&ordering=-consecutive', headers: <String, String>{'authorization': basicAuth})
    .then((http.Response response) {
      final Map<String, dynamic> saleData = json.decode(utf8.decode(response.bodyBytes));
      final List <dynamic> saleResults = saleData['results'];
      final List<Sale> fetchedSalesList = [];
      if (saleResults.length > 0 ) {
        saleResults.forEach((dynamic sale) {
          // final Map<String, dynamic> saleObject = json.decode(sale);
          final Sale fetchedSale = Sale(
            id: sale['id'],
            consecutive: sale['consecutive'],
            saleTotal: double.parse(sale['sale_total']),
            client: parseClient(sale['client']),
            cart: parseCart((sale['cart']))
          );
          fetchedSalesList.add(fetchedSale);
        });
      }
      _sales = fetchedSalesList;
      notifyListeners();
    });
  
  }

  Future<Map<String, dynamic>> fetchSaleAndRelated(int consecutive) async {
  
    final prefs = await SharedPreferences.getInstance();
    
    final apiURL = prefs.getString('apiURL') ?? '';
    final username = prefs.getString('username') ?? '';
    final password = prefs.getString('password') ?? '';
    // String username = 'admin';
    // String password = 'admin123456';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return http.get('http://$apiURL/api/saleslist/getsaledata/?consecutive=$consecutive', headers: <String, String>{'authorization': basicAuth})
    .then((http.Response response) {
      final Map<String, dynamic> saleData = json.decode(utf8.decode(response.bodyBytes));

      final Sale fetchedSale = Sale(
        id: saleData['sale']['id'],
        consecutive: saleData['sale']['consecutive'],
        saleTotal: double.parse(saleData['sale']['sale_total']),
        client: parseClient(saleData['sale']['client']),
        cart: parseCart((saleData['sale']['cart']))
      );

      final fetchedInvoice = saleData['invoice'] != null
          ? ElectronicInvoice(
            id: saleData['invoice']['id'],
            saleConsecutive: saleData['invoice']['sale_consecutive'],
            numericKey: saleData['invoice']['numeric_key'],
            processHistory: saleData['invoice']['process_history'],
            processStatus: saleData['invoice']['process_status'],
            saleId: saleData['invoice']['sale_id'],
            consecutiveNumbering: saleData['invoice']['consecutive_numbering']
        ) : saleData['invoice'];

      final fetchedTicket = saleData['ticket'] != null
        ? ElectronicTicket(
            id: saleData['ticket']['id'],
            saleConsecutive: saleData['ticket']['sale_consecutive'],
            numericKey: saleData['ticket']['numeric_key'],
            processHistory: saleData['ticket']['process_history'],
            processStatus: saleData['ticket']['process_status'],
            saleId: saleData['ticket']['sale_id'],
            consecutiveNumbering: saleData['ticket']['consecutive_numbering']
        ) : saleData['ticket'];
        
        return {
          'sale': fetchedSale,
          'invoice': fetchedInvoice,
          'ticket': fetchedTicket
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