import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  final List<Meal> _favoriteMeals = [];

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Meal removed from favorites.');
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('Meal added to favorites!');
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage =
        CategoriesScreen(onToggleFavorites: _toggleMealFavoriteStatus);

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorites: _toggleMealFavoriteStatus,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPageIndex == 1 ? 'Your Favorites' : 'Categories'),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
