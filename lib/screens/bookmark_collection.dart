import 'package:flutter/material.dart';
import 'package:portrait_click/provider/user_provider.dart';
import 'package:portrait_click/services/firestore_service.dart';
import 'package:provider/provider.dart';

class Bookmark extends StatelessWidget {
  const Bookmark({super.key});

  @override
  Widget build(BuildContext context) {
    FireStoreService fireStoreService = FireStoreService();
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return const Scaffold();
  }
}
