import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:wine_app/module/detail/detail_page.dart';
import 'package:wine_app/shared/constants.dart';
import 'package:wine_app/shared/model/cate.dart';
import 'package:wine_app/shared/model/user_data.dart';
import 'package:wine_app/shared/model/wine.dart';
import 'package:wine_app/shared/widget/normal_button.dart';
import 'package:wine_app/shared/widget/xoayxoay.dart';

import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  static List<Cate> cates = List<Cate>();

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    print("object");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          child: Text("Rượu Vang - Đẳng cấp và quý phái ", style: TextStyle(fontSize: 35)),
        ),
        Categories(Body.cates),
        Wines(Body.cates),
      ],
    );
  }
}

class Wines extends StatefulWidget {
  String cateId;
  List<Cate> cs;

  Wines(this.cs);

  @override
  _WinesState createState() => _WinesState();
}

class _WinesState extends State<Wines> {
  List<Cate> cates = List<Cate>();
  List<Wine> ws = List<Wine>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ws.clear();
  }
  @override
  Future<void> didChangeDependencies()  {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("Home page didChangeDependencies");
    ws.clear();
    var bloc = Provider.of<HomeBloc>(context);
    cates = bloc.getCateList();
    bloc.getUserProfile();
    ws = cates.length > 0 ? bloc.getWineListByCateId("1"):ws = List<Wine>();
    bloc.getShoppingCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(
      builder: (context, bloc, child) => StreamProvider<String>.value(
        value: bloc.cateIdStream,
        initialData: cates.length > 0 ? cates[0].cateId : null,
        child: Consumer<String>(
          builder: (context, cid, child) => StreamProvider.value(
            initialData: ws,
            value: bloc.getStreamWineList(cid),
            child: Consumer<List<Wine>>(
              builder: (context, wines, child) {
                if (wines == null) {
                  return Center(
                    child: ColorLoader(),
                  );
                }
                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                    child: GridView.builder(
                        itemCount: wines.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: kDefaultPaddin,
                          crossAxisSpacing: kDefaultPaddin,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) => ItemCard(
                            wine: wines[index],
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      product: wines[index],
                                    ),
                                  ));
//                        print(bloc.doingSomething());
                            }

//                      ),
                            )),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Categories extends StatefulWidget {
  List<Cate> cs;

  Categories(this.cs);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  static int selectedIndex = 0;
  HomeBloc bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    bloc = Provider.of<HomeBloc>(context);
//    categories = bloc.getCateList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(
      builder: (context, bl, child) => StreamProvider.value(
        value: bl.getStreamCateList(),
        initialData: null,
        catchError: (context, error) {
          return error;
        },
        child: Consumer<Object>(builder: (context, data, child) {
          if (data == null) {
            return Center(
              child: ColorLoader(),
            );
          }
          var cates = data as List<Cate>;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
            child: SizedBox(
              height: 25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cates.length,
                itemBuilder: (context, index) =>
                    buildCategory(index, cates, bl),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildCategory(int index, List<Cate> cates, HomeBloc bloc) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        bloc.cateIdSink.add(cates[index].cateId);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              cates[index].cateName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? Colors.pink[200] : kTextColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPaddin / 4),
              //top padding 5
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: selectedIndex == index
                    ? Colors.pink[200]
                    : Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Wine wine;
  final Function press;

  const ItemCard({
    Key key,
    this.wine,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RandomColor _randomColor = RandomColor();
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                color: wine.color,
                borderRadius: BorderRadius.circular(16),
              ),
//              child: Hero(
//                tag: "${wine.id}",
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Image.network(
                    wine.thumbnail,
                    height: 120,
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddin / 4),
                    child: Text(
                      // products is out demo list
                      wine.name.length > 33
                          ? "${wine.name.substring(0, 26)}..."
                          : wine.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _randomColor.randomColor(
                          colorBrightness: ColorBrightness.veryDark,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      "${wine.alcohol}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: kTextColor),
                    ),
                  ),
                  Text(
                    "${FlutterMoneyFormatter(
                        settings: MoneyFormatterSettings(
                          symbol: 'vnđ',
                          fractionDigits: 0,
                        ), amount: double.parse(wine.price.toString()))
                        .output.symbolOnRight}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _randomColor.randomColor(
                          colorBrightness: ColorBrightness.veryDark,
                        )),
                  )
                ],
              ),
            ),
          ),
//          ),
//          Padding(
//            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
//            child: Text(
//              // products is out demo list
//              wine.name,
//              style: TextStyle(color: kTextLightColor),
//            ),
//          ),
//          Text(
//            "\$${wine.price}",
//            style: TextStyle(fontWeight: FontWeight.bold),
//          )
        ],
      ),
    );
  }
}