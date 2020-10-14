import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/event/admin/admin_password_recovery.dart';
import 'package:wine_app/module/admin/admin_bloc.dart';
import 'package:wine_app/shared/model/user_data.dart';

class DetailUserPage extends StatelessWidget {
  UserData userData;

  DetailUserPage({this.userData});

  @override
  Widget build(BuildContext context) {
    return DetailUserWidget(userData: userData);
  }
}

class DetailUserWidget extends StatefulWidget {
  UserData userData;
  AdminBloc bloc;

  DetailUserWidget({this.userData, this.bloc});

  @override
  _DetailUserWidgetState createState() => _DetailUserWidgetState();
}

class _DetailUserWidgetState extends State<DetailUserWidget> {
  @override
  Widget build(BuildContext context) {
    String urlRank;
    if (double.parse(widget.userData.point) >= 1000) {
      urlRank =
          'https://raw.githubusercontent.com/duongplus/wine-images/master/Diamond.png';
    } else if (double.parse(widget.userData.point) >= 500) {
      urlRank =
          'https://raw.githubusercontent.com/duongplus/wine-images/master/GOLD.png';
    } else if (double.parse(widget.userData.point) >= 250) {
      urlRank =
          'https://raw.githubusercontent.com/duongplus/wine-images/master/Silver.png';
    } else {
      urlRank =
          'https://raw.githubusercontent.com/duongplus/wine-images/master/BRONZE.png';
    }

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

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: StreamProvider<int>.value(
          value: widget.bloc.statusStream,
          initialData: 0,
          child: Consumer<int>(
            builder: (context, status, child) {
              if (status == 200) {
                showMessage('Khôi phục mật khẩu thành công.', Colors.green);
                widget.bloc.statusSink.add(0);
              } else if (status >= 400) {
                showMessage('Gặp vấn đề trong việc khôi phục', Colors.red);
                widget.bloc.statusSink.add(0);
              }
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    Text(
                      "Thông tin người dùng",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: widget.userData.avatar == null ||
                                        widget.userData.avatar == ""
                                    ? AssetImage('assets/img/user.png')
                                    : NetworkImage(
                                        "${widget.userData.avatar}",
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                ),
                                child: Image.network(
                                  urlRank,
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    buildTextField(
                      "Tên",
                      "${widget.userData.displayName}",
                    ),
                    buildTextField(
                      "Số điện thoại",
                      "${widget.userData.phone}",
                    ),
                    buildTextField(
                      "Điểm hội viên",
                      "${widget.userData.point}",
                    ),
                    buildTextField("Vị trí", "${widget.userData.role}"),
                    RaisedButton(
                      onPressed: () {
                        widget.bloc.event.add(AdminPasswordRecovery(
                            phone: widget.userData.phone));
                      },
                      color: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Khôi phục mật khẩu".toUpperCase(),
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String labelText,
    String placeholder,
  ) {
    TextEditingController c = TextEditingController();
    c.text = placeholder;
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
          controller: c,
          readOnly: true,
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
