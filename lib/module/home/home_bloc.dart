import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wine_app/base/base_bloc.dart';
import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/data/remote/order_service.dart';
import 'package:wine_app/data/remote/wine_service.dart';
import 'package:wine_app/data/repo/order_repo.dart';
import 'package:wine_app/data/repo/wine_repo.dart';
import 'package:wine_app/event/home/add_to_cart_event.dart';
import 'package:wine_app/event/home/confirm_order_event.dart';
import 'package:wine_app/event/home/home_swipe.dart';
import 'package:wine_app/event/home/minus_from_cart_event.dart';
import 'package:wine_app/module/home/main_container_page.dart';
import 'package:wine_app/shared/model/cate.dart';
import 'package:wine_app/shared/model/shopping_cart.dart';
import 'package:wine_app/shared/model/user_data.dart';
import 'package:wine_app/shared/model/wine.dart';

class HomeBloc extends BaseBloc {
  WineRepo _wineRepo;
  OrderRepo _orderRepo;
  var _shoppingCart = ShoppingCart();

  final _cateIdSubject = BehaviorSubject<String>();

  Stream get cateIdStream => _cateIdSubject.stream;

  Sink get cateIdSink => _cateIdSubject.sink;

  final _indexSubject = BehaviorSubject<int>();

  Stream get indexStream => _indexSubject.stream;

  Sink get indexSink => _indexSubject.sink;
  final _pageSubject = BehaviorSubject<PageController>();

  Stream get pageStream => _pageSubject.stream;

  Sink get pageSink => _pageSubject.sink;

  static HomeBloc _instance;

  HomeBloc._internal({
    @required WineRepo wineRepo,
    @required OrderRepo orderRepo,
  })  : _wineRepo = wineRepo,
        _orderRepo = orderRepo;

  static HomeBloc getInstance({
    @required WineRepo wineRepo,
    @required OrderRepo orderRepo,
  }) {
    if (_instance == null) {
      _instance = HomeBloc._internal(
        wineRepo: wineRepo,
        orderRepo: orderRepo,
      );
    }
    return _instance;
  }

  final _shoppingCartSubject = BehaviorSubject<int>();

  Stream<int> get shoppingCartStream => _shoppingCartSubject.stream;

  Sink<int> get shoppingCartSink => _shoppingCartSubject.sink;

  doingSomething() {
    return "doingSomething";
  }

  getUserProfile() {
    _wineRepo.profileUser().then((onValue) => UserData.u = onValue);
  }

  getStreamUserProfile() {
    return Stream<UserData>.fromFuture(_wineRepo.profileUser());
  }

  getShoppingCartInfo() async {
    Stream<int>.fromFuture(_orderRepo.getShoppingCartInfo()).listen((total) {
      print("------------------");
      print(total);
      shoppingCartSink.add(total);
    }, onError: (err) {
      _shoppingCartSubject.addError(err);
    });
  }

  Stream<List<Cate>> getStreamCateList() {
    return Stream<List<Cate>>.fromFuture(_wineRepo.getWineCategories());
  }

  List<Cate> getCateList() {
    print("vào đc getcatelist");
    var list = List<Cate>();
    Future.delayed(Duration(seconds: 0), () {
      _wineRepo.getWineCategories().then((listCate) {
        print("vào đc getcatelist.then");
        print(listCate);
        return listCate;
      }, onError: (e) {
        print("vào đc getcatelist.err");
      });
    });
    return list;
  }

  Stream<List<Wine>> getStreamWineList(cateId) {
    return Stream<List<Wine>>.fromFuture(_wineRepo.getWineByCateId(cateId));
  }

  getStreamWines() {
    return Stream<List<Wine>>.fromFuture(_wineRepo.getWines());
  }

  List<Wine> getWineListByCateId(String cateId) {
    var list = List<Wine>();
    print('0000000');
    Stream<List<Wine>>.fromFuture(
      _wineRepo.getWineByCateId(cateId),
    ).listen(
      (listWine) {
        list = listWine;
        print("list wine ${listWine.length}");
      },
      onError: (err) {},
    );
    return list;
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case AddToCartEvent:
        handleAddToCart(event);
        break;
      case MinusFromCart:
        handleMinusFormCartEvent(event);
        break;
      case ConfirmOrderEvent:
        handleConfirmOrderEvent(event);
        break;
    }
  }

  final _orderSubject = BehaviorSubject<int>();

  Stream<int> get orderStream => _orderSubject.stream;

  Sink<int> get orderSink => _orderSubject.sink;

  handleConfirmOrderEvent(event) {
    ConfirmOrderEvent e = event as ConfirmOrderEvent;
    _orderRepo.confirmOrder().then((statusCode) {
      print(statusCode);
      orderSink.add(statusCode);
    }, onError: (e) {
      try{
        orderSink.add(int.parse(e['status'].toString()));
        print("confirmOrder: ${e['status']}");
      }catch(e) {
        print("confirmOrder: $e");
      }
    });
  }

  handleMinusFormCartEvent(event) {
    MinusFromCart e = event as MinusFromCart;
    _orderRepo.minusFromCart(e.wineId).then((statusCode) {
      print(statusCode);
    }, onError: (e) {});
  }

  handleAddToCart(event) {
    AddToCartEvent e = event as AddToCartEvent;
    _orderRepo.addToCart(e.wineId).then((statusCode) {
      print(statusCode);
    }, onError: (e) {});
  }

  getShoppingCartList() {
    return Stream<List<ShoppingCart>>.fromFuture(
      _orderRepo.getShoppingCart(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _indexSubject.close();
    _pageSubject.close();
    _shoppingCartSubject.close();
    _cateIdSubject.close();
    _orderSubject.close();
  }

  handleSwipe(index) {
    indexSink.add(index);
  }
}
