import 'package:flutter/material.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:shofar/models/comment.dart';

import 'avatar.dart';

class CommentsColumn extends StatefulWidget {
  final List<Comment> comments;

  const CommentsColumn({Key key, this.comments}) : super(key: key);

  @override
  _CommentsColumnState createState() => _CommentsColumnState();
}

class _CommentsColumnState extends State<CommentsColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.from(widget.comments
          .map((e) => CommentWidget(
                owner: e.owner,
                content: e.content,
                textTheme: Theme.of(context).textTheme,
              ))
          .toList()),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final String content;
  final String owner;
  final TextTheme textTheme;

  const CommentWidget({Key key, this.content, this.owner, this.textTheme})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(
                svg: Jdenticon.toSvg(owner),
                size: 15,
              ),
              Text(
                owner,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 11,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          // SizedBox(
          //   height: 20,
          // ),
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
