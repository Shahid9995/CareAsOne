import 'package:careAsOne/controller/JobSeeker/post_play_video.dart';
import 'package:careAsOne/view/widget/image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';
import '../../constants/app_colors.dart';
import '../../constants/size.dart';
import '../../controller/JobSeeker/my_post_controller.dart';
import '../../controller/JobSeeker/news_feed.dart';

class MyPost extends StatefulWidget {
  MyPost({Key? key}) : super(key: key);
  @override
  _MyPostState createState() => _MyPostState();
}
class _MyPostState extends State<MyPost> {

  // PickedFile? imageFile;
  // String? imgUrl;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFileList;
  List<XFile>? _videoFileList;
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyPostController>(
      init: MyPostController(),
        builder: (_) => _.isLoading?Center(child: CircularProgressIndicator(color: AppColors.green,),):
        Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.black38,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _.myPostData.length,
                itemBuilder: (context, i)
                => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width/1.5,
                          //   child: Text(
                          //     "Title",
                          //     // friendsData[i].name,
                          //     style:
                          //     TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/1.3,
                            child: ReadMoreText(
                              _.myPostData[i].text.toString(),
                              trimLines: 2,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: TextStyle(color: Colors.green.shade600),
                              lessStyle: TextStyle(color: Colors.red.shade600),
                            ),
                          ),
                          Spacer(),
                          PopupMenuButton(
                            padding: EdgeInsets.zero,
                            child: Icon(Icons.more_vert),
                            itemBuilder: (context) {
                              return List.generate(1, (index) {
                                return PopupMenuItem(
                                  padding: EdgeInsets.zero,
                                  height: 15,
                                  child: Column(
                                    children: [
                                      TextButton.icon(
                                        style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.green)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          String text=_.myPostData[i].text.toString();
                                          String ID=_.myPostData[i].id.toString();
                                          MyPostController controller=_;
                                          String fType=_.myPostData[i].fileType.toString();
                                          String File=_.myPostData[i].postFile.toString();
                                          String fileId=_.myPostData[i].fileId.toString();
                                          print("=======File:$File===================");
                                          showDialog(context: context,
                                            builder: (_) {
                                              return editDialogPost(ID,text,controller,File,fType,fileId);
                                            },
                                            barrierDismissible: false,
                                            barrierColor: Colors.white.withOpacity(0.9),
                                          );
                                        },
                                        label: Text("Edit"),
                                        icon: Icon(Icons.edit),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton.icon(
                                        style: ButtonStyle(
                                            foregroundColor:
                                            MaterialStateProperty.all(Colors.red)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _.showSelectionDialog(context,_.myPostData[i].id.toString());
                                        },
                                        label: Text("Delete"),
                                        icon: Icon(Icons.delete),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      // subtitle: ReadMoreText(
                      //   _.myPostData[i].text.toString(),
                      //   trimLines: 2,
                      //   colorClickableText: Colors.pink,
                      //   trimMode: TrimMode.Line,
                      //   trimCollapsedText: 'Show more',
                      //   trimExpandedText: 'Show less',
                      //   moreStyle: TextStyle(color: Colors.green.shade600),
                      //   lessStyle: TextStyle(color: Colors.red.shade600),
                      // ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        )
    );
  }
  Widget editDialogPost( id,String Tittle,MyPostController controller,file,ftype,fid) {
    TextEditingController Ttext=TextEditingController();
    RxBool isImgSelected = false.obs;
    RxBool isFileExist=file!="null"?true.obs:false.obs;
    RxBool isvideoSelected = false.obs;
    RxBool isCLearList = false.obs;
    Ttext.text=Tittle;
    String  File=file;
    String fileId="";
    return Obx(() => SizedBox(
      height: height(context) * 0.7,
      width: width(context) * 0.3,
      child: AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        title: Text(
          "Edit Post",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
        ),
        content: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
          child: Container(
            height: height(context) * 0.42,
              width: width(context) * 0.8,
            child: ListView(
              shrinkWrap: true,
              // mainAxisSize: MainAxisSize.min,
              children: [
                isImgSelected.value == true || isvideoSelected.value == true?
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
                )
                    :
                Scrollbar(
                  child: TextFormField(
                    controller: Ttext,
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
                    isFileExist.value?Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:MediaQuery.of(context).size.width*0.5,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child:Text("$File")
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                ftype=="mp4" ?
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return viewdialogPost(File);
                                  },
                                  barrierDismissible: true,
                                  barrierColor: Colors.white.withOpacity(0.9),
                                ) :
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
                                              // panEnabled: false, // Set it to false
                                              boundaryMargin: EdgeInsets.all(100),
                                              minScale: 0.5,
                                              maxScale: 2,
                                              child: RectangularCachedImage(imageUrl: File, height:height(context), fit: BoxFit.fitWidth,),
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
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(Icons.visibility,color: Colors.green,),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                fileId=fid;
                                isFileExist.value=false;
                                isCLearList.value=true;
                                _imageFileList=null;
                                setState(() { });
                                },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(Icons.delete,color: Colors.red,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ):
                    isCLearList.value==false?
                    _imageFileList != null?
                    Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
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
                      ),
                    ) :SizedBox():SizedBox(),
                    SizedBox(height: 5,)
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
                          print(isImgSelected.value);
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
                          print(isvideoSelected.value);
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
              Get.back(),
              isvideoSelected.value = false,
              isImgSelected.value = false,
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
          Padding(
            padding: const EdgeInsets.only(right: 10,),
            child: TextButton(
              onPressed: () async {
                String _text = Ttext.text.trim();
                String fileType=_imageFileList==null?"":_imageFileList!.path.split(".").last.toString()=="mp4"?'video':"image";
                if(_text.isEmpty){
                  Fluttertoast.showToast(msg: "Message Is Empty");
                }else{
                Navigator.pop(context);
                if(fileId!=""){
                  print("=====true:$id=======================");
                  await controller.deleteMedia(fileId);
                }
                await controller.updatPost(id,_imageFileList,_text,fileType);
                isvideoSelected.value = false;
                isImgSelected.value = false;
                  _videoFileList?.clear();
                  _imageFileList=null;
                setState(() {});
              }},
              child: Text('Post'),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ),);
  }
  pickedImage(ImageSource source) async {
    // final XFile? pickedFileList = await _picker.pickImage(source: source);
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
  Widget viewdialogPost(String url) {
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
