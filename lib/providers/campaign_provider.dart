import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:shofar/models/campaign.dart';
import 'package:shofar/providers/providers.dart';
import 'package:shofar/providers/wallet_provider.dart';
import 'package:shofar/ui/pages/add_campaign_screen.dart';
import 'package:shofar/utils/date_cal.dart';
import 'package:shofar/utils/filter_list.dart';

class CampaignProvider {
  static init() {}

  // done: get all campaign address in contract
  Future<List<String>> getAllCampaignInContract() async {
    String tag = randomAlpha(5);
    List<String> campaignsAddress = List<String>();
    Providers.jsContext.evalJavascript("""
      contract.getAllCampaigns()
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic json = await Providers.waitJSMessage(tag);

    //try {
    for (var s in json) {
      campaignsAddress.add(s.toString());
    }
    //} catch (e) {
    // print(e);
    //}

    return campaignsAddress;
  }

  // done: get my campaigns in contract()
  Future<List<String>> getMyCampaignInContract() async {
    List<String> campaignsAddress;
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.getMyCampaigns('${WalletProvider.address}')
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic json = await Providers.waitJSMessage(tag);
    try {
      campaignsAddress = List<String>.from(json);
    } catch (e) {
      print(e);
    }
    return campaignsAddress;
  }

  // done: get campaign info
  Future<CampaignOnContract> getCampaignInfoOnContract(
      String campaignAddress) async {
    String tag = randomAlpha(5);
    CampaignOnContract campaignOnContract;
    Providers.jsContext.evalJavascript("""
      contract.getCampaignInfo('$campaignAddress')
        .then(
          value => {
            nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
          }
        );
    """);
    dynamic res = await Providers.waitJSMessage(tag);
    print(res);
    try {
      Map<String, dynamic> jsonMap = Map<String, dynamic>.from(res);
      campaignOnContract = CampaignOnContract.fromJson(jsonMap);
    } catch (e) {
      print(e);
    }
    return campaignOnContract;
  }

  // done: createCampaignOnContract
  Future<bool> createCampaignOnContract({
    String targetFund,
    String timeLock,
    String minimumContribution: '1000000000',
    String privateKey,
  }) async {
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.createCampaign('$targetFund', '$timeLock', '$minimumContribution', '$privateKey')
        .then(
          value => {
            nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
          }
        );
    """);
    dynamic res = await Providers.waitJSMessage(tag);
    print(res.toString());
    if (res.toString().contains('error')) {
      return false;
    }
    return true;
  }

  Future<void> createCampaignOnFB(
      {CampaignOnFB campaign, String campaignAddress}) async {
    await Providers.campaignsStore.doc(campaignAddress).set(campaign.toJson());
  }

  Future<bool> createCampaign({
    String title,
    String imageUrl,
    String description,
    double targetFund,
    DateTime due,
  }) async {
    List<String> oldList = await getMyCampaignInContract();
    bool ok = await createCampaignOnContract(
      targetFund: (targetFund * pow(10, 18)).floor().toString(),
      timeLock: (due.millisecondsSinceEpoch).toString(),
      privateKey: WalletProvider.privateKey,
    );
    print(WalletProvider.privateKey);
    if (!ok) {
      return false;
    }
    List<String> newList = await getMyCampaignInContract();

    String campaignAddress = getNewElement(oldList, newList);
    if (campaignAddress == null) {
      throw Exception("Cannot get new campaign address");
    }

    await createCampaignOnFB(
      campaign: CampaignOnFB(
          owner: WalletProvider.address,
          coverUrl: imageUrl,
          title: title,
          description: description),
      campaignAddress: campaignAddress,
    );

    return true;
  }

  Future<Campaign> getCampaign(String campaignAddress) async {
    Campaign campaign;
    CampaignOnContract inContract =
        await getCampaignInfoOnContract(campaignAddress);

    CampaignOnFB inFB;
    try {
      inFB = await getCampaignInFB(campaignAddress);
    } catch (e) {
      print(e);
      inFB = CampaignOnFB();
    }
    // todo: handle inFB == null

    campaign = Campaign(
      owner: inContract.owner,
      address: campaignAddress,
      title: inFB.title ?? "Dummy campaign",
      description: inFB.description ?? "No description.",
      imageUrl: inFB.coverUrl ?? defaultImageUrl,
      targetFund: inContract.targetFund,
      currentFund: inContract.currentFund,
      completed: inContract.completed,
      due: timeStampToDateTime(inContract.timeLock),
    );
    return campaign;
  }

  // done: getAllContributors
  Future<List<String>> getAllContributors(String campaignAddress) async {
    List<String> addresses;
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.getAllContributors('$campaignAddress')
        .then(
          value => {
            nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
          }
        );
    """);
    dynamic res = await Providers.waitJSMessage(tag);
    addresses = List<String>.from(res);
    return addresses;
  }

  // done: getContribution
  Future<int> getContribution(
    String campaignAddress,
    String userAddress,
  ) async {
    int contribution;
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.getContribution('$campaignAddress', '$userAddress')
        .then(
          value => {
            nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
          }
        );
    """);
    dynamic res = await Providers.waitJSMessage(tag);
    print(res);
    contribution = int.parse(res.toString());
    return contribution;
  }

  // done: contributed Campaign
  Future<List<String>> getContributedCampaigns(String userAddress) async {
    List<String> campaigns;
    String tag = randomAlpha(5);
    Providers.jsContext.evalJavascript("""
      contract.getContributedCampaigns('$userAddress')
      .then(
        value => {
          nativeCommunicator.postMessage(JSON.stringify({tag: '$tag', data: value}));
        }
      );
    """);
    dynamic json = await Providers.waitJSMessage(tag);
    try {
      campaigns = List<String>.from(json);
    } catch (e) {
      print(e);
    }
    return campaigns;
  }

  Future<List<String>> searchTitle(String search) async {
    List<String> res = List<String>();
    QuerySnapshot querySnapshot = await Providers.campaignsStore
        .where('title', isGreaterThanOrEqualTo: search)
        .get();
    for (var doc in querySnapshot.docs) {
      res.add(doc.id);
    }
    return res;
  }

  Future<CampaignOnFB> getCampaignInFB(String campaignAddress) async {
    Map<String, dynamic> json;
    DocumentSnapshot documentSnapshot =
        await Providers.campaignsStore.doc(campaignAddress).get();
    json = documentSnapshot.data();
    return CampaignOnFB.fromJson(json);
  }
}
