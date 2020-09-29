import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/module/admin/admin_bloc.dart';
import 'package:wine_app/module/admin/admin_detail_revenue_page.dart';
import 'package:wine_app/shared/model/revenue.dart';
import 'package:wine_app/shared/widget/xoayxoay.dart';

class AdminRevenuePage extends StatelessWidget {
  AdminBloc bloc;

  AdminRevenuePage({this.bloc});

  @override
  Widget build(BuildContext context) {
    return AdminRevenueWidget(bloc: bloc);
  }
}

class AdminRevenueWidget extends StatefulWidget {
  AdminBloc bloc;

  AdminRevenueWidget({this.bloc});

  @override
  _AdminRevenueWidgetState createState() => _AdminRevenueWidgetState();
}

class _AdminRevenueWidgetState extends State<AdminRevenueWidget> {
  List<String> months;
  String _selectedMonth;
  List<DropdownMenuItem<String>> _dropdownMenuItems;

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List<String> months) {
    List<DropdownMenuItem<String>> items = List();
    for (String i in months) {
      items.add(DropdownMenuItem(
        value: i,
        child: Text(
          i,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ));
    }
    return items;
  }

  @override
  void initState() {
    // TODO: implement initState
    months = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
    _dropdownMenuItems = buildDropdownMenuItems(months);
    _selectedMonth = _dropdownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Doanh thu'),
          actions: <Widget>[
            Center(child: Text('Tháng')),
            Center(
                child: SizedBox(
              width: 10,
            )),
            DropdownButton(
              items: _dropdownMenuItems,
              value: _selectedMonth,
              onChanged: (value) {
                setState(() {
                  _selectedMonth = value;
                });
              },
            ),
          ],
        ),
        body: _body());
  }

  _body() {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: StreamProvider<List<Revenue>>.value(
        value: widget.bloc.getRevenueList('${_selectedMonth}'),
        initialData: null,
        child: Consumer<List<Revenue>>(
          builder: (context, list, child) {
            if (list == null) {
              return Center(child: ColorLoader());
            }
            double netTotal = 0;
            double total = 0;
            double discount = 0;
            for(var i in list){
              netTotal += i.netTotal;
              total += i.total;
              discount +=i.discount;
            }
            return ListView(
              children: <Widget>[
                Text('Tổng lợi nhuận: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                  symbol: 'vnđ',
                  fractionDigits: 0,
                ), amount: double.parse(total.toString())).output.symbolOnRight}'),

                Text('Tổng giảm giá: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                  symbol: 'vnđ',
                  fractionDigits: 0,
                ), amount: double.parse(discount.toString())).output.symbolOnRight}'),

                Text('Tổng lợi nhuận thực: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                  symbol: 'vnđ',
                  fractionDigits: 0,
                ), amount: double.parse(netTotal.toString())).output.symbolOnRight}'),
                Container(
                  height: size.height,
                  child: ListView.builder(
                      reverse: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) => _buildItemList(list[index])),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemList(Revenue revenue) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailRevenuePage(revenue: revenue,),
            ));
      },
      title: Text(
        '${revenue.phone}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
              symbol: 'vnđ',
              fractionDigits: 0,
            ), amount: double.parse(revenue.netTotal.toString())).output.symbolOnRight}',
      ),
      trailing: Text(
        '${revenue.date}',
      ),
    );
  }
}
