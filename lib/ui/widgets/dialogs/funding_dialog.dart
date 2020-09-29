import 'package:flutter/material.dart';
import 'package:shofar/constants.dart';
import 'package:shofar/providers/campaign_provider.dart';
import 'package:shofar/providers/wallet_provider.dart';
import 'package:shofar/ui/widgets/dialogs/custom_dialog.dart';
import 'package:shofar/ui/widgets/text_form.dart';

class FundingDialog extends StatefulWidget {
  String campaignAddress;

  FundingDialog({this.campaignAddress});

  @override
  _FundingDialogState createState() => _FundingDialogState();
}

class _FundingDialogState extends State<FundingDialog> {
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
              "Fund",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            TextForm(
              labelText: "Amount to fund this project (in ONE)",
              controller: amountCtrl,
              keyboardType: TextInputType.number,
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
                  child: Text("FUND"),
                  color: secText,
                  onPressed: () async {
                    showLoadingDialog(context);
                    bool res;
                    try {
                      res = await WalletProvider.donate(
                        WalletProvider.privateKey,
                        widget.campaignAddress,
                        double.parse(amountCtrl.text),
                      );
                    } catch (e) {
                      print(e);
                      res = false;
                    }
                    Navigator.pop(context);
                    showNormalDialog(
                      usePreDialog: false,
                      context: context,
                      widget: AlertDialog(
                        title: Text((res == true) ? "Success" : "Error"),
                        content: Text((res == true)
                            ? "Fund successfully."
                            : "Some errors occur. Please try again later."),
                        actions: [
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextEditingController amountCtrl;
  CampaignProvider campaignProvider;

  @override
  void initState() {
    super.initState();
    amountCtrl = TextEditingController();
    campaignProvider = CampaignProvider();
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    super.dispose();
  }
}
