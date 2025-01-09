class Roles {
    String? description;
    String? name;
    String? id;
    List<Level>? levels;
    List<Tool>? tools;

    Roles({
        this.description,
        this.name,
        this.levels,
        this.tools,
        this.id
    });

    factory Roles.fromJson(Map<String, dynamic> json) => Roles(
        description: json["description"],
        name: json["name"],
        id: json["id"],
        levels: List<Level>.from(json["levels"].map((x) => Level.fromJson(x))),
        tools: List<Tool>.from(json["tools"].map((x) => Tool.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "name": name,
        "id": id,
        "levels": List<dynamic>.from(levels!.map((x) => x.toJson())),
        "tools": List<dynamic>.from(tools!.map((x) => x.toJson())),
    };
}

class Level {
    String? description;
    String? name;
    List<Materials>? materials;

    Level({
        this.description,
        this.name,
        this.materials,
    });

    factory Level.fromJson(Map<String, dynamic> json) => Level(
        description: json["description"],
        name: json["name"],
        materials: List<Materials>.from(json["materials"].map((x) => Materials.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "name": name,
        "materials": List<dynamic>.from(materials!.map((x) => x.toJson()))
    };
}

class Materials {
    String? name;
    String? recommendation;

    Materials({
        this.name,
        this.recommendation,
    });

    factory Materials.fromJson(Map<String, dynamic> json) => Materials(
        name: json["name"],
        recommendation: json["recommendation"],
    );

    Map<String, dynamic> toJson({bool isDone = false}) => {
        "name": name,
        "recommendation": recommendation,
        "isDone" : isDone
    };
}

class Tool {
    String? image;
    String? name;

    Tool({
        this.image,
        this.name,
    });

    factory Tool.fromJson(Map<String, dynamic> json) => Tool(
        image: json["image"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
    };
}