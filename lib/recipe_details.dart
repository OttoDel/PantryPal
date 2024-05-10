import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'recipe.dart'; // Import your recipe model

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetails({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          recipe.name, // Use the recipe name as the app bar title
          style: const TextStyle(
            color: Colors.white, // Text color
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(2.8, 2.8),
                blurRadius: 8.0,
                color: Colors.cyan, // Shadow color
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Set back arrow color to white
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Ingredients:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), // Increased font size for Ingredients
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.ingredients
                    .map((ingredient) => Text('• $ingredient', style: const TextStyle(fontSize: 15, color: Colors.cyan)))
                    .toList(), // Increased font size for ingredients
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0), // Button border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.5), // Set glow color and opacity
                      spreadRadius: 5, // Spread radius for the glow effect
                      blurRadius: 15, // Blur radius for the glow effect
                      offset: const Offset(0, 3), // Offset of the shadow (adjust as needed)
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0, // No elevation for the card itself (using shadow in the button)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      recipe.imageUrl, // Use the recipe image URL
                      fit: BoxFit.cover, // Cover the entire card area with the image
                      width: 300, // Set a fixed width for the image
                      height: 300, // Set a fixed height for the image
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _launchURL(context, recipe.sourceUrl); // Pass context here
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan), // Set button background color to white
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.cyan), // Set text color to cyan
                  elevation: MaterialStateProperty.all<double>(50), // No elevation for the button (using shadow)
                  shadowColor: MaterialStateProperty.all<Color>(Colors.deepPurple.withOpacity(1)), // Set glow color for the button
                  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent), // No overlay color when pressed
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Colors.transparent), // Set a transparent border color
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                  ),
                ),
                child: const Text(
                  'View Instructions',
                  style: TextStyle(
                    color: Colors.black, // Set button text color to cyan
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to launch the URL
  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      Uri uri = Uri.parse(url); // Parse the URL
      bool launched = await launch(
        uri.toString(),
        forceWebView: false,
        enableJavaScript: true,
        enableDomStorage: true,
      );
      if (!launched) {
        // Handle launch failure
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Could not launch $url'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
