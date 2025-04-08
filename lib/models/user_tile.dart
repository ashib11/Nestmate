import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String? profileImageUrl;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    this.profileImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.green[200],
          // borderRadius: BorderRadius.circular(40),
        ),
        // margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        margin: EdgeInsets.only(left: 5, top: 10,),
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 4),
        child: Row(
          children: [
            profileImageUrl != null
                ? CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl!),
              radius: 30, // Adjust size as needed
            )
                : const CircleAvatar(
              child: Icon(Icons.person),
              radius: 20,
            ),
            const SizedBox(width: 20),
            Text(text, style: TextStyle(color: Colors.black, fontSize: 16),),
          ],
        ),
      ),
    );
  }
}