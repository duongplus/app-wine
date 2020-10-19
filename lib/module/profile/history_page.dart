import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/module/profile/profile_bloc.dart';
import 'package:wine_app/shared/constants.dart';
import 'package:wine_app/shared/model/revenue.dart';
import 'package:wine_app/shared/widget/xoayxoay.dart';

class HistoryPage extends StatefulWidget {
  final ProfileBloc bloc;

  HistoryPage({this.bloc});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        title: Text('Lịch sử giao dịch'.toUpperCase()),
      ),
      body: StreamProvider<List<Revenue>>.value(
        value: widget.bloc.getStreamHistories(),
        initialData: null,
        child: Consumer<List<Revenue>>(
          builder: (context, list, child) {
            if (list == null) {
              return Center(
                child: Image(
                  image: AssetImage('assets/img/wine_success.gif'),
                  height: 80,
                  width: 80,
                ),
              );
            }
            return Container(
              child: ListView.separated(
                reverse: true,
                itemCount: list.length,
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) => _buildItemList(list[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemList(Revenue revenue) {
    double point = revenue.total / 100000;
    int amount = 0;
    for (var i = 0; i < revenue.wines.length; i++) {
      amount += revenue.wines[i].amount;
    }
    return ListTile(
      title: Text(
        '${revenue.date.toString()}',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      trailing: Text(
        'Điểm: ${point.toStringAsFixed(point.truncateToDouble() == point ? 0 : 2)}\nSố lượng: ${amount}',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      subtitle: Container(
        height: 60,
        width: 100,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: revenue.wines.length,
          itemBuilder: (context, index) => Row(
            children: [
              Image.network(
                '${revenue.wines[index].wine.thumbnail}',
                height: 50,
                width: 50,
                // fit: BoxFit.fitHeight,
              ),
              Text(
                'x${revenue.wines[index].amount}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          // separatorBuilder: (context, index) => Container(
          //   width: 1,
          //   color: Colors.grey,
          // ),
        ),
      ),
    );
  }
}
