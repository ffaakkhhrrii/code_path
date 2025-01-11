import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
    String? createdAt;
    String? createdBy;
    String? description;
    String? id;
    List<String>? likes;
    String? theme;
    String? title;
    List<Comments>? comments;

    News({
        this.createdAt,
        this.createdBy,
        this.description,
        this.id,
        this.likes,
        this.theme,
        this.title,
        this.comments
    });

    factory News.fromJson(Map<String, dynamic> json) => News(
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        description: json["description"],
        id: json["id"],
        likes: List<String>.from(json["likes"].map((x) => x)),
        theme: json["theme"],
        title: json["title"],
        comments: List<Comments>.from(json["comments"].map((x) => Comments.fromJson(x)))
    );

    Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "created_by": createdBy,
        "description": description,
        "id": id,
        "likes": List<dynamic>.from(likes!.map((x) => x)),
        "theme": theme,
        "title": title,
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
    };
}

class Comments {
    String? id;
    String? comment;

    Comments({
        this.id,
        this.comment,
    });

    factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        id: json["id"],
        comment: json["comment"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
    };
}
