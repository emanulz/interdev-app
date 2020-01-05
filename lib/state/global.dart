import 'package:scoped_model/scoped_model.dart';
import './clients.dart';
import './utils.dart';
import './sales.dart';
import './presales.dart';
import 'auth.dart';

class GlobalModel extends Model with ClientsModel, UtilsModel, SalesModel, PresalesModel, AuthModel {}