import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wine_app/base/base_bloc.dart';
import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/event/profile/profile_change_name_event.dart';
import 'package:wine_app/event/profile/profile_change_pass_event.dart';
import 'package:wine_app/shared/validation.dart';

class ProfileBloc extends BaseBloc {
  UserRepo _userRepo;

  ProfileBloc({@required UserRepo userRepo}) {
    _userRepo = userRepo;
    validatePasswordForm();
  }

  final _btnSaveSubject = BehaviorSubject<bool>();

  Stream<bool> get btnSaveStream => _btnSaveSubject.stream;

  Sink<bool> get btnSaveSink => _btnSaveSubject.sink;

  final _displayNameSubject = BehaviorSubject<String>();

  Stream<String> get displayNameStream =>
      _displayNameSubject.stream.transform(displayNameValidation);

  Sink<String> get displayNameSink => _displayNameSubject.sink;

  var displayNameValidation = StreamTransformer<String, String>.fromHandlers(
      handleData: (displayName, sink) {
    if (Validation.isDisplayName(displayName)) {
      sink.add(null);
      return;
    }
    sink.add('Tên không hợp lệ');
  });

  final _passSubject = BehaviorSubject<String>();

  Stream<String> get passStream =>
      _passSubject.stream.transform(passValidation);

  Sink<String> get passSink => _passSubject.sink;

  final _newPassSubject = BehaviorSubject<String>();

  Stream<String> get newPassStream =>
      _newPassSubject.stream.transform(passValidation);

  Sink<String> get newPassSink => _newPassSubject.sink;

  final _newPassCompareSubject = BehaviorSubject<String>();

  Stream<String> get newPassCompareStream =>
      _newPassCompareSubject.stream.transform(passValidation);

  Sink<String> get newPassCompareSink => _newPassCompareSubject.sink;

  var passValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink) {
      if (Validation.isPassValid(pass)) {
        sink.add(null);
        return;
      }
      sink.add('Mật khẩu phải dài hơn 6 ký tự');
    },
  );

  final _showPassSubject = BehaviorSubject<bool>();

  Stream<bool> get showPassStream => _showPassSubject.stream;

  Sink<bool> get showPassSink => _showPassSubject.sink;

  final _btnPass = BehaviorSubject<bool>();

  Stream<bool> get btnPassStream => _btnPass.stream;

  Sink<bool> get btnPassSink => _btnPass.sink;

  final _changeStatus = BehaviorSubject<int>();

  Stream<int> get changeStatusStream => _changeStatus.stream;

  Sink<int> get changeStatusSink => _changeStatus.sink;

  @override
  void dispatchEvent(BaseEvent event) {
    // TODO: implement dispatchEvent
    switch (event.runtimeType) {
      case ChangeNameEvent:
        handleChangeNameEvent(event);
        break;
      case ChangePassEvent:
        handleChangePassEvent(event);
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _showPassSubject.close();
    _passSubject.close();
    _displayNameSubject.close();
    _btnSaveSubject.close();
    _newPassSubject.close();
    _newPassCompareSubject.close();
    _btnPass.close();
    _changeStatus.close();
  }

  void validatePasswordForm() {
    Observable.combineLatest3(
      _passSubject,
      _newPassSubject,
      _newPassCompareSubject,
      (pass, newPass, newPassCompare) {
        return Validation.isPassValid(pass) &&
            Validation.isPassValid(newPass) &&
            Validation.isPassValid(newPassCompare);
      },
    ).listen(
      (enable) {
        btnPassSink.add(enable);
      },
    );
  }

  void handleChangeNameEvent(BaseEvent event) {
    btnSaveSink.add(false);
    ChangeNameEvent e = event as ChangeNameEvent;
    _userRepo.changeName(e.name).then((status) {
      changeStatusSink.add(status);
    }, onError: (e) {
      try{
        changeStatusSink.add(int.parse(e.toString()));
      }catch(e){
        print(e);
      }
    });
  }

  void handleChangePassEvent(BaseEvent event) {
    btnSaveSink.add(false);
    ChangePassEvent e = event as ChangePassEvent;
    _userRepo.changePassword(e.password, e.newPass).then((status) {
      print(status);
      changeStatusSink.add(status);
    }, onError: (e) {
      print(e);
      try{
        changeStatusSink.add(int.parse(e.toString()));
      }catch(e) {
        print(e);
      }
    });
  }
}
