import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gapopatesttask/model/gallery_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GalleryController extends GetxController {
  //

  // VARIABLE DECLARATION
  // ---------------------------------------------------------------------------

  final imageData = <GalleryModel>[].obs;

  bool isLoading = false;
  final scrollController = ScrollController();

  int _page = 1;
  final int _perPage = 50;

  @override
  void onInit() {
    super.onInit();
    fetchImageData();
    scrollController.addListener(_scrollListener);
  }

  // PRIVATE HELPER METHOD
  // ---------------------------------------------------------------------------

  // Scroll listener to get images on scroll
  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isLoading) {
        return;
      }
      fetchImageData();
    }
  }

  // API CALL
  // ---------------------------------------------------------------------------

  // Get image data from server using pixabay API.
  Future<void> fetchImageData() async {
    const String apiKey = '43411935-cbc09ed05959836d591926fcb';
    String url =
        'https://pixabay.com/api/?key=$apiKey&q=yellow+fllower&page=$_page&per_page=$_perPage';

    isLoading = true;

    final response = await http.get(Uri.parse(url));

    isLoading = false;

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['hits'];
      final imageList =
          List<GalleryModel>.from(data.map((e) => GalleryModel.fromJson(e)));
      imageData.addAll(imageList);
      _page++;
    } else {
      throw Exception('Failed to load image data');
    }
  }
}
