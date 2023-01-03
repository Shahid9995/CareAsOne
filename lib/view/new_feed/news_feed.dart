import 'package:careAsOne/view/new_feed/post.dart';
import 'package:careAsOne/view/new_feed/postbar.dart';
import 'package:flutter/material.dart';

class NewsFeed extends StatefulWidget {
  NewsFeed({Key? key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}
class _NewsFeedState extends State<NewsFeed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(top: 8.0),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Postbar(),
          Divider(thickness: 1, color: Colors.black12),
          Post(),
        ],
      ),
    );
  }
}
