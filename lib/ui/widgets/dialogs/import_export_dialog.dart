import 'package:flutter/material.dart';
import 'package:shofar/constants.dart';
import 'package:shofar/main.dart';
import 'package:shofar/providers/wallet_provider.dart';
import 'package:shofar/ui/widgets/text_form.dart';

class ImportExportDialog extends StatefulWidget {
  @override
  _ImportExportDialogState createState() => _ImportExportDialogState();
}

class _ImportExportDialogState extends State<ImportExportDialog> {
  String key = '';
  bool showing = false;
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
              "Import & Export",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "Be careful with your private key.",
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Show private key",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: priText,
                  ),
                  onPressed: () {
                    setState(() {
                      if (showing) {
                        key = '';
                        showing = false;
                      } else {
                        key = WalletProvider.privateKey;
                        showing = true;
                      }
                    });
                  },
                )
              ],
            ),
            Text(
              key,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Import private key",
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              "The new key will override the current account.",
            ),
            SizedBox(
              height: 10,
            ),
            TextForm(
              labelText: "New Private Key",
              hintText: "0xddfa12d531...",
              controller: _privateKeyCtrl,
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
                  child: Text("IMPORT"),
                  color: secText,
                  onPressed: () async {
                    await WalletProvider.init(privKey: _privateKeyCtrl.text);
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeScreenScaffold();
                    }));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextEditingController _privateKeyCtrl;

  @override
  void initState() {
    super.initState();
    _privateKeyCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _privateKeyCtrl.dispose();
    super.dispose();
  }
}
