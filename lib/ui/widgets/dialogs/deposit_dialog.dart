import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';
import 'package:shofar/constants.dart';
import 'package:shofar/providers/wallet_provider.dart';

class DepositDialog extends StatelessWidget {
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
              "Deposit",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text("Please send ONE tokens to this address."),
            SizedBox(
              height: 20,
            ),
            Text("ONE address", style: Theme.of(context).textTheme.headline6),
            SelectableText(
              WalletProvider.oneAddress,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrettyQr(
                  typeNumber: 3,
                  size: 200,
                  data: WalletProvider.oneAddress,
                  errorCorrectLevel: QrErrorCorrectLevel.M,
                  roundEdges: true,
                  elementColor: priText,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
