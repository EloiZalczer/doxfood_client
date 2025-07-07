import 'package:doxfood/api.dart';
import 'package:doxfood/utils/color.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final User user;

  const UserAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.blueGrey,
      radius: 17,
      child: CircleAvatar(
        backgroundColor: colorFromText(user.username),
        radius: 16,
        backgroundImage: (user.avatar != null) ? NetworkImage(user.avatar!.toString()) : null,
        child:
            (user.avatar == null) ? Text(user.username[0].toUpperCase(), style: TextStyle(color: Colors.black)) : null,
      ),
    );
  }
}
