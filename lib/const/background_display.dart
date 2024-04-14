import 'package:flutter/material.dart';
import 'package:quiz_app/const/image_asset_path.dart';

class BackgroundImage extends StatelessWidget {
  final Widget child;

  const BackgroundImage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          ImageAssetPath.bgImage,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        child,
      ],
    );
  }
}
