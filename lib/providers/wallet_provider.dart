import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:random_string/random_string.dart';
import 'package:shofar/providers/providers.dart';

class WalletProvider {
  static String privateKey;
  static String address;
  static String hashed;
  static String oneAddress;
  static String svgAvatar;

  static init({String privKey}) async {
    if (privKey != null && privKey != '') {
      privateKey = privKey;
      hashed = await getHashed();
      address = await getAddress();
      oneAddress = await getOneAddress();
      svgAvatar = Jdenticon.toSvg(address);
      Providers.usersStore.doc(address).set({"fingerprint": hashed});
    } else {
      await getStore();
      if (privateKey == null) {
        privateKey = await createNewWallet();
      }
      hashed = await getHashed();
      address = await getAddress();
      oneAddress = await getOneAddress();
      svgAvatar = Jdenticon.toSvg(address);
      Providers.usersStore.doc(address).set({"fingerprint": hashed});
    }
    await saveStore();
  }

  static getStore() async {
    privateKey = await Providers.secureStorage.read(key: 'privateKey');
    // address = await Providers.secureStorage.read(key: 'address');
    // _hashed = await Providers.secureStorage.read(key: 'hashed');
    // oneAddress = await Providers.secureStorage.read(key: 'oneAddress');
    // svgAvatar = await Providers.secureStorage.read(key: 'svgAvatar');
  }

  static saveStore() async {
    await Providers.secureStorage.deleteAll();
    await Providers.secureStorage.write(key: 'privateKey', value: privateKey);
    // await Providers.secureStorage.write(key: 'hashed', value: hashed);
    // await Providers.secureStorage.write(key: 'address', value: address);
    // await Providers.secureStorage.write(key: 'oneAddress', value: oneAddress);
    // await Providers.secureStorage.write(key: 'svgAvatar', value: svgAvatar);
  }

  static Future<String> createNewWallet() async {
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.createAccount()
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic res = await Providers.waitJSMessage(tag);
    return res.toString();
  }

  static Future<bool> refund(String privateKey, String campaignAddress) async {
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.refund('$privateKey', '$campaignAddress')
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic res = await Providers.waitJSMessage(tag);

    if (res.toString().contains('error')) {
      print(res);
      return false;
    }
    return true;
  }

  static Future<bool> claim(String privateKey, String campaignAddress) async {
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.withdraw('$privateKey', '$campaignAddress')
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic res = await Providers.waitJSMessage(tag);

    if (res.toString().contains('error')) {
      print(res);
      return false;
    }
    return true;
  }

  static Future<bool> transferOne(
      String privKey, String destination, double amount) async {
    if (amount >= double.parse(await WalletProvider.getBalance())) {
      return false;
    }
    if (destination == null ||
        destination == '' ||
        amount == null ||
        amount == 0) {
      return false;
    }
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.transferOne('$privKey', '$destination', $amount)
      .then(
        value => {
          nativeCommunicator.postMessage(value);
        }
      );
    """);
    print("""
      contract.transferOne('$privKey', '$destination', $amount)
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic res = await Providers.waitJSMessage(tag);
    print(res);

    if (res.toString().contains('error')) {
      print(res);
      return false;
    }
    return true;
  }

  static Future<bool> donate(
      String privateKey, String campaignAddress, double amountInOne) async {
    int amountInWei = (amountInOne * pow(10, 18)).floor();
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.contribute('$privateKey', '$campaignAddress', $amountInWei)
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic res = await Providers.waitJSMessage(tag);

    if (res.toString().contains('error')) {
      print(res);
      return false;
    }
    return true;
  }

  static Future<String> getHashed() async {
    var byte = utf8.encode(privateKey + "shofar-account-secret =]]");
    var digest = sha256.convert(byte);
    return digest.toString();
  }

  static Future<String> getAddress() async {
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.getEthAddress('$privateKey')
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic res = await Providers.waitJSMessage(tag);
    return res.toString();
  }

  static Future<String> getOneAddress() async {
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.getOneAddress('$privateKey')
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic res = await Providers.waitJSMessage(tag);
    return res.toString();
  }

  static Future<String> getBalance() async {
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.getBalance('$privateKey')
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic res = await Providers.waitJSMessage(tag);
    return res.toString();
  }
}
