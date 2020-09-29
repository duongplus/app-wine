import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:wine_app/shared/model/revenue.dart';

class DetailRevenuePage extends StatelessWidget {
  Revenue revenue;
  DetailRevenuePage({this.revenue});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết hóa đơn'),
      ),
      body: DetailRevenueWidget(revenue: revenue,),
    );
  }
}

class DetailRevenueWidget extends StatefulWidget {
  Revenue revenue;
  DetailRevenueWidget({this.revenue});
  @override
  _DetailRevenueWidgetState createState() => _DetailRevenueWidgetState();
}

class _DetailRevenueWidgetState extends State<DetailRevenueWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildListTile('Số điện thoại: ${widget.revenue.phone}'),
        _buildListTile('Tổng tiền: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
          symbol: 'vnđ',
          fractionDigits: 0,
        ), amount: double.parse(widget.revenue.total.toString())).output.symbolOnRight}'),
        _buildListTile('Phần trăm giảm giá: ${widget.revenue.percentDiscount}%'),
        _buildListTile('Giảm giá: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
          symbol: 'vnđ',
          fractionDigits: 0,
        ), amount: double.parse(widget.revenue.discount.toString())).output.symbolOnRight}'),
        _buildListTile('Tổng tiền thực: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
          symbol: 'vnđ',
          fractionDigits: 0,
        ), amount: double.parse(widget.revenue.netTotal.toString())).output.symbolOnRight}'),
        _buildListTile('Ngày: ${widget.revenue.date}'),
      ],
    );
  }

  Widget _buildListTile(String title){
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 16),),
    );
  }
}
