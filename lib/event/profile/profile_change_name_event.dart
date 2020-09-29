import 'package:flutter/material.dart';
import 'package:wine_app/base/base_event.dart';

class ChangeNameEvent extends BaseEvent {
  String name;

  ChangeNameEvent({
    @required this.name,
  });
}