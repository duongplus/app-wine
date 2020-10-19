import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wine_app/base/base_bloc.dart';
import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/event/signin/signin_event.dart';
import 'package:wine_app/event/signin/signin_fail_event.dart';
import 'package:wine_app/event/signin/signin_sucess_event.dart';
import 'package:wine_app/module/signin/signin_page.dart';
import 'package:wine_app/shared/model/user_data.dart';
import 'package:wine_app/shared/validation.dart';

class SignInBloc extends BaseBloc {
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();
  final _teddySubject = BehaviorSubject<String>();

  UserRepo _userRepo;

  SignInBloc({@required UserRepo userRepo}) {
    _userRepo = userRepo;
    validateForm();
  }

  var phoneValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (phone, sink) {
      if (Validation.isPhoneValid(phone)) {
        sink.add(null);
        return;
      }
      sink.add('Số điện thoại không hợp lệ');
    },
  );

  var passValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink) {
      if (Validation.isPassValid(pass)) {
        sink.add(null);
        return;
      }
      sink.add('Mật khẩu không hợp lệ');
    },
  );

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

  validateForm() {
    Observable.combineLatest2(
      _phoneSubject,
      _passSubject,
      (phone, pass) {
        return Validation.isPhoneValid(phone) && Validation.isPassValid(pass);
      },
    ).listen(
      (enable) {
        btnSink.add(enable);
      },
    );
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SignInEvent:
        handleSignIn(event);
        break;
    }
  }

  handleSignIn(event) async {
    btnSink.add(false);
    loadingSink.add(true);

    Future.delayed(Duration(seconds: 1), () async {
      SignInEvent e = event as SignInEvent;
      await _userRepo.signIn(e.phone, e.pass).then(
            (userData) {
              UserData.u = userData;
          teddySink.add('success');
          processEventSink.add(SignInSuccessEvent(userData));
        },
        onError: (e) {
          // print(e['status']);
          btnSink.add(true);
          loadingSink.add(false);
          teddySink.add('fail');
          try{
            if(e['status'].toString() == '404'){
              processEventSink
                  .add(SignInFailEvent('Số điện thoại này không tồn tại'));
            } else if(e['status'].toString() == '401'){
              processEventSink
                  .add(SignInFailEvent('Sai mật khẩu.'));
            } else {
              processEventSink.add(SignInFailEvent(e.toString()));
            }
          }catch(e){}
        },
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _phoneSubject.close();
    _passSubject.close();
    _btnSubject.close();
    _teddySubject.close();
  }
}
