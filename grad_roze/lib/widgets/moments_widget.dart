import 'package:flutter/material.dart';
import 'package:grad_roze/custom/theme.dart';

class MomentsWidget extends StatelessWidget {
  final String imageUrl;
  final String text;

  const MomentsWidget({
    super.key,
    required this.imageUrl,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the image is a local asset or a network image
    final isNetworkImage = imageUrl.startsWith("http");

    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(8), // Add padding to shrink the image
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: 50, // Adjust the width to control size
                height: 50, // Adjust the height to control size
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain, // Contain the image inside the circle
                    image: isNetworkImage
                        ? NetworkImage(imageUrl) // For network images
                        : AssetImage(imageUrl)
                            as ImageProvider, // For local assets
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4), // Add spacing between image and text
            Text(
              text, // Display dynamic text
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    fontFamily: 'Funnel Display',
                    useGoogleFonts: false,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
