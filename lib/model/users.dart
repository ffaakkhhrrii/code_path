class Users {
    String? email;
    String? id;
    String? institute;
    bool? isAdmin;
    String? name;
    String? password;
    String? profile;
    String? role;
    String? username;

    Users({
        this.email,
        this.id,
        this.institute,
        this.isAdmin,
        this.name,
        this.password,
        this.profile,
        this.role,
        this.username,
    });

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        email: json["email"],
        id: json["id"],
        institute: json["institute"],
        isAdmin: json["isAdmin"],
        name: json["name"],
        password: json["password"],
        profile: json["profile"],
        role: json["role"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "institute": institute,
        "isAdmin": isAdmin,
        "name": name,
        "password": password,
        "profile": profile,
        "role": role,
        "username": username,
    };
}