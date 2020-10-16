import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:random_color/random_color.dart';
import 'package:wine_app/shared/constants.dart';
import 'package:wine_app/shared/model/revenue.dart';
import 'package:wine_app/shared/model/wine.dart';

class DetailRevenuePage extends StatelessWidget {
  Revenue revenue;

  DetailRevenuePage({this.revenue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết hóa đơn'),
      ),
      body: DetailRevenueWidget(
        revenue: revenue,
      ),
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
        _buildListTile(
            'Tổng tiền: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                  symbol: 'vnđ',
                  fractionDigits: 0,
                ), amount: double.parse(widget.revenue.total.toString())).output.symbolOnRight}'),
        _buildListTile(
            'Phần trăm giảm giá: ${widget.revenue.percentDiscount}%'),
        _buildListTile(
            'Giảm giá: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                  symbol: 'vnđ',
                  fractionDigits: 0,
                ), amount: double.parse(widget.revenue.discount.toString())).output.symbolOnRight}'),
        _buildListTile(
            'Tổng tiền thực: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                  symbol: 'vnđ',
                  fractionDigits: 0,
                ), amount: double.parse(widget.revenue.netTotal.toString())).output.symbolOnRight}'),
        _buildListTile('Ngày: ${widget.revenue.date}'),
        Container(
          height: 1,
          color: Colors.grey,
        ),
        Center(
          child: Text('Sản phẩm'),
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
        Container(
          height: 300,
          // color: Colors.grey,
          child: ListView.separated(
              separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: Colors.grey,
                  ),
              itemCount: widget.revenue.wines.length,
              itemBuilder: (context, index) {
                return _buildWineTiles(widget.revenue.wines[index].wine,
                    widget.revenue.wines[index].amount);
              }),
        )
      ],
    );
  }

  Widget _buildWineTiles(Wine wine, int amount) {
    return ListTile(
      title:
          Text(wine.name, style: TextStyle(fontSize: 16, color: Colors.black)),
      subtitle: Text('${wine.producer} - ${wine.country}',
          style: TextStyle(fontSize: 14, color: Colors.grey)),
      leading: Image.network(
        wine.thumbnail,
        height: 70,
        width: 70,
        fit: BoxFit.fitHeight,
      ),
      trailing: Text('x${amount.toString()}',
          style: TextStyle(
              fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey)),
    );
  }

  Widget _buildListTile(String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
