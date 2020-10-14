import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:wine_app/module/admin/admin_add_wine_page.dart';
import 'package:wine_app/module/admin/admin_bloc.dart';
import 'package:wine_app/module/detail/detail_page.dart';
import 'package:wine_app/shared/constants.dart';
import 'package:wine_app/shared/model/cate.dart';
import 'package:wine_app/shared/model/user_data.dart';
import 'package:wine_app/shared/model/wine.dart';
import 'package:wine_app/shared/widget/normal_button.dart';
import 'package:wine_app/shared/widget/xoayxoay.dart';

import 'admin_wine_detail_page.dart';

class WinePage extends StatefulWidget {
  AdminBloc bloc;

  WinePage({this.bloc});

  @override
  _WinePageState createState() => _WinePageState();
}

class _WinePageState extends State<WinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý rượu'),
        elevation: 1,
        actions: <Widget>[
          StreamProvider<List<Wine>>.value(
            value: widget.bloc.getStreamWines(),
            initialData: null,
            child: Consumer<List<Wine>>(
              builder: (context, wines, child) {
                if (wines == null) {
                  return IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    onPressed: null,
                  );
                }
                return IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: DataSearch(listWine: wines, bloc: widget.bloc));
                  },
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminAddWineScreen(bloc: widget.bloc),
                  ));
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Body(
        bloc: widget.bloc,
      ),
    );
  }
}

class Body extends StatefulWidget {
  AdminBloc bloc;

  Body({this.bloc});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        //   child: Text("Rượu Vang - Đẳng cấp và quý phái ", style: TextStyle(fontSize: 35)),
        // ),
        Categories(widget.bloc),
        Wines(widget.bloc),
      ],
    );
  }
}

class Wines extends StatefulWidget {
  String cateId;
  AdminBloc bloc;

  Wines(this.bloc);

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
    // ws.clear();
  }

  @override
  Future<void> didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // print("Home page didChangeDependencies");
    // ws.clear();
    // var bloc = Provider.of<HomeBloc>(context);
    // cates = bloc.getCateList();
    // bloc.getUserProfile();
    // ws = cates.length > 0 ? bloc.getWineListByCateId("1"):ws = List<Wine>();
    // bloc.getShoppingCartList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<String>.value(
      value: widget.bloc.cateIdStream,
      initialData: cates.length > 0 ? cates[0].cateId : null,
      child: Consumer<String>(
        builder: (context, cid, child) => StreamProvider.value(
          initialData: ws,
          value: widget.bloc.getStreamWineList(cid),
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
                                  builder: (context) => AdminWineDetailsScreen(
                                    product: wines[index],
                                    bloc: widget.bloc,
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
    );
  }
}

class Categories extends StatefulWidget {
  AdminBloc bloc;

  Categories(this.bloc);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  static int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: widget.bloc.getStreamCateList(),
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
        Cate.cates = cates;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
          child: SizedBox(
            height: 25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cates.length,
              itemBuilder: (context, index) =>
                  buildCategory(index, cates, widget.bloc),
            ),
          ),
        );
      }),
    );
  }

  Widget buildCategory(int index, List<Cate> cates, AdminBloc bloc) {
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
                    "${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                          symbol: 'vnđ',
                          fractionDigits: 0,
                        ), amount: double.parse(wine.price.toString())).output.symbolOnRight}",
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

class DataSearch extends SearchDelegate<String> {
  var wines = [];
  var recentWines = [];
  final List<Wine> listWine;
  AdminBloc bloc;

  DataSearch({this.listWine, this.bloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.close),
        color: Colors.grey,
        iconSize: 30,
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    wines.clear();
    for (var wine in listWine) {
      wines.add(wine.name);
    }

    recentWines.clear();
    if (listWine.length > 1) {
      recentWines.add(listWine[0].name);
      recentWines.add(listWine[1].name);
    }

    final suggestionList = recentWines.isEmpty
        ? recentWines
        : listWine
            .where((p) => p.name.toUpperCase().contains(query.toUpperCase()))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Wine wine;
          for (Wine w in listWine) {
            if (w == suggestionList[index]) {
              wine = w;
            }
          }
          close(context, null);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminWineDetailsScreen(
                  product: wine,
                  bloc: bloc,
                ),
              ));
        },
        leading: Image.network(
          suggestionList[index].thumbnail,
          // 'assets/img/wine_glass.png',
          height: 50,
          width: 25,
          fit: BoxFit.fitHeight,
        ),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].name.substring(0, query.length),
            // text: query,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: suggestionList[index].name.substring(query.length),
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
