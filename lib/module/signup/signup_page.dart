import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/base/base_widget.dart';
import 'package:wine_app/data/remote/user_service.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/event/signup/signup_event.dart';
import 'package:wine_app/module/signup/signup_bloc.dart';
import 'package:wine_app/shared/app_color.dart';
import 'package:wine_app/shared/widget/normal_button.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Sign Up',
      actions: <Widget>[],
      di: [
        Provider.value(value: UserService()),
        ProxyProvider<UserService, UserRepo>(
          builder: (context, userService, previous) => UserRepo(
            userService: userService,
          ),
        )
      ],
      child: SignUpFormWidget(),
    );
  }
}

class SignUpFormWidget extends StatefulWidget {
  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final TextEditingController _txtDisplayNameController =
      TextEditingController();
  final TextEditingController _txtPhoneController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Provider<SignUpBloc>.value(
      value: SignUpBloc(userRepo: Provider.of(context)),
      child: Consumer<SignUpBloc>(
        builder: (context, bloc, child) => SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTeddy(bloc),
                _buildDisplayNameField(bloc),
                _buildPhoneField(bloc),
                _buildPasswordField(bloc),
                _buildButton(bloc),
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
      Function onTap) {
    return TextFormField(
      controller: controller,
      onChanged: onChange,
      cursorColor: Colors.black,
      obscureText: isPass,
      keyboardType: inputType,
      decoration: InputDecoration(
          hintText: hint, labelText: label, icon: icon, errorText: errText),
      onTap: onTap,
    );
  }

  _buildTeddy(SignUpBloc bloc) {
    return StreamProvider.value(
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

  _buildDisplayNameField(SignUpBloc bloc) {
    return StreamProvider.value(
      value: bloc.displayNameStream,
      initialData: null,
      child: Consumer<String>(
        builder: (context, msg, child) => _buildField(
            "Display Name",
            "Nguyen Van A",
            Icon(
              Icons.account_box,
              color: AppColor.blue,
            ),
            TextInputType.text,
            false,
            _txtDisplayNameController,
            (displayName) {
              bloc.displayNameSink.add(displayName);
            },
            msg,
            () {
              bloc.teddySink.add('test');
            }),
      ),
    );
  }

  _buildPhoneField(SignUpBloc bloc) {
    return StreamProvider.value(
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
            }),
      ),
    );
  }

  _buildPasswordField(SignUpBloc bloc) {
    return StreamProvider.value(
      value: bloc.passStream,
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
            }),
      ),
    );
  }

  _buildButton(SignUpBloc bloc) {
    return StreamProvider.value(
      value: bloc.btnStream,
      initialData: false,
      child: Consumer<bool>(
        builder: (context, enable, child) => Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 10),
          child: NormalButton(
            onPressed: enable
                ? () {
                    bloc.event.add(
                      SignUpEvent(
                        displayName: _txtDisplayNameController.text,
                        phone: _txtPhoneController.text,
                        pass: _txtPassController.text,
                      ),
                    );
                  }
                : null,
            title: 'Sign Up',
          ),
        ),
      ),
    );
  }
}
