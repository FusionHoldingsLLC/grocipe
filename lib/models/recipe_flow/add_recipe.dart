import 'dart:convert';

class AddRecipeData {
  final String image;
  final String name;
  final String description;
  final String cuisine;
  final String servings;
 

  AddRecipeData({
    required this.image,
    required this.name,
    required this.description,
    required this.cuisine,
    required this.servings,
  });

  AddRecipeData copyWith({
    String? image,
    String? name,
    String? description,
    String? cuisine,
    String? servings,
  }) {
    return AddRecipeData(
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
      cuisine: cuisine ?? this.cuisine,
      servings: servings ?? this.servings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'description': description,
      'cuisine': cuisine,
      'servings': servings,
    };
  }

  factory AddRecipeData.fromMap(Map<String, dynamic> map) {
    return AddRecipeData(
      image: map['image'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      cuisine: map['cuisine'] as String,
      servings: map['servings'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddRecipeData.fromJson(String source) =>
      AddRecipeData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AddRecipeData(image: $image, name: $name, description: $description, cuisine: $cuisine, servings: $servings)';

  @override
  bool operator ==(covariant AddRecipeData other) {
    if (identical(this, other)) return true;

    return other.image == image &&
        other.name == name &&
        other.description == description &&
        other.cuisine == cuisine &&
        other.servings == servings;
  }

  @override
  int get hashCode =>
      image.hashCode ^
      name.hashCode ^
      description.hashCode ^
      cuisine.hashCode ^
      servings.hashCode;
}
