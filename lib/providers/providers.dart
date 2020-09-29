import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:interactive_webview/interactive_webview.dart';
import 'package:shofar/providers/campaign_provider.dart';
import 'package:shofar/providers/wallet_provider.dart';

class Providers {
  static InteractiveWebView jsContext;
  static FlutterSecureStorage secureStorage;

  static CollectionReference usersStore =
      FirebaseFirestore.instance.collection('users');
  static CollectionReference campaignsStore =
      FirebaseFirestore.instance.collection('campaigns');
  static CollectionReference commentsStore =
      FirebaseFirestore.instance.collection('comments');
  static CollectionReference updatesStore =
      FirebaseFirestore.instance.collection('updates');

  static init() async {
    jsContext = new InteractiveWebView();
    await jsContext.evalJavascript(
      "const nativeCommunicator = typeof webkit !== 'undefined' ? webkit.messageHandlers.native : window.native;",
    );
    await importJSLib("harmony");

    secureStorage = FlutterSecureStorage();
    await CampaignProvider.init();
    await WalletProvider.init();
  }

  static importJSLib(String name) async {
    var jsCode = await rootBundle.loadString('assets/$name.js');
    try {
      await jsContext.evalJavascript(jsCode);
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> waitJSMessage(String tag) async {
    WebkitMessage message =
        await jsContext.didReceiveMessage.firstWhere((element) {
      if (element.data['tag'] == tag) {
        return true;
      }
      return false;
    });
    return message.data['data'];
  }
}
