




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/colors.dart';
import 'package:whatsapp/model/user_model/user_model.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.contactSource,
    required this.onTap,
  }) : super(key: key);

  final UserModel contactSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust padding and font size based on screen width
    final double horizontalPadding = screenWidth * 0.02; // 5% of screen width
    final double leadingRadius = screenWidth * 0.1; // 10% of screen width
    final double fontSize = screenWidth * 0.04; // 4% of screen width

    return ListTile(

      onTap: onTap,
      contentPadding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding / 2,
      ),
      leading: CircleAvatar(
   backgroundColor: Colors.grey.withValues(),
        radius: leadingRadius,
        backgroundImage: contactSource.profile.isNotEmpty
            ? CachedNetworkImageProvider(contactSource.profile)
            : null,
        child: contactSource.profile.isEmpty
            ? Icon(
          Icons.person,
          size: fontSize * 2, // Adjust icon size based on font size
          color: Colors.white,
        )
            : null,
      ),
      title: Text(
        contactSource.name,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        contactSource.uid.isNotEmpty
            ? "Hey there! I'm using WhatsApp"
            : contactSource.statu,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: fontSize * 0.9, // Slightly smaller font for subtitle
        ),
      ),
      trailing: contactSource.uid.isEmpty
          ? TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Coloors.greenDark,
          textStyle: TextStyle(fontSize: fontSize),
        ),
        child: const Text('INVITE'),
      )
          : null,

    );
  }
}






