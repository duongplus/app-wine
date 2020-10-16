import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/data/remote/user_service.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/data/spref/spref.dart';
import 'package:wine_app/event/profile/profile_change_name_event.dart';
import 'package:wine_app/event/profile/profile_change_pass_event.dart';
import 'package:wine_app/module/home/main_container_page.dart';
import 'package:wine_app/module/profile/change_pass_page.dart';
import 'package:wine_app/module/profile/history_page.dart';
import 'package:wine_app/module/profile/profile_bloc.dart';
import 'package:wine_app/shared/constant.dart';
import 'package:wine_app/shared/model/user_data.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(
          value: UserService(),
        ),
        ProxyProvider<UserService, UserRepo>(
          builder: (context, userService, previous) =>
              UserRepo(userService: userService),
        ),
      ],
      child: ProfileWidget(),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool showPassword = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pointController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = UserData.u.displayName;
    phoneController.text = UserData.u.phone;
    pointController.text = UserData.u.point;
    roleController.text = UserData.u.role;
    String urlRank;
    if (double.parse(UserData.u.point) >= 1000) {
      urlRank =
          'https://raw.githubusercontent.com/duongplus/wine-images/master/Diamond.png';
    } else if (double.parse(UserData.u.point) >= 500) {
      urlRank =
          'https://raw.githubusercontent.com/duongplus/wine-images/master/GOLD.png';
    } else if (double.parse(UserData.u.point) >= 250) {
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

    bool isLogOut = false;
    DateTime currentBackPressTime;
    Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        showMessage("Ấn thêm lần nữa để đăng xuất", Colors.lightGreenAccent);
        return Future.value(false);
      }
      return Future.value(true);
    }

    return Provider<ProfileBloc>.value(
      value: ProfileBloc(userRepo: Provider.of(context)),
      child: Consumer<ProfileBloc>(
        builder: (context, bloc, child) => Scaffold(
          backgroundColor: Colors.white,
          body: StreamProvider<int>.value(
            initialData: 0,
            value: bloc.changeStatusStream,
            child: Consumer<int>(
              builder: (context, status, child) {
                if (status == 200) {
                  showMessage("Thay đổi thành công!", Colors.green);
                  bloc.changeStatusSink.add(0);
                }
                if (status == 404) {
                  showMessage("Gặp sự cố trong việc thay đổi. Mời bạn thử lại.",
                      Colors.red);
                  bloc.changeStatusSink.add(0);
                }
                return Container(
                  padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text(
                            "Thông tin người dùng",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              onWillPop().then((isOut) {
                                isLogOut = isOut;
                              });
                              if (isLogOut == true) {
                                await SPref.instance
                                    .set(SPrefCache.KEY_TOKEN, null);
                                HomeContainerPage.pagecontroller.jumpToPage(0);
                                Navigator.pushReplacementNamed(
                                    context, '/sign-in');
                              }
                            },
                            icon: Icon(Icons.exit_to_app),
                          ),
                          leading: UserData.u.role == 'ADMIN'
                              ? IconButton(
                                  onPressed: () async {
                                    HomeContainerPage.pagecontroller
                                        .jumpToPage(0);
                                    Navigator.pushReplacementNamed(
                                        context, '/switch');
                                  },
                                  icon: Icon(Icons.swap_horiz),
                                )
                              : null,
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
                                    // image: NetworkImage(
                                    //   UserData.u.avatar == null ||
                                    //           UserData.u.avatar == ""
                                    //       ? "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250"
                                    //       : "${UserData.u.avatar}",
                                    // ),
                                    image: UserData.u.avatar == null ||
                                            UserData.u.avatar == ""
                                        ? AssetImage('assets/img/user.png')
                                        : NetworkImage(
                                            "${UserData.u.avatar}",
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
                                      // fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        StreamProvider<String>.value(
                          initialData: null,
                          value: bloc.displayNameStream,
                          child: Consumer<String>(
                            builder: (context, msg, child) => buildTextField(
                                "Tên",
                                "${UserData.u.displayName}",
                                nameController, (name) {
                              bloc.displayNameSink.add(name);
                              bloc.btnSaveSink.add(name.toString().length > 3);
                              print(name);
                            }, msg, false, false, bloc),
                          ),
                        ),
//              StreamProvider<bool>.value(
//                  value: profileBloc.passStream,
//                  initialData: showPassword,
//                  child: Consumer<bool>(
//                      builder: (context, isShow, child) => buildTextField(
//                          "Mật khẩu",
//                          "",
//                          passController,
//                          true,
//                          true,
//                          profileBloc))),
//              StreamProvider<bool>.value(
//                  value: profileBloc.passStream,
//                  initialData: showPassword,
//                  child: Consumer<bool>(
//                    builder: (context, isShow, child) => buildTextField(
//                        "Mật khẩu mới",
//                        "",
//                        newPassController,
//                        true,
//                        true,
//                        profileBloc),
//                  )),
                        buildTextField(
                            "Số điện thoại",
                            "${UserData.u.phone}",
                            phoneController,
                            (phone) {},
                            null,
                            true,
                            false,
                            bloc),
                        Stack(
                          children: [
                            buildTextField(
                                "Điểm hội viên",
                                "${UserData.u.point}",
                                pointController,
                                (point) {},
                                null,
                                true,
                                false,
                                bloc),
                            Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.event),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HistoryPage(
                                                  bloc: bloc,
                                                )));
                                  },
                                ))
                          ],
                        ),
                        buildTextField("Vị trí", "${UserData.u.role}",
                            roleController, (role) {}, null, true, false, bloc),
                        SizedBox(
                          height: 35,
                        ),
                        OutlineButton(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangePassPage()));
                          },
                          child: Text("Đổi mật khẩu".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black)),
                        ),
                        StreamProvider<bool>.value(
                          initialData: false,
                          value: bloc.btnSaveStream,
                          child: Consumer<bool>(
                            builder: (context, enable, child) {
                              print(enable);
                              return RaisedButton(
                                onPressed: enable
                                    ? () {
                                        bloc.event.add(ChangeNameEvent(
                                            name: nameController.text));
                                        HomeContainerPage.pagecontroller
                                            .jumpToPage(0);
                                        HomeContainerPage.pagecontroller
                                            .jumpToPage(2);
                                      }
                                    : null,
                                color: Colors.green,
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "Lưu thay đổi".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText,
      String placeholder,
      TextEditingController controller,
      Function onChanged,
      String msgErr,
      bool enable,
      bool isPasswordTextField,
      ProfileBloc bloc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
//        enabled: enable,
        readOnly: enable,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
            errorText: msgErr,
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      showPassword = !showPassword;
                      bloc.showPassSink.add(showPassword);
//                      setState(() {
//                        showPassword = !showPassword;
//                      });
                    },
                    icon: showPassword
                        ? Icon(
                            Icons.remove_red_eye,
                            color: Colors.grey,
                          )
                        : Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
