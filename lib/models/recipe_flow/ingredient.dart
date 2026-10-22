class Ingredient {
  String name;
  String detail;
  int index;
  int id;
  int groceryId;

  Ingredient({
    required this.name,
    required this.detail,
    required this.index,
    required this.id,
    this.groceryId = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "ingredient_id":
          index, // Ensure 'ingredient_id' is included with the index value
      "ingredient": {
        "name": name,
        "grocery_id":
            groceryId == 0 ? null : groceryId, // Handle groceryId accordingly
        "created_mode": "John Doe" // This can be dynamic if needed
      },
      "detail": detail
    };
  }

  // A method to represent the ingredient as a string, useful for debugging
  @override
  String toString() {
    return 'Ingredient{name: $name, detail: $detail, index: $index, groceryId: $groceryId}';
  }

  // Factory method to create an Ingredient from a map, useful for deserialization
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['ingredient']['name'],
      detail: map['detail'],
      index: map['ingredient_id'],
      id: map['id'],
      groceryId: map['ingredient']['grocery_id'] ??
          0, // Use 0 as a default value if groceryId is not provided
    );
  }
}
