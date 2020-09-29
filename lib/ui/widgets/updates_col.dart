import 'package:flutter/material.dart';
import 'package:shofar/models/update.dart';

class UpdatesColumn extends StatefulWidget {
  final List<Update> updates;

  const UpdatesColumn({Key key, this.updates}) : super(key: key);
  @override
  _UpdatesColumnState createState() => _UpdatesColumnState();
}

class _UpdatesColumnState extends State<UpdatesColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.from(widget.updates
          .map((e) => UpdateWidget(
              title: e.title,
              content: e.content,
              textTheme: Theme.of(context).textTheme))
          .toList()),
    );
  }
}

class UpdateWidget extends StatelessWidget {
  final String title;
  final String content;
  final TextTheme textTheme;

  const UpdateWidget({Key key, this.title, this.content, this.textTheme})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.headline5,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            content,
            style: textTheme.bodyText1,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
