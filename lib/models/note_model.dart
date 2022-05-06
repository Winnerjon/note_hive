class Note {
  late int userId;
  late DateTime createTime;
  DateTime? editTime;
  late String title;
  late String content;

  Note({
    required this.userId,
    required this.createTime,
    this.editTime,
    required this.title,
    required this.content,
  });

  Note.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    createTime = DateTime.parse(json['createTime']);
    editTime = (json['editTime'] != "null" && json['editTime'] != null) ? DateTime.parse(json['editTime']) : null;
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() => {
    'userId' : userId,
    'createTime' : createTime.toString(),
    'editTime' : editTime.toString(),
    'title' : title,
    'content' : content,
  };
}