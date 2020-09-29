import 'package:badges/badges.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/base/base_widget.dart';
import 'package:wine_app/data/remote/order_service.dart';
import 'package:wine_app/data/remote/wine_service.dart';
import 'package:wine_app/data/repo/order_repo.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/data/repo/wine_repo.dart';
import 'package:wine_app/module/checkout/checkout_page.dart';
import 'package:wine_app/module/home/home_bloc.dart';
import 'package:wine_app/module/home/home_page.dart';
import 'package:wine_app/module/info/info_page.dart';
import 'package:wine_app/module/profile/profile_page.dart';
import 'package:wine_app/module/signin/signin_bloc.dart';
import 'package:wine_app/shared/model/shopping_cart.dart';
import 'package:wine_app/shared/model/user_data.dart';
import 'package:wine_app/shared/widget/xoayxoay.dart';

class HomeContainerPage extends StatelessWidget {
  static PageController pagecontroller;
  @override
  Widget build(BuildContext context) {
    if(pagecontroller == null) {
      pagecontroller = PageController();
    }
    return MultiProvider(
      providers: [
        Provider.value(value: OrderService()),
        Provider.value(value: WineService()),
        ProxyProvider<WineService, WineRepo>(
          builder: (context, wineService, previous) =>
              WineRepo(wineService: wineService),
        ),
        ProxyProvider<OrderService, OrderRepo>(
          builder: (context, orderService, previous) =>
              OrderRepo(orderService: orderService),
        ),
      ],
      child: Scaffold(
        body: MainContainerWidget(pagecontroller),
        bottomNavigationBar: BottomNavyWidget(pagecontroller),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, right: 20),
      child: IconButton(
        iconSize: 30,
        icon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        onPressed: () {
          showSearch(context: context, delegate: DataSearch());
        },
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final wines = ['an', 'bay', 'cai', 'dau'];
  final recentWines = ['an', 'bay'];

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
    // TODO: implement buildResults
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestionList = query.isEmpty
        ? recentWines
        : wines.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) =>
          ListTile(
            onTap: () {
              showResults(context);
            },
            leading: Icon(Icons.local_florist),
            title: RichText(
              text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
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

class MainContainerWidget extends StatefulWidget {
  PageController pagecontroller;

  MainContainerWidget(this.pagecontroller);

  @override
  _MainContainerWidgetState createState() => _MainContainerWidgetState();
}

class _MainContainerWidgetState extends State<MainContainerWidget> {
//  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
//    widget.pagecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<HomeBloc>.value(
      value: HomeBloc.getInstance(
        orderRepo: Provider.of(context),
        wineRepo: Provider.of(context),
      ),
      child: MainBody(widget.pagecontroller),
    );
  }
}

class MainBody extends StatefulWidget {
  PageController pagecontroller;

  MainBody(this.pagecontroller);

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    var bloc = Provider.of<HomeBloc>(context);
//    userData= bloc.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(builder: (context, bloc, child) {
      return StreamProvider.value(
        value: bloc.indexStream,
        initialData: 0,
        child: SizedBox.expand(
          child: PageView(
            controller: widget.pagecontroller,
            onPageChanged: (index) {
//                  setState(() => _currentIndex = index);
              bloc.indexSink.add(index);
            },
            children: <Widget>[
              HomePage(),
              CheckOutPage(),
              ProfilePage(),
              InfoPage(),
            ],
          ),
        ),
      );
    });
  }
}


class BottomNavyWidget extends StatefulWidget {
  PageController pagecontroller;

  BottomNavyWidget(this.pagecontroller);

  @override
  _BottomNavyWidgetState createState() => _BottomNavyWidgetState();
}

class _BottomNavyWidgetState extends State<BottomNavyWidget> {
  @override
  Widget build(BuildContext context) {
    return Provider<HomeBloc>.value(
      value: HomeBloc.getInstance(
        wineRepo: Provider.of(context),
        orderRepo: Provider.of(context),
      ),
      child: Consumer<HomeBloc>(
        builder: (context, bloc, child) =>
        StreamProvider<int>.value(
          initialData: 0,
          value: bloc.indexStream,
          child: Consumer<int>(
              builder: (context, i, child) =>
                  BottomNavyBarWidget(
                    i: i,
                    pagecontroller: widget.pagecontroller,
                  )),
        ),
      ),
    );
  }
}

class BottomNavyBarWidget extends StatefulWidget {
  PageController pagecontroller;
  int i;

  BottomNavyBarWidget({this.i, this.pagecontroller});

  @override
  _BottomNavyBarWidgetState createState() => _BottomNavyBarWidgetState();
}

class _BottomNavyBarWidgetState extends State<BottomNavyBarWidget> {
  var bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
    bloc = Provider.of<HomeBloc>(context);
    bloc.getShoppingCartInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildItemBottomNavy(text, icon, color, colorIA) {
      return BottomNavyBarItem(
          title: Text(text),
          icon: icon,
          activeColor: color,
          inactiveColor: colorIA);
    }

    bloc.getShoppingCartInfo();
    return BottomNavyBar(
      selectedIndex: widget.i,
      onItemSelected: (index) {
//              setState(() => _currentIndex = index);
        bloc.indexSink.add(index);
        widget.pagecontroller.jumpToPage(index);
      },
      items: <BottomNavyBarItem>[
        _buildItemBottomNavy(
            'Trang chủ', Icon(Icons.home), Colors.pink[300], Colors.grey),
        _buildItemBottomNavy(
            'Giỏ hàng',
            Consumer<HomeBloc>(
              builder: (context, bl, child) =>
              StreamProvider<int>.value(
                initialData: 0,
                value: bl.shoppingCartStream,
                child: Consumer<int>(
                  builder: (context, total, child) =>
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 15, right: 20),
                          child: Badge(
                            badgeContent: Text(
                              total < 10 ? '$total' : '9+',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Icon(Icons.shopping_cart),
                          ),
                        ),
                      ),
                ),
              ),
            ),
            Colors.cyan,
            Colors.grey),
        _buildItemBottomNavy('Hồ sơ', Icon(Icons.account_circle),
            Colors.lightGreenAccent, Colors.grey),
        _buildItemBottomNavy(
            'Thông tin', Icon(Icons.info), Colors.lightBlueAccent, Colors.grey),
      ],
    );
  }
}
