import 'package:doxfood/api.dart';
import 'package:doxfood/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAvatar extends StatelessWidget {
  final PublicUser user;

  const UserAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final avatarUri = context.read<API>().getAvatarURL(user);

    return CircleAvatar(
      backgroundColor: Colors.blueGrey,
      radius: 17,
      child: CircleAvatar(
        backgroundColor: colorFromText(user.username),
        radius: 16,
        backgroundImage: (avatarUri != null) ? NetworkImage(avatarUri.toString()) : null,
        child:
            (avatarUri == null)
                ? Text(user.username[0].toUpperCase(), style: const TextStyle(color: Colors.black))
                : null,
      ),
    );
  }
}
