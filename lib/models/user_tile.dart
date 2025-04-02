import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String? profileImageUrl; // Nullable if the user might not have a profile picture
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    this.profileImageUrl, // Optional
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[200],
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Display profile picture if URL exists, otherwise show default icon
            profileImageUrl != null
                ? CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl!),
              radius: 20, // Adjust size as needed
            )
                : const CircleAvatar(
              child: Icon(Icons.person),
              radius: 20,
            ),
            const SizedBox(width: 20),
            Text(text),
          ],
        ),
      ),
    );
  }
}