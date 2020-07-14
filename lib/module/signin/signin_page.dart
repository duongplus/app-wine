import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wine_app/base/base_widget.dart';
import 'package:wine_app/data/remote/user_service.dart';
import 'package:wine_app/data/repo/user_repo.dart';
import 'package:wine_app/event/signin/signin_event.dart';
import 'package:wine_app/module/signin/signin_bloc.dart';
import 'package:wine_app/shared/app_color.dart';
import 'package:wine_app/shared/widget/normal_button.dart';

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
  Widget build(BuildContext context) {
    return Provider<SignInBloc>.value(
      value: SignInBloc(userRepo: Provider.of(context)),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, child) => Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              StreamProvider<String>.value(
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
                  ),
                ),
              ),
              StreamProvider.value(
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
                  ),
                ),
              ),
              StreamProvider.value(
                value: bloc.btnStream,
                initialData: false,
                child: Consumer<bool>(
                  builder: (context, enable, child) => NormalButton(
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
            ],
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
      String errText) {
    return TextFormField(
      controller: controller,
      onChanged: onChange,
      cursorColor: Colors.black,
      obscureText: isPass,
      keyboardType: inputType,
      decoration: InputDecoration(
          hintText: hint, labelText: label, icon: icon, errorText: errText),
    );
  }
}
