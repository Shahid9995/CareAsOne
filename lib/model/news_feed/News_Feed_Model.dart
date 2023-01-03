class NewsFeedModel {
  List<NewsFeedData>? data;
  Links? links;
  Meta? meta;

  NewsFeedModel({this.data, this.links, this.meta});

  NewsFeedModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NewsFeedData>[];
      json['data'].forEach((v) {
        data!.add(new NewsFeedData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}
class NewsFeedData {
  int? id;
  int? userId;
  String? userName;
  String? companyName;
  String? userImage;
  String? text;
  String? postFile;
  String? fileType;
  String? createdAt;
  String? updatedAt;
  int? totalLikes;
  String? publicLink;
  List<int>? likeUsers;
  List<Comments>? comments;

  NewsFeedData(
      {this.id,
        this.userId,
        this.userName,
        this.companyName,
        this.userImage,
        this.text,
        this.postFile,
        this.fileType,
        this.createdAt,
        this.updatedAt,
        this.totalLikes,
        this.publicLink,
        this.likeUsers,
        this.comments});

  NewsFeedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    companyName = json['company_name'];
    userImage = json['user_image'];
    text = json['text'];
    postFile = json['post_file'];
    fileType = json['file_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalLikes = json['total_likes'];
    publicLink = json['public_link'];
    likeUsers = json['like_users'].cast<int>();
    if (json['Comments'] != null) {
      comments = <Comments>[];
      json['Comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['company_name'] = this.companyName;
    data['user_image'] = this.userImage;
    data['text'] = this.text;
    data['post_file'] = this.postFile;
    data['file_type'] = this.fileType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total_likes'] = this.totalLikes;
    data['public_link'] = this.publicLink;
    data['like_users'] = this.likeUsers;
    if (this.comments != null) {
      data['Comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Comments {
  int? id;
  var userId;
  var postId;
  var userName;
  var userImage;
  var comment;
  var totalLikes;
  List<dynamic>? likeUsers;
  List<Replies>? replies;

  Comments(
      {this.id,
        this.userId,
        this.postId,
        this.userName,
        this.userImage,
        this.comment,
        this.totalLikes,
        this.likeUsers,
        this.replies});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postId = json['post_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    comment = json['comment'];
    totalLikes = json['total_likes'];
    likeUsers =json['like_users']==null?[]:json['like_users'].cast<int>();
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['comment'] = this.comment;
    data['total_likes'] = this.totalLikes;
    data['like_users'] = this.likeUsers;
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Replies {
  int? id;
  var userId;
  var commentId;
  String? userName;
  String? userImage;
  String? reply;

  Replies(
      {this.id,
        this.userId,
        this.commentId,
        this.userName,
        this.userImage,
        this.reply});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    commentId = json['comment_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    reply = json['reply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['comment_id'] = this.commentId;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['reply'] = this.reply;
    return data;
  }
}

class Links {
  var first;
  var last;
  var prev;
  var next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}