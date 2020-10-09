import 'package:flutter/material.dart';
import 'package:shofar/providers/campaign_provider.dart';

import 'home_srceen.dart';

class SearchResultScreen extends StatefulWidget {
  final String keyword;

  const SearchResultScreen({Key key, this.keyword}) : super(key: key);
  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  Future<List<String>> campaigns;

  @override
  void initState() {
    super.initState();
    CampaignProvider campaignProvider = CampaignProvider();
    campaigns = campaignProvider.searchTitle(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Color(0xfffefefe),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Text(
                "Search results: ${widget.keyword}",
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 20,
              ),
              CampaignClusterOnBoard(
                title: "Title: ${widget.keyword}",
                future: campaigns,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
