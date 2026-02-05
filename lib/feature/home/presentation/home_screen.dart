import 'package:cookly/core/widgets/categories.dart';
import 'package:cookly/core/widgets/filtered_recipe_list.dart';
import 'package:cookly/core/widgets/home_header.dart';
import 'package:cookly/core/widgets/home_searchbar.dart';
import 'package:cookly/core/widgets/promocard.dart';
import 'package:cookly/core/widgets/quick_easy_section.dart';
import 'package:cookly/feature/Account/account_screen.dart';
import 'package:cookly/feature/favorite/favorite_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Using a list of widgets for the navigation tabs
  final List<Widget> _screens = [
    const HomeContent(), // Index 0
    const FavoritesScreen(), // Index 1
     AccountScreen(), // Index 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f1e2),
      // IndexedStack preserves the state (scroll position/search) of each tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF09338c),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String selectedCategory = 'All';
  String searchQuery = "";
  // Controller moved here to manage Home-specific search state
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(height: 16),
            
            // Pass the controller and logic to the search bar
            HomeSearchbar(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            
            const SizedBox(height: 16),
            const Promocard(),
            const SizedBox(height: 24),

            Categories(
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                  // Optional: clear search when clicking a category for better UX
                  if (searchQuery.isNotEmpty) {
                    searchController.clear();
                    searchQuery = "";
                  }
                });
              },
            ),

            const SizedBox(height: 24),

            // SEARCH LOGIC: Show results if searching, otherwise show categories
            if (searchQuery.isNotEmpty) ...[
              Text(
                "Searching for '$searchQuery'",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              FilteredRecipeList(category: 'All', searchQuery: searchQuery), // Updated parameter
            ] 
            else if (selectedCategory == 'All') ...[
              const QuickEasySection(),
            ] 
            else ...[
              Text(
                '$selectedCategory Recipes',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              FilteredRecipeList(category: selectedCategory, searchQuery: '',),
            ],
          ],
        ),
      ),
    );
  }
}