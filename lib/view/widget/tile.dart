import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'image.dart';
import 'text.dart';

class FilterTile extends StatelessWidget {
  final String? title;
  final String? value;
  final bool underline;
  final VoidCallback? onTap;
  final Widget? container;
  final Widget? trailing;

  FilterTile(
      {this.title,
      this.trailing,
      this.container,
      this.value,
      this.underline = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'NEWEST';
    List<String> list = [];
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: SubText(title.toString().toUpperCase(),
                        size: 12.0, color: AppColors.green)),
                Expanded(
                  child:
                      Align(alignment: Alignment.centerRight, child: container),
                ),
              ],
            ),
            trailing: trailing,
          ),
          if (underline) Divider(height: 0.0),
          if (underline) SizedBox(height: 5.0),
        ],
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String? name;
  final String? profileImage;
  final String? lastMsg;
  final String? lastSeen;
  final int? unReadMsg;
  final bool? isOnline;
  final bool? hasReceived;
  final bool? hasRead;

  ChatTile({
    this.name,
    this.profileImage,
    this.lastMsg,
    this.lastSeen,
    this.unReadMsg,
    this.isOnline,
    this.hasReceived,
    this.hasRead,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: ListTile(
              horizontalTitleGap: 0,
              contentPadding: const EdgeInsets.all(0.0),
              leading: Stack(
                children: [
                  CircularCachedImage(
                      radius: 16.0,
                      imageUrl:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRA6eicE4jNjMgF1lREUukyVT3BW0nnMyf81dznts1JZzyKjlMXEfxO8yTrdFBrK62J7AY&usqp=CAU'),
                  Positioned(
                    right: 5.0,
                    child: CircleAvatar(
                        radius: 3.0, backgroundColor: AppColors.green),
                  ),
                ],
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SubText('Bernard Shaw',
                          size: 16.0,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.topRight,
                          child: SubText('20 MIN AGO',
                              size: 10.0, colorOpacity: 0.5))),
                ],
              ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: SubText(
                      'Lorem ipsum is a dummy text used for industrial purposes',
                      size: 12.0,
                      maxLines: 2,
                      colorOpacity: 0.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: Center(
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: AppColors.green,
                        child: SubText('2',
                            size: 10.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white),
                      ),

                      // child: Icon(Icons.check_circle_outline,
                      //     size: 16.0, color: AppColors.black.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0.0),
        ],
      ),
    );
  }
}
