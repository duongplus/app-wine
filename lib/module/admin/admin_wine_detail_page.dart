import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/data/repo/order_repo.dart';
import 'package:wine_app/data/repo/wine_repo.dart';
import 'package:wine_app/event/admin/admin_update_wine.dart';
import 'package:wine_app/event/home/add_to_cart_event.dart';
import 'package:wine_app/event/home/add_to_cart_success.dart';
import 'package:wine_app/module/admin/admin_bloc.dart';
import 'package:wine_app/module/home/home_bloc.dart';
import 'package:wine_app/shared/model/wine.dart';
import 'package:wine_app/shared/widget/bloc_listener.dart';
import 'package:wine_app/shared/widget/loading_task.dart';

class AdminWineDetailsScreen extends StatelessWidget {
  final Wine product;
  final AdminBloc bloc;

  const AdminWineDetailsScreen({Key key, this.product, this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: product.color,
      ),
      body: Body(
        product: product,
        bloc: bloc,
      ),
    );
  }
}

class Body extends StatelessWidget {
  final Wine product;
  final AdminBloc bloc;

  const Body({Key key, this.product, this.bloc}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    TextEditingController idController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController producerController = TextEditingController();
    TextEditingController countryController = TextEditingController();
    TextEditingController alcoholController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController thumbnailController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController cateIDController = TextEditingController();
    TextEditingController capacityController = TextEditingController();
    TextEditingController sizeController = TextEditingController();
    return Container(
      padding: EdgeInsets.only(left: 16, top: 25, right: 16),
      child: ListView(
        children: <Widget>[
          buildTextField("Mã số", product.id['\$oid'], true, idController),
          buildTextField("Tên rượu", product.name, false, nameController),
          buildTextField(
              "Tên nhà sản xuất", product.producer, false, producerController),
          buildTextField("Quốc gia", product.country, false, countryController),
          buildTextField("Nồng độ", product.alcohol, false, alcoholController),
          buildTextField(
              "Mô tả", product.description, false, descriptionController),
          buildTextField(
              "Hình ảnh", product.thumbnail, false, thumbnailController),
          buildTextField(
              "Giá", product.price.toString(), false, priceController),
          buildTextField("Thể tích", product.size, false, sizeController),
          buildTextField("Số lượng", product.capacity.toString(), false,
              capacityController),
          buildTextField(
              "Mã số loại", product.cateId.toString(), false, cateIDController),
          FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: product.color,
            onPressed: () {
              Wine wine = Wine(
                id: product.id,
                name: nameController.text,
                producer: producerController.text,
                country: producerController.text,
                alcohol: alcoholController.text,
                description: descriptionController.text,
                thumbnail: thumbnailController.text,
                price: double.parse(priceController.text),
                cateId: cateIDController.text,
                capacity: int.parse(capacityController.text),
                size: sizeController.text,
              );
              bloc.event.add(AdminUpdateWine(wine: wine));
            },
            child: Text(
              "Lưu thay đổi".toUpperCase(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool readOnly,
      TextEditingController c) {
    c.text = placeholder;
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: c,
          readOnly: readOnly,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3),
              labelText: labelText,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ))),
    );
  }
}
