import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../model/news_feed/News_Feed_Model.dart';

class MyRepo{
  static Rx<NewsFeedModel> newsFeedModel=NewsFeedModel().obs;
}