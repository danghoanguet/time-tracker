import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
    this.photoUrl,
    @required this.radius,
    @required this.onTap,
  }) : super(key: key);
  final String photoUrl;
  final double radius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue[400], width: 3)),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.black12,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
          child: photoUrl == null ? Icon(Icons.camera_alt, size: radius) : null,
        ),
      ),
    );
  }
}
