import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property.dart';
import '../widgets/property_card.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteProperties = favoritesProvider.favoriteProperties;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: favoriteProperties.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the heart icon on properties to save them here',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: favoriteProperties.length,
        itemBuilder: (context, index) {
          final property = favoriteProperties[index];
          return Column(
            children: [
              _buildUserInfo(property, context),
              PropertyCard(property: property),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserInfo(Property property, BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(property.userImage),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property.userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                _formatTime(property.postTime),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              favoritesProvider.removeFromFavorites(property);
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime postTime) {
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      final hour = postTime.hour > 12 ? postTime.hour - 12 : postTime.hour;
      final period = postTime.hour < 12 ? 'am' : 'pm';
      final minute = postTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute$period';
    }
  }
}