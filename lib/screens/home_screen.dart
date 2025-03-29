import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maprojects/screens/category_selection.dart';
import 'package:maprojects/screens/favorites_screen.dart';
import 'package:maprojects/screens/profile_screen.dart';
import 'inbox_screen.dart';
import 'home_page.dart';
import 'search_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({required this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      UserHome(),
      SearchScreen(),
      CategorySelectionPage(),
      FavoritesScreen(),
      ProfileScreen(userID: widget.user.uid,),
    ];

    return Scaffold(
      appBar: _buildAppBar(),
      body: Expanded(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(color: Colors.green, size: 30),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Text(
            'NestMate',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Icon(Icons.home, color: Colors.green),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.blueGrey),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.message, color: Colors.blue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InboxScreen()),
            );
          },
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
