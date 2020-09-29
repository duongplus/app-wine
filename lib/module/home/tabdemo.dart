import 'package:flutter/material.dart';
import 'package:wine_app/base/base_widget.dart';

class TabContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: '',
      child: TabsDemo(),
      actions: <Widget>[],
      di: [],
    );
  }
}


class TabsDemo extends StatefulWidget {
  @override
  _TabsDemoState createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo> {
  TabController _controller;

  @override
  void initState() {
    super.initState();
  }

  List<String> categories = ["a", "b", "c", "d", "e", "f", "g", "h"];

  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
        home: DefaultTabController(
            length: categories.length,
            child: new Scaffold(
                appBar: new AppBar(
                  title: new Text("Title"),
                  bottom: new TabBar(
                    isScrollable: true,
                    tabs: List<Widget>.generate(categories.length, (int index) {
                      print(categories[0]);
                      return new Tab(icon: Icon(Icons.directions_car),
                          text: "some random text");
                    }),

                  ),
                ),

                body: new TabBarView(
                  children: List<Widget>.generate(
                      categories.length, (int index) {
                    print(categories[0]);
                    return new Text("again some random text");
                  }),
                )
            ))
    );
  }
}