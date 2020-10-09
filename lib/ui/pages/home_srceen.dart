import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:shofar/constants.dart';
import 'package:shofar/providers/campaign_provider.dart';
import 'package:shofar/providers/wallet_provider.dart';
import 'package:shofar/ui/pages/search_result_screen.dart';
import 'package:shofar/ui/widgets/avatar.dart';
import 'package:shofar/ui/widgets/campaign_on_board.dart';
import 'package:shofar/ui/widgets/dialogs/custom_dialog.dart';
import 'package:shofar/ui/widgets/dialogs/deposit_dialog.dart';
import 'package:shofar/ui/widgets/dialogs/import_export_dialog.dart';
import 'package:shofar/ui/widgets/dialogs/withdraw_dialog.dart';
import 'package:shofar/ui/widgets/text_form.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<String>> campaigns;
  Future<List<String>> myCampaigns;
  Future<List<String>> myContribute;

  CampaignProvider campaignProvider;
  TextEditingController searchTextCtrl;
  String balance;

  @override
  void initState() {
    super.initState();
    campaignProvider = CampaignProvider();
    campaigns = campaignProvider.getAllCampaignInContract();
    myCampaigns = campaignProvider.getMyCampaignInContract();
    myContribute =
        campaignProvider.getContributedCampaigns(WalletProvider.address);
    WalletProvider.getBalance().then((value) {
      setState(() {
        balance = value;
      });
    });
    searchTextCtrl = TextEditingController();
  }

  @override
  void dispose() {
    searchTextCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: Avatar(
                          svg: WalletProvider.svgAvatar,
                          size: 80,
                        ),
                        onTap: () {
                          showNormalDialog(
                            context: context,
                            widget: ImportExportDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: priText,
                          size: 25,
                        ),
                        onPressed: () {
                          WalletProvider.getBalance().then((value) {
                            setState(() {
                              balance = value;
                            });
                          });
                        },
                      ),
                      Text(
                        balance != null
                            ? double.parse(balance).toStringAsFixed(3) + " ONE"
                            : "------",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonTheme(
                    minWidth: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlineButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red),
                          ),
                          child: Row(children: [
                            Icon(Icons.arrow_upward),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "DEPOSIT",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: priText,
                              ),
                            ),
                          ]),
                          onPressed: () => showNormalDialog(
                            context: context,
                            widget: DepositDialog(),
                          ),
                        ),
                        OutlineButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red),
                          ),
                          child: Row(children: [
                            Icon(Icons.arrow_downward),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "WITHDRAW",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: priText,
                              ),
                            )
                          ]),
                          onPressed: () => showNormalDialog(
                            context: context,
                            widget: WithdrawDialog(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.all(20),
              child: TextForm(
                labelText: "Search campaign",
                hintText: "Campaign\'s title",
                controller: searchTextCtrl,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: priText,
                    size: 27,
                  ),
                  onPressed: () async {
                    if (searchTextCtrl.text == null ||
                        searchTextCtrl.text == '') {
                      return;
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SearchResultScreen(
                        keyword: searchTextCtrl.text,
                      );
                    }));
                  },
                ),
              ),
            ),
            Divider(),
            CampaignClusterOnBoard(
              title: "My Campaigns",
              future: myCampaigns,
            ),
            Divider(),
            CampaignClusterOnBoard(
              title: "My Contributions",
              future: myContribute,
            ),
            Divider(),
            CampaignClusterOnBoard(
              title: "Latest Campaigns",
              future: campaigns,
            ),
          ],
        ),
      ),
    );
  }
}

class CampaignClusterOnBoard extends StatelessWidget {
  final String title;
  final Future<dynamic> future;

  const CampaignClusterOnBoard({Key key, this.title, this.future})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        FutureBuilder(
          future: future,
          builder: (context, campaignSnap) {
            if (campaignSnap.connectionState == ConnectionState.none ||
                campaignSnap.hasData == null) {
              return AsyncSpinKit();
            }
            if (campaignSnap.hasData) {
              print(campaignSnap.data);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.from(List<Widget>.from(campaignSnap.data
                        .map((camp) => CampaignOnBoard(
                              campaignAddress: camp,
                            ))
                        .toList())
                    .reversed),
              );
//                return ListView.builder(
//                  physics: BouncingScrollPhysics(),
//                  itemCount: campaignSnap.data.length,
//                  itemBuilder: (BuildContext ctx, int index) {
//                    return CampaignOnBoard(
//                      campaign: campaignSnap.data[index],
//                    );
//                  },
//                );
            }
            return AsyncSpinKit();
          },
        )
      ],
    );
  }
}
