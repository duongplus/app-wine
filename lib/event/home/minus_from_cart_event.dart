
import 'package:flutter/material.dart';
import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/shared/model/wine.dart';

class MinusFromCart extends BaseEvent {
  String wineId;

  MinusFromCart({@required this.wineId});
}
