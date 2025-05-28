import 'package:flutter/material.dart';
import 'package:duitKu/common/model/cards.dart';
import 'package:duitKu/common/model/transactions.dart';
import 'package:duitKu/common/routes/app_routes_name.dart';
import 'package:duitKu/common/services/firebase.dart';
import 'package:duitKu/global.dart';
import 'package:duitKu/pages/Card/addcard.dart';
import 'package:duitKu/pages/Card/edit_card.dart';
import 'package:duitKu/pages/Transaction/add_transaction.dart';
import 'package:duitKu/pages/Transaction/edit_transaction.dart';
import 'package:duitKu/pages/application/application.dart';
import 'package:duitKu/pages/setup/setup.dart';
import 'package:duitKu/pages/register/register.dart';
import 'package:duitKu/pages/sign_in/sign_in.dart';
import 'package:duitKu/pages/welcome/welcome.dart';

class AppPages {
  static List<RouteEntity> routes() {
    return [
      RouteEntity(path: AppRoutesName.WELCOME, builder: (_) => Welcome()),
      RouteEntity(path: AppRoutesName.REGISTER, builder: (_) => Register()),
      RouteEntity(path: AppRoutesName.SIGN_IN, builder: (_) => SignIn()),
      RouteEntity(path: AppRoutesName.SETUP, builder: (_) => Setup()),
      RouteEntity(
        path: AppRoutesName.APPLICATION,
        builder: (_) => Application(),
      ),
      RouteEntity(path: AppRoutesName.ADDCARD, builder: (_) => AddCard()),
      RouteEntity(
        path: AppRoutesName.EDITCARD,
        builder: (args) {
          final card = args as CardModel;
          return EditCardPage(card: card);
        },
      ),
      RouteEntity(
        path: AppRoutesName.ADDTRANSACTION,
        builder: (_) => AddTransaction(),
      ),
      RouteEntity(
        path: AppRoutesName.EDITTRANSACTION,
        builder: (args) {
          final data = args as TransactionModel;
          return EditTransaction(transactionData: data);
        },
      ),
    ];
  }

  static Future<Widget> getPageForRoute(RouteSettings settings) async {
    print(
      "Navigating to: ${settings.name} with arguments: ${settings.arguments}",
    );

    var result = routes().where((element) => element.path == settings.name);
    if (result.isNotEmpty) {
      // Logic khusus untuk Welcome / Setup
      if ((result.first.path == AppRoutesName.WELCOME ||
              result.first.path == AppRoutesName.SETUP) &&
          Global.storageService.getDeviceFisrtOpen()) {
        // Auth logic...
        bool isLoggedIn = Global.storageService.isLoggedIn();
        if (isLoggedIn) {
          final firebase = FirebaseService();
          bool hasCards = await firebase.checkUserHasCards(
            Global.storageService.getUserId(),
          );
          return hasCards ? Application() : Setup();
        } else {
          return SignIn();
        }
      }

      // ✅ Gunakan builder dengan argumen
      return result.first.builder?.call(settings.arguments) ?? const Welcome();
    }

    return const Welcome(); // Default page
  }
}

// class RouteEntity {
//   String path;
//   Widget page;
//   RouteEntity({required this.path, required this.page});
// }

class RouteEntity {
  String path;
  final Widget Function(Object? arguments)? builder;

  RouteEntity({required this.path, required this.builder});
}
