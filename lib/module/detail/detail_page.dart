import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/data/repo/order_repo.dart';
import 'package:wine_app/data/repo/wine_repo.dart';
import 'package:wine_app/event/home/add_to_cart_event.dart';
import 'package:wine_app/event/home/add_to_cart_success.dart';
import 'package:wine_app/module/home/home_bloc.dart';
import 'package:wine_app/shared/model/wine.dart';
import 'package:wine_app/shared/widget/bloc_listener.dart';
import 'package:wine_app/shared/widget/loading_task.dart';

class DetailsScreen extends StatelessWidget {
  final Wine product;

  const DetailsScreen({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
     value: HomeBloc.getInstance(
       orderRepo: OrderRepo(),
       wineRepo: WineRepo(),
     ),
      child: Scaffold(
        // each product have a color
        backgroundColor: product.color,
        appBar: AppBar(
          backgroundColor: product.color,
        actions: <Widget>[
          Consumer<HomeBloc>(
            builder: (context, bloc, child) {
              return StreamProvider<int>.value(
                value: bloc.shoppingCartStream,
                initialData: 0,
                child: Consumer<int>(
                  builder: (context, total, child) => Container(
                    margin: EdgeInsets.only(top: 15, right: 20),
                    child: Badge(
                      badgeContent: Text(
                        '$total',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Icon(Icons.shopping_cart),
                    ),
                  ),
                ),
              );
            },
          )
        ],
        ),
        body: Body(product: product),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final Wine product;

  const Body({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: EdgeInsets.only(
                    top: size.height * 0.12,
                    left: 20,
                    right: 20,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Description(product: product),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Giá\n",
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: product.color)),
                            TextSpan(
                              text: "${FlutterMoneyFormatter(
                                  settings: MoneyFormatterSettings(
                                    symbol: 'vnđ',
                                    fractionDigits: 0,
                                  ), amount: double.parse(product.price.toString()))
                                  .output.symbolOnRight}",
                              style: Theme.of(context).textTheme.body1.copyWith(
                                  color: product.color,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20 / 2),
                      AddToCart(product: product)
                    ],
                  ),
                ),
                SizedBox(height: 20),
//                Container(
//                  decoration: BoxDecoration(
//                    shape: BoxShape.rectangle
//                  ),
//                  alignment: Alignment(0.85,-0.95),
//                  child: Text(
//                    "${product.capacity}",
//                  ),
//                ),
                ProductTitleWithImage(product: product),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Wine product;

  _buildInfo(context, title, content, color) {
    return Container(
      width: 150,
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: "$title\n",
                  style: Theme.of(context).textTheme.body1.copyWith(
                        color: Colors.black,
                      )),
              TextSpan(
                text: "$content",
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            product.name,
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  _buildInfo(
                      context, "Nhà sản xuất", product.producer, Colors.white),
                  SizedBox(height: 20),
                  _buildInfo(context, "Quốc gia", product.country, Colors.white),
                  SizedBox(height: 20),
                  _buildInfo(context, "Thể tích", product.size, Colors.white),
                  SizedBox(height: 20),
                  _buildInfo(
                      context, "Độ rượu", product.alcohol, product.color),
                  SizedBox(height: 20),
                  _buildInfo(
                      context, "Số lượng", product.capacity, product.color),
                ],
              ),
              SizedBox(width: 50),
              Expanded(
                child: Hero(
                  tag: product.id,
                  child: Image.network(product.thumbnail, height: 300),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Wine product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        product.description,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}

class AddToCart extends StatefulWidget {
  const AddToCart({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Wine product;

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(
      builder: (context, bloc, child) => StreamProvider.value(
        initialData: 0,
        value: bloc.shoppingCartStream,
        child: Consumer<int>(
          builder: (context, total, child) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: widget.product.color,
                      onPressed: () {
                        print(widget.product.id["\$oid"]);
                        bloc.event.add(AddToCartEvent(wineId: widget.product.id["\$oid"]));
                        bloc.shoppingCartSink.add(total+1);
                      },
                      child: Text(
                        "Thêm vào giỏ hàng".toUpperCase(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
