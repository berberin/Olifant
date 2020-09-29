import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shofar/models/update.dart';
import 'package:shofar/providers/providers.dart';

class UpdateProvider {
  Future<List<Update>> getCampaignUpdates(String campaignAddress) async {
    List<Update> updates = List<Update>();

    QuerySnapshot querySnapshot = await Providers.updatesStore
        .doc(campaignAddress)
        .collection("data")
        .get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> json = doc.data();
      Update temp = Update.fromJson(json);
      updates.add(temp);
    }
    return updates;
  }

  Future<void> createCampaignUpdate(
      {Update update, String campaignAddress}) async {
    await Providers.updatesStore
        .doc(campaignAddress)
        .collection("data")
        .add(update.toJson());
  }
}
