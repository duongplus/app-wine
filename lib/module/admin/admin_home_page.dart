import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/data/remote/order_service.dart';
import 'package:wine_app/data/remote/user_service.dart';
import 'package:wine_app/data/remote/wine_service.dart';
import 'package:wine_app/data/repo/order_repo.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/data/repo/wine_repo.dart';
import 'package:wine_app/module/admin/admin_bloc.dart';
import 'package:wine_app/module/admin/admin_list_profile_page.dart';
import 'package:wine_app/module/admin/admin_revenue_page.dart';
import 'package:wine_app/module/admin/admin_wine_page.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: OrderService()),
        Provider.value(value: WineService()),
        Provider.value(value: UserService()),
        ProxyProvider<WineService, WineRepo>(
          builder: (context, wineService, previous) =>
              WineRepo(wineService: wineService),
        ),
        ProxyProvider<OrderService, OrderRepo>(
          builder: (context, orderService, previous) =>
              OrderRepo(orderService: orderService),
        ),
        ProxyProvider<UserService, UserRepo>(
          builder: (context, userService, previous) =>
              UserRepo(userService: userService),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Trang Quản trị",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: AdminHomeWidget(),
      ),
    );
  }
}

class AdminHomeWidget extends StatefulWidget {
  @override
  _AdminHomeWidgetState createState() => _AdminHomeWidgetState();
}

class _AdminHomeWidgetState extends State<AdminHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Provider<AdminBloc>.value(
      value: AdminBloc.getInstance(
        wineRepo: Provider.of(context),
        orderRepo: Provider.of(context),
        userRepo: Provider.of(context),
      ),
      child: Consumer<AdminBloc>(
        builder: (context, bloc, child) => GridView.count(
          childAspectRatio: 1,
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          primary: false,
          children: <Widget>[
            _buildCard('assets/img/user.png', "Quản lý người dùng", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListProfileWidget(bloc: bloc,),
                  ));
            }),
            _buildCard('assets/img/wine_lap.png', "Quản lý rượu", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WinePage(bloc: bloc,),
                  ));
            }),
            _buildCard('assets/img/chart.png', "Doanh thu", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminRevenuePage(bloc: bloc,),
                  ));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String uri, String text, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                uri,
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.brown[600],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
