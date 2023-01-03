
import 'package:careAsOne/view/widget/image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/app_colors.dart';
import '../../constants/size.dart';
import '../../controller/JobSeeker/news_feed.dart';
import '../../controller/JobSeeker/post_play_video.dart';
import '../../model/news_feed/News_Feed_Model.dart';
import '../Employeer/training_videos.dart';
class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

  // bool isCommentSelected = false;

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsFeedController>(
        init: NewsFeedController(),
        builder: (_) => _.isLoading?Center(child: CircularProgressIndicator(color: AppColors.green,),):
        RefreshIndicator(
          displacement: 200,
          color: AppColors.green,
          onRefresh: () {
            return _.getAllPost();
          },
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.72,
                child: Padding(
                  padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height/10,),
                  child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: _.newsFeedList.length,
                      itemBuilder: (context,i){
                        bool isLike=false;
                        if(_.newsFeedList[i].likeUsers!.any((element) => element.toString()==_.userId.toString())){
                          isLike=true;
                        }
                        return Container(
                          child: Column(
                            children: [
                              Card(
                                margin: EdgeInsets.only(top: 12, left: 5, right: 5, bottom: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            iconSize: 50,
                                            onPressed: () => {
                                            },
                                            icon:CircularCachedImage(
                                              radius:80.0,
                                              imageUrl:_.newsFeedList[i].userImage.toString(),)
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _.newsFeedList[i].userName.toString(),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Wrap(
                                                spacing: 10.0,
                                                children: [
                                                  Text(_.newsFeedList[i].companyName??"",
                                                    style: TextStyle(fontSize: 18.0),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: ReadMoreText(
                                              _.newsFeedList[i].text.toString(),
                                              trimLines: 2,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: 'Show more',
                                              trimExpandedText: 'Show less',
                                              style: TextStyle(fontSize: 18.0, color: Colors.black),
                                              moreStyle: TextStyle(color: Colors.green.shade600, fontSize: 15),
                                              lessStyle: TextStyle(color: Colors.red.shade600, fontSize: 15),
                                            ),
                                            // Text(
                                            //   _.newsFeedList[i].text.toString(),
                                            //   style: TextStyle(fontSize: 18.0, color: Colors.black),
                                            // ),
                                          ),
                                          // Image(image: AssetImage(postData[i].postImage))
                                        ],
                                      ),
                                    ),
                                    if(_.newsFeedList[i].fileType!=null)
                                      (_.newsFeedList[i].fileType.toString()=="video")?
                                      FutureBuilder<ThumbnailResult>(
                                       future: genThumbnail("${_.newsFeedList[i].postFile}"),// specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratioquality: 75,)),
                                       builder: (BuildContext context, AsyncSnapshot snapshot){
                                         if(snapshot.hasData){
                                          final _image=snapshot.data.image;
                                           print("========_image:${_image.runtimeType}===============");
                                           return Container(
                                             height:height(context)*0.3,
                                             child: InkWell(
                                                 onTap: (){
                                                   String url=_.newsFeedList[i].postFile.toString();
                                                   showDialog(
                                                     context: context,
                                                     builder: (_) {
                                                       return dialogPost(url);
                                                     },
                                                     barrierDismissible: true,
                                                     barrierColor: Colors.white.withOpacity(0.9),
                                                   );
                                                 },
                                                 child:Center(
                                                   child: Stack(
                                                     alignment: AlignmentDirectional.center,
                                                     children: [
                                                       _image,
                                                       Positioned(child:  Icon(Icons.play_circle_filled_outlined,size: 60,),)
                                                     ],
                                                   ),
                                                 )

                                                 // Center(child: Icon(Icons.play_circle_filled_outlined,size: 60,))
                                             ),
                                           );
                                         }else{
                                           return Container(
                                               height:height(context)*0.3,
                                               child: Center(child: CircularProgressIndicator(color: AppColors.green,),));
                                         }
                                       },
                                     )
                                          :Container(
                                        child: Center(child: InkWell(
                                            onTap: (){
                                              String url=_.newsFeedList[i].postFile.toString();
                                              showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return Center(
                                                    child: Stack(
                                                      children: [
                                                        Positioned(
                                                          left: 0,
                                                          right: 0,
                                                          top: 0,
                                                          bottom: 0,
                                                          child: InteractiveViewer(
                                                            boundaryMargin: EdgeInsets.all(100),
                                                            minScale: 0.5,
                                                            maxScale: 2,
                                                            child: RectangularCachedImage(imageUrl: url, height:height(context), fit: BoxFit.fitWidth,),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          // left: 0,
                                                          top: 15,
                                                            right: 15,
                                                            child: GestureDetector(
                                                              onTap: (){
                                                                Get.back();
                                                              },
                                                              child: CircleAvatar(
                                                          backgroundColor: Colors.red,
                                                          child: Icon(Icons.clear, color: Colors.white, size: 30,),
                                                        ),
                                                            ))
                                                      ],
                                                    ),
                                                  );
                                                },
                                                barrierDismissible: true,
                                                barrierColor: Colors.white.withOpacity(0.9),
                                              );
                                            },
                                            child: RectangularCachedImage(imageUrl: _.newsFeedList[i].postFile.toString(), height:height(context)*0.3,))),
                                      ),
                                    Card(
                                      // margin: EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 12),
                                      elevation: 0.2,
                                      color: Colors.green.shade100,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        if(isLike){
                                                          print("====userId:${_.userId}=====================");
                                                          _.newsFeedList[i].likeUsers!.removeWhere((element) => element.toString()==_.userId.toString());
                                                        }else{
                                                          _.newsFeedList[i].likeUsers?.add(_.userId);
                                                        }
                                                        setState(() {});
                                                        await _.likePost(_.newsFeedList[i].id).then((respons) {});
                                                      },
                                                      icon: isLike == false ? Icon(Icons.thumb_up_alt_outlined,) : Icon(Icons.thumb_up_off_alt_sharp, color: AppColors.green,),
                                                    ),
                                                    Text(_.newsFeedList[i].likeUsers!.length.toString(),
                                                      style: TextStyle(fontSize: 18.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.message_outlined),
                                                      onPressed:() async {
                                                        // isMsgSelected.value=!isMsgSelected.value;
                                                        // print("----------------isSelected :$isMsgSelected");
                                                        // Get.to(ButtomSheet(newsFeed:_.newsFeedList[i],controller: _,));
                                                        await showDialog(context: context, builder: (context) {
                                                          return ButtomSheet(newsFeed:_.newsFeedList[i],controller: _,);
                                                        });
                                                        setState(() {});
                                                      },
                                                    ),
                                                    Text(_.newsFeedList[i].comments!.length.toString(), style: TextStyle(fontSize: 18.0)),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.share_outlined),
                                                      onPressed:() async {
                                                        String message = "Click to see the post :_\n${_.newsFeedList[i].publicLink} ";
                                                        Share.share(message);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 15,),
                            ],
                          ),);
                      }),
                ),
              ),
              // SizedBox(height:MediaQuery.of(context).size.height/2,)
            ],
          ),
        )
    );
  }
  Widget dialogPost(String url) {
    return SizedBox(
      height: height(context) * 0.7,
      width: width(context) * 0.7,
      child: AlertDialog(

        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        title: GetBuilder<PlayPostVideoController>(
          init: PlayPostVideoController(url),
          builder: (_)=> Container(
            height: height(context) / 3,
            width: width(context),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black26)),
            margin: EdgeInsets.only(
                left: 10, right: 10, top: 10, bottom: 30),
            child: Center(
                child: Chewie(
                  controller: _.chewieController!,
                )),
          ),
        ),
      ),
    );
  }
}
class ButtomSheet extends StatefulWidget {
  final NewsFeedData newsFeed;
  final NewsFeedController controller;
  ButtomSheet({required this.newsFeed,required this.controller});
  @override
  State<ButtomSheet> createState() => _ButtomSheetState();
}
class _ButtomSheetState extends State<ButtomSheet> {
  String replayID="";
  Rx<NewsFeedData> newsFeedList=NewsFeedData().obs;
  NewsFeedController controller=NewsFeedController();
  TextEditingController commentController=TextEditingController();
  TextEditingController replyController=TextEditingController();
  @override
  void initState(){
    newsFeedList.value=widget.newsFeed;
    controller=widget.controller;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    RxBool isreplySelected = false.obs;
    return  SafeArea(
      child: Dismissible(
          direction: DismissDirection.vertical,
          key: const Key('key'),
          onDismissed: (_) => Navigator.pop(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            // ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    color: Colors.green.shade200,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Comments: ${newsFeedList.value.comments!.length}', style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Spacer(),
                        IconButton(onPressed: (){ Get.back();}, icon: Icon(Icons.keyboard_arrow_down_sharp, size: 30,))
                      ],
                    )),
                Expanded(
                  child: Container(
                    color: Colors.green.shade100,
                    child: newsFeedList.value.comments!.isEmpty ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/img.png", height: 100, width: 100, color: Colors.green.withOpacity(0.3),),
                          Text("No Comments Yet", style: TextStyle(color: Colors.green.withOpacity(0.3), fontWeight: FontWeight.bold, fontSize: 20),)
                        ],
                      ),
                    ) : Scrollbar(
                      child: ListView.builder(
                          itemCount:newsFeedList.value.comments!.length ,
                          itemBuilder: (context,index){
                            RxBool isLike=false.obs;
                            RxBool isrply=false.obs;
                            if(newsFeedList.value.comments![index].likeUsers!.any((element) => element.toString()==controller.userId.toString())){
                              isLike.value=true;
                            }
                            return  Obx(() {
                              return ListTile(
                                leading: CircularCachedImage(
                                  imageUrl:newsFeedList.value.comments![index].userImage.toString(),),
                                title: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10) )
                                  ),

                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(newsFeedList.value.comments![index].userName.toString(),
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(newsFeedList.value.comments![index].comment.toString(),
                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey,fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: Colors.grey.shade100,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton.icon(
                                              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.grey.shade700)),
                                              onPressed: () async {
                                                if(isLike.value){
                                                  newsFeedList.value.comments![index].likeUsers!.removeWhere((element) => element.toString()==controller.userId.toString());
                                                  isLike.value=false;
                                                }else{
                                                  newsFeedList.value.comments![index].likeUsers?.add(controller.userId);
                                                  isLike.value=true;
                                                }
                                                await controller.likeComment(newsFeedList.value.comments![index].id).then((respons) {});
                                              },
                                              icon: isLike.value == false ? Icon(Icons.thumb_up_alt_outlined,) : Icon(Icons.thumb_up_off_alt_sharp, color: AppColors.green,),
                                              label: Text(newsFeedList.value.comments![index].likeUsers!.length.toString(),
                                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            TextButton(
                                              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.grey.shade700)),
                                              onPressed:(){
                                                // isMsgSelected = false;
                                                if(replayID== newsFeedList.value.comments![index].id.toString()){
                                                  isreplySelected.value =! isreplySelected.value;
                                                  // print("=======isreplySelected.value:${isreplySelected.value}=======================");
                                                }else{
                                                  isreplySelected.value = true;
                                                }
                                                replayID= newsFeedList.value.comments![index].id.toString();
                                                isrply.value=!isrply.value;
                                              },
                                              child: Row(
                                                children: [
                                                  Text("Reply ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                  Text(newsFeedList.value.comments![index].replies==null?"0":
                                                  newsFeedList.value.comments![index].replies!.length.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Todo Reply Section
                                      (newsFeedList.value.comments![index].replies?.length!=0&&isrply.value) ?

                                      Column(
                                        children: [
                                          Container(
                                            height: newsFeedList.value.comments![index].replies!.length == 1 ? height(context)*0.15 :
                                            newsFeedList.value.comments![index].replies!.length == 2 ? height(context)*0.25 :
                                            newsFeedList.value.comments![index].replies!.length == 3 ? height(context)*0.35 :
                                            newsFeedList.value.comments![index].replies!.length == 4 ? height(context)*0.45 : height(context)*0.55 ,
                                            width: double.infinity,
                                            // decoration: BoxDecoration(
                                            //     color: Colors.white,
                                            //     borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10) )
                                            // ),
                                            child: Scrollbar(
                                                child:ListView.builder(
                                                    itemCount:newsFeedList.value.comments![index].replies!.length,
                                                    itemBuilder: (context,i){
                                                      return  ListTile(
                                                        // tileColor: Colors.green.shade200,
                                                        // shape: RoundedRectangleBorder(),
                                                        // leading: CircularCachedImage(
                                                        //   imageUrl:newsFeedList.value.comments![index].replies![i].userImage.toString(),),
                                                        title: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 8.0),
                                                              child: CircularCachedImage(
                                                                radius: 15,
                                                                imageUrl:newsFeedList.value.comments![index].replies![i].userImage.toString(),),
                                                            ),
                                                            SizedBox(width: 10,),
                                                            Expanded(
                                                              child: Card(
                                                                elevation: 0.2,
                                                                margin: EdgeInsets.zero,
                                                                color: Colors.grey.shade200,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Text(newsFeedList.value.comments![index].replies![i].userName.toString(),
                                                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 15),
                                                                      ),
                                                                      Text(
                                                                        newsFeedList.value.comments![index].replies![i].reply.toString(),
                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        subtitle: SizedBox(height: 5,),
                                                      );
                                                    })
                                            ),
                                          ),
                                          Container(height: 5,color: Colors.white,)
                                        ],
                                      ):SizedBox(),
                                      // SizedBox(height: 5,)
                                    ],
                                  ),
                                ),
                              );
                            });
                          }),
                    ),
                  ),
                ),
                Obx(() {
                  return  Container(
                    color: Colors.green.shade100,
                    child: isreplySelected.value? Form(
                      // key: addComment,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.person,color: AppColors.green, size: 40,),
                          ),
                          title: Scrollbar(
                            child: TextFormField(
                              autofocus:true,
                              controller: replyController,
                              minLines: 1,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    "[a-z A-Z0-9.\n!#%&'*@()<>+/=?^_`{|}~-]"))
                              ],
                              textAlign: TextAlign.start,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 0, top: 6, bottom: 6),
                                hintText: "Add a reply ...",
                                border: InputBorder.none,
                                // prefix: SizedBox(width: 30,),
                                hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              print("========replayID:$replayID====================");
                              // FocusScope.of(context).unfocus();
                              if(replyController.text.isEmpty){
                                return;
                              }else{
                                replyController.clear();
                              await  controller.replyPost(replayID, replyController.text).then((value) {
                                  // newsFeedList.value.comments.in;
                                  for(int i=0; i<newsFeedList.value.comments!.length; i++){
                                    if(newsFeedList.value.comments![i].id.toString()==replayID){
                                      newsFeedList.value.comments![i].replies?.add(value);
                                    }
                                  }
                                  setState(() {});
                                  // newsFeedList.value.comments?.where((element) =>element.id.toString()==replayID);
                                  print("=======screen:${value.userName}===========================");
                                });
                              }

                              ///Post
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ) : Form(
                      // key: addComment,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.person,color: AppColors.green, size: 40,),
                          ),
                          title: Scrollbar(
                            child: TextFormField(
                              // focusNode: FocusScope.of(context),
                              autofocus:true,
                              controller: commentController,
                              minLines: 1,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    "[a-z A-Z0-9.\n!#%&'*@()<>+/=?^_`{|}~-]"))
                              ],
                              textAlign: TextAlign.start,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 0, top: 6, bottom: 6),
                                hintText: "Add a comment ...",
                                border: InputBorder.none,
                                // prefix: SizedBox(width: 30,),
                                hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              // FocusScope.of(context).unfocus();
                              if(commentController.text.isEmpty){
                                return;
                              }else{
                                commentController.clear();
                                await controller.commentPost(newsFeedList.value.id.toString(),commentController.text).then((value){
                                  newsFeedList.value.comments!.add(value);
                                  setState(() {});
                                });
                              }

                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    )
                    ,
                  );
                })
                // SizedBox(height: 10,),

              ],
            ),
          )),
    );
  }
}