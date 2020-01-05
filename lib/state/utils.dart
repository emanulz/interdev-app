import 'package:scoped_model/scoped_model.dart';

mixin UtilsModel on Model {
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

}