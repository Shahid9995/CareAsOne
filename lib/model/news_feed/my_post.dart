class MyPostModel {
  List<MyPostData>? data;
  Links? links;
  Meta? meta;

  MyPostModel({this.data, this.links, this.meta});

  MyPostModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MyPostData>[];
      json['data'].forEach((v) {
        data!.add(new MyPostData.fromJson(v));
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

  void clear() {}
}

class MyPostData {
  int? id;
  String? text;
  int? fileId;
  String? postFile;
  String? fileType;

  MyPostData({this.id, this.text, this.postFile, this.fileType,this.fileId});

  MyPostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    fileId= json['file_id'];
    postFile = json['post_file'];
    fileType = json['file_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['file_id'] = this.fileId;
    data['post_file'] = this.postFile;
    data['file_type'] = this.fileType;
    return data;
  }
}
class Links {
  String? first;
  String? last;
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
  var currentPage;
  var from;
  var lastPage;
  var path;
  var perPage;
  var to;
  var total;

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