import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String title;
  final String imageUrl;

  const ImageViewerScreen({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const CircularProgressIndicator();
            },
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
          ),
        ),
      ),
    );
  }
} 