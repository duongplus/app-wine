import 'package:flutter/material.dart';
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

  DetailUserWidget({this.userData});

  @override
  _DetailUserWidgetState createState() => _DetailUserWidgetState();
}

class _DetailUserWidgetState extends State<DetailUserWidget> {


  @override
  Widget build(BuildContext context) {
    Color colorRank;
    if (double.parse(widget.userData.point) >= 1000) {
      colorRank = Colors.cyanAccent;
    } else if (double.parse(widget.userData.point) >= 500) {
      colorRank = Colors.yellow;
    } else if (double.parse(widget.userData.point) >= 250) {
      colorRank = Colors.grey[300];
    } else {
      colorRank = Colors.brown[400];
    }
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
             Text(
                  "Thông tin người dùng",
                  style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500),
                ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
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
                              image: NetworkImage(
                                widget.userData.avatar == null ||
                                    widget.userData.avatar == ""
                                    ? "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250"
                                    : "${widget.userData.avatar}",
                              ))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor,
                            ),
                            color: colorRank,
                          ),
                          child: Icon(
                            Icons.credit_card,
                            color: Colors.white,
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
            "${widget.userData.displayName}",),
              buildTextField(
                  "Số điện thoại",
                  "${widget.userData.phone}",),
              buildTextField(
                  "Điểm hội viên",
                  "${widget.userData.point}",),
              buildTextField("Vị trí", "${widget.userData.role}"),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText,
      String placeholder,) {
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
            ))
        ),
    );
  }
}

