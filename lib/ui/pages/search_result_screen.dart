import 'package:flutter/material.dart';

class SearchResultScreen extends StatefulWidget {
  final List<String> campaigns;

  const SearchResultScreen({Key key, this.campaigns}) : super(key: key);
  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Search screen"),
    );
  }
}
