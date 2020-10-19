import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wine_app/base/base_bloc.dart';
import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/data/repo/order_repo.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/data/repo/wine_repo.dart';
import 'package:wine_app/event/admin/admin_add_wine.dart';
import 'package:wine_app/event/admin/admin_delete_wine.dart';
import 'package:wine_app/event/admin/admin_get_revenue.dart';
import 'package:wine_app/event/admin/admin_password_recovery.dart';
import 'package:wine_app/event/admin/admin_update_wine.dart';
import 'package:wine_app/event/admin/admin_user_list_call.dart';
import 'package:wine_app/shared/model/cate.dart';
import 'package:wine_app/shared/model/revenue.dart';
import 'package:wine_app/shared/model/user_data.dart';
import 'package:wine_app/shared/model/wine.dart';
import 'package:wine_app/shared/validation.dart';

class AdminBloc extends BaseBloc {
  WineRepo _wineRepo;
  OrderRepo _orderRepo;
  UserRepo _userRepo;

  AdminBloc._internal({
    @required WineRepo wineRepo,
    @required OrderRepo orderRepo,
    @required UserRepo userRepo,
  })  : _wineRepo = wineRepo,
        _orderRepo = orderRepo,
        _userRepo = userRepo;

  static AdminBloc _instance;

  static AdminBloc getInstance({
    @required WineRepo wineRepo,
    @required OrderRepo orderRepo,
    @required UserRepo userRepo,
  }) {
    if (_instance == null) {
      _instance = AdminBloc._internal(
        wineRepo: wineRepo,
        orderRepo: orderRepo,
        userRepo: userRepo,
      );
    }
    return _instance;
  }

  final _cateIdSubject = BehaviorSubject<String>();

  Stream get cateIdStream => _cateIdSubject.stream;

  Sink get cateIdSink => _cateIdSubject.sink;

  final _statusSubject = BehaviorSubject<int>();

  Stream get statusStream => _statusSubject.stream;

  Sink get statusSink => _statusSubject.sink;

  var numberValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (num, sink) {
      if (Validation.isNumber(num)) {
        sink.add(null);
        return;
      }
      sink.add('Chỉ nhập số.');
    },
  );

  final _numberSubject = BehaviorSubject<String>();
  Stream get numberStream => _numberSubject.stream.transform(numberValidation);

  Sink get numberSink => _numberSubject.sink;

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case AdminUserListCall:
        handleAdminUserListCall(event);
        break;
      case AdminUpdateWine:
        handleAdminUpdateWine(event);
        break;
      case AdminAddWine:
        handleAdminAddWine(event);
        break;
      case AdminDeleteWine:
        handleAdminDeleteWine(event);
        break;
      case AdminGetRevenue:
        handleAdminGetRevenue(event);
        break;
      case AdminPasswordRecovery:
        handleAdminPasswordRecovery(event);
        break;
    }
  }

  handleAdminDeleteWine(event){
    AdminDeleteWine e = event as AdminDeleteWine;
    _wineRepo.deleteWine(e.oid).then((status) {
      statusSink.add(status);
    }, onError: (e) {});
  }

  handleAdminPasswordRecovery(event){
    AdminPasswordRecovery e = event as AdminPasswordRecovery;
    _userRepo.passwordRecovery(e.phone).then((status) {
      statusSink.add(status);
    }, onError: (e) {});
  }

  handleAdminGetRevenue(event) {
    AdminGetRevenue e = event as AdminGetRevenue;
  }

  handleAdminUserListCall(event) {}

  handleAdminUpdateWine(event) {
    AdminUpdateWine e = event as AdminUpdateWine;
    _wineRepo.updateWine(e.wine).then((status) {
      print(status);
      statusSink.add(status);
    }, onError: (e) {});
  }

  handleAdminAddWine(event) {
    AdminAddWine e = event as AdminAddWine;
    _wineRepo.addWine(e.wine).then((status) {
      print(status);
      statusSink.add(status);
    }, onError: (e) {});
  }

  Stream<List<UserData>> getListUserData() {
    return Stream<List<UserData>>.fromFuture(_userRepo.findAllUser());
  }

  Stream<List<Cate>> getStreamCateList() {
    return Stream<List<Cate>>.fromFuture(_wineRepo.getWineCategories());
  }

  Stream<List<Wine>> getStreamWineList(cateId) {
    return Stream<List<Wine>>.fromFuture(_wineRepo.getWineByCateId(cateId));
  }

  Stream<List<Revenue>> getRevenueList(month) {
    return Stream<List<Revenue>>.fromFuture(_orderRepo.getRevenues(month));
  }

  Stream<List<Wine>> getStreamWines() {
    return Stream<List<Wine>>.fromFuture(_wineRepo.getWines());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cateIdSubject.close();
    _statusSubject.close();_numberSubject.close();
  }
}
