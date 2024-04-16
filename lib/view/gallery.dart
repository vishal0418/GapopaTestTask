import 'package:flutter/material.dart';
import 'package:gapopatesttask/controller/gallery_controller.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({super.key});

  final controller = Get.put(GalleryController());

  @override
  Widget build(BuildContext context) {
    //
    // Get image list
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      controller.fetchImageData();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gallery'),
      ),
      body: Obx(
        () => GridView.builder(
          controller: controller.scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _numberOfColumToDisplay(context),
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: controller.imageData.length,
          itemBuilder: (context, index) {
            return _galleryItemAt(
              context,
              index: index,
            );
          },
        ).paddingAll(5),
      ),
    );
  }

  // Gallery Item Widget
  Widget _galleryItemAt(
    BuildContext context, {
    required int index,
  }) {
    final itemData = controller.imageData[index];
    return GestureDetector(
      onTap: () {
        _openImagePreview(
          context,
          itemData.largeImageURL ?? '',
        );
      },
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          title: Row(
            children: [
              const Icon(
                Icons.thumb_up,
                size: 18,
              ).paddingOnly(right: 5),
              Text(
                (itemData.likes ?? 0).toString(),
              ),
              const Spacer(),
              Text(
                (itemData.views ?? 0).toString(),
              ).paddingOnly(right: 5),
              const Icon(
                Icons.visibility,
                size: 20,
              ),
            ],
          ),
        ),
        child: Container(
          color: Colors.grey.shade100,
          child: Image.network(
            itemData.webformatURL ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.photo_album,
                color: Colors.grey.shade400,
                size: 50,
              );
            },
          ),
        ),
      ),
    );
  }

  // Function to get number if column based on screen width
  int _numberOfColumToDisplay(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const cellWidth = 200.0;
    final crossAxisCount = (screenWidth / cellWidth).round();
    return crossAxisCount;
  }

  // Function to open image in fullscreen
  void _openImagePreview(BuildContext context, String imageUrl) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
              initialScale: PhotoViewComputedScale.contained,
            ),
          ),
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }
}
