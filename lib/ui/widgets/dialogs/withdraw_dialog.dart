import 'package:flutter/material.dart';
import 'package:shofar/constants.dart';
import 'package:shofar/providers/wallet_provider.dart';
import 'package:shofar/ui/widgets/dialogs/custom_dialog.dart';
import 'package:shofar/ui/widgets/text_form.dart';

class WithdrawDialog extends StatefulWidget {
  @override
  _WithdrawDialogState createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
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
              "Withdraw",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "Please enter ONE address and amount to send.\nThis process cannot be undone.",
            ),
            SizedBox(
              height: 20,
            ),
            Text("Receiver", style: Theme.of(context).textTheme.headline6),
            SizedBox(
              height: 10,
            ),
            TextForm(
              labelText: "Send ONE to this Address:",
              hintText: "one1m77t7p6ug...",
              controller: _addressToSendCtrl,
            ),
            SizedBox(
              height: 10,
            ),
            TextForm(
              labelText: "Amount (in ONE)",
              keyboardType: TextInputType.number,
              controller: _amountToSendCtrl,
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
                  child: Text("SEND"),
                  color: secText,
                  onPressed: () async {
                    showLoadingDialog(context);
                    bool res;
                    try {
                      res = await WalletProvider.transferOne(
                        WalletProvider.privateKey,
                        _addressToSendCtrl.text,
                        double.parse(_amountToSendCtrl.text),
                      );
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pop(context);

                    showNormalDialog(
                      usePreDialog: false,
                      context: context,
                      widget: AlertDialog(
                        title: Text((res == true) ? "Success" : "Error"),
                        content: Text((res == true)
                            ? "Transfer successfully."
                            : "Some errors occur. Please try again later or export private key."),
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

  TextEditingController _addressToSendCtrl;
  TextEditingController _amountToSendCtrl;
  @override
  void initState() {
    super.initState();
    _addressToSendCtrl = TextEditingController();
    _amountToSendCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _addressToSendCtrl.dispose();
    _amountToSendCtrl.dispose();
    super.dispose();
  }
}
