import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shofar/main.dart';
import 'package:shofar/models/campaign.dart';
import 'package:shofar/models/comment.dart';
import 'package:shofar/models/update.dart';
import 'package:shofar/providers/campaign_provider.dart';
import 'package:shofar/providers/comment_provider.dart';
import 'package:shofar/providers/update_provider.dart';
import 'package:shofar/providers/wallet_provider.dart';
import 'package:shofar/ui/widgets/avatar.dart';
import 'package:shofar/ui/widgets/comments_col.dart';
import 'package:shofar/ui/widgets/dialogs/comment_dialog.dart';
import 'package:shofar/ui/widgets/dialogs/custom_dialog.dart';
import 'package:shofar/ui/widgets/dialogs/funding_dialog.dart';
import 'package:shofar/ui/widgets/dialogs/update_dialog.dart';
import 'package:shofar/ui/widgets/updates_col.dart';
import 'package:shofar/utils/date_cal.dart';
import 'package:shofar/utils/fund_display.dart';

import '../../constants.dart';

class CampaignDetailScreen extends StatefulWidget {
  final Campaign campaign;

  const CampaignDetailScreen({Key key, this.campaign}) : super(key: key);
  @override
  _CampaignDetailScreenState createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  List<String> backers;
  CampaignProvider campaignProvider;
  CommentProvider commentProvider;
  UpdateProvider updateProvider;
  List<Update> updates;
  List<Comment> comments;
  @override
  void initState() {
    super.initState();
    campaignProvider = CampaignProvider();
    updateProvider = UpdateProvider();
    commentProvider = CommentProvider();
    campaignProvider.getAllContributors(widget.campaign.address).then((value) {
      setState(() {
        backers = value;
      });
    });
    commentProvider.getCampaignComments(widget.campaign.address).then((value) {
      comments = value;
      setState(() {});
    });
    updateProvider.getCampaignUpdates(widget.campaign.address).then((value) {
      updates = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreenScaffold()),
        );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xfffefefe),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await showNormalDialog(
                context: context,
                widget: FundingDialog(
                  campaignAddress: widget.campaign.address,
                ),
              );
              setState(() {});
            },
            child: Icon(Icons.attach_money),
            tooltip: "Become a backer!",
            backgroundColor: secText,
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    widget.campaign.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.campaign.title,
                        style: Theme.of(context).textTheme.headline5,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 50,
                        animation: true,
                        lineHeight: 5.0,
                        animationDuration: 1500,
                        percent: (widget.campaign.currentFund /
                                    widget.campaign.targetFund) <=
                                1
                            ? widget.campaign.currentFund /
                                widget.campaign.targetFund
                            : 1,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: widget.campaign.completed
                            ? Colors.green[400]
                            : secText,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          miniWidget(
                            icon: Icons.monetization_on,
                            boldText: widget.campaign.completed
                                ? fundToDisplay(
                                    widget.campaign.currentFund.toDouble() /
                                        (pow(10, 18)))
                                : fundToDisplay((widget.campaign.targetFund -
                                            widget.campaign.currentFund)
                                        .toDouble() /
                                    (pow(10, 18))),
                            subText: widget.campaign.completed
                                ? "Total"
                                : "ONE to finish",
                            textTheme: Theme.of(context).textTheme,
                          ),
                          miniWidget(
                            icon: Icons.people,
                            boldText: backers != null
                                ? backers.length.toString()
                                : "---",
                            subText: "Backers",
                            textTheme: Theme.of(context).textTheme,
                          ),
                          miniWidget(
                            icon: Icons.access_time,
                            boldText: daysRemaining(widget.campaign.due) >= 0
                                ? daysRemaining(widget.campaign.due).toString()
                                : "Time up",
                            subText: daysRemaining(widget.campaign.due) >= 0
                                ? "Days to go"
                                : "Failed",
                            textTheme: Theme.of(context).textTheme,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Owner:'),
                      Row(
                        children: [
                          Avatar(
                            svg: Jdenticon.toSvg(widget.campaign.owner),
                            size: 25,
                          ),
                          Text(
                            widget.campaign.owner,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: 13,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Text('Contract Address:'),
                      Row(
                        children: [
                          Avatar(
                            svg: Jdenticon.toSvg(widget.campaign.address),
                            size: 25,
                          ),
                          Text(
                            widget.campaign.address,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: 13,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          widget.campaign.completed
                              ? RaisedButton(
                                  disabledColor: Colors.green[300],
                                  child: Text("SUCCESS!"),
                                )
                              : (daysRemaining(widget.campaign.due) < 0)
                                  ? RaisedButton(
                                      disabledColor: Colors.red[300],
                                      child: Text("FAIL"),
                                    )
                                  : Container(),
                          (widget.campaign.completed &&
                                  widget.campaign.owner ==
                                      WalletProvider.address)
                              ? RaisedButton(
                                  color: secText,
                                  child: Text("CLAIM"),
                                  onPressed: () async {
                                    showLoadingDialog(context);
                                    bool res;
                                    try {
                                      res = await WalletProvider.claim(
                                          WalletProvider.privateKey,
                                          widget.campaign.address);
                                    } catch (e) {
                                      print(e);
                                      res = false;
                                    }
                                    Navigator.pop(context);

                                    showNormalDialog(
                                      usePreDialog: false,
                                      context: context,
                                      widget: AlertDialog(
                                        title: Text((res == true)
                                            ? "Success"
                                            : "Error"),
                                        content: Text((res == true)
                                            ? "Claim successfully."
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
                                )
                              : Container(),
                          (!widget.campaign.completed &&
                                  daysRemaining(widget.campaign.due) < 0 &&
                                  (backers == null
                                      ? false
                                      : backers
                                          .contains(WalletProvider.address)))
                              ? RaisedButton(
                                  color: secText,
                                  child: Text("GET BACK MY MONEY"),
                                  onPressed: () async {
                                    showLoadingDialog(context);
                                    bool res;
                                    try {
                                      res = await WalletProvider.refund(
                                          WalletProvider.privateKey,
                                          widget.campaign.address);
                                    } catch (e) {
                                      print(e);
                                      res = false;
                                    }
                                    Navigator.pop(context);

                                    showNormalDialog(
                                      usePreDialog: false,
                                      context: context,
                                      widget: AlertDialog(
                                        title: Text((res == true)
                                            ? "Success"
                                            : "Error"),
                                        content: Text((res == true)
                                            ? "Process successfully."
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
                                )
                              : Container(),
                        ],
                      ),
                      Text(
                        "About this project",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        widget.campaign.description,
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ExpansionTile(
                        childrenPadding: EdgeInsets.all(0),
                        tilePadding: EdgeInsets.all(0),
                        title: Text(
                          "Updates (${updates != null ? updates.length : 0})",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        children: [
                          UpdatesColumn(
                            updates: updates,
                          ),
                          widget.campaign.owner == WalletProvider.address
                              ? OutlineButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Text("Update"),
                                  onPressed: () async {
                                    await showNormalDialog(
                                      context: context,
                                      widget: UpdateDialog(
                                        campaignAddress:
                                            widget.campaign.address,
                                        updates: updates,
                                      ),
                                    );
                                    setState(() {});
                                  },
                                )
                              : Container()
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ExpansionTile(
                        childrenPadding: EdgeInsets.all(0),
                        tilePadding: EdgeInsets.all(0),
                        title: Text(
                          "Comments (${comments != null ? comments.length : 0})",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        children: [
                          CommentsColumn(
                            comments: comments,
                          ),
                          OutlineButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Text("Comment"),
                            onPressed: () async {
                              await showNormalDialog(
                                context: context,
                                widget: CommentDialog(
                                  campaignAddress: widget.campaign.address,
                                  comments: comments,
                                ),
                              );
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget miniWidget(
      {IconData icon, String boldText, String subText, TextTheme textTheme}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              boldText,
              style: textTheme.headline4.copyWith(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              subText,
              style: textTheme.bodyText1,
            ),
          ],
        )
      ],
    );
  }
}
