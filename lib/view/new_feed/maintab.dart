import 'package:careAsOne/constants/size.dart';
import 'package:flutter/material.dart';

import 'my_post.dart';
import 'news_feed.dart';
class MainTab extends StatefulWidget {
  MainTab({Key? key}) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Tab> topTabs = <Tab>[
    Tab(icon: Icon(Icons.newspaper, color: Colors.green,),
    text: "News Feed",
    ),
    Tab(icon: Icon(Icons.post_add, color: Colors.green,),
      text: "My Post",
    ),
  ];

  @override
  void initState() {
    _tabController =
        TabController(length: topTabs.length, initialIndex: 0, vsync: this)
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context),
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.green,
              controller: _tabController,
              indicatorColor: Colors.green,
              tabs: topTabs,
            ),
            Expanded(
              // height: height(context)/1.3,
              child: TabBarView(
                controller: _tabController,
                children: [
                  NewsFeed(),
                  MyPost(),
                ],
              ),
            ),
          ],
        ),
      );

  }
}
