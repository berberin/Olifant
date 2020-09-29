import 'package:flutter/material.dart';
import 'package:shofar/constants.dart';
import 'package:shofar/models/update.dart';
import 'package:shofar/providers/update_provider.dart';
import 'package:shofar/providers/wallet_provider.dart';
import 'package:shofar/ui/widgets/dialogs/custom_dialog.dart';
import 'package:shofar/ui/widgets/text_form.dart';

class UpdateDialog extends StatefulWidget {
  String campaignAddress;
  List<Update> updates;

  UpdateDialog({this.campaignAddress, this.updates});

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
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
              "Submit an update",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text("What\'s new?"),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            TextForm(
              labelText: "Title",
              controller: titleCtrl,
            ),
            SizedBox(
              height: 10,
            ),
            TextForm(
              labelText: "Content",
              controller: contentCtrl,
              maxline: 5,
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
                  child: Text("UPDATE"),
                  color: secText,
                  onPressed: () async {
                    showLoadingDialog(context);
                    bool res;
                    try {
                      Update temp = Update(
                        owner: WalletProvider.address,
                        title: titleCtrl.text,
                        content: contentCtrl.text,
                        fingerprint: WalletProvider.hashed,
                      );
                      await updateProvider.createCampaignUpdate(
                        update: temp,
                        campaignAddress: widget.campaignAddress,
                      );
                      widget.updates.add(temp);
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

  TextEditingController titleCtrl;
  TextEditingController contentCtrl;
  UpdateProvider updateProvider;

  @override
  void initState() {
    super.initState();
    contentCtrl = TextEditingController();
    titleCtrl = TextEditingController();
    updateProvider = UpdateProvider();
  }

  @override
  void dispose() {
    contentCtrl.dispose();
    titleCtrl.dispose();
    super.dispose();
  }
}
