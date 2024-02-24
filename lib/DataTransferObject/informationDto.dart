import 'package:cloud_firestore/cloud_firestore.dart';

class informationDto {
  String title;
  String imageUrl;
  String description;

  informationDto(this.title, this.imageUrl, this.description);

  factory informationDto.fromMap(Map<String, dynamic> json){
    return informationDto(json['title'],json['imageUrl'],json['description']);
  }

  Map<String, dynamic> toMap() =>
      {
        'title': title,
        'imageUrl': imageUrl,
        'description': description,
      };
}