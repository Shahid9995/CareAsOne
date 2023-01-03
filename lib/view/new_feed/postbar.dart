import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_colors.dart';
import '../../constants/size.dart';
import '../../controller/JobSeeker/news_feed.dart';

class Postbar extends StatefulWidget {
  const Postbar({Key? key}) : super(key: key);
  @override
  State<Postbar> createState() => _PostbarState();
}
class _PostbarState extends State<Postbar> {

  // PickedFile? imageFile;
  // String? imgUrl;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFileList;
  List<XFile>? _videoFileList;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsFeedController>(
      init:NewsFeedController(),
        builder: (controller)=>Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            iconSize: 50,
            onPressed: () => print('User Avatar Clicked'),
            icon:Icon(Icons.person,color: AppColors.green,)
          // CircleAvatar(
          //   radius: 80.0,
          //   backgroundImage: AssetImage('images/user/sonam.jpg'),
          // ),
        ),
        CupertinoButton(
          onPressed: () => {
            showDialog(
              context: context,
              builder: (_) {
                return dialogPost(controller);
              },
              barrierDismissible: false,
              barrierColor: Colors.white.withOpacity(0.9),
            )
          },
          child: Text(
            "What's on your mind ?",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ),
      ],
    ));
  }
  Widget dialogPost(NewsFeedController cont) {
    RxBool isImgSelected = false.obs;
    RxBool isvideoSelected = false.obs;
    RxBool isCLearList = false.obs;
    TextEditingController text=TextEditingController();
    return Obx(() => SizedBox(
      height: height(context) * 0.7,
      width: width(context) * 0.7,
      child: AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        title: Text(
          "Write Post",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
        ),
        content: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
          child: SizedBox(
            height: height(context) * 0.42,
            width: width(context) * 0.8,
            child: ListView(
              shrinkWrap: true,
              // mainAxisSize: MainAxisSize.min,
              children: [
                isImgSelected.value == true || isvideoSelected.value == true ?
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    isImgSelected.value == true ?
                   await pickedImage(ImageSource.gallery) :await pickedVideo(ImageSource.gallery);
                    isImgSelected.value = false;
                    isvideoSelected.value = false;
                    print(_imageFileList.toString()+"===================================");
                    setState(() {});
                  },
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_upload_outlined, color: Colors.white, size: 40,),
                        Text(isImgSelected.value == true ? "Upload Image" :
                        isvideoSelected.value == true ? "Upload Video" : "",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                      ],
                    ),
                  ),
                ) :
                Scrollbar(
                  child: TextFormField(
                    controller: text,
                    maxLines: 10,
                    decoration: InputDecoration(
                      // filled: true,
                        hoverColor: Colors.red,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            )),
                        hintText: "Write Something Here"),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    isCLearList.value==false?
                    _imageFileList != null?
                    Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:MediaQuery.of(context).size.width*0.6,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child:Text("${_imageFileList!.path.split("/").last}")
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                isCLearList.value=true;
                                _imageFileList=null;
                                print("=========_imageFileList:$_imageFileList===============");
                                print("=========_imageFileList:${ isCLearList.value}===============");
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(Icons.delete,color: Colors.red,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ) :SizedBox():SizedBox(),
                    SizedBox(height: 5,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.green.shade400),
                          side: MaterialStateProperty.all(BorderSide(color: Colors.green.shade400, width: 1.5))
                      ),
                      onPressed: () {
                        setState(() {
                          isCLearList.value=false;
                          print(isImgSelected.value);
                          isvideoSelected.value = false;
                          isImgSelected.value =! isImgSelected.value;
                          // isImgSelected.obs != isImgSelected.obs;
                        });
                      },
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.black,
                      ), label: Text("Image", style: TextStyle(color: Colors.black),),),
                    VerticalDivider(color: Colors.grey, width: 5,),
                    OutlinedButton.icon(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.green.shade400),
                          side: MaterialStateProperty.all(BorderSide(color: Colors.green.shade400, width: 1.5))
                      ),
                      onPressed: () {
                        setState(() {
                          isCLearList.value=false;
                          print(isvideoSelected.value);
                          isImgSelected.value = false;
                          isvideoSelected.value =! isvideoSelected.value;
                          // isImgSelected.obs != isImgSelected.obs;
                        });
                      },
                      icon: Icon(
                        Icons.video_file_outlined,
                        color: Colors.black,
                      ), label: Text("Video", style: TextStyle(color: Colors.black),),),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => {
              isvideoSelected.value = false,
              isImgSelected.value = false,
              Get.back(),
              setState(() {
                _imageFileList=null;
              })
            },
            child: Text('Cancel'),
            style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red[400],
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () async {
              String _text = text.text.trim();
              String fileType=_imageFileList==null?"":_imageFileList!.path.split(".").last.toString()=="mp4"?'video':"image";
              if(_text.isEmpty){
                Fluttertoast.showToast(msg: "Message Is Empty");
              }else{
                Navigator.pop(context);
                isvideoSelected.value = false;
                isImgSelected.value = false;
                await cont.createdPost(_imageFileList,_text,fileType);
                _videoFileList?.clear();
                _imageFileList=null;
                setState(() { });
              }
            },
            child: Text('Post'),
            style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),);
  }
  pickedImage(ImageSource source) async {
    final XFile? pickedFileList = await _picker.pickImage(source:source);
    // final pickedFile = await imagePicker.pickMultiImage();
    print(pickedFileList.toString()+"===================================");
    setState(() {
      _imageFileList = pickedFileList;
    });
  }
  pickedVideo(ImageSource source) async {
    final XFile? pickedvideo = await _picker.pickVideo(source: source);
    // final pickedFile = await imagePicker.pickMultiImage();
    print(pickedvideo.toString()+"===================================");
    setState(() {
      _imageFileList = pickedvideo;
      // _videoFileList = pickedvideo as List<XFile>?;
    });
  }
}
