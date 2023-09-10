import 'package:flutter/widgets.dart';
import 'package:portrait_click/models/user.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthService authService = AuthService();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await authService.getUserDetails();
    _user = user;
    notifyListeners();
  }

  
}
