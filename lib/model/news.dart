import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
    String? cover;
    String? createdAt;
    String? description;
    String? id;
    List<String>? likes;
    String? theme;
    String? title;

    News({
        this.cover,
        this.createdAt,
        this.description,
        this.id,
        this.likes,
        this.theme,
        this.title,
    });

    factory News.fromJson(Map<String, dynamic> json) => News(
        cover: json["cover"],
        createdAt: json["created_at"],
        description: json["description"],
        id: json["id"],
        likes: List<String>.from(json["likes"].map((x) => x)),
        theme: json["theme"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "cover": cover,
        "created_at": createdAt,
        "description": description,
        "id": id,
        "likes": List<dynamic>.from(likes!.map((x) => x)),
        "theme": theme,
        "title": title,
    };
}
