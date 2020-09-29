import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shofar/models/campaign.dart';
import 'package:shofar/providers/campaign_provider.dart';
import 'package:shofar/ui/pages/campaign_details_screen.dart';
import 'package:shofar/ui/widgets/dialogs/custom_dialog.dart';
import 'package:shofar/utils/date_cal.dart';
import 'package:shofar/utils/fund_display.dart';

import '../../constants.dart';
import 'avatar.dart';

class CampaignOnBoard extends StatefulWidget {
  final String campaignAddress;

  const CampaignOnBoard({Key key, @required this.campaignAddress})
      : super(key: key);

  @override
  _CampaignOnBoardState createState() => _CampaignOnBoardState();
}

class _CampaignOnBoardState extends State<CampaignOnBoard> {
  Future<Campaign> campaign;
  CampaignProvider campaignProvider;
  int backer;

  @override
  void initState() {
    super.initState();
    campaignProvider = CampaignProvider();

    campaign = campaignProvider.getCampaign(widget.campaignAddress);
    campaignProvider.getAllContributors(widget.campaignAddress).then((value) {
      setState(() {
        backer = value.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: campaign,
      builder: (context, campaignSnap) {
        if (campaignSnap.connectionState == ConnectionState.none ||
            campaignSnap.hasData == null) {
          return AsyncSpinKit();
        }
        if (campaignSnap.hasData) {
          return Wrap(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CampaignDetailScreen(
                        campaign: campaignSnap.data,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: PhysicalModel(
                    color: Colors.white,
                    elevation: 3,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              campaignSnap.data.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Avatar(
                                      svg: Jdenticon.toSvg(
                                          campaignSnap.data.owner),
                                      size: 25,
                                    ),
                                    Text(
                                      campaignSnap.data.owner,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 13,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  campaignSnap.data.title,
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
                                  percent: (campaignSnap.data.currentFund /
                                              campaignSnap.data.targetFund) <=
                                          1
                                      ? campaignSnap.data.currentFund /
                                          campaignSnap.data.targetFund
                                      : 1,
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: campaignSnap.data.completed
                                      ? Colors.green[400]
                                      : secText,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    miniWidget(
                                      icon: Icons.monetization_on,
                                      boldText: campaignSnap.data.completed
                                          ? fundToDisplay(campaignSnap
                                                  .data.currentFund
                                                  .toDouble() /
                                              (pow(10, 18)))
                                          : fundToDisplay(
                                              (campaignSnap.data.targetFund -
                                                          campaignSnap
                                                              .data.currentFund)
                                                      .toDouble() /
                                                  (pow(10, 18))),
                                      subText: campaignSnap.data.completed
                                          ? "Total"
                                          : "ONE to finish",
                                      textTheme: Theme.of(context).textTheme,
                                    ),
                                    miniWidget(
                                      icon: Icons.people,
                                      boldText: backer != null
                                          ? backer.toString()
                                          : "---",
                                      subText: "Backers",
                                      textTheme: Theme.of(context).textTheme,
                                    ),
                                    miniWidget(
                                      icon: Icons.access_time,
                                      boldText: daysRemaining(
                                                  campaignSnap.data.due) >=
                                              0
                                          ? daysRemaining(campaignSnap.data.due)
                                              .toString()
                                          : "Time up",
                                      subText: daysRemaining(
                                                  campaignSnap.data.due) >=
                                              0
                                          ? "Days to go"
                                          : campaignSnap.data.completed
                                              ? "Success"
                                              : "Fail",
                                      textTheme: Theme.of(context).textTheme,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return AsyncSpinKit();
      },
    );
  }

  Widget miniWidget(
      {IconData icon, String boldText, String subText, TextTheme textTheme}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: priText,
        ),
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
