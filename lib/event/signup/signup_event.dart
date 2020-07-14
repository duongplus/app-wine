import 'package:flutter/material.dart';
import 'package:wine_app/base/base_event.dart';

class SignUpEvent extends BaseEvent {
  String displayName;
  String phone;
  String pass;
  String avatar;

  SignUpEvent({
    @required this.displayName,
    @required this.phone,
    @required this.pass,
    this.avatar,
  });
}
