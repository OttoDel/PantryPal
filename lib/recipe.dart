class Recipe {
  final String name;
  final List<String> ingredients;
  final String sourceUrl;
  final String imageUrl; // Add imageUrl parameter

  Recipe({
    required this.name,
    required this.ingredients,
    required this.sourceUrl,
    required this.imageUrl, // Add required for imageUrl
  });
}
