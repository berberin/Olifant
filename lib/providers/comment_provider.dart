import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shofar/models/comment.dart';
import 'package:shofar/providers/providers.dart';

class CommentProvider {
  Future<List<Comment>> getCampaignComments(String campaignAddress) async {
    List<Comment> comments = List<Comment>();

    QuerySnapshot querySnapshot = await Providers.commentsStore
        .doc(campaignAddress)
        .collection("data")
        .get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> json = doc.data();
      Comment temp = Comment.fromJson(json);
      comments.add(temp);
    }
    return comments;
  }

  Future<void> createCampaignComments(
      {Comment comment, String campaignAddress}) async {
    await Providers.commentsStore
        .doc(campaignAddress)
        .collection("data")
        .add(comment.toJson());
  }
}
