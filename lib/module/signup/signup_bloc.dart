import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wine_app/base/base_bloc.dart';
import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/event/signup/signup_event.dart';
import 'package:wine_app/event/signup/signup_fail_event.dart';
import 'package:wine_app/event/signup/signup_sucess_event.dart';
import 'package:wine_app/shared/validation.dart';

class SignUpBloc extends BaseBloc {
  final _displayNameSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();
  final _teddySubject = BehaviorSubject<String>();

  Stream<String> get displayNameStream =>
      _displayNameSubject.stream.transform(displayNameValidation);

  Sink<String> get displayNameSink => _displayNameSubject.sink;

  Stream<String> get phoneStream =>
      _phoneSubject.stream.transform(phoneValidation);

  Sink<String> get phoneSink => _phoneSubject.sink;

  Stream<String> get passStream =>
      _passSubject.stream.transform(passValidation);

  Sink<String> get passSink => _passSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;

  Sink<bool> get btnSink => _btnSubject.sink;

  Stream<String> get teddyStream => _teddySubject.stream;

  Sink<String> get teddySink => _teddySubject.sink;

  UserRepo _userRepo;

  var displayNameValidation = StreamTransformer<String, String>.fromHandlers(
      handleData: (displayName, sink) {
    if (Validation.isDisplayName(displayName)) {
      sink.add(null);
      return;
    }
    sink.add('Display name invalid');
  });

  var phoneValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (phone, sink) {
      if (Validation.isPhoneValid(phone)) {
        sink.add(null);
        return;
      }
      sink.add('Phone invalid');
    },
  );

  var passValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink) {
      if (Validation.isPassValid(pass)) {
        sink.add(null);
        return;
      }
      sink.add('Password too short');
    },
  );

  SignUpBloc({@required UserRepo userRepo}) {
    _userRepo = userRepo;
    validateForm();
  }

  validateForm() {
    Observable.combineLatest3(
      _displayNameSubject,
      _phoneSubject,
      _passSubject,
      (
        displayName,
        phone,
        pass,
      ) {
        return Validation.isDisplayName(displayName) &&
            Validation.isPhoneValid(phone) &&
            Validation.isPassValid(pass);
      },
    ).listen((enable) {
      btnSink.add(enable);
    });
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SignUpEvent:
        handleSignUp(event);
        break;
    }
  }

  handleSignUp(event) {
    btnSink.add(false);
    loadingSink.add(true);
    Future.delayed(Duration(seconds: 6), (){
      SignUpEvent e = event as SignUpEvent;
      _userRepo.signUp(e.displayName, e.phone, e.pass, avatar: e.avatar).then(
            (userData) {
          print(userData.token);
          teddySink.add('success');
          processEventSink.add(SignUpSuccessEvent(userData));
        },
        onError: (e) {
          print(e);
          teddySink.add('fail');
          loadingSink.add(false);
          btnSink.add(true);
          processEventSink.add(SignUpFailEvent(e.toString()));
        },
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _displayNameSubject.close();
    _phoneSubject.close();
    _passSubject.close();
    _btnSubject.close();
    _teddySubject.close();
  }
}
