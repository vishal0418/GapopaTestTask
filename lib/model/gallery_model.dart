class GalleryModel {
  int? id;
  String? webformatURL;
  String? largeImageURL;
  int? views;
  int? likes;

  GalleryModel({
    this.id,
    this.webformatURL,
    this.largeImageURL,
    this.views,
    this.likes,
  });

  GalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    webformatURL = json['webformatURL'];
    largeImageURL = json['largeImageURL'];
    views = json['views'];
    likes = json['likes'];
  }
}
