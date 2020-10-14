import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/event/home/add_to_cart_event.dart';
import 'package:wine_app/event/home/confirm_order_event.dart';
import 'package:wine_app/event/home/minus_from_cart_event.dart';
import 'package:wine_app/module/detail/detail_page.dart';
import 'package:wine_app/module/home/home_bloc.dart';
import 'package:wine_app/module/home/main_container_page.dart';
import 'package:wine_app/shared/app_color.dart';
import 'package:wine_app/shared/model/shopping_cart.dart';
import 'package:wine_app/shared/model/user_data.dart';
import 'package:wine_app/shared/model/user_data.dart';
import 'package:wine_app/shared/model/user_data.dart';
import 'package:wine_app/shared/model/wine.dart';
import 'package:wine_app/shared/widget/btn_cart_action.dart';
import 'package:wine_app/shared/widget/normal_button.dart';
import 'package:wine_app/shared/widget/xoayxoay.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeBloc>(
          builder: (context, bloc, child) => ProductListWidget(bloc)),
    );
  }
}

class ConfirmInfoWidget extends StatefulWidget {
  final double total;

  ConfirmInfoWidget(
    this.total,
  );

  @override
  _ConfirmInfoWidgetState createState() => _ConfirmInfoWidgetState();
}

class _ConfirmInfoWidgetState extends State<ConfirmInfoWidget> {
  @override
  Widget build(BuildContext context) {
    double point = double.parse(UserData.u.point);
    double persent = 0;
    if (point >= 1000) {
      persent = 20;
    } else if (point >= 500) {
      persent = 15;
    } else if (point >= 250) {
      persent = 10;
    } else {
      persent = 0;
    }
    return Consumer<HomeBloc>(builder: (context, bloc, child) {
      return Container(
        height: 170,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tổng tiền: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                    symbol: 'vnđ',
                    fractionDigits: 0,
                  ), amount: widget.total).output.symbolOnRight}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.cyan),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Giảm giá: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                    symbol: '%',
                    fractionDigits: 0,
                  ), amount: persent).output.symbolOnRight}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.cyan),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Thành tiền: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                    symbol: 'vnđ',
                    fractionDigits: 0,
                  ), amount: (widget.total - (widget.total * (persent / 100)))).output.symbolOnRight}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.cyan),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () {
                bloc.event.add(ConfirmOrderEvent());
              },
              color: Colors.cyan,
              padding: EdgeInsets.symmetric(horizontal: 50),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Thanh toán".toUpperCase(),
                style: TextStyle(
                    fontSize: 14, letterSpacing: 2.2, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ProductListWidget extends StatefulWidget {
  HomeBloc bloc;

  ProductListWidget(this.bloc);

  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  List<ShoppingCart> productList = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  showMessage(status, color) {
    Fluttertoast.showToast(
        msg: status.toString(),
        timeInSecForIosWeb: 10,
        webShowClose: true,
        toastLength: Toast.LENGTH_LONG,
        textColor: Colors.white,
        backgroundColor: color,
        gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
//    productList.sort((p1, p2) => p1.wine.price.compareTo(p2.wine.price));
    return Consumer<HomeBloc>(
      builder: (context, bloc, child) => StreamProvider<int>.value(
        initialData: 0,
        value: bloc.orderStream,
        child: Consumer<int>(
          builder: (context, status, child) {
            if (status == 200) {
              bloc.indexSink.add(0);
              showMessage("Thanh toán thành công!", Colors.lightGreen);
              // showDialog(context: context, builder: (context) {
              //   return CustomDialog(
              //     title: "Thông báo",
              //     description: "Thanh toán thành công",
              //     buttonText: "OK",
              //     image: AssetImage('assets/img/success.gif'),
              //   );
              // });
              HomeContainerPage.pagecontroller.jumpToPage(0);
              bloc.orderSink.add(0);
            }
            else if(status == 205){
              showMessage("Lỗi thanh toán. Mời bạn thử lại", Colors.brown[600]);
              HomeContainerPage.pagecontroller.jumpToPage(0);
              bloc.orderSink.add(0);
            }
            else if (status == 404) {
              bloc.indexSink.add(1);
              showMessage("Mời bạn thử lại", Colors.brown[600]);
              HomeContainerPage.pagecontroller.jumpToPage(0);
              bloc.orderSink.add(0);
            }
            else if (status == 406) {
              bloc.indexSink.add(1);
              showMessage("Gặp sự cố về dữ liệu! Mời bạn thử lại", Colors.red);
              HomeContainerPage.pagecontroller.jumpToPage(1);
              bloc.orderSink.add(0);
            }
            else if(status == 417){
              showMessage("Gặp sự cố về dữ liệu! Mời bạn thử lại", Colors.red);
              setState(() {
                HomeContainerPage.pagecontroller.jumpToPage(1);
              });
              bloc.orderSink.add(0);
            }
            return StreamProvider.value(
              initialData: productList,
              value: bloc.getShoppingCartList(),
              child: Consumer<List<ShoppingCart>>(
                  builder: (context, prodList, child) {
                if (prodList == null) {
                  return Center(
                    child: ColorLoader(),
                  );
                }
                productList = prodList;
                double total = 0;
                for (var item in prodList) {
                  total += item.amount * item.wine.price;
                }
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: prodList.length,
                        itemBuilder: (context, index) => _buildRow(
                            bloc,
                            productList[index].wine,
                            productList[index].amount,
                            index),
                      ),
                    ),
                    ConfirmInfoWidget(total),
                  ],
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(
    HomeBloc bloc,
    Wine product,
    int amount,
    int index,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        product: product,
                      ),
                    ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(1),
                  color: product.color,
                  child: Image.network(
                    product.thumbnail,
                    width: 90,
                    height: 140,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15.0,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Giá: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                          symbol: 'vnđ',
                          fractionDigits: 0,
                        ), amount: double.parse(product.price.toString())).output.symbolOnRight}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _buildCartAction(bloc, product, amount, index),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartAction(HomeBloc bloc, Wine product, int amount, int index) {
    return StreamProvider<int>.value(
      value: bloc.shoppingCartStream,
      initialData: amount,
      child: Consumer<int>(
        builder: (context, total, child) => Row(
          children: <Widget>[
            BtnCartAction(
              title: '-',
              onPressed: () {
                bloc.event.add(MinusFromCart(wineId: product.id["\$oid"]));
                bloc.shoppingCartSink.add(total - 1);
                // HomeContainerPage.pagecontroller.jumpToPage(0);
                setState(() {
                  HomeContainerPage.pagecontroller.jumpToPage(0);
                  HomeContainerPage.pagecontroller.jumpToPage(1);
                  // productList[index].amount -= 1;
                  // if (productList[index].amount == 0) {
                  //   productList.removeAt(index);
                  // }
                });
              },
            ),
            SizedBox(
              width: 15,
            ),
            StreamProvider.value(
              initialData: productList,
              value: bloc.getShoppingCartList(),
              child:
                  Consumer<List<ShoppingCart>>(builder: (context, list, child) {
                return Text('${productList[index].amount}',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red));
              }),
            ),
            SizedBox(
              width: 15,
            ),
            BtnCartAction(
              title: '+',
              onPressed: () {
                bloc.event.add(AddToCartEvent(wineId: product.id["\$oid"]));
                bloc.shoppingCartSink.add(total + 1);
                // HomeContainerPage.pagecontroller.jumpToPage(0);
                // HomeContainerPage.pagecontroller.jumpToPage(1);
                setState(() {
                  HomeContainerPage.pagecontroller.jumpToPage(0);
                  HomeContainerPage.pagecontroller.jumpToPage(1);
                  // productList[index].amount += 1;
                  // if (productList[index].amount == product.capacity) {
                  //   productList[index].amount = product.capacity;
                  // }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final AssetImage image;

  CustomDialog({this.title, this.description, this.buttonText, this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 100,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0,10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(buttonText),
                ),
              ),
              Positioned(
                top: 0,
                left: 16,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 50,
                  backgroundImage: image,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
