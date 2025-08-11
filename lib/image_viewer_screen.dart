import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isAsset;

  const ImageViewerScreen({
    super.key, 
    required this.title, 
    required this.imageUrl, 
    this.isAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: const Color(0xFFF3EFFF),
      body: Center(
        child: InteractiveViewer(
          child: isAsset 
            ? Image.asset(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Image not found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading image...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
                errorBuilder: (context, error, stackTrace) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load image',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
} 