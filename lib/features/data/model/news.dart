import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
    String? createdAt;
    String? createdBy;
    String? description;
    String? id;
    List<Likes>? likes;
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
        likes: List<Likes>.from(json["likes"].map((x) => Likes.fromJson(x))),
        theme: json["theme"],
        title: json["title"],
        comments: List<Comments>.from(json["comments"].map((x) => Comments.fromJson(x)))
    );

    Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "created_by": createdBy,
        "description": description,
        "id": id,
        "likes": List<dynamic>.from(likes!.map((x) => x.toJson())),
        "theme": theme,
        "title": title,
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
    };
}

class Comments {
    String? id;
    String? comment;
    DateTime? createdAt;
    String? name;

    Comments({
        this.id,
        this.comment,
        this.createdAt,
        this.name
    });

    factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        id: json["id"],
        comment: json["comment"],
        createdAt: (json["created_at"] as Timestamp).toDate(),
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "created_at": Timestamp.fromDate(createdAt!),
        "name": name,
    };
}

class Likes {
    String? id;

    Likes({
        this.id,
    });

    factory Likes.fromJson(Map<String, dynamic> json) => Likes(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
