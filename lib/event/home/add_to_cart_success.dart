import 'package:flutter/material.dart';
import 'package:wine_app/base/base_event.dart';

class AddToCartSuccess extends BaseEvent{
  int statusCode;
  AddToCartSuccess({@required this.statusCode});
}