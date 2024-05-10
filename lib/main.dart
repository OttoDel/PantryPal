import 'package:flutter/material.dart';
import 'userService.dart'; // Import API service
import 'recipe_details.dart'; // Import RecipeDetails
import 'recipe.dart'; // Import your recipe model

void main() {
  runApp(const PantryPalApp());
}

class PantryPalApp extends StatelessWidget {
  const PantryPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PantryPal',
      theme: ThemeData(
        // Your theme data
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _ingredientController = TextEditingController();
  List<String> _recipes = []; // Placeholder for recipe results

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //appbar
        backgroundColor: Colors.black,
        title: const Center( //center
          child: Text( //text
            'PantryPal',
            style: TextStyle(
              color: Colors.white, // Change the header color to red
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2.8, 2.8),
                  blurRadius: 8.0,
                  color: Colors.cyan, // Glow color
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black, // Black background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ingredientController,
              decoration: const InputDecoration(
                labelText: 'Enter ingredients (comma-separated)',
                labelStyle: TextStyle(color: Colors.white), // White label text color
              ),
              style: const TextStyle(color: Colors.white), // White text color for input
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _searchRecipes();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan), // Cyan background color for button

              ),
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _recipes[index],
                      style: const TextStyle(color: Colors.cyan), // Cyan text color for list item
                    ),
                    onTap: () async {
                      await _navigateToRecipeDetails(_recipes[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchRecipes() async {
    final String ingredients = _ingredientController.text.trim();
    print('Ingredients entered: $ingredients');

    if (ingredients.isNotEmpty) {
      try {
        final List<String> fetchedRecipes = await RecipeApiService.searchRecipes(ingredients);
        print('Fetched recipes: $fetchedRecipes');

        setState(() {
          _recipes = fetchedRecipes;
        });
      } catch (e) {
        print('Error fetching recipes: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching recipes. Please try again later.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter ingredients to search for recipes.')),
      );
    }
  }

  Future<void> _navigateToRecipeDetails(String recipeName) async {
    try {
      final Recipe recipe = await RecipeApiService.fetchRecipeDetails(recipeName);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetails(recipe: recipe),
        ),
      );
    } catch (e) {
      print('Error fetching recipe details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching recipe details. Please try again later.')),
      );
    }
  }

  @override
  void dispose() {
    _ingredientController.dispose(); // Dispose of the controller to free up resources
    super.dispose();
  }
}
