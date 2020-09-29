import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/data/remote/user_service.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/event/profile/profile_change_pass_event.dart';
import 'package:wine_app/module/profile/profile_bloc.dart';

class ChangePassPage extends StatelessWidget {
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
      child: ChangePassWidget(),
    );
  }
}

class ChangePassWidget extends StatefulWidget {
  @override
  _ChangePassWidgetState createState() => _ChangePassWidgetState();
}

class _ChangePassWidgetState extends State<ChangePassWidget> {
  bool showPassword = true;
  TextEditingController passController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController newPassCompareController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Provider<ProfileBloc>.value(
      value: ProfileBloc(userRepo: Provider.of(context)),
      child: Consumer<ProfileBloc>(
        builder: (context, bloc, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightGreenAccent,
          ),
          body: StreamProvider<int>.value(
            initialData: 0,
            value: bloc.changeStatusStream,
            child: Consumer<int>(
              builder: (context, status, child) {
                if(status == 200) {
                  showMessage("Đổi mật khẩu thành công!", Colors.green);
                  passController.text = "";
                  newPassController.text = "";
                  newPassCompareController.text = "";
                  bloc.changeStatusSink.add(0);
                }
                if(status == 401){
                  showMessage('Mật khẩu không chính xác.', Colors.red);
                  passController.text = "";
                  newPassController.text = "";
                  newPassCompareController.text = "";
                  bloc.changeStatusSink.add(0);
                }

                return Container(
                  padding: EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView(
                      children: <Widget>[
                        StreamProvider<String>.value(
                          value: bloc.passStream,
                          child: Consumer<String>(
                            builder: (context, msg, child) =>
                                StreamProvider<bool>.value(
                                    value: bloc.showPassStream,
                                    initialData: showPassword,
                                    child: Consumer<bool>(
                                        builder: (context, isShow, child) =>
                                            buildTextField(
                                                "Mật khẩu", "", passController,
                                                (pass) {
                                              bloc.passSink.add(pass);
                                            }, msg, true, true, bloc))),
                          ),
                        ),
                        StreamProvider<String>.value(
                          initialData: null,
                          value: bloc.newPassStream,
                          child: Consumer<String>(
                            builder: (context, msg, child) =>
                                StreamProvider<bool>.value(
                                    value: bloc.showPassStream,
                                    initialData: showPassword,
                                    child: Consumer<bool>(
                                        builder: (context, isShow, child) =>
                                            buildTextField("Mật khẩu mới", "",
                                                newPassController, (newPass) {
                                              bloc.newPassSink.add(newPass);
                                            }, msg, true, true, bloc))),
                          ),
                        ),
                        StreamProvider<String>.value(
                          initialData: null,
                          value: bloc.newPassCompareStream,
                          child: Consumer<String>(
                            builder: (context, msg, child) =>
                                StreamProvider<bool>.value(
                                    value: bloc.showPassStream,
                                    initialData: showPassword,
                                    child: Consumer<bool>(
                                        builder: (context, isShow, child) =>
                                            buildTextField(
                                                "Xác nhận mật khẩu mới",
                                                "",
                                                newPassCompareController,
                                                (newPassCompare) {
                                              bloc.newPassCompareSink
                                                  .add(newPassCompare);
                                            }, msg, true, true, bloc))),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        StreamProvider<bool>.value(
                          initialData: false,
                          value: bloc.btnPassStream,
                          child: Consumer<bool>(
                            builder: (context, enable, child) => RaisedButton(
                              onPressed: enable
                                  ? () {
                                      String pass = passController.text;
                                      String newPass = newPassController.text;
                                      String newPassCompare =
                                          newPassCompareController.text;
                                      if (newPass == newPassCompare) {
                                        bloc.event.add(ChangePassEvent(
                                            password: pass, newPass: newPass));
                                        bloc.btnPassSink.add(false);
                                      }else{
                                        showMessage("Mật khẩu nhập lại không khớp", Colors.yellow);
                                      }
                                    }
                                  : null,
                              color: Colors.lightGreenAccent,
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
                            ),
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
      Function onChange,
      String errText,
      bool enable,
      bool isPasswordTextField,
      ProfileBloc bloc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        onChanged: onChange,
        obscureText: isPasswordTextField ? showPassword : false,
        enabled: enable,
        controller: controller,
        decoration: InputDecoration(
            errorText: errText,
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
