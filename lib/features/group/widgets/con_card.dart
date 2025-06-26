





import 'package:whatsapp/model/user_model/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ConCard extends StatelessWidget {
  const ConCard({
    Key? key,
    required this.contactSource,
   required this.onTap,
  }) : super(key: key);

  final UserModel contactSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.withValues(),
        radius: 20,
        backgroundImage: contactSource.profile.isNotEmpty
            ? CachedNetworkImageProvider(contactSource.profile)
            : null,
        child: contactSource.profile.isEmpty
            ? const Icon(
          Icons.person,
          size: 30,
          color: Colors.white,
        )
            : null,
      ),
      title: Text(
        contactSource.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

    );
  }
}








