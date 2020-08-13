import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/base/base_widget.dart';
import 'package:wine_app/data/remote/user_service.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/event/signin/signin_event.dart';
import 'package:wine_app/module/signin/signin_bloc.dart';
import 'package:wine_app/shared/app_color.dart';
import 'package:wine_app/shared/widget/normal_button.dart';
import 'package:flare_flutter/flare_actor.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      di: [
        Provider.value(value: UserService()),
        ProxyProvider<UserService, UserRepo>(
          builder: (context, userService, previous) => UserRepo(
            userService: userService,
          ),
        ),
      ],
      actions: <Widget>[],
      title: 'Sign In',
      child: SignInFormWidget(),
    );
  }
}

class SignInFormWidget extends StatefulWidget {
  @override
  _SignInFormWidgetState createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  final TextEditingController _txtPhoneController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();

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
    return Provider<SignInBloc>.value(
      value: SignInBloc(userRepo: Provider.of(context)),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, child) => Container(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTeddy(bloc),
                _buildPhoneField(bloc),
                _buildPasswordField(bloc),
                _buildButton(bloc),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    String hint,
    Icon icon,
    TextInputType inputType,
    bool isPass,
    TextEditingController controller,
    Function onChange,
    String errText,
    Function onTap,
  ) {
    return TextFormField(
      controller: controller,
      onChanged: onChange,
      onTap: onTap,
      cursorColor: Colors.black,
      obscureText: isPass,
      keyboardType: inputType,
      decoration: InputDecoration(
          hintText: hint, labelText: label, icon: icon, errorText: errText),
    );
  }

  _buildTeddy(SignInBloc bloc) {
    return StreamProvider<String>.value(
      value: bloc.teddyStream,
      initialData: 'idle',
      child: Consumer<String>(
        builder: (context, type, child) => Center(
          child: GestureDetector(
            onTap: () {
              bloc.teddySink.add('hands_down');
            },
            child: Container(
              height: 200,
              width: 300,
              child: FlareActor(
                "assets/teddy_test.flr",
                alignment: Alignment.center,
                fit: BoxFit.cover,
                animation: type,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.all(10),
      child: FlatButton(
        onPressed: () {
          Navigator.pushNamed(context, '/sign-up');
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(4),
        ),
        child: Text(
          'Đăng ký tài khoản',
          style: TextStyle(
            color: AppColor.blue,
            fontSize: 19,
          ),
        ),
      ),
    );
  }

  _buildPhoneField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.phoneStream,
      child: Consumer<String>(
        builder: (context, msg, child) => _buildField(
          'Phone',
          '(+84) 933 505 575',
          Icon(
            Icons.phone,
            color: AppColor.blue,
          ),
          TextInputType.phone,
          false,
          _txtPhoneController,
          (phone) {
            bloc.phoneSink.add(phone);
          },
          msg,
          () {
            bloc.teddySink.add('test');
          },
        ),
      ),
    );
  }

  _buildPasswordField(SignInBloc bloc) {
    return StreamProvider.value(
      value: bloc.passStream,
      initialData: null,
      child: Consumer<String>(
        builder: (context, msg, child) => _buildField(
          'Password',
          '',
          Icon(
            Icons.lock,
            color: AppColor.blue,
          ),
          TextInputType.visiblePassword,
          true,
          _txtPassController,
          (pass) {
            bloc.passSink.add(pass);
          },
          msg,
          () {
            bloc.teddySink.add('hands_up');
          },
        ),
      ),
    );
  }

  _buildButton(SignInBloc bloc) {
    return StreamProvider.value(
      value: bloc.btnStream,
      initialData: false,
      child: Consumer<bool>(
        builder: (context, enable, child) => Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(10),
          child: NormalButton(
            onPressed: enable
                ? () {
                    bloc.event.add(
                      SignInEvent(
                        phone: _txtPhoneController.text,
                        pass: _txtPassController.text,
                      ),
                    );
                  }
                : null,
            title: 'Sign In',
          ),
        ),
      ),
    );
  }
}
