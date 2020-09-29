import 'package:flutter/material.dart';
import 'package:wine_app/base/base_event.dart';

class ChangePassEvent extends BaseEvent {
  String password;
  String newPass;

  ChangePassEvent({
    @required this.password,
    @required this.newPass,
  });
}