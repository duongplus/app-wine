import 'package:flutter/material.dart';
import 'package:wine_app/shared/app_color.dart';
import 'package:provider/provider.dart';

class PageContainer extends StatelessWidget {
  final String title;
  final Widget child;

  final List<SingleChildCloneableWidget> di;
  final List<Widget> actions;

  PageContainer({this.title, this.di, this.actions, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        actions: actions,
      ),
      body: MultiProvider(
        providers: [
          ...di,
        ],
        child: child,
      ),
    );
  }
}

class NavigatorProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[],
      ),
    );
  }
}
