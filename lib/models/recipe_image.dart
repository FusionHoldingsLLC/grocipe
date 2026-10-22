import 'package:hive/hive.dart';

part 'recipe_image.g.dart';

@HiveType(typeId: 5)
class RecipeImage extends HiveObject {
  @HiveField(0)
  String imageData;

  @HiveField(1)
  int id;

  RecipeImage({
    required this.imageData,
    required this.id,
  });

  factory RecipeImage.fromJson(Map<String, dynamic> json) => RecipeImage(
        imageData: json['image_data'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'image_data': imageData,
        'id': id,
      };
}
