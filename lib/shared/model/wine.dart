import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class Wine{
  dynamic id;
  String name;
  String producer;
  String country;
  String alcohol;
  String description;
  String thumbnail;
  dynamic price;
  String cateId;
  dynamic capacity;
  dynamic size;
  Color color;


  Wine({this.id, this.name, this.producer, this.country, this.alcohol,
    this.description, this.thumbnail, this.price, this.cateId, this.capacity, this.size, this.color});

  factory Wine.fromJson(Map<String, dynamic> json){
    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(
        colorBrightness: ColorBrightness.veryLight
    );
    return Wine(
      id: json["_id"],
      name: json["name"],
      producer: json["producer"],
      country: json["country"],
      alcohol: json["alcohol"],
      description: json["description"],
      thumbnail: json["thumbnail"],
      price: json["price"],
      cateId: json["cateID"],
      capacity: json["capacity"],
      size: json["size"],
      color: Colors.pink[200]
    );
  }

  static List<Wine> parseWineList(map) {
    var list = map['data'] as List;
    return list.map((product) => Wine.fromJson(product)).toList();
  }

  static List<Wine> wines;
}