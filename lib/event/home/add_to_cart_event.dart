
import 'package:flutter/material.dart';
import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/shared/model/wine.dart';

class AddToCartEvent extends BaseEvent {
  String wineId;

  AddToCartEvent({@required this.wineId});
}
