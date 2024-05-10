import 'package:http/http.dart' as http;
import 'recipe.dart';
import 'dart:convert';

class RecipeApiService {
  static const String apiKey = '0926e237587d8d35e6748ce533768e9b';
  static const String applicationId = '7d0f4a61';
  static const String baseUrl = 'https://api.edamam.com/api/recipes/v2';

  static Future<List<String>> searchRecipes(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?q=$query&app_id=$applicationId&app_key=$apiKey&type=public'));

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        if (data != null && data['hits'] != null) {
          final List<dynamic> hits = data['hits'];
          return hits.map((hit) => hit['recipe']['label'].toString()).toList().cast<String>();
        } else {
          throw Exception('Empty or invalid response from API');
        }
      } else {
        throw Exception('Failed to load recipes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching recipes: $e');
      throw Exception('Error fetching recipes. Please try again later. Error: $e'); // Include actual error in the message
    }
  }

  static Future<Recipe> fetchRecipeDetails(String recipeLabel) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?q=$recipeLabel&app_id=$applicationId&app_key=$apiKey&type=public'));

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        if (data != null && data['hits'] != null && data['hits'].isNotEmpty) {
          final dynamic recipeData = data['hits'][0]['recipe'];
          Recipe recipe = Recipe(
            name: recipeData['label'].toString(),
            ingredients: recipeData['ingredientLines'].map<String>((ingredient) => ingredient.toString()).toList(),
            sourceUrl: recipeData['url'].toString(), // Use 'url' as source URL if needed
            imageUrl: recipeData['image'].toString(), // Use 'image' as imageUrl
          );

          return recipe;
        } else {
          throw Exception('Empty or invalid response from API');
        }
      } else {
        throw Exception('Failed to load recipe details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching recipe details: $e');
      throw Exception('Error fetching recipe details. Please try again later. Error: $e'); // Include actual error in the message
    }
  }
}
