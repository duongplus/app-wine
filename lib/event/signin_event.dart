import 'package:flutter/material.dart';
import 'package:wine_app/base/base_event.dart';

class SignInEvent extends BaseEvent {
  String phone;
  String pass;

  SignInEvent({
    @required this.phone,
    @required this.pass,
  });
}
