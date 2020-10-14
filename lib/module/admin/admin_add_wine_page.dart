import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/data/repo/order_repo.dart';
import 'package:wine_app/data/repo/wine_repo.dart';
import 'package:wine_app/event/admin/admin_add_wine.dart';
import 'package:wine_app/event/admin/admin_update_wine.dart';
import 'package:wine_app/event/home/add_to_cart_event.dart';
import 'package:wine_app/event/home/add_to_cart_success.dart';
import 'package:wine_app/module/admin/admin_bloc.dart';
import 'package:wine_app/module/home/home_bloc.dart';
import 'package:wine_app/shared/model/cate.dart';
import 'package:wine_app/shared/model/wine.dart';
import 'package:wine_app/shared/widget/bloc_listener.dart';
import 'package:wine_app/shared/widget/loading_task.dart';

class AdminAddWineScreen extends StatelessWidget {
  final AdminBloc bloc;

  const AdminAddWineScreen({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Thêm rượu'),
      ),
      body: Body(
        bloc: bloc,
      ),
    );
  }
}

class Body extends StatefulWidget {
  AdminBloc bloc;

  Body({Key key, this.bloc}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<DropdownMenuItem<Cate>> _dropdownMenuItems;
  Cate _selectedCate;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItem(Cate.cates);
    _selectedCate = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Cate>> buildDropdownMenuItem(List<Cate> cates) {
    List<DropdownMenuItem<Cate>> items = List();
    for (Cate i in cates) {
      items.add(DropdownMenuItem(
        value: i,
        child: Text(i.cateName),
      ));
    }
    return items;
  }

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

  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;

    showMessage(status, color) {
      Fluttertoast.showToast(
          msg: status.toString(),
          timeInSecForIosWeb: 10,
          webShowClose: true,
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          backgroundColor: color,
          gravity: ToastGravity.BOTTOM);
    }

    return StreamProvider<int>.value(
      value: widget.bloc.statusStream,
      initialData: 0,
      child: Consumer<int>(
        builder: (context, status, child) {
          if(status == 200){
            showMessage('Thêm rượu thành công!', Colors.lightGreenAccent);
            nameController.text = '';
            producerController.text = '';
            countryController.text = '';
            alcoholController.text = '';
            descriptionController.text = '';
            thumbnailController.text = '';
            priceController.text = '';
            capacityController.text = '';
            sizeController.text = '';
            widget.bloc.statusSink.add(0);
          } else if (status >= 400){
            showMessage('Gặp sự cố trong quá trình thêm rượu!', Colors.red);
            widget.bloc.statusSink.add(0);
            nameController.text = '';
            producerController.text = '';
            countryController.text = '';
            alcoholController.text = '';
            descriptionController.text = '';
            thumbnailController.text = '';
            priceController.text = '';
            capacityController.text = '';
            sizeController.text = '';
          }
          return Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: ListView(
              children: <Widget>[
                buildTextField("Tên rượu", "Rượu abc", false, nameController,
                    TextInputType.multiline),
                buildTextField("Tên nhà sản xuất", "Vidu", false, producerController,
                    TextInputType.multiline),
                buildTextField("Quốc gia", "Vidu", false, countryController,
                    TextInputType.multiline),
                buildTextField("Nồng độ", "xx.x%", false, alcoholController,
                    TextInputType.number),
                buildTextField("Mô tả", "...", false, descriptionController,
                    TextInputType.multiline),
                buildTextField("Hình ảnh", "www.duongdang.wine/img.png", false,
                    thumbnailController, TextInputType.multiline),
                buildTextField("Giá", "xxx.xxx.xxx", false, priceController,
                    TextInputType.number),
                buildTextField("Thể tích", "xxx ml", false, sizeController,
                    TextInputType.number),
                buildTextField("Số lượng", "xx", false, capacityController,
                    TextInputType.multiline),
                // buildTextField(
                //     "Mã số loại", "1", false, cateIDController),
                Row(
                  children: <Widget>[
                    Text('Loại rượu: '),
                    SizedBox(width: 20,),
                    DropdownButton(
                      items: _dropdownMenuItems,
                      value: _selectedCate,
                      onChanged: (cate) {
                        setState(() {
                          _selectedCate = cate;
                        });
                      },
                    ),
                  ],
                ),
                FlatButton(
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    if(nameController.text!='' && priceController.text != '' && alcoholController.text != ''){
                      Wine wine = Wine(
                        name: nameController.text,
                        producer: producerController.text,
                        country: producerController.text,
                        alcohol: alcoholController.text + "%",
                        description: descriptionController.text,
                        thumbnail: thumbnailController.text,
                        price: double.parse(priceController.text),
                        cateId: _selectedCate.cateId,
                        capacity: int.parse(capacityController.text),
                        size: sizeController.text + "ml",
                      );
                      widget.bloc.event.add(AdminAddWine(wine: wine));
                      return;
                    }
                    showMessage('Không thể thêm rượu',Colors.red);
                  },
                  child: Text(
                    "Thêm rượu".toUpperCase(),
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
        },
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool readOnly,
      TextEditingController c, TextInputType t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
          keyboardType: t,
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
