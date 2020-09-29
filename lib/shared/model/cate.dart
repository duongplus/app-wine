import 'package:flutter/foundation.dart';

class Cate {
  String cateId;
  String cateName;

  Cate({this.cateId, this.cateName});

  factory Cate.fromJson(Map<String, dynamic> json) {
    return Cate(
      cateId: json["cateId"],
      cateName: json["cateName"],
    );
  }

  static List<Cate> parseCateList(map) {
    var list = map['data'] as List;
    return list.map((product) => Cate.fromJson(product)).toList();
  }

  static List<Cate> cates;
}
