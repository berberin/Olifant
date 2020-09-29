import 'package:flutter/material.dart';
import 'package:shofar/constants.dart';
import 'package:shofar/models/comment.dart';
import 'package:shofar/providers/comment_provider.dart';
import 'package:shofar/providers/wallet_provider.dart';
import 'package:shofar/ui/widgets/dialogs/custom_dialog.dart';
import 'package:shofar/ui/widgets/text_form.dart';

class CommentDialog extends StatefulWidget {
  String campaignAddress;
  List<Comment> comments;

  CommentDialog({this.campaignAddress, this.comments});

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Comment",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            TextForm(
              labelText: "Comment",
              controller: commentCtrl,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlineButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text("COMMENT"),
                  color: secText,
                  onPressed: () async {
                    showLoadingDialog(context);
                    bool res;
                    try {
                      Comment temp = Comment(
                        owner: WalletProvider.address,
                        content: commentCtrl.text,
                        fingerprint: WalletProvider.hashed,
                      );
                      await commentProvider.createCampaignComments(
                        comment: temp,
                        campaignAddress: widget.campaignAddress,
                      );
                      widget.comments.add(temp);
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextEditingController commentCtrl;
  CommentProvider commentProvider;

  @override
  void initState() {
    super.initState();
    commentCtrl = TextEditingController();
    commentProvider = CommentProvider();
  }

  @override
  void dispose() {
    commentCtrl.dispose();
    super.dispose();
  }
}
